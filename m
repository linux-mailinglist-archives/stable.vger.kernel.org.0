Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3F423A703
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHCMV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgHCMVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6231F2076B;
        Mon,  3 Aug 2020 12:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457281;
        bh=gKlcmSGlHvB6+8H+L2KwKuZ7/ab68uJDzVhy8Km+I8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WG/tnaZr2xXsuLlCT/zMIco+GfoNKCjCEWlBnmLAIVwgscnNIHI6rNdsIbSLAb0Df
         YEff0IXbUcSIB7+6cyiDsUL6aGtB6KknbOq0h7xVppovfgzBAEMxxEqiPOECtMtcuq
         kyW6o5booKRiIE7AlOyCPB42Jaucte/2SHCilkMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhaojuan Guo <zguo@redhat.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Honggang Li <honli@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.7 011/120] IB/rdmavt: Fix RQ counting issues causing use of an invalid RWQE
Date:   Mon,  3 Aug 2020 14:17:49 +0200
Message-Id: <20200803121903.407406951@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 54a485e9ec084da1a4b32dcf7749c7d760ed8aa5 upstream.

The lookaside count is improperly initialized to the size of the
Receive Queue with the additional +1.  In the traces below, the
RQ size is 384, so the count was set to 385.

The lookaside count is then rarely refreshed.  Note the high and
incorrect count in the trace below:

rvt_get_rwqe: [hfi1_0] wqe ffffc900078e9008 wr_id 55c7206d75a0 qpn c
	qpt 2 pid 3018 num_sge 1 head 1 tail 0, count 385
rvt_get_rwqe: (hfi1_rc_rcv+0x4eb/0x1480 [hfi1] <- rvt_get_rwqe) ret=0x1

The head,tail indicate there is only one RWQE posted although the count
says 385 and we correctly return the element 0.

The next call to rvt_get_rwqe with the decremented count:

rvt_get_rwqe: [hfi1_0] wqe ffffc900078e9058 wr_id 0 qpn c
	qpt 2 pid 3018 num_sge 0 head 1 tail 1, count 384
rvt_get_rwqe: (hfi1_rc_rcv+0x4eb/0x1480 [hfi1] <- rvt_get_rwqe) ret=0x1

Note that the RQ is empty (head == tail) yet we return the RWQE at tail 1,
which is not valid because of the bogus high count.

Best case, the RWQE has never been posted and the rc logic sees an RWQE
that is too small (all zeros) and puts the QP into an error state.

In the worst case, a server slow at posting receive buffers might fool
rvt_get_rwqe() into fetching an old RWQE and corrupt memory.

Fix by deleting the faulty initialization code and creating an
inline to fetch the posted count and convert all callers to use
new inline.

Fixes: f592ae3c999f ("IB/rdmavt: Fracture single lock used for posting and processing RWQEs")
Link: https://lore.kernel.org/r/20200728183848.22226.29132.stgit@awfm-01.aw.intel.com
Reported-by: Zhaojuan Guo <zguo@redhat.com>
Cc: <stable@vger.kernel.org> # 5.4.x
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Tested-by: Honggang Li <honli@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/rdmavt/qp.c |   33 ++++-----------------------------
 drivers/infiniband/sw/rdmavt/rc.c |    4 +---
 include/rdma/rdmavt_qp.h          |   19 +++++++++++++++++++
 3 files changed, 24 insertions(+), 32 deletions(-)

--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -898,8 +898,6 @@ static void rvt_init_qp(struct rvt_dev_i
 	qp->s_tail_ack_queue = 0;
 	qp->s_acked_ack_queue = 0;
 	qp->s_num_rd_atomic = 0;
-	if (qp->r_rq.kwq)
-		qp->r_rq.kwq->count = qp->r_rq.size;
 	qp->r_sge.num_sge = 0;
 	atomic_set(&qp->s_reserved_used, 0);
 }
@@ -2353,31 +2351,6 @@ bad_lkey:
 }
 
 /**
- * get_count - count numbers of request work queue entries
- * in circular buffer
- * @rq: data structure for request queue entry
- * @tail: tail indices of the circular buffer
- * @head: head indices of the circular buffer
- *
- * Return - total number of entries in the circular buffer
- */
-static u32 get_count(struct rvt_rq *rq, u32 tail, u32 head)
-{
-	u32 count;
-
-	count = head;
-
-	if (count >= rq->size)
-		count = 0;
-	if (count < tail)
-		count += rq->size - tail;
-	else
-		count -= tail;
-
-	return count;
-}
-
-/**
  * get_rvt_head - get head indices of the circular buffer
  * @rq: data structure for request queue entry
  * @ip: the QP
@@ -2451,7 +2424,7 @@ int rvt_get_rwqe(struct rvt_qp *qp, bool
 
 	if (kwq->count < RVT_RWQ_COUNT_THRESHOLD) {
 		head = get_rvt_head(rq, ip);
-		kwq->count = get_count(rq, tail, head);
+		kwq->count = rvt_get_rq_count(rq, head, tail);
 	}
 	if (unlikely(kwq->count == 0)) {
 		ret = 0;
@@ -2486,7 +2459,9 @@ int rvt_get_rwqe(struct rvt_qp *qp, bool
 		 * the number of remaining WQEs.
 		 */
 		if (kwq->count < srq->limit) {
-			kwq->count = get_count(rq, tail, get_rvt_head(rq, ip));
+			kwq->count =
+				rvt_get_rq_count(rq,
+						 get_rvt_head(rq, ip), tail);
 			if (kwq->count < srq->limit) {
 				struct ib_event ev;
 
--- a/drivers/infiniband/sw/rdmavt/rc.c
+++ b/drivers/infiniband/sw/rdmavt/rc.c
@@ -127,9 +127,7 @@ __be32 rvt_compute_aeth(struct rvt_qp *q
 			 * not atomic, which is OK, since the fuzziness is
 			 * resolved as further ACKs go out.
 			 */
-			credits = head - tail;
-			if ((int)credits < 0)
-				credits += qp->r_rq.size;
+			credits = rvt_get_rq_count(&qp->r_rq, head, tail);
 		}
 		/*
 		 * Binary search the credit table to find the code to
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -278,6 +278,25 @@ struct rvt_rq {
 	spinlock_t lock ____cacheline_aligned_in_smp;
 };
 
+/**
+ * rvt_get_rq_count - count numbers of request work queue entries
+ * in circular buffer
+ * @rq: data structure for request queue entry
+ * @head: head indices of the circular buffer
+ * @tail: tail indices of the circular buffer
+ *
+ * Return - total number of entries in the Receive Queue
+ */
+
+static inline u32 rvt_get_rq_count(struct rvt_rq *rq, u32 head, u32 tail)
+{
+	u32 count = head - tail;
+
+	if ((s32)count < 0)
+		count += rq->size;
+	return count;
+}
+
 /*
  * This structure holds the information that the send tasklet needs
  * to send a RDMA read response or atomic operation.


