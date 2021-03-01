Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCDA32888D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbhCARmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238640AbhCAReg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:34:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 838DD64F13;
        Mon,  1 Mar 2021 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617620;
        bh=vpsLdYaocT3QisefzFRoHw9RJiGvDi/bWgpS62TaveU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwmdeKXC7/vmeD9JnQQTy6FTPLajVGCm2BNxR67nEHo/QnoaiPH+lNfJQlgmA2lNf
         J3isxoSlQu6IiTUMqs10M3qg0m65HKgSouJ/Gj9TKG8K138jLpMhF/9+h0CRdMih/g
         MoWqSlYFMGUvqUbDzreECR0i3VVqzC3m2fpGN3uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/340] RDMA/siw: Fix handling of zero-sized Read and Receive Queues.
Date:   Mon,  1 Mar 2021 17:11:22 +0100
Message-Id: <20210301161055.109143551@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit 661f385961f06f36da24cf408d461f988d0c39ad ]

During connection setup, the application may choose to zero-size inbound
and outbound READ queues, as well as the Receive queue.  This patch fixes
handling of zero-sized queues, but not prevents it.

Kamal Heib says in an initial error report:

 When running the blktests over siw the following shift-out-of-bounds is
 reported, this is happening because the passed IRD or ORD from the ulp
 could be zero which will lead to unexpected behavior when calling
 roundup_pow_of_two(), fix that by blocking zero values of ORD or IRD.

   UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
   shift exponent 64 is too large for 64-bit type 'long unsigned int'
   CPU: 20 PID: 3957 Comm: kworker/u64:13 Tainted: G S     5.10.0-rc6 #2
   Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.1.5 04/11/2016
   Workqueue: iw_cm_wq cm_work_handler [iw_cm]
   Call Trace:
    dump_stack+0x99/0xcb
    ubsan_epilogue+0x5/0x40
    __ubsan_handle_shift_out_of_bounds.cold.11+0xb4/0xf3
    ? down_write+0x183/0x3d0
    siw_qp_modify.cold.8+0x2d/0x32 [siw]
    ? __local_bh_enable_ip+0xa5/0xf0
    siw_accept+0x906/0x1b60 [siw]
    ? xa_load+0x147/0x1f0
    ? siw_connect+0x17a0/0x17a0 [siw]
    ? lock_downgrade+0x700/0x700
    ? siw_get_base_qp+0x1c2/0x340 [siw]
    ? _raw_spin_unlock_irqrestore+0x39/0x40
    iw_cm_accept+0x1f4/0x430 [iw_cm]
    rdma_accept+0x3fa/0xb10 [rdma_cm]
    ? check_flush_dependency+0x410/0x410
    ? cma_rep_recv+0x570/0x570 [rdma_cm]
    nvmet_rdma_queue_connect+0x1a62/0x2680 [nvmet_rdma]
    ? nvmet_rdma_alloc_cmds+0xce0/0xce0 [nvmet_rdma]
    ? lock_release+0x56e/0xcc0
    ? lock_downgrade+0x700/0x700
    ? lock_downgrade+0x700/0x700
    ? __xa_alloc_cyclic+0xef/0x350
    ? __xa_alloc+0x2d0/0x2d0
    ? rdma_restrack_add+0xbe/0x2c0 [ib_core]
    ? __ww_mutex_die+0x190/0x190
    cma_cm_event_handler+0xf2/0x500 [rdma_cm]
    iw_conn_req_handler+0x910/0xcb0 [rdma_cm]
    ? _raw_spin_unlock_irqrestore+0x39/0x40
    ? trace_hardirqs_on+0x1c/0x150
    ? cma_ib_handler+0x8a0/0x8a0 [rdma_cm]
    ? __kasan_kmalloc.constprop.7+0xc1/0xd0
    cm_work_handler+0x121c/0x17a0 [iw_cm]
    ? iw_cm_reject+0x190/0x190 [iw_cm]
    ? trace_hardirqs_on+0x1c/0x150
    process_one_work+0x8fb/0x16c0
    ? pwq_dec_nr_in_flight+0x320/0x320
    worker_thread+0x87/0xb40
    ? __kthread_parkme+0xd1/0x1a0
    ? process_one_work+0x16c0/0x16c0
    kthread+0x35f/0x430
    ? kthread_mod_delayed_work+0x180/0x180
    ret_from_fork+0x22/0x30

