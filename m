Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CE2658071
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiL1QSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiL1QRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC3B1AD98
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:15:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55763B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63BFC433D2;
        Wed, 28 Dec 2022 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244128;
        bh=54dbHOIasJXfDOHH/vRNBxtekKU3VJIXGLtvmHeKg6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuWHXaYgbsO4cn9hOazqTG8iI1XaowQ5SJgEoaDoDANWIRfpeIZ5Ov8W+ulUNT5/0
         ep/D5fgFcT7HSqGQ/leMiYVNvk7dGCoE9nvQMNm2mU+sxy1jpoJLwVQHvV1GiTKxBz
         zfj/kGPsqdckvGEdv5muA0gJc/TR1YqMSM8VnvRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0646/1073] RDMA/hns: Remove redundant DFX file and DFX ops structure
Date:   Wed, 28 Dec 2022 15:37:14 +0100
Message-Id: <20221228144345.590643586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit 40b4b79c866ffc1414a3989cc480263e76f28589 ]

There is no need to use a dedicated DXF file and DFX structure to manage
the interface of the query queue context.

Link: https://lore.kernel.org/r/20220822104455.2311053-2-liangwenpeng@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 487d65090a3d ("RDMA/hns: Fix the gid problem caused by free mr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/Makefile            |  2 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   | 10 ++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    | 35 ++++++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h    |  3 --
 .../infiniband/hw/hns/hns_roce_hw_v2_dfx.c    | 34 ------------------
 drivers/infiniband/hw/hns/hns_roce_main.c     |  6 +++-
 drivers/infiniband/hw/hns/hns_roce_restrack.c | 35 +++++++------------
 7 files changed, 50 insertions(+), 75 deletions(-)
 delete mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2_dfx.c

diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/hns/Makefile
index 9f04f25d9631..a7d259238305 100644
--- a/drivers/infiniband/hw/hns/Makefile
+++ b/drivers/infiniband/hw/hns/Makefile
@@ -10,6 +10,6 @@ hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
 	hns_roce_cq.o hns_roce_alloc.o hns_roce_db.o hns_roce_srq.o hns_roce_restrack.o
 
 ifdef CONFIG_INFINIBAND_HNS_HIP08
-hns-roce-hw-v2-objs := hns_roce_hw_v2.o hns_roce_hw_v2_dfx.o $(hns-roce-objs)
+hns-roce-hw-v2-objs := hns_roce_hw_v2.o $(hns-roce-objs)
 obj-$(CONFIG_INFINIBAND_HNS) += hns-roce-hw-v2.o
 endif
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 4dc296d856d8..48db4a42b7d3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -851,11 +851,6 @@ struct hns_roce_caps {
 	enum cong_type	cong_type;
 };
 
