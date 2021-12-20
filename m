Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712D747AB6F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhLTOgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbhLTOgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:36:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FE2C061401;
        Mon, 20 Dec 2021 06:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76C76CE10F9;
        Mon, 20 Dec 2021 14:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41945C36AE7;
        Mon, 20 Dec 2021 14:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640010993;
        bh=jQmmDBeI2ftL96deG7+b/Io0mmHLQ6E3LxbXlUGxrvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIncxcdc2D0NEbhrex2/n/xouAgb254fUbP6oIhenGhI+qi4A21WrZGEet4NQITor
         MGxgrNzQ9xckjYvAKxDq2QLV5z9mdB2bUjhWDA4GiD99V+Bt3FTom8dkfjNbXjEfNr
         nxtFEDvpF/V/wyqgtlc5gUvGl/05WkyU3OyJJ/tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.4 21/23] xen/netfront: harden netfront against event channel storms
Date:   Mon, 20 Dec 2021 15:34:22 +0100
Message-Id: <20211220143018.527922365@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit b27d47950e481f292c0a5ad57357edb9d95d03ba upstream.

The Xen netfront driver is still vulnerable for an attack via excessive
number of events sent by the backend. Fix that by using lateeoi event
channels.

For being able to detect the case of no rx responses being added while
the carrier is down a new lock is needed in order to update and test
rsp_cons and the number of seen unconsumed responses atomically.

This is part of XSA-391

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |  125 +++++++++++++++++++++++++++++++++------------
 1 file changed, 94 insertions(+), 31 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -141,6 +141,9 @@ struct netfront_queue {
 	struct sk_buff *rx_skbs[NET_RX_RING_SIZE];
 	grant_ref_t gref_rx_head;
 	grant_ref_t grant_rx_ref[NET_RX_RING_SIZE];
+
+	unsigned int rx_rsp_unconsumed;
+	spinlock_t rx_cons_lock;
 };
 
 struct netfront_info {
@@ -365,11 +368,12 @@ static int xennet_open(struct net_device
 	return 0;
 }
 
-static void xennet_tx_buf_gc(struct netfront_queue *queue)
+static bool xennet_tx_buf_gc(struct netfront_queue *queue)
 {
 	RING_IDX cons, prod;
 	unsigned short id;
 	struct sk_buff *skb;
+	bool work_done = false;
 	const struct device *dev = &queue->info->netdev->dev;
 
 	BUG_ON(!netif_carrier_ok(queue->info->netdev));
@@ -386,6 +390,8 @@ static void xennet_tx_buf_gc(struct netf
 		for (cons = queue->tx.rsp_cons; cons != prod; cons++) {
 			struct xen_netif_tx_response txrsp;
 
+			work_done = true;
+
 			RING_COPY_RESPONSE(&queue->tx, cons, &txrsp);
 			if (txrsp.status == XEN_NETIF_RSP_NULL)
 				continue;
@@ -439,11 +445,13 @@ static void xennet_tx_buf_gc(struct netf
 
 	xennet_maybe_wake_tx(queue);
 
-	return;
+	return work_done;
 
  err:
 	queue->info->broken = true;
 	dev_alert(dev, "Disabled for further use\n");
+
+	return work_done;
 }
 
 struct xennet_gnttab_make_txreq {
@@ -748,6 +756,16 @@ static int xennet_close(struct net_devic
 	return 0;
 }
 
+static void xennet_set_rx_rsp_cons(struct netfront_queue *queue, RING_IDX val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->rx_cons_lock, flags);
+	queue->rx.rsp_cons = val;
+	queue->rx_rsp_unconsumed = RING_HAS_UNCONSUMED_RESPONSES(&queue->rx);
+	spin_unlock_irqrestore(&queue->rx_cons_lock, flags);
+}
+
 static void xennet_move_rx_slot(struct netfront_queue *queue, struct sk_buff *skb,
 				grant_ref_t ref)
 {
@@ -799,7 +817,7 @@ static int xennet_get_extras(struct netf
 		xennet_move_rx_slot(queue, skb, ref);
 	} while (extra.flags & XEN_NETIF_EXTRA_FLAG_MORE);
 
-	queue->rx.rsp_cons = cons;
+	xennet_set_rx_rsp_cons(queue, cons);
 	return err;
 }
 
@@ -879,7 +897,7 @@ next:
 	}
 
 	if (unlikely(err))
-		queue->rx.rsp_cons = cons + slots;
+		xennet_set_rx_rsp_cons(queue, cons + slots);
 
 	return err;
 }
@@ -933,7 +951,8 @@ static int xennet_fill_frags(struct netf
 			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
 		}
 		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
-			queue->rx.rsp_cons = ++cons + skb_queue_len(list);
+			xennet_set_rx_rsp_cons(queue,
+					       ++cons + skb_queue_len(list));
 			kfree_skb(nskb);
 			return -ENOENT;
 		}
@@ -946,7 +965,7 @@ static int xennet_fill_frags(struct netf
 		kfree_skb(nskb);
 	}
 
-	queue->rx.rsp_cons = cons;
+	xennet_set_rx_rsp_cons(queue, cons);
 
 	return 0;
 }
