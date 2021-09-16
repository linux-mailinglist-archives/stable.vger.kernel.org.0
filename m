Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F3540E630
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351633AbhIPRS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350837AbhIPRQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:16:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E51DE61B61;
        Thu, 16 Sep 2021 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810428;
        bh=7hh779pIjIra02jDNZvX5LuFRHjM82SuTkhLW5pxo+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZGIUkdgSgZdChumlM2YfHGVoLuNiFlSc30QLqc8sRsbfTTeQv+V0pM9w5hT40pvO
         QvoptX1hRHzqTHuh1NekCHdKLhGUMEuoQ6sadHFUBUKh+I39RuWfhz0speo9FqgHCb
         Q7g6TVT2TJBJmaB1EQH3nYurdpLzIWRe4pinUJAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Junxian Huang <huangjunxian4@hisilicon.com>,
        Yangyang Li <liyangyang20@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 138/432] RDMA/hns: Bugfix for incorrect association between dip_idx and dgid
Date:   Thu, 16 Sep 2021 17:58:07 +0200
Message-Id: <20210916155815.438240892@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxian Huang <huangjunxian4@hisilicon.com>

[ Upstream commit eb653eda1e91dd3e7d1d2448d528d033dbfbe78f ]

dip_idx and dgid should be a one-to-one mapping relationship, but when
qp_num loops back to the start number, it may happen that two different
dgid are assiociated to the same dip_idx incorrectly.

One solution is to store the qp_num that is not assigned to dip_idx in an
array. When a dip_idx needs to be allocated to a new dgid, an spare qp_num
is extracted and assigned to dip_idx.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Link: https://lore.kernel.org/r/1629884592-23424-4-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Junxian Huang <huangjunxian4@hisilicon.com>
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  9 ++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  9 ++++++++-
 drivers/infiniband/hw/hns/hns_roce_main.c   |  8 ++++++--
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 10 +++++++++-
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 991f65269fa6..8518b1571f2c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -496,6 +496,12 @@ struct hns_roce_bank {
 	u32 next; /* Next ID to allocate. */
 };
 
+struct hns_roce_idx_table {
+	u32 *spare_idx;
+	u32 head;
+	u32 tail;
+};
+
 struct hns_roce_qp_table {
 	struct hns_roce_hem_table	qp_table;
 	struct hns_roce_hem_table	irrl_table;
@@ -504,6 +510,7 @@ struct hns_roce_qp_table {
 	struct mutex			scc_mutex;
 	struct hns_roce_bank bank[HNS_ROCE_QP_BANK_NUM];
 	struct mutex bank_mutex;
+	struct hns_roce_idx_table	idx_table;
 };
 
 struct hns_roce_cq_table {
@@ -1146,7 +1153,7 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 void hns_roce_init_pd_table(struct hns_roce_dev *hr_dev);
 void hns_roce_init_mr_table(struct hns_roce_dev *hr_dev);
 void hns_roce_init_cq_table(struct hns_roce_dev *hr_dev);
-void hns_roce_init_qp_table(struct hns_roce_dev *hr_dev);
+int hns_roce_init_qp_table(struct hns_roce_dev *hr_dev);
 int hns_roce_init_srq_table(struct hns_roce_dev *hr_dev);
 void hns_roce_init_xrcd_table(struct hns_roce_dev *hr_dev);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d9e330a383b2..21c82f5aff04 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4507,12 +4507,18 @@ static int get_dip_ctx_idx(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 {
 	const struct ib_global_route *grh = rdma_ah_read_grh(&attr->ah_attr);
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
+	u32 *spare_idx = hr_dev->qp_table.idx_table.spare_idx;
+	u32 *head =  &hr_dev->qp_table.idx_table.head;
+	u32 *tail =  &hr_dev->qp_table.idx_table.tail;
 	struct hns_roce_dip *hr_dip;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&hr_dev->dip_list_lock, flags);
 
+	spare_idx[*tail] = ibqp->qp_num;
+	*tail = (*tail == hr_dev->caps.num_qps - 1) ? 0 : (*tail + 1);
+
 	list_for_each_entry(hr_dip, &hr_dev->dip_list, node) {
 		if (!memcmp(grh->dgid.raw, hr_dip->dgid, 16)) {
 			*dip_idx = hr_dip->dip_idx;
@@ -4530,7 +4536,8 @@ static int get_dip_ctx_idx(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	}
 
 	memcpy(hr_dip->dgid, grh->dgid.raw, sizeof(grh->dgid.raw));
-	hr_dip->dip_idx = *dip_idx = ibqp->qp_num;
+	hr_dip->dip_idx = *dip_idx = spare_idx[*head];
+	*head = (*head == hr_dev->caps.num_qps - 1) ? 0 : (*head + 1);
 	list_add_tail(&hr_dip->node, &hr_dev->dip_list);
 
 out:
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index cc6eab14a222..217aad8d9bd9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -748,6 +748,12 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 		goto err_uar_table_free;
 	}
 
+	ret = hns_roce_init_qp_table(hr_dev);
+	if (ret) {
+		dev_err(dev, "Failed to init qp_table.\n");
+		goto err_uar_table_free;
+	}
+
 	hns_roce_init_pd_table(hr_dev);
 
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_XRC)
@@ -757,8 +763,6 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 
 	hns_roce_init_cq_table(hr_dev);
 
-	hns_roce_init_qp_table(hr_dev);
-
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ) {
 		ret = hns_roce_init_srq_table(hr_dev);
 		if (ret) {
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index c3e2fee16c0e..8f437806e07f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1423,12 +1423,17 @@ bool hns_roce_wq_overflow(struct hns_roce_wq *hr_wq, u32 nreq,
 	return cur + nreq >= hr_wq->wqe_cnt;
 }
 
-void hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
+int hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
 	unsigned int reserved_from_bot;
 	unsigned int i;
 
+	qp_table->idx_table.spare_idx = kcalloc(hr_dev->caps.num_qps,
+					sizeof(u32), GFP_KERNEL);
+	if (!qp_table->idx_table.spare_idx)
+		return -ENOMEM;
+
 	mutex_init(&qp_table->scc_mutex);
 	mutex_init(&qp_table->bank_mutex);
 	xa_init(&hr_dev->qp_table_xa);
@@ -1446,6 +1451,8 @@ void hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
 					       HNS_ROCE_QP_BANK_NUM - 1;
 		hr_dev->qp_table.bank[i].next = hr_dev->qp_table.bank[i].min;
 	}
+
+	return 0;
 }
 
 void hns_roce_cleanup_qp_table(struct hns_roce_dev *hr_dev)
@@ -1454,4 +1461,5 @@ void hns_roce_cleanup_qp_table(struct hns_roce_dev *hr_dev)
 
 	for (i = 0; i < HNS_ROCE_QP_BANK_NUM; i++)
 		ida_destroy(&hr_dev->qp_table.bank[i].ida);
+	kfree(hr_dev->qp_table.idx_table.spare_idx);
 }
-- 
2.30.2



