Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50341013F9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfKSF3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbfKSF3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F39208C3;
        Tue, 19 Nov 2019 05:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141342;
        bh=0mGVJ9uX0ARCdCw/vdbCln6Nb+99wd6SXVvf6W+1R9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+D3G4RFix6I+VJuhjoyJoNo0mPkGvhD38FSf7uudAMpKiS7kVsZ4WF95UVgUXcdM
         7MmY96FxQ/L+KeAia8dHfpXaKLupEIUOUnJEY5seth08P9bheFIQj1Fvaq/BCYL2BD
         xQ0GPyKFI8Abxw0H4Yy+g6tVrnBw7bEUJeLfbc08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Gao <jun.gao@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 127/422] i2c: mediatek: Use DMA safe buffers for i2c transactions
Date:   Tue, 19 Nov 2019 06:15:24 +0100
Message-Id: <20191119051407.175902069@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Gao <jun.gao@mediatek.com>

[ Upstream commit fc66b39fe36acfd06f716e338de7cd8f9550fad2 ]

DMA mode will always be used in i2c transactions, try to allocate
a DMA safe buffer if the buf of struct i2c_msg used is not DMA safe.

Signed-off-by: Jun Gao <jun.gao@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 62 +++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 1e57f58fcb001..a74ef76705e0c 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -441,6 +441,8 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
 	u16 control_reg;
 	u16 restart_flag = 0;
 	u32 reg_4g_mode;
+	u8 *dma_rd_buf = NULL;
+	u8 *dma_wr_buf = NULL;
 	dma_addr_t rpaddr = 0;
 	dma_addr_t wpaddr = 0;
 	int ret;
@@ -500,10 +502,18 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
 	if (i2c->op == I2C_MASTER_RD) {
 		writel(I2C_DMA_INT_FLAG_NONE, i2c->pdmabase + OFFSET_INT_FLAG);
 		writel(I2C_DMA_CON_RX, i2c->pdmabase + OFFSET_CON);
-		rpaddr = dma_map_single(i2c->dev, msgs->buf,
+
+		dma_rd_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
+		if (!dma_rd_buf)
+			return -ENOMEM;
+
+		rpaddr = dma_map_single(i2c->dev, dma_rd_buf,
 					msgs->len, DMA_FROM_DEVICE);
-		if (dma_mapping_error(i2c->dev, rpaddr))
+		if (dma_mapping_error(i2c->dev, rpaddr)) {
+			i2c_put_dma_safe_msg_buf(dma_rd_buf, msgs, false);
+
 			return -ENOMEM;
+		}
 
 		if (i2c->dev_comp->support_33bits) {
 			reg_4g_mode = mtk_i2c_set_4g_mode(rpaddr);
@@ -515,10 +525,18 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
 	} else if (i2c->op == I2C_MASTER_WR) {
 		writel(I2C_DMA_INT_FLAG_NONE, i2c->pdmabase + OFFSET_INT_FLAG);
 		writel(I2C_DMA_CON_TX, i2c->pdmabase + OFFSET_CON);
-		wpaddr = dma_map_single(i2c->dev, msgs->buf,
+
+		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
+		if (!dma_wr_buf)
+			return -ENOMEM;
+
+		wpaddr = dma_map_single(i2c->dev, dma_wr_buf,
 					msgs->len, DMA_TO_DEVICE);
-		if (dma_mapping_error(i2c->dev, wpaddr))
+		if (dma_mapping_error(i2c->dev, wpaddr)) {
+			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
+
 			return -ENOMEM;
+		}
 
 		if (i2c->dev_comp->support_33bits) {
 			reg_4g_mode = mtk_i2c_set_4g_mode(wpaddr);
@@ -530,16 +548,39 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
 	} else {
 		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_INT_FLAG);
 		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_CON);
-		wpaddr = dma_map_single(i2c->dev, msgs->buf,
+
+		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
+		if (!dma_wr_buf)
+			return -ENOMEM;
+
+		wpaddr = dma_map_single(i2c->dev, dma_wr_buf,
 					msgs->len, DMA_TO_DEVICE);
-		if (dma_mapping_error(i2c->dev, wpaddr))
+		if (dma_mapping_error(i2c->dev, wpaddr)) {
+			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
+
 			return -ENOMEM;
-		rpaddr = dma_map_single(i2c->dev, (msgs + 1)->buf,
+		}
+
+		dma_rd_buf = i2c_get_dma_safe_msg_buf((msgs + 1), 0);
+		if (!dma_rd_buf) {
+			dma_unmap_single(i2c->dev, wpaddr,
+					 msgs->len, DMA_TO_DEVICE);
+
+			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
+
+			return -ENOMEM;
+		}
+
+		rpaddr = dma_map_single(i2c->dev, dma_rd_buf,
 					(msgs + 1)->len,
 					DMA_FROM_DEVICE);
 		if (dma_mapping_error(i2c->dev, rpaddr)) {
 			dma_unmap_single(i2c->dev, wpaddr,
 					 msgs->len, DMA_TO_DEVICE);
+
+			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
+			i2c_put_dma_safe_msg_buf(dma_rd_buf, (msgs + 1), false);
+
 			return -ENOMEM;
 		}
 
@@ -578,14 +619,21 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
 	if (i2c->op == I2C_MASTER_WR) {
 		dma_unmap_single(i2c->dev, wpaddr,
 				 msgs->len, DMA_TO_DEVICE);
+
+		i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, true);
 	} else if (i2c->op == I2C_MASTER_RD) {
 		dma_unmap_single(i2c->dev, rpaddr,
 				 msgs->len, DMA_FROM_DEVICE);
+
+		i2c_put_dma_safe_msg_buf(dma_rd_buf, msgs, true);
 	} else {
 		dma_unmap_single(i2c->dev, wpaddr, msgs->len,
 				 DMA_TO_DEVICE);
 		dma_unmap_single(i2c->dev, rpaddr, (msgs + 1)->len,
 				 DMA_FROM_DEVICE);
+
+		i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, true);
+		i2c_put_dma_safe_msg_buf(dma_rd_buf, (msgs + 1), true);
 	}
 
 	if (ret == 0) {
-- 
2.20.1



