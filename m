Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B7F1A5AF6
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgDKXpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgDKXFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66A4C20787;
        Sat, 11 Apr 2020 23:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646331;
        bh=FtyPbzzNxvM6RHxiwcwiiPXfTO+DlAGk+a370DGggq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVZ5AQ2nnYtiyFDM9JDjw2TKG3b2JKL5bOR68bJswlg9TtsbVjoDcfXN7GACCbV/P
         LcB/VUVHmjrPlfOcpEtnoGF44vQWachEA2Ywr828yKE2dSPd21py2DkSjDmtJzcTje
         ZG2TkYPR6g7q3+RgkH0CVEWOVsSTopjkGNPomY7Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yixian Liu <liuyixian@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 083/149] RDMA/hns: Delayed flush cqe process with workqueue
Date:   Sat, 11 Apr 2020 19:02:40 -0400
Message-Id: <20200411230347.22371-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

[ Upstream commit b53742865e9f09cbba4d9daa161760ec23f36aa4 ]

HiP08 RoCE hardware lacks ability(a known hardware problem) to flush
outstanding WQEs if QP state gets into errored mode for some reason.  To
overcome this hardware problem and as a workaround, when QP is detected to
be in errored state during various legs like post send, post receive
etc[1], flush needs to be performed from the driver.

The earlier patch[1] sent to solve the hardware limitation explained in
the cover-letter had a bug in the software flushing leg. It acquired mutex
while modifying QP state to errored state and while conveying it to the
hardware using the mailbox. This caused leg to sleep while holding
spin-lock and caused crash.

Suggested Solution: we have proposed to defer the flushing of the QP in
the Errored state using the workqueue to get around with the limitation of
our hardware.

This patch specifically adds the calls to the flush handler from where
parts of the code like post_send/post_recv etc. when the QP state gets
into the errored mode.

[1] https://patchwork.kernel.org/patch/10534271/

Link: https://lore.kernel.org/r/1580983005-13899-3-git-send-email-liuyixian@huawei.com
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Reviewed-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  6 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 99 +++++++++++----------
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 11 ++-
 3 files changed, 66 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index a089d47354391..96d7bfa2dd8c8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -641,6 +641,10 @@ struct hns_roce_rinl_buf {
 	u32			 wqe_cnt;
 };
 
+enum {
+	HNS_ROCE_FLUSH_FLAG = 0,
+};
+
 struct hns_roce_work {
 	struct hns_roce_dev *hr_dev;
 	struct work_struct work;
@@ -693,6 +697,8 @@ struct hns_roce_qp {
 	struct hns_roce_sge	sge;
 	u32			next_sge;
 
+	/* 0: flush needed, 1: unneeded */
+	unsigned long		flush_flag;
 	struct hns_roce_work	flush_work;
 	struct hns_roce_rinl_buf rq_inl_buf;
 	struct list_head	node;		/* all qps are on a list */
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 950c604a6fcb4..d33d9ebe628df 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -220,11 +220,6 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	return 0;
 }
 
-static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
-				 const struct ib_qp_attr *attr,
-				 int attr_mask, enum ib_qp_state cur_state,
-				 enum ib_qp_state new_state);
-
 static int check_send_valid(struct hns_roce_dev *hr_dev,
 			    struct hns_roce_qp *hr_qp)
 {
@@ -261,7 +256,6 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 	struct hns_roce_wqe_frmr_seg *fseg;
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_v2_db sq_db;
-	struct ib_qp_attr attr;
 	unsigned int owner_bit;
 	unsigned int sge_idx;
 	unsigned int wqe_idx;
@@ -269,7 +263,6 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 	int valid_num_sge;
 	void *wqe = NULL;
 	bool loopback;
-	int attr_mask;
 	u32 tmp_len;
 	u32 hr_op;
 	u8 *smac;
@@ -607,18 +600,19 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 
 		qp->next_sge = sge_idx;
 
-		if (qp->state == IB_QPS_ERR) {
-			attr_mask = IB_QP_STATE;
-			attr.qp_state = IB_QPS_ERR;
-
-			ret = hns_roce_v2_modify_qp(&qp->ibqp, &attr, attr_mask,
-						    qp->state, IB_QPS_ERR);
-			if (ret) {
-				spin_unlock_irqrestore(&qp->sq.lock, flags);
-				*bad_wr = wr;
-				return ret;
-			}
-		}
+		/*
+		 * Hip08 hardware cannot flush the WQEs in SQ if the QP state
+		 * gets into errored mode. Hence, as a workaround to this
+		 * hardware limitation, driver needs to assist in flushing. But
+		 * the flushing operation uses mailbox to convey the QP state to
+		 * the hardware and which can sleep due to the mutex protection
+		 * around the mailbox calls. Hence, use the deferred flush for
+		 * now.
+		 */
+		if (qp->state == IB_QPS_ERR)
+			if (!test_and_set_bit(HNS_ROCE_FLUSH_FLAG,
+					      &qp->flush_flag))
+				init_flush_work(hr_dev, qp);
 	}
 
 	spin_unlock_irqrestore(&qp->sq.lock, flags);
