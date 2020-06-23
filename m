Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB9F206241
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390976AbgFWU5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392415AbgFWUmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B0021D7D;
        Tue, 23 Jun 2020 20:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944942;
        bh=QzpldxtyamB1Q3zYcmu6cFKBfKAhkF3H7FaDzVX+mgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vky1b4iZlOUIsEuTZlTix/W41l+g4SnRgacYO0MyY8DMVtqE+NLhUEJc2w4UUIGuv
         gEAq2wBFPZRqSQVj2Soqs3d7qrZ+z2pMI2QezbrMkBsdeAHDUB85MbwvT1ZV6zT0so
         nc0rQMJ3I+OSMrW66cdshsarQozPM5bKa5VR8g7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/206] mtd: rawnand: Pass a nand_chip object to nand_release()
Date:   Tue, 23 Jun 2020 21:58:32 +0200
Message-Id: <20200623195326.089982292@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@bootlin.com>

[ Upstream commit 59ac276f22270fb2094910f9a734c17f41c25e70 ]

Let's make the raw NAND API consistent by patching all helpers to
take a nand_chip object instead of an mtd_info one.

Now is nand_release()'s turn.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/mtdnand.rst       | 2 +-
 drivers/mtd/nand/raw/ams-delta.c           | 2 +-
 drivers/mtd/nand/raw/au1550nd.c            | 2 +-
 drivers/mtd/nand/raw/bcm47xxnflash/main.c  | 2 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c   | 2 +-
 drivers/mtd/nand/raw/cafe_nand.c           | 2 +-
 drivers/mtd/nand/raw/cmx270_nand.c         | 2 +-
 drivers/mtd/nand/raw/cs553x_nand.c         | 2 +-
 drivers/mtd/nand/raw/davinci_nand.c        | 2 +-
 drivers/mtd/nand/raw/denali.c              | 4 +---
 drivers/mtd/nand/raw/diskonchip.c          | 4 ++--
 drivers/mtd/nand/raw/docg4.c               | 2 +-
 drivers/mtd/nand/raw/fsl_elbc_nand.c       | 3 +--
 drivers/mtd/nand/raw/fsl_ifc_nand.c        | 3 +--
 drivers/mtd/nand/raw/fsl_upm.c             | 2 +-
 drivers/mtd/nand/raw/fsmc_nand.c           | 2 +-
 drivers/mtd/nand/raw/gpio.c                | 2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
 drivers/mtd/nand/raw/hisi504_nand.c        | 3 +--
 drivers/mtd/nand/raw/jz4740_nand.c         | 2 +-
 drivers/mtd/nand/raw/jz4780_nand.c         | 4 ++--
 drivers/mtd/nand/raw/lpc32xx_mlc.c         | 3 +--
 drivers/mtd/nand/raw/lpc32xx_slc.c         | 3 +--
 drivers/mtd/nand/raw/marvell_nand.c        | 4 ++--
 drivers/mtd/nand/raw/mpc5121_nfc.c         | 2 +-
 drivers/mtd/nand/raw/mtk_nand.c            | 4 ++--
 drivers/mtd/nand/raw/mxc_nand.c            | 2 +-
 drivers/mtd/nand/raw/nand_base.c           | 8 ++++----
 drivers/mtd/nand/raw/nandsim.c             | 4 ++--
 drivers/mtd/nand/raw/ndfc.c                | 2 +-
 drivers/mtd/nand/raw/nuc900_nand.c         | 2 +-
 drivers/mtd/nand/raw/omap2.c               | 2 +-
 drivers/mtd/nand/raw/orion_nand.c          | 5 ++---
 drivers/mtd/nand/raw/oxnas_nand.c          | 4 ++--
 drivers/mtd/nand/raw/pasemi_nand.c         | 2 +-
 drivers/mtd/nand/raw/plat_nand.c           | 4 ++--
 drivers/mtd/nand/raw/qcom_nandc.c          | 2 +-
 drivers/mtd/nand/raw/r852.c                | 4 ++--
 drivers/mtd/nand/raw/s3c2410.c             | 2 +-
 drivers/mtd/nand/raw/sh_flctl.c            | 2 +-
 drivers/mtd/nand/raw/sharpsl.c             | 4 ++--
 drivers/mtd/nand/raw/socrates_nand.c       | 5 ++---
 drivers/mtd/nand/raw/sunxi_nand.c          | 4 ++--
 drivers/mtd/nand/raw/tango_nand.c          | 2 +-
 drivers/mtd/nand/raw/tmio_nand.c           | 4 ++--
 drivers/mtd/nand/raw/txx9ndfmc.c           | 2 +-
 drivers/mtd/nand/raw/vf610_nfc.c           | 2 +-
 drivers/mtd/nand/raw/xway_nand.c           | 4 ++--
 include/linux/mtd/rawnand.h                | 2 +-
 49 files changed, 66 insertions(+), 75 deletions(-)

