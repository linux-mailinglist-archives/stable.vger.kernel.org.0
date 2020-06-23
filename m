Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EF62061D2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392688AbgFWUu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390563AbgFWUs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:48:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6F621548;
        Tue, 23 Jun 2020 20:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945306;
        bh=ZrvQS2znFGZcThK+EiaGk16ADSVrz5AzzmE9Md8Mdfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ipaw4z1bpejjLiAOSMUPYgZy+jOY/38gHQ7OcM+/iz6P/YApDEufYfr+85+/6NCww
         e4HFHcyXXnE52yLHYZD6WJG/wa06qKKRzyIYM5eAJ3Qv59XiBYgzWoc8rGJHldwIhH
         NCPE83iAHm/oc+31O2aAIdSWytBNEr5Cl8PdJ6Ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/136] mtd: rawnand: Pass a nand_chip object to nand_release()
Date:   Tue, 23 Jun 2020 21:59:35 +0200
Message-Id: <20200623195309.720758916@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
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
 Documentation/driver-api/mtdnand.rst   | 2 +-
 drivers/mtd/nand/ams-delta.c           | 2 +-
 drivers/mtd/nand/au1550nd.c            | 2 +-
 drivers/mtd/nand/bcm47xxnflash/main.c  | 2 +-
 drivers/mtd/nand/brcmnand/brcmnand.c   | 2 +-
 drivers/mtd/nand/cafe_nand.c           | 2 +-
 drivers/mtd/nand/cmx270_nand.c         | 2 +-
 drivers/mtd/nand/cs553x_nand.c         | 2 +-
 drivers/mtd/nand/davinci_nand.c        | 2 +-
 drivers/mtd/nand/denali.c              | 4 +---
 drivers/mtd/nand/diskonchip.c          | 4 ++--
 drivers/mtd/nand/docg4.c               | 4 ++--
 drivers/mtd/nand/fsl_elbc_nand.c       | 2 +-
 drivers/mtd/nand/fsl_ifc_nand.c        | 2 +-
 drivers/mtd/nand/fsl_upm.c             | 2 +-
 drivers/mtd/nand/fsmc_nand.c           | 2 +-
 drivers/mtd/nand/gpio.c                | 2 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 2 +-
 drivers/mtd/nand/hisi504_nand.c        | 5 ++---
 drivers/mtd/nand/jz4740_nand.c         | 2 +-
 drivers/mtd/nand/jz4780_nand.c         | 4 ++--
 drivers/mtd/nand/lpc32xx_mlc.c         | 3 +--
 drivers/mtd/nand/lpc32xx_slc.c         | 3 +--
 drivers/mtd/nand/mpc5121_nfc.c         | 2 +-
 drivers/mtd/nand/mtk_nand.c            | 4 ++--
 drivers/mtd/nand/mxc_nand.c            | 2 +-
 drivers/mtd/nand/nand_base.c           | 8 ++++----
 drivers/mtd/nand/nandsim.c             | 4 ++--
 drivers/mtd/nand/ndfc.c                | 2 +-
 drivers/mtd/nand/nuc900_nand.c         | 2 +-
 drivers/mtd/nand/omap2.c               | 2 +-
 drivers/mtd/nand/orion_nand.c          | 5 ++---
 drivers/mtd/nand/oxnas_nand.c          | 4 ++--
 drivers/mtd/nand/pasemi_nand.c         | 2 +-
 drivers/mtd/nand/plat_nand.c           | 4 ++--
 drivers/mtd/nand/qcom_nandc.c          | 2 +-
 drivers/mtd/nand/r852.c                | 4 ++--
 drivers/mtd/nand/s3c2410.c             | 2 +-
 drivers/mtd/nand/sh_flctl.c            | 2 +-
 drivers/mtd/nand/sharpsl.c             | 4 ++--
 drivers/mtd/nand/socrates_nand.c       | 5 ++---
 drivers/mtd/nand/sunxi_nand.c          | 4 ++--
 drivers/mtd/nand/tango_nand.c          | 2 +-
 drivers/mtd/nand/tmio_nand.c           | 4 ++--
 drivers/mtd/nand/txx9ndfmc.c           | 2 +-
 drivers/mtd/nand/vf610_nfc.c           | 2 +-
 drivers/mtd/nand/xway_nand.c           | 4 ++--
 include/linux/mtd/rawnand.h            | 6 ++----
 48 files changed, 67 insertions(+), 76 deletions(-)

