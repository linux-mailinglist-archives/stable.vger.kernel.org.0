Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD452502B1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHXQfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgHXQfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0895422BEF;
        Mon, 24 Aug 2020 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286923;
        bh=3Z4SzG6bQVywb4kSotX/ty/YSGXXSZc0jjqdPcVYsRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+kHDGZFY/2qChNQG7tEkWuA2Fh2eU0XBdeJPf1xu+Ype5GGyEDx6FSCmCXtg5zlp
         0d8+0cg5q55SW0IKMBKyPwxVyw+40nXfZQlooEOFlVWgD9zpH9EbAHsCHgEkGJnoYP
         XuYd76DRq9FahrXe+hIzIZR23KMQA4orNMpkgoBE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@st.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 14/63] spi: stm32: fix fifo threshold level in case of short transfer
Date:   Mon, 24 Aug 2020 12:34:14 -0400
Message-Id: <20200824163504.605538-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit 3373e9004acc0603242622b4378c64bc01d21b5f ]

When transfer is shorter than half of the fifo, set the data packet size
up to transfer size instead of up to half of the fifo.
Check also that threshold is set at least to 1 data frame.

Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Link: https://lore.kernel.org/r/1597043558-29668-3-git-send-email-alain.volmat@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 814a3ec3b8ada..e5450233f3f8b 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -467,20 +467,27 @@ static int stm32_spi_prepare_mbr(struct stm32_spi *spi, u32 speed_hz,
 /**
  * stm32h7_spi_prepare_fthlv - Determine FIFO threshold level
  * @spi: pointer to the spi controller data structure
+ * @xfer_len: length of the message to be transferred
  */
-static u32 stm32h7_spi_prepare_fthlv(struct stm32_spi *spi)
+static u32 stm32h7_spi_prepare_fthlv(struct stm32_spi *spi, u32 xfer_len)
 {
-	u32 fthlv, half_fifo;
+	u32 fthlv, half_fifo, packet;
 
 	/* data packet should not exceed 1/2 of fifo space */
 	half_fifo = (spi->fifo_size / 2);
 
+	/* data_packet should not exceed transfer length */
+	if (half_fifo > xfer_len)
+		packet = xfer_len;
+	else
+		packet = half_fifo;
+
 	if (spi->cur_bpw <= 8)
-		fthlv = half_fifo;
+		fthlv = packet;
 	else if (spi->cur_bpw <= 16)
-		fthlv = half_fifo / 2;
+		fthlv = packet / 2;
 	else
-		fthlv = half_fifo / 4;
+		fthlv = packet / 4;
 
 	/* align packet size with data registers access */
 	if (spi->cur_bpw > 8)
@@ -488,6 +495,9 @@ static u32 stm32h7_spi_prepare_fthlv(struct stm32_spi *spi)
 	else
 		fthlv -= (fthlv % 4); /* multiple of 4 */
 
+	if (!fthlv)
+		fthlv = 1;
+
 	return fthlv;
 }
 
@@ -1393,7 +1403,7 @@ static void stm32h7_spi_set_bpw(struct stm32_spi *spi)
 	cfg1_setb |= (bpw << STM32H7_SPI_CFG1_DSIZE_SHIFT) &
 		     STM32H7_SPI_CFG1_DSIZE;
 
-	spi->cur_fthlv = stm32h7_spi_prepare_fthlv(spi);
+	spi->cur_fthlv = stm32h7_spi_prepare_fthlv(spi, spi->cur_xferlen);
 	fthlv = spi->cur_fthlv - 1;
 
 	cfg1_clrb |= STM32H7_SPI_CFG1_FTHLV;
@@ -1588,6 +1598,8 @@ static int stm32_spi_transfer_one_setup(struct stm32_spi *spi,
 
 	spin_lock_irqsave(&spi->lock, flags);
 
+	spi->cur_xferlen = transfer->len;
+
 	if (spi->cur_bpw != transfer->bits_per_word) {
 		spi->cur_bpw = transfer->bits_per_word;
 		spi->cfg->set_bpw(spi);
@@ -1635,8 +1647,6 @@ static int stm32_spi_transfer_one_setup(struct stm32_spi *spi,
 			goto out;
 	}
 
-	spi->cur_xferlen = transfer->len;
-
 	dev_dbg(spi->dev, "transfer communication mode set to %d\n",
 		spi->cur_comm);
 	dev_dbg(spi->dev,
-- 
2.25.1

