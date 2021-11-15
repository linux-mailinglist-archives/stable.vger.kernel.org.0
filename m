Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98493450E34
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbhKOSNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240109AbhKOSFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20EFB6328F;
        Mon, 15 Nov 2021 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998154;
        bh=BZyM0cvyy3SjbkM0SjZNvV1wP+CNjif3ciGEo8Kn6qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uipRI0GcSjO68CAh61svllxfqJthwG7+AzW0NKu8ekJWXpc4JivXI+p11OMPmPFgD
         kB3fdJpMcQfM3OW9kxkPzpelX+LrLKL2tPpbT0kT6d/8BIpnBKg7J+1TnvvkQa4HlP
         HQ5XeKUUP/sZgN1O9rTihcu4MiU0lMDUjTLORAcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        Thomas Voegtle <tv@lio96.de>
Subject: [PATCH 5.10 408/575] ALSA: hda: Release controller display power during shutdown/reboot
Date:   Mon, 15 Nov 2021 18:02:13 +0100
Message-Id: <20211115165357.874555296@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 472e18f63c425dda97b888f40f858ea54e3efc17 ]

Make sure the HDA driver's display power reference is released during
shutdown/reboot.

During the shutdown/reboot sequence the pci device core calls the
pm_runtime_resume handler for all devices before calling the driver's
shutdown callback and so the HDA driver's runtime resume callback will
acquire a display power reference (on HSW/BDW). This triggers a power
reference held WARN on HSW/BDW in the i915 driver's subsequent shutdown
handler, which expects all display power references to be released by
that time.

Since the HDA controller is stopped in the shutdown handler in any case,
let's follow here the same sequence as the one during runtime suspend.
This will also reset the HDA link and drop the display power reference,
getting rid of the above WARN.

Tested on HSW.

v2:
- Fix the build for CONFIG_PM=n (Takashi)
- s/__azx_runtime_suspend/azx_shutdown_chip/

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3618
Reported-and-tested-by: Thomas Voegtle <tv@lio96.de>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20210623134601.2128663-1-imre.deak@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a8eae31e47efb..e31eafe73661f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -936,6 +936,14 @@ static unsigned int azx_get_pos_skl(struct azx *chip, struct azx_dev *azx_dev)
 	return azx_get_pos_posbuf(chip, azx_dev);
 }
 
+static void azx_shutdown_chip(struct azx *chip)
+{
+	azx_stop_chip(chip);
+	azx_enter_link_reset(chip);
+	azx_clear_irq_pending(chip);
+	display_power(chip, false);
+}
+
 #ifdef CONFIG_PM
 static DEFINE_MUTEX(card_list_lock);
 static LIST_HEAD(card_list);
@@ -995,14 +1003,6 @@ static bool azx_is_pm_ready(struct snd_card *card)
 	return true;
 }
 
-static void __azx_runtime_suspend(struct azx *chip)
-{
-	azx_stop_chip(chip);
-	azx_enter_link_reset(chip);
-	azx_clear_irq_pending(chip);
-	display_power(chip, false);
-}
-
 static void __azx_runtime_resume(struct azx *chip)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
@@ -1081,7 +1081,7 @@ static int azx_suspend(struct device *dev)
 
 	chip = card->private_data;
 	bus = azx_bus(chip);
-	__azx_runtime_suspend(chip);
+	azx_shutdown_chip(chip);
 	if (bus->irq >= 0) {
 		free_irq(bus->irq, chip);
 		bus->irq = -1;
@@ -1160,7 +1160,7 @@ static int azx_runtime_suspend(struct device *dev)
 	/* enable controller wake up event */
 	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) | STATESTS_INT_MASK);
 
-	__azx_runtime_suspend(chip);
+	azx_shutdown_chip(chip);
 	trace_azx_runtime_suspend(chip);
 	return 0;
 }
@@ -2461,7 +2461,7 @@ static void azx_shutdown(struct pci_dev *pci)
 		return;
 	chip = card->private_data;
 	if (chip && chip->running)
-		azx_stop_chip(chip);
+		azx_shutdown_chip(chip);
 }
 
 /* PCI IDs */
-- 
2.33.0



