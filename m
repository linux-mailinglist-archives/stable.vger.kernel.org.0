Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09711329060
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242707AbhCAUHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242623AbhCATyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CB1565370;
        Mon,  1 Mar 2021 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621291;
        bh=JhQh2ux6ZgpUi9YRLx/57rzcMHviGO6axjlzaQi/C9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zklkQJAsUASTPK1wU8+5T1rApU9ap5CGx+TBPkBuQkvwHhpYXdSytUvi9nTRvPlnL
         uxNi2AnmowHeQBcBSgToNjpaq9eTjeHYYlSiB0xq++Ysvat9/zsouw4VpQsmuXVt8V
         /RGEWxeccHIrrMMXxw8w7lLx4IgOscNNv6MzbeTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 432/775] RDMA/hns: Bugfix for checking whether the srq is full when post wr
Date:   Mon,  1 Mar 2021 17:10:00 +0100
Message-Id: <20210301161222.918568671@linuxfoundation.org>
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

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit 1620f09b96ec14c1ff1ff64ee0aeabc027c653d5 ]

If a user posts WR by wr_list, the head pointer of idx_queue won't be
updated until all wqes are filled, so the judgment of whether head equals
to tail will get a wrong result. Fix above issue and move the head and
tail pointer from the srq structure into the idx_queue structure. After
idx_queue is filled with wqe idx, the head pointer of it will increase.

Fixes: c7bcb13442e1 ("RDMA/hns: Add SRQ support for hip08 kernel mode")
Link: https://lore.kernel.org/r/1611997090-48820-3-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 19 ++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_srq.c    |  5 +++--
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index dd3e3886ab96d..2e42e25957938 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -492,6 +492,8 @@ struct hns_roce_idx_que {
 	struct hns_roce_mtr		mtr;
 	int				entry_shift;
 	unsigned long			*bitmap;
+	u32				head;
+	u32				tail;
 };
 
 struct hns_roce_srq {
@@ -511,8 +513,6 @@ struct hns_roce_srq {
 	u64		       *wrid;
 	struct hns_roce_idx_que idx_que;
 	spinlock_t		lock;
-	u16			head;
-	u16			tail;
 	struct mutex		mutex;
 	void (*event)(struct hns_roce_srq *srq, enum hns_roce_event event);
 };
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4d1e4bddf8327..c05e418b6e538 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -849,11 +849,20 @@ static void hns_roce_free_srq_wqe(struct hns_roce_srq *srq, int wqe_index)
 	spin_lock(&srq->lock);
 
 	bitmap_clear(srq->idx_que.bitmap, wqe_index, 1);
-	srq->tail++;
+	srq->idx_que.tail++;
 
 	spin_unlock(&srq->lock);
 }
 
+int hns_roce_srqwq_overflow(struct hns_roce_srq *srq, int nreq)
+{
+	struct hns_roce_idx_que *idx_que = &srq->idx_que;
+	unsigned int cur;
+
+	cur = idx_que->head - idx_que->tail;
+	return cur + nreq >= srq->wqe_cnt - 1;
+}
+
 static int find_empty_entry(struct hns_roce_idx_que *idx_que,
 			    unsigned long size)
 {
@@ -889,7 +898,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 
 	spin_lock_irqsave(&srq->lock, flags);
 
-	ind = srq->head & (srq->wqe_cnt - 1);
+	ind = srq->idx_que.head & (srq->wqe_cnt - 1);
 	max_sge = srq->max_gs - srq->rsv_sge;
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
@@ -902,7 +911,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 			break;
 		}
 
-		if (unlikely(srq->head == srq->tail)) {
+		if (unlikely(hns_roce_srqwq_overflow(srq, nreq))) {
 			ret = -ENOMEM;
 			*bad_wr = wr;
 			break;
@@ -938,7 +947,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 	}
 
 	if (likely(nreq)) {
-		srq->head += nreq;
+		srq->idx_que.head += nreq;
 
 		/*
 		 * Make sure that descriptors are written before
@@ -950,7 +959,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 			cpu_to_le32(HNS_ROCE_V2_SRQ_DB << V2_DB_BYTE_4_CMD_S |
 				    (srq->srqn & V2_DB_BYTE_4_TAG_M));
 		srq_db.parameter =
-			cpu_to_le32(srq->head & V2_DB_PARAMETER_IDX_M);
+			cpu_to_le32(srq->idx_que.head & V2_DB_PARAMETER_IDX_M);
 
 		hns_roce_write64(hr_dev, (__le32 *)&srq_db, srq->db_reg_l);
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 8e20085b8920a..9f60a0a745e11 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -247,6 +247,9 @@ static int alloc_srq_idx(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq,
 		}
 	}
 
+	idx_que->head = 0;
+	idx_que->tail = 0;
+
 	return 0;
 err_idx_mtr:
 	hns_roce_mtr_destroy(hr_dev, &idx_que->mtr);
@@ -265,8 +268,6 @@ static void free_srq_idx(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 
 static int alloc_srq_wrid(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 {
-	srq->head = 0;
-	srq->tail = srq->wqe_cnt - 1;
 	srq->wrid = kvmalloc_array(srq->wqe_cnt, sizeof(u64), GFP_KERNEL);
 	if (!srq->wrid)
 		return -ENOMEM;
-- 
2.27.0



