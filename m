Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B53724FA13
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgHXJwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728548AbgHXIid (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:38:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E4D20FC3;
        Mon, 24 Aug 2020 08:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258312;
        bh=Th2zgGwWzxKAiUqBsJBnqsq9toC4rscuuCvlMxfUxuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVLrYnNZ0WUkROvqR49bwvTUmwra/CdePyeU4621Ei7uJmpZPHsAmPORBmervZARD
         AOMWV1etGyiPFOeSlURvfGwJJXajA3LbE0WxKu4pHTx99zfVjfTVRi4/ucPzQftM0t
         yveCzXqiMtR2rrT65nsOz5dqu24TRHPC1XPRnZho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 123/148] Revert "RDMA/hns: Reserve one sge in order to avoid local length error"
Date:   Mon, 24 Aug 2020 10:30:21 +0200
Message-Id: <20200824082419.905659752@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 6da06c6291f38be4df6df2efb76ba925096d2691 ]

This patch caused some issues on SEND operation, and it should be reverted
to make the drivers work correctly. There will be a better solution that
has been tested carefully to solve the original problem.

This reverts commit 711195e57d341e58133d92cf8aaab1db24e4768d.

Fixes: 711195e57d34 ("RDMA/hns: Reserve one sge in order to avoid local length error")
Link: https://lore.kernel.org/r/1597829984-20223-1-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 --
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 9 ++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 4 +---
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 5 ++---
 drivers/infiniband/hw/hns/hns_roce_srq.c    | 2 +-
 5 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 479fa557993e7..c69453a62767c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -66,8 +66,6 @@
 #define HNS_ROCE_CQE_WCMD_EMPTY_BIT		0x2
 #define HNS_ROCE_MIN_CQE_CNT			16
 
-#define HNS_ROCE_RESERVED_SGE			1
-
 #define HNS_ROCE_MAX_IRQ_NUM			128
 
 #define HNS_ROCE_SGE_IN_WQE			2
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index eb71b941d21b7..38a48ab3e1d02 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -629,7 +629,7 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 
 		wqe_idx = (hr_qp->rq.head + nreq) & (hr_qp->rq.wqe_cnt - 1);
 
-		if (unlikely(wr->num_sge >= hr_qp->rq.max_gs)) {
+		if (unlikely(wr->num_sge > hr_qp->rq.max_gs)) {
 			ibdev_err(ibdev, "rq:num_sge=%d >= qp->sq.max_gs=%d\n",
 				  wr->num_sge, hr_qp->rq.max_gs);
 			ret = -EINVAL;
@@ -649,7 +649,6 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 		if (wr->num_sge < hr_qp->rq.max_gs) {
 			dseg->lkey = cpu_to_le32(HNS_ROCE_INVALID_LKEY);
 			dseg->addr = 0;
-			dseg->len = cpu_to_le32(HNS_ROCE_INVALID_SGE_LENGTH);
 		}
 
 		/* rq support inline data */
@@ -783,8 +782,8 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 		}
 
 		if (wr->num_sge < srq->max_gs) {
-			dseg[i].len = cpu_to_le32(HNS_ROCE_INVALID_SGE_LENGTH);
-			dseg[i].lkey = cpu_to_le32(HNS_ROCE_INVALID_LKEY);
+			dseg[i].len = 0;
+			dseg[i].lkey = cpu_to_le32(0x100);
 			dseg[i].addr = 0;
 		}
 
@@ -5098,7 +5097,7 @@ static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 
 	attr->srq_limit = limit_wl;
 	attr->max_wr = srq->wqe_cnt - 1;
-	attr->max_sge = srq->max_gs - HNS_ROCE_RESERVED_SGE;
+	attr->max_sge = srq->max_gs;
 
 out:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index e6c385ced1872..4f840997c6c73 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -92,9 +92,7 @@
 #define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		PAGE_SIZE
 #define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
-#define HNS_ROCE_INVALID_LKEY			0x0
-#define HNS_ROCE_INVALID_SGE_LENGTH		0x80000000
-
+#define HNS_ROCE_INVALID_LKEY			0x100
 #define HNS_ROCE_CMQ_TX_TIMEOUT			30000
 #define HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE	2
 #define HNS_ROCE_V2_RSV_QPS			8
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index a0a47bd669759..4edea397b6b80 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -386,8 +386,7 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 		return -EINVAL;
 	}
 
-	hr_qp->rq.max_gs = roundup_pow_of_two(max(1U, cap->max_recv_sge) +
-					      HNS_ROCE_RESERVED_SGE);
+	hr_qp->rq.max_gs = roundup_pow_of_two(max(1U, cap->max_recv_sge));
 
 	if (hr_dev->caps.max_rq_sg <= HNS_ROCE_SGE_IN_WQE)
 		hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz);
@@ -402,7 +401,7 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 		hr_qp->rq_inl_buf.wqe_cnt = 0;
 
 	cap->max_recv_wr = cnt;
-	cap->max_recv_sge = hr_qp->rq.max_gs - HNS_ROCE_RESERVED_SGE;
+	cap->max_recv_sge = hr_qp->rq.max_gs;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index f40a000e94ee7..b9e2dbd372b66 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -297,7 +297,7 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 	spin_lock_init(&srq->lock);
 
 	srq->wqe_cnt = roundup_pow_of_two(init_attr->attr.max_wr + 1);
-	srq->max_gs = init_attr->attr.max_sge + HNS_ROCE_RESERVED_SGE;
+	srq->max_gs = init_attr->attr.max_sge;
 
 	if (udata) {
 		ret = ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
-- 
2.25.1