diff --git a/Documentation/driver-api/mtdnand.rst b/Documentation/driver-api/mtdnand.rst
index 1ab6f35b64108..5470a3d6bd9ea 100644
--- a/Documentation/driver-api/mtdnand.rst
+++ b/Documentation/driver-api/mtdnand.rst
@@ -277,7 +277,7 @@ unregisters the partitions in the MTD layer.
     static void __exit board_cleanup (void)
     {
         /* Release resources, unregister device */
-        nand_release (board_mtd);
+        nand_release (mtd_to_nand(board_mtd));
 
         /* unmap physical address */
         iounmap(baseaddr);
diff --git a/drivers/mtd/nand/raw/ams-delta.c b/drivers/mtd/nand/raw/ams-delta.c
index 24ba7296ec08c..acf7971e815df 100644
--- a/drivers/mtd/nand/raw/ams-delta.c
+++ b/drivers/mtd/nand/raw/ams-delta.c
@@ -264,7 +264,7 @@ static int ams_delta_cleanup(struct platform_device *pdev)
 	void __iomem *io_base = platform_get_drvdata(pdev);
 
 	/* Release resources, unregister device */
-	nand_release(ams_delta_mtd);
+	nand_release(mtd_to_nand(ams_delta_mtd));
 
 	gpio_free_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
 	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
diff --git a/drivers/mtd/nand/raw/au1550nd.c b/drivers/mtd/nand/raw/au1550nd.c
index afc1e812e80d9..b45fb36537e7e 100644
--- a/drivers/mtd/nand/raw/au1550nd.c
+++ b/drivers/mtd/nand/raw/au1550nd.c
@@ -492,7 +492,7 @@ static int au1550nd_remove(struct platform_device *pdev)
 	struct au1550nd_ctx *ctx = platform_get_drvdata(pdev);
 	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	nand_release(nand_to_mtd(&ctx->chip));
+	nand_release(&ctx->chip);
 	iounmap(ctx->base);
 	release_mem_region(r->start, 0x1000);
 	kfree(ctx);
diff --git a/drivers/mtd/nand/raw/bcm47xxnflash/main.c b/drivers/mtd/nand/raw/bcm47xxnflash/main.c
index fb31429b70a9a..d796941608457 100644
--- a/drivers/mtd/nand/raw/bcm47xxnflash/main.c
+++ b/drivers/mtd/nand/raw/bcm47xxnflash/main.c
@@ -65,7 +65,7 @@ static int bcm47xxnflash_remove(struct platform_device *pdev)
 {
 	struct bcm47xxnflash *nflash = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&nflash->nand_chip));
+	nand_release(&nflash->nand_chip);
 
 	return 0;
 }
diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index edf7447a0cd54..bd20f4521036f 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2619,7 +2619,7 @@ int brcmnand_remove(struct platform_device *pdev)
 	struct brcmnand_host *host;
 
 	list_for_each_entry(host, &ctrl->host_list, node)
-		nand_release(nand_to_mtd(&host->chip));
+		nand_release(&host->chip);
 
 	clk_disable_unprepare(ctrl->clk);
 
diff --git a/drivers/mtd/nand/raw/cafe_nand.c b/drivers/mtd/nand/raw/cafe_nand.c
index e497b95d624e2..3304594177c6d 100644
--- a/drivers/mtd/nand/raw/cafe_nand.c
+++ b/drivers/mtd/nand/raw/cafe_nand.c
@@ -819,7 +819,7 @@ static void cafe_nand_remove(struct pci_dev *pdev)
 	/* Disable NAND IRQ in global IRQ mask register */
 	cafe_writel(cafe, ~1 & cafe_readl(cafe, GLOBAL_IRQ_MASK), GLOBAL_IRQ_MASK);
 	free_irq(pdev->irq, mtd);
-	nand_release(mtd);
+	nand_release(chip);
 	free_rs(cafe->rs);
 	pci_iounmap(pdev, cafe->mmio);
 	dma_free_coherent(&cafe->pdev->dev, 2112, cafe->dmabuf, cafe->dmaaddr);
diff --git a/drivers/mtd/nand/raw/cmx270_nand.c b/drivers/mtd/nand/raw/cmx270_nand.c
index e92c0f113eb34..2eb933a8f99eb 100644
--- a/drivers/mtd/nand/raw/cmx270_nand.c
+++ b/drivers/mtd/nand/raw/cmx270_nand.c
@@ -228,7 +228,7 @@ module_init(cmx270_init);
 static void __exit cmx270_cleanup(void)
 {
 	/* Release resources, unregister device */
-	nand_release(cmx270_nand_mtd);
+	nand_release(mtd_to_nand(cmx270_nand_mtd));
 
 	gpio_free(GPIO_NAND_RB);
 	gpio_free(GPIO_NAND_CS);
diff --git a/drivers/mtd/nand/raw/cs553x_nand.c b/drivers/mtd/nand/raw/cs553x_nand.c
index 4065bcd12e64f..d4be416bb2faa 100644
--- a/drivers/mtd/nand/raw/cs553x_nand.c
+++ b/drivers/mtd/nand/raw/cs553x_nand.c
@@ -336,7 +336,7 @@ static void __exit cs553x_cleanup(void)
 		mmio_base = this->IO_ADDR_R;
 
 		/* Release resources, unregister device */
-		nand_release(mtd);
+		nand_release(this);
 		kfree(mtd->name);
 		cs553x_mtd[i] = NULL;
 
diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index 1021624195f7a..66d3d59660138 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -841,7 +841,7 @@ static int nand_davinci_remove(struct platform_device *pdev)
 		ecc4_busy = false;
 	spin_unlock_irq(&davinci_nand_lock);
 
-	nand_release(nand_to_mtd(&info->chip));
+	nand_release(&info->chip);
 
 	return 0;
 }
