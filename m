Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486E72D050B
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 14:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgLFNKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 08:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFNKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 08:10:48 -0500
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E42C0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 05:10:07 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id C242510138A00;
        Sun,  6 Dec 2020 14:09:29 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 6224460144BE;
        Sun,  6 Dec 2020 14:10:06 +0100 (CET)
X-Mailbox-Line: From 298055a3252640ac67dbf1dbf1452678133fa515 Mon Sep 17 00:00:00 2001
Message-Id: <298055a3252640ac67dbf1dbf1452678133fa515.1607260117.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 6 Dec 2020 14:10:00 +0100
Subject: [PATCH 5.4-stable] spi: bcm2835: Release the DMA channel if probe
 fails after dma_init
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 666224b43b4bd4612ce3b758c038f9bc5c5e3fcb ]

The DMA channel was not released if either devm_request_irq() or
devm_spi_register_controller() failed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20191212135550.4634-3-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to 5.4-stable]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/spi/spi-bcm2835.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 5bc97b22491c..56ee84e85bee 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1310,21 +1310,22 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 			       dev_name(&pdev->dev), ctlr);
 	if (err) {
 		dev_err(&pdev->dev, "could not request IRQ: %d\n", err);
-		goto out_clk_disable;
+		goto out_dma_release;
 	}
 
 	err = spi_register_controller(ctlr);
 	if (err) {
 		dev_err(&pdev->dev, "could not register SPI controller: %d\n",
 			err);
-		goto out_clk_disable;
+		goto out_dma_release;
 	}
 
 	bcm2835_debugfs_create(bs, dev_name(&pdev->dev));
 
 	return 0;
 
-out_clk_disable:
+out_dma_release:
+	bcm2835_dma_release(ctlr, bs);
 	clk_disable_unprepare(bs->clk);
 	return err;
 }
-- 
2.29.2

