Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC73F6763
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241682AbhHXRdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241308AbhHXRbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F058961B7E;
        Tue, 24 Aug 2021 17:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824746;
        bh=qg4+/hAFhqMc6kyi0UVAlA2SLom5vJBs+IbyNCve4U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DplcwACzXpMEtH0dGWZgDvQ2HQgHlQRmqDC6uIGdtPMQ+209E/8V0cBhW3kaWs+Ae
         xUFl4OO3vrQBeJpCl+e44PUQFwvHmf/XmmkWAsdw3RpJry9FumpuJzoJhWgDebAfTO
         lDmd78qLvHLtU/2zyYN/zvQx8DHCQAGQdG54QVnRIXyKeTLRq9k63AncH0qdXKtP/I
         UANsDM3CWhUkCqGq0icxtZta9HbktLdm9o1ZZpOwL3U7vWR7wVc2EDwFZ1IewNkUnG
         qlWih2GnSKzSjLkbqGkRKBXFka4XikUy8O+J23aTNpb4QK01GvVEGmaY5mtmjSJOTq
         CnNw2xI8eaDFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 50/64] bnxt: don't lock the tx queue from napi poll
Date:   Tue, 24 Aug 2021 13:04:43 -0400
Message-Id: <20210824170457.710623-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 3c603136c9f82833813af77185618de5af67676c ]

We can't take the tx lock from the napi poll routine, because
netpoll can poll napi at any moment, including with the tx lock
already held.

The tx lock is protecting against two paths - the disable
path, and (as Michael points out) the NETDEV_TX_BUSY case
which may occur if NAPI completions race with start_xmit
and both decide to re-enable the queue.

For the disable/ifdown path use synchronize_net() to make sure
closing the device does not race we restarting the queues.
Annotate accesses to dev_state against data races.

For the NAPI cleanup vs start_xmit path - appropriate barriers
are already in place in the main spot where Tx queue is stopped
but we need to do the same careful dance in the TX_BUSY case.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 54 ++++++++++++++---------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9135c3eccb58..c4b0c35a270c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -266,6 +266,26 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
 	return md_dst->u.port_info.port_id;
 }
 
+static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
+					  struct bnxt_tx_ring_info *txr,
+					  struct netdev_queue *txq)
+{
+	netif_tx_stop_queue(txq);
+
+	/* netif_tx_stop_queue() must be done before checking
+	 * tx index in bnxt_tx_avail() below, because in
+	 * bnxt_tx_int(), we update tx index before checking for
+	 * netif_tx_queue_stopped().
+	 */
+	smp_mb();
+	if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh) {
+		netif_tx_wake_queue(txq);
+		return false;
+	}
+
+	return true;
+}
+
 static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -293,8 +313,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
-		netif_tx_stop_queue(txq);
-		return NETDEV_TX_BUSY;
+		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
+			return NETDEV_TX_BUSY;
 	}
 
 	length = skb->len;
@@ -505,16 +525,7 @@ tx_done:
 		if (skb->xmit_more && !tx_buf->is_push)
 			bnxt_db_write(bp, txr->tx_doorbell, DB_KEY_TX | prod);
 
-		netif_tx_stop_queue(txq);
-
-		/* netif_tx_stop_queue() must be done before checking
-		 * tx index in bnxt_tx_avail() below, because in
-		 * bnxt_tx_int(), we update tx index before checking for
-		 * netif_tx_queue_stopped().
-		 */
-		smp_mb();
-		if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)
-			netif_tx_wake_queue(txq);
+		bnxt_txr_netif_try_stop_queue(bp, txr, txq);
 	}
 	return NETDEV_TX_OK;
 
@@ -598,14 +609,9 @@ next_tx_int:
 	smp_mb();
 
 	if (unlikely(netif_tx_queue_stopped(txq)) &&
-	    (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)) {
-		__netif_tx_lock(txq, smp_processor_id());
-		if (netif_tx_queue_stopped(txq) &&
-		    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
-		    txr->dev_state != BNXT_DEV_STATE_CLOSING)
-			netif_tx_wake_queue(txq);
-		__netif_tx_unlock(txq);
-	}
+	    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
+	    READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)
+		netif_tx_wake_queue(txq);
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
@@ -5748,9 +5754,11 @@ void bnxt_tx_disable(struct bnxt *bp)
 	if (bp->tx_ring) {
 		for (i = 0; i < bp->tx_nr_rings; i++) {
 			txr = &bp->tx_ring[i];
-			txr->dev_state = BNXT_DEV_STATE_CLOSING;
+			WRITE_ONCE(txr->dev_state, BNXT_DEV_STATE_CLOSING);
 		}
 	}
+	/* Make sure napi polls see @dev_state change */
+	synchronize_net();
 	/* Drop carrier first to prevent TX timeout */
 	netif_carrier_off(bp->dev);
 	/* Stop all TX queues */
@@ -5764,8 +5772,10 @@ void bnxt_tx_enable(struct bnxt *bp)
 
 	for (i = 0; i < bp->tx_nr_rings; i++) {
 		txr = &bp->tx_ring[i];
-		txr->dev_state = 0;
+		WRITE_ONCE(txr->dev_state, 0);
 	}
+	/* Make sure napi polls see @dev_state change */
+	synchronize_net();
 	netif_tx_wake_all_queues(bp->dev);
 	if (bp->link_info.link_up)
 		netif_carrier_on(bp->dev);
-- 
2.30.2

