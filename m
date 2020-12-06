Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178BE2D04DD
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgLFMrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:47:20 -0500
Received: from mailout2.hostsharing.net ([83.223.78.233]:49857 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFMrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:47:20 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 4CC7510189B63;
        Sun,  6 Dec 2020 13:46:23 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id BB165601805A;
        Sun,  6 Dec 2020 13:46:38 +0100 (CET)
X-Mailbox-Line: From 14fae59ad4802abf66f0af6d2e6540456c879a74 Mon Sep 17 00:00:00 2001
Message-Id: <14fae59ad4802abf66f0af6d2e6540456c879a74.1607258637.git.lukas@wunner.de>
In-Reply-To: <6b95ef1dc97d62b2927f1ac81514a323da0e8aaf.1607258637.git.lukas@wunner.de>
References: <6b95ef1dc97d62b2927f1ac81514a323da0e8aaf.1607258637.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 6 Dec 2020 13:46:01 +0100
Subject: [PATCH 4.9-stable 2/5] spi: bcm-qspi: Fix use-after-free on unbind
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 63c5395bb7a9777a33f0e7b5906f2c0170a23692 ]

bcm_qspi_remove() calls spi_unregister_master() even though
bcm_qspi_probe() calls devm_spi_register_master().  The spi_master is
therefore unregistered and freed twice on unbind.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

While at it, fix an ordering issue in bcm_qspi_remove() wherein
spi_unregister_master() is called after uninitializing the hardware,
disabling the clock and freeing an IRQ data structure.  The correct
order is to call spi_unregister_master() *before* those teardown steps
because bus accesses may still be ongoing until that function returns.

Fixes: fa236a7ef240 ("spi: bcm-qspi: Add Broadcom MSPI driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.9+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/5e31a9a59fd1c0d0b795b2fe219f25e5ee855f9d.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 1906b2319e5b..5453910d8abc 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1185,7 +1185,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!of_match_node(bcm_qspi_of_match, dev->of_node))
 		return -ENODEV;
 
-	master = spi_alloc_master(dev, sizeof(struct bcm_qspi));
+	master = devm_spi_alloc_master(dev, sizeof(struct bcm_qspi));
 	if (!master) {
 		dev_err(dev, "error allocating spi_master\n");
 		return -ENOMEM;
@@ -1218,21 +1218,17 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 	if (res) {
 		qspi->base[MSPI]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[MSPI])) {
-			ret = PTR_ERR(qspi->base[MSPI]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[MSPI]))
+			return PTR_ERR(qspi->base[MSPI]);
 	} else {
-		goto qspi_resource_err;
+		return 0;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "bspi");
 	if (res) {
 		qspi->base[BSPI]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[BSPI])) {
-			ret = PTR_ERR(qspi->base[BSPI]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[BSPI]))
+			return PTR_ERR(qspi->base[BSPI]);
 		qspi->bspi_mode = true;
 	} else {
 		qspi->bspi_mode = false;
@@ -1243,18 +1239,14 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cs_reg");
 	if (res) {
 		qspi->base[CHIP_SELECT]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[CHIP_SELECT])) {
-			ret = PTR_ERR(qspi->base[CHIP_SELECT]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[CHIP_SELECT]))
+			return PTR_ERR(qspi->base[CHIP_SELECT]);
 	}
 
 	qspi->dev_ids = kcalloc(num_irqs, sizeof(struct bcm_qspi_dev_id),
 				GFP_KERNEL);
-	if (!qspi->dev_ids) {
-		ret = -ENOMEM;
-		goto qspi_resource_err;
-	}
+	if (!qspi->dev_ids)
+		return -ENOMEM;
 
 	for (val = 0; val < num_irqs; val++) {
 		irq = -1;
@@ -1330,7 +1322,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	qspi->xfer_mode.addrlen = -1;
 	qspi->xfer_mode.hp = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(dev, "can't register master\n");
 		goto qspi_reg_err;
@@ -1343,8 +1335,6 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-qspi_resource_err:
-	spi_master_put(master);
 	return ret;
 }
 /* probe function to be called by SoC specific platform driver probe */
@@ -1355,10 +1345,10 @@ int bcm_qspi_remove(struct platform_device *pdev)
 	struct bcm_qspi *qspi = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
+	spi_unregister_master(qspi->master);
 	bcm_qspi_hw_uninit(qspi);
 	clk_disable_unprepare(qspi->clk);
 	kfree(qspi->dev_ids);
-	spi_unregister_master(qspi->master);
 
 	return 0;
 }
-- 
2.29.2

