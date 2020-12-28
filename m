Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266FE2E3DB8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389620AbgL1OTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440595AbgL1OTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF57420731;
        Mon, 28 Dec 2020 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165130;
        bh=CRCtOdDamxHN7cTxpI9y41/INOW1ct7uRop5YKntB7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVcvSznlyguLKBP/lj0HYD9AgRS9es7idxll19PA6Z1/Y2iIXfIb4jCo5u5mc//wx
         GX+Vu+uJipgs4O81qtCOJAG9n28r0awjCe5pFvJjwyeYU52huyPaLPMuyo4u+iyGZC
         dcoCGOiS4IRVf/t5pzyBaxb5WsOmFX1Sc8GJmJZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/717] RDMA/hns: Normalization the judgment of some features
Date:   Mon, 28 Dec 2020 13:47:01 +0100
Message-Id: <20201228125041.230729369@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit 4ddeacf68a3dd05f346b63f4507e1032a15cc3cc ]

Whether to enable the these features should better depend on the enable
flags, not the value of related fields.

Fixes: 5c1f167af112 ("RDMA/hns: Init SRQ table for hip08")
Fixes: 3cb2c996c9dc ("RDMA/hns: Add support for SCCC in size of 64 Bytes")
Link: https://lore.kernel.org/r/1607650657-35992-3-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c  | 4 ++--
 drivers/infiniband/hw/hns/hns_roce_main.c | 8 ++++----
 drivers/infiniband/hw/hns/hns_roce_qp.c   | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 7487cf3d2c37a..66f9f036ef946 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1017,7 +1017,7 @@ void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
 
 void hns_roce_cleanup_hem(struct hns_roce_dev *hr_dev)
 {
-	if (hr_dev->caps.srqc_entry_sz)
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ)
 		hns_roce_cleanup_hem_table(hr_dev,
 					   &hr_dev->srq_table.table);
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->cq_table.table);
@@ -1027,7 +1027,7 @@ void hns_roce_cleanup_hem(struct hns_roce_dev *hr_dev)
 	if (hr_dev->caps.cqc_timer_entry_sz)
 		hns_roce_cleanup_hem_table(hr_dev,
 					   &hr_dev->cqc_timer_table);
-	if (hr_dev->caps.sccc_sz)
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL)
 		hns_roce_cleanup_hem_table(hr_dev,
 					   &hr_dev->qp_table.sccc_table);
 	if (hr_dev->caps.trrl_entry_sz)
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index a6277d1c36ba9..ae721fa61e0e4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -632,7 +632,7 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 		goto err_unmap_trrl;
 	}
 
-	if (hr_dev->caps.srqc_entry_sz) {
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ) {
 		ret = hns_roce_init_hem_table(hr_dev, &hr_dev->srq_table.table,
 					      HEM_TYPE_SRQC,
 					      hr_dev->caps.srqc_entry_sz,
@@ -644,7 +644,7 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 		}
 	}
 
-	if (hr_dev->caps.sccc_sz) {
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL) {
 		ret = hns_roce_init_hem_table(hr_dev,
 					      &hr_dev->qp_table.sccc_table,
 					      HEM_TYPE_SCCC,
@@ -688,11 +688,11 @@ err_unmap_qpc_timer:
 		hns_roce_cleanup_hem_table(hr_dev, &hr_dev->qpc_timer_table);
 
 err_unmap_ctx:
-	if (hr_dev->caps.sccc_sz)
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL)
 		hns_roce_cleanup_hem_table(hr_dev,
 					   &hr_dev->qp_table.sccc_table);
 err_unmap_srq:
-	if (hr_dev->caps.srqc_entry_sz)
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ)
 		hns_roce_cleanup_hem_table(hr_dev, &hr_dev->srq_table.table);
 
 err_unmap_cq:
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 800141ab643a3..ef1452215b17d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -286,7 +286,7 @@ static int alloc_qpc(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 		}
 	}
 
-	if (hr_dev->caps.sccc_sz) {
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL) {
 		/* Alloc memory for SCC CTX */
 		ret = hns_roce_table_get(hr_dev, &qp_table->sccc_table,
 					 hr_qp->qpn);
-- 
2.27.0



