Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106D229B8EC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802103AbgJ0Pph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801066AbgJ0Pi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9247207C4;
        Tue, 27 Oct 2020 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813106;
        bh=VTa9YoU+X8GpLPs8AMYwC+f7N1Mnv2nRE6zERsHPy4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFcLUL2PrOgzZJO5xvDl3p/6/eK8j7gE9aHXjHJkBc8FSYR//krAvgHQ9BoW/Qamh
         xrVE+sVVYIowAN5c1wjW50/nOSAy4fNbNLYc9bCLaDIEWBZbO34jcnT+GhEFz941u7
         m9GrW1a62ae8R/TizFPxjYvHd1kc8PSKFVtIFGWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 438/757] RDMA/qedr: Fix inline size returned for iWARP
Date:   Tue, 27 Oct 2020 14:51:28 +0100
Message-Id: <20201027135511.084916951@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit fbf58026b2256e9cd5f241a4801d79d3b2b7b89d ]

commit 59e8970b3798 ("RDMA/qedr: Return max inline data in QP query
result") changed query_qp max_inline size to return the max roce inline
size.  When iwarp was introduced, this should have been modified to return
the max inline size based on protocol.  This size is cached in the device
attributes

Fixes: 69ad0e7fe845 ("RDMA/qedr: Add support for iWARP in user space")
Link: https://lore.kernel.org/r/20200902165741.8355-8-michal.kalderon@marvell.com
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index c61bdf97231f8..db6be39834128 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2637,7 +2637,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	qp_attr->cap.max_recv_wr = qp->rq.max_wr;
 	qp_attr->cap.max_send_sge = qp->sq.max_sges;
 	qp_attr->cap.max_recv_sge = qp->rq.max_sges;
-	qp_attr->cap.max_inline_data = ROCE_REQ_MAX_INLINE_DATA_SIZE;
+	qp_attr->cap.max_inline_data = dev->attr.max_inline;
 	qp_init_attr->cap = qp_attr->cap;
 
 	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ROCE;
-- 
2.25.1



