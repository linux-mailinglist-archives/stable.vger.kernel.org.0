Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F5132904C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhCAUF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242617AbhCATyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C6ED6536C;
        Mon,  1 Mar 2021 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621280;
        bh=U14pbi5IXoD11u+uScBweYaxDJ9Mq4Vjicmwib4olto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2CE2WRLH2qpmRGIhDzy+4iCRukKzkCKTuEBUjoqRRfakPmOP0VytBhFCFrZYS6YD
         VISVufuKv3J3f3W7IuCKE3dN6m6HFRoa77IMF8uAGiHqlTcbqxnVauoUHjxs8MbXrd
         jI73rq+Raxt4rJhbuettxJ5igZ4LX9GveZWyaFLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 431/775] RDMA/hns: Allocate one more recv SGE for HIP08
Date:   Mon,  1 Mar 2021 17:09:59 +0100
Message-Id: <20210301161222.869020514@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

[ Upstream commit 9dd052474a2645b2a6171d19ad17b05b180d446d ]

The RQ/SRQ of HIP08 needs one special sge to stop receive reliably. So the
driver needs to allocate at least one SGE when creating RQ/SRQ and ensure
that at least one SGE is filled with the special value during post_recv.

Besides, the kernel driver should only do this for kernel ULP. For
userspace ULP, the userspace driver will allocate the reserved SGE in
buffer, and the kernel driver just needs to pin the corresponding size of
memory based on the userspace driver's requirements.

Link: https://lore.kernel.org/r/1611997090-48820-2-git-send-email-liweihang@huawei.com
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  4 +++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 28 ++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  3 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 37 +++++++++++++++----
 drivers/infiniband/hw/hns/hns_roce_srq.c    | 40 +++++++++++++++++++--
 5 files changed, 93 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index ad8253245a85f..dd3e3886ab96d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -65,6 +65,8 @@
 #define HNS_ROCE_CQE_WCMD_EMPTY_BIT		0x2
 #define HNS_ROCE_MIN_CQE_CNT			16
 
+#define HNS_ROCE_RESERVED_SGE			1
+
 #define HNS_ROCE_MAX_IRQ_NUM			128
 
 #define HNS_ROCE_SGE_IN_WQE			2
