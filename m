Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FE0395EC6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhEaOD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232770AbhEaOBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92C546144C;
        Mon, 31 May 2021 13:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468203;
        bh=+BsTtVc6PdfMc7tMiicVr3+MQ3VK3Pq81j3/C0zPQWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6uBKTNInp/onGOy05Ukn2C6A5Jc8jvrj3iKsAgKqfaUErMS/5KnYe4ZYgoF/SnrC
         7eso2YlZfLzXjwflsJaB4ZDdDUS5wK9QxZ4tz+NLsKmsD/Mcx4S3KeBK/aVxKbkIsP
         Z8++6JeHn6Kawi3D2IU3c4h0JMPPXUTb2E+4yhV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 121/252] i2c: mediatek: Disable i2c start_en and clear intr_stat brfore reset
Date:   Mon, 31 May 2021 15:13:06 +0200
Message-Id: <20210531130702.103473057@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

commit fed1bd51a504eb96caa38b4f13ab138fc169ea75 upstream.

The i2c controller driver do dma reset after transfer timeout,
but sometimes dma reset will trigger an unexpected DMA_ERR irq.
It will cause the i2c controller to continuously send interrupts
to the system and cause soft lock-up. So we need to disable i2c
start_en and clear intr_stat to stop i2c controller before dma
reset when transfer timeout.

Fixes: aafced673c06("i2c: mediatek: move dma reset before i2c reset")
Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mt65xx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -478,6 +478,11 @@ static void mtk_i2c_clock_disable(struct
 static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 {
 	u16 control_reg;
+	u16 intr_stat_reg;
+
+	mtk_i2c_writew(i2c, I2C_CHN_CLR_FLAG, OFFSET_START);
+	intr_stat_reg = mtk_i2c_readw(i2c, OFFSET_INTR_STAT);
+	mtk_i2c_writew(i2c, intr_stat_reg, OFFSET_INTR_STAT);
 
 	if (i2c->dev_comp->apdma_sync) {
 		writel(I2C_DMA_WARM_RST, i2c->pdmabase + OFFSET_RST);