diff --git a/drivers/mtd/nand/raw/denali.c b/drivers/mtd/nand/raw/denali.c
index d16581b117ce9..277e84aa6166a 100644
--- a/drivers/mtd/nand/raw/denali.c
+++ b/drivers/mtd/nand/raw/denali.c
@@ -1407,9 +1407,7 @@ EXPORT_SYMBOL(denali_init);
 
 void denali_remove(struct denali_nand_info *denali)
 {
-	struct mtd_info *mtd = nand_to_mtd(&denali->nand);
-
-	nand_release(mtd);
+	nand_release(&denali->nand);
 	denali_disable_irq(denali);
 }
 EXPORT_SYMBOL(denali_remove);
diff --git a/drivers/mtd/nand/raw/diskonchip.c b/drivers/mtd/nand/raw/diskonchip.c
index 9159748a2ef0c..43d1e08133ceb 100644
--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -1627,7 +1627,7 @@ static int __init doc_probe(unsigned long physadr)
 		/* nand_release will call mtd_device_unregister, but we
 		   haven't yet added it.  This is handled without incident by
 		   mtd_device_unregister, as far as I can tell. */
-		nand_release(mtd);
+		nand_release(nand);
 		goto fail;
 	}
 
@@ -1662,7 +1662,7 @@ static void release_nanddoc(void)
 		doc = nand_get_controller_data(nand);
 
 		nextmtd = doc->nextdoc;
-		nand_release(mtd);
+		nand_release(nand);
 		iounmap(doc->virtadr);
 		release_mem_region(doc->physadr, DOC_IOREMAP_LEN);
 		free_rs(doc->rs_decoder);