diff --git a/Documentation/driver-api/mtdnand.rst b/Documentation/driver-api/mtdnand.rst
index 2a5191b6d4459..15449334b1242 100644
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
diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index dcec9cf4983f8..e22a9ffa9cb73 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -263,7 +263,7 @@ static int ams_delta_cleanup(struct platform_device *pdev)
 	void __iomem *io_base = platform_get_drvdata(pdev);
 
 	/* Release resources, unregister device */
-	nand_release(ams_delta_mtd);
+	nand_release(mtd_to_nand(ams_delta_mtd));
 
 	gpio_free_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
 	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 9d4a28fa6b73b..99c738be2545d 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -496,7 +496,7 @@ static int au1550nd_remove(struct platform_device *pdev)
 	struct au1550nd_ctx *ctx = platform_get_drvdata(pdev);
 	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	nand_release(nand_to_mtd(&ctx->chip));
+	nand_release(&ctx->chip);
 	iounmap(ctx->base);
 	release_mem_region(r->start, 0x1000);
 	kfree(ctx);
diff --git a/drivers/mtd/nand/bcm47xxnflash/main.c b/drivers/mtd/nand/bcm47xxnflash/main.c
index fb31429b70a9a..d796941608457 100644
--- a/drivers/mtd/nand/bcm47xxnflash/main.c
+++ b/drivers/mtd/nand/bcm47xxnflash/main.c
@@ -65,7 +65,7 @@ static int bcm47xxnflash_remove(struct platform_device *pdev)
 {
 	struct bcm47xxnflash *nflash = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&nflash->nand_chip));
+	nand_release(&nflash->nand_chip);
 
 	return 0;
 }
diff --git a/drivers/mtd/nand/brcmnand/brcmnand.c b/drivers/mtd/nand/brcmnand/brcmnand.c
index f8d793b15a7a9..2bb8e6faa5391 100644
--- a/drivers/mtd/nand/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/brcmnand/brcmnand.c
@@ -2597,7 +2597,7 @@ int brcmnand_remove(struct platform_device *pdev)
 	struct brcmnand_host *host;
 
 	list_for_each_entry(host, &ctrl->host_list, node)
-		nand_release(nand_to_mtd(&host->chip));
+		nand_release(&host->chip);
 
 	clk_disable_unprepare(ctrl->clk);
 
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index bc558c438a574..98c013094fa23 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -826,7 +826,7 @@ static void cafe_nand_remove(struct pci_dev *pdev)
 	/* Disable NAND IRQ in global IRQ mask register */
 	cafe_writel(cafe, ~1 & cafe_readl(cafe, GLOBAL_IRQ_MASK), GLOBAL_IRQ_MASK);
 	free_irq(pdev->irq, mtd);