@@ -646,10 +640,8 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 	struct hns_roce_v2_wqe_data_seg *dseg;
 	struct hns_roce_rinl_sge *sge_list;
 	struct device *dev = hr_dev->dev;
-	struct ib_qp_attr attr;
 	unsigned long flags;
 	void *wqe = NULL;
-	int attr_mask;
 	u32 wqe_idx;
 	int nreq;
 	int ret;
@@ -719,19 +711,19 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 
 		*hr_qp->rdb.db_record = hr_qp->rq.head & 0xffff;
 
-		if (hr_qp->state == IB_QPS_ERR) {
-			attr_mask = IB_QP_STATE;
-			attr.qp_state = IB_QPS_ERR;
-
-			ret = hns_roce_v2_modify_qp(&hr_qp->ibqp, &attr,
-						    attr_mask, hr_qp->state,
-						    IB_QPS_ERR);
-			if (ret) {
-				spin_unlock_irqrestore(&hr_qp->rq.lock, flags);
-				*bad_wr = wr;
-				return ret;
-			}
-		}
+		/*
+		 * Hip08 hardware cannot flush the WQEs in RQ if the QP state
+		 * gets into errored mode. Hence, as a workaround to this
+		 * hardware limitation, driver needs to assist in flushing. But
+		 * the flushing operation uses mailbox to convey the QP state to
+		 * the hardware and which can sleep due to the mutex protection
+		 * around the mailbox calls. Hence, use the deferred flush for
+		 * now.
+		 */
+		if (hr_qp->state == IB_QPS_ERR)
+			if (!test_and_set_bit(HNS_ROCE_FLUSH_FLAG,
+					      &hr_qp->flush_flag))
+				init_flush_work(hr_dev, hr_qp);
 	}
 	spin_unlock_irqrestore(&hr_qp->rq.lock, flags);
 