diff --git a/drivers/mtd/nand/raw/docg4.c b/drivers/mtd/nand/raw/docg4.c
index 69f60755f38a4..2d86bc5a886df 100644
--- a/drivers/mtd/nand/raw/docg4.c
+++ b/drivers/mtd/nand/raw/docg4.c
@@ -1420,7 +1420,7 @@ static int __init probe_docg4(struct platform_device *pdev)
 static int __exit cleanup_docg4(struct platform_device *pdev)
 {
 	struct docg4_priv *doc = platform_get_drvdata(pdev);
-	nand_release(doc->mtd);
+	nand_release(mtd_to_nand(doc->mtd));
 	kfree(mtd_to_nand(doc->mtd));
 	iounmap(doc->virtadr);
 	return 0;
diff --git a/drivers/mtd/nand/raw/fsl_elbc_nand.c b/drivers/mtd/nand/raw/fsl_elbc_nand.c
index 541343d142e06..22bcd64a66c82 100644
--- a/drivers/mtd/nand/raw/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_elbc_nand.c
@@ -942,9 +942,8 @@ static int fsl_elbc_nand_remove(struct platform_device *pdev)
 {
 	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = fsl_lbc_ctrl_dev->nand;
 	struct fsl_elbc_mtd *priv = dev_get_drvdata(&pdev->dev);
-	struct mtd_info *mtd = nand_to_mtd(&priv->chip);
 
-	nand_release(mtd);
+	nand_release(&priv->chip);
 	fsl_elbc_chip_remove(priv);
 
 	mutex_lock(&fsl_elbc_nand_mutex);
diff --git a/drivers/mtd/nand/raw/fsl_ifc_nand.c b/drivers/mtd/nand/raw/fsl_ifc_nand.c
index ad010c72df789..70bf8e1552a5a 100644
--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -1105,9 +1105,8 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
 static int fsl_ifc_nand_remove(struct platform_device *dev)
 {
 	struct fsl_ifc_mtd *priv = dev_get_drvdata(&dev->dev);
-	struct mtd_info *mtd = nand_to_mtd(&priv->chip);
 
-	nand_release(mtd);
+	nand_release(&priv->chip);
 	fsl_ifc_chip_remove(priv);
 
 	mutex_lock(&fsl_ifc_nand_mutex);
diff --git a/drivers/mtd/nand/raw/fsl_upm.c b/drivers/mtd/nand/raw/fsl_upm.c
index b45c9940f9c05..2763fd3ad5122 100644
--- a/drivers/mtd/nand/raw/fsl_upm.c
+++ b/drivers/mtd/nand/raw/fsl_upm.c
@@ -326,7 +326,7 @@ static int fun_remove(struct platform_device *ofdev)
 	struct mtd_info *mtd = nand_to_mtd(&fun->chip);
 	int i;
 
-	nand_release(mtd);
+	nand_release(&fun->chip);
 	kfree(mtd->name);
 
 	for (i = 0; i < fun->mchip_count; i++) {
diff --git a/drivers/mtd/nand/raw/fsmc_nand.c b/drivers/mtd/nand/raw/fsmc_nand.c
index 9991e3b8e2376..25d354e9448ec 100644
--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -1161,7 +1161,7 @@ static int fsmc_nand_remove(struct platform_device *pdev)
 	struct fsmc_nand_data *host = platform_get_drvdata(pdev);
 
 	if (host) {
-		nand_release(nand_to_mtd(&host->nand));
+		nand_release(&host->nand);
 
 		if (host->mode == USE_DMA_ACCESS) {
 			dma_release_channel(host->write_dma_chan);
diff --git a/drivers/mtd/nand/raw/gpio.c b/drivers/mtd/nand/raw/gpio.c
index 983d3be480193..0e7d00faf33ca 100644
--- a/drivers/mtd/nand/raw/gpio.c
+++ b/drivers/mtd/nand/raw/gpio.c
@@ -194,7 +194,7 @@ static int gpio_nand_remove(struct platform_device *pdev)
 {
 	struct gpiomtd *gpiomtd = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&gpiomtd->nand_chip));
+	nand_release(&gpiomtd->nand_chip);
 
 	/* Enable write protection and disable the chip */
 	if (gpiomtd->nwp && !IS_ERR(gpiomtd->nwp))
diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 7af207bc3ab5f..fe99d9323d4ac 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -2026,7 +2026,7 @@ static int gpmi_nand_remove(struct platform_device *pdev)
 {
 	struct gpmi_nand_data *this = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&this->nand));
+	nand_release(&this->nand);
 	gpmi_free_dma_buffer(this);
 	release_resources(this);
 	return 0;
diff --git a/drivers/mtd/nand/raw/hisi504_nand.c b/drivers/mtd/nand/raw/hisi504_nand.c
index 76885dbf9c1ba..6833fc82e6b1d 100644
--- a/drivers/mtd/nand/raw/hisi504_nand.c
+++ b/drivers/mtd/nand/raw/hisi504_nand.c
@@ -828,9 +828,8 @@ static int hisi_nfc_probe(struct platform_device *pdev)
 static int hisi_nfc_remove(struct platform_device *pdev)
 {
 	struct hinfc_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->chip);
 
-	nand_release(mtd);
+	nand_release(&host->chip);
 
 	return 0;
 }
diff --git a/drivers/mtd/nand/raw/jz4740_nand.c b/drivers/mtd/nand/raw/jz4740_nand.c
index 75bb26645c820..27603d78b157b 100644
--- a/drivers/mtd/nand/raw/jz4740_nand.c
+++ b/drivers/mtd/nand/raw/jz4740_nand.c
@@ -507,7 +507,7 @@ static int jz_nand_remove(struct platform_device *pdev)
 	struct jz_nand *nand = platform_get_drvdata(pdev);
 	size_t i;
 
-	nand_release(nand_to_mtd(&nand->chip));
+	nand_release(&nand->chip);
 
 	/* Deassert and disable all chips */
 	writel(0, nand->base + JZ_REG_NAND_CTRL);
diff --git a/drivers/mtd/nand/raw/jz4780_nand.c b/drivers/mtd/nand/raw/jz4780_nand.c
index 2122a7f3c4847..b072bd5dd7a03 100644
--- a/drivers/mtd/nand/raw/jz4780_nand.c
+++ b/drivers/mtd/nand/raw/jz4780_nand.c
@@ -292,7 +292,7 @@ static int jz4780_nand_init_chip(struct platform_device *pdev,
 
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
-		nand_release(mtd);
+		nand_release(chip);
 		return ret;
 	}
 
@@ -307,7 +307,7 @@ static void jz4780_nand_cleanup_chips(struct jz4780_nand_controller *nfc)
 
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct jz4780_nand_chip, chip_list);
-		nand_release(nand_to_mtd(&chip->chip));
+		nand_release(&chip->chip);
 		list_del(&chip->chip_list);
 	}
 }
