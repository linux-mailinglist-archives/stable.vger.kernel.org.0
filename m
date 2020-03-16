Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A41862CF
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgCPCdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729329AbgCPCdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E73920722;
        Mon, 16 Mar 2020 02:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326001;
        bh=+/WGUNoF/bF3Pf95IXpvlyflqkUl1JePo02WWXc+lvk=;
        h=From:To:Cc:Subject:Date:From;
        b=L8wjCgeGzN6zehmhOGc7JZZhdSuqmeheTm2xt6GRDeTMUzhjMuqQ6WtDNVNN4mI+v
         FI0ut5eUKrrpsOpJE0bbU0XKrH5lIzGAJc910NbIEB6bb36SbN4A2kPCUukRL8AjSr
         yyUgoqXoGA1KB1TtDMPjoPYTioN15Q9P+WNHTNUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 01/41] spi: spi-omap2-mcspi: Handle DMA size restriction on AM65x
Date:   Sun, 15 Mar 2020 22:32:39 -0400
Message-Id: <20200316023319.749-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit e4e8276a4f652be2c7bb783a0155d4adb85f5d7d ]

On AM654, McSPI can only support 4K - 1 bytes per transfer when DMA is
enabled. Therefore populate master->max_transfer_size callback to
inform client drivers of this restriction when DMA channels are
available.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20200204124816.16735-2-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c                 | 26 +++++++++++++++++++
 include/linux/platform_data/spi-omap2-mcspi.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 7e2292c11d120..e9bc9cf984d60 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -130,6 +130,7 @@ struct omap2_mcspi {
 	int			fifo_depth;
 	bool			slave_aborted;
 	unsigned int		pin_dir:1;
+	size_t			max_xfer_len;
 };
 
 struct omap2_mcspi_cs {
@@ -1305,6 +1306,18 @@ static bool omap2_mcspi_can_dma(struct spi_master *master,
 	return (xfer->len >= DMA_MIN_BYTES);
 }
 
+static size_t omap2_mcspi_max_xfer_size(struct spi_device *spi)
+{
+	struct omap2_mcspi *mcspi = spi_master_get_devdata(spi->master);
+	struct omap2_mcspi_dma *mcspi_dma =
+		&mcspi->dma_channels[spi->chip_select];
+
+	if (mcspi->max_xfer_len && mcspi_dma->dma_rx)
+		return mcspi->max_xfer_len;
+
+	return SIZE_MAX;
+}
+
 static int omap2_mcspi_controller_setup(struct omap2_mcspi *mcspi)
 {
 	struct spi_master	*master = mcspi->master;
@@ -1373,6 +1386,11 @@ static struct omap2_mcspi_platform_config omap4_pdata = {
 	.regs_offset = OMAP4_MCSPI_REG_OFFSET,
 };
 
+static struct omap2_mcspi_platform_config am654_pdata = {
+	.regs_offset = OMAP4_MCSPI_REG_OFFSET,
+	.max_xfer_len = SZ_4K - 1,
+};
+
 static const struct of_device_id omap_mcspi_of_match[] = {
 	{
 		.compatible = "ti,omap2-mcspi",
@@ -1382,6 +1400,10 @@ static const struct of_device_id omap_mcspi_of_match[] = {
 		.compatible = "ti,omap4-mcspi",
 		.data = &omap4_pdata,
 	},
+	{
+		.compatible = "ti,am654-mcspi",
+		.data = &am654_pdata,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, omap_mcspi_of_match);
@@ -1439,6 +1461,10 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 		mcspi->pin_dir = pdata->pin_dir;
 	}
 	regs_offset = pdata->regs_offset;
+	if (pdata->max_xfer_len) {
+		mcspi->max_xfer_len = pdata->max_xfer_len;
+		master->max_transfer_size = omap2_mcspi_max_xfer_size;
+	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mcspi->base = devm_ioremap_resource(&pdev->dev, r);
diff --git a/include/linux/platform_data/spi-omap2-mcspi.h b/include/linux/platform_data/spi-omap2-mcspi.h
index 0bf9fddb83064..3b400b1919a9b 100644
--- a/include/linux/platform_data/spi-omap2-mcspi.h
+++ b/include/linux/platform_data/spi-omap2-mcspi.h
@@ -11,6 +11,7 @@ struct omap2_mcspi_platform_config {
 	unsigned short	num_cs;
 	unsigned int regs_offset;
 	unsigned int pin_dir:1;
+	size_t max_xfer_len;
 };
 
 struct omap2_mcspi_device_config {
-- 
2.20.1

