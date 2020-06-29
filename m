Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A499C20DDC8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgF2UTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732614AbgF2TZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85C942540F;
        Mon, 29 Jun 2020 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445363;
        bh=n3cpEf4rfQbDgUwS6BLJpHDZsjXrggCpK7e3ZgexTdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9EKAlFns6PQ1dr6+TfD0gKUAoQUZpTFciN4jtxXJDO3DLTpkGCpG2OrHRLXPK0Bz
         6NOlhlesnGabM/k4MtaVlvQfsjuaJata6zc3NbeyKiJE6XbAR0snDHnWfcneeB1JNe
         ZS6bG2Q/VwBMZagMWD095WWwL0V1Nl+rmGJsDdJY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Brezillon <boris.brezillon@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 119/191] mtd: rawnand: Pass a nand_chip object to nand_release()
Date:   Mon, 29 Jun 2020 11:38:55 -0400
Message-Id: <20200629154007.2495120-120-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/mtd/nand/ams-delta.c           | 2 +-
 drivers/mtd/nand/atmel_nand.c          | 2 +-
 drivers/mtd/nand/au1550nd.c            | 2 +-
 drivers/mtd/nand/bcm47xxnflash/main.c  | 2 +-
 drivers/mtd/nand/bf5xx_nand.c          | 2 +-
 drivers/mtd/nand/brcmnand/brcmnand.c   | 2 +-
 drivers/mtd/nand/cafe_nand.c           | 2 +-
 drivers/mtd/nand/cmx270_nand.c         | 2 +-
 drivers/mtd/nand/cs553x_nand.c         | 2 +-
 drivers/mtd/nand/davinci_nand.c        | 2 +-
 drivers/mtd/nand/denali.c              | 2 +-
 drivers/mtd/nand/diskonchip.c          | 4 ++--
 drivers/mtd/nand/docg4.c               | 4 ++--
 drivers/mtd/nand/fsl_elbc_nand.c       | 2 +-
 drivers/mtd/nand/fsl_ifc_nand.c        | 2 +-
 drivers/mtd/nand/fsl_upm.c             | 2 +-
 drivers/mtd/nand/fsmc_nand.c           | 2 +-
 drivers/mtd/nand/gpio.c                | 2 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 2 +-
 drivers/mtd/nand/hisi504_nand.c        | 5 ++---
 drivers/mtd/nand/jz4740_nand.c         | 4 ++--
 drivers/mtd/nand/jz4780_nand.c         | 4 ++--
 drivers/mtd/nand/lpc32xx_mlc.c         | 5 ++---
 drivers/mtd/nand/lpc32xx_slc.c         | 5 ++---
 drivers/mtd/nand/mpc5121_nfc.c         | 2 +-
 drivers/mtd/nand/mtk_nand.c            | 4 ++--
 drivers/mtd/nand/mxc_nand.c            | 2 +-
 drivers/mtd/nand/nand_base.c           | 8 ++++----
 drivers/mtd/nand/nandsim.c             | 4 ++--
 drivers/mtd/nand/ndfc.c                | 2 +-
 drivers/mtd/nand/nuc900_nand.c         | 2 +-
 drivers/mtd/nand/omap2.c               | 2 +-
 drivers/mtd/nand/orion_nand.c          | 5 ++---
 drivers/mtd/nand/pasemi_nand.c         | 2 +-
 drivers/mtd/nand/plat_nand.c           | 4 ++--
 drivers/mtd/nand/pxa3xx_nand.c         | 2 +-
 drivers/mtd/nand/qcom_nandc.c          | 4 ++--
 drivers/mtd/nand/r852.c                | 4 ++--
 drivers/mtd/nand/s3c2410.c             | 2 +-
 drivers/mtd/nand/sh_flctl.c            | 2 +-
 drivers/mtd/nand/sharpsl.c             | 4 ++--
 drivers/mtd/nand/socrates_nand.c       | 5 ++---
 drivers/mtd/nand/sunxi_nand.c          | 4 ++--
 drivers/mtd/nand/tmio_nand.c           | 4 ++--
 drivers/mtd/nand/txx9ndfmc.c           | 2 +-
 drivers/mtd/nand/vf610_nfc.c           | 2 +-
 drivers/mtd/nand/xway_nand.c           | 4 ++--
 include/linux/mtd/nand.h               | 6 ++----
 48 files changed, 70 insertions(+), 77 deletions(-)

diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 78e12cc8bac2f..02ec2d183607f 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -264,7 +264,7 @@ static int ams_delta_cleanup(struct platform_device *pdev)
 	void __iomem *io_base = platform_get_drvdata(pdev);
 
 	/* Release resources, unregister device */
-	nand_release(ams_delta_mtd);
+	nand_release(mtd_to_nand(ams_delta_mtd));
 
 	gpio_free_array(_mandatory_gpio, ARRAY_SIZE(_mandatory_gpio));
 	gpio_free(AMS_DELTA_GPIO_PIN_NAND_RB);
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 68b9160108c9f..45495bc1a70e2 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -2336,7 +2336,7 @@ static int atmel_nand_remove(struct platform_device *pdev)
 	struct atmel_nand_host *host = platform_get_drvdata(pdev);
 	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 
 	atmel_nand_disable(host);
 
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 9bf6d9915694e..a0e7789131dfc 100644
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
diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 3962f55bd0349..020bb350a2db2 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -688,7 +688,7 @@ static int bf5xx_nand_remove(struct platform_device *pdev)
 	 * and their partitions, then go through freeing the
 	 * resources used
 	 */
-	nand_release(nand_to_mtd(&info->chip));
+	nand_release(&info->chip);
 
 	peripheral_free_list(bfin_nfc_pin_req);
 	bf5xx_nand_dma_remove(info);
diff --git a/drivers/mtd/nand/brcmnand/brcmnand.c b/drivers/mtd/nand/brcmnand/brcmnand.c
index 1291492a1cef1..fbee81909d38a 100644
--- a/drivers/mtd/nand/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/brcmnand/brcmnand.c
@@ -2595,7 +2595,7 @@ int brcmnand_remove(struct platform_device *pdev)
 	struct brcmnand_host *host;
 
 	list_for_each_entry(host, &ctrl->host_list, node)
-		nand_release(nand_to_mtd(&host->chip));
+		nand_release(&host->chip);
 
 	clk_disable_unprepare(ctrl->clk);
 
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 0b0c93702abbd..c16e740c01c38 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -825,7 +825,7 @@ static void cafe_nand_remove(struct pci_dev *pdev)
 	/* Disable NAND IRQ in global IRQ mask register */
 	cafe_writel(cafe, ~1 & cafe_readl(cafe, GLOBAL_IRQ_MASK), GLOBAL_IRQ_MASK);
 	free_irq(pdev->irq, mtd);