diff --git a/drivers/mtd/nand/raw/lpc32xx_mlc.c b/drivers/mtd/nand/raw/lpc32xx_mlc.c
index 453a83b82d73b..d240b8ff40cad 100644
--- a/drivers/mtd/nand/raw/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_mlc.c
@@ -839,9 +839,8 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 static int lpc32xx_nand_remove(struct platform_device *pdev)
 {
 	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 	free_irq(host->irq, host);
 	if (use_dma)
 		dma_release_channel(host->dma_chan);
diff --git a/drivers/mtd/nand/raw/lpc32xx_slc.c b/drivers/mtd/nand/raw/lpc32xx_slc.c
index ad6eff0591d2c..607e4bdfae030 100644
--- a/drivers/mtd/nand/raw/lpc32xx_slc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -956,9 +956,8 @@ static int lpc32xx_nand_remove(struct platform_device *pdev)
 {
 	uint32_t tmp;
 	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 	dma_release_channel(host->dma_chan);
 
 	/* Force CE high */
diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index e0e21a7fc8e7e..3e542224dd115 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2564,7 +2564,7 @@ static int marvell_nand_chip_init(struct device *dev, struct marvell_nfc *nfc,
 		ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "failed to register mtd device: %d\n", ret);
-		nand_release(mtd);
+		nand_release(chip);
 		return ret;
 	}
 
@@ -2619,7 +2619,7 @@ static void marvell_nand_chips_cleanup(struct marvell_nfc *nfc)
 	struct marvell_nand_chip *entry, *temp;
 
 	list_for_each_entry_safe(entry, temp, &nfc->chips, node) {
-		nand_release(nand_to_mtd(&entry->chip));
+		nand_release(&entry->chip);
 		list_del(&entry->node);
 	}
 }
diff --git a/drivers/mtd/nand/raw/mpc5121_nfc.c b/drivers/mtd/nand/raw/mpc5121_nfc.c
index bc99064c8ca98..b3d6effb34865 100644
--- a/drivers/mtd/nand/raw/mpc5121_nfc.c
+++ b/drivers/mtd/nand/raw/mpc5121_nfc.c
@@ -828,7 +828,7 @@ static int mpc5121_nfc_remove(struct platform_device *op)
 	struct device *dev = &op->dev;
 	struct mtd_info *mtd = dev_get_drvdata(dev);
 
-	nand_release(mtd);
+	nand_release(mtd_to_nand(mtd));
 	mpc5121_nfc_free(dev, mtd);
 
 	return 0;
diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index 6cc2845a5ff25..9c2ae8e873478 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1389,7 +1389,7 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "mtd parse partition error\n");
-		nand_release(mtd);
+		nand_release(nand);
 		return ret;
 	}
 
@@ -1555,7 +1555,7 @@ static int mtk_nfc_remove(struct platform_device *pdev)
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct mtk_nfc_nand_chip,
 					node);
-		nand_release(nand_to_mtd(&chip->nand));
+		nand_release(&chip->nand);
 		list_del(&chip->node);
 	}
 
diff --git a/drivers/mtd/nand/raw/mxc_nand.c b/drivers/mtd/nand/raw/mxc_nand.c
index 72bdd2767a4c0..334578d9f4a85 100644
--- a/drivers/mtd/nand/raw/mxc_nand.c
+++ b/drivers/mtd/nand/raw/mxc_nand.c
@@ -1928,7 +1928,7 @@ static int mxcnd_remove(struct platform_device *pdev)
 {
 	struct mxc_nand_host *host = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&host->nand));
+	nand_release(&host->nand);
 	if (host->clk_act)
 		clk_disable_unprepare(host->clk);
 
diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 2800520dd44d9..de3926eaec133 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -6846,12 +6846,12 @@ EXPORT_SYMBOL_GPL(nand_cleanup);
 /**
  * nand_release - [NAND Interface] Unregister the MTD device and free resources
  *		  held by the NAND device
- * @mtd: MTD device structure
+ * @chip: NAND chip object
  */
-void nand_release(struct mtd_info *mtd)
+void nand_release(struct nand_chip *chip)
 {
-	mtd_device_unregister(mtd);
-	nand_cleanup(mtd_to_nand(mtd));
+	mtd_device_unregister(nand_to_mtd(chip));
+	nand_cleanup(chip);
 }
 EXPORT_SYMBOL_GPL(nand_release);
 
diff --git a/drivers/mtd/nand/raw/nandsim.c b/drivers/mtd/nand/raw/nandsim.c
index 7a461ea8abf93..6e908e4fa8e85 100644
--- a/drivers/mtd/nand/raw/nandsim.c
+++ b/drivers/mtd/nand/raw/nandsim.c
@@ -2364,7 +2364,7 @@ static int __init ns_init_module(void)
 
 err_exit:
 	free_nandsim(nand);
-	nand_release(nsmtd);
+	nand_release(chip);
 	for (i = 0;i < ARRAY_SIZE(nand->partitions); ++i)
 		kfree(nand->partitions[i].name);
 error:
@@ -2386,7 +2386,7 @@ static void __exit ns_cleanup_module(void)
 	int i;
 
 	free_nandsim(ns);    /* Free nandsim private resources */
-	nand_release(nsmtd); /* Unregister driver */
+	nand_release(chip); /* Unregister driver */
 	for (i = 0;i < ARRAY_SIZE(ns->partitions); ++i)
 		kfree(ns->partitions[i].name);
 	kfree(mtd_to_nand(nsmtd));        /* Free other structures */
diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index cfe31c78482a1..6e96c633ac290 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -258,7 +258,7 @@ static int ndfc_remove(struct platform_device *ofdev)
 	struct ndfc_controller *ndfc = dev_get_drvdata(&ofdev->dev);
 	struct mtd_info *mtd = nand_to_mtd(&ndfc->chip);
 
-	nand_release(mtd);
+	nand_release(&ndfc->chip);
 	kfree(mtd->name);
 
 	return 0;
diff --git a/drivers/mtd/nand/raw/nuc900_nand.c b/drivers/mtd/nand/raw/nuc900_nand.c
index 41ed993b9523b..0c675b6c0b6ef 100644
--- a/drivers/mtd/nand/raw/nuc900_nand.c
+++ b/drivers/mtd/nand/raw/nuc900_nand.c
@@ -284,7 +284,7 @@ static int nuc900_nand_remove(struct platform_device *pdev)
 {
 	struct nuc900_nand *nuc900_nand = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&nuc900_nand->chip));
+	nand_release(&nuc900_nand->chip);
 	clk_disable(nuc900_nand->clk);
 
 	return 0;
diff --git a/drivers/mtd/nand/raw/omap2.c b/drivers/mtd/nand/raw/omap2.c
index 49fc60a790ea0..7a4af5f3e3d36 100644
--- a/drivers/mtd/nand/raw/omap2.c
+++ b/drivers/mtd/nand/raw/omap2.c
@@ -2290,7 +2290,7 @@ static int omap_nand_remove(struct platform_device *pdev)
 	}
 	if (info->dma)
 		dma_release_channel(info->dma);
-	nand_release(mtd);
+	nand_release(nand_chip);
 	return 0;
 }
 
diff --git a/drivers/mtd/nand/raw/orion_nand.c b/drivers/mtd/nand/raw/orion_nand.c
index 256a6b018bdc5..5c58d91ffaee6 100644
--- a/drivers/mtd/nand/raw/orion_nand.c
+++ b/drivers/mtd/nand/raw/orion_nand.c
@@ -181,7 +181,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	mtd->name = "orion_nand";
 	ret = mtd_device_register(mtd, board->parts, board->nr_parts);
 	if (ret) {
-		nand_release(mtd);
+		nand_release(nc);
 		goto no_dev;
 	}
 
@@ -196,9 +196,8 @@ static int orion_nand_remove(struct platform_device *pdev)
 {
 	struct orion_nand_info *info = platform_get_drvdata(pdev);
 	struct nand_chip *chip = &info->chip;
-	struct mtd_info *mtd = nand_to_mtd(chip);
 
-	nand_release(mtd);
+	nand_release(chip);
 
 	clk_disable_unprepare(info->clk);
 
diff --git a/drivers/mtd/nand/raw/oxnas_nand.c b/drivers/mtd/nand/raw/oxnas_nand.c
index 9aeb024c2a0ed..5bc180536320d 100644
--- a/drivers/mtd/nand/raw/oxnas_nand.c
+++ b/drivers/mtd/nand/raw/oxnas_nand.c
@@ -148,7 +148,7 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 
 		err = mtd_device_register(mtd, NULL, 0);
 		if (err) {
-			nand_release(mtd);
+			nand_release(chip);
 			goto err_clk_unprepare;
 		}
 
@@ -176,7 +176,7 @@ static int oxnas_nand_remove(struct platform_device *pdev)
 	struct oxnas_nand_ctrl *oxnas = platform_get_drvdata(pdev);
 
 	if (oxnas->chips[0])
-		nand_release(nand_to_mtd(oxnas->chips[0]));
+		nand_release(oxnas->chips[0]);
 
 	clk_disable_unprepare(oxnas->clk);
 
diff --git a/drivers/mtd/nand/raw/pasemi_nand.c b/drivers/mtd/nand/raw/pasemi_nand.c
index 8979ff248a31b..8713ea770006e 100644
--- a/drivers/mtd/nand/raw/pasemi_nand.c
+++ b/drivers/mtd/nand/raw/pasemi_nand.c
@@ -193,7 +193,7 @@ static int pasemi_nand_remove(struct platform_device *ofdev)
 	chip = mtd_to_nand(pasemi_nand_mtd);
 
 	/* Release resources, unregister device */
-	nand_release(pasemi_nand_mtd);
+	nand_release(chip);
 
 	release_region(lpcctl, 4);
 
diff --git a/drivers/mtd/nand/raw/plat_nand.c b/drivers/mtd/nand/raw/plat_nand.c
index deefe2136282e..d65e4084dea48 100644
--- a/drivers/mtd/nand/raw/plat_nand.c
+++ b/drivers/mtd/nand/raw/plat_nand.c
@@ -97,7 +97,7 @@ static int plat_nand_probe(struct platform_device *pdev)
 	if (!err)
 		return err;
 
-	nand_release(mtd);
+	nand_release(&data->chip);
 out:
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);
@@ -112,7 +112,7 @@ static int plat_nand_remove(struct platform_device *pdev)
 	struct plat_nand_data *data = platform_get_drvdata(pdev);
 	struct platform_nand_data *pdata = dev_get_platdata(&pdev->dev);
 
