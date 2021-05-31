Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B3A3961D9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhEaOrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234242AbhEaOpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC2461C87;
        Mon, 31 May 2021 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469310;
        bh=+BsTtVc6PdfMc7tMiicVr3+MQ3VK3Pq81j3/C0zPQWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2zVucd2rezemB6EMbecYjbT2RSFXFjeCj0tsMfy6dLdW/hXM4V93CVcWU2g2THKJ
         1OOnfguBDw8XoYY+Lsd2pOLkmmnQwsfjGd4DMvfxrn7atyQ0RT+gilpwgFDgJwnWQE
         Zupzi7PuF+XfvkTMG5VKH3MUJGEtBekFB4bJES7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.12 150/296] i2c: mediatek: Disable i2c start_en and clear intr_stat brfore reset
Date:   Mon, 31 May 2021 15:13:25 +0200
Message-Id: <20210531130708.915162917@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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


