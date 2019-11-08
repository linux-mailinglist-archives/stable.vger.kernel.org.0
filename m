Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B5DF47D0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391471AbfKHLq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391467AbfKHLq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9081B21D82;
        Fri,  8 Nov 2019 11:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213615;
        bh=IKe3NgO/UtZdXa4rzM4MFaxevILnmTQeYY26tJYkwg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rC/uEH4KPV1C+sSsD8aYlD7li/MzacoIG+xeVfvAbBA55Ta9Yvz3vIZ3muJ9Lu2Gy
         HzC9H3OLMaLQ4kc6kGZAh0t/+Gm3BwjK8/zxpmNIFDu49ElLDhAgtC8w2ukVZY+bCw
         9eo7GjEt5W51HEJYkobQr9I8rNhpIvkFrxPnZdZc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 49/64] ALSA: intel8x0m: Register irq handler after register initializations
Date:   Fri,  8 Nov 2019 06:45:30 -0500
Message-Id: <20191108114545.15351-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7064f376d4a10686f51c879401a569bb4babf9c6 ]

The interrupt handler has to be acquired after the other resource
initialization when allocated with IRQF_SHARED.  Otherwise it's
triggered before the resource gets ready, and may lead to unpleasant
behavior.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/intel8x0m.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 1bc98c867133d..2286dfd72ff7e 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1171,16 +1171,6 @@ static int snd_intel8x0m_create(struct snd_card *card,
 	}
 
  port_inited:
-	if (request_irq(pci->irq, snd_intel8x0m_interrupt, IRQF_SHARED,
-			KBUILD_MODNAME, chip)) {
-		dev_err(card->dev, "unable to grab IRQ %d\n", pci->irq);
-		snd_intel8x0m_free(chip);
-		return -EBUSY;
-	}
-	chip->irq = pci->irq;
-	pci_set_master(pci);
-	synchronize_irq(chip->irq);
-
 	/* initialize offsets */
 	chip->bdbars_count = 2;
 	tbl = intel_regs;
@@ -1224,11 +1214,21 @@ static int snd_intel8x0m_create(struct snd_card *card,
 	chip->int_sta_reg = ICH_REG_GLOB_STA;
 	chip->int_sta_mask = int_sta_masks;
 
+	pci_set_master(pci);
+
 	if ((err = snd_intel8x0m_chip_init(chip, 1)) < 0) {
 		snd_intel8x0m_free(chip);
 		return err;
 	}
 
+	if (request_irq(pci->irq, snd_intel8x0m_interrupt, IRQF_SHARED,
+			KBUILD_MODNAME, chip)) {
+		dev_err(card->dev, "unable to grab IRQ %d\n", pci->irq);
+		snd_intel8x0m_free(chip);
+		return -EBUSY;
+	}
+	chip->irq = pci->irq;
+
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
 		snd_intel8x0m_free(chip);
 		return err;
-- 
2.20.1