-	nand_release(mtd);
+	nand_release(chip);
 	free_rs(cafe->rs);
 	pci_iounmap(pdev, cafe->mmio);
 	dma_free_coherent(&cafe->pdev->dev,
diff --git a/drivers/mtd/nand/cmx270_nand.c b/drivers/mtd/nand/cmx270_nand.c
index 1fc435f994e1e..7b824ae88ab01 100644
--- a/drivers/mtd/nand/cmx270_nand.c
+++ b/drivers/mtd/nand/cmx270_nand.c
@@ -230,7 +230,7 @@ module_init(cmx270_init);
 static void __exit cmx270_cleanup(void)
 {
 	/* Release resources, unregister device */
-	nand_release(cmx270_nand_mtd);
+	nand_release(mtd_to_nand(cmx270_nand_mtd));
 
 	gpio_free(GPIO_NAND_RB);
 	gpio_free(GPIO_NAND_CS);
diff --git a/drivers/mtd/nand/cs553x_nand.c b/drivers/mtd/nand/cs553x_nand.c
index d48877540f144..647d4ee693457 100644
--- a/drivers/mtd/nand/cs553x_nand.c
+++ b/drivers/mtd/nand/cs553x_nand.c
@@ -338,7 +338,7 @@ static void __exit cs553x_cleanup(void)
 		mmio_base = this->IO_ADDR_R;
 
 		/* Release resources, unregister device */
-		nand_release(mtd);
+		nand_release(this);
 		kfree(mtd->name);
 		cs553x_mtd[i] = NULL;
 
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index ccc8c43abcff3..e66f1385b49e8 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -854,7 +854,7 @@ static int nand_davinci_remove(struct platform_device *pdev)
 		ecc4_busy = false;
 	spin_unlock_irq(&davinci_nand_lock);
 
-	nand_release(nand_to_mtd(&info->chip));
+	nand_release(&info->chip);
 
 	clk_disable_unprepare(info->clk);
 
diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 3087b0ba7b7f3..390a18ad68eea 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1444,9 +1444,7 @@ EXPORT_SYMBOL(denali_init);
 /* driver exit point */
 void denali_remove(struct denali_nand_info *denali)
 {
-	struct mtd_info *mtd = nand_to_mtd(&denali->nand);
-
-	nand_release(mtd);
+	nand_release(&denali->nand);
 	kfree(denali->buf);
 	denali_disable_irq(denali);
 }
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index c3aa53caab5cf..12cac07f5cf22 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1611,7 +1611,7 @@ static int __init doc_probe(unsigned long physadr)
 		/* nand_release will call mtd_device_unregister, but we
 		   haven't yet added it.  This is handled without incident by
 		   mtd_device_unregister, as far as I can tell. */
-		nand_release(mtd);
+		nand_release(nand);
 		kfree(nand);
 		goto fail;
 	}
@@ -1644,7 +1644,7 @@ static void release_nanddoc(void)
 		doc = nand_get_controller_data(nand);
 
 		nextmtd = doc->nextdoc;
-		nand_release(mtd);
+		nand_release(nand);
 		iounmap(doc->virtadr);
 		release_mem_region(doc->physadr, DOC_IOREMAP_LEN);
 		kfree(nand);
diff --git a/drivers/mtd/nand/docg4.c b/drivers/mtd/nand/docg4.c
index 2436cbc71662d..53fdf491d8c00 100644
--- a/drivers/mtd/nand/docg4.c
+++ b/drivers/mtd/nand/docg4.c
@@ -1376,7 +1376,7 @@ static int __init probe_docg4(struct platform_device *pdev)
 	return 0;
 
 fail:
-	nand_release(mtd); /* deletes partitions and mtd devices */
+	nand_release(nand); /* deletes partitions and mtd devices */
 	free_bch(doc->bch);
 	kfree(nand);
 
@@ -1389,7 +1389,7 @@ static int __init probe_docg4(struct platform_device *pdev)
 static int __exit cleanup_docg4(struct platform_device *pdev)
 {
 	struct docg4_priv *doc = platform_get_drvdata(pdev);
-	nand_release(doc->mtd);
+	nand_release(mtd_to_nand(doc->mtd));
 	free_bch(doc->bch);
 	kfree(mtd_to_nand(doc->mtd));
 	iounmap(doc->virtadr);
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 17db2f90aa2c3..0f70bd961234e 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -813,7 +813,7 @@ static int fsl_elbc_chip_remove(struct fsl_elbc_mtd *priv)
 	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
 	struct mtd_info *mtd = nand_to_mtd(&priv->chip);
 
-	nand_release(mtd);
+	nand_release(&priv->chip);
 
 	kfree(mtd->name);
 
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 16deba1a23858..0d49281614397 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -927,7 +927,7 @@ static int fsl_ifc_chip_remove(struct fsl_ifc_mtd *priv)
 {
 	struct mtd_info *mtd = nand_to_mtd(&priv->chip);
 
-	nand_release(mtd);
+	nand_release(&priv->chip);
 
 	kfree(mtd->name);
 
diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index a88e2cf66e0f6..009e96fb92ae2 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -326,7 +326,7 @@ static int fun_remove(struct platform_device *ofdev)
 	struct mtd_info *mtd = nand_to_mtd(&fun->chip);
 	int i;
 
-	nand_release(mtd);
+	nand_release(&fun->chip);
 	kfree(mtd->name);
 
 	for (i = 0; i < fun->mchip_count; i++) {
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index eac15d9bf49eb..3be80e15e4002 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -1118,7 +1118,7 @@ static int fsmc_nand_remove(struct platform_device *pdev)
 	struct fsmc_nand_data *host = platform_get_drvdata(pdev);
 
 	if (host) {
-		nand_release(nand_to_mtd(&host->nand));
+		nand_release(&host->nand);
 
 		if (host->mode == USE_DMA_ACCESS) {
 			dma_release_channel(host->write_dma_chan);
diff --git a/drivers/mtd/nand/gpio.c b/drivers/mtd/nand/gpio.c
index fd3648952b5a7..81b02b81e9844 100644
--- a/drivers/mtd/nand/gpio.c
+++ b/drivers/mtd/nand/gpio.c
@@ -199,7 +199,7 @@ static int gpio_nand_remove(struct platform_device *pdev)
 {
 	struct gpiomtd *gpiomtd = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&gpiomtd->nand_chip));
+	nand_release(&gpiomtd->nand_chip);
 
 	if (gpio_is_valid(gpiomtd->plat.gpio_nwp))
 		gpio_set_value(gpiomtd->plat.gpio_nwp, 0);
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index d4d824ef64e9f..c7d0d2eed6c25 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -2135,7 +2135,7 @@ static int gpmi_nand_remove(struct platform_device *pdev)
 {
 	struct gpmi_nand_data *this = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&this->nand));
+	nand_release(&this->nand);
 	gpmi_free_dma_buffer(this);
 	release_resources(this);
 	return 0;
diff --git a/drivers/mtd/nand/hisi504_nand.c b/drivers/mtd/nand/hisi504_nand.c
index d9ee1a7e69563..1d1b541489f84 100644
--- a/drivers/mtd/nand/hisi504_nand.c
+++ b/drivers/mtd/nand/hisi504_nand.c
@@ -823,7 +823,7 @@ static int hisi_nfc_probe(struct platform_device *pdev)
 	return 0;
 
 err_mtd:
-	nand_release(mtd);
+	nand_release(chip);
 err_res:
 	return ret;
 }
@@ -831,9 +831,8 @@ static int hisi_nfc_probe(struct platform_device *pdev)
 static int hisi_nfc_remove(struct platform_device *pdev)
 {
 	struct hinfc_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->chip);
 
-	nand_release(mtd);
+	nand_release(&host->chip);
 
 	return 0;
 }
diff --git a/drivers/mtd/nand/jz4740_nand.c b/drivers/mtd/nand/jz4740_nand.c
index ad827d4af3e9b..2caf27bef13a4 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -500,7 +500,7 @@ static int jz_nand_remove(struct platform_device *pdev)
 	struct jz_nand *nand = platform_get_drvdata(pdev);
 	size_t i;
 
-	nand_release(nand_to_mtd(&nand->chip));
+	nand_release(&nand->chip);
 
 	/* Deassert and disable all chips */
 	writel(0, nand->base + JZ_REG_NAND_CTRL);
diff --git a/drivers/mtd/nand/jz4780_nand.c b/drivers/mtd/nand/jz4780_nand.c
index e69f6ae4c5395..86ff46eb79256 100644
--- a/drivers/mtd/nand/jz4780_nand.c
+++ b/drivers/mtd/nand/jz4780_nand.c
@@ -293,7 +293,7 @@ static int jz4780_nand_init_chip(struct platform_device *pdev,
 
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
-		nand_release(mtd);
+		nand_release(chip);
 		return ret;
 	}
 
@@ -308,7 +308,7 @@ static void jz4780_nand_cleanup_chips(struct jz4780_nand_controller *nfc)
 
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct jz4780_nand_chip, chip_list);
-		nand_release(nand_to_mtd(&chip->chip));
+		nand_release(&chip->chip);
 		list_del(&chip->chip_list);
 	}
 }
diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index 5796468db6534..34687c20409be 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -829,9 +829,8 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 static int lpc32xx_nand_remove(struct platform_device *pdev)
 {
 	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 	free_irq(host->irq, host);
 	if (use_dma)
 		dma_release_channel(host->dma_chan);
diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index b61f28a1554d3..408758c90a451 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -954,9 +954,8 @@ static int lpc32xx_nand_remove(struct platform_device *pdev)
 {
 	uint32_t tmp;
 	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 	dma_release_channel(host->dma_chan);
 
 	/* Force CE high */
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index b6b97cc9fba69..b8a93b47a2901 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -829,7 +829,7 @@ static int mpc5121_nfc_remove(struct platform_device *op)
 	struct device *dev = &op->dev;
 	struct mtd_info *mtd = dev_get_drvdata(dev);
 
-	nand_release(mtd);
+	nand_release(mtd_to_nand(mtd));
 	mpc5121_nfc_free(dev, mtd);
 
 	return 0;
diff --git a/drivers/mtd/nand/mtk_nand.c b/drivers/mtd/nand/mtk_nand.c
index e17f838b9b814..27fcce71ad38c 100644
--- a/drivers/mtd/nand/mtk_nand.c
+++ b/drivers/mtd/nand/mtk_nand.c
@@ -1357,7 +1357,7 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 	ret = mtd_device_parse_register(mtd, NULL, NULL, NULL, 0);
 	if (ret) {
 		dev_err(dev, "mtd parse partition error\n");
-		nand_release(mtd);
+		nand_release(nand);
 		return ret;
 	}
 
@@ -1514,7 +1514,7 @@ static int mtk_nfc_remove(struct platform_device *pdev)
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct mtk_nfc_nand_chip,
 					node);
-		nand_release(nand_to_mtd(&chip->nand));
+		nand_release(&chip->nand);
 		list_del(&chip->node);
 	}
 
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index fcb575d55b89b..808d85bde9f22 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1834,7 +1834,7 @@ static int mxcnd_remove(struct platform_device *pdev)
 {
 	struct mxc_nand_host *host = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&host->nand));
