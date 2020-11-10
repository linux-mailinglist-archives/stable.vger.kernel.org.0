Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADEC2ACE34
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgKJDxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731865AbgKJDxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61A3220781;
        Tue, 10 Nov 2020 03:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980415;
        bh=nAbUG2HwMOperHmk1+8FdGNfVbvxaEgbvll9qgba8Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2acFxvTvEZpxUyi7o7StkamUlnW6P0gxjqtlSoTdH5v4XroJkOE+os9luCKbcdvt3
         ln5DNND/MRvjeg2A+copCA6JXGXfd3CziM2c4jVuSj/Jb0JM9s5/I9C0ztefapEUd4
         IJ+9Tz8QtbEW/x8dW/Daj4F0KenoQVLnJz3wCEw0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.9 11/55] ALSA: hda: Separate runtime and system suspend
Date:   Mon,  9 Nov 2020 22:52:34 -0500
Message-Id: <20201110035318.423757-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit f5dac54d9d93826a776dffc848df76746f7135bb ]

Both pm_runtime_force_suspend() and pm_runtime_force_resume() have
some implicit checks, so it can make code flow more straightforward if
we separate runtime and system suspend callbacks.

High Definition Audio Specification, 4.5.9.3 Codec Wake From System S3
states that codec can wake the system up from S3 if WAKEEN is toggled.
Since HDA controller has different wakeup settings for runtime and
system susend, we also need to explicitly disable direct-complete which
can be enabled automatically by PCI core. In addition to that, avoid
waking up codec if runtime resume is for system suspend, to not break
direct-complete for codecs.

While at it, also remove AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP, as the
original bug commit a6630529aecb ("ALSA: hda: Workaround for spurious
wakeups on some Intel platforms") solves doesn't happen with this
patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20201027130038.16463-3-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.h |  3 +-
 sound/pci/hda/hda_intel.c      | 62 +++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index be63ead8161f8..68f9668788ea2 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -41,7 +41,7 @@
 /* 24 unused */
 #define AZX_DCAPS_COUNT_LPIB_DELAY  (1 << 25)	/* Take LPIB as delay */
 #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
-#define AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP (1 << 27) /* Workaround for spurious wakeups after suspend */
+/* 27 unused */
 #define AZX_DCAPS_CORBRP_SELF_CLEAR (1 << 28)	/* CORBRP clears itself after reset */
 #define AZX_DCAPS_NO_MSI64      (1 << 29)	/* Stick to 32-bit MSIs */
 #define AZX_DCAPS_SEPARATE_STREAM_TAG	(1 << 30) /* capture and playback use separate stream tag */
@@ -143,6 +143,7 @@ struct azx {
 	unsigned int align_buffer_size:1;
 	unsigned int region_requested:1;
 	unsigned int disabled:1; /* disabled by vga_switcheroo */
+	unsigned int pm_prepared:1;
 
 	/* GTS present */
 	unsigned int gts_present:1;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 476a8b871daa1..268e9ead9795f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -297,8 +297,7 @@ enum {
 /* PCH for HSW/BDW; with runtime PM */
 /* no i915 binding for this as HSW/BDW has another controller for HDMI */
 #define AZX_DCAPS_INTEL_PCH \
-	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME |\
-	 AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
+	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME)
 
 /* HSW HDMI */
 #define AZX_DCAPS_INTEL_HASWELL \
@@ -984,7 +983,7 @@ static void __azx_runtime_suspend(struct azx *chip)
 	display_power(chip, false);
 }
 
-static void __azx_runtime_resume(struct azx *chip, bool from_rt)
+static void __azx_runtime_resume(struct azx *chip)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct hdac_bus *bus = azx_bus(chip);
@@ -1001,7 +1000,8 @@ static void __azx_runtime_resume(struct azx *chip, bool from_rt)
 	azx_init_pci(chip);
 	hda_intel_init_chip(chip, true);
 
-	if (from_rt) {
+	/* Avoid codec resume if runtime resume is for system suspend */
+	if (!chip->pm_prepared) {
 		list_for_each_codec(codec, &chip->bus) {
 			if (codec->relaxed_resume)
 				continue;
@@ -1017,6 +1017,29 @@ static void __azx_runtime_resume(struct azx *chip, bool from_rt)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static int azx_prepare(struct device *dev)
+{
+	struct snd_card *card = dev_get_drvdata(dev);
+	struct azx *chip;
+
+	chip = card->private_data;
+	chip->pm_prepared = 1;
+
+	/* HDA controller always requires different WAKEEN for runtime suspend
+	 * and system suspend, so don't use direct-complete here.
+	 */
+	return 0;
+}
+
+static void azx_complete(struct device *dev)
+{
+	struct snd_card *card = dev_get_drvdata(dev);
+	struct azx *chip;
+
+	chip = card->private_data;
+	chip->pm_prepared = 0;
+}
+
 static int azx_suspend(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
@@ -1028,15 +1051,7 @@ static int azx_suspend(struct device *dev)
 
 	chip = card->private_data;
 	bus = azx_bus(chip);
-	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
-	/* An ugly workaround: direct call of __azx_runtime_suspend() and
-	 * __azx_runtime_resume() for old Intel platforms that suffer from
-	 * spurious wakeups after S3 suspend
-	 */
-	if (chip->driver_caps & AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
-		__azx_runtime_suspend(chip);
-	else
-		pm_runtime_force_suspend(dev);
+	__azx_runtime_suspend(chip);
 	if (bus->irq >= 0) {
 		free_irq(bus->irq, chip);
 		bus->irq = -1;
@@ -1065,11 +1080,7 @@ static int azx_resume(struct device *dev)
 	if (azx_acquire_irq(chip, 1) < 0)
 		return -EIO;
 
-	if (chip->driver_caps & AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
-		__azx_runtime_resume(chip, false);
-	else
-		pm_runtime_force_resume(dev);
-	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
+	__azx_runtime_resume(chip);
 
 	trace_azx_resume(chip);
 	return 0;
@@ -1117,10 +1128,7 @@ static int azx_runtime_suspend(struct device *dev)
 	chip = card->private_data;
 
 	/* enable controller wake up event */
-	if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0) {
-		azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) |
-			   STATESTS_INT_MASK);
-	}
+	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) | STATESTS_INT_MASK);
 
 	__azx_runtime_suspend(chip);
 	trace_azx_runtime_suspend(chip);
@@ -1131,18 +1139,14 @@ static int azx_runtime_resume(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip;
-	bool from_rt = snd_power_get_state(card) == SNDRV_CTL_POWER_D0;
 
 	if (!azx_is_pm_ready(card))
 		return 0;
 	chip = card->private_data;
-	__azx_runtime_resume(chip, from_rt);
+	__azx_runtime_resume(chip);
 
 	/* disable controller Wake Up event*/
-	if (from_rt) {
-		azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) &
-			   ~STATESTS_INT_MASK);
-	}
+	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) & ~STATESTS_INT_MASK);
 
 	trace_azx_runtime_resume(chip);
 	return 0;
@@ -1176,6 +1180,8 @@ static int azx_runtime_idle(struct device *dev)
 static const struct dev_pm_ops azx_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(azx_suspend, azx_resume)
 #ifdef CONFIG_PM_SLEEP
+	.prepare = azx_prepare,
+	.complete = azx_complete,
 	.freeze_noirq = azx_freeze_noirq,
 	.thaw_noirq = azx_thaw_noirq,
 #endif
-- 
2.27.0

