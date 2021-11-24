Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A3845C078
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245185AbhKXNJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244614AbhKXNGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C049661391;
        Wed, 24 Nov 2021 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757489;
        bh=Na+VFDNc23vBqqieaWxvkvKx/dmnYxyU420PrkxYGvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geIB7wUdo4bBfZAgA/04dZACNe5W3/TLSWAMWBJCZ6kzpHk99DQ6s1vR6uF/WoPF7
         CN47MUdLDfeo23fwt8ddTY4x1zvAPMm5UfPJbOB87Mh3nV8QVmQZM52uAFISwxBMAR
         ZY8AQcmtbwUhdueHseJHH3O5VbIg3CnYRyQPFH2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/323] ALSA: hda: Reduce udelay() at SKL+ position reporting
Date:   Wed, 24 Nov 2021 12:56:14 +0100
Message-Id: <20211124115725.155609311@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 46243b85b0ec5d2cee7545e5ce18c015ce91957e ]

The position reporting on Intel Skylake and later chips via
azx_get_pos_skl() contains a udelay(20) call for the capture streams.
A call for this alone doesn't sound too harmful.  However, as the
pointer PCM ops is one of the hottest path in the PCM operations --
especially for the timer-scheduled operations like PulseAudio -- such
a delay hogs CPU usage significantly in the total performance.

The code there was taken from the original code in ASoC SST Skylake
driver blindly.  The udelay() is a workaround for the case where the
reported position is behind the period boundary at the timing
triggered from interrupts; applications often expect that the full
data is available for the whole period when returned (and also that's
the definition of the ALSA PCM period).

OTOH, HD-audio (legacy) driver has already some workarounds for the
delayed position reporting due to its relatively large FIFO, such as
the BDL position adjustment and the delayed period-elapsed call in the
work.  That said, the udelay() is almost superfluous for HD-audio
driver unlike SST, and we can drop the udelay().

Though, the current code doesn't guarantee the full period readiness
as mentioned in the above, but rather it checks the wallclock and
detects the unexpected jump.  That's one missing piece, and the drop
of udelay() needs a bit more sanity checks for the delayed handling.

This patch implements those: the drop of udelay() call in
azx_get_pos_skl() and the more proper check of hwptr in
azx_position_ok().  The latter change is applied only for the case
where the stream is running in the normal mode without
no_period_wakeup flag.  When no_period_wakeup is set, it essentially
ignores the period handling and rather concentrates only on the
current position; which implies that we don't need to care about the
period boundary at all.

Fixes: f87e7f25893d ("ALSA: hda - Improved position reporting on SKL+")
Reported-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210929072934.6809-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 2cd8bfd5293b9..7d4b6c31dfe70 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -743,13 +743,17 @@ static int azx_intel_link_power(struct azx *chip, bool enable)
  * the update-IRQ timing.  The IRQ is issued before actually the
  * data is processed.  So, we need to process it afterwords in a
  * workqueue.
+ *
+ * Returns 1 if OK to proceed, 0 for delay handling, -1 for skipping update
  */
 static int azx_position_ok(struct azx *chip, struct azx_dev *azx_dev)
 {
 	struct snd_pcm_substream *substream = azx_dev->core.substream;
+	struct snd_pcm_runtime *runtime = substream->runtime;
 	int stream = substream->stream;
 	u32 wallclk;
 	unsigned int pos;
+	snd_pcm_uframes_t hwptr, target;
 
 	wallclk = azx_readl(chip, WALLCLK) - azx_dev->core.start_wallclk;
 	if (wallclk < (azx_dev->core.period_wallclk * 2) / 3)
@@ -786,6 +790,24 @@ static int azx_position_ok(struct azx *chip, struct azx_dev *azx_dev)
 		/* NG - it's below the first next period boundary */
 		return chip->bdl_pos_adj ? 0 : -1;
 	azx_dev->core.start_wallclk += wallclk;
+
+	if (azx_dev->core.no_period_wakeup)
+		return 1; /* OK, no need to check period boundary */
+
+	if (runtime->hw_ptr_base != runtime->hw_ptr_interrupt)
+		return 1; /* OK, already in hwptr updating process */
+
+	/* check whether the period gets really elapsed */
+	pos = bytes_to_frames(runtime, pos);
+	hwptr = runtime->hw_ptr_base + pos;
+	if (hwptr < runtime->status->hw_ptr)
+		hwptr += runtime->buffer_size;
+	target = runtime->hw_ptr_interrupt + runtime->period_size;
+	if (hwptr < target) {
+		/* too early wakeup, process it later */
+		return chip->bdl_pos_adj ? 0 : -1;
+	}
+
 	return 1; /* OK, it's fine */
 }
 
@@ -983,11 +1005,7 @@ static unsigned int azx_get_pos_skl(struct azx *chip, struct azx_dev *azx_dev)
 	if (azx_dev->core.substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		return azx_skl_get_dpib_pos(chip, azx_dev);
 
-	/* For capture, we need to read posbuf, but it requires a delay
-	 * for the possible boundary overlap; the read of DPIB fetches the
-	 * actual posbuf
-	 */
-	udelay(20);
+	/* read of DPIB fetches the actual posbuf */
 	azx_skl_get_dpib_pos(chip, azx_dev);
 	return azx_get_pos_posbuf(chip, azx_dev);
 }
-- 
2.33.0