@@ -1067,7 +1086,9 @@ err:
 
 			if (unlikely(xennet_set_skb_gso(skb, gso))) {
 				__skb_queue_head(&tmpq, skb);
-				queue->rx.rsp_cons += skb_queue_len(&tmpq);
+				xennet_set_rx_rsp_cons(queue,
+						       queue->rx.rsp_cons +
+						       skb_queue_len(&tmpq));
 				goto err;
 			}
 		}
@@ -1091,7 +1112,8 @@ err:
 
 		__skb_queue_tail(&rxq, skb);
 
-		i = ++queue->rx.rsp_cons;
+		i = queue->rx.rsp_cons + 1;
+		xennet_set_rx_rsp_cons(queue, i);
 		work_done++;
 	}
 
@@ -1275,40 +1297,79 @@ static int xennet_set_features(struct ne
 	return 0;
 }
 
-static irqreturn_t xennet_tx_interrupt(int irq, void *dev_id)
+static bool xennet_handle_tx(struct netfront_queue *queue, unsigned int *eoi)
 {
-	struct netfront_queue *queue = dev_id;
 	unsigned long flags;
 
-	if (queue->info->broken)
-		return IRQ_HANDLED;
+	if (unlikely(queue->info->broken))
+		return false;
 
 	spin_lock_irqsave(&queue->tx_lock, flags);
-	xennet_tx_buf_gc(queue);
+	if (xennet_tx_buf_gc(queue))
+		*eoi = 0;
 	spin_unlock_irqrestore(&queue->tx_lock, flags);
 
+	return true;
+}
+
+static irqreturn_t xennet_tx_interrupt(int irq, void *dev_id)
+{
+	unsigned int eoiflag = XEN_EOI_FLAG_SPURIOUS;
+
+	if (likely(xennet_handle_tx(dev_id, &eoiflag)))
+		xen_irq_lateeoi(irq, eoiflag);
+
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t xennet_rx_interrupt(int irq, void *dev_id)
+static bool xennet_handle_rx(struct netfront_queue *queue, unsigned int *eoi)
 {
-	struct netfront_queue *queue = dev_id;
-	struct net_device *dev = queue->info->netdev;
+	unsigned int work_queued;
+	unsigned long flags;
+
+	if (unlikely(queue->info->broken))
+		return false;
 
-	if (queue->info->broken)
-		return IRQ_HANDLED;
+	spin_lock_irqsave(&queue->rx_cons_lock, flags);
+	work_queued = RING_HAS_UNCONSUMED_RESPONSES(&queue->rx);
+	if (work_queued > queue->rx_rsp_unconsumed) {
+		queue->rx_rsp_unconsumed = work_queued;
+		*eoi = 0;
+	} else if (unlikely(work_queued < queue->rx_rsp_unconsumed)) {
+		const struct device *dev = &queue->info->netdev->dev;
+
+		spin_unlock_irqrestore(&queue->rx_cons_lock, flags);
+		dev_alert(dev, "RX producer index going backwards\n");
+		dev_alert(dev, "Disabled for further use\n");
+		queue->info->broken = true;
+		return false;
+	}
+	spin_unlock_irqrestore(&queue->rx_cons_lock, flags);
 
-	if (likely(netif_carrier_ok(dev) &&
-		   RING_HAS_UNCONSUMED_RESPONSES(&queue->rx)))
+	if (likely(netif_carrier_ok(queue->info->netdev) && work_queued))
 		napi_schedule(&queue->napi);
 
+	return true;
+}
+
+static irqreturn_t xennet_rx_interrupt(int irq, void *dev_id)
+{
+	unsigned int eoiflag = XEN_EOI_FLAG_SPURIOUS;
+
+	if (likely(xennet_handle_rx(dev_id, &eoiflag)))
+		xen_irq_lateeoi(irq, eoiflag);
+
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t xennet_interrupt(int irq, void *dev_id)
 {
-	xennet_tx_interrupt(irq, dev_id);
-	xennet_rx_interrupt(irq, dev_id);
+	unsigned int eoiflag = XEN_EOI_FLAG_SPURIOUS;
+
+	if (xennet_handle_tx(dev_id, &eoiflag) &&
+	    xennet_handle_rx(dev_id, &eoiflag))
+		xen_irq_lateeoi(irq, eoiflag);
+
 	return IRQ_HANDLED;
 }
 
@@ -1540,9 +1601,10 @@ static int setup_netfront_single(struct
 	if (err < 0)
 		goto fail;
 
-	err = bind_evtchn_to_irqhandler(queue->tx_evtchn,
-					xennet_interrupt,
-					0, queue->info->netdev->name, queue);
+	err = bind_evtchn_to_irqhandler_lateeoi(queue->tx_evtchn,
+						xennet_interrupt, 0,
+						queue->info->netdev->name,
+						queue);
 	if (err < 0)
 		goto bind_fail;
 	queue->rx_evtchn = queue->tx_evtchn;
@@ -1570,18 +1632,18 @@ static int setup_netfront_split(struct n
 
 	snprintf(queue->tx_irq_name, sizeof(queue->tx_irq_name),
 		 "%s-tx", queue->name);
-	err = bind_evtchn_to_irqhandler(queue->tx_evtchn,
-					xennet_tx_interrupt,
-					0, queue->tx_irq_name, queue);
+	err = bind_evtchn_to_irqhandler_lateeoi(queue->tx_evtchn,
+						xennet_tx_interrupt, 0,
+						queue->tx_irq_name, queue);
 	if (err < 0)
 		goto bind_tx_fail;
 	queue->tx_irq = err;
 
 	snprintf(queue->rx_irq_name, sizeof(queue->rx_irq_name),
 		 "%s-rx", queue->name);
-	err = bind_evtchn_to_irqhandler(queue->rx_evtchn,
-					xennet_rx_interrupt,
-					0, queue->rx_irq_name, queue);
+	err = bind_evtchn_to_irqhandler_lateeoi(queue->rx_evtchn,
+						xennet_rx_interrupt, 0,
+						queue->rx_irq_name, queue);
 	if (err < 0)
 		goto bind_rx_fail;
 	queue->rx_irq = err;
@@ -1683,6 +1745,7 @@ static int xennet_init_queue(struct netf
 
 	spin_lock_init(&queue->tx_lock);
 	spin_lock_init(&queue->rx_lock);
+	spin_lock_init(&queue->rx_cons_lock);
 
 	setup_timer(&queue->rx_refill_timer, rx_refill_timeout,
 		    (unsigned long)queue);


