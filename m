Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE961101862
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKSFcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbfKSFcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17ADE21783;
        Tue, 19 Nov 2019 05:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141539;
        bh=VL9r0Csglza5UEJzSeVP/0TGRgcTmcqr5vr+D1HxZhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6fjvA0JNJKSzlyZdH7JtyISbErGXHh7dRkmwzA1nL4FaL4TkNvWwwAu9x868UbWP
         ayArhmgzpfGzb3l9ik1wtH9I4VcXsW6nM3RLR7heGS072MDa2vE3HJVhH1xzpHflSC
         jlJ0vYgl9+nUZio+pz5DpuUy6ged+F3zDgjTPjN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 196/422] ALSA: intel8x0m: Register irq handler after register initializations
Date:   Tue, 19 Nov 2019 06:16:33 +0100
Message-Id: <20191119051411.271206773@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 943a726b1c1b0..c84629190cbaf 100644
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



