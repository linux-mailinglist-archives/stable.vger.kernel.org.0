Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9D71B7502
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgDXMXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXMXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3AF20706;
        Fri, 24 Apr 2020 12:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731015;
        bh=v6KNJMAThACxl173RUXa9EVAziAlMPIDlPYr3zXtyVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTH4SOD3Y246VIL9s2L0TCDRh7B+V2o7E9I+iDcg3R4iT2PVDmGuFl8PRRqX+SkO8
         gZfA9JFVpbu+UolpCJjj1SlPoYHxYOBCJrpsSEuPsxLshz8lr+NRzh9+/cFJsZysS0
         5hzW+ktvkSPnyKDT9ocMNnICyKJ6kSZf9SvYulys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 10/26] ALSA: hda: Skip controller resume if not needed
Date:   Fri, 24 Apr 2020 08:23:07 -0400
Message-Id: <20200424122323.10194-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c4c8dd6ef807663e42a5f04ea77cd62029eb99fa ]

The HD-audio controller does system-suspend and resume operations by
directly calling its helpers __azx_runtime_suspend() and
__azx_runtime_resume().  However, in general, we don't have to resume
always the device fully at the system resume; typically, if a device
has been runtime-suspended, we can leave it to runtime resume.

Usually for achieving this, the driver would call
pm_runtime_force_suspend() and pm_runtime_force_resume() pairs in the
system suspend and resume ops.  Unfortunately, this doesn't work for
the resume path in our case.  For handling the jack detection at the
system resume, a child codec device may need the (literally) forcibly
resume even if it's been runtime-suspended, and for that, the
controller device must be also resumed even if it's been suspended.

This patch is an attempt to improve the situation.  It replaces the
direct __azx_runtime_suspend()/_resume() calls with with
pm_runtime_force_suspend() and pm_runtime_force_resume() with a slight
trick as we've done for the codec side.  More exactly:

- azx_has_pm_runtime() check is dropped from azx_runtime_suspend() and
  azx_runtime_resume(), so that it can be properly executed from the
  system-suspend/resume path

- The WAKEEN handling depends on the card's power state now; it's set
  and cleared only for the runtime-suspend

- azx_resume() checks whether any codec may need the forcible resume
  beforehand.  If the forcible resume is required, it does temporary
  PM refcount up/down for actually triggering the runtime resume.

- A new helper function, hda_codec_need_resume(), is introduced for
  checking whether the codec needs a forcible runtime-resume, and the
  existing code is rewritten with that.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207043
Link: https://lore.kernel.org/r/20200413082034.25166-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h |  5 +++++
 sound/pci/hda/hda_codec.c |  2 +-
 sound/pci/hda/hda_intel.c | 38 +++++++++++++++++++++++++++-----------
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 9a0393cf024c2..65c056ce91128 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -494,6 +494,11 @@ void snd_hda_update_power_acct(struct hda_codec *codec);
 static inline void snd_hda_set_power_save(struct hda_bus *bus, int delay) {}
 #endif
 
+static inline bool hda_codec_need_resume(struct hda_codec *codec)
+{
+	return !codec->relaxed_resume && codec->jacktbl.used;
+}
+
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
 /*
  * patch firmware
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 6cb72336433ad..1bc45c8507858 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2948,7 +2948,7 @@ static int hda_codec_runtime_resume(struct device *dev)
 static int hda_codec_force_resume(struct device *dev)
 {
 	struct hda_codec *codec = dev_to_hda_codec(dev);
-	bool forced_resume = !codec->relaxed_resume && codec->jacktbl.used;
+	bool forced_resume = hda_codec_need_resume(codec);
 	int ret;
 
 	/* The get/put pair below enforces the runtime resume even if the
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 6ccf34840e8a1..4604d1e16150d 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1025,7 +1025,7 @@ static int azx_suspend(struct device *dev)
 	chip = card->private_data;
 	bus = azx_bus(chip);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
-	__azx_runtime_suspend(chip);
+	pm_runtime_force_suspend(dev);
 	if (bus->irq >= 0) {
 		free_irq(bus->irq, chip);
 		bus->irq = -1;
@@ -1041,7 +1041,9 @@ static int azx_suspend(struct device *dev)
 static int azx_resume(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
+	struct hda_codec *codec;
 	struct azx *chip;
+	bool forced_resume = false;
 
 	if (!azx_is_pm_ready(card))
 		return 0;
@@ -1052,7 +1054,20 @@ static int azx_resume(struct device *dev)
 			chip->msi = 0;
 	if (azx_acquire_irq(chip, 1) < 0)
 		return -EIO;
-	__azx_runtime_resume(chip, false);
+
+	/* check for the forced resume */
+	list_for_each_codec(codec, &chip->bus) {
+		if (hda_codec_need_resume(codec)) {
+			forced_resume = true;
+			break;
+		}
+	}
+
+	if (forced_resume)
+		pm_runtime_get_noresume(dev);
+	pm_runtime_force_resume(dev);
+	if (forced_resume)
+		pm_runtime_put(dev);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 
 	trace_azx_resume(chip);
@@ -1099,12 +1114,12 @@ static int azx_runtime_suspend(struct device *dev)
 	if (!azx_is_pm_ready(card))
 		return 0;
 	chip = card->private_data;
-	if (!azx_has_pm_runtime(chip))
-		return 0;
 
 	/* enable controller wake up event */
-	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) |
-		  STATESTS_INT_MASK);
+	if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0) {
+		azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) |
+			   STATESTS_INT_MASK);
+	}
 
 	__azx_runtime_suspend(chip);
 	trace_azx_runtime_suspend(chip);
@@ -1115,17 +1130,18 @@ static int azx_runtime_resume(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip;
+	bool from_rt = snd_power_get_state(card) == SNDRV_CTL_POWER_D0;
 
 	if (!azx_is_pm_ready(card))
 		return 0;
 	chip = card->private_data;
-	if (!azx_has_pm_runtime(chip))
-		return 0;
-	__azx_runtime_resume(chip, true);
+	__azx_runtime_resume(chip, from_rt);
 
 	/* disable controller Wake Up event*/
-	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) &
-			~STATESTS_INT_MASK);
+	if (from_rt) {
+		azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) &
+			   ~STATESTS_INT_MASK);
+	}
 
 	trace_azx_runtime_resume(chip);
 	return 0;
-- 
2.20.1

