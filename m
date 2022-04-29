Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D09514712
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357762AbiD2Kqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357842AbiD2Kqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:46:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AABC7E85;
        Fri, 29 Apr 2022 03:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A758B8301B;
        Fri, 29 Apr 2022 10:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECC3C385A7;
        Fri, 29 Apr 2022 10:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228958;
        bh=B7TioHBEjs15QhBChEqdu1+Jdcxktbsgy5vf3tM2sBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yA+iGt5jLnt59hxAtdyAIkFY50jBD3Fg5Zm86//GF+XENd6ZcJQZpxS4eFc88yZwK
         CPkQepa6cyWKTEdkJzAUgZaKJGyzL9A7iJVrxXgAVCa7fD/KAuwxTgoSGGB8hUVUuJ
         Wv/tB8p04iGzJIb3Yx3ZdlJEk4SiJhbZQLdAUBrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Pratyush Yadav <p.yadav@ti.com>,
        Mark Brown <broonie@kernel.org>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 12/33] spi: cadence-quadspi: fix write completion support
Date:   Fri, 29 Apr 2022 12:41:59 +0200
Message-Id: <20220429104052.701673099@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 98d948eb833104a094517401ed8be26ba3ce9935 upstream.

Some versions of the Cadence QSPI controller does not have the write
completion register implemented(CQSPI_REG_WR_COMPLETION_CTRL). On the
Intel SoCFPGA platform the CQSPI_REG_WR_COMPLETION_CTRL register is
not configured.

Add a quirk to not write to the CQSPI_REG_WR_COMPLETION_CTRL register.

Fixes: 9cb2ff111712 ("spi: cadence-quadspi: Disable Auto-HW polling)
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20211108200854.3616121-1-dinguyen@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[IA: backported for linux=5.15.y]
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -36,6 +36,7 @@
 /* Quirks */
 #define CQSPI_NEEDS_WR_DELAY		BIT(0)
 #define CQSPI_DISABLE_DAC_MODE		BIT(1)
+#define CQSPI_NO_SUPPORT_WR_COMPLETION	BIT(3)
 
 /* Capabilities */
 #define CQSPI_SUPPORTS_OCTAL		BIT(0)
@@ -83,6 +84,7 @@ struct cqspi_st {
 	u32			wr_delay;
 	bool			use_direct_mode;
 	struct cqspi_flash_pdata f_pdata[CQSPI_MAX_CHIPSELECT];
+	bool			wr_completion;
 };
 
 struct cqspi_driver_platdata {
@@ -797,9 +799,11 @@ static int cqspi_write_setup(struct cqsp
 	 * polling on the controller's side. spinand and spi-nor will take
 	 * care of polling the status register.
 	 */
-	reg = readl(reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
-	reg |= CQSPI_REG_WR_DISABLE_AUTO_POLL;
-	writel(reg, reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
+	if (cqspi->wr_completion) {
+		reg = readl(reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
+		reg |= CQSPI_REG_WR_DISABLE_AUTO_POLL;
+		writel(reg, reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
+	}
 
 	reg = readl(reg_base + CQSPI_REG_SIZE);
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
@@ -1532,6 +1536,10 @@ static int cqspi_probe(struct platform_d
 
 	cqspi->master_ref_clk_hz = clk_get_rate(cqspi->clk);
 	master->max_speed_hz = cqspi->master_ref_clk_hz;
+
+	/* write completion is supported by default */
+	cqspi->wr_completion = true;
+
 	ddata  = of_device_get_match_data(dev);
 	if (ddata) {
 		if (ddata->quirks & CQSPI_NEEDS_WR_DELAY)
@@ -1541,6 +1549,8 @@ static int cqspi_probe(struct platform_d
 			master->mode_bits |= SPI_RX_OCTAL | SPI_TX_OCTAL;
 		if (!(ddata->quirks & CQSPI_DISABLE_DAC_MODE))
 			cqspi->use_direct_mode = true;
+		if (ddata->quirks & CQSPI_NO_SUPPORT_WR_COMPLETION)
+			cqspi->wr_completion = false;
 	}
 
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
@@ -1649,6 +1659,10 @@ static const struct cqspi_driver_platdat
 	.quirks = CQSPI_DISABLE_DAC_MODE,
 };
 
+static const struct cqspi_driver_platdata socfpga_qspi = {
+	.quirks = CQSPI_NO_SUPPORT_WR_COMPLETION,
+};
+
 static const struct of_device_id cqspi_dt_ids[] = {
 	{
 		.compatible = "cdns,qspi-nor",
@@ -1666,6 +1680,10 @@ static const struct of_device_id cqspi_d
 		.compatible = "intel,lgm-qspi",
 		.data = &intel_lgm_qspi,
 	},
+	{
+		.compatible = "intel,socfpga-qspi",
+		.data = (void *)&socfpga_qspi,
+	},
 	{ /* end of table */ }
 };
 


