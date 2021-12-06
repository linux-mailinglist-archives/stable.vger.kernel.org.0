Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF03B4699D8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345075AbhLFPEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbhLFPDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:03:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BD4C0698D6;
        Mon,  6 Dec 2021 06:59:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 433C061311;
        Mon,  6 Dec 2021 14:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24588C341C1;
        Mon,  6 Dec 2021 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802785;
        bh=x6lvkpKluC4z9oPPnaFFjeRYY6Jd3o0b2TnBAAQwKjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cO4VnMm5iZn1x7dYv3+5V0iI79c4uZLHKzU9wl/+yQPojuSSGYQclghFX9WykAFr+
         UmeK2W4uKPTlAOMC8DJqO9tKO/I/PARptDqoQ0dNx3VgnObDczyY24LPFxdVe3JqGQ
         eBv/dwDmbsybolqQgxsiSvXpNz0bmBfFkNVAgwTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 32/52] xen/netfront: dont trust the backend response data blindly
Date:   Mon,  6 Dec 2021 15:56:16 +0100
Message-Id: <20211206145548.974503615@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit a884daa61a7d91650987e855464526aef219590f upstream.

Today netfront will trust the backend to send only sane response data.
In order to avoid privilege escalations or crashes in case of malicious
backends verify the data to be within expected limits. Especially make
sure that the response always references an outstanding request.

Note that only the tx queue needs special id handling, as for the rx
queue the id is equal to the index in the ring page.

