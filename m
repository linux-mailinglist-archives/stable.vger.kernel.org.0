Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AAA23A6E5
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgHCMzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgHCMWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B1262076B;
        Mon,  3 Aug 2020 12:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457338;
        bh=4VIgQ+/YAHhQES4rT3DCbadE3AbKY8baNT3gf9iE3M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SJmUlcrFfhCeybpZaXWnKgqA8SyCkpDe+hQ0mccZ56O8PTFP5tXM4GSH1bXIfHNr
         TZ8OTMCW2jvdiUP4lYqpcGWuw2BTsNAfl8IN008hctyL/u6PPEBN1X2hOqNwb44udC
         iBUIbfHedpGh7kbBa/cqP4Cwv8vjJVOnkxFlYlCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 008/120] ALSA: hda: Workaround for spurious wakeups on some Intel platforms
Date:   Mon,  3 Aug 2020 14:17:46 +0200
Message-Id: <20200803121903.263637082@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit a6630529aecb5a3e84370c376ed658e892e6261e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_controller.h |    2 +-
 sound/pci/hda/hda_intel.c      |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

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
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -298,7 +298,8 @@ enum {
 /* PCH for HSW/BDW; with runtime PM */
 /* no i915 binding for this as HSW/BDW has another controller for HDMI */
 #define AZX_DCAPS_INTEL_PCH \
-	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME)
+	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME |\
+	 AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
 
 /* HSW HDMI */
 #define AZX_DCAPS_INTEL_HASWELL \
@@ -1028,7 +1029,14 @@ static int azx_suspend(struct device *de
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
@@ -1057,7 +1065,10 @@ static int azx_resume(struct device *dev
 	if (azx_acquire_irq(chip, 1) < 0)
 		return -EIO;
 
-	pm_runtime_force_resume(dev);
+	if (chip->driver_caps & AZX_DCAPS_SUSPEND_SPURIOUS_WAKEUP)
+		__azx_runtime_resume(chip, false);
+	else
+		pm_runtime_force_resume(dev);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 
 	trace_azx_resume(chip);