+	nand_release(&host->nand);
 	if (host->clk_act)
 		clk_disable_unprepare(host->clk);
 
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index d410de3318542..e953eca67608a 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -5046,12 +5046,12 @@ EXPORT_SYMBOL_GPL(nand_cleanup);
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
 
diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 44322a363ba54..dbb0e47f51975 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -2356,7 +2356,7 @@ static int __init ns_init_module(void)
 
 err_exit:
 	free_nandsim(nand);
-	nand_release(nsmtd);
+	nand_release(chip);
 	for (i = 0;i < ARRAY_SIZE(nand->partitions); ++i)
 		kfree(nand->partitions[i].name);
 error:
@@ -2378,7 +2378,7 @@ static void __exit ns_cleanup_module(void)
 	int i;
 
 	free_nandsim(ns);    /* Free nandsim private resources */
-	nand_release(nsmtd); /* Unregister driver */
+	nand_release(chip); /* Unregister driver */
 	for (i = 0;i < ARRAY_SIZE(ns->partitions); ++i)
 		kfree(ns->partitions[i].name);
 	kfree(mtd_to_nand(nsmtd));        /* Free other structures */
diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index d8a8068949376..eb84328d9bded 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -258,7 +258,7 @@ static int ndfc_remove(struct platform_device *ofdev)
 	struct ndfc_controller *ndfc = dev_get_drvdata(&ofdev->dev);
 	struct mtd_info *mtd = nand_to_mtd(&ndfc->chip);
 
-	nand_release(mtd);
+	nand_release(&ndfc->chip);
 	kfree(mtd->name);
 
 	return 0;
diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index 7bb4d2ea93421..a79f88c6d0102 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -284,7 +284,7 @@ static int nuc900_nand_remove(struct platform_device *pdev)
 {
 	struct nuc900_nand *nuc900_nand = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&nuc900_nand->chip));
+	nand_release(&nuc900_nand->chip);
 	clk_disable(nuc900_nand->clk);
 
 	return 0;
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 9f98f74ff221a..110c0726c665e 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -2306,7 +2306,7 @@ static int omap_nand_remove(struct platform_device *pdev)
 	}
 	if (info->dma)
 		dma_release_channel(info->dma);
-	nand_release(mtd);
+	nand_release(nand_chip);
 	return 0;
 }
 
diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 5a5aa1f07d074..2f21c678d6efd 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -186,7 +186,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	mtd->name = "orion_nand";
 	ret = mtd_device_register(mtd, board->parts, board->nr_parts);
 	if (ret) {
-		nand_release(mtd);
+		nand_release(nc);
 		goto no_dev;
 	}
 
