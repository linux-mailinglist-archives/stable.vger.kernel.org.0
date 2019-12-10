Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C76119704
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLJVal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbfLJVJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D978246A2;
        Tue, 10 Dec 2019 21:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012183;
        bh=R8e3yrP1hmqiVMCiVknR+auHxGom3Sx/TlWBJrtWbJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah20RtvyVh+NChKKOqzsrGJ9OtxdexFwPBaMkGmxzgVjji8ZTFgGQQ63orBfGutVP
         2uMkU/fKbthnGnew6s4FWsUEI3uGVPYMsbaXcqzChFP1iaFU49cgnLbA1FMa4b3Gbx
         KjX73qB4XBNFV2EPJWw98pZoUzNCQzRub767SvDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernard Metzler <bmt@zurich.ibm.com>,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 140/350] RDMA/siw: Fix SQ/RQ drain logic
Date:   Tue, 10 Dec 2019 16:04:05 -0500
Message-Id: <20191210210735.9077-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit cf049bb31f7101d9672eaf97ade4fdd5171ddf26 ]

Storage ULPs (e.g. iSER & NVMeOF) use ib_drain_qp() to drain
QP/CQ. Current SIW's own drain routines do not properly wait until all
SQ/RQ elements are completed and reaped from the CQ. This may cause touch
after free issues.  New logic relies on generic
__ib_drain_sq()/__ib_drain_rq() posting a final work request, which SIW
immediately flushes to CQ.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Link: https://lore.kernel.org/r/20191004125356.20673-1-bmt@zurich.ibm.com
Signed-off-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c  |  20 ----
 drivers/infiniband/sw/siw/siw_verbs.c | 144 ++++++++++++++++++++++----
 2 files changed, 122 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 05a92f997f603..fb01407a310fa 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -248,24 +248,6 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
 	return NULL;
 }
 
