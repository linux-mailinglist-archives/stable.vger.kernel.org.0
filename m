Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0B247AE9C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhLTPBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37762 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240015AbhLTO7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93D2AB80EF1;
        Mon, 20 Dec 2021 14:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D570EC36AE7;
        Mon, 20 Dec 2021 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012387;
        bh=WFmlfzG5I+MJq6rZvxF1F3bvPT8vxp1gXnAF6JdTpa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNqNsCfN4z/ZWbxcGEuvP++ccJJobucRthn9xmIrc7kUzy9xGn9xCIdT4+EBBvmmK
         0LhpXwJ8otXHeGMExdaA2H+8gJ6WNXaaaTqOsr/Ziu0P7FF1RtbwCsHaHhNAGUMrRa
         yx6UrvgYqJTrvYQBxKGPGYokAT5GvoLesrF4pHeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.15 176/177] xen/netback: fix rx queue stall detection
Date:   Mon, 20 Dec 2021 15:35:26 +0100
Message-Id: <20211220143045.989062122@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 6032046ec4b70176d247a71836186d47b25d1684 upstream.

Commit 1d5d48523900a4b ("xen-netback: require fewer guest Rx slots when
not using GSO") introduced a security problem in netback, as an
interface would only be regarded to be stalled if no slot is available
in the rx queue ring page. In case the SKB at the head of the queued
requests will need more than one rx slot and only one slot is free the
stall detection logic will never trigger, as the test for that is only
looking for at least one slot to be free.

Fix that by testing for the needed number of slots instead of only one
slot being available.

In order to not have to take the rx queue lock that often, store the
number of needed slots in the queue data. As all SKB dequeue operations
happen in the rx queue kernel thread this is safe, as long as the
number of needed slots is accessed via READ/WRITE_ONCE() only and
updates are always done with the rx queue lock held.

Add a small helper for obtaining the number of free slots.

This is part of XSA-392

Fixes: 1d5d48523900a4b ("xen-netback: require fewer guest Rx slots when not using GSO")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/common.h |    1 
 drivers/net/xen-netback/rx.c     |   65 ++++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 24 deletions(-)

--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -203,6 +203,7 @@ struct xenvif_queue { /* Per-queue data
 	unsigned int rx_queue_max;
 	unsigned int rx_queue_len;
 	unsigned long last_rx_time;
+	unsigned int rx_slots_needed;
 	bool stalled;
 
 	struct xenvif_copy_state rx_copy;
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -33,28 +33,36 @@
 #include <xen/xen.h>
 #include <xen/events.h>
 
-static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
+/*
+ * Update the needed ring page slots for the first SKB queued.
+ * Note that any call sequence outside the RX thread calling this function
+ * needs to wake up the RX thread via a call of xenvif_kick_thread()
+ * afterwards in order to avoid a race with putting the thread to sleep.
+ */
+static void xenvif_update_needed_slots(struct xenvif_queue *queue,
+				       const struct sk_buff *skb)
 {
-	RING_IDX prod, cons;
-	struct sk_buff *skb;
-	int needed;
-	unsigned long flags;
+	unsigned int needed = 0;
 
-	spin_lock_irqsave(&queue->rx_queue.lock, flags);
-
-	skb = skb_peek(&queue->rx_queue);
-	if (!skb) {
-		spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
-		return false;
+	if (skb) {
+		needed = DIV_ROUND_UP(skb->len, XEN_PAGE_SIZE);
+		if (skb_is_gso(skb))
+			needed++;
+		if (skb->sw_hash)
+			needed++;
 	}
 
-	needed = DIV_ROUND_UP(skb->len, XEN_PAGE_SIZE);
-	if (skb_is_gso(skb))
-		needed++;
-	if (skb->sw_hash)
-		needed++;
+	WRITE_ONCE(queue->rx_slots_needed, needed);
+}
 
-	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
+{
+	RING_IDX prod, cons;
+	unsigned int needed;
+
+	needed = READ_ONCE(queue->rx_slots_needed);
+	if (!needed)
+		return false;
 
 	do {
 		prod = queue->rx.sring->req_prod;
@@ -80,6 +88,9 @@ void xenvif_rx_queue_tail(struct xenvif_
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
+	if (skb_queue_empty(&queue->rx_queue))
+		xenvif_update_needed_slots(queue, skb);
+
 	__skb_queue_tail(&queue->rx_queue, skb);
 
 	queue->rx_queue_len += skb->len;
@@ -100,6 +111,8 @@ static struct sk_buff *xenvif_rx_dequeue
 
 	skb = __skb_dequeue(&queue->rx_queue);
 	if (skb) {
+		xenvif_update_needed_slots(queue, skb_peek(&queue->rx_queue));
+
 		queue->rx_queue_len -= skb->len;
 		if (queue->rx_queue_len < queue->rx_queue_max) {
 			struct netdev_queue *txq;
@@ -487,27 +500,31 @@ void xenvif_rx_action(struct xenvif_queu
 	xenvif_rx_copy_flush(queue);
 }
 
-static bool xenvif_rx_queue_stalled(struct xenvif_queue *queue)
+static RING_IDX xenvif_rx_queue_slots(const struct xenvif_queue *queue)
 {
 	RING_IDX prod, cons;
 
 	prod = queue->rx.sring->req_prod;
 	cons = queue->rx.req_cons;
 
+	return prod - cons;
+}
+
+static bool xenvif_rx_queue_stalled(const struct xenvif_queue *queue)
+{
+	unsigned int needed = READ_ONCE(queue->rx_slots_needed);
+
 	return !queue->stalled &&
-		prod - cons < 1 &&
+		xenvif_rx_queue_slots(queue) < needed &&
 		time_after(jiffies,
 			   queue->last_rx_time + queue->vif->stall_timeout);
 }
 
 static bool xenvif_rx_queue_ready(struct xenvif_queue *queue)
 {
-	RING_IDX prod, cons;
-
-	prod = queue->rx.sring->req_prod;
-	cons = queue->rx.req_cons;
+	unsigned int needed = READ_ONCE(queue->rx_slots_needed);
 
-	return queue->stalled && prod - cons >= 1;
+	return queue->stalled && xenvif_rx_queue_slots(queue) >= needed;
 }
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread)


