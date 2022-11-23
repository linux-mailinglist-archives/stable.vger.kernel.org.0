Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1D16356BF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiKWJeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbiKWJdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:33:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FA910CEB0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C545B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1FAC433D6;
        Wed, 23 Nov 2022 09:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195902;
        bh=NZnXs1/bhZXCRx/knemX2qzzGLddsS6nwRlsfnHJXM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjctwO1P8sVbUzsUg0bwtDxUCWLT7CaWU6c8CU3mhehgmRLpPYBbG+7omH/snJeBi
         skFUcDRDcIuN9dPFt6KE6pRQUfDUIANHsY1ju8Rc+DxsvHu/pz1JkxFIUznr6ea6qv
         z22m7JvCEsPJsi9B/bbwWS/qLR/uN3Nxe+u/Xg98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Lima <mauro.lima@eclypsium.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/181] mtd: spi-nor: intel-spi: Disable write protection only if asked
Date:   Wed, 23 Nov 2022 09:49:57 +0100
Message-Id: <20221123084603.856922446@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit cd149eff8d2201a63c074a6d9d03e52926aa535d ]

Currently the driver tries to disable the BIOS write protection
automatically even if this is not what the user wants. For this reason
modify the driver so that by default it does not touch the write
protection. Only if specifically asked by the user (setting writeable=1
command line parameter) the driver tries to disable the BIOS write
protection.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mauro Lima <mauro.lima@eclypsium.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220209122706.42439-2-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 92a66cbf6b30 ("spi: intel: Use correct mask for flash and protected regions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/lpc_ich.c                         | 59 +++++++++++++++++--
 .../mtd/spi-nor/controllers/intel-spi-pci.c   | 29 +++++----
 drivers/mtd/spi-nor/controllers/intel-spi.c   | 41 ++++++-------
 include/linux/platform_data/x86/intel-spi.h   |  6 +-
 4 files changed, 96 insertions(+), 39 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index f10e53187f67..9ffab9aafd81 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -63,6 +63,8 @@
 #define SPIBASE_BYT		0x54
 #define SPIBASE_BYT_SZ		512
 #define SPIBASE_BYT_EN		BIT(1)
+#define BYT_BCR			0xfc
+#define BYT_BCR_WPD		BIT(0)
 
 #define SPIBASE_LPT		0x3800
 #define SPIBASE_LPT_SZ		512
@@ -1084,12 +1086,57 @@ static int lpc_ich_init_wdt(struct pci_dev *dev)
 	return ret;
 }
 
+static bool lpc_ich_byt_set_writeable(void __iomem *base, void *data)
+{
+	u32 val;
+
+	val = readl(base + BYT_BCR);
+	if (!(val & BYT_BCR_WPD)) {
+		val |= BYT_BCR_WPD;
+		writel(val, base + BYT_BCR);
+		val = readl(base + BYT_BCR);
+	}
+
+	return val & BYT_BCR_WPD;
+}
+
+static bool lpc_ich_lpt_set_writeable(void __iomem *base, void *data)
+{
+	struct pci_dev *pdev = data;
+	u32 bcr;
+
+	pci_read_config_dword(pdev, BCR, &bcr);
+	if (!(bcr & BCR_WPD)) {
+		bcr |= BCR_WPD;
+		pci_write_config_dword(pdev, BCR, bcr);
+		pci_read_config_dword(pdev, BCR, &bcr);
+	}
+
+	return bcr & BCR_WPD;
+}
+
+static bool lpc_ich_bxt_set_writeable(void __iomem *base, void *data)
+{
+	unsigned int spi = PCI_DEVFN(13, 2);
+	struct pci_bus *bus = data;
+	u32 bcr;
+
+	pci_bus_read_config_dword(bus, spi, BCR, &bcr);
+	if (!(bcr & BCR_WPD)) {
+		bcr |= BCR_WPD;
+		pci_bus_write_config_dword(bus, spi, BCR, bcr);
+		pci_bus_read_config_dword(bus, spi, BCR, &bcr);
+	}
+
+	return bcr & BCR_WPD;
+}
+
 static int lpc_ich_init_spi(struct pci_dev *dev)
 {
 	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	struct resource *res = &intel_spi_res[0];
 	struct intel_spi_boardinfo *info;
-	u32 spi_base, rcba, bcr;
+	u32 spi_base, rcba;
 
 	info = devm_kzalloc(&dev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -1103,6 +1150,8 @@ static int lpc_ich_init_spi(struct pci_dev *dev)
 		if (spi_base & SPIBASE_BYT_EN) {
 			res->start = spi_base & ~(SPIBASE_BYT_SZ - 1);
 			res->end = res->start + SPIBASE_BYT_SZ - 1;
+
+			info->set_writeable = lpc_ich_byt_set_writeable;
 		}
 		break;
 
@@ -1113,8 +1162,8 @@ static int lpc_ich_init_spi(struct pci_dev *dev)
 			res->start = spi_base + SPIBASE_LPT;
 			res->end = res->start + SPIBASE_LPT_SZ - 1;
 
-			pci_read_config_dword(dev, BCR, &bcr);
-			info->writeable = !!(bcr & BCR_WPD);
+			info->set_writeable = lpc_ich_lpt_set_writeable;
+			info->data = dev;
 		}
 		break;
 
@@ -1135,8 +1184,8 @@ static int lpc_ich_init_spi(struct pci_dev *dev)
 			res->start = spi_base & 0xfffffff0;
 			res->end = res->start + SPIBASE_APL_SZ - 1;
 
-			pci_bus_read_config_dword(bus, spi, BCR, &bcr);
-			info->writeable = !!(bcr & BCR_WPD);
+			info->set_writeable = lpc_ich_bxt_set_writeable;
+			info->data = bus;
 		}
 
 		pci_bus_write_config_byte(bus, p2sb, 0xe1, 0x1);
