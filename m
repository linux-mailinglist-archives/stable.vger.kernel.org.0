Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C69C12C3D8
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfL2RX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:23:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfL2RXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:23:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EA3D207FD;
        Sun, 29 Dec 2019 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640233;
        bh=Y6B4UcocmHODRSr5NfFddhSUmsIQrX+k0n9K1yXol78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqV1GTMy6k5OLz1u44kHQ80dszzvkP0MGZ9KEx0tLsiC3aDpTNu8f6Kn3tA5VqOc1
         Jl1QL9eBMbuURMEgJtZwXSb2vndYnhCoBqYhBCnY0t4GEIgOe3IHU5gamJSdemPCcN
         izOJkYDc1M4wSij0K0KOsJ7xjoUx9vYS1O6/+HmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 072/161] RDMA/qedr: Fix memory leak in user qp and mr
Date:   Sun, 29 Dec 2019 18:18:40 +0100
Message-Id: <20191229162421.774776080@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 24e412c1e00ebfe73619e6b88cbc26c2c7d41b85 ]

User QPs pbl's weren't freed properly.
MR pbls weren't freed properly.

Fixes: e0290cce6ac0 ("qedr: Add support for memory registeration verbs")
Link: https://lore.kernel.org/r/20191027200451.28187-5-michal.kalderon@marvell.com
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 7f4cc9336442..656e7c1a4449 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1343,6 +1343,14 @@ static void qedr_cleanup_user(struct qedr_dev *dev, struct qedr_qp *qp)
 	if (qp->urq.umem)
 		ib_umem_release(qp->urq.umem);
 	qp->urq.umem = NULL;
+
+	if (rdma_protocol_roce(&dev->ibdev, 1)) {
+		qedr_free_pbl(dev, &qp->usq.pbl_info, qp->usq.pbl_tbl);
+		qedr_free_pbl(dev, &qp->urq.pbl_info, qp->urq.pbl_tbl);
+	} else {
+		kfree(qp->usq.pbl_tbl);
+		kfree(qp->urq.pbl_tbl);
+	}
 }
 
 static int qedr_create_user_qp(struct qedr_dev *dev,
@@ -2331,8 +2339,8 @@ int qedr_dereg_mr(struct ib_mr *ib_mr)
 
 	dev->ops->rdma_free_tid(dev->rdma_ctx, mr->hw_mr.itid);
 
-	if ((mr->type != QEDR_MR_DMA) && (mr->type != QEDR_MR_FRMR))
-		qedr_free_pbl(dev, &mr->info.pbl_info, mr->info.pbl_table);
+	if (mr->type != QEDR_MR_DMA)
+		free_mr_info(dev, &mr->info);
 
 	/* it could be user registered memory. */
 	if (mr->umem)
-- 
2.20.1



