Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17E42F79F7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733069AbhAOMnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388229AbhAOMiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67D4722473;
        Fri, 15 Jan 2021 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714294;
        bh=Zk2Lza44DFglugqkJ6sQUaVNQXbZ4UPQR3yAhYBD8CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+cNdekauF8eQUW2ecEwRVWjdeqHBjr86X3q5SmVL8jMCU5WJ7SVOZVSMS9GJw9+j
         mR8INCTNlowvrCehlq+CDP0YwGrQz5iyz1zmVrFvNqQrQJC2EjzETSeBVFrE8ktHFF
         dApBPtNlaNY0/vqQ1x99FVPpFhem7ooduyTbkBuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 064/103] i2c: mediatek: Fix apdma and i2c hand-shake timeout
Date:   Fri, 15 Jan 2021 13:27:57 +0100
Message-Id: <20210115122009.141328698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

commit 05f6f7271a38c482c5021967433f7b698e102c45 upstream.

With the apdma remove hand-shake signal, it requirs special
operation timing to reset i2c manually, otherwise the interrupt
will not be triggered, i2c transmission will be timeout.

Fixes: 8426fe70cfa4("i2c: mediatek: Add apdma sync in i2c driver")
Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-mt65xx.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -38,6 +38,7 @@
 #define I2C_IO_CONFIG_OPEN_DRAIN	0x0003
 #define I2C_IO_CONFIG_PUSH_PULL		0x0000
 #define I2C_SOFT_RST			0x0001
+#define I2C_HANDSHAKE_RST		0x0020
 #define I2C_FIFO_ADDR_CLR		0x0001
 #define I2C_DELAY_LEN			0x0002
 #define I2C_TIME_CLR_VALUE		0x0000
@@ -45,6 +46,7 @@
 #define I2C_WRRD_TRANAC_VALUE		0x0002
 #define I2C_RD_TRANAC_VALUE		0x0001
 #define I2C_SCL_MIS_COMP_VALUE		0x0000
+#define I2C_CHN_CLR_FLAG		0x0000
 
 #define I2C_DMA_CON_TX			0x0000
 #define I2C_DMA_CON_RX			0x0001
@@ -54,7 +56,9 @@
 #define I2C_DMA_START_EN		0x0001
 #define I2C_DMA_INT_FLAG_NONE		0x0000
 #define I2C_DMA_CLR_FLAG		0x0000
+#define I2C_DMA_WARM_RST		0x0001
 #define I2C_DMA_HARD_RST		0x0002
+#define I2C_DMA_HANDSHAKE_RST		0x0004
 
 #define MAX_SAMPLE_CNT_DIV		8
 #define MAX_STEP_CNT_DIV		64
@@ -475,11 +479,24 @@ static void mtk_i2c_init_hw(struct mtk_i
 {
 	u16 control_reg;
 
-	writel(I2C_DMA_HARD_RST, i2c->pdmabase + OFFSET_RST);
-	udelay(50);
-	writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_RST);
-
-	mtk_i2c_writew(i2c, I2C_SOFT_RST, OFFSET_SOFTRESET);
+	if (i2c->dev_comp->dma_sync) {
+		writel(I2C_DMA_WARM_RST, i2c->pdmabase + OFFSET_RST);
+		udelay(10);
+		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_RST);
+		udelay(10);
+		writel(I2C_DMA_HANDSHAKE_RST | I2C_DMA_HARD_RST,
+		       i2c->pdmabase + OFFSET_RST);
+		mtk_i2c_writew(i2c, I2C_HANDSHAKE_RST | I2C_SOFT_RST,
+			       OFFSET_SOFTRESET);
+		udelay(10);
+		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_RST);
+		mtk_i2c_writew(i2c, I2C_CHN_CLR_FLAG, OFFSET_SOFTRESET);
+	} else {
+		writel(I2C_DMA_HARD_RST, i2c->pdmabase + OFFSET_RST);
+		udelay(50);
+		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_RST);
+		mtk_i2c_writew(i2c, I2C_SOFT_RST, OFFSET_SOFTRESET);
+	}
 
 	/* Set ioconfig */
 	if (i2c->use_push_pull)


