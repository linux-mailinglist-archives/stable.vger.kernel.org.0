Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB892598D2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIAQdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbgIAPbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:31:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4742E205F4;
        Tue,  1 Sep 2020 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974304;
        bh=ySBnpwnF0CNXjCXAEVMorz59mCAeieq6TpQ0Z/HUrxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmFWNKwUIhSlr+HMX4yYCtyB8A+mELT+IY2Z6gCN7HHfRXkHpJeG2ieHJX+mynq2w
         WelXk9E+pd8dOUdxeeeFYX+hEOQKCwBSTFLzF6X5ElR2bog7HO6MXvnlakuKsDjro1
         BK5PcHUjVwzYoRA3FXkrSp1w0+KqqT97zsVDTCZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/214] spi: stm32: fix fifo threshold level in case of short transfer
Date:   Tue,  1 Sep 2020 17:10:03 +0200
Message-Id: <20200901150958.878202484@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 25b1348aaa549..f092bc8e00819 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -469,20 +469,27 @@ static int stm32_spi_prepare_mbr(struct stm32_spi *spi, u32 speed_hz,
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
@@ -490,6 +497,9 @@ static u32 stm32h7_spi_prepare_fthlv(struct stm32_spi *spi)
 	else
 		fthlv -= (fthlv % 4); /* multiple of 4 */
 
+	if (!fthlv)
+		fthlv = 1;
+
 	return fthlv;
 }
 
@@ -1396,7 +1406,7 @@ static void stm32h7_spi_set_bpw(struct stm32_spi *spi)
 	cfg1_setb |= (bpw << STM32H7_SPI_CFG1_DSIZE_SHIFT) &
 		     STM32H7_SPI_CFG1_DSIZE;
 
-	spi->cur_fthlv = stm32h7_spi_prepare_fthlv(spi);
+	spi->cur_fthlv = stm32h7_spi_prepare_fthlv(spi, spi->cur_xferlen);
 	fthlv = spi->cur_fthlv - 1;
 
 	cfg1_clrb |= STM32H7_SPI_CFG1_FTHLV;
@@ -1582,6 +1592,8 @@ static int stm32_spi_transfer_one_setup(struct stm32_spi *spi,
 
 	spin_lock_irqsave(&spi->lock, flags);
 
+	spi->cur_xferlen = transfer->len;
+
 	if (spi->cur_bpw != transfer->bits_per_word) {
 		spi->cur_bpw = transfer->bits_per_word;
 		spi->cfg->set_bpw(spi);
@@ -1629,8 +1641,6 @@ static int stm32_spi_transfer_one_setup(struct stm32_spi *spi,
 			goto out;
 	}
 
-	spi->cur_xferlen = transfer->len;
-
 	dev_dbg(spi->dev, "transfer communication mode set to %d\n",
 		spi->cur_comm);
 	dev_dbg(spi->dev,
-- 
2.25.1



