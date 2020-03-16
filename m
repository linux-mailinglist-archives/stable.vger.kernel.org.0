Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179B0186311
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgCPCj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbgCPCeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5536F20737;
        Mon, 16 Mar 2020 02:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326054;
        bh=zzaahmDT84UeYapfyePLPQkSNdpaQfj2oAJEjcsBFBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsLeHK5n/l9VZaKj65bTLcd1Y1hCYY3j81Q2N1DujzN5LofjY6wyV74/ZopJkcd3O
         Fdilx+HeO7Fiv9jnQJY3lCEmsuo9MiOKtdLfVKTTsNk+efujpTWXrc9bzbFEkrUbNv
         UzSGUBQAmT8MEwzolXYJlyGehsBa59jkL1dMsaFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/35] spi: spi-omap2-mcspi: Support probe deferral for DMA channels
Date:   Sun, 15 Mar 2020 22:33:38 -0400
Message-Id: <20200316023411.1263-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 32f2fc5dc3992b4b60cc6b1a6a31be605cc9c3a2 ]

dma_request_channel() can return -EPROBE_DEFER, if DMA driver is not
ready. Currently driver just falls back to PIO mode on probe deferral.
Fix this by requesting all required channels during probe and
propagating EPROBE_DEFER error code.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20200204124816.16735-3-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 77 +++++++++++++++++------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 8e435da730996..cfb64e5a7d45d 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -986,20 +986,12 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
  * Note that we currently allow DMA only if we get a channel
  * for both rx and tx. Otherwise we'll do PIO for both rx and tx.
  */
-static int omap2_mcspi_request_dma(struct spi_device *spi)
+static int omap2_mcspi_request_dma(struct omap2_mcspi *mcspi,
+				   struct omap2_mcspi_dma *mcspi_dma)
 {
-	struct spi_master	*master = spi->master;
-	struct omap2_mcspi	*mcspi;
-	struct omap2_mcspi_dma	*mcspi_dma;
 	int ret = 0;
 
-	mcspi = spi_master_get_devdata(master);
-	mcspi_dma = mcspi->dma_channels + spi->chip_select;
-
-	init_completion(&mcspi_dma->dma_rx_completion);
-	init_completion(&mcspi_dma->dma_tx_completion);
-
-	mcspi_dma->dma_rx = dma_request_chan(&master->dev,
+	mcspi_dma->dma_rx = dma_request_chan(mcspi->dev,
 					     mcspi_dma->dma_rx_ch_name);
 	if (IS_ERR(mcspi_dma->dma_rx)) {
 		ret = PTR_ERR(mcspi_dma->dma_rx);
@@ -1007,7 +999,7 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
 		goto no_dma;
 	}
 
-	mcspi_dma->dma_tx = dma_request_chan(&master->dev,
+	mcspi_dma->dma_tx = dma_request_chan(mcspi->dev,
 					     mcspi_dma->dma_tx_ch_name);
 	if (IS_ERR(mcspi_dma->dma_tx)) {
 		ret = PTR_ERR(mcspi_dma->dma_tx);
@@ -1016,20 +1008,40 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
 		mcspi_dma->dma_rx = NULL;
 	}
 
+	init_completion(&mcspi_dma->dma_rx_completion);
+	init_completion(&mcspi_dma->dma_tx_completion);
+
 no_dma:
 	return ret;
 }
 
+static void omap2_mcspi_release_dma(struct spi_master *master)
+{
+	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
+	struct omap2_mcspi_dma	*mcspi_dma;
+	int i;
+
+	for (i = 0; i < master->num_chipselect; i++) {
+		mcspi_dma = &mcspi->dma_channels[i];
+
+		if (mcspi_dma->dma_rx) {
+			dma_release_channel(mcspi_dma->dma_rx);
+			mcspi_dma->dma_rx = NULL;
+		}
+		if (mcspi_dma->dma_tx) {
+			dma_release_channel(mcspi_dma->dma_tx);
+			mcspi_dma->dma_tx = NULL;
+		}
+	}
+}
+
 static int omap2_mcspi_setup(struct spi_device *spi)
 {
 	int			ret;
 	struct omap2_mcspi	*mcspi = spi_master_get_devdata(spi->master);
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
-	struct omap2_mcspi_dma	*mcspi_dma;
 	struct omap2_mcspi_cs	*cs = spi->controller_state;
 
-	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
-
 	if (!cs) {
 		cs = kzalloc(sizeof *cs, GFP_KERNEL);
 		if (!cs)
@@ -1054,13 +1066,6 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 		}
 	}
 
-	if (!mcspi_dma->dma_rx || !mcspi_dma->dma_tx) {
-		ret = omap2_mcspi_request_dma(spi);
-		if (ret)
-			dev_warn(&spi->dev, "not using DMA for McSPI (%d)\n",
-				 ret);
-	}
-
 	ret = pm_runtime_get_sync(mcspi->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(mcspi->dev);
@@ -1077,12 +1082,8 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 
 static void omap2_mcspi_cleanup(struct spi_device *spi)
 {
-	struct omap2_mcspi	*mcspi;
-	struct omap2_mcspi_dma	*mcspi_dma;
 	struct omap2_mcspi_cs	*cs;
 
-	mcspi = spi_master_get_devdata(spi->master);
-
 	if (spi->controller_state) {
 		/* Unlink controller state from context save list */
 		cs = spi->controller_state;
@@ -1091,19 +1092,6 @@ static void omap2_mcspi_cleanup(struct spi_device *spi)
 		kfree(cs);
 	}
 
-	if (spi->chip_select < spi->master->num_chipselect) {
-		mcspi_dma = &mcspi->dma_channels[spi->chip_select];
-
-		if (mcspi_dma->dma_rx) {
-			dma_release_channel(mcspi_dma->dma_rx);
-			mcspi_dma->dma_rx = NULL;
-		}
-		if (mcspi_dma->dma_tx) {
-			dma_release_channel(mcspi_dma->dma_tx);
-			mcspi_dma->dma_tx = NULL;
-		}
-	}
-
 	if (gpio_is_valid(spi->cs_gpio))
 		gpio_free(spi->cs_gpio);
 }
@@ -1314,6 +1302,9 @@ static bool omap2_mcspi_can_dma(struct spi_master *master,
 	if (spi_controller_is_slave(master))
 		return true;
 
+	master->dma_rx = mcspi_dma->dma_rx;
+	master->dma_tx = mcspi_dma->dma_tx;
+
 	return (xfer->len >= DMA_MIN_BYTES);
 }
 
@@ -1501,6 +1492,11 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	for (i = 0; i < master->num_chipselect; i++) {
 		sprintf(mcspi->dma_channels[i].dma_rx_ch_name, "rx%d", i);
 		sprintf(mcspi->dma_channels[i].dma_tx_ch_name, "tx%d", i);
+
+		status = omap2_mcspi_request_dma(mcspi,
+						 &mcspi->dma_channels[i]);
+		if (status == -EPROBE_DEFER)
+			goto free_master;
 	}
 
 	status = platform_get_irq(pdev, 0);
@@ -1538,6 +1534,7 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_master:
+	omap2_mcspi_release_dma(master);
 	spi_master_put(master);
 	return status;
 }
@@ -1547,6 +1544,8 @@ static int omap2_mcspi_remove(struct platform_device *pdev)
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
 
+	omap2_mcspi_release_dma(master);
+
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
 	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.20.1

