Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA3F1A5AF1
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgDKXFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbgDKXFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3105120708;
        Sat, 11 Apr 2020 23:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646329;
        bh=9UiT+54dkE2BzQLulbKxri8KD5FKEpDi5HFaU1OOVk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/3gLdKI+o5Czm0yxwtvQblkEMXMuOLVHdcThahf+jEqOJ5xhUNhHiedGPmgDGq9R
         VtLdMqSZ21Eci6a+fec8KgIigKS5VY8Hb2KVWGjRIEB0EZYvxQcH5BhHLmWrM6u2Dq
         sSzgKsyBMa3SutiXhj0UiplN6ANbf37/HURoqqk8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yixian Liu <liuyixian@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 082/149] RDMA/hns: Add the workqueue framework for flush cqe handler
Date:   Sat, 11 Apr 2020 19:02:39 -0400
Message-Id: <20200411230347.22371-82-sashal@kernel.org>
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

[ Upstream commit ffd541d45726341c1830ff595fd7352b6d1cfbcd ]

HiP08 RoCE hardware lacks ability(a known hardware problem) to flush
outstanding WQEs if QP state gets into errored mode for some reason.  To
overcome this hardware problem and as a workaround, when QP is detected to
be in errored state during various legs like post send, post receive etc
[1], flush needs to be performed from the driver.

The earlier patch[1] sent to solve the hardware limitation explained in
the cover-letter had a bug in the software flushing leg. It acquired mutex
while modifying QP state to errored state and while conveying it to the
hardware using the mailbox. This caused leg to sleep while holding
spin-lock and caused crash.

Suggested Solution:
we have proposed to defer the flushing of the QP in the Errored state
using the workqueue to get around with the limitation of our hardware.

This patch adds the framework of the workqueue and the flush handler
function.

[1] https://patchwork.kernel.org/patch/10534271/

Link: https://lore.kernel.org/r/1580983005-13899-2-git-send-email-liuyixian@huawei.com
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Reviewed-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 20 ++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  3 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 37 +++++++++++++++++++++
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index a7c4ff975c289..a089d47354391 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -641,6 +641,15 @@ struct hns_roce_rinl_buf {
 	u32			 wqe_cnt;
 };
 
+struct hns_roce_work {
+	struct hns_roce_dev *hr_dev;
+	struct work_struct work;
+	u32 qpn;
+	u32 cqn;
+	int event_type;
+	int sub_type;
+};
+
 struct hns_roce_qp {
 	struct ib_qp		ibqp;
 	struct hns_roce_buf	hr_buf;
@@ -684,6 +693,7 @@ struct hns_roce_qp {
 	struct hns_roce_sge	sge;
 	u32			next_sge;
 
+	struct hns_roce_work	flush_work;
 	struct hns_roce_rinl_buf rq_inl_buf;
 	struct list_head	node;		/* all qps are on a list */
 	struct list_head	rq_node;	/* all recv qps are on a list */
@@ -906,15 +916,6 @@ struct hns_roce_caps {
 	u16		default_ceq_arm_st;
 };
 
-struct hns_roce_work {
-	struct hns_roce_dev *hr_dev;
-	struct work_struct work;
-	u32 qpn;
-	u32 cqn;
-	int event_type;
-	int sub_type;
-};
-
 struct hns_roce_dfx_hw {
 	int (*query_cqc_info)(struct hns_roce_dev *hr_dev, u32 cqn,
 			      int *buffer);
@@ -1237,6 +1238,7 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *ib_pd,
 				 struct ib_udata *udata);
 int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		       int attr_mask, struct ib_udata *udata);
+void init_flush_work(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp);
 void *get_recv_wqe(struct hns_roce_qp *hr_qp, int n);
 void *get_send_wqe(struct hns_roce_qp *hr_qp, int n);
 void *get_send_extend_sge(struct hns_roce_qp *hr_qp, int n);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 12c4cd8e9378c..950c604a6fcb4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6292,8 +6292,7 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 		goto err_request_irq_fail;
 	}
 
-	hr_dev->irq_workq =
-		create_singlethread_workqueue("hns_roce_irq_workqueue");
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "Create irq workqueue failed!\n");
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 3257ad11be482..dab73140c5c29 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -43,6 +43,43 @@
 
 #define SQP_NUM				(2 * HNS_ROCE_MAX_PORTS)
 
+static void flush_work_handle(struct work_struct *work)
+{
+	struct hns_roce_work *flush_work = container_of(work,
+					struct hns_roce_work, work);
+	struct hns_roce_qp *hr_qp = container_of(flush_work,
+					struct hns_roce_qp, flush_work);
+	struct device *dev = flush_work->hr_dev->dev;
+	struct ib_qp_attr attr;
+	int attr_mask;
+	int ret;
+
+	attr_mask = IB_QP_STATE;
+	attr.qp_state = IB_QPS_ERR;
+
+	ret = hns_roce_modify_qp(&hr_qp->ibqp, &attr, attr_mask, NULL);
+	if (ret)
+		dev_err(dev, "Modify QP to error state failed(%d) during CQE flush\n",
+			ret);
+
+	/*
+	 * make sure we signal QP destroy leg that flush QP was completed
+	 * so that it can safely proceed ahead now and destroy QP
+	 */
+	if (atomic_dec_and_test(&hr_qp->refcount))
+		complete(&hr_qp->free);
+}
+
+void init_flush_work(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
+{
+	struct hns_roce_work *flush_work = &hr_qp->flush_work;
+
+	flush_work->hr_dev = hr_dev;
+	INIT_WORK(&flush_work->work, flush_work_handle);
+	atomic_inc(&hr_qp->refcount);
+	queue_work(hr_dev->irq_workq, &flush_work->work);
+}
+
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type)
 {
 	struct device *dev = hr_dev->dev;
-- 
2.20.1