@@ -393,6 +395,7 @@ struct hns_roce_wq {
 	spinlock_t	lock;
 	u32		wqe_cnt;  /* WQE num */
 	u32		max_gs;
+	u32		rsv_sge;
 	int		offset;
 	int		wqe_shift;	/* WQE size */
 	u32		head;
@@ -496,6 +499,7 @@ struct hns_roce_srq {
 	unsigned long		srqn;
 	u32			wqe_cnt;
 	int			max_gs;
+	u32			rsv_sge;
 	int			wqe_shift;
 	void __iomem		*db_reg_l;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 833e1f259936f..4d1e4bddf8327 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -741,6 +741,7 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 	unsigned long flags;
 	void *wqe = NULL;
 	u32 wqe_idx;
+	u32 max_sge;
 	int nreq;
 	int ret;
 	int i;
@@ -754,6 +755,7 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 		goto out;
 	}
 
+	max_sge = hr_qp->rq.max_gs - hr_qp->rq.rsv_sge;
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (unlikely(hns_roce_wq_overflow(&hr_qp->rq, nreq,
 						  hr_qp->ibqp.recv_cq))) {
@@ -764,9 +766,9 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 
 		wqe_idx = (hr_qp->rq.head + nreq) & (hr_qp->rq.wqe_cnt - 1);
 
-		if (unlikely(wr->num_sge > hr_qp->rq.max_gs)) {
+		if (unlikely(wr->num_sge > max_sge)) {
 			ibdev_err(ibdev, "num_sge = %d >= max_sge = %u.\n",
-				  wr->num_sge, hr_qp->rq.max_gs);
+				  wr->num_sge, max_sge);
 			ret = -EINVAL;
 			*bad_wr = wr;
 			goto out;
@@ -781,9 +783,10 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 			dseg++;
 		}
 
-		if (wr->num_sge < hr_qp->rq.max_gs) {
+		if (hr_qp->rq.rsv_sge) {
 			dseg->lkey = cpu_to_le32(HNS_ROCE_INVALID_LKEY);
 			dseg->addr = 0;
+			dseg->len = cpu_to_le32(HNS_ROCE_INVALID_SGE_LENGTH);
 		}
 
 		/* rq support inline data */
@@ -879,6 +882,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 	__le32 *srq_idx;
 	int ret = 0;
 	int wqe_idx;
+	u32 max_sge;
 	void *wqe;
 	int nreq;
 	int i;
@@ -886,9 +890,13 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 	spin_lock_irqsave(&srq->lock, flags);
 
 	ind = srq->head & (srq->wqe_cnt - 1);
+	max_sge = srq->max_gs - srq->rsv_sge;
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
-		if (unlikely(wr->num_sge >= srq->max_gs)) {
+		if (unlikely(wr->num_sge > max_sge)) {
+			ibdev_err(&hr_dev->ib_dev,
+				  "srq: num_sge = %d, max_sge = %u.\n",
+				  wr->num_sge, max_sge);
 			ret = -EINVAL;
 			*bad_wr = wr;
 			break;
@@ -916,9 +924,9 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 			dseg[i].addr = cpu_to_le64(wr->sg_list[i].addr);
 		}
 
-		if (wr->num_sge < srq->max_gs) {
-			dseg[i].len = 0;
-			dseg[i].lkey = cpu_to_le32(0x100);
+		if (srq->rsv_sge) {
+			dseg[i].len = cpu_to_le32(HNS_ROCE_INVALID_SGE_LENGTH);
+			dseg[i].lkey = cpu_to_le32(HNS_ROCE_INVALID_LKEY);
 			dseg[i].addr = 0;
 		}
 
@@ -1999,10 +2007,12 @@ static int hns_roce_query_pf_caps(struct hns_roce_dev *hr_dev)
 	caps->max_sq_sg		     = le16_to_cpu(resp_a->max_sq_sg);
 	caps->max_sq_inline	     = le16_to_cpu(resp_a->max_sq_inline);
 	caps->max_rq_sg		     = le16_to_cpu(resp_a->max_rq_sg);
+	caps->max_rq_sg = roundup_pow_of_two(caps->max_rq_sg);
 	caps->max_extend_sg	     = le32_to_cpu(resp_a->max_extend_sg);
 	caps->num_qpc_timer	     = le16_to_cpu(resp_a->num_qpc_timer);
 	caps->num_cqc_timer	     = le16_to_cpu(resp_a->num_cqc_timer);
 	caps->max_srq_sges	     = le16_to_cpu(resp_a->max_srq_sges);
+	caps->max_srq_sges = roundup_pow_of_two(caps->max_srq_sges);
 	caps->num_aeq_vectors	     = resp_a->num_aeq_vectors;
 	caps->num_other_vectors	     = resp_a->num_other_vectors;
 	caps->max_sq_desc_sz	     = resp_a->max_sq_desc_sz;
@@ -5083,7 +5093,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 done:
 	qp_attr->cur_qp_state = qp_attr->qp_state;
 	qp_attr->cap.max_recv_wr = hr_qp->rq.wqe_cnt;
-	qp_attr->cap.max_recv_sge = hr_qp->rq.max_gs;
+	qp_attr->cap.max_recv_sge = hr_qp->rq.max_gs - hr_qp->rq.rsv_sge;
 
 	if (!ibqp->uobject) {
 		qp_attr->cap.max_send_wr = hr_qp->sq.wqe_cnt;
@@ -5395,7 +5405,7 @@ static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 
 	attr->srq_limit = limit_wl;
 	attr->max_wr = srq->wqe_cnt - 1;
-	attr->max_sge = srq->max_gs;
+	attr->max_sge = srq->max_gs - srq->rsv_sge;
 
 out:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index bdaccf86460dd..09d88d97a7ff9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -96,7 +96,8 @@
 #define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		PAGE_SIZE
 #define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
-#define HNS_ROCE_INVALID_LKEY			0x100
+#define HNS_ROCE_INVALID_LKEY			0x0
+#define HNS_ROCE_INVALID_SGE_LENGTH		0x80000000
 #define HNS_ROCE_CMQ_TX_TIMEOUT			30000
 #define HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE	2
 #define HNS_ROCE_V2_RSV_QPS			8
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 1116371adf74f..8695c96e66964 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -413,9 +413,32 @@ static void free_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 	mutex_unlock(&hr_dev->qp_table.bank_mutex);
 }
 
+static u32 proc_rq_sge(struct hns_roce_dev *dev, struct hns_roce_qp *hr_qp,
+		       bool user)
+{
+	u32 max_sge = dev->caps.max_rq_sg;
+
+	if (dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
+		return max_sge;
+
+	/* Reserve SGEs only for HIP08 in kernel; The userspace driver will
+	 * calculate number of max_sge with reserved SGEs when allocating wqe
+	 * buf, so there is no need to do this again in kernel. But the number
+	 * may exceed the capacity of SGEs recorded in the firmware, so the
+	 * kernel driver should just adapt the value accordingly.
+	 */
+	if (user)
+		max_sge = roundup_pow_of_two(max_sge + 1);
+	else
+		hr_qp->rq.rsv_sge = 1;
+
+	return max_sge;
+}
+
 static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
-		       struct hns_roce_qp *hr_qp, int has_rq)
+		       struct hns_roce_qp *hr_qp, int has_rq, bool user)
 {
+	u32 max_sge = proc_rq_sge(hr_dev, hr_qp, user);
 	u32 cnt;
 
 	/* If srq exist, set zero for relative number of rq */
@@ -431,8 +454,9 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 
 	/* Check the validity of QP support capacity */
 	if (!cap->max_recv_wr || cap->max_recv_wr > hr_dev->caps.max_wqes ||
-	    cap->max_recv_sge > hr_dev->caps.max_rq_sg) {
-		ibdev_err(&hr_dev->ib_dev, "RQ config error, depth=%u, sge=%d\n",
+	    cap->max_recv_sge > max_sge) {
+		ibdev_err(&hr_dev->ib_dev,
+			  "RQ config error, depth = %u, sge = %u\n",
 			  cap->max_recv_wr, cap->max_recv_sge);
 		return -EINVAL;
 	}
@@ -444,7 +468,8 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 		return -EINVAL;
 	}
 
-	hr_qp->rq.max_gs = roundup_pow_of_two(max(1U, cap->max_recv_sge));
+	hr_qp->rq.max_gs = roundup_pow_of_two(max(1U, cap->max_recv_sge) +
+					      hr_qp->rq.rsv_sge);
 
 	if (hr_dev->caps.max_rq_sg <= HNS_ROCE_SGE_IN_WQE)
 		hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz);
@@ -459,7 +484,7 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 		hr_qp->rq_inl_buf.wqe_cnt = 0;
 
 	cap->max_recv_wr = cnt;
-	cap->max_recv_sge = hr_qp->rq.max_gs;
+	cap->max_recv_sge = hr_qp->rq.max_gs - hr_qp->rq.rsv_sge;
 
 	return 0;
 }
@@ -919,7 +944,7 @@ static int set_qp_param(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 		hr_qp->sq_signal_bits = IB_SIGNAL_REQ_WR;
 
 	ret = set_rq_size(hr_dev, &init_attr->cap, hr_qp,
-			  hns_roce_qp_has_rq(init_attr));
+			  hns_roce_qp_has_rq(init_attr), !!udata);
 	if (ret) {
 		ibdev_err(ibdev, "failed to set user RQ size, ret = %d.\n",
 			  ret);
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index c4ae57e4173a1..8e20085b8920a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2018 Hisilicon Limited.
  */
 
+#include <linux/pci.h>
 #include <rdma/ib_umem.h>
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
@@ -279,6 +280,28 @@ static void free_srq_wrid(struct hns_roce_srq *srq)
 	srq->wrid = NULL;
 }
 
+static u32 proc_srq_sge(struct hns_roce_dev *dev, struct hns_roce_srq *hr_srq,
+			bool user)
+{
+	u32 max_sge = dev->caps.max_srq_sges;
+
+	if (dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
+		return max_sge;
+
+	/* Reserve SGEs only for HIP08 in kernel; The userspace driver will
+	 * calculate number of max_sge with reserved SGEs when allocating wqe
+	 * buf, so there is no need to do this again in kernel. But the number
+	 * may exceed the capacity of SGEs recorded in the firmware, so the
+	 * kernel driver should just adapt the value accordingly.
+	 */
+	if (user)
+		max_sge = roundup_pow_of_two(max_sge + 1);
+	else
+		hr_srq->rsv_sge = 1;
+
+	return max_sge;
+}
+
 int hns_roce_create_srq(struct ib_srq *ib_srq,
 			struct ib_srq_init_attr *init_attr,
 			struct ib_udata *udata)
@@ -288,6 +311,7 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 	struct hns_roce_srq *srq = to_hr_srq(ib_srq);
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_ib_create_srq ucmd = {};
+	u32 max_sge;
 	int ret;
 	u32 cqn;
 
@@ -295,16 +319,24 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 	    init_attr->srq_type != IB_SRQT_XRC)
 		return -EOPNOTSUPP;
 
-	/* Check the actual SRQ wqe and SRQ sge num */
+	max_sge = proc_srq_sge(hr_dev, srq, !!udata);
+
 	if (init_attr->attr.max_wr >= hr_dev->caps.max_srq_wrs ||
-	    init_attr->attr.max_sge > hr_dev->caps.max_srq_sges)
+	    init_attr->attr.max_sge > max_sge) {
+		ibdev_err(&hr_dev->ib_dev,
+			  "SRQ config error, depth = %u, sge = %d\n",
+			  init_attr->attr.max_wr, init_attr->attr.max_sge);
 		return -EINVAL;
+	}
 
 	mutex_init(&srq->mutex);
 	spin_lock_init(&srq->lock);
 
 	srq->wqe_cnt = roundup_pow_of_two(init_attr->attr.max_wr + 1);
-	srq->max_gs = init_attr->attr.max_sge;
+	srq->max_gs =
+		roundup_pow_of_two(init_attr->attr.max_sge + srq->rsv_sge);
+	init_attr->attr.max_wr = srq->wqe_cnt;
+	init_attr->attr.max_sge = srq->max_gs;
 
 	if (udata) {
 		ret = ib_copy_from_udata(&ucmd, udata,
@@ -351,6 +383,8 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 
 	srq->event = hns_roce_ib_srq_event;
 	resp.srqn = srq->srqn;
+	srq->max_gs = init_attr->attr.max_sge;
+	init_attr->attr.max_sge = srq->max_gs - srq->rsv_sge;
 
 	if (udata) {
 		ret = ib_copy_to_udata(udata, &resp,
-- 
2.27.0