-	nand_release(nand_to_mtd(&data->chip));
+	nand_release(&data->chip);
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);
 
diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 87dc21df1c983..1f9d64aeb863e 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2999,7 +2999,7 @@ static int qcom_nandc_remove(struct platform_device *pdev)
 	struct qcom_nand_host *host;
 
 	list_for_each_entry(host, &nandc->host_list, node)
-		nand_release(nand_to_mtd(&host->chip));
+		nand_release(&host->chip);
 
 
 	qcom_nandc_unalloc(nandc);
diff --git a/drivers/mtd/nand/raw/r852.c b/drivers/mtd/nand/raw/r852.c
index dcdeb0660e5e3..bb74a0ac697e8 100644
--- a/drivers/mtd/nand/raw/r852.c
+++ b/drivers/mtd/nand/raw/r852.c
@@ -656,7 +656,7 @@ static int r852_register_nand_device(struct r852_device *dev)
 	dev->card_registred = 1;
 	return 0;
 error3:
-	nand_release(mtd);
+	nand_release(dev->chip);
 error1:
 	/* Force card redetect */
 	dev->card_detected = 0;
@@ -675,7 +675,7 @@ static void r852_unregister_nand_device(struct r852_device *dev)
 		return;
 
 	device_remove_file(&mtd->dev, &dev_attr_media_type);
-	nand_release(mtd);
+	nand_release(dev->chip);
 	r852_engine_disable(dev);
 	dev->card_registred = 0;
 }
diff --git a/drivers/mtd/nand/raw/s3c2410.c b/drivers/mtd/nand/raw/s3c2410.c
index 7f30d801d6420..cf045813c160a 100644
--- a/drivers/mtd/nand/raw/s3c2410.c
+++ b/drivers/mtd/nand/raw/s3c2410.c
@@ -781,7 +781,7 @@ static int s3c24xx_nand_remove(struct platform_device *pdev)
 
 		for (mtdno = 0; mtdno < info->mtd_count; mtdno++, ptr++) {
 			pr_debug("releasing mtd %d (%p)\n", mtdno, ptr);
-			nand_release(nand_to_mtd(&ptr->chip));
+			nand_release(&ptr->chip);
 		}
 	}
 
diff --git a/drivers/mtd/nand/raw/sh_flctl.c b/drivers/mtd/nand/raw/sh_flctl.c
index 1675ff254b7a1..683df1a12989c 100644
--- a/drivers/mtd/nand/raw/sh_flctl.c
+++ b/drivers/mtd/nand/raw/sh_flctl.c
@@ -1226,7 +1226,7 @@ static int flctl_remove(struct platform_device *pdev)
 	struct sh_flctl *flctl = platform_get_drvdata(pdev);
 
 	flctl_release_dma(flctl);
-	nand_release(nand_to_mtd(&flctl->chip));
+	nand_release(&flctl->chip);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
diff --git a/drivers/mtd/nand/raw/sharpsl.c b/drivers/mtd/nand/raw/sharpsl.c
index 4afacb0dcf001..c8eb4654bb1c7 100644
--- a/drivers/mtd/nand/raw/sharpsl.c
+++ b/drivers/mtd/nand/raw/sharpsl.c
@@ -187,7 +187,7 @@ static int sharpsl_nand_probe(struct platform_device *pdev)
 	return 0;
 
 err_add:
-	nand_release(mtd);
+	nand_release(this);
 
 err_scan:
 	iounmap(sharpsl->io);
@@ -205,7 +205,7 @@ static int sharpsl_nand_remove(struct platform_device *pdev)
 	struct sharpsl_nand *sharpsl = platform_get_drvdata(pdev);
 
 	/* Release resources, unregister device */
-	nand_release(nand_to_mtd(&sharpsl->chip));
+	nand_release(&sharpsl->chip);
 
 	iounmap(sharpsl->io);
 
diff --git a/drivers/mtd/nand/raw/socrates_nand.c b/drivers/mtd/nand/raw/socrates_nand.c
index 976b6f30d67fb..74fdb8402dbde 100644
--- a/drivers/mtd/nand/raw/socrates_nand.c
+++ b/drivers/mtd/nand/raw/socrates_nand.c
@@ -193,7 +193,7 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 	if (!res)
 		return res;
 
-	nand_release(mtd);
+	nand_release(nand_chip);
 
 out:
 	iounmap(host->io_base);
@@ -206,9 +206,8 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 static int socrates_nand_remove(struct platform_device *ofdev)
 {
 	struct socrates_nand_host *host = dev_get_drvdata(&ofdev->dev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 
 	iounmap(host->io_base);
 
diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index bd9084f1964be..5b8502fd50cbc 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1947,7 +1947,7 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "failed to register mtd device: %d\n", ret);
-		nand_release(mtd);
+		nand_release(nand);
 		return ret;
 	}
 