Fixes: a531975279f3 ("rdma/siw: main include file")
Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Link: https://lore.kernel.org/r/20210108125845.1803-1-bmt@zurich.ibm.com
Reported-by: Kamal Heib <kamalheib1@gmail.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw.h       |   2 +-
 drivers/infiniband/sw/siw/siw_qp.c    | 271 ++++++++++++++------------
 drivers/infiniband/sw/siw/siw_qp_rx.c |  26 ++-
 drivers/infiniband/sw/siw/siw_qp_tx.c |   4 +-
 drivers/infiniband/sw/siw/siw_verbs.c |  20 +-
 5 files changed, 177 insertions(+), 146 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index dba4535494abd..4d8bc995b4503 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -667,7 +667,7 @@ static inline struct siw_sqe *orq_get_free(struct siw_qp *qp)
 {
 	struct siw_sqe *orq_e = orq_get_tail(qp);
 
-	if (orq_e && READ_ONCE(orq_e->flags) == 0)
+	if (READ_ONCE(orq_e->flags) == 0)
 		return orq_e;
 
 	return NULL;
diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index b4317480cee74..5927ac5923dd8 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -199,26 +199,26 @@ void siw_qp_llp_write_space(struct sock *sk)
 
 static int siw_qp_readq_init(struct siw_qp *qp, int irq_size, int orq_size)
 {
-	irq_size = roundup_pow_of_two(irq_size);
-	orq_size = roundup_pow_of_two(orq_size);
-
-	qp->attrs.irq_size = irq_size;
-	qp->attrs.orq_size = orq_size;
-
-	qp->irq = vzalloc(irq_size * sizeof(struct siw_sqe));
-	if (!qp->irq) {
-		siw_dbg_qp(qp, "irq malloc for %d failed\n", irq_size);
-		qp->attrs.irq_size = 0;
-		return -ENOMEM;
+	if (irq_size) {
+		irq_size = roundup_pow_of_two(irq_size);
+		qp->irq = vzalloc(irq_size * sizeof(struct siw_sqe));
+		if (!qp->irq) {
+			qp->attrs.irq_size = 0;
+			return -ENOMEM;
+		}
 	}
-	qp->orq = vzalloc(orq_size * sizeof(struct siw_sqe));
-	if (!qp->orq) {
-		siw_dbg_qp(qp, "orq malloc for %d failed\n", orq_size);
-		qp->attrs.orq_size = 0;
-		qp->attrs.irq_size = 0;
-		vfree(qp->irq);
-		return -ENOMEM;
+	if (orq_size) {
+		orq_size = roundup_pow_of_two(orq_size);
+		qp->orq = vzalloc(orq_size * sizeof(struct siw_sqe));
+		if (!qp->orq) {
+			qp->attrs.orq_size = 0;
+			qp->attrs.irq_size = 0;
+			vfree(qp->irq);
+			return -ENOMEM;
+		}
 	}
+	qp->attrs.irq_size = irq_size;
+	qp->attrs.orq_size = orq_size;
 	siw_dbg_qp(qp, "ORD %d, IRD %d\n", orq_size, irq_size);
 	return 0;
 }
@@ -288,13 +288,14 @@ int siw_qp_mpa_rts(struct siw_qp *qp, enum mpa_v2_ctrl ctrl)
 	if (ctrl & MPA_V2_RDMA_WRITE_RTR)
 		wqe->sqe.opcode = SIW_OP_WRITE;
 	else if (ctrl & MPA_V2_RDMA_READ_RTR) {
-		struct siw_sqe *rreq;
+		struct siw_sqe *rreq = NULL;
 
 		wqe->sqe.opcode = SIW_OP_READ;
 
 		spin_lock(&qp->orq_lock);
 
-		rreq = orq_get_free(qp);
+		if (qp->attrs.orq_size)
+			rreq = orq_get_free(qp);
 		if (rreq) {
 			siw_read_to_orq(rreq, &wqe->sqe);
 			qp->orq_put++;
@@ -877,135 +878,88 @@ void siw_read_to_orq(struct siw_sqe *rreq, struct siw_sqe *sqe)
 	rreq->num_sge = 1;
 }
 
-/*
- * Must be called with SQ locked.
- * To avoid complete SQ starvation by constant inbound READ requests,
- * the active IRQ will not be served after qp->irq_burst, if the
- * SQ has pending work.
- */
-int siw_activate_tx(struct siw_qp *qp)
+static int siw_activate_tx_from_sq(struct siw_qp *qp)
 {
-	struct siw_sqe *irqe, *sqe;
+	struct siw_sqe *sqe;
 	struct siw_wqe *wqe = tx_wqe(qp);
 	int rv = 1;
 
-	irqe = &qp->irq[qp->irq_get % qp->attrs.irq_size];
-
-	if (irqe->flags & SIW_WQE_VALID) {
-		sqe = sq_get_next(qp);
-
-		/*
-		 * Avoid local WQE processing starvation in case
-		 * of constant inbound READ request stream
-		 */
-		if (sqe && ++qp->irq_burst >= SIW_IRQ_MAXBURST_SQ_ACTIVE) {
-			qp->irq_burst = 0;
-			goto skip_irq;
-		}
-		memset(wqe->mem, 0, sizeof(*wqe->mem) * SIW_MAX_SGE);
-		wqe->wr_status = SIW_WR_QUEUED;
-
-		/* start READ RESPONSE */
-		wqe->sqe.opcode = SIW_OP_READ_RESPONSE;
-		wqe->sqe.flags = 0;
-		if (irqe->num_sge) {
-			wqe->sqe.num_sge = 1;
-			wqe->sqe.sge[0].length = irqe->sge[0].length;
-			wqe->sqe.sge[0].laddr = irqe->sge[0].laddr;
-			wqe->sqe.sge[0].lkey = irqe->sge[0].lkey;
-		} else {
-			wqe->sqe.num_sge = 0;
-		}
-
-		/* Retain original RREQ's message sequence number for
-		 * potential error reporting cases.
-		 */
-		wqe->sqe.sge[1].length = irqe->sge[1].length;
-
-		wqe->sqe.rkey = irqe->rkey;
-		wqe->sqe.raddr = irqe->raddr;
+	sqe = sq_get_next(qp);
+	if (!sqe)
+		return 0;
 
-		wqe->processed = 0;
-		qp->irq_get++;
+	memset(wqe->mem, 0, sizeof(*wqe->mem) * SIW_MAX_SGE);
+	wqe->wr_status = SIW_WR_QUEUED;
 
-		/* mark current IRQ entry free */
-		smp_store_mb(irqe->flags, 0);
+	/* First copy SQE to kernel private memory */
+	memcpy(&wqe->sqe, sqe, sizeof(*sqe));
 
+	if (wqe->sqe.opcode >= SIW_NUM_OPCODES) {
+		rv = -EINVAL;
 		goto out;
 	}
-	sqe = sq_get_next(qp);
-	if (sqe) {
-skip_irq:
-		memset(wqe->mem, 0, sizeof(*wqe->mem) * SIW_MAX_SGE);
-		wqe->wr_status = SIW_WR_QUEUED;
-
-		/* First copy SQE to kernel private memory */
-		memcpy(&wqe->sqe, sqe, sizeof(*sqe));
-
-		if (wqe->sqe.opcode >= SIW_NUM_OPCODES) {
+	if (wqe->sqe.flags & SIW_WQE_INLINE) {
+		if (wqe->sqe.opcode != SIW_OP_SEND &&
+		    wqe->sqe.opcode != SIW_OP_WRITE) {
 			rv = -EINVAL;
 			goto out;
 		}
-		if (wqe->sqe.flags & SIW_WQE_INLINE) {
-			if (wqe->sqe.opcode != SIW_OP_SEND &&
-			    wqe->sqe.opcode != SIW_OP_WRITE) {
-				rv = -EINVAL;
-				goto out;
-			}
-			if (wqe->sqe.sge[0].length > SIW_MAX_INLINE) {
-				rv = -EINVAL;
-				goto out;
-			}
-			wqe->sqe.sge[0].laddr = (uintptr_t)&wqe->sqe.sge[1];
-			wqe->sqe.sge[0].lkey = 0;
-			wqe->sqe.num_sge = 1;
+		if (wqe->sqe.sge[0].length > SIW_MAX_INLINE) {
+			rv = -EINVAL;
+			goto out;
 		}
-		if (wqe->sqe.flags & SIW_WQE_READ_FENCE) {
-			/* A READ cannot be fenced */
-			if (unlikely(wqe->sqe.opcode == SIW_OP_READ ||
-				     wqe->sqe.opcode ==
-					     SIW_OP_READ_LOCAL_INV)) {
-				siw_dbg_qp(qp, "cannot fence read\n");
-				rv = -EINVAL;
-				goto out;
-			}
-			spin_lock(&qp->orq_lock);
+		wqe->sqe.sge[0].laddr = (uintptr_t)&wqe->sqe.sge[1];
+		wqe->sqe.sge[0].lkey = 0;
+		wqe->sqe.num_sge = 1;
+	}
+	if (wqe->sqe.flags & SIW_WQE_READ_FENCE) {
+		/* A READ cannot be fenced */
+		if (unlikely(wqe->sqe.opcode == SIW_OP_READ ||
+			     wqe->sqe.opcode ==
+				     SIW_OP_READ_LOCAL_INV)) {
+			siw_dbg_qp(qp, "cannot fence read\n");
+			rv = -EINVAL;
+			goto out;
+		}
+		spin_lock(&qp->orq_lock);
 
-			if (!siw_orq_empty(qp)) {
-				qp->tx_ctx.orq_fence = 1;
-				rv = 0;
-			}
-			spin_unlock(&qp->orq_lock);
+		if (qp->attrs.orq_size && !siw_orq_empty(qp)) {
+			qp->tx_ctx.orq_fence = 1;
+			rv = 0;
+		}
+		spin_unlock(&qp->orq_lock);
 
-		} else if (wqe->sqe.opcode == SIW_OP_READ ||
-			   wqe->sqe.opcode == SIW_OP_READ_LOCAL_INV) {
-			struct siw_sqe *rreq;
+	} else if (wqe->sqe.opcode == SIW_OP_READ ||
+		   wqe->sqe.opcode == SIW_OP_READ_LOCAL_INV) {
+		struct siw_sqe *rreq;
 
-			wqe->sqe.num_sge = 1;
+		if (unlikely(!qp->attrs.orq_size)) {
+			/* We negotiated not to send READ req's */
+			rv = -EINVAL;
+			goto out;
+		}
+		wqe->sqe.num_sge = 1;
 
-			spin_lock(&qp->orq_lock);
+		spin_lock(&qp->orq_lock);
 
-			rreq = orq_get_free(qp);
-			if (rreq) {
-				/*
-				 * Make an immediate copy in ORQ to be ready
-				 * to process loopback READ reply
-				 */
-				siw_read_to_orq(rreq, &wqe->sqe);
-				qp->orq_put++;
-			} else {
-				qp->tx_ctx.orq_fence = 1;
-				rv = 0;
-			}
-			spin_unlock(&qp->orq_lock);
+		rreq = orq_get_free(qp);
+		if (rreq) {
+			/*
+			 * Make an immediate copy in ORQ to be ready
+			 * to process loopback READ reply
+			 */
+			siw_read_to_orq(rreq, &wqe->sqe);
+			qp->orq_put++;
+		} else {
+			qp->tx_ctx.orq_fence = 1;
+			rv = 0;
 		}
-
-		/* Clear SQE, can be re-used by application */
-		smp_store_mb(sqe->flags, 0);
-		qp->sq_get++;
-	} else {
-		rv = 0;
+		spin_unlock(&qp->orq_lock);
 	}
+
+	/* Clear SQE, can be re-used by application */
+	smp_store_mb(sqe->flags, 0);
+	qp->sq_get++;
 out:
 	if (unlikely(rv < 0)) {
 		siw_dbg_qp(qp, "error %d\n", rv);
@@ -1014,6 +968,65 @@ out:
 	return rv;
 }
 
+/*
+ * Must be called with SQ locked.
+ * To avoid complete SQ starvation by constant inbound READ requests,
+ * the active IRQ will not be served after qp->irq_burst, if the
+ * SQ has pending work.
+ */
+int siw_activate_tx(struct siw_qp *qp)
+{
+	struct siw_sqe *irqe;
+	struct siw_wqe *wqe = tx_wqe(qp);
+
+	if (!qp->attrs.irq_size)
+		return siw_activate_tx_from_sq(qp);
+
+	irqe = &qp->irq[qp->irq_get % qp->attrs.irq_size];
+
+	if (!(irqe->flags & SIW_WQE_VALID))
+		return siw_activate_tx_from_sq(qp);
+
+	/*
+	 * Avoid local WQE processing starvation in case
+	 * of constant inbound READ request stream
+	 */
+	if (sq_get_next(qp) && ++qp->irq_burst >= SIW_IRQ_MAXBURST_SQ_ACTIVE) {
+		qp->irq_burst = 0;
+		return siw_activate_tx_from_sq(qp);
+	}
+	memset(wqe->mem, 0, sizeof(*wqe->mem) * SIW_MAX_SGE);
+	wqe->wr_status = SIW_WR_QUEUED;
+
+	/* start READ RESPONSE */
+	wqe->sqe.opcode = SIW_OP_READ_RESPONSE;
+	wqe->sqe.flags = 0;
+	if (irqe->num_sge) {
+		wqe->sqe.num_sge = 1;
+		wqe->sqe.sge[0].length = irqe->sge[0].length;
+		wqe->sqe.sge[0].laddr = irqe->sge[0].laddr;
+		wqe->sqe.sge[0].lkey = irqe->sge[0].lkey;
+	} else {
+		wqe->sqe.num_sge = 0;
+	}
+
+	/* Retain original RREQ's message sequence number for
+	 * potential error reporting cases.
+	 */
+	wqe->sqe.sge[1].length = irqe->sge[1].length;
+
+	wqe->sqe.rkey = irqe->rkey;
+	wqe->sqe.raddr = irqe->raddr;
+
+	wqe->processed = 0;
+	qp->irq_get++;
+
+	/* mark current IRQ entry free */
+	smp_store_mb(irqe->flags, 0);
+
+	return 1;
+}
+
 /*
  * Check if current CQ state qualifies for calling CQ completion
  * handler. Must be called with CQ lock held.
diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 0520e70084f97..c7c38f7fd29d6 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -680,6 +680,10 @@ static int siw_init_rresp(struct siw_qp *qp, struct siw_rx_stream *srx)
 	}
 	spin_lock_irqsave(&qp->sq_lock, flags);
 
+	if (unlikely(!qp->attrs.irq_size)) {
+		run_sq = 0;
+		goto error_irq;
+	}
 	if (tx_work->wr_status == SIW_WR_IDLE) {
 		/*
 		 * immediately schedule READ response w/o
@@ -712,8 +716,9 @@ static int siw_init_rresp(struct siw_qp *qp, struct siw_rx_stream *srx)
 		/* RRESP now valid as current TX wqe or placed into IRQ */
 		smp_store_mb(resp->flags, SIW_WQE_VALID);
 	} else {
-		pr_warn("siw: [QP %u]: irq %d exceeded %d\n", qp_id(qp),
-			qp->irq_put % qp->attrs.irq_size, qp->attrs.irq_size);
+error_irq:
+		pr_warn("siw: [QP %u]: IRQ exceeded or null, size %d\n",
+			qp_id(qp), qp->attrs.irq_size);
 
 		siw_init_terminate(qp, TERM_ERROR_LAYER_RDMAP,
 				   RDMAP_ETYPE_REMOTE_OPERATION,
@@ -740,6 +745,9 @@ static int siw_orqe_start_rx(struct siw_qp *qp)
 	struct siw_sqe *orqe;
 	struct siw_wqe *wqe = NULL;
 
+	if (unlikely(!qp->attrs.orq_size))
+		return -EPROTO;
+
 	/* make sure ORQ indices are current */
 	smp_mb();
 
@@ -796,8 +804,8 @@ int siw_proc_rresp(struct siw_qp *qp)
 		 */
 		rv = siw_orqe_start_rx(qp);
 		if (rv) {
-			pr_warn("siw: [QP %u]: ORQ empty at idx %d\n",
-				qp_id(qp), qp->orq_get % qp->attrs.orq_size);
+			pr_warn("siw: [QP %u]: ORQ empty, size %d\n",
+				qp_id(qp), qp->attrs.orq_size);
 			goto error_term;
 		}
 		rv = siw_rresp_check_ntoh(srx, frx);
@@ -1290,11 +1298,13 @@ static int siw_rdmap_complete(struct siw_qp *qp, int error)
 					      wc_status);
 		siw_wqe_put_mem(wqe, SIW_OP_READ);
 
-		if (!error)
+		if (!error) {
 			rv = siw_check_tx_fence(qp);
-		else
-			/* Disable current ORQ eleement */
-			WRITE_ONCE(orq_get_current(qp)->flags, 0);
+		} else {
+			/* Disable current ORQ element */
+			if (qp->attrs.orq_size)
+				WRITE_ONCE(orq_get_current(qp)->flags, 0);
+		}
 		break;
 
 	case RDMAP_RDMA_READ_REQ:
diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index e7cd04eda04ac..424918eb1cd4a 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -1107,8 +1107,8 @@ next_wqe:
 		/*
 		 * RREQ may have already been completed by inbound RRESP!
 		 */
-		if (tx_type == SIW_OP_READ ||
-		    tx_type == SIW_OP_READ_LOCAL_INV) {
+		if ((tx_type == SIW_OP_READ ||
+		     tx_type == SIW_OP_READ_LOCAL_INV) && qp->attrs.orq_size) {
 			/* Cleanup pending entry in ORQ */
 			qp->orq_put--;
 			qp->orq[qp->orq_put % qp->attrs.orq_size].flags = 0;
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 1b1a40db529c6..2c3704f0f10fa 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -387,13 +387,23 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 	if (rv)
 		goto err_out;
 
+	num_sqe = attrs->cap.max_send_wr;
+	num_rqe = attrs->cap.max_recv_wr;
+
 	/* All queue indices are derived from modulo operations
 	 * on a free running 'get' (consumer) and 'put' (producer)
 	 * unsigned counter. Having queue sizes at power of two
 	 * avoids handling counter wrap around.
 	 */
-	num_sqe = roundup_pow_of_two(attrs->cap.max_send_wr);
-	num_rqe = roundup_pow_of_two(attrs->cap.max_recv_wr);
+	if (num_sqe)
+		num_sqe = roundup_pow_of_two(num_sqe);
+	else {
+		/* Zero sized SQ is not supported */
+		rv = -EINVAL;
+		goto err_out;
+	}
+	if (num_rqe)
+		num_rqe = roundup_pow_of_two(num_rqe);
 
 	if (qp->kernel_verbs)
 		qp->sendq = vzalloc(num_sqe * sizeof(struct siw_sqe));
@@ -401,7 +411,6 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 		qp->sendq = vmalloc_user(num_sqe * sizeof(struct siw_sqe));
 
 	if (qp->sendq == NULL) {
-		siw_dbg(base_dev, "SQ size %d alloc failed\n", num_sqe);
 		rv = -ENOMEM;
 		goto err_out_xa;
 	}
@@ -434,7 +443,6 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 				vmalloc_user(num_rqe * sizeof(struct siw_rqe));
 
 		if (qp->recvq == NULL) {
-			siw_dbg(base_dev, "RQ size %d alloc failed\n", num_rqe);
 			rv = -ENOMEM;
 			goto err_out_xa;
 		}
@@ -982,9 +990,9 @@ int siw_post_receive(struct ib_qp *base_qp, const struct ib_recv_wr *wr,
 	unsigned long flags;
 	int rv = 0;
 
-	if (qp->srq) {
+	if (qp->srq || qp->attrs.rq_size == 0) {
 		*bad_wr = wr;
-		return -EOPNOTSUPP; /* what else from errno.h? */
+		return -EINVAL;
 	}
 	if (!qp->kernel_verbs) {
 		siw_dbg_qp(qp, "no kernel post_recv for user mapped sq\n");
-- 
2.27.0



