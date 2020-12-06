Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170422D04F1
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgLFMyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:54:01 -0500
Received: from mailout2.hostsharing.net ([83.223.78.233]:54763 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFMyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:54:01 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 6303810189B63;
        Sun,  6 Dec 2020 13:53:04 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id CB6FD601805A;
        Sun,  6 Dec 2020 13:53:19 +0100 (CET)
X-Mailbox-Line: From 196d7c6ce1a7f6bb81ea6c13d94acba7c15cf473 Mon Sep 17 00:00:00 2001
Message-Id: <196d7c6ce1a7f6bb81ea6c13d94acba7c15cf473.1607259026.git.lukas@wunner.de>
In-Reply-To: <f3b2cd978df11c532658412b28eae329b99d9eec.1607259026.git.lukas@wunner.de>
References: <f3b2cd978df11c532658412b28eae329b99d9eec.1607259026.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 6 Dec 2020 13:53:01 +0100
Subject: [PATCH 4.4-stable 2/4] spi: bcm2835: Fix use-after-free on unbind
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e1483ac030fb4c57734289742f1c1d38dca61e22 ]

bcm2835_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: f8043872e796 ("spi: add driver for BCM2835")
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v3.10+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v3.10+
Cc: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/ad66e0a0ad96feb848814842ecf5b6a4539ef35c.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 27680b336454..d09a93257d65 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -742,7 +742,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master) {
 		dev_err(&pdev->dev, "spi_alloc_master() failed\n");
 		return -ENOMEM;
@@ -764,23 +764,20 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	bs->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_master_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(bs->clk)) {
 		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		goto out_master_put;
+		return err;
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);
 	if (bs->irq <= 0) {
 		dev_err(&pdev->dev, "could not get IRQ: %d\n", bs->irq);
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_master_put;
+		return bs->irq ? bs->irq : -ENODEV;
 	}
 
 	clk_prepare_enable(bs->clk);
@@ -808,8 +805,6 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_master_put:
-	spi_master_put(master);
 	return err;
 }
 
-- 
2.29.2

