Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8673C24E8
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhGINZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232958AbhGINZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 798E0613CC;
        Fri,  9 Jul 2021 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836965;
        bh=EUsgZ38tymH3moKDPNSnr3o+5hGH0xDo3WB11SPtJDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWdSoLKjGiw5yNf6mFVtk/Cd7ogRueNS/UxBdVOuOnHwpxBRN/PgUGRXaolpiJVYg
         GUxtK6JmDla6H7Qjvr0y7Jdfvnj2gx3NAz3fpTIdFM9bY3xzc/NZba8UtbZUbp4e9c
         06iuYwyRkpVy6wYUqoTBp2McGnFHptLN0h8Oy3jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <Deren.Wu@mediatek.com>
Subject: [PATCH 5.12 07/11] mt76: dma: introduce mt76_dma_queue_reset routine
Date:   Fri,  9 Jul 2021 15:21:44 +0200
Message-Id: <20210709131559.167287713@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 3990465db6829c91e8ebfde51ba2d98885020249 upstream.

Introduce mt76_dma_queue_reset utility routine to reset a given hw
queue. This is a preliminary patch to introduce mt7921 chip reset
support.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Deren Wu <Deren.Wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/dma.c  |   46 ++++++++++++++++++------------
 drivers/net/wireless/mediatek/mt76/mt76.h |    3 +
 2 files changed, 31 insertions(+), 18 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -79,13 +79,38 @@ mt76_free_pending_txwi(struct mt76_dev *
 	local_bh_enable();
 }
 
+static void
+mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	writel(q->desc_dma, &q->regs->desc_base);
+	writel(q->ndesc, &q->regs->ring_size);
+	q->head = readl(&q->regs->dma_idx);
+	q->tail = q->head;
+}
+
+static void
+mt76_dma_queue_reset(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	int i;
+
+	if (!q)
+		return;
+
+	/* clear descriptors */
+	for (i = 0; i < q->ndesc; i++)
+		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
+
+	writel(0, &q->regs->cpu_idx);
+	writel(0, &q->regs->dma_idx);
+	mt76_dma_sync_idx(dev, q);
+}
+
 static int
 mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc, int bufsize,
 		     u32 ring_base)
 {
 	int size;
-	int i;
 
 	spin_lock_init(&q->lock);
 	spin_lock_init(&q->cleanup_lock);
@@ -105,14 +130,7 @@ mt76_dma_alloc_queue(struct mt76_dev *de
 	if (!q->entry)
 		return -ENOMEM;
 
-	/* clear descriptors */
-	for (i = 0; i < q->ndesc; i++)
-		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
-
-	writel(q->desc_dma, &q->regs->desc_base);
-	writel(0, &q->regs->cpu_idx);
-	writel(0, &q->regs->dma_idx);
-	writel(q->ndesc, &q->regs->ring_size);
+	mt76_dma_queue_reset(dev, q);
 
 	return 0;
 }
@@ -202,15 +220,6 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev
 }
 
 static void
-mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
-{
-	writel(q->desc_dma, &q->regs->desc_base);
-	writel(q->ndesc, &q->regs->ring_size);
-	q->head = readl(&q->regs->dma_idx);
-	q->tail = q->head;
-}
-
-static void
 mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
 	wmb();
@@ -640,6 +649,7 @@ mt76_dma_init(struct mt76_dev *dev)
 static const struct mt76_queue_ops mt76_dma_ops = {
 	.init = mt76_dma_init,
 	.alloc = mt76_dma_alloc_queue,
+	.reset_q = mt76_dma_queue_reset,
 	.tx_queue_skb_raw = mt76_dma_tx_queue_skb_raw,
 	.tx_queue_skb = mt76_dma_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -191,6 +191,8 @@ struct mt76_queue_ops {
 			   bool flush);
 
 	void (*kick)(struct mt76_dev *dev, struct mt76_queue *q);
+
+	void (*reset_q)(struct mt76_dev *dev, struct mt76_queue *q);
 };
 
 enum mt76_wcid_flags {
@@ -786,6 +788,7 @@ static inline u16 mt76_rev(struct mt76_d
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_tx_cleanup(dev, ...)        (dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_reset(dev, ...)	(dev)->mt76.queue_ops->reset_q(&((dev)->mt76), __VA_ARGS__)
 
 #define mt76_for_each_q_rx(dev, i)	\
 	for (i = 0; i < ARRAY_SIZE((dev)->q_rx) && \


