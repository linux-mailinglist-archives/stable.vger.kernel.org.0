Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4725D4ABC9A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386920AbiBGLiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385612AbiBGLcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C4DC03CA49;
        Mon,  7 Feb 2022 03:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E159B80EBD;
        Mon,  7 Feb 2022 11:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A95CC004E1;
        Mon,  7 Feb 2022 11:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233467;
        bh=OOrci6zsJTgNVekK33PRhoxSHZ4Cd74TJOKyCSGkGLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqs8VEO2XbAtpdbdgmxIuQJ+mid9ZZWNHVkkh2CZumU7zbcuAkaRm7nD2hTP4tlJW
         EDZ4niGYFjFVJ/iiSxldY1qcAX2c6913eIYFfUiRf0CYw2ufL+RgH29LHJcjeJjkgX
         x1QHuztrcbY4EUSFm6HQmRg5lqITBdxFne/TKmVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Lukas Wunner <lukas@wunner.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 005/126] spi: stm32-qspi: Update spi registering
Date:   Mon,  7 Feb 2022 12:05:36 +0100
Message-Id: <20220207103804.249514249@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit e4d63473d3110afd170e6e0e48494d3789d26136 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-stm32-qspi.c |   47 +++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -688,7 +688,7 @@ static int stm32_qspi_probe(struct platf
 	struct resource *res;
 	int ret, irq;
 
-	ctrl = spi_alloc_master(dev, sizeof(*qspi));
+	ctrl = devm_spi_alloc_master(dev, sizeof(*qspi));
 	if (!ctrl)
 		return -ENOMEM;
 
@@ -697,58 +697,46 @@ static int stm32_qspi_probe(struct platf
 
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
@@ -784,7 +772,7 @@ static int stm32_qspi_probe(struct platf
 	pm_runtime_enable(dev);
 	pm_runtime_get_noresume(dev);
 
-	ret = devm_spi_register_master(dev, ctrl);
+	ret = spi_register_master(ctrl);
 	if (ret)
 		goto err_pm_runtime_free;
 
@@ -806,8 +794,6 @@ err_dma_free:
 	stm32_qspi_dma_free(qspi);
 err_clk_disable:
 	clk_disable_unprepare(qspi->clk);
-err_master_put:
-	spi_master_put(qspi->ctrl);
 
 	return ret;
 }
@@ -817,6 +803,7 @@ static int stm32_qspi_remove(struct plat
 	struct stm32_qspi *qspi = platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(qspi->dev);
+	spi_unregister_master(qspi->ctrl);
 	/* disable qspi */
 	writel_relaxed(0, qspi->io_base + QSPI_CR);
 	stm32_qspi_dma_free(qspi);