-	nand_release(mtd);
+	nand_release(chip);
 	free_rs(cafe->rs);
 	pci_iounmap(pdev, cafe->mmio);
 	dma_free_coherent(&cafe->pdev->dev,
diff --git a/drivers/mtd/nand/cmx270_nand.c b/drivers/mtd/nand/cmx270_nand.c
index 49133783ca536..b9667204e711a 100644
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
index a65e4e0f57a1c..4779dfec3576f 100644
--- a/drivers/mtd/nand/cs553x_nand.c
+++ b/drivers/mtd/nand/cs553x_nand.c
@@ -339,7 +339,7 @@ static void __exit cs553x_cleanup(void)
 		mmio_base = this->IO_ADDR_R;
 
 		/* Release resources, unregister device */
-		nand_release(mtd);
+		nand_release(this);
 		kfree(mtd->name);
 		cs553x_mtd[i] = NULL;
 
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 27fa8b87cd5fc..c7f535676e49f 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -840,7 +840,7 @@ static int nand_davinci_remove(struct platform_device *pdev)
 		ecc4_busy = false;
 	spin_unlock_irq(&davinci_nand_lock);
 
-	nand_release(nand_to_mtd(&info->chip));
+	nand_release(&info->chip);
 
 	clk_disable_unprepare(info->clk);
 
diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 0476ae8776d93..982cbc7f412f4 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1655,7 +1655,7 @@ void denali_remove(struct denali_nand_info *denali)
 	 */
 	int bufsize = mtd->writesize + mtd->oobsize;
 
-	nand_release(mtd);
+	nand_release(&denali->nand);
 	denali_irq_cleanup(denali->irq, denali);
 	dma_unmap_single(denali->dev, denali->buf.dma_buf, bufsize,
 			 DMA_BIDIRECTIONAL);
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index a023ab9e9cbf6..b42d618553be8 100644
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
index 7af2a3cd949ee..5798cd87f340b 100644
--- a/drivers/mtd/nand/docg4.c
+++ b/drivers/mtd/nand/docg4.c
@@ -1374,7 +1374,7 @@ static int __init probe_docg4(struct platform_device *pdev)
 	return 0;
 
 fail:
-	nand_release(mtd); /* deletes partitions and mtd devices */
+	nand_release(nand); /* deletes partitions and mtd devices */
 	free_bch(doc->bch);
 	kfree(nand);
 
@@ -1387,7 +1387,7 @@ static int __init probe_docg4(struct platform_device *pdev)
 static int __exit cleanup_docg4(struct platform_device *pdev)
 {
 	struct docg4_priv *doc = platform_get_drvdata(pdev);
-	nand_release(doc->mtd);
+	nand_release(mtd_to_nand(doc->mtd));
 	free_bch(doc->bch);
 	kfree(mtd_to_nand(doc->mtd));
 	iounmap(doc->virtadr);
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 113f76e599372..2fc4f2ab89ff5 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -811,7 +811,7 @@ static int fsl_elbc_chip_remove(struct fsl_elbc_mtd *priv)
 	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
 	struct mtd_info *mtd = nand_to_mtd(&priv->chip);
 
-	nand_release(mtd);
+	nand_release(&priv->chip);
 
 	kfree(mtd->name);
 
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 4c3b986dd74d1..cf0fccb5908e7 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -918,7 +918,7 @@ static int fsl_ifc_chip_remove(struct fsl_ifc_mtd *priv)
 {
 	struct mtd_info *mtd = nand_to_mtd(&priv->chip);
 
-	nand_release(mtd);
+	nand_release(&priv->chip);
 
 	kfree(mtd->name);
 
diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index d85fa2555b683..0b4d2489cc716 100644
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
index d4f454a4b35e7..92737deb7845d 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -1038,7 +1038,7 @@ static int fsmc_nand_remove(struct platform_device *pdev)
 	struct fsmc_nand_data *host = platform_get_drvdata(pdev);
 
 	if (host) {
-		nand_release(nand_to_mtd(&host->nand));
+		nand_release(&host->nand);
 
 		if (host->mode == USE_DMA_ACCESS) {
 			dma_release_channel(host->write_dma_chan);
diff --git a/drivers/mtd/nand/gpio.c b/drivers/mtd/nand/gpio.c
index 6317f6836022e..c7461ca1c1a69 100644
--- a/drivers/mtd/nand/gpio.c
+++ b/drivers/mtd/nand/gpio.c
@@ -197,7 +197,7 @@ static int gpio_nand_remove(struct platform_device *pdev)
 {
 	struct gpiomtd *gpiomtd = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&gpiomtd->nand_chip));
+	nand_release(&gpiomtd->nand_chip);
 
 	if (gpio_is_valid(gpiomtd->plat.gpio_nwp))
 		gpio_set_value(gpiomtd->plat.gpio_nwp, 0);
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index d9dab42758590..f4a99e91c2500 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1930,7 +1930,7 @@ static int gpmi_set_geometry(struct gpmi_nand_data *this)
 
 static void gpmi_nand_exit(struct gpmi_nand_data *this)
 {
-	nand_release(nand_to_mtd(&this->nand));
+	nand_release(&this->nand);
 	gpmi_free_dma_buffer(this);
 }
 
diff --git a/drivers/mtd/nand/hisi504_nand.c b/drivers/mtd/nand/hisi504_nand.c
index 9432546f4cd47..6c96d9d29a310 100644
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
index 5551c36adbdf1..6f323858d51a1 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -499,7 +499,7 @@ static int jz_nand_probe(struct platform_device *pdev)
 	return 0;
 
 err_nand_release:
-	nand_release(mtd);
+	nand_release(chip);
 err_unclaim_banks:
 	while (chipnr--) {
 		unsigned char bank = nand->banks[chipnr];
@@ -520,7 +520,7 @@ static int jz_nand_remove(struct platform_device *pdev)
 	struct jz_nand *nand = platform_get_drvdata(pdev);
 	size_t i;
 
-	nand_release(nand_to_mtd(&nand->chip));
+	nand_release(&nand->chip);
 
 	/* Deassert and disable all chips */
 	writel(0, nand->base + JZ_REG_NAND_CTRL);
diff --git a/drivers/mtd/nand/jz4780_nand.c b/drivers/mtd/nand/jz4780_nand.c
index a39bb70175eea..e8aaf2543946c 100644
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
index bc6e49af063a2..839f8f4ace9e6 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -805,7 +805,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	if (!res)
 		return res;
 
-	nand_release(mtd);
+	nand_release(nand_chip);
 
 err_exit4:
 	free_irq(host->irq, host);
@@ -828,9 +828,8 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
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
index 8d3edc34958e7..0b5fa254ea60a 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -940,7 +940,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	if (!res)
 		return res;
 
-	nand_release(mtd);
+	nand_release(chip);
 
 err_exit3:
 	dma_release_channel(host->dma_chan);
@@ -959,9 +959,8 @@ static int lpc32xx_nand_remove(struct platform_device *pdev)
 {
 	uint32_t tmp;
 	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 	dma_release_channel(host->dma_chan);
 
 	/* Force CE high */
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 7eacb2f545f50..9662f8fe47137 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -827,7 +827,7 @@ static int mpc5121_nfc_remove(struct platform_device *op)
 	struct device *dev = &op->dev;
 	struct mtd_info *mtd = dev_get_drvdata(dev);
 
-	nand_release(mtd);
+	nand_release(mtd_to_nand(mtd));
 	mpc5121_nfc_free(dev, mtd);
 
 	return 0;
diff --git a/drivers/mtd/nand/mtk_nand.c b/drivers/mtd/nand/mtk_nand.c
index ca95ae00215ec..fadc755e55f82 100644
--- a/drivers/mtd/nand/mtk_nand.c
+++ b/drivers/mtd/nand/mtk_nand.c
@@ -1327,7 +1327,7 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 	ret = mtd_device_parse_register(mtd, NULL, NULL, NULL, 0);
 	if (ret) {
 		dev_err(dev, "mtd parse partition error\n");
-		nand_release(mtd);
+		nand_release(nand);
 		return ret;
 	}
 
@@ -1450,7 +1450,7 @@ static int mtk_nfc_remove(struct platform_device *pdev)
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct mtk_nfc_nand_chip,
 					node);
-		nand_release(nand_to_mtd(&chip->nand));
+		nand_release(&chip->nand);
 		list_del(&chip->node);
 	}
 
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 5c44eb57885b9..deb3cbadbc519 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1838,7 +1838,7 @@ static int mxcnd_remove(struct platform_device *pdev)
 {
 	struct mxc_nand_host *host = platform_get_drvdata(pdev);
 
-	nand_release(nand_to_mtd(&host->nand));
+	nand_release(&host->nand);
 	if (host->clk_act)
 		clk_disable_unprepare(host->clk);
 
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 5fb45161789ce..bdf40c090acdc 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -4941,12 +4941,12 @@ EXPORT_SYMBOL_GPL(nand_cleanup);
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
index 1eb934414eb58..fe593f2f1ec7d 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -2394,7 +2394,7 @@ static int __init ns_init_module(void)
 
 err_exit:
 	free_nandsim(nand);
-	nand_release(nsmtd);
+	nand_release(chip);
 	for (i = 0;i < ARRAY_SIZE(nand->partitions); ++i)
 		kfree(nand->partitions[i].name);
 error:
@@ -2417,7 +2417,7 @@ static void __exit ns_cleanup_module(void)
 
 	nandsim_debugfs_remove(ns);
 	free_nandsim(ns);    /* Free nandsim private resources */
-	nand_release(nsmtd); /* Unregister driver */
+	nand_release(chip); /* Unregister driver */
 	for (i = 0;i < ARRAY_SIZE(ns->partitions); ++i)
 		kfree(ns->partitions[i].name);
 	kfree(mtd_to_nand(nsmtd));        /* Free other structures */
diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index 28e6118362f7e..d03b47d2664b0 100644
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
index 8f64011d32ef2..f7f54b46f246b 100644
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
index f3a516b3f108a..62c0ca437c91e 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -2307,7 +2307,7 @@ static int omap_nand_remove(struct platform_device *pdev)
 	}
 	if (info->dma)
 		dma_release_channel(info->dma);
-	nand_release(mtd);
+	nand_release(nand_chip);
 	return 0;
 }
 
diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index af2f09135fb0e..cfd53f0ba6c31 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -167,7 +167,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	mtd->name = "orion_nand";
 	ret = mtd_device_register(mtd, board->parts, board->nr_parts);
 	if (ret) {
-		nand_release(mtd);
+		nand_release(nc);
 		goto no_dev;
 	}
 
@@ -184,9 +184,8 @@ static int orion_nand_remove(struct platform_device *pdev)
 {
 	struct orion_nand_info *info = platform_get_drvdata(pdev);
 	struct nand_chip *chip = &info->chip;
-	struct mtd_info *mtd = nand_to_mtd(chip);
 
-	nand_release(mtd);
+	nand_release(chip);
 
 	if (!IS_ERR(info->clk))
 		clk_disable_unprepare(info->clk);
diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 80c98eef44d90..3300e43e2cb9f 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -194,7 +194,7 @@ static int pasemi_nand_remove(struct platform_device *ofdev)
 	chip = mtd_to_nand(pasemi_nand_mtd);
 
 	/* Release resources, unregister device */
-	nand_release(pasemi_nand_mtd);
+	nand_release(chip);
 
 	release_region(lpcctl, 4);
 
diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 415a53a0deeb3..245efb0f83e26 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -100,7 +100,7 @@ static int plat_nand_probe(struct platform_device *pdev)
 	if (!err)
 		return err;
 
-	nand_release(mtd);
+	nand_release(&data->chip);
 out:
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);
@@ -115,7 +115,7 @@ static int plat_nand_remove(struct platform_device *pdev)
 	struct plat_nand_data *data = platform_get_drvdata(pdev);
 	struct platform_nand_data *pdata = dev_get_platdata(&pdev->dev);
 
-	nand_release(nand_to_mtd(&data->chip));
+	nand_release(&data->chip);
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);
 
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 3b8911cd3a199..46f13f7e54da0 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1907,7 +1907,7 @@ static int pxa3xx_nand_remove(struct platform_device *pdev)
 	clk_disable_unprepare(info->clk);
 
 	for (cs = 0; cs < pdata->num_cs; cs++)
-		nand_release(nand_to_mtd(&info->host[cs]->chip));
+		nand_release(&info->host[cs]->chip);
 	return 0;
 }
 
diff --git a/drivers/mtd/nand/qcom_nandc.c b/drivers/mtd/nand/qcom_nandc.c
index 9f6c9a34b9eb6..1594770987fdb 100644
--- a/drivers/mtd/nand/qcom_nandc.c
+++ b/drivers/mtd/nand/qcom_nandc.c
@@ -2163,7 +2163,7 @@ static int qcom_nandc_probe(struct platform_device *pdev)
 
 err_cs_init:
 	list_for_each_entry(host, &nandc->host_list, node)
-		nand_release(nand_to_mtd(&host->chip));
+		nand_release(&host->chip);
 err_setup:
 	clk_disable_unprepare(nandc->aon_clk);
 err_aon_clk:
@@ -2180,7 +2180,7 @@ static int qcom_nandc_remove(struct platform_device *pdev)
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
index d459c19d78de3..be9c145b743c9 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -768,7 +768,7 @@ static int s3c24xx_nand_remove(struct platform_device *pdev)
 
 		for (mtdno = 0; mtdno < info->mtd_count; mtdno++, ptr++) {
 			pr_debug("releasing mtd %d (%p)\n", mtdno, ptr);
-			nand_release(nand_to_mtd(&ptr->chip));
+			nand_release(&ptr->chip);
 		}
 	}
 
diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index d6c013f93b8c0..31f98acdba073 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -1229,7 +1229,7 @@ static int flctl_remove(struct platform_device *pdev)
 	struct sh_flctl *flctl = platform_get_drvdata(pdev);
 
 	flctl_release_dma(flctl);
-	nand_release(nand_to_mtd(&flctl->chip));
+	nand_release(&flctl->chip);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
diff --git a/drivers/mtd/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c
index 064ca1757589a..70e28bfeb840f 100644
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
index 888fd314c62a2..f633ff1ebc0ab 100644
--- a/drivers/mtd/nand/socrates_nand.c
+++ b/drivers/mtd/nand/socrates_nand.c
@@ -203,7 +203,7 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 	if (!res)
 		return res;
 
-	nand_release(mtd);
+	nand_release(nand_chip);
 
 out:
 	iounmap(host->io_base);
@@ -216,9 +216,8 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 static int socrates_nand_remove(struct platform_device *ofdev)
 {
 	struct socrates_nand_host *host = dev_get_drvdata(&ofdev->dev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
-	nand_release(mtd);
+	nand_release(&host->nand_chip);
 
 	iounmap(host->io_base);
 
diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 886355bfa7617..ddf3e24cc2898 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -2108,7 +2108,7 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "failed to register mtd device: %d\n", ret);
-		nand_release(mtd);
+		nand_release(nand);
 		return ret;
 	}
 
