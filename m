Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE2424B27C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgHTJbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgHTJa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B4420724;
        Thu, 20 Aug 2020 09:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915857;
        bh=RNUcBcNTkD1GFy4fHwktE1gUYbc2wxtI+X1AHVFZdjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gC8Zicp+S/EiipPYosB3tPN48yidcc/BY6qSibYHG1bsf2gk7oCROiYAEpqeVpJtV
         ipT0Ge8cJbqAQXLArX9lg86LYDY2czI51GgrKApuByiJU74MwHfQlpDt6PfZB8zL71
         40Qf+RWoRn4f472U7pCVw8FW3dl2Umviszu7vX40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 129/232] IB/uverbs: Set IOVA on IB MR in uverbs layer
Date:   Thu, 20 Aug 2020 11:19:40 +0200
Message-Id: <20200820091619.064879283@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

[ Upstream commit 04c0a5fcfcf65aade2fb238b6336445f1a99b646 ]

Set IOVA on IB MR in uverbs layer to let all drivers have it, this
includes both reg/rereg MR flows.
As part of this change cleaned-up this setting from the drivers that
already did it by themselves in their user flows.

Fixes: e6f0330106f4 ("mlx4_ib: set user mr attributes in struct ib_mr")
Link: https://lore.kernel.org/r/20200630093916.332097-3-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 4 ++++
 drivers/infiniband/hw/cxgb4/mem.c    | 1 -
 drivers/infiniband/hw/mlx4/mr.c      | 1 -
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b48b3f6e632d4..557644dcc9237 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -770,6 +770,7 @@ static int ib_uverbs_reg_mr(struct uverbs_attr_bundle *attrs)
 	mr->uobject = uobj;
 	atomic_inc(&pd->usecnt);
 	mr->res.type = RDMA_RESTRACK_MR;
+	mr->iova = cmd.hca_va;
 	rdma_restrack_uadd(&mr->res);
 
 	uobj->object = mr;
@@ -861,6 +862,9 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 		atomic_dec(&old_pd->usecnt);
 	}
 
+	if (cmd.flags & IB_MR_REREG_TRANS)
+		mr->iova = cmd.hca_va;
+
 	memset(&resp, 0, sizeof(resp));
 	resp.lkey      = mr->lkey;
 	resp.rkey      = mr->rkey;
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 962dc97a8ff2b..1e4f4e5255980 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -399,7 +399,6 @@ static int finish_mem_reg(struct c4iw_mr *mhp, u32 stag)
 	mmid = stag >> 8;
 	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
 	mhp->ibmr.length = mhp->attr.len;
-	mhp->ibmr.iova = mhp->attr.va_fbo;
 	mhp->ibmr.page_size = 1U << (mhp->attr.page_size + 12);
 	pr_debug("mmid 0x%x mhp %p\n", mmid, mhp);
 	return xa_insert_irq(&mhp->rhp->mrs, mmid, mhp, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 7e0b205c05eb3..d7c78f841d2f5 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -439,7 +439,6 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.length = length;
-	mr->ibmr.iova = virt_addr;
 	mr->ibmr.page_size = 1U << shift;
 
 	return &mr->ibmr;
-- 
2.25.1



