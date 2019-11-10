Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6AF6602
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfKJDKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbfKJCn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 698AA21655;
        Sun, 10 Nov 2019 02:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353835;
        bh=DirF3562ki04v3whOy7FclNbip8VciH5wUPKy5FLgs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iec/aUPwi3HQ0mAUm4gYEl/kua9d7yQZOmuH4HQ5fxDBaevKKe327OTKuMGxaqZNU
         HxUFIUgeHqeEiH3oiLAQuyCUvMNz5xGXFybsZWamP5JS9dIHbXTaE1VM8Qv2QB9Sgx
         mz9F/JKM3mAYvuDJzftsTQ0LjLnTvCQaCqnrxeYw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 126/191] iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs
Date:   Sat,  9 Nov 2019 21:39:08 -0500
Message-Id: <20191110024013.29782-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 1b571086e869395b6a11ab24186b0104fe05c057 ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/infiniband/hw/cxgb4/qp.c:287:8: warning: implicit conversion
from enumeration type 'enum t4_bar2_qtype' to different enumeration type
'enum cxgb4_bar2_qtype' [-Wenum-conversion]
                                                 T4_BAR2_QTYPE_EGRESS,
                                                 ^~~~~~~~~~~~~~~~~~~~

c4iw_bar2_addrs expects a value from enum cxgb4_bar2_qtype so use the
corresponding values from that type so Clang is satisfied without changing
the meaning of the code.

T4_BAR2_QTYPE_EGRESS = CXGB4_BAR2_QTYPE_EGRESS = 0
T4_BAR2_QTYPE_INGRESS = CXGB4_BAR2_QTYPE_INGRESS = 1

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 2 +-
 drivers/infiniband/hw/cxgb4/qp.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 6d30427940942..1fd8798d91a73 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -161,7 +161,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	cq->gts = rdev->lldi.gts_reg;
 	cq->rdev = rdev;
 
-	cq->bar2_va = c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRESS,
+	cq->bar2_va = c4iw_bar2_addrs(rdev, cq->cqid, CXGB4_BAR2_QTYPE_INGRESS,
 				      &cq->bar2_qid,
 				      user ? &cq->bar2_pa : NULL);
 	if (user && !cq->bar2_pa) {
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 347fe18b1a41c..a9e3a11bea54a 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -279,12 +279,13 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 
 	wq->db = rdev->lldi.db_reg;
 
-	wq->sq.bar2_va = c4iw_bar2_addrs(rdev, wq->sq.qid, T4_BAR2_QTYPE_EGRESS,
+	wq->sq.bar2_va = c4iw_bar2_addrs(rdev, wq->sq.qid,
+					 CXGB4_BAR2_QTYPE_EGRESS,
 					 &wq->sq.bar2_qid,
 					 user ? &wq->sq.bar2_pa : NULL);
 	if (need_rq)
 		wq->rq.bar2_va = c4iw_bar2_addrs(rdev, wq->rq.qid,
-						 T4_BAR2_QTYPE_EGRESS,
+						 CXGB4_BAR2_QTYPE_EGRESS,
 						 &wq->rq.bar2_qid,
 						 user ? &wq->rq.bar2_pa : NULL);
 
@@ -2572,7 +2573,7 @@ static int alloc_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
 	memset(wq->queue, 0, wq->memsize);
 	pci_unmap_addr_set(wq, mapping, wq->dma_addr);
 
-	wq->bar2_va = c4iw_bar2_addrs(rdev, wq->qid, T4_BAR2_QTYPE_EGRESS,
+	wq->bar2_va = c4iw_bar2_addrs(rdev, wq->qid, CXGB4_BAR2_QTYPE_EGRESS,
 				      &wq->bar2_qid,
 			user ? &wq->bar2_pa : NULL);
 
-- 
2.20.1

