Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC5E33B732
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhCON7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhCON6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E24464F2A;
        Mon, 15 Mar 2021 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816701;
        bh=rRxsMiMQxDaP1Whezji5ADgRg5QkUThQpfZvWv4TDFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvBSrmGYOQHRs6nYzilCAjOdVfivn/XKMplHMzYFazceO42F/XOtGKEU6IE1sIXwl
         ZPnMm8iR3rP6YMTgkRYd/t6MDPmOd/GvREfkShR64QfY2AVlmVChok3j41PBu+4/rB
         0Ia9JkrAluGYTT2q13OwJEoNJ0xFojwxuZFlHZmM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 073/306] s390/qeth: improve completion of pending TX buffers
Date:   Mon, 15 Mar 2021 14:52:16 +0100
Message-Id: <20210315135510.108940686@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Wiedmann <jwi@linux.ibm.com>

commit c20383ad1656b0f6354dd50e4acd894f9d94090d upstream.

The current design attaches a pending TX buffer to a custom
single-linked list, which is anchored at the buffer's slot on the
TX ring. The buffer is then checked for final completion whenever
this slot is processed during a subsequent TX NAPI poll cycle.

But if there's insufficient traffic on the ring, we might never make
enough progress to get back to this ring slot and discover the pending
buffer's final TX completion. In particular if this missing TX
completion blocks the application from sending further traffic.

So convert the custom single-linked list code to a per-queue list_head,
and scan this list on every TX NAPI cycle.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core.h      |    3 +
 drivers/s390/net/qeth_core_main.c |   69 +++++++++++++++-----------------------
 2 files changed, 30 insertions(+), 42 deletions(-)

--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -436,7 +436,7 @@ struct qeth_qdio_out_buffer {
 	int is_header[QDIO_MAX_ELEMENTS_PER_BUFFER];
 
 	struct qeth_qdio_out_q *q;
-	struct qeth_qdio_out_buffer *next_pending;
+	struct list_head list_entry;
 };
 
 struct qeth_card;
@@ -500,6 +500,7 @@ struct qeth_qdio_out_q {
 	struct qdio_buffer *qdio_bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qeth_qdio_out_buffer *bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qdio_outbuf_state *bufstates; /* convenience pointer */
+	struct list_head pending_bufs;
 	struct qeth_out_q_stats stats;
 	spinlock_t lock;
 	unsigned int priority;
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -73,8 +73,6 @@ static void qeth_free_qdio_queues(struct
 static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
 		struct qeth_qdio_out_buffer *buf,
 		enum iucv_tx_notify notification);
-static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
-				 int budget);
 
 static void qeth_close_dev_handler(struct work_struct *work)
 {
@@ -465,41 +463,6 @@ static enum iucv_tx_notify qeth_compute_
 	return n;
 }
 
-static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
-					 int forced_cleanup)
-{
-	if (q->card->options.cq != QETH_CQ_ENABLED)
-		return;
-
-	if (q->bufs[bidx]->next_pending != NULL) {
-		struct qeth_qdio_out_buffer *head = q->bufs[bidx];
-		struct qeth_qdio_out_buffer *c = q->bufs[bidx]->next_pending;
-
-		while (c) {
-			if (forced_cleanup ||
-			    atomic_read(&c->state) == QETH_QDIO_BUF_EMPTY) {
-				struct qeth_qdio_out_buffer *f = c;
-
-				QETH_CARD_TEXT(f->q->card, 5, "fp");
-				QETH_CARD_TEXT_(f->q->card, 5, "%lx", (long) f);
-				/* release here to avoid interleaving between
-				   outbound tasklet and inbound tasklet
-				   regarding notifications and lifecycle */
-				qeth_tx_complete_buf(c, forced_cleanup, 0);
-
-				c = f->next_pending;
-				WARN_ON_ONCE(head->next_pending != f);
-				head->next_pending = c;
-				kmem_cache_free(qeth_qdio_outbuf_cache, f);
-			} else {
-				head = c;
-				c = c->next_pending;
-			}
-
-		}
-	}
-}
-
 static void qeth_qdio_handle_aob(struct qeth_card *card,
 				 unsigned long phys_aob_addr)
 {
@@ -537,7 +500,7 @@ static void qeth_qdio_handle_aob(struct
 		qeth_notify_skbs(buffer->q, buffer, notification);
 
 		/* Free dangling allocations. The attached skbs are handled by
-		 * qeth_cleanup_handled_pending().
+		 * qeth_tx_complete_pending_bufs().
 		 */
 		for (i = 0;
 		     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
@@ -1484,14 +1447,35 @@ static void qeth_clear_output_buffer(str
 	atomic_set(&buf->state, QETH_QDIO_BUF_EMPTY);
 }
 
+static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
+					  struct qeth_qdio_out_q *queue,
+					  bool drain)
+{
+	struct qeth_qdio_out_buffer *buf, *tmp;
+
+	list_for_each_entry_safe(buf, tmp, &queue->pending_bufs, list_entry) {
+		if (drain || atomic_read(&buf->state) == QETH_QDIO_BUF_EMPTY) {
+			QETH_CARD_TEXT(card, 5, "fp");
+			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
+
+			qeth_tx_complete_buf(buf, drain, 0);
+
+			list_del(&buf->list_entry);
+			kmem_cache_free(qeth_qdio_outbuf_cache, buf);
+		}
+	}
+}
+
 static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 {
 	int j;
 
+	qeth_tx_complete_pending_bufs(q->card, q, true);
+
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
 		if (!q->bufs[j])
 			continue;
-		qeth_cleanup_handled_pending(q, j, 1);
+
 		qeth_clear_output_buffer(q, q->bufs[j], true, 0);
 		if (free) {
 			kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[j]);
@@ -2611,7 +2595,6 @@ static int qeth_init_qdio_out_buf(struct
 	skb_queue_head_init(&newbuf->skb_list);
 	lockdep_set_class(&newbuf->skb_list.lock, &qdio_out_skb_queue_key);
 	newbuf->q = q;
-	newbuf->next_pending = q->bufs[bidx];
 	atomic_set(&newbuf->state, QETH_QDIO_BUF_EMPTY);
 	q->bufs[bidx] = newbuf;
 	return 0;
@@ -2693,6 +2676,7 @@ static int qeth_alloc_qdio_queues(struct
 		card->qdio.out_qs[i] = queue;
 		queue->card = card;
 		queue->queue_no = i;
+		INIT_LIST_HEAD(&queue->pending_bufs);
 		spin_lock_init(&queue->lock);
 		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
@@ -6099,6 +6083,8 @@ static void qeth_iqd_tx_complete(struct
 					qeth_schedule_recovery(card);
 				}
 
+				list_add(&buffer->list_entry,
+					 &queue->pending_bufs);
 				/* Skip clearing the buffer: */
 				return;
 			case QETH_QDIO_BUF_QAOB_OK:
@@ -6154,6 +6140,8 @@ static int qeth_tx_poll(struct napi_stru
 		unsigned int bytes = 0;
 		int completed;
 
+		qeth_tx_complete_pending_bufs(card, queue, false);
+
 		if (qeth_out_queue_is_empty(queue)) {
 			napi_complete(napi);
 			return 0;
@@ -6186,7 +6174,6 @@ static int qeth_tx_poll(struct napi_stru
 
 			qeth_handle_send_error(card, buffer, error);
 			qeth_iqd_tx_complete(queue, bidx, error, budget);
-			qeth_cleanup_handled_pending(queue, bidx, false);
 		}
 
 		netdev_tx_completed_queue(txq, packets, bytes);


