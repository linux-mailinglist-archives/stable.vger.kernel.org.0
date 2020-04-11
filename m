Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96CCD1A5859
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgDKXLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbgDKXK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E30215A4;
        Sat, 11 Apr 2020 23:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646657;
        bh=8Cwoy2amtFzQGMw1MK2u/E5zJynCI/+buenWaMNjp5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MK73dRtHeTaKjUJAYoO+ROAzCfqxNCkzX8ERwYa2h6nUEYsztyOAqduj45ytbvofe
         QUVE2BxQ20DnG8qUmKMvk9fYBwYpNCWOQtaLQ9qDd56A+PLy/WjVozdc8TtAerYd4w
         z9fE/LQ1yTG9YF2a+H865lZ99V4jJRX8k76CwbFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yixian Liu <liuyixian@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 059/108] RDMA/hns: Add the workqueue framework for flush cqe handler
Date:   Sat, 11 Apr 2020 19:08:54 -0400
Message-Id: <20200411230943.24951-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
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
index e36d315690819..2408a363fb191 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -648,6 +648,15 @@ struct hns_roce_rinl_buf {
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
@@ -691,6 +700,7 @@ struct hns_roce_qp {
 	struct hns_roce_sge	sge;
 	u32			next_sge;
 
+	struct hns_roce_work	flush_work;
 	struct hns_roce_rinl_buf rq_inl_buf;
 };
 
@@ -911,15 +921,6 @@ struct hns_roce_caps {
 	u64		flags;
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
@@ -1239,6 +1240,7 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *ib_pd,
 				 struct ib_udata *udata);
 int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		       int attr_mask, struct ib_udata *udata);
+void init_flush_work(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp);
 void *get_recv_wqe(struct hns_roce_qp *hr_qp, int n);
 void *get_send_wqe(struct hns_roce_qp *hr_qp, int n);
 void *get_send_extend_sge(struct hns_roce_qp *hr_qp, int n);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4540b00ccee94..b5112170b8761 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5975,8 +5975,7 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 		goto err_request_irq_fail;
 	}
 
-	hr_dev->irq_workq =
-		create_singlethread_workqueue("hns_roce_irq_workqueue");
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "Create irq workqueue failed!\n");
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 8dd2d666f6875..fe791c4e8ff60 100644
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

