Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC05F1EAA9E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgFASJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbgFASJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:09:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E71C2068D;
        Mon,  1 Jun 2020 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034981;
        bh=RijcyfdNducBD2VrBm/8grRQL5tAr3XhzsmTbCOtmKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/xT1Mv7h4h0liuf83HWjsZKSXnLGxHMMF38kdHCau8SRxBuIrVIxKkZgjkIe4niU
         OLoFnzhJhDlQULq46VDoR7aq3RyWBLZa8SVgUBx39XRLxIrWHuU09EiEZgbxWeLoIb
         FnGsMP7l5f//Dzo04S2l0Vh6C6Al9DPAtwBCY4b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valentine Fatiev <valentinef@mellanox.com>,
        Alaa Hleihel <alaa@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/142] IB/ipoib: Fix double free of skb in case of multicast traffic in CM mode
Date:   Mon,  1 Jun 2020 19:54:16 +0200
Message-Id: <20200601174048.118606150@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentine Fatiev <valentinef@mellanox.com>

[ Upstream commit 1acba6a817852d4aa7916d5c4f2c82f702ee9224 ]

When connected mode is set, and we have connected and datagram traffic in
parallel, ipoib might crash with double free of datagram skb.

The current mechanism assumes that the order in the completion queue is
the same as the order of sent packets for all QPs. Order is kept only for
specific QP, in case of mixed UD and CM traffic we have few QPs (one UD and
few CM's) in parallel.

The problem:
----------------------------------------------------------

Transmit queue:
-----------------
UD skb pointer kept in queue itself, CM skb kept in spearate queue and
uses transmit queue as a placeholder to count the number of total
transmitted packets.

0   1   2   3   4  5  6  7  8   9  10  11 12 13 .........127
------------------------------------------------------------
NL ud1 UD2 CM1 ud3 cm2 cm3 ud4 cm4 ud5 NL NL NL ...........
------------------------------------------------------------
    ^                                  ^
   tail                               head

Completion queue (problematic scenario) - the order not the same as in
the transmit queue:

  1  2  3  4  5  6  7  8  9
------------------------------------
 ud1 CM1 UD2 ud3 cm2 cm3 ud4 cm4 ud5
------------------------------------

1. CM1 'wc' processing
   - skb freed in cm separate ring.
   - tx_tail of transmit queue increased although UD2 is not freed.
     Now driver assumes UD2 index is already freed and it could be used for
     new transmitted skb.

0   1   2   3   4  5  6  7  8   9  10  11 12 13 .........127
------------------------------------------------------------
NL NL  UD2 CM1 ud3 cm2 cm3 ud4 cm4 ud5 NL NL NL ...........
------------------------------------------------------------
        ^   ^                       ^
      (Bad)tail                    head
(Bad - Could be used for new SKB)

In this case (due to heavy load) UD2 skb pointer could be replaced by new
transmitted packet UD_NEW, as the driver assumes its free.  At this point
we will have to process two 'wc' with same index but we have only one
pointer to free.

During second attempt to free the same skb we will have NULL pointer
exception.

2. UD2 'wc' processing
   - skb freed according the index we got from 'wc', but it was already
     overwritten by mistake. So actually the skb that was released is the
     skb of the new transmitted packet and not the original one.

3. UD_NEW 'wc' processing
   - attempt to free already freed skb. NUll pointer exception.

The fix:
-----------------------------------------------------------------------

The fix is to stop using the UD ring as a placeholder for CM packets, the
cyclic ring variables tx_head and tx_tail will manage the UD tx_ring, a
new cyclic variables global_tx_head and global_tx_tail are introduced for
managing and counting the overall outstanding sent packets, then the send
queue will be stopped and waken based on these variables only.

Note that no locking is needed since global_tx_head is updated in the xmit
flow and global_tx_tail is updated in the NAPI flow only.  A previous
attempt tried to use one variable to count the outstanding sent packets,
but it did not work since xmit and NAPI flows can run at the same time and
the counter will be updated wrongly. Thus, we use the same simple cyclic
head and tail scheme that we have today for the UD tx_ring.

Fixes: 2c104ea68350 ("IB/ipoib: Get rid of the tx_outstanding variable in all modes")
Link: https://lore.kernel.org/r/20200527134705.480068-1-leon@kernel.org
Signed-off-by: Valentine Fatiev <valentinef@mellanox.com>
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  4 ++++
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 15 +++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |  9 +++++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 10 ++++++----
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 2aa3457a30ce..0e5f27caf2b2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -377,8 +377,12 @@ struct ipoib_dev_priv {
 	struct ipoib_rx_buf *rx_ring;
 
 	struct ipoib_tx_buf *tx_ring;
+	/* cyclic ring variables for managing tx_ring, for UD only */
 	unsigned int	     tx_head;
 	unsigned int	     tx_tail;
+	/* cyclic ring variables for counting overall outstanding send WRs */
+	unsigned int	     global_tx_head;
+	unsigned int	     global_tx_tail;
 	struct ib_sge	     tx_sge[MAX_SKB_FRAGS + 1];
 	struct ib_ud_wr      tx_wr;
 	struct ib_wc	     send_wc[MAX_SEND_CQE];
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index c59e00a0881f..9bf0fa30df28 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -756,7 +756,8 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 		return;
 	}
 
-	if ((priv->tx_head - priv->tx_tail) == ipoib_sendq_size - 1) {
+	if ((priv->global_tx_head - priv->global_tx_tail) ==
+	    ipoib_sendq_size - 1) {
 		ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 			  tx->qp->qp_num);
 		netif_stop_queue(dev);
@@ -786,7 +787,7 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	} else {
 		netif_trans_update(dev);
 		++tx->tx_head;
-		++priv->tx_head;
+		++priv->global_tx_head;
 	}
 }
 
