Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DDC101795
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfKSFmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729536AbfKSFmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CEDE21783;
        Tue, 19 Nov 2019 05:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142135;
        bh=DirF3562ki04v3whOy7FclNbip8VciH5wUPKy5FLgs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmEmPdaeSKL/bWhf0yhAVc7+G22eHo5fsB0Crp3ZxF47OtsHSBURskiUomutapqTP
         1yY5/7gsgdU5lYXMVT86R0rKoQ5opNy6N+p4sWpZV9+ToAD+KkcpNuT4BoD/I/8Vug
         FjumKXzb3CA7X0u+m6kx0ZIuEMa9KS7i9ZmGkuPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 360/422] iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs
Date:   Tue, 19 Nov 2019 06:19:17 +0100
Message-Id: <20191119051422.343630177@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



