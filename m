Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E632C9B5F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgLAJHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbgLAJHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC74206D8;
        Tue,  1 Dec 2020 09:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813643;
        bh=qYfa4oSFlu5hO8s1dC0SHGIj90Gzg0ib2jMS1cSYg8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsWe5uSrbOwMtKcJoU/0UZ13EWhdX9uu2dnYS/T47tZ4/ZLjfLKyCxCsn3+U219UI
         IvxTWRR/1iy1obASM/h+6RAl7wJcLkjYRuLqcwjpxc/uYfXMjmpIrEljxrnidqEkTF
         romzEQ50bk0q79voen2M3cNOmakMovbS5PJQlHeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.9 003/152] spi: bcm-qspi: Fix use-after-free on unbind
Date:   Tue,  1 Dec 2020 09:51:58 +0100
Message-Id: <20201201084712.110575812@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 63c5395bb7a9777a33f0e7b5906f2c0170a23692 upstream

bcm_qspi_remove() calls spi_unregister_master() even though
bcm_qspi_probe() calls devm_spi_register_master().  The spi_master is
therefore unregistered and freed twice on unbind.

Moreover, since commit 0392727c261b ("spi: bcm-qspi: Handle clock probe
deferral"), bcm_qspi_probe() leaks the spi_master allocation if the call
to devm_clk_get_optional() fails.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound and also
avoids the spi_master leak on probe.

While at it, fix an ordering issue in bcm_qspi_remove() wherein
spi_unregister_master() is called after uninitializing the hardware,
disabling the clock and freeing an IRQ data structure.  The correct
order is to call spi_unregister_master() *before* those teardown steps
because bus accesses may still be ongoing until that function returns.

Fixes: fa236a7ef240 ("spi: bcm-qspi: Add Broadcom MSPI driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.9+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/5e31a9a59fd1c0d0b795b2fe219f25e5ee855f9d.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm-qspi.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1334,7 +1334,7 @@ int bcm_qspi_probe(struct platform_devic
 
 	data = of_id->data;
 
-	master = spi_alloc_master(dev, sizeof(struct bcm_qspi));
+	master = devm_spi_alloc_master(dev, sizeof(struct bcm_qspi));
 	if (!master) {
 		dev_err(dev, "error allocating spi_master\n");
 		return -ENOMEM;
@@ -1374,21 +1374,17 @@ int bcm_qspi_probe(struct platform_devic
 
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
@@ -1399,18 +1395,14 @@ int bcm_qspi_probe(struct platform_devic
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
@@ -1491,7 +1483,7 @@ int bcm_qspi_probe(struct platform_devic
 	qspi->xfer_mode.addrlen = -1;
 	qspi->xfer_mode.hp = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(dev, "can't register master\n");
 		goto qspi_reg_err;
@@ -1504,8 +1496,6 @@ qspi_reg_err:
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-qspi_resource_err:
-	spi_master_put(master);
 	return ret;
 }
 /* probe function to be called by SoC specific platform driver probe */
@@ -1515,10 +1505,10 @@ int bcm_qspi_remove(struct platform_devi
 {
 	struct bcm_qspi *qspi = platform_get_drvdata(pdev);
 
+	spi_unregister_master(qspi->master);
 	bcm_qspi_hw_uninit(qspi);
 	clk_disable_unprepare(qspi->clk);
 	kfree(qspi->dev_ids);
-	spi_unregister_master(qspi->master);
 
 	return 0;
 }


