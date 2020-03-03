Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BC1177F69
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbgCCRuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731910AbgCCRu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21A621556;
        Tue,  3 Mar 2020 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257828;
        bh=C9k+6l4WlT2v3x5fEpWbnnNPWm1W50vZKs5iIi13810=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUo8ve6FKJOeTOkM1kIhQPVy9/uuTw/2VuNmXcX2UMF/FnT0jagl3WREThB5dzEh9
         t31MZ+JOpz1/2orkBYqhUYlMu6qh9jew9oZp+3tgVPySsdQn++ewnQRIzEUY8arvVe
         zIn29WogfWa9235Rcx0AfuNXp8QNC1o9vGWTp36w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixian Liu <liuyixian@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 145/176] RDMA/hns: Simplify the calculation and usage of wqe idx for post verbs
Date:   Tue,  3 Mar 2020 18:43:29 +0100
Message-Id: <20200303174321.519703793@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

commit 4768820243d71d49f1044b3f911ac3d52bdb79af upstream.

Currently, the wqe idx is calculated repeatly everywhere it is used.  This
patch defines wqe_idx and calculated it only once, then just use it as
needed.

Fixes: 2d40788825ac ("RDMA/hns: Add support for processing send wr and receive wr")
Link: https://lore.kernel.org/r/1575981902-5274-1-git-send-email-liweihang@hisilicon.com
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hns/hns_roce_device.h |    3 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   37 ++++++++++--------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |   43 +++++++++++-----------------
 3 files changed, 35 insertions(+), 48 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -423,7 +423,7 @@ struct hns_roce_mr_table {
 struct hns_roce_wq {
 	u64		*wrid;     /* Work request ID */
 	spinlock_t	lock;
-	int		wqe_cnt;  /* WQE num */
+	u32		wqe_cnt;  /* WQE num */
 	int		max_gs;
 	int		offset;
 	int		wqe_shift;	/* WQE size */
@@ -647,7 +647,6 @@ struct hns_roce_qp {
 	u8			sdb_en;
 	u32			doorbell_qpn;
 	u32			sq_signal_bits;
-	u32			sq_next_wqe;
 	struct hns_roce_wq	sq;
 
 	struct ib_umem		*umem;
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -74,8 +74,8 @@ static int hns_roce_v1_post_send(struct
 	unsigned long flags = 0;
 	void *wqe = NULL;
 	__le32 doorbell[2];
+	u32 wqe_idx = 0;
 	int nreq = 0;
-	u32 ind = 0;
 	int ret = 0;
 	u8 *smac;
 	int loopback;
@@ -88,7 +88,7 @@ static int hns_roce_v1_post_send(struct
 	}
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
-	ind = qp->sq_next_wqe;
+
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (hns_roce_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq)) {
 			ret = -ENOMEM;
@@ -96,6 +96,8 @@ static int hns_roce_v1_post_send(struct
 			goto out;
 		}
 
+		wqe_idx = (qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1);
+
 		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
 			dev_err(dev, "num_sge=%d > qp->sq.max_gs=%d\n",
 				wr->num_sge, qp->sq.max_gs);
@@ -104,9 +106,8 @@ static int hns_roce_v1_post_send(struct
 			goto out;
 		}
 
-		wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
-		qp->sq.wrid[(qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1)] =
-								      wr->wr_id;
+		wqe = get_send_wqe(qp, wqe_idx);
+		qp->sq.wrid[wqe_idx] = wr->wr_id;
 
 		/* Corresponding to the RC and RD type wqe process separately */
 		if (ibqp->qp_type == IB_QPT_GSI) {
@@ -210,7 +211,6 @@ static int hns_roce_v1_post_send(struct
 				       cpu_to_le32((wr->sg_list[1].addr) >> 32);
 			ud_sq_wqe->l_key1 =
 				       cpu_to_le32(wr->sg_list[1].lkey);
-			ind++;
 		} else if (ibqp->qp_type == IB_QPT_RC) {
 			u32 tmp_len = 0;
 
@@ -308,7 +308,6 @@ static int hns_roce_v1_post_send(struct
 				ctrl->flag |= cpu_to_le32(wr->num_sge <<
 					      HNS_ROCE_WQE_SGE_NUM_BIT);
 			}
-			ind++;
 		}
 	}
 
@@ -336,7 +335,6 @@ out:
 		doorbell[1] = sq_db.u32_8;
 
 		hns_roce_write64_k(doorbell, qp->sq.db_reg_l);
-		qp->sq_next_wqe = ind;
 	}
 
 	spin_unlock_irqrestore(&qp->sq.lock, flags);
@@ -348,12 +346,6 @@ static int hns_roce_v1_post_recv(struct
 				 const struct ib_recv_wr *wr,
 				 const struct ib_recv_wr **bad_wr)
 {
-	int ret = 0;
-	int nreq = 0;
-	int ind = 0;
-	int i = 0;
-	u32 reg_val;
-	unsigned long flags = 0;
 	struct hns_roce_rq_wqe_ctrl *ctrl = NULL;
 	struct hns_roce_wqe_data_seg *scat = NULL;
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
@@ -361,9 +353,14 @@ static int hns_roce_v1_post_recv(struct
 	struct device *dev = &hr_dev->pdev->dev;
 	struct hns_roce_rq_db rq_db;
 	__le32 doorbell[2] = {0};
+	unsigned long flags = 0;
+	unsigned int wqe_idx;
+	int ret = 0;
+	int nreq = 0;
+	int i = 0;
+	u32 reg_val;
 
 	spin_lock_irqsave(&hr_qp->rq.lock, flags);
-	ind = hr_qp->rq.head & (hr_qp->rq.wqe_cnt - 1);
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (hns_roce_wq_overflow(&hr_qp->rq, nreq,
@@ -373,6 +370,8 @@ static int hns_roce_v1_post_recv(struct
 			goto out;
 		}
 
+		wqe_idx = (hr_qp->rq.head + nreq) & (hr_qp->rq.wqe_cnt - 1);
+
 		if (unlikely(wr->num_sge > hr_qp->rq.max_gs)) {
 			dev_err(dev, "rq:num_sge=%d > qp->sq.max_gs=%d\n",
 				wr->num_sge, hr_qp->rq.max_gs);
@@ -381,7 +380,7 @@ static int hns_roce_v1_post_recv(struct
 			goto out;
 		}
 
-		ctrl = get_recv_wqe(hr_qp, ind);
+		ctrl = get_recv_wqe(hr_qp, wqe_idx);
 
 		roce_set_field(ctrl->rwqe_byte_12,
 			       RQ_WQE_CTRL_RWQE_BYTE_12_RWQE_SGE_NUM_M,
@@ -393,9 +392,7 @@ static int hns_roce_v1_post_recv(struct
 		for (i = 0; i < wr->num_sge; i++)
 			set_data_seg(scat + i, wr->sg_list + i);
 
-		hr_qp->rq.wrid[ind] = wr->wr_id;
-
-		ind = (ind + 1) & (hr_qp->rq.wqe_cnt - 1);
+		hr_qp->rq.wrid[wqe_idx] = wr->wr_id;
 	}
 
 out:
@@ -2701,7 +2698,6 @@ static int hns_roce_v1_m_sqp(struct ib_q
 		hr_qp->rq.tail = 0;
 		hr_qp->sq.head = 0;
 		hr_qp->sq.tail = 0;
-		hr_qp->sq_next_wqe = 0;
 	}
 
 	kfree(context);
@@ -3315,7 +3311,6 @@ static int hns_roce_v1_m_qp(struct ib_qp
 		hr_qp->rq.tail = 0;
 		hr_qp->sq.head = 0;
 		hr_qp->sq.tail = 0;
-		hr_qp->sq_next_wqe = 0;
 	}
 out:
 	kfree(context);
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -239,10 +239,10 @@ static int hns_roce_v2_post_send(struct
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_v2_db sq_db;
 	struct ib_qp_attr attr;
-	unsigned int sge_ind;
 	unsigned int owner_bit;
+	unsigned int sge_idx;
+	unsigned int wqe_idx;
 	unsigned long flags;
-	unsigned int ind;
 	void *wqe = NULL;
 	bool loopback;
 	int attr_mask;
@@ -269,8 +269,7 @@ static int hns_roce_v2_post_send(struct
 	}
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
-	ind = qp->sq_next_wqe;
-	sge_ind = qp->next_sge;
+	sge_idx = qp->next_sge;
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (hns_roce_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq)) {
@@ -279,6 +278,8 @@ static int hns_roce_v2_post_send(struct
 			goto out;
 		}
 
+		wqe_idx = (qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1);
+
 		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
 			dev_err(dev, "num_sge=%d > qp->sq.max_gs=%d\n",
 				wr->num_sge, qp->sq.max_gs);
@@ -287,10 +288,8 @@ static int hns_roce_v2_post_send(struct
 			goto out;
 		}
 
-		wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
-		qp->sq.wrid[(qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1)] =
-								      wr->wr_id;
-
+		wqe = get_send_wqe(qp, wqe_idx);
+		qp->sq.wrid[wqe_idx] = wr->wr_id;
 		owner_bit =
 		       ~(((qp->sq.head + nreq) >> ilog2(qp->sq.wqe_cnt)) & 0x1);
 		tmp_len = 0;
@@ -373,7 +372,7 @@ static int hns_roce_v2_post_send(struct
 			roce_set_field(ud_sq_wqe->byte_20,
 				     V2_UD_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_M,
 				     V2_UD_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_S,
-				     sge_ind & (qp->sge.sge_cnt - 1));
+				     sge_idx & (qp->sge.sge_cnt - 1));
 
 			roce_set_field(ud_sq_wqe->byte_24,
 				       V2_UD_SEND_WQE_BYTE_24_UDPSPN_M,
@@ -423,8 +422,7 @@ static int hns_roce_v2_post_send(struct
 			memcpy(&ud_sq_wqe->dgid[0], &ah->av.dgid[0],
 			       GID_LEN_V2);
 
-			set_extend_sge(qp, wr, &sge_ind);
-			ind++;
+			set_extend_sge(qp, wr, &sge_idx);
 		} else if (ibqp->qp_type == IB_QPT_RC) {
 			rc_sq_wqe = wqe;
 			memset(rc_sq_wqe, 0, sizeof(*rc_sq_wqe));
@@ -553,12 +551,10 @@ static int hns_roce_v2_post_send(struct
 					       wr->num_sge);
 			} else if (wr->opcode != IB_WR_REG_MR) {
 				ret = set_rwqe_data_seg(ibqp, wr, rc_sq_wqe,
-							wqe, &sge_ind, bad_wr);
+							wqe, &sge_idx, bad_wr);
 				if (ret)
 					goto out;
 			}
-
-			ind++;
 		} else {
 			dev_err(dev, "Illegal qp_type(0x%x)\n", ibqp->qp_type);
 			spin_unlock_irqrestore(&qp->sq.lock, flags);
@@ -588,8 +584,7 @@ out:
 
 		hns_roce_write64(hr_dev, (__le32 *)&sq_db, qp->sq.db_reg_l);
 
-		qp->sq_next_wqe = ind;
-		qp->next_sge = sge_ind;
+		qp->next_sge = sge_idx;
 
 		if (qp->state == IB_QPS_ERR) {
 			attr_mask = IB_QP_STATE;
@@ -623,13 +618,12 @@ static int hns_roce_v2_post_recv(struct
 	unsigned long flags;
 	void *wqe = NULL;
 	int attr_mask;
+	u32 wqe_idx;
 	int ret = 0;
 	int nreq;
-	int ind;
 	int i;
 
 	spin_lock_irqsave(&hr_qp->rq.lock, flags);
-	ind = hr_qp->rq.head & (hr_qp->rq.wqe_cnt - 1);
 
 	if (hr_qp->state == IB_QPS_RESET) {
 		spin_unlock_irqrestore(&hr_qp->rq.lock, flags);
@@ -645,6 +639,8 @@ static int hns_roce_v2_post_recv(struct
 			goto out;
 		}
 
+		wqe_idx = (hr_qp->rq.head + nreq) & (hr_qp->rq.wqe_cnt - 1);
+
 		if (unlikely(wr->num_sge > hr_qp->rq.max_gs)) {
 			dev_err(dev, "rq:num_sge=%d > qp->sq.max_gs=%d\n",
 				wr->num_sge, hr_qp->rq.max_gs);
@@ -653,7 +649,7 @@ static int hns_roce_v2_post_recv(struct
 			goto out;
 		}
 
-		wqe = get_recv_wqe(hr_qp, ind);
+		wqe = get_recv_wqe(hr_qp, wqe_idx);
 		dseg = (struct hns_roce_v2_wqe_data_seg *)wqe;
 		for (i = 0; i < wr->num_sge; i++) {
 			if (!wr->sg_list[i].length)
@@ -669,8 +665,8 @@ static int hns_roce_v2_post_recv(struct
 
 		/* rq support inline data */
 		if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) {
-			sge_list = hr_qp->rq_inl_buf.wqe_list[ind].sg_list;
-			hr_qp->rq_inl_buf.wqe_list[ind].sge_cnt =
+			sge_list = hr_qp->rq_inl_buf.wqe_list[wqe_idx].sg_list;
+			hr_qp->rq_inl_buf.wqe_list[wqe_idx].sge_cnt =
 							       (u32)wr->num_sge;
 			for (i = 0; i < wr->num_sge; i++) {
 				sge_list[i].addr =
@@ -679,9 +675,7 @@ static int hns_roce_v2_post_recv(struct
 			}
 		}
 
-		hr_qp->rq.wrid[ind] = wr->wr_id;
-
-		ind = (ind + 1) & (hr_qp->rq.wqe_cnt - 1);
+		hr_qp->rq.wrid[wqe_idx] = wr->wr_id;
 	}
 
 out:
@@ -4464,7 +4458,6 @@ static int hns_roce_v2_modify_qp(struct
 		hr_qp->rq.tail = 0;
 		hr_qp->sq.head = 0;
 		hr_qp->sq.tail = 0;
-		hr_qp->sq_next_wqe = 0;
 		hr_qp->next_sge = 0;
 		if (hr_qp->rq.wqe_cnt)
 			*hr_qp->rdb.db_record = 0;


