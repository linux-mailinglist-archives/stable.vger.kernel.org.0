Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1791C4AA8DC
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiBEM4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:56:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45002 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379874AbiBEM4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:56:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93D4860EA9
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 12:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E11DC340E8;
        Sat,  5 Feb 2022 12:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644065809;
        bh=nV9mcA1IdExeXP+LKY8OwyeQB2vqHdZqL3/YW/4Jl+M=;
        h=Subject:To:Cc:From:Date:From;
        b=n5dAGshpfqGdtPyE0LTfsn8meDuF77lxkcA2WJ15R5uim3WZYOyn5It0GQleNQqXh
         2r3S2oBcqcreN4X5pVsAto7z5WNxDvY4rz4b1mWaqeYz4ZS3+Ch2554+s4s9mvTW3w
         nbCm3dRE4ModMK/52GugNGFO35se5cgK8sWRUeRo=
Subject: FAILED: patch "[PATCH] spi: stm32-qspi: Update spi registering" failed to apply to 5.4-stable tree
To:     patrice.chotard@foss.st.com, broonie@kernel.org, lukas@wunner.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 13:56:38 +0100
Message-ID: <164406579817225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e4d63473d3110afd170e6e0e48494d3789d26136 Mon Sep 17 00:00:00 2001
From: Patrice Chotard <patrice.chotard@foss.st.com>
Date: Mon, 17 Jan 2022 13:17:44 +0100
Subject: [PATCH] spi: stm32-qspi: Update spi registering

Some device driver need to communicate to qspi device during the remove
process, qspi controller must be functional when spi_unregister_master()
is called.

To ensure this, replace devm_spi_register_master() by spi_register_master()
and spi_unregister_master() is called directly in .remove callback before
stopping the qspi controller.

This issue was put in evidence using kernel v5.11 and later
with a spi-nor which supports the software reset feature introduced
by commit d73ee7534cc5 ("mtd: spi-nor: core: perform a Soft Reset on
shutdown")

Fixes: c530cd1d9d5e ("spi: spi-mem: add stm32 qspi controller")

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: <stable@vger.kernel.org> # 5.8.x
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/20220117121744.29729-1-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index 514337c86d2c..ffdc55f87e82 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -688,7 +688,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret, irq;
 
-	ctrl = spi_alloc_master(dev, sizeof(*qspi));
+	ctrl = devm_spi_alloc_master(dev, sizeof(*qspi));
 	if (!ctrl)
 		return -ENOMEM;
 
@@ -697,58 +697,46 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qspi");
 	qspi->io_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(qspi->io_base)) {
-		ret = PTR_ERR(qspi->io_base);
-		goto err_master_put;
-	}
+	if (IS_ERR(qspi->io_base))
+		return PTR_ERR(qspi->io_base);
 
 	qspi->phys_base = res->start;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qspi_mm");
 	qspi->mm_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(qspi->mm_base)) {
-		ret = PTR_ERR(qspi->mm_base);
-		goto err_master_put;
-	}
+	if (IS_ERR(qspi->mm_base))
+		return PTR_ERR(qspi->mm_base);
 
 	qspi->mm_size = resource_size(res);
-	if (qspi->mm_size > STM32_QSPI_MAX_MMAP_SZ) {
-		ret = -EINVAL;
-		goto err_master_put;
-	}
+	if (qspi->mm_size > STM32_QSPI_MAX_MMAP_SZ)
+		return -EINVAL;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		ret = irq;
-		goto err_master_put;
-	}
+	if (irq < 0)
+		return irq;
 
 	ret = devm_request_irq(dev, irq, stm32_qspi_irq, 0,
 			       dev_name(dev), qspi);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
-		goto err_master_put;
+		return ret;
 	}
 
 	init_completion(&qspi->data_completion);
 	init_completion(&qspi->match_completion);
 
 	qspi->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(qspi->clk)) {
-		ret = PTR_ERR(qspi->clk);
-		goto err_master_put;
-	}
+	if (IS_ERR(qspi->clk))
+		return PTR_ERR(qspi->clk);
 
 	qspi->clk_rate = clk_get_rate(qspi->clk);
-	if (!qspi->clk_rate) {
-		ret = -EINVAL;
-		goto err_master_put;
-	}
+	if (!qspi->clk_rate)
+		return -EINVAL;
 
 	ret = clk_prepare_enable(qspi->clk);
 	if (ret) {
 		dev_err(dev, "can not enable the clock\n");
-		goto err_master_put;
+		return ret;
 	}
 
 	rstc = devm_reset_control_get_exclusive(dev, NULL);
@@ -784,7 +772,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_noresume(dev);
 
-	ret = devm_spi_register_master(dev, ctrl);
+	ret = spi_register_master(ctrl);
 	if (ret)
 		goto err_pm_runtime_free;
 
@@ -806,8 +794,6 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	stm32_qspi_dma_free(qspi);
 err_clk_disable:
 	clk_disable_unprepare(qspi->clk);
-err_master_put:
-	spi_master_put(qspi->ctrl);
 
 	return ret;
 }
@@ -817,6 +803,7 @@ static int stm32_qspi_remove(struct platform_device *pdev)
 	struct stm32_qspi *qspi = platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(qspi->dev);
+	spi_unregister_master(qspi->ctrl);
 	/* disable qspi */
 	writel_relaxed(0, qspi->io_base + QSPI_CR);
 	stm32_qspi_dma_free(qspi);