-struct hns_roce_dfx_hw {
-	int (*query_cqc_info)(struct hns_roce_dev *hr_dev, u32 cqn,
-			      int *buffer);
-};
-
 enum hns_roce_device_state {
 	HNS_ROCE_DEVICE_STATE_INITED,
 	HNS_ROCE_DEVICE_STATE_RST_DOWN,
@@ -901,6 +896,7 @@ struct hns_roce_hw {
 	int (*init_eq)(struct hns_roce_dev *hr_dev);
 	void (*cleanup_eq)(struct hns_roce_dev *hr_dev);
 	int (*write_srqc)(struct hns_roce_srq *srq, void *mb_buf);
+	int (*query_cqc)(struct hns_roce_dev *hr_dev, u32 cqn, void *buffer);
 	const struct ib_device_ops *hns_roce_dev_ops;
 	const struct ib_device_ops *hns_roce_dev_srq_ops;
 };
@@ -962,7 +958,6 @@ struct hns_roce_dev {
 	void			*priv;
 	struct workqueue_struct *irq_workq;
 	struct work_struct ecc_work;
-	const struct hns_roce_dfx_hw *dfx;
 	u32 func_num;
 	u32 is_vf;
 	u32 cong_algo_tmpl_id;
@@ -1230,8 +1225,7 @@ u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u32 port, int gid_index);
 void hns_roce_handle_device_err(struct hns_roce_dev *hr_dev);
 int hns_roce_init(struct hns_roce_dev *hr_dev);
 void hns_roce_exit(struct hns_roce_dev *hr_dev);
-int hns_roce_fill_res_cq_entry(struct sk_buff *msg,
-			       struct ib_cq *ib_cq);
+int hns_roce_fill_res_cq_entry(struct sk_buff *msg, struct ib_cq *ib_cq);
 struct hns_user_mmap_entry *
 hns_roce_user_mmap_entry_insert(struct ib_ucontext *ucontext, u64 address,
 				size_t length,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 7e9853c6d412..eb14df9fe70c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5764,6 +5764,35 @@ static int hns_roce_v2_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 	return ret;
 }
 
+static int hns_roce_v2_query_cqc(struct hns_roce_dev *hr_dev, u32 cqn,
+				 void *buffer)
+{
+	struct hns_roce_v2_cq_context *context;
+	struct hns_roce_cmd_mailbox *mailbox;
+	int ret;
+
+	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	context = mailbox->buf;
+	ret = hns_roce_cmd_mbox(hr_dev, 0, mailbox->dma,
+				HNS_ROCE_CMD_QUERY_CQC, cqn);
+	if (ret) {
+		ibdev_err(&hr_dev->ib_dev,
+			  "failed to process cmd when querying CQ, ret = %d.\n",
+			  ret);
+		goto err_mailbox;
+	}
+
+	memcpy(buffer, context, sizeof(*context));
+
+err_mailbox:
+	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
+
+	return ret;
+}
+
 static void hns_roce_irq_work_handle(struct work_struct *work)
 {
 	struct hns_roce_work *irq_work =
@@ -6565,10 +6594,6 @@ static void hns_roce_v2_cleanup_eq_table(struct hns_roce_dev *hr_dev)
 	kfree(eq_table->eq);
 }
 
-static const struct hns_roce_dfx_hw hns_roce_dfx_hw_v2 = {
-	.query_cqc_info = hns_roce_v2_query_cqc_info,
-};
-
 static const struct ib_device_ops hns_roce_v2_dev_ops = {
 	.destroy_qp = hns_roce_v2_destroy_qp,
 	.modify_cq = hns_roce_v2_modify_cq,
@@ -6609,6 +6634,7 @@ static const struct hns_roce_hw hns_roce_hw_v2 = {
 	.init_eq = hns_roce_v2_init_eq_table,
 	.cleanup_eq = hns_roce_v2_cleanup_eq_table,
 	.write_srqc = hns_roce_v2_write_srqc,
+	.query_cqc = hns_roce_v2_query_cqc,
 	.hns_roce_dev_ops = &hns_roce_v2_dev_ops,
 	.hns_roce_dev_srq_ops = &hns_roce_v2_dev_srq_ops,
 };
@@ -6640,7 +6666,6 @@ static void hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 	hr_dev->is_vf = id->driver_data;
 	hr_dev->dev = &handle->pdev->dev;
 	hr_dev->hw = &hns_roce_hw_v2;
-	hr_dev->dfx = &hns_roce_dfx_hw_v2;
 	hr_dev->sdb_offset = ROCEE_DB_SQ_L_0_REG;
 	hr_dev->odb_offset = hr_dev->sdb_offset;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 4544a8775ce5..12d54bf6d954 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1460,9 +1460,6 @@ struct hns_roce_sccc_clr_done {
 	__le32 rsv[5];
 };
 
-int hns_roce_v2_query_cqc_info(struct hns_roce_dev *hr_dev, u32 cqn,
-			       int *buffer);
-
 static inline void hns_roce_write64(struct hns_roce_dev *hr_dev, __le32 val[2],
 				    void __iomem *dest)
 {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2_dfx.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2_dfx.c
deleted file mode 100644
index f7a75a7cda74..000000000000
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2_dfx.c
+++ /dev/null
@@ -1,34 +0,0 @@
-// SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-// Copyright (c) 2019 Hisilicon Limited.
-
-#include "hnae3.h"
-#include "hns_roce_device.h"
-#include "hns_roce_cmd.h"
-#include "hns_roce_hw_v2.h"
-
-int hns_roce_v2_query_cqc_info(struct hns_roce_dev *hr_dev, u32 cqn,
-			       int *buffer)
-{
-	struct hns_roce_v2_cq_context *cq_context;
-	struct hns_roce_cmd_mailbox *mailbox;
-	int ret;
-
-	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
-	if (IS_ERR(mailbox))
-		return PTR_ERR(mailbox);
-
-	cq_context = mailbox->buf;
-	ret = hns_roce_cmd_mbox(hr_dev, 0, mailbox->dma, HNS_ROCE_CMD_QUERY_CQC,
-				cqn);
-	if (ret) {
-		dev_err(hr_dev->dev, "QUERY cqc cmd process error\n");
-		goto err_mailbox;
-	}
-
-	memcpy(buffer, cq_context, sizeof(*cq_context));
-
-err_mailbox:
-	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
-
-	return ret;
-}
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index a4e7bb5bb194..bf5c7729d7e8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -529,7 +529,6 @@ static const struct ib_device_ops hns_roce_dev_ops = {
 	.destroy_ah = hns_roce_destroy_ah,
 	.destroy_cq = hns_roce_destroy_cq,
 	.disassociate_ucontext = hns_roce_disassociate_ucontext,
-	.fill_res_cq_entry = hns_roce_fill_res_cq_entry,
 	.get_dma_mr = hns_roce_get_dma_mr,
 	.get_link_layer = hns_roce_get_link_layer,
 	.get_port_immutable = hns_roce_port_immutable,
@@ -580,6 +579,10 @@ static const struct ib_device_ops hns_roce_dev_xrcd_ops = {
 	INIT_RDMA_OBJ_SIZE(ib_xrcd, hns_roce_xrcd, ibxrcd),
 };
 
+static const struct ib_device_ops hns_roce_dev_restrack_ops = {
+	.fill_res_cq_entry = hns_roce_fill_res_cq_entry,
+};
+
 static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 {
 	int ret;
@@ -619,6 +622,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 
 	ib_set_device_ops(ib_dev, hr_dev->hw->hns_roce_dev_ops);
 	ib_set_device_ops(ib_dev, &hns_roce_dev_ops);
+	ib_set_device_ops(ib_dev, &hns_roce_dev_restrack_ops);
 	for (i = 0; i < hr_dev->caps.num_ports; i++) {
 		if (!hr_dev->iboe.netdevs[i])
 			continue;
diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index 24a154d64630..83417be15d3f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_restrack.c
+++ b/drivers/infiniband/hw/hns/hns_roce_restrack.c
@@ -55,45 +55,34 @@ static int hns_roce_fill_cq(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
-int hns_roce_fill_res_cq_entry(struct sk_buff *msg,
-			       struct ib_cq *ib_cq)
+int hns_roce_fill_res_cq_entry(struct sk_buff *msg, struct ib_cq *ib_cq)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ib_cq->device);
 	struct hns_roce_cq *hr_cq = to_hr_cq(ib_cq);
-	struct hns_roce_v2_cq_context *context;
+	struct hns_roce_v2_cq_context context;
 	struct nlattr *table_attr;
 	int ret;
 
-	if (!hr_dev->dfx->query_cqc_info)
+	if (!hr_dev->hw->query_cqc)
 		return -EINVAL;
 
-	context = kzalloc(sizeof(struct hns_roce_v2_cq_context), GFP_KERNEL);
-	if (!context)
-		return -ENOMEM;
-
-	ret = hr_dev->dfx->query_cqc_info(hr_dev, hr_cq->cqn, (int *)context);
+	ret = hr_dev->hw->query_cqc(hr_dev, hr_cq->cqn, &context);
 	if (ret)
-		goto err;
+		return -EINVAL;
 
 	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_DRIVER);
-	if (!table_attr) {
-		ret = -EMSGSIZE;
-		goto err;
-	}
+	if (!table_attr)
+		return -EMSGSIZE;
 
-	if (hns_roce_fill_cq(msg, context)) {
-		ret = -EMSGSIZE;
-		goto err_cancel_table;
-	}
+	if (hns_roce_fill_cq(msg, &context))
+		goto err;
 
 	nla_nest_end(msg, table_attr);
-	kfree(context);
 
 	return 0;
 
-err_cancel_table:
-	nla_nest_cancel(msg, table_attr);
 err:
-	kfree(context);
-	return ret;
+	nla_nest_cancel(msg, table_attr);
+
+	return -EMSGSIZE;
 }
-- 
2.35.1



