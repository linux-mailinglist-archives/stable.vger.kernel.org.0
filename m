Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D12B2079
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390397AbfIMNWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390994AbfIMNWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:22:18 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03EB420717;
        Fri, 13 Sep 2019 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380937;
        bh=7gF5wCj+sK2WXkZCUhmUf+C0SqYX4bVf84XpdmzmAwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPgz5MO2bba8UkkhCYDN/HdaJYwA0ohOpDXkBWKdFalDPYN5mvCLLdEjLUeB6XWsX
         niqobvMBHudHIkVS6M9uTy06utapoffQIYhnLQKJl/BJtPB4a2x7NjJUSgBzqZ1D1Q
         Y9HwtitNNXDHh5kxoxW5PZeM0Uvj5zFTGBWuEyQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.2 22/37] IB/{rdmavt, qib, hfi1}: Convert to new completion API
Date:   Fri, 13 Sep 2019 14:07:27 +0100
Message-Id: <20190913130519.314201693@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Convert all completions to use the new completion routine that
fixes a race between post send and completion where fields from
a SWQE can be read after SWQE has been freed.

This patch also addresses issues reported in
https://marc.info/?l=linux-kernel&m=155656897409107&w=2.

The reserved operation path has no need for any barrier.

The barrier for the other path is addressed by the
smp_load_acquire() barrier.

