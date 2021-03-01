Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0278F329053
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbhCAUGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242628AbhCATyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B0386536A;
        Mon,  1 Mar 2021 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621299;
        bh=pXFnh3MubB6tF1MTqPvJYuusSMu+Jnx25o6aC59TPQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipTDSa4B1cSWQPy+tEKCRhs7pRs3eKuqb657vbm3j9ebdTUsrPP6f1F+I/7i3ctUV
         vBbiky6bdZgq+rYwWFf0l8srQhpbmW9RTFNp687nk1wtdUpi8WyKi7Pld98+2IJOHZ
         zlRtjxC0Dy5d+Vk8DITLBsZ8s8631dWSY2DadyoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 435/775] RDMA/hns: Remove the reserved WQE of SRQ
Date:   Mon,  1 Mar 2021 17:10:03 +0100
Message-Id: <20210301161223.063842584@linuxfoundation.org>
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

[ Upstream commit 6ee00fbf733d7e17ca935e5636adfce605b10659 ]

Each SRQs contain an reserved WQE, it is inappropriate and should be
removed.

Fixes: c7bcb13442e1 ("RDMA/hns: Add SRQ support for hip08 kernel mode")
Link: https://lore.kernel.org/r/1611997090-48820-6-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 6 +++---
 drivers/infiniband/hw/hns/hns_roce_srq.c    | 6 ++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 2e42e25957938..9ac6d760aa5b3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -54,6 +54,7 @@
 /* Hardware specification only for v1 engine */
 #define HNS_ROCE_MIN_CQE_NUM			0x40
 #define HNS_ROCE_MIN_WQE_NUM			0x20
+#define HNS_ROCE_MIN_SRQ_WQE_NUM		1
 
 /* Hardware specification only for v1 engine */
 #define HNS_ROCE_MAX_INNER_MTPT_NUM		0x7
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c05e418b6e538..a909993552e7f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -860,7 +860,7 @@ int hns_roce_srqwq_overflow(struct hns_roce_srq *srq, int nreq)
 	unsigned int cur;
 
 	cur = idx_que->head - idx_que->tail;
-	return cur + nreq >= srq->wqe_cnt - 1;
+	return cur + nreq >= srq->wqe_cnt;
 }
 
 static int find_empty_entry(struct hns_roce_idx_que *idx_que,
@@ -5350,7 +5350,7 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 		return -EINVAL;
 
 	if (srq_attr_mask & IB_SRQ_LIMIT) {
-		if (srq_attr->srq_limit >= srq->wqe_cnt)
+		if (srq_attr->srq_limit > srq->wqe_cnt)
 			return -EINVAL;
 
 		mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
@@ -5413,7 +5413,7 @@ static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 				  SRQC_BYTE_8_SRQ_LIMIT_WL_S);
 
 	attr->srq_limit = limit_wl;
-	attr->max_wr = srq->wqe_cnt - 1;
+	attr->max_wr = srq->wqe_cnt;
 	attr->max_sge = srq->max_gs - srq->rsv_sge;
 
 out:
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index ecc42c59e3cfc..51de9305bb4de 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -322,7 +322,7 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 
 	max_sge = proc_srq_sge(hr_dev, srq, !!udata);
 
-	if (init_attr->attr.max_wr >= hr_dev->caps.max_srq_wrs ||
+	if (init_attr->attr.max_wr > hr_dev->caps.max_srq_wrs ||
 	    init_attr->attr.max_sge > max_sge) {
 		ibdev_err(&hr_dev->ib_dev,
 			  "SRQ config error, depth = %u, sge = %d\n",
@@ -333,7 +333,9 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 	mutex_init(&srq->mutex);
 	spin_lock_init(&srq->lock);
 
-	srq->wqe_cnt = roundup_pow_of_two(init_attr->attr.max_wr + 1);
+	init_attr->attr.max_wr = max_t(u32, init_attr->attr.max_wr,
+				       HNS_ROCE_MIN_SRQ_WQE_NUM);
+	srq->wqe_cnt = roundup_pow_of_two(init_attr->attr.max_wr);
 	srq->max_gs =
 		roundup_pow_of_two(init_attr->attr.max_sge + srq->rsv_sge);
 	init_attr->attr.max_wr = srq->wqe_cnt;
-- 
2.27.0



