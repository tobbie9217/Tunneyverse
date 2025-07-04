import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class CleanedRecording extends StatefulWidget {
  const CleanedRecording({super.key});

  @override
  State<CleanedRecording> createState() => _CleanedRecordingState();
}

class _CleanedRecordingState extends State<CleanedRecording> {
  late AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _player.setAsset('assets/audio/cleaned.mp3');
    _duration = _player.duration ?? Duration.zero;

    _positionSub = _player.positionStream.listen((pos) {
      setState(() => _position = pos);
    });
    _playerStateSub = _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 661,
      height: 200,
      decoration: ShapeDecoration(
        color: const Color(0xFFD1CCF0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Header Row: Play/Pause + Title + Time
          Positioned(
            left: 20,
            top: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Play/Pause Button
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: const Color(0xFF1B191C),
                      size: 40,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Title
                const SizedBox(
                  width: 231.58,
                  height: 32,
                  child: Text(
                    'Cleaned recording',
                    style: TextStyle(
                      color: Color(0xFF1B191C),
                      fontSize: 28,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Time label (current/total)
                Text(
                  '${_formatTime(_position)} / ${_formatTime(_duration)}',
                  style: const TextStyle(
                    color: Color(0xFF1B191C),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.42,
                    letterSpacing: -0.30,
                  ),
                ),
              ],
            ),
          ),
          // Waveform Bars (static, as before)
          Positioned(
            left: 20,
            top: 59,
            child: Container(
              width: 625,
              height: 102,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: Stack(
                children: [
                  _buildBar(left: 5, top: 65, width: 24),
                  _buildBar(left: 10, top: 76.07, width: 50.14),
                  _buildBar(left: 15, top: 69.56, width: 37.12),
                  _buildBar(left: 20, top: 66.15, width: 30.30),
                  _buildBar(left: 25, top: 75.71, width: 49.42),
                  _buildBar(left: 30, top: 72.97, width: 43.95),
                  _buildBar(left: 35, top: 75.36, width: 48.71),
                  _buildBar(left: 40, top: 76.41, width: 50.81),
                  _buildBar(left: 45, top: 63.88, width: 25.76),
                  _buildBar(left: 50, top: 69.20, width: 36.39),
                  _buildBar(left: 55, top: 64.11, width: 26.22),
                  // Add more bars as needed...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for waveform bars
  static Widget _buildBar({
    required double left,
    required double top,
    required double width,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: -1.57, // -90 degrees in radians
        child: Container(
          width: width,
          height: 0,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 3,
                color: const Color(0xFF1B191C), // Use dark color for bars
              ),
            ),
          ),
        ),
      ),
    );
  }
}
