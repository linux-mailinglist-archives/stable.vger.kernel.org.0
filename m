Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1589D3F64FC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239420AbhHXRJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238921AbhHXRHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B566561A09;
        Tue, 24 Aug 2021 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824400;
        bh=n5KKIVvxy4O7B4w97bkf/cLCgTb07yU4GLlkotJl37g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMhWj5vph6ernWNW9OZU2KrKLjHmNG6Be3+6Vx65E/nu/mruC1TQr0rdZXYHviXtU
         Wzyl1ZNiWaGTk7cj15odjqVa6XqFeoqMLjClmisiYmiYpf7/ndte7fvI95KUiberiy
         v81aDM25v13/XSne4fywuZGq8WfyWOXC3HSkiuxnOCejCCH3UEY+biJlqdh0j75GEz
         gaiUNqKujFuZYnTocf/aaCwobRvSicd6Y7A1I1RSAEmMGnjY6SqsfWqrfXA6qrcJCt
         ApwYJDOrzSpgw9sakx3jg7NziVslxv7M2g+FLcZr5WMxssPI92eAaw5mhm7F6youzX
         j3zxQodXUBiAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/98] bnxt: make sure xmit_more + errors does not miss doorbells
Date:   Tue, 24 Aug 2021 12:58:21 -0400
Message-Id: <20210824165908.709932-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e8d8c5d80f5e9d4586c68061b62c642752289095 ]

skbs are freed on error and not put on the ring. We may, however,
be in a situation where we're freeing the last skb of a batch,
and there is a doorbell ring pending because of xmit_more() being
true earlier. Make sure we ring the door bell in such situations.

Since errors are rare don't pay attention to xmit_more() and just
always flush the pending frames.

The busy case should be safe to be left alone because it can
only happen if start_xmit races with completions and they
both enable the queue. In that case the kick can't be pending.

Noticed while reading the code.

Fixes: 4d172f21cefe ("bnxt_en: Implement xmit_more.")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 39 +++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 621346656af3..dd03e1e6279a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -69,7 +69,8 @@
 #include "bnxt_debugfs.h"
 
 #define BNXT_TX_TIMEOUT		(5 * HZ)
-#define BNXT_DEF_MSG_ENABLE	(NETIF_MSG_DRV | NETIF_MSG_HW)
+#define BNXT_DEF_MSG_ENABLE	(NETIF_MSG_DRV | NETIF_MSG_HW | \
+				 NETIF_MSG_TX_ERR)
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
@@ -360,6 +361,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
 	return md_dst->u.port_info.port_id;
 }
 
+static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			     u16 prod)
+{
+	bnxt_db_write(bp, &txr->tx_db, prod);
+	txr->kick_pending = 0;
+}
+
 static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
 					  struct bnxt_tx_ring_info *txr,
 					  struct netdev_queue *txq)
@@ -407,6 +415,10 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
+		/* We must have raced with NAPI cleanup */
+		if (net_ratelimit() && txr->kick_pending)
+			netif_warn(bp, tx_err, dev,
+				   "bnxt: ring busy w/ flush pending!\n");
 		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
 			return NETDEV_TX_BUSY;
 	}
@@ -510,21 +522,16 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 normal_tx:
 	if (length < BNXT_MIN_PKT_SIZE) {
 		pad = BNXT_MIN_PKT_SIZE - length;
-		if (skb_pad(skb, pad)) {
+		if (skb_pad(skb, pad))
 			/* SKB already freed. */
-			tx_buf->skb = NULL;
-			return NETDEV_TX_OK;
-		}
+			goto tx_kick_pending;
 		length = BNXT_MIN_PKT_SIZE;
 	}
 
 	mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
-		dev_kfree_skb_any(skb);
-		tx_buf->skb = NULL;
-		return NETDEV_TX_OK;
-	}
+	if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
+		goto tx_free;
 
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
 	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
@@ -609,13 +616,15 @@ normal_tx:
 	txr->tx_prod = prod;
 
 	if (!netdev_xmit_more() || netif_xmit_stopped(txq))
-		bnxt_db_write(bp, &txr->tx_db, prod);
+		bnxt_txr_db_kick(bp, txr, prod);
+	else
+		txr->kick_pending = 1;
 
 tx_done:
 
 	if (unlikely(bnxt_tx_avail(bp, txr) <= MAX_SKB_FRAGS + 1)) {
 		if (netdev_xmit_more() && !tx_buf->is_push)
-			bnxt_db_write(bp, &txr->tx_db, prod);
+			bnxt_txr_db_kick(bp, txr, prod);
 
 		bnxt_txr_netif_try_stop_queue(bp, txr, txq);
 	}
@@ -627,7 +636,6 @@ tx_dma_error:
 	/* start back at beginning and unmap skb */
 	prod = txr->tx_prod;
 	tx_buf = &txr->tx_buf_ring[prod];
-	tx_buf->skb = NULL;
 	dma_unmap_single(&pdev->dev, dma_unmap_addr(tx_buf, mapping),
 			 skb_headlen(skb), PCI_DMA_TODEVICE);
 	prod = NEXT_TX(prod);
@@ -641,7 +649,12 @@ tx_dma_error:
 			       PCI_DMA_TODEVICE);
 	}
 
+tx_free:
 	dev_kfree_skb_any(skb);
+tx_kick_pending:
+	if (txr->kick_pending)
+		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
+	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a95c5afa2f01..95d10e7bbb04 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -770,6 +770,7 @@ struct bnxt_tx_ring_info {
 	u16			tx_prod;
 	u16			tx_cons;
 	u16			txq_index;
+	u8			kick_pending;
 	struct bnxt_db_info	tx_db;
 
 	struct tx_bd		*tx_desc_ring[MAX_TX_PAGES];
-- 
2.30.2

