Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2996AF061
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCGSaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjCGS3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6AE43910
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05614CE1C8D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB36C433D2;
        Tue,  7 Mar 2023 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213385;
        bh=4KGg3EveVte5vnCaNWbVj+yIR+HRcuGyhW5Mu+h98SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksTKZSGfWNcQ8wn1fD2zvo0HIgWrtwSOugzTjhYqvYhnUcyM5F8TpvIfcJKcXSMtA
         CghcacbiWGPFuDTtQgBO/TUQIOEOIO1dCUuKucPryT/QjYOtc1dH3S6YU2OnpQyWve
         mIOBOh5g0IRLpldT9rRW/+amyxvNholNFFQd7x/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 490/885] RDMA/rxe: Fix missing memory barriers in rxe_queue.h
Date:   Tue,  7 Mar 2023 17:57:04 +0100
Message-Id: <20230307170023.752135970@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit a77a52385e9a761f896a88a4162e69fb7ccafe3f ]

An earlier patch which introduced smp_load_acquire/smp_store_release
into rxe_queue.h incorrectly assumed that surrounding spin-locks in
rxe_verbs.c around queue updates for kernel ulps was sufficient to
protect the passing of data through the queues between the ulp and
the rxe tasklets. But this was incorrect. The typical sequence was

	ulp				rxe requester tasklet
	------------------------	---------------------
	spin_lock_irqsave()		wqe = queue_head(queue)
	if (!queue_full(q)) {		if (!wqe)
		spin_unlock_irqrestore		return;
		return -ENOMEM
	}				<process wqe>
	wqe = queue_producer_addr(q)
	<fill in wqe>			queue_advance_consumer(queue)
	queue_advance_producer(q)
	spin_unlock_irqrestore()

queue_head() calls queue_empty() which calls smp_load_acquire()
For user space apps queue_advance_producer() calls smp_store_release()
so that there is a memory barrier between the producer and the
consumer but for kernel ulps queue_advance_produce() just incremented
the producer index because the lock function is a release function.
But to work the barrier has to come between filling in the wqe and
updating the producer index. This patch adds the missing barriers.
It also changes the enum names for the ulp queue types to
	QUEUE_TYPE_FROM/TO_ULP instead of QUEUE_TYPE_TO/FROM_DRIVER
which is very ambiguous. This bug is suspected as the cause of very
rare lockups in a very high scale storage application. It is a bug
in any case and should be corrected.

Fixes: 0a67c46d2e99 ("RDMA/rxe: Protect user space index loads/stores")
Link: https://lore.kernel.org/r/20230214071053.5395-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_queue.h | 108 ++++++++++++++++----------
 drivers/infiniband/sw/rxe/rxe_verbs.c |  20 ++---
 2 files changed, 76 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_queue.h b/drivers/infiniband/sw/rxe/rxe_queue.h
index ed44042782fa7..c711cb98b9496 100644
--- a/drivers/infiniband/sw/rxe/rxe_queue.h
+++ b/drivers/infiniband/sw/rxe/rxe_queue.h
@@ -35,19 +35,26 @@
 /**
  * enum queue_type - type of queue
  * @QUEUE_TYPE_TO_CLIENT:	Queue is written by rxe driver and
- *				read by client. Used by rxe driver only.
+ *				read by client which may be a user space
+ *				application or a kernel ulp.
+ *				Used by rxe internals only.
  * @QUEUE_TYPE_FROM_CLIENT:	Queue is written by client and
- *				read by rxe driver. Used by rxe driver only.
- * @QUEUE_TYPE_TO_DRIVER:	Queue is written by client and
- *				read by rxe driver. Used by kernel client only.
- * @QUEUE_TYPE_FROM_DRIVER:	Queue is written by rxe driver and
- *				read by client. Used by kernel client only.
+ *				read by rxe driver.
+ *				Used by rxe internals only.
+ * @QUEUE_TYPE_FROM_ULP:	Queue is written by kernel ulp and
+ *				read by rxe driver.
+ *				Used by kernel verbs APIs only on
+ *				behalf of ulps.
+ * @QUEUE_TYPE_TO_ULP:		Queue is written by rxe driver and
+ *				read by kernel ulp.
+ *				Used by kernel verbs APIs only on
+ *				behalf of ulps.
  */
 enum queue_type {
 	QUEUE_TYPE_TO_CLIENT,
 	QUEUE_TYPE_FROM_CLIENT,
-	QUEUE_TYPE_TO_DRIVER,
-	QUEUE_TYPE_FROM_DRIVER,
+	QUEUE_TYPE_FROM_ULP,
+	QUEUE_TYPE_TO_ULP,
 };
 
 struct rxe_queue_buf;
@@ -62,9 +69,9 @@ struct rxe_queue {
 	u32			index_mask;
 	enum queue_type		type;
 	/* private copy of index for shared queues between
-	 * kernel space and user space. Kernel reads and writes
+	 * driver and clients. Driver reads and writes
 	 * this copy and then replicates to rxe_queue_buf
-	 * for read access by user space.
+	 * for read access by clients.
 	 */
 	u32			index;
 };
