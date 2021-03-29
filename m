Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D555F34C96F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhC2I3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhC2I1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A74F619C5;
        Mon, 29 Mar 2021 08:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006408;
        bh=bb+0VIw8Ucv2NpNmToF0MGp/brPsu94kUAAZLF1tnNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXJTV6OeYf2p3/DavwM7rcVYmTwMwJ4CL1CNGNwJzvDMy048K5t+jAlzOw4b6xccE
         su+DKKWcI8kXHNk/eUG1OH/YiWlCqKWaXXKvnH6xvEM+6kirozi9AzW0kua3NTrs5h
         slhToMtmOyXTZa5DUtFPx5CVhb2sqI7gSCDNpWts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 001/254] mt76: fix tx skb error handling in mt76_dma_tx_queue_skb
Date:   Mon, 29 Mar 2021 09:55:17 +0200
Message-Id: <20210329075633.184081952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ae064fc0e32a4d28389086d9f4b260a0c157cfee ]

When running out of room in the tx queue after calling drv->tx_prepare_skb,
the buffer list will already have been modified on MT7615 and newer drivers.
This can leak a DMA mapping and will show up as swiotlb allocation failures
on x86.

Fix this by moving the queue length check further up. This is less accurate,
since it can overestimate the needed room in the queue on MT7615 and newer,
but the difference is small enough to not matter in practice.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210216135119.23809-1-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 9bf13994c036..680c899a96d7 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -345,7 +345,6 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	};
 	struct ieee80211_hw *hw;
 	int len, n = 0, ret = -ENOMEM;
-	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
 	struct sk_buff *iter;
 	dma_addr_t addr;
@@ -387,6 +386,11 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	}
 	tx_info.nbuf = n;
 
+	if (q->queued + (tx_info.nbuf + 1) / 2 >= q->ndesc - 1) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
+
 	dma_sync_single_for_cpu(dev->dev, t->dma_addr, dev->drv->txwi_size,
 				DMA_TO_DEVICE);
 	ret = dev->drv->tx_prepare_skb(dev, txwi, q->qid, wcid, sta, &tx_info);
@@ -395,11 +399,6 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	if (ret < 0)
 		goto unmap;
 
-	if (q->queued + (tx_info.nbuf + 1) / 2 >= q->ndesc - 1) {
-		ret = -ENOMEM;
-		goto unmap;
-	}
-
 	return mt76_dma_add_buf(dev, q, tx_info.buf, tx_info.nbuf,
 				tx_info.info, tx_info.skb, t);
 
@@ -415,9 +414,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		dev->test.tx_done--;
 #endif
 
-	e.skb = tx_info.skb;
-	e.txwi = t;
-	dev->drv->tx_complete_skb(dev, &e);
+	dev_kfree_skb(tx_info.skb);
 	mt76_put_txwi(dev, t);
 	return ret;
 }
-- 
2.30.1



