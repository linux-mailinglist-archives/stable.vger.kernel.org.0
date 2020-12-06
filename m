Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067832D04E0
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgLFMrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:47:42 -0500
Received: from mailout3.hostsharing.net ([176.9.242.54]:44505 "EHLO
        mailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFMrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:47:42 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 847BE100A8780;
        Sun,  6 Dec 2020 13:46:59 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 1439D6040B59;
        Sun,  6 Dec 2020 13:47:00 +0100 (CET)
X-Mailbox-Line: From 43e6aab6ac72a313046cf2db3b823db32a71a885 Mon Sep 17 00:00:00 2001
Message-Id: <43e6aab6ac72a313046cf2db3b823db32a71a885.1607258638.git.lukas@wunner.de>
In-Reply-To: <6b95ef1dc97d62b2927f1ac81514a323da0e8aaf.1607258637.git.lukas@wunner.de>
References: <6b95ef1dc97d62b2927f1ac81514a323da0e8aaf.1607258637.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 6 Dec 2020 13:46:04 +0100
Subject: [PATCH 4.9-stable 5/5] spi: bcm2835: Release the DMA channel if probe
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
[lukas: backport to 4.19-stable]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/spi/spi-bcm2835.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 2908df35466f..6824beae18e4 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -787,18 +787,19 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 			       dev_name(&pdev->dev), master);
 	if (err) {
 		dev_err(&pdev->dev, "could not request IRQ: %d\n", err);
-		goto out_clk_disable;
+		goto out_dma_release;
 	}
 
 	err = spi_register_master(master);
 	if (err) {
 		dev_err(&pdev->dev, "could not register SPI master: %d\n", err);
-		goto out_clk_disable;
+		goto out_dma_release;
 	}
 
 	return 0;
 
-out_clk_disable:
+out_dma_release:
+	bcm2835_dma_release(master);
 	clk_disable_unprepare(bs->clk);
 	return err;
 }
-- 
2.29.2

