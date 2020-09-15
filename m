Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D9326B59F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgIOXs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIOOdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FBE323BED;
        Tue, 15 Sep 2020 14:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179900;
        bh=IeJLKUT8VW1wu2rKMjdTyQF5OIjbyfww4mhjyWpYV5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbAGdXvlbiCNe+9gPPMKJB6uJkD5s6/2hXJP0nrwDTFNJmTR7hv9PBR6bZgXL5Cqu
         xRPVmmRJv/ktWBh26DCPxgX5lig26gxpRN0zqjIjHcdGdaGLYRa5NrO2wzbljhHdDZ
         vdMlZjNhUtGWdl2RSZ48ZjoHFIvIwgQ9J9N1Pz5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 022/177] RDMA/bnxt_re: Remove the qp from list only if the qp destroy succeeds
Date:   Tue, 15 Sep 2020 16:11:33 +0200
Message-Id: <20200915140654.713479340@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 097a9d23b7250355b182c5fd47dd4c55b22b1c33 ]

Driver crashes when destroy_qp is re-tried because of an error
returned. This is because the qp entry was removed from the qp list during
the first call.

Remove qp from the list only if destroy_qp returns success.

The driver will still trigger a WARN_ON due to the memory leaking, but at
least it isn't corrupting memory too.

Fixes: 8dae419f9ec7 ("RDMA/bnxt_re: Refactor queue pair creation code")
Link: https://lore.kernel.org/r/1598292876-26529-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index dad38aa06403d..cb6e873039df5 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -752,12 +752,6 @@ static int bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
 	gsi_sqp = rdev->gsi_ctx.gsi_sqp;
 	gsi_sah = rdev->gsi_ctx.gsi_sah;
 
-	/* remove from active qp list */
-	mutex_lock(&rdev->qp_lock);
-	list_del(&gsi_sqp->list);
-	mutex_unlock(&rdev->qp_lock);
-	atomic_dec(&rdev->qp_count);
-
 	ibdev_dbg(&rdev->ibdev, "Destroy the shadow AH\n");
 	bnxt_qplib_destroy_ah(&rdev->qplib_res,
 			      &gsi_sah->qplib_ah,
@@ -772,6 +766,12 @@ static int bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
 	}
 	bnxt_qplib_free_qp_res(&rdev->qplib_res, &gsi_sqp->qplib_qp);
 
+	/* remove from active qp list */
+	mutex_lock(&rdev->qp_lock);
+	list_del(&gsi_sqp->list);
+	mutex_unlock(&rdev->qp_lock);
+	atomic_dec(&rdev->qp_count);
+
 	kfree(rdev->gsi_ctx.sqp_tbl);
 	kfree(gsi_sah);
 	kfree(gsi_sqp);
@@ -792,11 +792,6 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata)
 	unsigned int flags;
 	int rc;
 
-	mutex_lock(&rdev->qp_lock);
-	list_del(&qp->list);
-	mutex_unlock(&rdev->qp_lock);
-	atomic_dec(&rdev->qp_count);
-
 	bnxt_qplib_flush_cqn_wq(&qp->qplib_qp);
 
 	rc = bnxt_qplib_destroy_qp(&rdev->qplib_res, &qp->qplib_qp);
@@ -819,6 +814,11 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata)
 			goto sh_fail;
 	}
 
+	mutex_lock(&rdev->qp_lock);
+	list_del(&qp->list);
+	mutex_unlock(&rdev->qp_lock);
+	atomic_dec(&rdev->qp_count);
+
 	ib_umem_release(qp->rumem);
 	ib_umem_release(qp->sumem);
 
-- 
2.25.1



