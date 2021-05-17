Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43989383549
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbhEQPRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243914AbhEQPPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:15:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885C161C5C;
        Mon, 17 May 2021 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261943;
        bh=LSyJ0nUKHPe0cCFG6u5p6HPaHIU32sXINdzx/z6TiW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed7NQ3MRJT6ZGNlflCjzvBZdhY0dGSTwlAsP9wUW6eyY6YOj5wquFfuie5Zdo4sUP
         kD/wj/Sf8n7437Z7RQOEYzYb7xAZEc9bTIbBQwtt/eZ9mijfAKxCf+A/tqOgDufU58
         PQhc7qrcSbFPBqwD4OrdOmeWqMLuggxAgG7BWZC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <jim2101024@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 190/329] ata: ahci_brcm: Fix use of BCM7216 reset controller
Date:   Mon, 17 May 2021 16:01:41 +0200
Message-Id: <20210517140308.555375498@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Quinlan <jim2101024@gmail.com>

[ Upstream commit e8d6f9e56187c101b325e8d18f1d4032420d08ff ]

This driver may use one of two resets controllers.  Keep them in separate
variables to keep things simple.  The reset controller "rescal" is shared
between the AHCI driver and the PCIe driver for the BrcmSTB 7216 chip.  Use
devm_reset_control_get_optional_shared() to handle this sharing.

[bhelgaas: add Jens' ack from v5 posting]
Fixes: 272ecd60a636 ("ata: ahci_brcm: BCM7216 reset is self de-asserting")
Fixes: c345ec6a50e9 ("ata: ahci_brcm: Support BCM7216 reset controller name")
Link: https://lore.kernel.org/r/20210430152156.21162-3-jim2101024@gmail.com
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_brcm.c | 46 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index 5b32df5d33ad..6e9c5ade4c2e 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -86,7 +86,8 @@ struct brcm_ahci_priv {
 	u32 port_mask;
 	u32 quirks;
 	enum brcm_ahci_version version;
-	struct reset_control *rcdev;
+	struct reset_control *rcdev_rescal;
+	struct reset_control *rcdev_ahci;
 };
 
 static inline u32 brcm_sata_readreg(void __iomem *addr)
@@ -352,8 +353,8 @@ static int brcm_ahci_suspend(struct device *dev)
 	else
 		ret = 0;
 
-	if (priv->version != BRCM_SATA_BCM7216)
-		reset_control_assert(priv->rcdev);
+	reset_control_assert(priv->rcdev_ahci);
+	reset_control_rearm(priv->rcdev_rescal);
 
 	return ret;
 }
@@ -365,10 +366,10 @@ static int __maybe_unused brcm_ahci_resume(struct device *dev)
 	struct brcm_ahci_priv *priv = hpriv->plat_data;
 	int ret = 0;
 
-	if (priv->version == BRCM_SATA_BCM7216)
-		ret = reset_control_reset(priv->rcdev);
-	else
-		ret = reset_control_deassert(priv->rcdev);
+	ret = reset_control_deassert(priv->rcdev_ahci);
+	if (ret)
+		return ret;
+	ret = reset_control_reset(priv->rcdev_rescal);
 	if (ret)
 		return ret;
 
@@ -434,7 +435,6 @@ static int brcm_ahci_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
 	struct device *dev = &pdev->dev;
-	const char *reset_name = NULL;
 	struct brcm_ahci_priv *priv;
 	struct ahci_host_priv *hpriv;
 	struct resource *res;
@@ -456,15 +456,15 @@ static int brcm_ahci_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->top_ctrl))
 		return PTR_ERR(priv->top_ctrl);
 
-	/* Reset is optional depending on platform and named differently */
-	if (priv->version == BRCM_SATA_BCM7216)
-		reset_name = "rescal";
-	else
-		reset_name = "ahci";
-
-	priv->rcdev = devm_reset_control_get_optional(&pdev->dev, reset_name);
-	if (IS_ERR(priv->rcdev))
-		return PTR_ERR(priv->rcdev);
+	if (priv->version == BRCM_SATA_BCM7216) {
+		priv->rcdev_rescal = devm_reset_control_get_optional_shared(
+			&pdev->dev, "rescal");
+		if (IS_ERR(priv->rcdev_rescal))
+			return PTR_ERR(priv->rcdev_rescal);
+	}
+	priv->rcdev_ahci = devm_reset_control_get_optional(&pdev->dev, "ahci");
+	if (IS_ERR(priv->rcdev_ahci))
+		return PTR_ERR(priv->rcdev_ahci);
 
 	hpriv = ahci_platform_get_resources(pdev, 0);
 	if (IS_ERR(hpriv))
@@ -485,10 +485,10 @@ static int brcm_ahci_probe(struct platform_device *pdev)
 		break;
 	}
 
-	if (priv->version == BRCM_SATA_BCM7216)
-		ret = reset_control_reset(priv->rcdev);
-	else
-		ret = reset_control_deassert(priv->rcdev);
+	ret = reset_control_reset(priv->rcdev_rescal);
+	if (ret)
+		return ret;
+	ret = reset_control_deassert(priv->rcdev_ahci);
 	if (ret)
 		return ret;
 
@@ -539,8 +539,8 @@ out_disable_regulators:
 out_disable_clks:
 	ahci_platform_disable_clks(hpriv);
 out_reset:
-	if (priv->version != BRCM_SATA_BCM7216)
-		reset_control_assert(priv->rcdev);
+	reset_control_assert(priv->rcdev_ahci);
+	reset_control_rearm(priv->rcdev_rescal);
 	return ret;
 }
 
-- 
2.30.2