@@ -3013,13 +3005,11 @@ static int hns_roce_v2_sw_poll_cq(struct hns_roce_cq *hr_cq, int num_entries,
 static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 				struct hns_roce_qp **cur_qp, struct ib_wc *wc)
 {
+	struct hns_roce_dev *hr_dev = to_hr_dev(hr_cq->ib_cq.device);
 	struct hns_roce_srq *srq = NULL;
-	struct hns_roce_dev *hr_dev;
 	struct hns_roce_v2_cqe *cqe;
 	struct hns_roce_qp *hr_qp;
 	struct hns_roce_wq *wq;
-	struct ib_qp_attr attr;
-	int attr_mask;
 	int is_send;
 	u16 wqe_ctr;
 	u32 opcode;
@@ -3043,7 +3033,6 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 				V2_CQE_BYTE_16_LCL_QPN_S);
 
 	if (!*cur_qp || (qpn & HNS_ROCE_V2_CQE_QPN_MASK) != (*cur_qp)->qpn) {
-		hr_dev = to_hr_dev(hr_cq->ib_cq.device);
 		hr_qp = __hns_roce_qp_lookup(hr_dev, qpn);
 		if (unlikely(!hr_qp)) {
 			dev_err(hr_dev->dev, "CQ %06lx with entry for unknown QPN %06x\n",
@@ -3053,6 +3042,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 		*cur_qp = hr_qp;
 	}
 
+	hr_qp = *cur_qp;
 	wc->qp = &(*cur_qp)->ibqp;
 	wc->vendor_err = 0;
 
@@ -3137,14 +3127,24 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 		break;
 	}
 
-	/* flush cqe if wc status is error, excluding flush error */
-	if ((wc->status != IB_WC_SUCCESS) &&
-	    (wc->status != IB_WC_WR_FLUSH_ERR)) {
-		attr_mask = IB_QP_STATE;
-		attr.qp_state = IB_QPS_ERR;
-		return hns_roce_v2_modify_qp(&(*cur_qp)->ibqp,
-					     &attr, attr_mask,
-					     (*cur_qp)->state, IB_QPS_ERR);
+	/*
+	 * Hip08 hardware cannot flush the WQEs in SQ/RQ if the QP state gets
+	 * into errored mode. Hence, as a workaround to this hardware
+	 * limitation, driver needs to assist in flushing. But the flushing
+	 * operation uses mailbox to convey the QP state to the hardware and
+	 * which can sleep due to the mutex protection around the mailbox calls.
+	 * Hence, use the deferred flush for now. Once wc error detected, the
+	 * flushing operation is needed.
+	 */
+	if (wc->status != IB_WC_SUCCESS &&
+	    wc->status != IB_WC_WR_FLUSH_ERR) {
+		dev_err(hr_dev->dev, "error cqe status is: 0x%x\n",
+			status & HNS_ROCE_V2_CQE_STATUS_MASK);
+
+		if (!test_and_set_bit(HNS_ROCE_FLUSH_FLAG, &hr_qp->flush_flag))
+			init_flush_work(hr_dev, hr_qp);
+
+		return 0;
 	}
 
 	if (wc->status == IB_WC_WR_FLUSH_ERR)
@@ -4735,6 +4735,8 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	struct hns_roce_v2_qp_context *context = ctx;
 	struct hns_roce_v2_qp_context *qpc_mask = ctx + 1;
 	struct device *dev = hr_dev->dev;
+	unsigned long sq_flag = 0;
+	unsigned long rq_flag = 0;
 	int ret;
 
 	/*
@@ -4752,6 +4754,9 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 
 	/* When QP state is err, SQ and RQ WQE should be flushed */
 	if (new_state == IB_QPS_ERR) {
+		spin_lock_irqsave(&hr_qp->sq.lock, sq_flag);
+		spin_lock_irqsave(&hr_qp->rq.lock, rq_flag);
+		hr_qp->state = IB_QPS_ERR;
 		roce_set_field(context->byte_160_sq_ci_pi,
 			       V2_QPC_BYTE_160_SQ_PRODUCER_IDX_M,
 			       V2_QPC_BYTE_160_SQ_PRODUCER_IDX_S,
@@ -4769,6 +4774,8 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 			       V2_QPC_BYTE_84_RQ_PRODUCER_IDX_M,
 			       V2_QPC_BYTE_84_RQ_PRODUCER_IDX_S, 0);
 		}
+		spin_unlock_irqrestore(&hr_qp->rq.lock, rq_flag);
+		spin_unlock_irqrestore(&hr_qp->sq.lock, sq_flag);
 	}
 
 	/* Configure the optional fields */
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index dab73140c5c29..f885b22fc0459 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -57,10 +57,12 @@ static void flush_work_handle(struct work_struct *work)
 	attr_mask = IB_QP_STATE;
 	attr.qp_state = IB_QPS_ERR;
 
-	ret = hns_roce_modify_qp(&hr_qp->ibqp, &attr, attr_mask, NULL);
-	if (ret)
-		dev_err(dev, "Modify QP to error state failed(%d) during CQE flush\n",
-			ret);
+	if (test_and_clear_bit(HNS_ROCE_FLUSH_FLAG, &hr_qp->flush_flag)) {
+		ret = hns_roce_modify_qp(&hr_qp->ibqp, &attr, attr_mask, NULL);
+		if (ret)
+			dev_err(dev, "Modify QP to error state failed(%d) during CQE flush\n",
+				ret);
+	}
 
 	/*
 	 * make sure we signal QP destroy leg that flush QP was completed
@@ -761,6 +763,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 	spin_lock_init(&hr_qp->rq.lock);
 
 	hr_qp->state = IB_QPS_RESET;
+	hr_qp->flush_flag = 0;
 
 	hr_qp->ibqp.qp_type = init_attr->qp_type;
 
-- 
2.20.1

