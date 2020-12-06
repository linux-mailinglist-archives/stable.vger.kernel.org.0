Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970CB2D04D5
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgLFMlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFMlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:41:01 -0500
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7295BC0613D1
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 04:40:21 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 44C3E101E692D;
        Sun,  6 Dec 2020 13:40:19 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id CDB98601805A;
        Sun,  6 Dec 2020 13:40:19 +0100 (CET)
X-Mailbox-Line: From 38a1b0ab6cda2cede3f9d1a3698d336448a71573 Mon Sep 17 00:00:00 2001
Message-Id: <38a1b0ab6cda2cede3f9d1a3698d336448a71573.1607258208.git.lukas@wunner.de>
In-Reply-To: <4a3ce9b0ebf2883bc24595f444723f5dee555c3d.1607258208.git.lukas@wunner.de>
References: <4a3ce9b0ebf2883bc24595f444723f5dee555c3d.1607258208.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 6 Dec 2020 13:39:02 +0100
Subject: [PATCH 4.14-stable 3/5] spi: bcm2835: Fix use-after-free on unbind
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
index df6abc75bc16..2908df35466f 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -737,7 +737,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master) {
 		dev_err(&pdev->dev, "spi_alloc_master() failed\n");
 		return -ENOMEM;
@@ -759,23 +759,20 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 
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
@@ -803,8 +800,6 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_master_put:
-	spi_master_put(master);
 	return err;
 }
 
-- 
2.29.2