@@ -201,9 +201,8 @@ static int orion_nand_remove(struct platform_device *pdev)
 {
 	struct orion_nand_info *info = platform_get_drvdata(pdev);
 	struct nand_chip *chip = &info->chip;
-	struct mtd_info *mtd = nand_to_mtd(chip);
 
-	nand_release(mtd);
+	nand_release(chip);
 
 	clk_disable_unprepare(info->clk);
 
diff --git a/drivers/mtd/nand/oxnas_nand.c b/drivers/mtd/nand/oxnas_nand.c
index d649d5944826e..ff58999887388 100644
--- a/drivers/mtd/nand/oxnas_nand.c
+++ b/drivers/mtd/nand/oxnas_nand.c
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
 
diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index d69e5bae541e2..f0f4ff9609655 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -193,7 +193,7 @@ static int pasemi_nand_remove(struct platform_device *ofdev)
 	chip = mtd_to_nand(pasemi_nand_mtd);
 
 	/* Release resources, unregister device */
-	nand_release(pasemi_nand_mtd);
+	nand_release(chip);
 
 	release_region(lpcctl, 4);
 
diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 925a1323604de..2906996d22620 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -99,7 +99,7 @@ static int plat_nand_probe(struct platform_device *pdev)
 	if (!err)
 		return err;
 
-	nand_release(mtd);
+	nand_release(&data->chip);
 out:
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);
@@ -114,7 +114,7 @@ static int plat_nand_remove(struct platform_device *pdev)
 	struct plat_nand_data *data = platform_get_drvdata(pdev);
 	struct platform_nand_data *pdata = dev_get_platdata(&pdev->dev);
 
-	nand_release(nand_to_mtd(&data->chip));
+	nand_release(&data->chip);
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);
 
diff --git a/drivers/mtd/nand/qcom_nandc.c b/drivers/mtd/nand/qcom_nandc.c
index 09d5f7df60237..65d1be2c30497 100644
--- a/drivers/mtd/nand/qcom_nandc.c
+++ b/drivers/mtd/nand/qcom_nandc.c
@@ -2760,7 +2760,7 @@ static int qcom_nandc_remove(struct platform_device *pdev)
 	struct qcom_nand_host *host;
 
 	list_for_each_entry(host, &nandc->host_list, node)
-		nand_release(nand_to_mtd(&host->chip));
+		nand_release(&host->chip);
 
 	qcom_nandc_unalloc(nandc);
 
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index fc9287af46140..2cfa549413952 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
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
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 4c383eeec6f6f..f60de68bfabcc 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -784,7 +784,7 @@ static int s3c24xx_nand_remove(struct platform_device *pdev)
 
 		for (mtdno = 0; mtdno < info->mtd_count; mtdno++, ptr++) {
 			pr_debug("releasing mtd %d (%p)\n", mtdno, ptr);
-			nand_release(nand_to_mtd(&ptr->chip));
+			nand_release(&ptr->chip);
 		}
 	}
 
diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 43db80e5d994f..f2ed03ee30355 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -1231,7 +1231,7 @@ static int flctl_remove(struct platform_device *pdev)
 	struct sh_flctl *flctl = platform_get_drvdata(pdev);
 
 	flctl_release_dma(flctl);
-	nand_release(nand_to_mtd(&flctl->chip));
+	nand_release(&flctl->chip);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
diff --git a/drivers/mtd/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c
index f59c455d9f517..6cfff0c81153f 100644
--- a/drivers/mtd/nand/sharpsl.c
+++ b/drivers/mtd/nand/sharpsl.c
@@ -192,7 +192,7 @@ static int sharpsl_nand_probe(struct platform_device *pdev)
 	return 0;
 
 err_add:
-	nand_release(mtd);
+	nand_release(this);
 
 err_scan:
 	iounmap(sharpsl->io);
@@ -210,7 +210,7 @@ static int sharpsl_nand_remove(struct platform_device *pdev)
 	struct sharpsl_nand *sharpsl = platform_get_drvdata(pdev);
 
 	/* Release resources, unregister device */
-	nand_release(nand_to_mtd(&sharpsl->chip));
+	nand_release(&sharpsl->chip);
 
 	iounmap(sharpsl->io);
 
diff --git a/drivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c
index 575997d0ef8a0..f960f18ea3e24 100644
--- a/drivers/mtd/nand/socrates_nand.c
+++ b/drivers/mtd/nand/socrates_nand.c
@@ -195,7 +195,7 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 	if (!res)
 		return res;
 
-	nand_release(mtd);
+	nand_release(nand_chip);
 
 out:
 	iounmap(host->io_base);
@@ -208,9 +208,8 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 static int socrates_nand_remove(struct platform_device *ofdev)
 {
 	struct socrates_nand_host *host = dev_get_drvdata(&ofdev->dev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 
 	iounmap(host->io_base);
 
diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 8e52314823976..d6e31e8a7b668 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -2125,7 +2125,7 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "failed to register mtd device: %d\n", ret);
-		nand_release(mtd);
+		nand_release(nand);
 		return ret;
 	}
 
