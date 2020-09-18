Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28D926EBE8
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgIRCIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbgIRCH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17D5B238E5;
        Fri, 18 Sep 2020 02:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394877;
        bh=VoN+RQMBRpIUqEdv7Xp17lu0pF70gd7NbulkG0Oq4Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+SGjgu8Mou5JPHM/SVJEIfinspfMqvzeSL0dm7XStez56XLvJWRhzwnijKzoWQBe
         eRu3Qir280+wpxAwdCM4GlXpYzevO8whO2E/5vyqqQco21o4h5I+ZWtk0z5asReRgS
         sESgEwZMtKdndDfWqE+aRs8qkL+cbSxt8vHKv83Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 328/330] ALSA: hda: Workaround for spurious wakeups on some Intel platforms
Date:   Thu, 17 Sep 2020 22:01:08 -0400
Message-Id: <20200918020110.2063155-328-sashal@kernel.org>
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

[ Upstream commit a6630529aecb5a3e84370c376ed658e892e6261e ]

We've received a regression report on Intel HD-audio controller that
wakes up immediately after S3 suspend.  The bisection leads to the
commit c4c8dd6ef807 ("ALSA: hda: Skip controller resume if not
needed").  This commit replaces the system-suspend to use
pm_runtime_force_suspend() instead of the direct call of
__azx_runtime_suspend().  However, by some really mysterious reason,
pm_runtime_force_suspend() causes a spurious wakeup (although it calls
the same __azx_runtime_suspend() internally).

As an ugly workaround for now, revert the behavior to call
__azx_runtime_suspend() and __azx_runtime_resume() for those old Intel
platforms that may exhibit such a problem, while keeping the new
standard pm_runtime_force_suspend() and pm_runtime_force_resume()
pair for the remaining chips.

Fixes: c4c8dd6ef807 ("ALSA: hda: Skip controller resume if not needed")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208649
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200727164443.4233-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.h |  2 +-
 sound/pci/hda/hda_intel.c      | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index 82e26442724ba..a356fb0e57738 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -41,7 +41,7 @@
 /* 24 unused */
 #define AZX_DCAPS_COUNT_LPIB_DELAY  (1 << 25)	/* Take LPIB as delay */
 #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
-/* 27 unused */
+#define AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP (1 << 27) /* Workaround for spurious wakeups after suspend */
 #define AZX_DCAPS_CORBRP_SELF_CLEAR (1 << 28)	/* CORBRP clears itself after reset */
 #define AZX_DCAPS_NO_MSI64      (1 << 29)	/* Stick to 32-bit MSIs */
 #define AZX_DCAPS_SEPARATE_STREAM_TAG	(1 << 30) /* capture and playback use separate stream tag */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 754e4d1a86b57..590ea262f2e20 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -295,7 +295,8 @@ enum {
 /* PCH for HSW/BDW; with runtime PM */
 /* no i915 binding for this as HSW/BDW has another controller for HDMI */
 #define AZX_DCAPS_INTEL_PCH \
-	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME)
+	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME |\
+	 AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
 
 /* HSW HDMI */
 #define AZX_DCAPS_INTEL_HASWELL \
@@ -1026,7 +1027,14 @@ static int azx_suspend(struct device *dev)
 	chip = card->private_data;
 	bus = azx_bus(chip);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
-	pm_runtime_force_suspend(dev);
+	/* An ugly workaround: direct call of __azx_runtime_suspend() and
+	 * __azx_runtime_resume() for old Intel platforms that suffer from
+	 * spurious wakeups after S3 suspend
+	 */
+	if (chip->driver_caps & AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
+		__azx_runtime_suspend(chip);
+	else
+		pm_runtime_force_suspend(dev);
 	if (bus->irq >= 0) {
 		free_irq(bus->irq, chip);
 		bus->irq = -1;
@@ -1054,7 +1062,10 @@ static int azx_resume(struct device *dev)
 	if (azx_acquire_irq(chip, 1) < 0)
 		return -EIO;
 
-	pm_runtime_force_resume(dev);
+	if (chip->driver_caps & AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
+		__azx_runtime_resume(chip, false);
+	else
+		pm_runtime_force_resume(dev);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 
 	trace_azx_resume(chip);
-- 
2.25.1