Introduce a new indicator for the device whether it is broken and let
the device stop working when it is set. Set this indicator in case the
backend sets any weird data.


Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   80 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 75 insertions(+), 5 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -125,10 +125,12 @@ struct netfront_queue {
 	struct sk_buff *tx_skbs[NET_TX_RING_SIZE];
 	unsigned short tx_link[NET_TX_RING_SIZE];
 #define TX_LINK_NONE 0xffff
+#define TX_PENDING   0xfffe
 	grant_ref_t gref_tx_head;
 	grant_ref_t grant_tx_ref[NET_TX_RING_SIZE];
 	struct page *grant_tx_page[NET_TX_RING_SIZE];
 	unsigned tx_skb_freelist;
+	unsigned int tx_pend_queue;
 
 	spinlock_t   rx_lock ____cacheline_aligned_in_smp;
 	struct xen_netif_rx_front_ring rx;
@@ -154,6 +156,9 @@ struct netfront_info {
 	struct netfront_stats __percpu *rx_stats;
 	struct netfront_stats __percpu *tx_stats;
 
+	/* Is device behaving sane? */
+	bool broken;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -338,7 +343,7 @@ static int xennet_open(struct net_device
 	unsigned int i = 0;
 	struct netfront_queue *queue = NULL;
 
-	if (!np->queues)
+	if (!np->queues || np->broken)
 		return -ENODEV;
 
 	for (i = 0; i < num_queues; ++i) {
@@ -365,11 +370,17 @@ static void xennet_tx_buf_gc(struct netf
 	RING_IDX cons, prod;
 	unsigned short id;
 	struct sk_buff *skb;
+	const struct device *dev = &queue->info->netdev->dev;
 
 	BUG_ON(!netif_carrier_ok(queue->info->netdev));
 
 	do {
 		prod = queue->tx.sring->rsp_prod;
+		if (RING_RESPONSE_PROD_OVERFLOW(&queue->tx, prod)) {
+			dev_alert(dev, "Illegal number of responses %u\n",
+				  prod - queue->tx.rsp_cons);
+			goto err;
+		}
 		rmb(); /* Ensure we see responses up to 'rp'. */
 
 		for (cons = queue->tx.rsp_cons; cons != prod; cons++) {
@@ -379,14 +390,27 @@ static void xennet_tx_buf_gc(struct netf
 			if (txrsp.status == XEN_NETIF_RSP_NULL)
 				continue;
 
-			id  = txrsp.id;
+			id = txrsp.id;
+			if (id >= RING_SIZE(&queue->tx)) {
+				dev_alert(dev,
+					  "Response has incorrect id (%u)\n",
+					  id);
+				goto err;
+			}
+			if (queue->tx_link[id] != TX_PENDING) {
+				dev_alert(dev,
+					  "Response for inactive request\n");
+				goto err;
+			}
+
+			queue->tx_link[id] = TX_LINK_NONE;
 			skb = queue->tx_skbs[id];
 			queue->tx_skbs[id] = NULL;
 			if (unlikely(gnttab_query_foreign_access(
 				queue->grant_tx_ref[id]) != 0)) {
-				pr_alert("%s: warning -- grant still in use by backend domain\n",
-					 __func__);
-				BUG();
+				dev_alert(dev,
+					  "Grant still in use by backend domain\n");
+				goto err;
 			}
 			gnttab_end_foreign_access_ref(
 				queue->grant_tx_ref[id], GNTMAP_readonly);
@@ -414,6 +438,12 @@ static void xennet_tx_buf_gc(struct netf
 	} while ((cons == prod) && (prod != queue->tx.sring->rsp_prod));
 
 	xennet_maybe_wake_tx(queue);
+
+	return;
+
+ err:
+	queue->info->broken = true;
+	dev_alert(dev, "Disabled for further use\n");
 }
 
 struct xennet_gnttab_make_txreq {
@@ -457,6 +487,12 @@ static void xennet_tx_setup_grant(unsign
 
 	*tx = info->tx_local;
 
+	/*
+	 * Put the request in the pending queue, it will be set to be pending
+	 * when the producer index is about to be raised.
+	 */
+	add_id_to_list(&queue->tx_pend_queue, queue->tx_link, id);
+
 	info->tx = tx;
 	info->size += info->tx_local.size;
 }
@@ -549,6 +585,15 @@ static u16 xennet_select_queue(struct ne
 	return queue_idx;
 }
 
+static void xennet_mark_tx_pending(struct netfront_queue *queue)
+{
+	unsigned int i;
+
+	while ((i = get_id_from_list(&queue->tx_pend_queue, queue->tx_link)) !=
+		TX_LINK_NONE)
+		queue->tx_link[i] = TX_PENDING;
+}
+
 #define MAX_XEN_SKB_FRAGS (65536 / XEN_PAGE_SIZE + 1)
 
 static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -571,6 +616,8 @@ static int xennet_start_xmit(struct sk_b
 	/* Drop the packet if no queues are set up */
 	if (num_queues < 1)
 		goto drop;
+	if (unlikely(np->broken))
+		goto drop;
 	/* Determine which queue to transmit this SKB on */
 	queue_index = skb_get_queue_mapping(skb);
 	queue = &np->queues[queue_index];
@@ -660,6 +707,8 @@ static int xennet_start_xmit(struct sk_b
 	/* First request has the packet length. */
 	first_tx->size = skb->len;
 
+	xennet_mark_tx_pending(queue);
+
 	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
 	if (notify)
 		notify_remote_via_irq(queue->tx_irq);
@@ -984,6 +1033,13 @@ static int xennet_poll(struct napi_struc
 	skb_queue_head_init(&tmpq);
 
 	rp = queue->rx.sring->rsp_prod;
+	if (RING_RESPONSE_PROD_OVERFLOW(&queue->rx, rp)) {
+		dev_alert(&dev->dev, "Illegal number of responses %u\n",
+			  rp - queue->rx.rsp_cons);
+		queue->info->broken = true;
+		spin_unlock(&queue->rx_lock);
+		return 0;
+	}
 	rmb(); /* Ensure we see queued responses up to 'rp'. */
 
 	i = queue->rx.rsp_cons;
@@ -1224,6 +1280,9 @@ static irqreturn_t xennet_tx_interrupt(i
 	struct netfront_queue *queue = dev_id;
 	unsigned long flags;
 
+	if (queue->info->broken)
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(&queue->tx_lock, flags);
 	xennet_tx_buf_gc(queue);
 	spin_unlock_irqrestore(&queue->tx_lock, flags);
@@ -1236,6 +1295,9 @@ static irqreturn_t xennet_rx_interrupt(i
 	struct netfront_queue *queue = dev_id;
 	struct net_device *dev = queue->info->netdev;
 
+	if (queue->info->broken)
+		return IRQ_HANDLED;
+
 	if (likely(netif_carrier_ok(dev) &&
 		   RING_HAS_UNCONSUMED_RESPONSES(&queue->rx)))
 		napi_schedule(&queue->napi);
@@ -1257,6 +1319,10 @@ static void xennet_poll_controller(struc
 	struct netfront_info *info = netdev_priv(dev);
 	unsigned int num_queues = dev->real_num_tx_queues;
 	unsigned int i;
+
+	if (info->broken)
+		return;
+
 	for (i = 0; i < num_queues; ++i)
 		xennet_interrupt(0, &info->queues[i]);
 }
@@ -1627,6 +1693,7 @@ static int xennet_init_queue(struct netf
 
 	/* Initialise tx_skb_freelist as a free chain containing every entry. */
 	queue->tx_skb_freelist = 0;
+	queue->tx_pend_queue = TX_LINK_NONE;
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
 		queue->tx_link[i] = i + 1;
 		queue->grant_tx_ref[i] = GRANT_INVALID_REF;
@@ -1842,6 +1909,9 @@ static int talk_to_netback(struct xenbus
 	if (info->queues)
 		xennet_destroy_queues(info);
 
+	/* For the case of a reconnect reset the "broken" indicator. */
+	info->broken = false;
+
 	err = xennet_create_queues(info, &num_queues);
 	if (err < 0) {
 		xenbus_dev_fatal(dev, err, "creating queues");


