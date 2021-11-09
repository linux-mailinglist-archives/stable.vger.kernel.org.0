Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41CA44B69D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343971AbhKIW27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344155AbhKIW1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:27:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03FA6619F8;
        Tue,  9 Nov 2021 22:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496401;
        bh=8U4Y1nre6BHpSU3mRKenxSkgHgL/CvhhoQ4ORo04szo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrsLkOLujGgLbbavyrWDUe2kiMaDqiqLu6weOAkSlTEDMLB7avFoa5tQ2M/w8y/5c
         1OFxcaE3YJ8cvhFFRCrOUm9qOYRbmiUAH7wWQB7ltCbTarTBeWWcJmhcmNaSabAcJI
         KL5L7TxNnJ3MdrNSkyQVswKXTDFKvAW/yFkNtIHnyCRdaJ5Y2XnyNTmO3QIVbc/JNC
         12/H+0/CftyXk4/adBPfLQaRjdIosQvPs0n80WxMK+8awEZCV6rw15PUJPe4b5XGHJ
         xcjK0x96AtMNAy9oExRk/uxk4O0KyyDDb3dwdFnCKZz4JZ5c4grj0g5BPqZswd0Lj9
         0HlgvdSMrjVKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, dledford@redhat.com,
        sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 32/75] RDMA/rxe: Separate HW and SW l/rkeys
Date:   Tue,  9 Nov 2021 17:18:22 -0500
Message-Id: <20211109221905.1234094-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 001345339f4ca85790a1644a74e33ae77ac116be ]

Separate software and simulated hardware lkeys and rkeys for MRs and MWs.
This makes struct ib_mr and struct ib_mw isolated from hardware changes
triggered by executing work requests.

This change fixes a bug seen in blktest.

Link: https://lore.kernel.org/r/20210914164206.19768-4-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h   |  1 +
 drivers/infiniband/sw/rxe/rxe_mr.c    | 69 ++++++++++++++++++++++-----
 drivers/infiniband/sw/rxe/rxe_mw.c    | 30 ++++++------
 drivers/infiniband/sw/rxe/rxe_req.c   | 14 ++----
 drivers/infiniband/sw/rxe/rxe_verbs.h | 18 ++-----
 5 files changed, 81 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 1ddb20855dee7..26e2b53505427 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -87,6 +87,7 @@ struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length);
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length);
 int rxe_invalidate_mr(struct rxe_qp *qp, u32 rkey);
+int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe);
 int rxe_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
 void rxe_mr_cleanup(struct rxe_pool_entry *arg);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index be4bcb420fab3..8a22df41d2864 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -48,8 +48,14 @@ static void rxe_mr_init(int access, struct rxe_mr *mr)
 	u32 lkey = mr->pelem.index << 8 | rxe_get_next_key(-1);
 	u32 rkey = (access & IB_ACCESS_REMOTE) ? lkey : 0;
 
-	mr->ibmr.lkey = lkey;
-	mr->ibmr.rkey = rkey;
+	/* set ibmr->l/rkey and also copy into private l/rkey
+	 * for user MRs these will always be the same
+	 * for cases where caller 'owns' the key portion
+	 * they may be different until REG_MR WQE is executed.
+	 */
+	mr->lkey = mr->ibmr.lkey = lkey;
+	mr->rkey = mr->ibmr.rkey = rkey;
+
 	mr->state = RXE_MR_STATE_INVALID;
 	mr->type = RXE_MR_TYPE_NONE;
 	mr->map_shift = ilog2(RXE_BUF_PER_MAP);
