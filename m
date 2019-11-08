Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01C2F4A6C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388605AbfKHMJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732002AbfKHLkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32AE21D6C;
        Fri,  8 Nov 2019 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213216;
        bh=0mGVJ9uX0ARCdCw/vdbCln6Nb+99wd6SXVvf6W+1R9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTC0Nu/qdXdlBTkwZMo8WNPLwzFTvh6uI5VIiMmUo9wmcAp3GAIpZf0bQLrNAoqTo
         6Kq6JlP9iCcYbvySj2sEcohVpeLpkJxfPqCD9aK0x7vdAK089rA7vpavmNH5xx50X+
         itgAYc9/oiQWU2hGD6/casGcKECprTGycFsdo7Jk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jun Gao <jun.gao@mediatek.com>, Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 095/205] i2c: mediatek: Use DMA safe buffers for i2c transactions
Date:   Fri,  8 Nov 2019 06:36:02 -0500
Message-Id: <20191108113752.12502-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

