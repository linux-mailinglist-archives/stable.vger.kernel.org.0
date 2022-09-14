Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A93B5B8395
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiINJBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiINJBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:01:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D75124951;
        Wed, 14 Sep 2022 02:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE31E61812;
        Wed, 14 Sep 2022 09:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96E2C433D6;
        Wed, 14 Sep 2022 09:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146071;
        bh=Gyqz6gWvSgQvR7dEPd2ETTNIQBE+ZsNVjs0eMRE5tmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V30QXqfq1oZCdIw07KutG8EKpswuexFMIyt7aNBA6PgKBzO2fxHdlhf0Z68r7A0Mx
         vTIgDprWXq2wh+GWJ2dr0GlRbxIRF1jOfaikGumJIsl3HWeGxtRFwALzJE+kcwggQi
         2SP2rJPQRP9HKQlQEx6yLEjG3tqjcavGlytJt+WJPIP/q1grI1p1dJ5DG0aBWjlVxp
         vG8l53lwoqsBqJhCypeqPuFQ6FGiyg7zfr4ytIE1hpvR7hDNJat/ETypq38Cd8ldP8
         YuD4CWMXsxh91sW6/V9X6UzCmAdINZ6wjKFA4K0jO0MkKhXuAWDQTvbkWZvNcVItmV
         49M+pvB6qhdmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 02/22] spi: cadence-quadspi: Disable irqs during indirect reads
Date:   Wed, 14 Sep 2022 05:00:43 -0400
Message-Id: <20220914090103.470630-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

[ Upstream commit 9ee5b6d53b8c99d13a47227e3b7052a1365556c9 ]

On architecture where reading the SRAM is slower than the pace at
controller fills it, with interrupt enabled while reading from
SRAM FIFO causes unwanted interrupt storm to CPU.

The inner "bytes to read" loop never exits and waits for the completion
so it is enough to only enable the watermark interrupt when we
are out of bytes to read, which only happens when we start the
transfer (waiting for the FIFO to fill up initially) if the SRAM
is slow.

So only using read watermark interrupt, as the current implementation
doesn't utilize the SRAM full and indirect complete read interrupt.
And disable all the read interrupts while reading from SRAM.

Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Link: https://lore.kernel.org/r/20220813042616.1372110-1-niravkumar.l.rabara@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 38 +++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 72b1a5a2298c5..e12ab5b43f341 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -39,6 +39,7 @@
 #define CQSPI_DISABLE_DAC_MODE		BIT(1)
 #define CQSPI_SUPPORT_EXTERNAL_DMA	BIT(2)
 #define CQSPI_NO_SUPPORT_WR_COMPLETION	BIT(3)
+#define CQSPI_SLOW_SRAM		BIT(4)
 
 /* Capabilities */
 #define CQSPI_SUPPORTS_OCTAL		BIT(0)
@@ -87,6 +88,7 @@ struct cqspi_st {
 	bool			use_dma_read;
 	u32			pd_dev_id;
 	bool			wr_completion;
+	bool			slow_sram;
 };
 
 struct cqspi_driver_platdata {
@@ -333,7 +335,10 @@ static irqreturn_t cqspi_irq_handler(int this_irq, void *dev)
 		}
 	}
 
-	irq_status &= CQSPI_IRQ_MASK_RD | CQSPI_IRQ_MASK_WR;
+	else if (!cqspi->slow_sram)
+		irq_status &= CQSPI_IRQ_MASK_RD | CQSPI_IRQ_MASK_WR;
+	else
+		irq_status &= CQSPI_REG_IRQ_WATERMARK | CQSPI_IRQ_MASK_WR;
 
 	if (irq_status)
 		complete(&cqspi->transfer_complete);
@@ -673,7 +678,18 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 	/* Clear all interrupts. */
 	writel(CQSPI_IRQ_STATUS_MASK, reg_base + CQSPI_REG_IRQSTATUS);
 
-	writel(CQSPI_IRQ_MASK_RD, reg_base + CQSPI_REG_IRQMASK);
+	/*
+	 * On SoCFPGA platform reading the SRAM is slow due to
+	 * hardware limitation and causing read interrupt storm to CPU,
+	 * so enabling only watermark interrupt to disable all read
+	 * interrupts later as we want to run "bytes to read" loop with
+	 * all the read interrupts disabled for max performance.
+	 */
+
+	if (!cqspi->slow_sram)
+		writel(CQSPI_IRQ_MASK_RD, reg_base + CQSPI_REG_IRQMASK);
+	else
+		writel(CQSPI_REG_IRQ_WATERMARK, reg_base + CQSPI_REG_IRQMASK);
 
 	reinit_completion(&cqspi->transfer_complete);
 	writel(CQSPI_REG_INDIRECTRD_START_MASK,
@@ -684,6 +700,13 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 						 msecs_to_jiffies(CQSPI_READ_TIMEOUT_MS)))
 			ret = -ETIMEDOUT;
 
+		/*
+		 * Disable all read interrupts until
+		 * we are out of "bytes to read"
+		 */
+		if (cqspi->slow_sram)
+			writel(0x0, reg_base + CQSPI_REG_IRQMASK);
+
 		bytes_to_read = cqspi_get_rd_sram_level(cqspi);
 
 		if (ret && bytes_to_read == 0) {
@@ -715,8 +738,11 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 			bytes_to_read = cqspi_get_rd_sram_level(cqspi);
 		}
 
-		if (remaining > 0)
+		if (remaining > 0) {
 			reinit_completion(&cqspi->transfer_complete);
+			if (cqspi->slow_sram)
+				writel(CQSPI_REG_IRQ_WATERMARK, reg_base + CQSPI_REG_IRQMASK);
+		}
 	}
 
 	/* Check indirect done status */
@@ -1667,6 +1693,8 @@ static int cqspi_probe(struct platform_device *pdev)
 			cqspi->use_dma_read = true;
 		if (ddata->quirks & CQSPI_NO_SUPPORT_WR_COMPLETION)
 			cqspi->wr_completion = false;
+		if (ddata->quirks & CQSPI_SLOW_SRAM)
+			cqspi->slow_sram = true;
 
 		if (of_device_is_compatible(pdev->dev.of_node,
 					    "xlnx,versal-ospi-1.0"))
@@ -1779,7 +1807,9 @@ static const struct cqspi_driver_platdata intel_lgm_qspi = {
 };
 
 static const struct cqspi_driver_platdata socfpga_qspi = {
-	.quirks = CQSPI_DISABLE_DAC_MODE | CQSPI_NO_SUPPORT_WR_COMPLETION,
+	.quirks = CQSPI_DISABLE_DAC_MODE
+			| CQSPI_NO_SUPPORT_WR_COMPLETION
+			| CQSPI_SLOW_SRAM,
 };
 
 static const struct cqspi_driver_platdata versal_ospi = {
-- 
2.35.1

