Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2E03F65B9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbhHXRQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239582AbhHXROJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E36D961A82;
        Tue, 24 Aug 2021 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824498;
        bh=gf1OLFyvY3SSmWF2DPapW+nBSDAMwqX1MJHprgYORFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWPyjB7ncv5OGU5qurtHa0VOOUlGVl2Wzs3o7lr+aC2aRpYtSL4RPfTQHJ5ejxa8Y
         E1zPot26uYS8ID2Qy0ar67Qz81i1BzeLRpAuSlRDZnUL7zS9nPgHTaYc7q053XvZ3S
         7GOV1zYi9hlQDrITf7drF5XJQ57CVKdg5OTZVxUCsw5LvGUB5tTV/9EGwUbbGvYthY
         XoYUV+Rue6yD1LzUnOL2s3rFCdWuNxpHwY8xTNq5VbNf5dk1jgne1Pma8ViKps6lKk
         eGoVGnW4llCjJXFKGi6oixNiL+fS4dRBGR/euVQe/iOITslPIgTDmpv+1JlAHiTA3a
         8jjywuhZYE1Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/61] bnxt: don't lock the tx queue from napi poll
Date:   Tue, 24 Aug 2021 13:00:36 -0400
Message-Id: <20210824170106.710221-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 287ea792922a..8111aefb2411 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -360,6 +360,26 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
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
@@ -387,8 +407,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
-		netif_tx_stop_queue(txq);
-		return NETDEV_TX_BUSY;
+		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
+			return NETDEV_TX_BUSY;
 	}
 
 	length = skb->len;
@@ -597,16 +617,7 @@ tx_done:
 		if (netdev_xmit_more() && !tx_buf->is_push)
 			bnxt_db_write(bp, &txr->tx_db, prod);
 
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
 
@@ -690,14 +701,9 @@ next_tx_int:
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
@@ -8371,9 +8377,11 @@ void bnxt_tx_disable(struct bnxt *bp)
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
@@ -8387,8 +8395,10 @@ void bnxt_tx_enable(struct bnxt *bp)
 
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