Cc: Andrea Parri <andrea.parri@amarulasolutions.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 drivers/infiniband/hw/hfi1/rc.c    | 26 ++++-----------------
 drivers/infiniband/hw/qib/qib_rc.c | 26 ++++-----------------
 drivers/infiniband/sw/rdmavt/qp.c  | 31 ++++++++-----------------
 include/rdma/rdmavt_qp.h           | 36 ------------------------------
 4 files changed, 17 insertions(+), 102 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 7c8cfb149da09..235bdbc706acc 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1830,23 +1830,14 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_opa_header *opah)
 	}
 
 	while (qp->s_last != qp->s_acked) {
-		u32 s_last;
-
 		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		if (cmp_psn(wqe->lpsn, qp->s_sending_psn) >= 0 &&
 		    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
 		trdma_clean_swqe(qp, wqe);
 		rvt_qp_wqe_unreserve(qp, wqe);
-		s_last = qp->s_last;
-		trace_hfi1_qp_send_completion(qp, wqe, s_last);
-		if (++s_last >= qp->s_size)
-			s_last = 0;
-		qp->s_last = s_last;
-		/* see post_send() */
-		barrier();
-		rvt_put_qp_swqe(qp, wqe);
-		rvt_qp_swqe_complete(qp,
+		trace_hfi1_qp_send_completion(qp, wqe, qp->s_last);
+		rvt_qp_complete_swqe(qp,
 				     wqe,
 				     ib_hfi1_wc_opcode[wqe->wr.opcode],
 				     IB_WC_SUCCESS);
@@ -1890,19 +1881,10 @@ struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 	trace_hfi1_rc_completion(qp, wqe->lpsn);
 	if (cmp_psn(wqe->lpsn, qp->s_sending_psn) < 0 ||
 	    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
-		u32 s_last;
-
 		trdma_clean_swqe(qp, wqe);
-		rvt_put_qp_swqe(qp, wqe);
 		rvt_qp_wqe_unreserve(qp, wqe);
-		s_last = qp->s_last;
-		trace_hfi1_qp_send_completion(qp, wqe, s_last);
-		if (++s_last >= qp->s_size)
-			s_last = 0;
-		qp->s_last = s_last;
-		/* see post_send() */
-		barrier();
-		rvt_qp_swqe_complete(qp,
+		trace_hfi1_qp_send_completion(qp, wqe, qp->s_last);
+		rvt_qp_complete_swqe(qp,
 				     wqe,
 				     ib_hfi1_wc_opcode[wqe->wr.opcode],
 				     IB_WC_SUCCESS);
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 2ac4c67f5ba1a..8d9a94d6f6856 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -921,20 +921,11 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		rvt_add_retry_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {
-		u32 s_last;
-
 		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		if (qib_cmp24(wqe->lpsn, qp->s_sending_psn) >= 0 &&
 		    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
-		s_last = qp->s_last;
-		if (++s_last >= qp->s_size)
-			s_last = 0;
-		qp->s_last = s_last;
-		/* see post_send() */
-		barrier();
-		rvt_put_qp_swqe(qp, wqe);
-		rvt_qp_swqe_complete(qp,
+		rvt_qp_complete_swqe(qp,
 				     wqe,
 				     ib_qib_wc_opcode[wqe->wr.opcode],
 				     IB_WC_SUCCESS);
@@ -972,21 +963,12 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 	 * is finished.
 	 */
 	if (qib_cmp24(wqe->lpsn, qp->s_sending_psn) < 0 ||
-	    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
-		u32 s_last;
-
-		rvt_put_qp_swqe(qp, wqe);
-		s_last = qp->s_last;
-		if (++s_last >= qp->s_size)
-			s_last = 0;
-		qp->s_last = s_last;
-		/* see post_send() */
-		barrier();
-		rvt_qp_swqe_complete(qp,
+	    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) > 0)
+		rvt_qp_complete_swqe(qp,
 				     wqe,
 				     ib_qib_wc_opcode[wqe->wr.opcode],
 				     IB_WC_SUCCESS);
-	} else
+	else
 		this_cpu_inc(*ibp->rvp.rc_delayed_comp);
 
 	qp->s_retry = qp->s_retry_cnt;
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index c5a50614a6c63..cb9e171d7e7bf 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1856,10 +1856,9 @@ static inline int rvt_qp_is_avail(
 
 	/* see rvt_qp_wqe_unreserve() */
 	smp_mb__before_atomic();
-	reserved_used = atomic_read(&qp->s_reserved_used);
 	if (unlikely(reserved_op)) {
 		/* see rvt_qp_wqe_unreserve() */
-		smp_mb__before_atomic();
+		reserved_used = atomic_read(&qp->s_reserved_used);
 		if (reserved_used >= rdi->dparms.reserved_operations)
 			return -ENOMEM;
 		return 0;
@@ -1867,14 +1866,13 @@ static inline int rvt_qp_is_avail(
 	/* non-reserved operations */
 	if (likely(qp->s_avail))
 		return 0;
-	slast = READ_ONCE(qp->s_last);
+	/* See rvt_qp_complete_swqe() */
+	slast = smp_load_acquire(&qp->s_last);
 	if (qp->s_head >= slast)
 		avail = qp->s_size - (qp->s_head - slast);
 	else
 		avail = slast - qp->s_head;
 
-	/* see rvt_qp_wqe_unreserve() */
-	smp_mb__before_atomic();
 	reserved_used = atomic_read(&qp->s_reserved_used);
 	avail =  avail - 1 -
 		(rdi->dparms.reserved_operations - reserved_used);
@@ -2667,27 +2665,16 @@ void rvt_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		       enum ib_wc_status status)
 {
 	u32 old_last, last;
-	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
+	struct rvt_dev_info *rdi;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
+	rdi = ib_to_rvt(qp->ibqp.device);
 
-	last = qp->s_last;
-	old_last = last;
-	trace_rvt_qp_send_completion(qp, wqe, last);
-	if (++last >= qp->s_size)
-		last = 0;
-	trace_rvt_qp_send_completion(qp, wqe, last);
-	qp->s_last = last;
-	/* See post_send() */
-	barrier();
-	rvt_put_qp_swqe(qp, wqe);
-
-	rvt_qp_swqe_complete(qp,
-			     wqe,
-			     rdi->wc_opcode[wqe->wr.opcode],
-			     status);
-
+	old_last = qp->s_last;
+	trace_rvt_qp_send_completion(qp, wqe, old_last);
+	last = rvt_qp_complete_swqe(qp, wqe, rdi->wc_opcode[wqe->wr.opcode],
+				    status);
 	if (qp->s_acked == old_last)
 		qp->s_acked = last;
 	if (qp->s_cur == old_last)
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 6014f17669071..84d0f36afc2f7 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -565,42 +565,6 @@ static inline void rvt_qp_wqe_unreserve(
 
 extern const enum ib_wc_opcode ib_rvt_wc_opcode[];
 
-/**
- * rvt_qp_swqe_complete() - insert send completion
- * @qp - the qp
- * @wqe - the send wqe
- * @status - completion status
- *
- * Insert a send completion into the completion
- * queue if the qp indicates it should be done.
- *
- * See IBTA 10.7.3.1 for info on completion
- * control.
- */
-static inline void rvt_qp_swqe_complete(
-	struct rvt_qp *qp,
-	struct rvt_swqe *wqe,
-	enum ib_wc_opcode opcode,
-	enum ib_wc_status status)
-{
-	if (unlikely(wqe->wr.send_flags & RVT_SEND_RESERVE_USED))
-		return;
-	if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
-	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
-	     status != IB_WC_SUCCESS) {
-		struct ib_wc wc;
-
-		memset(&wc, 0, sizeof(wc));
-		wc.wr_id = wqe->wr.wr_id;
-		wc.status = status;
-		wc.opcode = opcode;
-		wc.qp = &qp->ibqp;
-		wc.byte_len = wqe->length;
-		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc,
-			     status != IB_WC_SUCCESS);
-	}
-}
-
 /*
  * Compare the lower 24 bits of the msn values.
  * Returns an integer <, ==, or > than zero.
-- 
2.20.1