@@ -2164,7 +2164,7 @@ static void sunxi_nand_chips_cleanup(struct sunxi_nfc *nfc)
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct sunxi_nand_chip,
 					node);
-		nand_release(nand_to_mtd(&chip->nand));
+		nand_release(&chip->nand);
 		sunxi_nand_ecc_cleanup(&chip->nand.ecc);
 		list_del(&chip->node);
 	}
diff --git a/drivers/mtd/nand/tango_nand.c b/drivers/mtd/nand/tango_nand.c
index ce366816a7efb..1ab16a90ea296 100644
--- a/drivers/mtd/nand/tango_nand.c
+++ b/drivers/mtd/nand/tango_nand.c
@@ -619,7 +619,7 @@ static int tango_nand_remove(struct platform_device *pdev)
 
 	for (cs = 0; cs < MAX_CS; ++cs) {
 		if (nfc->chips[cs])
-			nand_release(nand_to_mtd(&nfc->chips[cs]->nand_chip));
+			nand_release(&nfc->chips[cs]->nand_chip);
 	}
 
 	return 0;
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 84dbf32332e12..5a082d9432f96 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -448,7 +448,7 @@ static int tmio_probe(struct platform_device *dev)
 	if (!retval)
 		return retval;
 
-	nand_release(mtd);
+	nand_release(nand_chip);
 
 err_irq:
 	tmio_hw_stop(dev, tmio);
@@ -459,7 +459,7 @@ static int tmio_remove(struct platform_device *dev)
 {
 	struct tmio_nand *tmio = platform_get_drvdata(dev);
 
-	nand_release(nand_to_mtd(&tmio->chip));
+	nand_release(&tmio->chip);
 	tmio_hw_stop(dev, tmio);
 	return 0;
 }
diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index b567d212fe7de..236181b2985ad 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -390,7 +390,7 @@ static int __exit txx9ndfmc_remove(struct platform_device *dev)
 		chip = mtd_to_nand(mtd);
 		txx9_priv = nand_get_controller_data(chip);
 
-		nand_release(mtd);
+		nand_release(chip);
 		kfree(txx9_priv->mtdname);
 		kfree(txx9_priv);
 	}
diff --git a/drivers/mtd/nand/vf610_nfc.c b/drivers/mtd/nand/vf610_nfc.c
index e2583a539b413..688393526b5aa 100644
--- a/drivers/mtd/nand/vf610_nfc.c
+++ b/drivers/mtd/nand/vf610_nfc.c
@@ -794,7 +794,7 @@ static int vf610_nfc_remove(struct platform_device *pdev)
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
 	struct vf610_nfc *nfc = mtd_to_nfc(mtd);
 
-	nand_release(mtd);
+	nand_release(mtd_to_nand(mtd));
 	clk_disable_unprepare(nfc->clk);
 	return 0;
 }
diff --git a/drivers/mtd/nand/xway_nand.c b/drivers/mtd/nand/xway_nand.c
index 9926b4e3d69d0..1988bb943d1bc 100644
--- a/drivers/mtd/nand/xway_nand.c
+++ b/drivers/mtd/nand/xway_nand.c
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
index 2b05f4273babd..e9a791f46eb64 100644
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -22,6 +22,7 @@
 #include <linux/mtd/flashchip.h>
 #include <linux/mtd/bbm.h>
 
+struct nand_chip;
 struct mtd_info;
 struct nand_flash_dev;
 struct device_node;
@@ -37,7 +38,7 @@ int nand_scan_ident(struct mtd_info *mtd, int max_chips,
 int nand_scan_tail(struct mtd_info *mtd);
 
 /* Unregister the MTD device and free resources held by the NAND device */
-void nand_release(struct mtd_info *mtd);
+void nand_release(struct nand_chip *chip);
 
 /* Internal helper for board drivers which need to override command function */
 void nand_wait_ready(struct mtd_info *mtd);
@@ -227,9 +228,6 @@ enum nand_ecc_algo {
 #define NAND_CI_CELLTYPE_MSK	0x0C
 #define NAND_CI_CELLTYPE_SHIFT	2
 
-/* Keep gcc happy */
-struct nand_chip;
-
 /* ONFI features */
 #define ONFI_FEATURE_16_BIT_BUS		(1 << 0)
 #define ONFI_FEATURE_EXT_PARAM_PAGE	(1 << 7)
-- 
2.25.1



