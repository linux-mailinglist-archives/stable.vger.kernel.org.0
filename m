Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F03106D5E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbfKVK7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730392AbfKVK7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5838120706;
        Fri, 22 Nov 2019 10:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420371;
        bh=0JVkLH877n/CH3V+OXPAhcvJUXONV4RbYhcxy9/3xPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOz+FxGBF79q3ziXsvRuNh9bjwQ3KNO2ZwwsiedZsuHf+uX8ZFpyuB5la9I7yA1iE
         9bp6TT+GRqsMk3AEphYvyoVaj8n3wmYSdS3g2r77nI5slkmojZZwV2cd2gdEplwDzz
         2RQGDbJzAbAsceRRTi5BfbWyn4vD11w/Pd6uGWWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/220] RDMA/hns: Bugfix for reserved qp number
Date:   Fri, 22 Nov 2019 11:27:30 +0100
Message-Id: <20191122100918.645504181@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 06ef0ee4b569101f3a07ce08335dbf29fd1404ef ]

It needs to include two special qps for every port. The hip08 have four
ports and the all reserved qp numbers are eight.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  1 +
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 10 ++++++++--
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 9a24fd0ee3e78..0bf9949842177 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -666,6 +666,7 @@ struct hns_roce_caps {
 	u32		max_sq_inline;	/* 32 */
 	u32		max_rq_sg;	/* 2 */
 	int		num_qps;	/* 256k */
+	int             reserved_qps;
 	u32		max_wqes;	/* 16k */
 	u32		max_sq_desc_sz;	/* 64 */
 	u32		max_rq_desc_sz;	/* 64 */
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 3f8e13190aa71..4e1465dbad91c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1222,6 +1222,7 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->reserved_mrws	= 1;
 	caps->reserved_uars	= 0;
 	caps->reserved_cqs	= 0;
+	caps->reserved_qps	= HNS_ROCE_V2_RSV_QPS;
 
 	caps->qpc_ba_pg_sz	= 0;
 	caps->qpc_buf_pg_sz	= 0;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 14aa308befef9..cd276b0b16471 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -78,6 +78,7 @@
 #define HNS_ROCE_INVALID_LKEY			0x100
 #define HNS_ROCE_CMQ_TX_TIMEOUT			30000
 #define HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE	2
+#define HNS_ROCE_V2_RSV_QPS			8
 
 #define HNS_ROCE_CONTEXT_HOP_NUM		1
 #define HNS_ROCE_MTT_HOP_NUM			1
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 2fa4fb17f6d3c..cb926ced40219 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1106,14 +1106,20 @@ int hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
 	int reserved_from_top = 0;
+	int reserved_from_bot;
 	int ret;
 
 	spin_lock_init(&qp_table->lock);
 	INIT_RADIX_TREE(&hr_dev->qp_table_tree, GFP_ATOMIC);
 
-	/* A port include two SQP, six port total 12 */
+	/* In hw v1, a port include two SQP, six ports total 12 */
+	if (hr_dev->caps.max_sq_sg <= 2)
+		reserved_from_bot = SQP_NUM;
+	else
+		reserved_from_bot = hr_dev->caps.reserved_qps;
+
 	ret = hns_roce_bitmap_init(&qp_table->bitmap, hr_dev->caps.num_qps,
-				   hr_dev->caps.num_qps - 1, SQP_NUM,
+				   hr_dev->caps.num_qps - 1, reserved_from_bot,
 				   reserved_from_top);
 	if (ret) {
 		dev_err(hr_dev->dev, "qp bitmap init failed!error=%d\n",
-- 
2.20.1



