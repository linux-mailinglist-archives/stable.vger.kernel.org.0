Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71AD4993A6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386069AbiAXUfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53886 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356917AbiAXU3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:29:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D50061382;
        Mon, 24 Jan 2022 20:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F65C340E5;
        Mon, 24 Jan 2022 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056152;
        bh=rtpLZA/dEdKmmCJ55vX9tk3oGIr36nPawB5/HexGmQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vl3+Qg2oN6cbMRxZ4L3+Hgxv9vr32h36J6L8N4j0SdjJzBvkc8NCpuuKX8gx+4SUG
         7QsdGRr24YvcSIaM+aj4gsaJe6oQ3zycD60KhAOygHR8idM0Svj8hBorF8ZRL2xv+2
         UgBJ+/pqQi9Z8vbn6OJBTThB1AY4z3zjlTos7j2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/846] ALSA: hda: Make proper use of timecounter
Date:   Mon, 24 Jan 2022 19:38:25 +0100
Message-Id: <20220124184114.326151138@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 6dd21ad81bf96478db3403b1bbe251c0612d0431 ]

HDA uses a timecounter to read a hardware clock running at 24 MHz. The
conversion factor is set with a mult value of 125 and a shift value of 0,
which is not converting the hardware clock to nanoseconds, it is converting
to 1/3 nanoseconds because the conversion factor from 24Mhz to nanoseconds
is 125/3. The usage sites divide the "nanoseconds" value returned by
timecounter_read() by 3 to get a real nanoseconds value.

There is a lengthy comment in azx_timecounter_init() explaining this
choice. That comment makes blatantly wrong assumptions about how
timecounters work and what can overflow.

The comment says:

     * Applying the 1/3 factor as part of the multiplication
     * requires at least 20 bits for a decent precision, however
     * overflows occur after about 4 hours or less, not a option.

timecounters operate on time deltas between two readouts of a clock and use
the mult/shift pair to calculate a precise nanoseconds value:

    delta_nsec = (delta_clock * mult) >> shift;

The fractional part is also taken into account and preserved to prevent
accumulated rounding errors. For details see cyclecounter_cyc2ns().

The mult/shift pair has to be chosen so that the multiplication of the
maximum expected delta value does not result in a 64bit overflow. As the
counter wraps around on 32bit, the maximum observable delta between two
reads is (1 << 32) - 1 which is about 178.9 seconds.

That in turn means the maximum multiplication factor which fits into an u32
will not cause a 64bit overflow ever because it's guaranteed that:

     ((1 << 32) - 1) ^ 2 < (1 << 64)

The resulting correct multiplication factor is 2796202667 and the shift
value is 26, i.e. 26 bit precision. The overflow of the multiplication
would happen exactly at a clock readout delta of 6597069765 which is way
after the wrap around of the hardware clock at around 274.8 seconds which
is off from the claimed 4 hours by more than an order of magnitude.

If the counter ever wraps around the last read value then the calculation
is off by the number of wrap arounds times 178.9 seconds because the
overflow cannot be observed.

Use clocks_calc_mult_shift(), which calculates the most accurate mult/shift
pair based on the given clock frequency, and remove the bogus comment along
with the divisions at the readout sites.

Fixes: 5d890f591d15 ("ALSA: hda: support for wallclock timestamps")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/871r35kwji.ffs@tglx
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_stream.c           | 14 ++++----------
 sound/pci/hda/hda_controller.c    |  1 -
 sound/soc/intel/skylake/skl-pcm.c |  1 -
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index 9867555883c34..aa7955fdf68a0 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -534,17 +534,11 @@ static void azx_timecounter_init(struct hdac_stream *azx_dev,
 	cc->mask = CLOCKSOURCE_MASK(32);
 
 	/*
-	 * Converting from 24 MHz to ns means applying a 125/3 factor.
-	 * To avoid any saturation issues in intermediate operations,
-	 * the 125 factor is applied first. The division is applied
-	 * last after reading the timecounter value.
-	 * Applying the 1/3 factor as part of the multiplication
-	 * requires at least 20 bits for a decent precision, however
-	 * overflows occur after about 4 hours or less, not a option.
+	 * Calculate the optimal mult/shift values. The counter wraps
+	 * around after ~178.9 seconds.
 	 */
-
-	cc->mult = 125; /* saturation after 195 years */
-	cc->shift = 0;
+	clocks_calc_mult_shift(&cc->mult, &cc->shift, 24000000,
+			       NSEC_PER_SEC, 178);
 
 	nsec = 0; /* audio time is elapsed time since trigger */
 	timecounter_init(tc, cc, nsec);
diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 930ae4002a818..75dcb14ff20ad 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -504,7 +504,6 @@ static int azx_get_time_info(struct snd_pcm_substream *substream,
 		snd_pcm_gettime(substream->runtime, system_ts);
 
 		nsec = timecounter_read(&azx_dev->core.tc);
-		nsec = div_u64(nsec, 3); /* can be optimized */
 		if (audio_tstamp_config->report_delay)
 			nsec = azx_adjust_codec_delay(substream, nsec);
 
diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index 9ecaf6a1e8475..e4aa366d356eb 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1251,7 +1251,6 @@ static int skl_platform_soc_get_time_info(
 		snd_pcm_gettime(substream->runtime, system_ts);
 
 		nsec = timecounter_read(&hstr->tc);
-		nsec = div_u64(nsec, 3); /* can be optimized */
 		if (audio_tstamp_config->report_delay)
 			nsec = skl_adjust_codec_delay(substream, nsec);
 
-- 
2.34.1



