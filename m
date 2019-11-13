Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1CDFA5AE
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbfKMCYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:24:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbfKMBwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0CF5222CA;
        Wed, 13 Nov 2019 01:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609927;
        bh=x+fI2AlsIAN1+ObAuhyPSaKXh5FMXJWkshgKRiW/kN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMkq3gFqi43FFnmeVRnhb4gTZKBBySx0usC+L3xDuuS6dDRPtMjMmdes3/upmMs5Z
         K6o0baYORWcU6jH1oNx962cB+M4ZgVrJF7ANClWPKrlj/kx19syDkn0swtusdF3jm8
         GLN2m2ineQXhoDbC2+EXCSdD7AwlliYj4vKxJQLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 073/209] RDMA/hns: Bugfix for reserved qp number
Date:   Tue, 12 Nov 2019 20:48:09 -0500
Message-Id: <20191113015025.9685-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a442b29e76119..7eb6e4bf8a090 100644
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

