Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA10302AE5
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbhAYS4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731386AbhAYSzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD1052067B;
        Mon, 25 Jan 2021 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600924;
        bh=Coi/mkEbQx1J5PPoOQp8Enck7bWfLWTDaqkucSs8Sx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mslju6mJGwg/XQpimblujXnYWSgszfCugvK74u+VXrA2legXoVCc4aE3dOgJmstsC
         DodIloU9eQMu0/3/veP4fAFZjvi32GUNmEudc4DS94B7/4Pn/2pdSLNuf/aiiw1Aty
         jlvOq0cJiuRTqB0LdztMnKXLclEiHNalGiYbOGTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 193/199] ASoC: SOF: Intel: hda: Avoid checking jack on system suspend
Date:   Mon, 25 Jan 2021 19:40:15 +0100
Message-Id: <20210125183224.315914092@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit ef4d764c99f792b725d4754a3628830f094f5c58 upstream.

System takes a very long time to suspend after commit 215a22ed31a1
("ALSA: hda: Refactor codec PM to use direct-complete optimization"):
[   90.065964] PM: suspend entry (s2idle)
[   90.067337] Filesystems sync: 0.001 seconds
[   90.185758] Freezing user space processes ... (elapsed 0.002 seconds) done.
[   90.188713] OOM killer disabled.
[   90.188714] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   90.190024] printk: Suspending console(s) (use no_console_suspend to debug)
[   90.904912] intel_pch_thermal 0000:00:12.0: CPU-PCH is cool [49C], continue to suspend
[  321.262505] snd_hda_codec_realtek ehdaudio0D0: Unable to sync register 0x2b8000. -5
[  328.426919] snd_hda_codec_realtek ehdaudio0D0: Unable to sync register 0x2b8000. -5
[  329.490933] ACPI: EC: interrupt blocked

That commit keeps the codec suspended during the system suspend. However,
mute/micmute LED will clear codec's direct-complete flag by
dpm_clear_superiors_direct_complete().

This doesn't play well with SOF driver. When its runtime resume is
called for system suspend, hda_codec_jack_check() schedules
jackpoll_work which uses snd_hdac_is_power_on() to check whether codec
is suspended. Because the direct-complete path isn't taken,
pm_runtime_disable() isn't called so snd_hdac_is_power_on() returns
false and jackpoll continues to run, and snd_hda_power_up_pm() cannot
power up an already suspended codec in multiple attempts, causes the
long delay on system suspend:

if (dev->power.direct_complete) {
	if (pm_runtime_status_suspended(dev)) {
		pm_runtime_disable(dev);
		if (pm_runtime_status_suspended(dev)) {
			pm_dev_dbg(dev, state, "direct-complete ");
			goto Complete;
		}

		pm_runtime_enable(dev);
	}
	dev->power.direct_complete = false;
}

When direct-complete path is taken, snd_hdac_is_power_on() returns true
and hda_jackpoll_work() is skipped by accident. So this is still not
correct.

If we were to use snd_hdac_is_power_on() in system PM path,
pm_runtime_status_suspended() should be used instead of
pm_runtime_suspended(), otherwise pm_runtime_{enable,disable}() may
change the outcome of snd_hdac_is_power_on().

Because devices suspend in reverse order (i.e. child first), it doesn't
make much sense to resume an already suspended codec from audio
controller. So avoid the issue by making sure jackpoll isn't used in
system PM process.

Fixes: 215a22ed31a1 ("ALSA: hda: Refactor codec PM to use direct-complete optimization")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210112181128.1229827-3-kai.heng.feng@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dsp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -683,8 +683,10 @@ static int hda_resume(struct snd_sof_dev
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
 	/* check jack status */
-	if (runtime_resume)
-		hda_codec_jack_check(sdev);
+	if (runtime_resume) {
+		if (sdev->system_suspend_target == SOF_SUSPEND_NONE)
+			hda_codec_jack_check(sdev);
+	}
 
 	/* turn off the links that were off before suspend */
 	list_for_each_entry(hlink, &bus->hlink_list, list) {


