Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D2106CEB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbfKVK4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730563AbfKVK4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F188E2071C;
        Fri, 22 Nov 2019 10:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420177;
        bh=KOxhOyJHSWa7DPV+48JX7Z1O9zoxYUJ7NP+wrtc+h3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oE5YAKcDPSDCHOYrL0wvwnYHuu233kQsb/Iq0bD2gYPt6fftdC2EuP+E/LFfsjFLf
         jP6wvNyktM1WMr4paTpTBbnimMOYdYzb+CJX3MT7APldnBUuKSsf2TwpsfeoL1ZhRC
         dOoGNSSTtCw3/zaN3OBoB65gLJfXN/CQfIx8Fh+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 002/220] i2c: mediatek: modify threshold passed to i2c_get_dma_safe_msg_buf()
Date:   Fri, 22 Nov 2019 11:26:07 +0100
Message-Id: <20191122100912.877438787@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit bc1a7f75c85e226e82f183d30d75c357f92b6029 upstream.

DMA with zero-length transfers doesn't make sense and this HW doesn't
support them at all, so increase the threshold.

Fixes: fc66b39fe36a ("i2c: mediatek: Use DMA safe buffers for i2c transactions")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
[wsa: reworded commit message]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-mt65xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -503,7 +503,7 @@ static int mtk_i2c_do_transfer(struct mt
 		writel(I2C_DMA_INT_FLAG_NONE, i2c->pdmabase + OFFSET_INT_FLAG);
 		writel(I2C_DMA_CON_RX, i2c->pdmabase + OFFSET_CON);
 
-		dma_rd_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
+		dma_rd_buf = i2c_get_dma_safe_msg_buf(msgs, 1);
 		if (!dma_rd_buf)
 			return -ENOMEM;
 
@@ -526,7 +526,7 @@ static int mtk_i2c_do_transfer(struct mt
 		writel(I2C_DMA_INT_FLAG_NONE, i2c->pdmabase + OFFSET_INT_FLAG);
 		writel(I2C_DMA_CON_TX, i2c->pdmabase + OFFSET_CON);
 
-		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
+		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 1);
 		if (!dma_wr_buf)
 			return -ENOMEM;
 
@@ -549,7 +549,7 @@ static int mtk_i2c_do_transfer(struct mt
 		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_INT_FLAG);
 		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_CON);
 
-		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
+		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 1);
 		if (!dma_wr_buf)
 			return -ENOMEM;
 
@@ -561,7 +561,7 @@ static int mtk_i2c_do_transfer(struct mt
 			return -ENOMEM;
 		}
 
-		dma_rd_buf = i2c_get_dma_safe_msg_buf((msgs + 1), 0);
+		dma_rd_buf = i2c_get_dma_safe_msg_buf((msgs + 1), 1);
 		if (!dma_rd_buf) {
 			dma_unmap_single(i2c->dev, wpaddr,
 					 msgs->len, DMA_TO_DEVICE);


