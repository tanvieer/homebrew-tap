class Trambar < Formula
  desc "Live tram, bus and train departures for Chemnitz / VMS in the macOS menu bar"
  homepage "https://github.com/tanvieer/trambar"
  url "https://github.com/tanvieer/trambar/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "17f164bd633f4adf56e9bd1b36e42a301f0d3fb193a2355d64b4ef521ae4cf6d"
  license "MIT"

  depends_on macos: :sonoma

  def install
    # Built here rather than downloaded, so the app has no quarantine flag and
    # opens without a Gatekeeper prompt even though it has no Developer ID.
    ENV["SWIFTPM_DISABLE_SANDBOX"] = "1"
    ENV["VERSION"] = version.to_s
    system "./build.sh"
    prefix.install "build/TramBar.app"
  end

  service do
    run [opt_prefix/"TramBar.app/Contents/MacOS/TramBar"]
    keep_alive successful_exit: false
    process_type :interactive
  end

  def caveats
    <<~EOS
      Start TramBar now and at every login:
        brew services start trambar

      Or put it in Applications to open it from Launchpad or Spotlight:
        ln -sf #{opt_prefix}/TramBar.app ~/Applications/TramBar.app
    EOS
  end

  test do
    assert_predicate prefix/"TramBar.app/Contents/MacOS/TramBar", :executable?
  end
end
