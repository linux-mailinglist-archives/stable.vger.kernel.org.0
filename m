Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C0B2470F1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbgHQSSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388369AbgHQQFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 732B120658;
        Mon, 17 Aug 2020 16:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680326;
        bh=k/oyX+TLZYFTzsr7j39HYVJcPWmgOzUX2e3v1/QsjDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AM1pZLDmpv/7/o/eqRIxVzxvL29htzt0DhP9eHfAPzex3967kGTpU0ljYq6aQ5Jdh
         ORGKCuQ8EGV7K7QLBG7woTISSroLXFvjjr+Bwad7U4My5ZOgQOJEoxoducE2TuSJjf
         fucREUbegfgD50GT68c1RafFn/H83ODha9hP/9JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kalderon <mkalderon@marvell.com>,
        Yuval Basson <ybason@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/270] RDMA/qedr: SRQs bug fixes
Date:   Mon, 17 Aug 2020 17:15:44 +0200
Message-Id: <20200817143802.928200069@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>

[ Upstream commit acca72e2b031b9fbb4184511072bd246a0abcebc ]

QP's with the same SRQ, working on different CQs and running in parallel
on different CPUs could lead to a race when maintaining the SRQ consumer
count, and leads to FW running out of SRQs. Update the consumer
atomically.  Make sure the wqe_prod is updated after the sge_prod due to
FW requirements.

Fixes: 3491c9e799fb ("qedr: Add support for kernel mode SRQ's")
Link: https://lore.kernel.org/r/20200708195526.31040-1-ybason@marvell.com
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Basson <ybason@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr.h  |  4 ++--
 drivers/infiniband/hw/qedr/verbs.c | 22 ++++++++++------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 8e927f6c15203..ed56df319d2df 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -349,10 +349,10 @@ struct qedr_srq_hwq_info {
 	u32 wqe_prod;
 	u32 sge_prod;
 	u32 wr_prod_cnt;
-	u32 wr_cons_cnt;
+	atomic_t wr_cons_cnt;
 	u32 num_elems;
 
-	u32 *virt_prod_pair_addr;
+	struct rdma_srq_producers *virt_prod_pair_addr;
 	dma_addr_t phy_prod_pair_addr;
 };
 
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 8b4240c1cc763..16a994fd7d0a7 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3460,7 +3460,7 @@ static u32 qedr_srq_elem_left(struct qedr_srq_hwq_info *hw_srq)
 	 * count and consumer count and subtract it from max
 	 * work request supported so that we get elements left.
 	 */
-	used = hw_srq->wr_prod_cnt - hw_srq->wr_cons_cnt;
+	used = hw_srq->wr_prod_cnt - (u32)atomic_read(&hw_srq->wr_cons_cnt);
 
 	return hw_srq->max_wr - used;
 }
@@ -3475,7 +3475,6 @@ int qedr_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 	unsigned long flags;
 	int status = 0;
 	u32 num_sge;
-	u32 offset;
 
 	spin_lock_irqsave(&srq->lock, flags);
 
@@ -3488,7 +3487,8 @@ int qedr_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 		if (!qedr_srq_elem_left(hw_srq) ||
 		    wr->num_sge > srq->hw_srq.max_sges) {
 			DP_ERR(dev, "Can't post WR  (%d,%d) || (%d > %d)\n",
-			       hw_srq->wr_prod_cnt, hw_srq->wr_cons_cnt,
+			       hw_srq->wr_prod_cnt,
+			       atomic_read(&hw_srq->wr_cons_cnt),
 			       wr->num_sge, srq->hw_srq.max_sges);
 			status = -ENOMEM;
 			*bad_wr = wr;
@@ -3522,22 +3522,20 @@ int qedr_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 			hw_srq->sge_prod++;
 		}
 
-		/* Flush WQE and SGE information before
+		/* Update WQE and SGE information before
 		 * updating producer.
 		 */
-		wmb();
+		dma_wmb();
 
 		/* SRQ producer is 8 bytes. Need to update SGE producer index
 		 * in first 4 bytes and need to update WQE producer in
 		 * next 4 bytes.
 		 */
-		*srq->hw_srq.virt_prod_pair_addr = hw_srq->sge_prod;
-		offset = offsetof(struct rdma_srq_producers, wqe_prod);
-		*((u8 *)srq->hw_srq.virt_prod_pair_addr + offset) =
-			hw_srq->wqe_prod;
+		srq->hw_srq.virt_prod_pair_addr->sge_prod = hw_srq->sge_prod;
+		/* Make sure sge producer is updated first */
+		dma_wmb();
+		srq->hw_srq.virt_prod_pair_addr->wqe_prod = hw_srq->wqe_prod;
 
-		/* Flush producer after updating it. */
-		wmb();
 		wr = wr->next;
 	}
 
@@ -3956,7 +3954,7 @@ static int process_resp_one_srq(struct qedr_dev *dev, struct qedr_qp *qp,
 	} else {
 		__process_resp_one(dev, qp, cq, wc, resp, wr_id);
 	}
-	srq->hw_srq.wr_cons_cnt++;
+	atomic_inc(&srq->hw_srq.wr_cons_cnt);
 
 	return 1;
 }
-- 
2.25.1



