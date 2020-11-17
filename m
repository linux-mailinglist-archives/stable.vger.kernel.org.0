Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489C32B6349
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732487AbgKQNfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732378AbgKQNf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7191B2467A;
        Tue, 17 Nov 2020 13:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620128;
        bh=JhdKaFlJpO4qT7Ve/Q6EhS4GgEaPVaOrcbkOBP1wpXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pklfacb14fUzlkP55NRtpJroTMdTXH+HCazUReZBcFylq62KKny9WRl5x3n9vx4v3
         MmqSxLiTlB1RbX8ggqJ3u5S63koQiqI5FaXc523Wwx2CIMOVMs3EKO/39gCjYf2aYn
         NMR8o3yfNhzT5ciCqLvSL5uPKZqv8uGYCdXYjXXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 116/255] i2c: mediatek: move dma reset before i2c reset
Date:   Tue, 17 Nov 2020 14:04:16 +0100
Message-Id: <20201117122144.588804048@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

[ Upstream commit aafced673c06b7c77040c1df42e2e965be5d0376 ]

The i2c driver default do dma reset after i2c reset, but sometimes
i2c reset will trigger dma tx2rx, then apdma write data to dram
which has been i2c_put_dma_safe_msg_buf(kfree). Move dma reset
before i2c reset in mtk_i2c_init_hw to fix it.

Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 0cbdfbe605b55..33de99b7bc20c 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -475,6 +475,10 @@ static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 {
 	u16 control_reg;
 
+	writel(I2C_DMA_HARD_RST, i2c->pdmabase + OFFSET_RST);
+	udelay(50);
+	writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_RST);
+
 	mtk_i2c_writew(i2c, I2C_SOFT_RST, OFFSET_SOFTRESET);
 
 	/* Set ioconfig */
@@ -529,10 +533,6 @@ static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 
 	mtk_i2c_writew(i2c, control_reg, OFFSET_CONTROL);
 	mtk_i2c_writew(i2c, I2C_DELAY_LEN, OFFSET_DELAY_LEN);
-
-	writel(I2C_DMA_HARD_RST, i2c->pdmabase + OFFSET_RST);
-	udelay(50);
-	writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_RST);
 }
 
 static const struct i2c_spec_values *mtk_i2c_get_spec(unsigned int speed)
-- 
2.27.0