@@ -192,10 +198,8 @@ int rxe_mr_init_fast(struct rxe_pd *pd, int max_pages, struct rxe_mr *mr)
 {
 	int err;
 
-	rxe_mr_init(0, mr);
-
-	/* In fastreg, we also set the rkey */
-	mr->ibmr.rkey = mr->ibmr.lkey;
+	/* always allow remote access for FMRs */
+	rxe_mr_init(IB_ACCESS_REMOTE, mr);
 
 	err = rxe_mr_alloc(mr, max_pages);
 	if (err)
@@ -522,8 +526,8 @@ struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 	if (!mr)
 		return NULL;
 
-	if (unlikely((type == RXE_LOOKUP_LOCAL && mr_lkey(mr) != key) ||
-		     (type == RXE_LOOKUP_REMOTE && mr_rkey(mr) != key) ||
+	if (unlikely((type == RXE_LOOKUP_LOCAL && mr->lkey != key) ||
+		     (type == RXE_LOOKUP_REMOTE && mr->rkey != key) ||
 		     mr_pd(mr) != pd || (access && !(access & mr->access)) ||
 		     mr->state != RXE_MR_STATE_VALID)) {
 		rxe_drop_ref(mr);
@@ -546,9 +550,9 @@ int rxe_invalidate_mr(struct rxe_qp *qp, u32 rkey)
 		goto err;
 	}
 
-	if (rkey != mr->ibmr.rkey) {
-		pr_err("%s: rkey (%#x) doesn't match mr->ibmr.rkey (%#x)\n",
-			__func__, rkey, mr->ibmr.rkey);
+	if (rkey != mr->rkey) {
+		pr_err("%s: rkey (%#x) doesn't match mr->rkey (%#x)\n",
+			__func__, rkey, mr->rkey);
 		ret = -EINVAL;
 		goto err_drop_ref;
 	}
@@ -569,6 +573,49 @@ err:
 	return ret;
 }
 
+/* user can (re)register fast MR by executing a REG_MR WQE.
+ * user is expected to hold a reference on the ib mr until the
+ * WQE completes.
+ * Once a fast MR is created this is the only way to change the
+ * private keys. It is the responsibility of the user to maintain
+ * the ib mr keys in sync with rxe mr keys.
+ */
+int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
+{
+	struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
+	u32 key = wqe->wr.wr.reg.key;
+	u32 access = wqe->wr.wr.reg.access;
+
+	/* user can only register MR in free state */
+	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
+		pr_warn("%s: mr->lkey = 0x%x not free\n",
+			__func__, mr->lkey);
+		return -EINVAL;
+	}
+
+	/* user can only register mr with qp in same protection domain */
+	if (unlikely(qp->ibqp.pd != mr->ibmr.pd)) {
+		pr_warn("%s: qp->pd and mr->pd don't match\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	/* user is only allowed to change key portion of l/rkey */
+	if (unlikely((mr->lkey & ~0xff) != (key & ~0xff))) {
+		pr_warn("%s: key = 0x%x has wrong index mr->lkey = 0x%x\n",
+			__func__, key, mr->lkey);
+		return -EINVAL;
+	}
+
+	mr->access = access;
+	mr->lkey = key;
+	mr->rkey = (access & IB_ACCESS_REMOTE) ? key : 0;
+	mr->iova = wqe->wr.wr.reg.mr->iova;
+	mr->state = RXE_MR_STATE_VALID;
+
+	return 0;
+}
+
 int rxe_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 {
 	struct rxe_mr *mr = to_rmr(ibmr);
diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 5ba77df7598ed..a5e2ea7d80f02 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -21,7 +21,7 @@ int rxe_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	}
 
 	rxe_add_index(mw);
-	ibmw->rkey = (mw->pelem.index << 8) | rxe_get_next_key(-1);
+	mw->rkey = ibmw->rkey = (mw->pelem.index << 8) | rxe_get_next_key(-1);
 	mw->state = (mw->ibmw.type == IB_MW_TYPE_2) ?
 			RXE_MW_STATE_FREE : RXE_MW_STATE_VALID;
 	spin_lock_init(&mw->lock);
@@ -71,6 +71,8 @@ int rxe_dealloc_mw(struct ib_mw *ibmw)
 static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 			 struct rxe_mw *mw, struct rxe_mr *mr)
 {
+	u32 key = wqe->wr.wr.mw.rkey & 0xff;
+
 	if (mw->ibmw.type == IB_MW_TYPE_1) {
 		if (unlikely(mw->state != RXE_MW_STATE_VALID)) {
 			pr_err_once(
@@ -108,7 +110,7 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		}
 	}
 
-	if (unlikely((wqe->wr.wr.mw.rkey & 0xff) == (mw->ibmw.rkey & 0xff))) {
+	if (unlikely(key == (mw->rkey & 0xff))) {
 		pr_err_once("attempt to bind MW with same key\n");
 		return -EINVAL;
 	}
@@ -161,13 +163,9 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 static void rxe_do_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		      struct rxe_mw *mw, struct rxe_mr *mr)
 {
-	u32 rkey;
-	u32 new_rkey;
-
-	rkey = mw->ibmw.rkey;
-	new_rkey = (rkey & 0xffffff00) | (wqe->wr.wr.mw.rkey & 0x000000ff);
+	u32 key = wqe->wr.wr.mw.rkey & 0xff;
 
-	mw->ibmw.rkey = new_rkey;
+	mw->rkey = (mw->rkey & ~0xff) | key;
 	mw->access = wqe->wr.wr.mw.access;
 	mw->state = RXE_MW_STATE_VALID;
 	mw->addr = wqe->wr.wr.mw.addr;
@@ -197,29 +195,29 @@ int rxe_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	struct rxe_mw *mw;
 	struct rxe_mr *mr;
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+	u32 mw_rkey = wqe->wr.wr.mw.mw_rkey;
+	u32 mr_lkey = wqe->wr.wr.mw.mr_lkey;
 	unsigned long flags;
 
-	mw = rxe_pool_get_index(&rxe->mw_pool,
-				wqe->wr.wr.mw.mw_rkey >> 8);
+	mw = rxe_pool_get_index(&rxe->mw_pool, mw_rkey >> 8);
 	if (unlikely(!mw)) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	if (unlikely(mw->ibmw.rkey != wqe->wr.wr.mw.mw_rkey)) {
+	if (unlikely(mw->rkey != mw_rkey)) {
 		ret = -EINVAL;
 		goto err_drop_mw;
 	}
 
 	if (likely(wqe->wr.wr.mw.length)) {
-		mr = rxe_pool_get_index(&rxe->mr_pool,
-					wqe->wr.wr.mw.mr_lkey >> 8);
+		mr = rxe_pool_get_index(&rxe->mr_pool, mr_lkey >> 8);
 		if (unlikely(!mr)) {
 			ret = -EINVAL;
 			goto err_drop_mw;
 		}
 
-		if (unlikely(mr->ibmr.lkey != wqe->wr.wr.mw.mr_lkey)) {
+		if (unlikely(mr->lkey != mr_lkey)) {
 			ret = -EINVAL;
 			goto err_drop_mr;
 		}
@@ -292,7 +290,7 @@ int rxe_invalidate_mw(struct rxe_qp *qp, u32 rkey)
 		goto err;
 	}
 
-	if (rkey != mw->ibmw.rkey) {
+	if (rkey != mw->rkey) {
 		ret = -EINVAL;
 		goto err_drop_ref;
 	}
@@ -323,7 +321,7 @@ struct rxe_mw *rxe_lookup_mw(struct rxe_qp *qp, int access, u32 rkey)
 	if (!mw)
 		return NULL;
 
-	if (unlikely((rxe_mw_rkey(mw) != rkey) || rxe_mw_pd(mw) != pd ||
+	if (unlikely((mw->rkey != rkey) || rxe_mw_pd(mw) != pd ||
 		     (mw->ibmw.type == IB_MW_TYPE_2 && mw->qp != qp) ||
 		     (mw->length == 0) ||
 		     (access && !(access & mw->access)) ||
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index c57699cc6578d..b4d3a11bee542 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -581,7 +581,6 @@ static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 {
 	u8 opcode = wqe->wr.opcode;
-	struct rxe_mr *mr;
 	u32 rkey;
 	int ret;
 
@@ -599,14 +598,11 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 		}
 		break;
 	case IB_WR_REG_MR:
-		mr = to_rmr(wqe->wr.wr.reg.mr);
-		rxe_add_ref(mr);
-		mr->state = RXE_MR_STATE_VALID;
-		mr->access = wqe->wr.wr.reg.access;
-		mr->ibmr.lkey = wqe->wr.wr.reg.key;
-		mr->ibmr.rkey = wqe->wr.wr.reg.key;
-		mr->iova = wqe->wr.wr.reg.mr->iova;
-		rxe_drop_ref(mr);
+		ret = rxe_reg_fast_mr(qp, wqe);
+		if (unlikely(ret)) {
+			wqe->status = IB_WC_LOC_QP_OP_ERR;
+			return ret;
+		}
 		break;
 	case IB_WR_BIND_MW:
 		ret = rxe_bind_mw(qp, wqe);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 959a3260fcab7..703b5ade0f279 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -313,6 +313,8 @@ struct rxe_mr {
 
 	struct ib_umem		*umem;
 
+	u32			lkey;
+	u32			rkey;
 	enum rxe_mr_state	state;
 	enum rxe_mr_type	type;
 	u64			va;
@@ -350,6 +352,7 @@ struct rxe_mw {
 	enum rxe_mw_state	state;
 	struct rxe_qp		*qp; /* Type 2 only */
 	struct rxe_mr		*mr;
+	u32			rkey;
 	int			access;
 	u64			addr;
 	u64			length;
@@ -474,26 +477,11 @@ static inline struct rxe_pd *mr_pd(struct rxe_mr *mr)
 	return to_rpd(mr->ibmr.pd);
 }
 
-static inline u32 mr_lkey(struct rxe_mr *mr)
-{
-	return mr->ibmr.lkey;
-}
-
-static inline u32 mr_rkey(struct rxe_mr *mr)
-{
-	return mr->ibmr.rkey;
-}
-
 static inline struct rxe_pd *rxe_mw_pd(struct rxe_mw *mw)
 {
 	return to_rpd(mw->ibmw.pd);
 }
 
-static inline u32 rxe_mw_rkey(struct rxe_mw *mw)
-{
-	return mw->ibmw.rkey;
-}
-
 int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name);
 
 void rxe_mc_cleanup(struct rxe_pool_entry *arg);
-- 
2.33.0

