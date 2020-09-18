Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6613326F17F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgIRCIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgIRCH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1865323770;
        Fri, 18 Sep 2020 02:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394876;
        bh=6JSglhZ8wTAzwbZlUymn5+InbH5SDe6l4YfVkyfb++Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnan5oY2WxlRnnQhR0/uhkDbc7YgHondUy3ycyn9IL+TC/StPcGCsI70XAxFGB9KO
         reoiDTeP3hs5vq4UeD7MmWhu1N6KKc3n8GHmaNmzGNHHrpR952ML1By4rFgGyeXhtY
         TDCVPjarsYNpbGo3kPnU6bmCCkxGjrF+7lOA5/do=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 327/330] ALSA: hda: Always use jackpoll helper for jack update after resume
Date:   Thu, 17 Sep 2020 22:01:07 -0400
Message-Id: <20200918020110.2063155-327-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8d6762af302d69f76fa788a277a56a9d9cd275d5 ]

HD-audio codec driver applies a tricky procedure to forcibly perform
the runtime resume by mimicking the usage count even if the device has
been runtime-suspended beforehand.  This was needed to assure to
trigger the jack detection update after the system resume.

And recently we also applied the similar logic to the HD-audio
controller side.  However this seems leading to some inconsistency,
and eventually PCI controller gets screwed up.

This patch is an attempt to fix and clean up those behavior: instead
of the tricky runtime resume procedure, the existing jackpoll work is
scheduled when such a forced codec resume is required.  The jackpoll
work will power up the codec, and this alone should suffice for the
jack status update in usual cases.  If the extra polling is requested
(by checking codec->jackpoll_interval), the manual update is invoked
after that, and the codec is powered down again.

Also, we filter the spurious wake up of the codec from the controller
runtime resume by checking codec->relaxed_resume flag.  If this flag
is set, basically we don't need to wake up explicitly, but it's
supposed to be done via the audio component notifier.

Fixes: c4c8dd6ef807 ("ALSA: hda: Skip controller resume if not needed")
Link: https://lore.kernel.org/r/20200422203744.26299-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 28 +++++++++++++++++-----------
 sound/pci/hda/hda_intel.c | 17 ++---------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 12da263fb02ba..6da296def283e 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -641,8 +641,18 @@ static void hda_jackpoll_work(struct work_struct *work)
 	struct hda_codec *codec =
 		container_of(work, struct hda_codec, jackpoll_work.work);
 
-	snd_hda_jack_set_dirty_all(codec);
-	snd_hda_jack_poll_all(codec);
+	/* for non-polling trigger: we need nothing if already powered on */
+	if (!codec->jackpoll_interval && snd_hdac_is_power_on(&codec->core))
+		return;
+
+	/* the power-up/down sequence triggers the runtime resume */
+	snd_hda_power_up_pm(codec);
+	/* update jacks manually if polling is required, too */
+	if (codec->jackpoll_interval) {
+		snd_hda_jack_set_dirty_all(codec);
+		snd_hda_jack_poll_all(codec);
+	}
+	snd_hda_power_down_pm(codec);
 
 	if (!codec->jackpoll_interval)
 		return;
@@ -2958,18 +2968,14 @@ static int hda_codec_runtime_resume(struct device *dev)
 static int hda_codec_force_resume(struct device *dev)
 {
 	struct hda_codec *codec = dev_to_hda_codec(dev);
-	bool forced_resume = hda_codec_need_resume(codec);
 	int ret;
 
-	/* The get/put pair below enforces the runtime resume even if the
-	 * device hasn't been used at suspend time.  This trick is needed to
-	 * update the jack state change during the sleep.
-	 */
-	if (forced_resume)
-		pm_runtime_get_noresume(dev);
 	ret = pm_runtime_force_resume(dev);
-	if (forced_resume)
-		pm_runtime_put(dev);
+	/* schedule jackpoll work for jack detection update */
+	if (codec->jackpoll_interval ||
+	    (pm_runtime_suspended(dev) && hda_codec_need_resume(codec)))
+		schedule_delayed_work(&codec->jackpoll_work,
+				      codec->jackpoll_interval);
 	return ret;
 }
 
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a6e8aaa091c7d..754e4d1a86b57 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1002,7 +1002,8 @@ static void __azx_runtime_resume(struct azx *chip, bool from_rt)
 
 	if (status && from_rt) {
 		list_for_each_codec(codec, &chip->bus)
-			if (status & (1 << codec->addr))
+			if (!codec->relaxed_resume &&
+			    (status & (1 << codec->addr)))
 				schedule_delayed_work(&codec->jackpoll_work,
 						      codec->jackpoll_interval);
 	}
@@ -1041,9 +1042,7 @@ static int azx_suspend(struct device *dev)
 static int azx_resume(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
-	struct hda_codec *codec;
 	struct azx *chip;
-	bool forced_resume = false;
 
 	if (!azx_is_pm_ready(card))
 		return 0;
@@ -1055,19 +1054,7 @@ static int azx_resume(struct device *dev)
 	if (azx_acquire_irq(chip, 1) < 0)
 		return -EIO;
 
-	/* check for the forced resume */
-	list_for_each_codec(codec, &chip->bus) {
-		if (hda_codec_need_resume(codec)) {
-			forced_resume = true;
-			break;
-		}
-	}
-
-	if (forced_resume)
-		pm_runtime_get_noresume(dev);
 	pm_runtime_force_resume(dev);
-	if (forced_resume)
-		pm_runtime_put(dev);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 
 	trace_azx_resume(chip);
-- 
2.25.1