-static void siw_verbs_sq_flush(struct ib_qp *base_qp)
-{
-	struct siw_qp *qp = to_siw_qp(base_qp);
-
-	down_write(&qp->state_lock);
-	siw_sq_flush(qp);
-	up_write(&qp->state_lock);
-}
-
-static void siw_verbs_rq_flush(struct ib_qp *base_qp)
-{
-	struct siw_qp *qp = to_siw_qp(base_qp);
-
-	down_write(&qp->state_lock);
-	siw_rq_flush(qp);
-	up_write(&qp->state_lock);
-}
-
 static const struct ib_device_ops siw_device_ops = {
 	.owner = THIS_MODULE,
 	.uverbs_abi_ver = SIW_ABI_VERSION,
@@ -284,8 +266,6 @@ static const struct ib_device_ops siw_device_ops = {
 	.destroy_cq = siw_destroy_cq,
 	.destroy_qp = siw_destroy_qp,
 	.destroy_srq = siw_destroy_srq,
-	.drain_rq = siw_verbs_rq_flush,
-	.drain_sq = siw_verbs_sq_flush,
 	.get_dma_mr = siw_get_dma_mr,
 	.get_port_immutable = siw_get_port_immutable,
 	.iw_accept = siw_accept,
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index b18a677832e10..7d0a7edc533d1 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -685,6 +685,47 @@ static int siw_copy_inline_sgl(const struct ib_send_wr *core_wr,
 	return bytes;
 }
 
+/* Complete SQ WR's without processing */
+static int siw_sq_flush_wr(struct siw_qp *qp, const struct ib_send_wr *wr,
+			   const struct ib_send_wr **bad_wr)
+{
+	struct siw_sqe sqe = {};
+	int rv = 0;
+
+	while (wr) {
+		sqe.id = wr->wr_id;
+		sqe.opcode = wr->opcode;
+		rv = siw_sqe_complete(qp, &sqe, 0, SIW_WC_WR_FLUSH_ERR);
+		if (rv) {
+			if (bad_wr)
+				*bad_wr = wr;
+			break;
+		}
+		wr = wr->next;
+	}
+	return rv;
+}
+
+/* Complete RQ WR's without processing */
+static int siw_rq_flush_wr(struct siw_qp *qp, const struct ib_recv_wr *wr,
+			   const struct ib_recv_wr **bad_wr)
+{
+	struct siw_rqe rqe = {};
+	int rv = 0;
+
+	while (wr) {
+		rqe.id = wr->wr_id;
+		rv = siw_rqe_complete(qp, &rqe, 0, 0, SIW_WC_WR_FLUSH_ERR);
+		if (rv) {
+			if (bad_wr)
+				*bad_wr = wr;
+			break;
+		}
+		wr = wr->next;
+	}
+	return rv;
+}
+
 /*
  * siw_post_send()
  *
@@ -703,26 +744,54 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 	unsigned long flags;
 	int rv = 0;
 
+	if (wr && !qp->kernel_verbs) {
+		siw_dbg_qp(qp, "wr must be empty for user mapped sq\n");
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
 	/*
 	 * Try to acquire QP state lock. Must be non-blocking
 	 * to accommodate kernel clients needs.
 	 */
 	if (!down_read_trylock(&qp->state_lock)) {
-		*bad_wr = wr;
-		siw_dbg_qp(qp, "QP locked, state %d\n", qp->attrs.state);
-		return -ENOTCONN;
+		if (qp->attrs.state == SIW_QP_STATE_ERROR) {
+			/*
+			 * ERROR state is final, so we can be sure
+			 * this state will not change as long as the QP
+			 * exists.
+			 *
+			 * This handles an ib_drain_sq() call with
+			 * a concurrent request to set the QP state
+			 * to ERROR.
+			 */
+			rv = siw_sq_flush_wr(qp, wr, bad_wr);
+		} else {
+			siw_dbg_qp(qp, "QP locked, state %d\n",
+				   qp->attrs.state);
+			*bad_wr = wr;
+			rv = -ENOTCONN;
+		}
+		return rv;
 	}
 	if (unlikely(qp->attrs.state != SIW_QP_STATE_RTS)) {
+		if (qp->attrs.state == SIW_QP_STATE_ERROR) {
+			/*
+			 * Immediately flush this WR to CQ, if QP
+			 * is in ERROR state. SQ is guaranteed to
+			 * be empty, so WR complets in-order.
+			 *
+			 * Typically triggered by ib_drain_sq().
+			 */
+			rv = siw_sq_flush_wr(qp, wr, bad_wr);
+		} else {
+			siw_dbg_qp(qp, "QP out of state %d\n",
+				   qp->attrs.state);
+			*bad_wr = wr;
+			rv = -ENOTCONN;
+		}
 		up_read(&qp->state_lock);
-		*bad_wr = wr;
-		siw_dbg_qp(qp, "QP out of state %d\n", qp->attrs.state);
-		return -ENOTCONN;
-	}
-	if (wr && !qp->kernel_verbs) {
-		siw_dbg_qp(qp, "wr must be empty for user mapped sq\n");
-		up_read(&qp->state_lock);
-		*bad_wr = wr;
-		return -EINVAL;
+		return rv;
 	}
 	spin_lock_irqsave(&qp->sq_lock, flags);
 
@@ -917,24 +986,55 @@ int siw_post_receive(struct ib_qp *base_qp, const struct ib_recv_wr *wr,
 		*bad_wr = wr;
 		return -EOPNOTSUPP; /* what else from errno.h? */
 	}
-	/*
-	 * Try to acquire QP state lock. Must be non-blocking
-	 * to accommodate kernel clients needs.
-	 */
-	if (!down_read_trylock(&qp->state_lock)) {
-		*bad_wr = wr;
-		return -ENOTCONN;
-	}
 	if (!qp->kernel_verbs) {
 		siw_dbg_qp(qp, "no kernel post_recv for user mapped sq\n");
 		up_read(&qp->state_lock);
 		*bad_wr = wr;
 		return -EINVAL;
 	}
+
+	/*
+	 * Try to acquire QP state lock. Must be non-blocking
+	 * to accommodate kernel clients needs.
+	 */
+	if (!down_read_trylock(&qp->state_lock)) {
+		if (qp->attrs.state == SIW_QP_STATE_ERROR) {
+			/*
+			 * ERROR state is final, so we can be sure
+			 * this state will not change as long as the QP
+			 * exists.
+			 *
+			 * This handles an ib_drain_rq() call with
+			 * a concurrent request to set the QP state
+			 * to ERROR.
+			 */
+			rv = siw_rq_flush_wr(qp, wr, bad_wr);
+		} else {
+			siw_dbg_qp(qp, "QP locked, state %d\n",
+				   qp->attrs.state);
+			*bad_wr = wr;
+			rv = -ENOTCONN;
+		}
+		return rv;
+	}
 	if (qp->attrs.state > SIW_QP_STATE_RTS) {
+		if (qp->attrs.state == SIW_QP_STATE_ERROR) {
+			/*
+			 * Immediately flush this WR to CQ, if QP
+			 * is in ERROR state. RQ is guaranteed to
+			 * be empty, so WR complets in-order.
+			 *
+			 * Typically triggered by ib_drain_rq().
+			 */
+			rv = siw_rq_flush_wr(qp, wr, bad_wr);
+		} else {
+			siw_dbg_qp(qp, "QP out of state %d\n",
+				   qp->attrs.state);
+			*bad_wr = wr;
+			rv = -ENOTCONN;
+		}
 		up_read(&qp->state_lock);
-		*bad_wr = wr;
-		return -EINVAL;
+		return rv;
 	}
 	/*
 	 * Serialize potentially multiple producers.
-- 
2.20.1