diff --git a/drivers/mtd/spi-nor/controllers/intel-spi-pci.c b/drivers/mtd/spi-nor/controllers/intel-spi-pci.c
index 1bc53b8bb88a..508f7ca098ef 100644
--- a/drivers/mtd/spi-nor/controllers/intel-spi-pci.c
+++ b/drivers/mtd/spi-nor/controllers/intel-spi-pci.c
@@ -16,12 +16,30 @@
 #define BCR		0xdc
 #define BCR_WPD		BIT(0)
 
+static bool intel_spi_pci_set_writeable(void __iomem *base, void *data)
+{
+	struct pci_dev *pdev = data;
+	u32 bcr;
+
+	/* Try to make the chip read/write */
+	pci_read_config_dword(pdev, BCR, &bcr);
+	if (!(bcr & BCR_WPD)) {
+		bcr |= BCR_WPD;
+		pci_write_config_dword(pdev, BCR, bcr);
+		pci_read_config_dword(pdev, BCR, &bcr);
+	}
+
+	return bcr & BCR_WPD;
+}
+
 static const struct intel_spi_boardinfo bxt_info = {
 	.type = INTEL_SPI_BXT,
+	.set_writeable = intel_spi_pci_set_writeable,
 };
 
 static const struct intel_spi_boardinfo cnl_info = {
 	.type = INTEL_SPI_CNL,
+	.set_writeable = intel_spi_pci_set_writeable,
 };
 
 static int intel_spi_pci_probe(struct pci_dev *pdev,
@@ -29,7 +47,6 @@ static int intel_spi_pci_probe(struct pci_dev *pdev,
 {
 	struct intel_spi_boardinfo *info;
 	struct intel_spi *ispi;
-	u32 bcr;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -41,15 +58,7 @@ static int intel_spi_pci_probe(struct pci_dev *pdev,
 	if (!info)
 		return -ENOMEM;
 
-	/* Try to make the chip read/write */
-	pci_read_config_dword(pdev, BCR, &bcr);
-	if (!(bcr & BCR_WPD)) {
-		bcr |= BCR_WPD;
-		pci_write_config_dword(pdev, BCR, bcr);
-		pci_read_config_dword(pdev, BCR, &bcr);
-	}
-	info->writeable = !!(bcr & BCR_WPD);
-
+	info->data = pdev;
 	ispi = intel_spi_probe(&pdev->dev, &pdev->resource[0], info);
 	if (IS_ERR(ispi))
 		return PTR_ERR(ispi);
diff --git a/drivers/mtd/spi-nor/controllers/intel-spi.c b/drivers/mtd/spi-nor/controllers/intel-spi.c
index 72dab5937df1..2b91249a4c3f 100644
--- a/drivers/mtd/spi-nor/controllers/intel-spi.c
+++ b/drivers/mtd/spi-nor/controllers/intel-spi.c
@@ -131,7 +131,6 @@
  * @sregs: Start of software sequencer registers
  * @nregions: Maximum number of regions
  * @pr_num: Maximum number of protected range registers
- * @writeable: Is the chip writeable
  * @locked: Is SPI setting locked
  * @swseq_reg: Use SW sequencer in register reads/writes
  * @swseq_erase: Use SW sequencer in erase operation
@@ -149,7 +148,6 @@ struct intel_spi {
 	void __iomem *sregs;
 	size_t nregions;
 	size_t pr_num;
-	bool writeable;
 	bool locked;
 	bool swseq_reg;
 	bool swseq_erase;
@@ -304,6 +302,14 @@ static int intel_spi_wait_sw_busy(struct intel_spi *ispi)
 				  INTEL_SPI_TIMEOUT * 1000);
 }
 
+static bool intel_spi_set_writeable(struct intel_spi *ispi)
+{
+	if (!ispi->info->set_writeable)
+		return false;
+
+	return ispi->info->set_writeable(ispi->base, ispi->info->data);
+}
+
 static int intel_spi_init(struct intel_spi *ispi)
 {
 	u32 opmenu0, opmenu1, lvscc, uvscc, val;
@@ -316,19 +322,6 @@ static int intel_spi_init(struct intel_spi *ispi)
 		ispi->nregions = BYT_FREG_NUM;
 		ispi->pr_num = BYT_PR_NUM;
 		ispi->swseq_reg = true;
-
-		if (writeable) {
-			/* Disable write protection */
-			val = readl(ispi->base + BYT_BCR);
-			if (!(val & BYT_BCR_WPD)) {
-				val |= BYT_BCR_WPD;
-				writel(val, ispi->base + BYT_BCR);
-				val = readl(ispi->base + BYT_BCR);
-			}
-
-			ispi->writeable = !!(val & BYT_BCR_WPD);
-		}
-
 		break;
 
 	case INTEL_SPI_LPT:
@@ -358,6 +351,12 @@ static int intel_spi_init(struct intel_spi *ispi)
 		return -EINVAL;
 	}
 
+	/* Try to disable write protection if user asked to do so */
+	if (writeable && !intel_spi_set_writeable(ispi)) {
+		dev_warn(ispi->dev, "can't disable chip write protection\n");
+		writeable = false;
+	}
+
 	/* Disable #SMI generation from HW sequencer */
 	val = readl(ispi->base + HSFSTS_CTL);
 	val &= ~HSFSTS_CTL_FSMIE;
@@ -884,9 +883,12 @@ static void intel_spi_fill_partition(struct intel_spi *ispi,
 		/*
 		 * If any of the regions have protection bits set, make the
 		 * whole partition read-only to be on the safe side.
+		 *
+		 * Also if the user did not ask the chip to be writeable
+		 * mask the bit too.
 		 */
-		if (intel_spi_is_protected(ispi, base, limit))
-			ispi->writeable = false;
+		if (!writeable || intel_spi_is_protected(ispi, base, limit))
+			part->mask_flags |= MTD_WRITEABLE;
 
 		end = (limit << 12) + 4096;
 		if (end > part->size)
@@ -927,7 +929,6 @@ struct intel_spi *intel_spi_probe(struct device *dev,
 
 	ispi->dev = dev;
 	ispi->info = info;
-	ispi->writeable = info->writeable;
 
 	ret = intel_spi_init(ispi);
 	if (ret)
@@ -945,10 +946,6 @@ struct intel_spi *intel_spi_probe(struct device *dev,
 
 	intel_spi_fill_partition(ispi, &part);
 
-	/* Prevent writes if not explicitly enabled */
-	if (!ispi->writeable || !writeable)
-		ispi->nor.mtd.flags &= ~MTD_WRITEABLE;
-
 	ret = mtd_device_register(&ispi->nor.mtd, &part, 1);
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/include/linux/platform_data/x86/intel-spi.h b/include/linux/platform_data/x86/intel-spi.h
index 7f53a5c6f35e..7dda3f690465 100644
--- a/include/linux/platform_data/x86/intel-spi.h
+++ b/include/linux/platform_data/x86/intel-spi.h
@@ -19,11 +19,13 @@ enum intel_spi_type {
 /**
  * struct intel_spi_boardinfo - Board specific data for Intel SPI driver
  * @type: Type which this controller is compatible with
- * @writeable: The chip is writeable
+ * @set_writeable: Try to make the chip writeable (optional)
+ * @data: Data to be passed to @set_writeable can be %NULL
  */
 struct intel_spi_boardinfo {
 	enum intel_spi_type type;
-	bool writeable;
+	bool (*set_writeable)(void __iomem *base, void *data);
+	void *data;
 };
 
 #endif /* INTEL_SPI_PDATA_H */
-- 
2.35.1