@@ -1986,7 +1986,7 @@ static void sunxi_nand_chips_cleanup(struct sunxi_nfc *nfc)
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct sunxi_nand_chip,
 					node);
-		nand_release(nand_to_mtd(&chip->nand));
+		nand_release(&chip->nand);
 		sunxi_nand_ecc_cleanup(&chip->nand.ecc);
 		list_del(&chip->node);
 	}
diff --git a/drivers/mtd/nand/raw/tango_nand.c b/drivers/mtd/nand/raw/tango_nand.c
index 45beb87aec937..1061eb60ee601 100644
--- a/drivers/mtd/nand/raw/tango_nand.c
+++ b/drivers/mtd/nand/raw/tango_nand.c
@@ -617,7 +617,7 @@ static int tango_nand_remove(struct platform_device *pdev)
 
 	for (cs = 0; cs < MAX_CS; ++cs) {
 		if (nfc->chips[cs])
-			nand_release(nand_to_mtd(&nfc->chips[cs]->nand_chip));
+			nand_release(&nfc->chips[cs]->nand_chip);
 	}
 
 	return 0;
diff --git a/drivers/mtd/nand/raw/tmio_nand.c b/drivers/mtd/nand/raw/tmio_nand.c
index 6df499a239ae2..39594910e6f04 100644
--- a/drivers/mtd/nand/raw/tmio_nand.c
+++ b/drivers/mtd/nand/raw/tmio_nand.c
@@ -449,7 +449,7 @@ static int tmio_probe(struct platform_device *dev)
 	if (!retval)
 		return retval;
 
-	nand_release(mtd);
+	nand_release(nand_chip);
 
 err_irq:
 	tmio_hw_stop(dev, tmio);
@@ -460,7 +460,7 @@ static int tmio_remove(struct platform_device *dev)
 {
 	struct tmio_nand *tmio = platform_get_drvdata(dev);
 
-	nand_release(nand_to_mtd(&tmio->chip));
+	nand_release(&tmio->chip);
 	tmio_hw_stop(dev, tmio);
 	return 0;
 }
diff --git a/drivers/mtd/nand/raw/txx9ndfmc.c b/drivers/mtd/nand/raw/txx9ndfmc.c
index 169e8bcee61ec..f722aae2b2449 100644
--- a/drivers/mtd/nand/raw/txx9ndfmc.c
+++ b/drivers/mtd/nand/raw/txx9ndfmc.c
@@ -390,7 +390,7 @@ static int __exit txx9ndfmc_remove(struct platform_device *dev)
 		chip = mtd_to_nand(mtd);
 		txx9_priv = nand_get_controller_data(chip);
 
-		nand_release(mtd);
+		nand_release(chip);
 		kfree(txx9_priv->mtdname);
 		kfree(txx9_priv);
 	}
diff --git a/drivers/mtd/nand/raw/vf610_nfc.c b/drivers/mtd/nand/raw/vf610_nfc.c
index 3b486f4ce8682..a73213c835a50 100644
--- a/drivers/mtd/nand/raw/vf610_nfc.c
+++ b/drivers/mtd/nand/raw/vf610_nfc.c
@@ -916,7 +916,7 @@ static int vf610_nfc_remove(struct platform_device *pdev)
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
 	struct vf610_nfc *nfc = mtd_to_nfc(mtd);
 
-	nand_release(mtd);
+	nand_release(mtd_to_nand(mtd));
 	clk_disable_unprepare(nfc->clk);
 	return 0;
 }
diff --git a/drivers/mtd/nand/raw/xway_nand.c b/drivers/mtd/nand/raw/xway_nand.c
index e670d3b5a6463..1adb41acebfc3 100644
--- a/drivers/mtd/nand/raw/xway_nand.c
+++ b/drivers/mtd/nand/raw/xway_nand.c
@@ -211,7 +211,7 @@ static int xway_nand_probe(struct platform_device *pdev)
 
 	err = mtd_device_register(mtd, NULL, 0);
 	if (err)
-		nand_release(mtd);
+		nand_release(&data->chip);
 
 	return err;
 }
@@ -223,7 +223,7 @@ static int xway_nand_remove(struct platform_device *pdev)
 {
 	struct xway_nand_data *data = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&data->chip));
+	nand_release(&data->chip);
 
 	return 0;
 }
diff --git a/include/linux/mtd/rawnand.h b/include/linux/mtd/rawnand.h
index 890cd7488aca7..a4be6b2bcc35a 100644
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -1741,7 +1741,7 @@ int nand_write_data_op(struct nand_chip *chip, const void *buf,
  */
 void nand_cleanup(struct nand_chip *chip);
 /* Unregister the MTD device and calls nand_cleanup() */
-void nand_release(struct mtd_info *mtd);
+void nand_release(struct nand_chip *chip);
 
 /* Default extended ID decoding function */
 void nand_decode_ext_id(struct nand_chip *chip);
-- 
2.25.1