@@ -97,19 +104,21 @@ static inline u32 queue_get_producer(const struct rxe_queue *q,
 
 	switch (type) {
 	case QUEUE_TYPE_FROM_CLIENT:
-		/* protect user index */
+		/* used by rxe, client owns the index */
 		prod = smp_load_acquire(&q->buf->producer_index);
 		break;
 	case QUEUE_TYPE_TO_CLIENT:
+		/* used by rxe which owns the index */
 		prod = q->index;
 		break;
-	case QUEUE_TYPE_FROM_DRIVER:
-		/* protect driver index */
-		prod = smp_load_acquire(&q->buf->producer_index);
-		break;
-	case QUEUE_TYPE_TO_DRIVER:
+	case QUEUE_TYPE_FROM_ULP:
+		/* used by ulp which owns the index */
 		prod = q->buf->producer_index;
 		break;
+	case QUEUE_TYPE_TO_ULP:
+		/* used by ulp, rxe owns the index */
+		prod = smp_load_acquire(&q->buf->producer_index);
+		break;
 	}
 
 	return prod;
@@ -122,19 +131,21 @@ static inline u32 queue_get_consumer(const struct rxe_queue *q,
 
 	switch (type) {
 	case QUEUE_TYPE_FROM_CLIENT:
+		/* used by rxe which owns the index */
 		cons = q->index;
 		break;
 	case QUEUE_TYPE_TO_CLIENT:
-		/* protect user index */
+		/* used by rxe, client owns the index */
 		cons = smp_load_acquire(&q->buf->consumer_index);
 		break;
-	case QUEUE_TYPE_FROM_DRIVER:
-		cons = q->buf->consumer_index;
-		break;
-	case QUEUE_TYPE_TO_DRIVER:
-		/* protect driver index */
+	case QUEUE_TYPE_FROM_ULP:
+		/* used by ulp, rxe owns the index */
 		cons = smp_load_acquire(&q->buf->consumer_index);
 		break;
+	case QUEUE_TYPE_TO_ULP:
+		/* used by ulp which owns the index */
+		cons = q->buf->consumer_index;
+		break;
 	}
 
 	return cons;
@@ -172,24 +183,31 @@ static inline void queue_advance_producer(struct rxe_queue *q,
 
 	switch (type) {
 	case QUEUE_TYPE_FROM_CLIENT:
-		pr_warn("%s: attempt to advance client index\n",
-			__func__);
+		/* used by rxe, client owns the index */
+		if (WARN_ON(1))
+			pr_warn("%s: attempt to advance client index\n",
+				__func__);
 		break;
 	case QUEUE_TYPE_TO_CLIENT:
+		/* used by rxe which owns the index */
 		prod = q->index;
 		prod = (prod + 1) & q->index_mask;
 		q->index = prod;
-		/* protect user index */
+		/* release so client can read it safely */
 		smp_store_release(&q->buf->producer_index, prod);
 		break;
-	case QUEUE_TYPE_FROM_DRIVER:
-		pr_warn("%s: attempt to advance driver index\n",
-			__func__);
-		break;
-	case QUEUE_TYPE_TO_DRIVER:
+	case QUEUE_TYPE_FROM_ULP:
+		/* used by ulp which owns the index */
 		prod = q->buf->producer_index;
 		prod = (prod + 1) & q->index_mask;
-		q->buf->producer_index = prod;
+		/* release so rxe can read it safely */
+		smp_store_release(&q->buf->producer_index, prod);
+		break;
+	case QUEUE_TYPE_TO_ULP:
+		/* used by ulp, rxe owns the index */
+		if (WARN_ON(1))
+			pr_warn("%s: attempt to advance driver index\n",
+				__func__);
 		break;
 	}
 }
@@ -201,24 +219,30 @@ static inline void queue_advance_consumer(struct rxe_queue *q,
 
 	switch (type) {
 	case QUEUE_TYPE_FROM_CLIENT:
-		cons = q->index;
-		cons = (cons + 1) & q->index_mask;
+		/* used by rxe which owns the index */
+		cons = (q->index + 1) & q->index_mask;
 		q->index = cons;
-		/* protect user index */
+		/* release so client can read it safely */
 		smp_store_release(&q->buf->consumer_index, cons);
 		break;
 	case QUEUE_TYPE_TO_CLIENT:
-		pr_warn("%s: attempt to advance client index\n",
-			__func__);
+		/* used by rxe, client owns the index */
+		if (WARN_ON(1))
+			pr_warn("%s: attempt to advance client index\n",
+				__func__);
+		break;
+	case QUEUE_TYPE_FROM_ULP:
+		/* used by ulp, rxe owns the index */
+		if (WARN_ON(1))
+			pr_warn("%s: attempt to advance driver index\n",
+				__func__);
 		break;
-	case QUEUE_TYPE_FROM_DRIVER:
+	case QUEUE_TYPE_TO_ULP:
+		/* used by ulp which owns the index */
 		cons = q->buf->consumer_index;
 		cons = (cons + 1) & q->index_mask;
-		q->buf->consumer_index = cons;
-		break;
-	case QUEUE_TYPE_TO_DRIVER:
-		pr_warn("%s: attempt to advance driver index\n",
-			__func__);
+		/* release so rxe can read it safely */
+		smp_store_release(&q->buf->consumer_index, cons);
 		break;
 	}
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 3bc0448f56deb..be13bcb4cc406 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -244,7 +244,7 @@ static int post_one_recv(struct rxe_rq *rq, const struct ib_recv_wr *ibwr)
 	int num_sge = ibwr->num_sge;
 	int full;
 
-	full = queue_full(rq->queue, QUEUE_TYPE_TO_DRIVER);
+	full = queue_full(rq->queue, QUEUE_TYPE_FROM_ULP);
 	if (unlikely(full))
 		return -ENOMEM;
 
@@ -255,7 +255,7 @@ static int post_one_recv(struct rxe_rq *rq, const struct ib_recv_wr *ibwr)
 	for (i = 0; i < num_sge; i++)
 		length += ibwr->sg_list[i].length;
 
-	recv_wqe = queue_producer_addr(rq->queue, QUEUE_TYPE_TO_DRIVER);
+	recv_wqe = queue_producer_addr(rq->queue, QUEUE_TYPE_FROM_ULP);
 	recv_wqe->wr_id = ibwr->wr_id;
 
 	memcpy(recv_wqe->dma.sge, ibwr->sg_list,
@@ -267,7 +267,7 @@ static int post_one_recv(struct rxe_rq *rq, const struct ib_recv_wr *ibwr)
 	recv_wqe->dma.cur_sge		= 0;
 	recv_wqe->dma.sge_offset	= 0;
 
-	queue_advance_producer(rq->queue, QUEUE_TYPE_TO_DRIVER);
+	queue_advance_producer(rq->queue, QUEUE_TYPE_FROM_ULP);
 
 	return 0;
 }
@@ -622,17 +622,17 @@ static int post_one_send(struct rxe_qp *qp, const struct ib_send_wr *ibwr,
 
 	spin_lock_irqsave(&qp->sq.sq_lock, flags);
 
-	full = queue_full(sq->queue, QUEUE_TYPE_TO_DRIVER);
+	full = queue_full(sq->queue, QUEUE_TYPE_FROM_ULP);
 
 	if (unlikely(full)) {
 		spin_unlock_irqrestore(&qp->sq.sq_lock, flags);
 		return -ENOMEM;
 	}
 
-	send_wqe = queue_producer_addr(sq->queue, QUEUE_TYPE_TO_DRIVER);
+	send_wqe = queue_producer_addr(sq->queue, QUEUE_TYPE_FROM_ULP);
 	init_send_wqe(qp, ibwr, mask, length, send_wqe);
 
-	queue_advance_producer(sq->queue, QUEUE_TYPE_TO_DRIVER);
+	queue_advance_producer(sq->queue, QUEUE_TYPE_FROM_ULP);
 
 	spin_unlock_irqrestore(&qp->sq.sq_lock, flags);
 
@@ -820,12 +820,12 @@ static int rxe_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
 	for (i = 0; i < num_entries; i++) {
-		cqe = queue_head(cq->queue, QUEUE_TYPE_FROM_DRIVER);
+		cqe = queue_head(cq->queue, QUEUE_TYPE_TO_ULP);
 		if (!cqe)
 			break;
 
 		memcpy(wc++, &cqe->ibwc, sizeof(*wc));
-		queue_advance_consumer(cq->queue, QUEUE_TYPE_FROM_DRIVER);
+		queue_advance_consumer(cq->queue, QUEUE_TYPE_TO_ULP);
 	}
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 
@@ -837,7 +837,7 @@ static int rxe_peek_cq(struct ib_cq *ibcq, int wc_cnt)
 	struct rxe_cq *cq = to_rcq(ibcq);
 	int count;
 
-	count = queue_count(cq->queue, QUEUE_TYPE_FROM_DRIVER);
+	count = queue_count(cq->queue, QUEUE_TYPE_TO_ULP);
 
 	return (count > wc_cnt) ? wc_cnt : count;
 }
@@ -853,7 +853,7 @@ static int rxe_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 	if (cq->notify != IB_CQ_NEXT_COMP)
 		cq->notify = flags & IB_CQ_SOLICITED_MASK;
 
-	empty = queue_empty(cq->queue, QUEUE_TYPE_FROM_DRIVER);
+	empty = queue_empty(cq->queue, QUEUE_TYPE_TO_ULP);
 
 	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !empty)
 		ret = 1;
-- 
2.39.2



