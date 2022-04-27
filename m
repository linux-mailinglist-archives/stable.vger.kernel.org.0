Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32B51162F
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiD0LIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiD0LHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:07:55 -0400
Received: from smtp109.ord1d.emailsrvr.com (smtp109.ord1d.emailsrvr.com [184.106.54.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F161380BE5
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 04:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1651056873;
        bh=r0cwTPY6fhsQmVqjLsUeht0tYJOFyEkG1O1to5OlozM=;
        h=From:To:Subject:Date:From;
        b=T1K7wvNwzLE72oQFCTJ4hg7bsRXBCnnBKtuYzAvuSlOUKp/UzRJVoN93lZNgg/rsy
         ngYjsmu4m30yqJn72G0plDsKByd1dCThoQDSDH9Coj/y3C2Z3n1KSMz/U8ZOsZnYWZ
         jSNwff36A3Dmv/dAdU0v5oZkUwPaNDcwI+8r9BiM=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp6.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id DE271E00EC;
        Wed, 27 Apr 2022 06:54:31 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     stable@vger.kernel.org
Cc:     linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Pratyush Yadav <p.yadav@ti.com>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 1/2] spi: cadence-quadspi: fix write completion support
Date:   Wed, 27 Apr 2022 11:54:06 +0100
Message-Id: <20220427105407.40167-2-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427105407.40167-1-abbotti@mev.co.uk>
References: <20220427105407.40167-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 3bf3f977-eed8-458c-82a7-dc4c605c474d-2-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
---
 drivers/spi/spi-cadence-quadspi.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 1a6294a06e72..f7419511f4f6 100644
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
@@ -797,9 +799,11 @@ static int cqspi_write_setup(struct cqspi_flash_pdata *f_pdata,
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
@@ -1517,6 +1521,10 @@ static int cqspi_probe(struct platform_device *pdev)
 
 	cqspi->master_ref_clk_hz = clk_get_rate(cqspi->clk);
 	master->max_speed_hz = cqspi->master_ref_clk_hz;
+
+	/* write completion is supported by default */
+	cqspi->wr_completion = true;
+
 	ddata  = of_device_get_match_data(dev);
 	if (ddata) {
 		if (ddata->quirks & CQSPI_NEEDS_WR_DELAY)
@@ -1526,6 +1534,8 @@ static int cqspi_probe(struct platform_device *pdev)
 			master->mode_bits |= SPI_RX_OCTAL | SPI_TX_OCTAL;
 		if (!(ddata->quirks & CQSPI_DISABLE_DAC_MODE))
 			cqspi->use_direct_mode = true;
+		if (ddata->quirks & CQSPI_NO_SUPPORT_WR_COMPLETION)
+			cqspi->wr_completion = false;
 	}
 
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
@@ -1634,6 +1644,10 @@ static const struct cqspi_driver_platdata intel_lgm_qspi = {
 	.quirks = CQSPI_DISABLE_DAC_MODE,
 };
 
+static const struct cqspi_driver_platdata socfpga_qspi = {
+	.quirks = CQSPI_NO_SUPPORT_WR_COMPLETION,
+};
+
 static const struct of_device_id cqspi_dt_ids[] = {
 	{
 		.compatible = "cdns,qspi-nor",
@@ -1651,6 +1665,10 @@ static const struct of_device_id cqspi_dt_ids[] = {
 		.compatible = "intel,lgm-qspi",
 		.data = &intel_lgm_qspi,
 	},
+	{
+		.compatible = "intel,socfpga-qspi",
+		.data = (void *)&socfpga_qspi,
+	},
 	{ /* end of table */ }
 };
 
-- 
2.35.1

