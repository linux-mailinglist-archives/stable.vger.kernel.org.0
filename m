Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256183FDBF7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345167AbhIAMqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345491AbhIAMoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFC9A6113D;
        Wed,  1 Sep 2021 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499922;
        bh=ElsBemGlIMO+UHw4Wl91WROpN2jG5NYv7kEO8jmBeko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xt/jrA3sHCkLg7xsD56jaunxZCNiO2yjL5+OA7dxzTIcwhOVo9sBpvhZkp6vzWuSL
         WhwMHG3bvWABUWLjnJzWi00mIjm2Xom0KF3RnEsb4NllPXfGfKPaH5IXJw/T/x4L32
         tRW1ICBg/D2qT1u6KIj6Yz3ntYxMdb6cWXx2ou1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 036/113] RDMA/uverbs: Track dmabuf memory regions
Date:   Wed,  1 Sep 2021 14:27:51 +0200
Message-Id: <20210901122303.190476246@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit f6018cc4602659e0e608849529704f3f41276c28 ]

The dmabuf memory registrations are missing the restrack handling and
hence do not appear in rdma tool.

Fixes: bfe0cc6eb249 ("RDMA/uverbs: Add uverbs command for dma-buf based MR registration")
Link: https://lore.kernel.org/r/20210812135607.6228-1-galpress@amazon.com
Signed-off-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index f782d5e1aa25..03e1db5d1e8c 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -249,6 +249,9 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_DMABUF_MR)(
 	mr->uobject = uobj;
 	atomic_inc(&pd->usecnt);
 
+	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
+	rdma_restrack_set_name(&mr->res, NULL);
+	rdma_restrack_add(&mr->res);
 	uobj->object = mr;
 
 	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_REG_DMABUF_MR_HANDLE);
-- 
2.30.2