@@ -2147,7 +2147,7 @@ static void sunxi_nand_chips_cleanup(struct sunxi_nfc *nfc)
 	while (!list_empty(&nfc->chips)) {
 		chip = list_first_entry(&nfc->chips, struct sunxi_nand_chip,
 					node);
-		nand_release(nand_to_mtd(&chip->nand));
+		nand_release(&chip->nand);
 		sunxi_nand_ecc_cleanup(&chip->nand.ecc);
 		list_del(&chip->node);
 	}
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 08b30549ec0a0..1deb5229db15d 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -446,7 +446,7 @@ static int tmio_probe(struct platform_device *dev)
 	if (!retval)
 		return retval;
 
-	nand_release(mtd);
+	nand_release(nand_chip);
 
 err_irq:
 	tmio_hw_stop(dev, tmio);
@@ -457,7 +457,7 @@ static int tmio_remove(struct platform_device *dev)
 {
 	struct tmio_nand *tmio = platform_get_drvdata(dev);
 
-	nand_release(nand_to_mtd(&tmio->chip));
+	nand_release(&tmio->chip);
 	tmio_hw_stop(dev, tmio);
 	return 0;
 }
diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index 0a14fda2e41bf..f2ba55b0a1e9d 100644
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
index ddc629e3f63a6..ec004e0a94a32 100644
--- a/drivers/mtd/nand/vf610_nfc.c
+++ b/drivers/mtd/nand/vf610_nfc.c
@@ -795,7 +795,7 @@ static int vf610_nfc_remove(struct platform_device *pdev)
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
 	struct vf610_nfc *nfc = mtd_to_nfc(mtd);
 
-	nand_release(mtd);
+	nand_release(mtd_to_nand(mtd));
 	clk_disable_unprepare(nfc->clk);
 	return 0;
 }
diff --git a/drivers/mtd/nand/xway_nand.c b/drivers/mtd/nand/xway_nand.c
index 895101a5e6864..d374a0007960a 100644
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
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index d8905a229f348..573e744223a24 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -24,6 +24,7 @@
 #include <linux/mtd/flashchip.h>
 #include <linux/mtd/bbm.h>
 
+struct nand_chip;
 struct mtd_info;
 struct nand_flash_dev;
 struct device_node;
@@ -39,7 +40,7 @@ int nand_scan_ident(struct mtd_info *mtd, int max_chips,
 int nand_scan_tail(struct mtd_info *mtd);
 
 /* Unregister the MTD device and free resources held by the NAND device */
-void nand_release(struct mtd_info *mtd);
+void nand_release(struct nand_chip *chip);
 
 /* Internal helper for board drivers which need to override command function */
 void nand_wait_ready(struct mtd_info *mtd);
@@ -219,9 +220,6 @@ enum nand_ecc_algo {
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

