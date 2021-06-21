Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853933AF363
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhFUSAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233324AbhFUR6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE4666115B;
        Mon, 21 Jun 2021 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298053;
        bh=Ulm5668ppW40hxOYFzzvuWM+MDIXiaR+Hxem0ej4GCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3zIKQV/lYT7d9ZCvnqwHV79kgwE7q+FmTswzWnWCOXosNDwS7cj/+xMs06kQJ0Tr
         pRYh9UIXQ0nDNjg4oULIOITAuCnGr9vPG5fB0EaNn+qVOOoj8PXApOaeaGaZ5xpUoZ
         LELelx3bsdEzf6tVdNgIKJgJl3wfPnusW1QJW3JlIelC7ZVPC3/HZdyKQOUFh6gWT2
         JNs+6vP3Fpg7Q+qieyxlilymLWeW3vQXeuNueIXG72pzPzQG4RdJsOpomDyDtqcFw/
         qodVSrHiaVv+O8XeTXMrh1DqjRI8FtjSKkGkNEvyj5iX9ML6zUu3NFQfnyrnUv33kc
         e2xy6yy0TEjkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 07/26] dmaengine: mediatek: do not issue a new desc if one is still current
Date:   Mon, 21 Jun 2021 13:53:40 -0400
Message-Id: <20210621175400.735800-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Ranquet <granquet@baylibre.com>

[ Upstream commit 2537b40b0a4f61d2c83900744fe89b09076be9c6 ]

Avoid issuing a new desc if one is still being processed as this can
lead to some desc never being marked as completed.

Signed-off-by: Guillaume Ranquet <granquet@baylibre.com>

Link: https://lore.kernel.org/r/20210513192642.29446-3-granquet@baylibre.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-uart-apdma.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index 311d7c236d27..e420e9f72b3d 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -204,14 +204,9 @@ static void mtk_uart_apdma_start_rx(struct mtk_chan *c)
 
 static void mtk_uart_apdma_tx_handler(struct mtk_chan *c)
 {
-	struct mtk_uart_apdma_desc *d = c->desc;
-
 	mtk_uart_apdma_write(c, VFF_INT_FLAG, VFF_TX_INT_CLR_B);
 	mtk_uart_apdma_write(c, VFF_INT_EN, VFF_INT_EN_CLR_B);
 	mtk_uart_apdma_write(c, VFF_EN, VFF_EN_CLR_B);
-
-	list_del(&d->vd.node);
-	vchan_cookie_complete(&d->vd);
 }
 
 static void mtk_uart_apdma_rx_handler(struct mtk_chan *c)
@@ -242,9 +237,17 @@ static void mtk_uart_apdma_rx_handler(struct mtk_chan *c)
 
 	c->rx_status = d->avail_len - cnt;
 	mtk_uart_apdma_write(c, VFF_RPT, wg);
+}
 
-	list_del(&d->vd.node);
-	vchan_cookie_complete(&d->vd);
+static void mtk_uart_apdma_chan_complete_handler(struct mtk_chan *c)
+{
+	struct mtk_uart_apdma_desc *d = c->desc;
+
+	if (d) {
+		list_del(&d->vd.node);
+		vchan_cookie_complete(&d->vd);
+		c->desc = NULL;
+	}
 }
 
 static irqreturn_t mtk_uart_apdma_irq_handler(int irq, void *dev_id)
@@ -258,6 +261,7 @@ static irqreturn_t mtk_uart_apdma_irq_handler(int irq, void *dev_id)
 		mtk_uart_apdma_rx_handler(c);
 	else if (c->dir == DMA_MEM_TO_DEV)
 		mtk_uart_apdma_tx_handler(c);
+	mtk_uart_apdma_chan_complete_handler(c);
 	spin_unlock_irqrestore(&c->vc.lock, flags);
 
 	return IRQ_HANDLED;
@@ -363,7 +367,7 @@ static void mtk_uart_apdma_issue_pending(struct dma_chan *chan)
 	unsigned long flags;
 
 	spin_lock_irqsave(&c->vc.lock, flags);
-	if (vchan_issue_pending(&c->vc)) {
+	if (vchan_issue_pending(&c->vc) && !c->desc) {
 		vd = vchan_next_desc(&c->vc);
 		c->desc = to_mtk_uart_apdma_desc(&vd->tx);
 
-- 
2.30.2

