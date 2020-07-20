Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80715227117
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgGTVjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbgGTVjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:39:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF9F22CF7;
        Mon, 20 Jul 2020 21:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281161;
        bh=5UrXs5K40IkwuyX6XDwLrEXO6fTXoOdDk5vlpHZthbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccZj7N0Wb8E+w5sxc2eZ280GKdLyOpoCUYQrECf8wYsTIEnmcf7UV0jmxY9KcjRNW
         umG87NKxvWUxawilyO9uHnQvAms+171iiJcAiGf/apcvAGQr8VuZtkA4T3ktgpF+Wi
         Y1IP8yfZKJuIOvgcUPMXfHFZFN6+qHJZroo8q6xk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "leilk.liu" <leilk.liu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 05/13] spi: mediatek: use correct SPI_CFG2_REG MACRO
Date:   Mon, 20 Jul 2020 17:39:06 -0400
Message-Id: <20200720213914.407919-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213914.407919-1-sashal@kernel.org>
References: <20200720213914.407919-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "leilk.liu" <leilk.liu@mediatek.com>

[ Upstream commit 44b37eb79e16a56cb30ba55b2da452396b941e7a ]

this patch use correct SPI_CFG2_REG offset.

Signed-off-by: leilk.liu <leilk.liu@mediatek.com>
Link: https://lore.kernel.org/r/20200701090020.7935-1-leilk.liu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 0c2867deb36fc..da28c52c9da19 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -41,7 +41,6 @@
 #define SPI_CFG0_SCK_LOW_OFFSET           8
 #define SPI_CFG0_CS_HOLD_OFFSET           16
 #define SPI_CFG0_CS_SETUP_OFFSET          24
-#define SPI_ADJUST_CFG0_SCK_LOW_OFFSET    16
 #define SPI_ADJUST_CFG0_CS_HOLD_OFFSET    0
 #define SPI_ADJUST_CFG0_CS_SETUP_OFFSET   16
 
@@ -53,6 +52,8 @@
 #define SPI_CFG1_CS_IDLE_MASK             0xff
 #define SPI_CFG1_PACKET_LOOP_MASK         0xff00
 #define SPI_CFG1_PACKET_LENGTH_MASK       0x3ff0000
+#define SPI_CFG2_SCK_HIGH_OFFSET          0
+#define SPI_CFG2_SCK_LOW_OFFSET           16
 
 #define SPI_CMD_ACT                  BIT(0)
 #define SPI_CMD_RESUME               BIT(1)
@@ -259,7 +260,7 @@ static void mtk_spi_set_cs(struct spi_device *spi, bool enable)
 static void mtk_spi_prepare_transfer(struct spi_master *master,
 				     struct spi_transfer *xfer)
 {
-	u32 spi_clk_hz, div, sck_time, cs_time, reg_val = 0;
+	u32 spi_clk_hz, div, sck_time, cs_time, reg_val;
 	struct mtk_spi *mdata = spi_master_get_devdata(master);
 
 	spi_clk_hz = clk_get_rate(mdata->spi_clk);
@@ -272,18 +273,18 @@ static void mtk_spi_prepare_transfer(struct spi_master *master,
 	cs_time = sck_time * 2;
 
 	if (mdata->dev_comp->enhance_timing) {
+		reg_val = (((sck_time - 1) & 0xffff)
+			   << SPI_CFG2_SCK_HIGH_OFFSET);
 		reg_val |= (((sck_time - 1) & 0xffff)
-			   << SPI_CFG0_SCK_HIGH_OFFSET);
-		reg_val |= (((sck_time - 1) & 0xffff)
-			   << SPI_ADJUST_CFG0_SCK_LOW_OFFSET);
+			   << SPI_CFG2_SCK_LOW_OFFSET);
 		writel(reg_val, mdata->base + SPI_CFG2_REG);
-		reg_val |= (((cs_time - 1) & 0xffff)
+		reg_val = (((cs_time - 1) & 0xffff)
 			   << SPI_ADJUST_CFG0_CS_HOLD_OFFSET);
 		reg_val |= (((cs_time - 1) & 0xffff)
 			   << SPI_ADJUST_CFG0_CS_SETUP_OFFSET);
 		writel(reg_val, mdata->base + SPI_CFG0_REG);
 	} else {
-		reg_val |= (((sck_time - 1) & 0xff)
+		reg_val = (((sck_time - 1) & 0xff)
 			   << SPI_CFG0_SCK_HIGH_OFFSET);
 		reg_val |= (((sck_time - 1) & 0xff) << SPI_CFG0_SCK_LOW_OFFSET);
 		reg_val |= (((cs_time - 1) & 0xff) << SPI_CFG0_CS_HOLD_OFFSET);
-- 
2.25.1