@@ -820,10 +821,11 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	netif_tx_lock(dev);
 
 	++tx->tx_tail;
-	++priv->tx_tail;
+	++priv->global_tx_tail;
 
 	if (unlikely(netif_queue_stopped(dev) &&
-		     (priv->tx_head - priv->tx_tail) <= ipoib_sendq_size >> 1 &&
+		     ((priv->global_tx_head - priv->global_tx_tail) <=
+		      ipoib_sendq_size >> 1) &&
 		     test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)))
 		netif_wake_queue(dev);
 
@@ -1232,8 +1234,9 @@ timeout:
 		dev_kfree_skb_any(tx_req->skb);
 		netif_tx_lock_bh(p->dev);
 		++p->tx_tail;
-		++priv->tx_tail;
-		if (unlikely(priv->tx_head - priv->tx_tail == ipoib_sendq_size >> 1) &&
+		++priv->global_tx_tail;
+		if (unlikely((priv->global_tx_head - priv->global_tx_tail) <=
+			     ipoib_sendq_size >> 1) &&
 		    netif_queue_stopped(p->dev) &&
 		    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 			netif_wake_queue(p->dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index c332b4761816..da3c5315bbb5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -407,9 +407,11 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	dev_kfree_skb_any(tx_req->skb);
 
 	++priv->tx_tail;
+	++priv->global_tx_tail;
 
 	if (unlikely(netif_queue_stopped(dev) &&
-		     ((priv->tx_head - priv->tx_tail) <= ipoib_sendq_size >> 1) &&
+		     ((priv->global_tx_head - priv->global_tx_tail) <=
+		      ipoib_sendq_size >> 1) &&
 		     test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)))
 		netif_wake_queue(dev);
 
@@ -634,7 +636,8 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	else
 		priv->tx_wr.wr.send_flags &= ~IB_SEND_IP_CSUM;
 	/* increase the tx_head after send success, but use it for queue state */
-	if (priv->tx_head - priv->tx_tail == ipoib_sendq_size - 1) {
+	if ((priv->global_tx_head - priv->global_tx_tail) ==
+	    ipoib_sendq_size - 1) {
 		ipoib_dbg(priv, "TX ring full, stopping kernel net queue\n");
 		netif_stop_queue(dev);
 	}
@@ -662,6 +665,7 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 
 		rc = priv->tx_head;
 		++priv->tx_head;
+		++priv->global_tx_head;
 	}
 	return rc;
 }
@@ -807,6 +811,7 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 				ipoib_dma_unmap_tx(priv, tx_req);
 				dev_kfree_skb_any(tx_req->skb);
 				++priv->tx_tail;
+				++priv->global_tx_tail;
 			}
 
 			for (i = 0; i < ipoib_recvq_size; ++i) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index ac0583ff280d..4fd095fd63b6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1188,9 +1188,11 @@ static void ipoib_timeout(struct net_device *dev)
 
 	ipoib_warn(priv, "transmit timeout: latency %d msecs\n",
 		   jiffies_to_msecs(jiffies - dev_trans_start(dev)));
-	ipoib_warn(priv, "queue stopped %d, tx_head %u, tx_tail %u\n",
-		   netif_queue_stopped(dev),
-		   priv->tx_head, priv->tx_tail);
+	ipoib_warn(priv,
+		   "queue stopped %d, tx_head %u, tx_tail %u, global_tx_head %u, global_tx_tail %u\n",
+		   netif_queue_stopped(dev), priv->tx_head, priv->tx_tail,
+		   priv->global_tx_head, priv->global_tx_tail);
+
 	/* XXX reset QP, etc. */
 }
 
@@ -1705,7 +1707,7 @@ static int ipoib_dev_init_default(struct net_device *dev)
 		goto out_rx_ring_cleanup;
 	}
 
-	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
+	/* priv->tx_head, tx_tail and global_tx_tail/head are already 0 */
 
 	if (ipoib_transport_dev_init(dev, priv->ca)) {
 		pr_warn("%s: ipoib_transport_dev_init failed\n",
-- 
2.25.1



