Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE4F29C3CF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509119AbgJ0OYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758871AbgJ0OYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79FF12072D;
        Tue, 27 Oct 2020 14:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808681;
        bh=WEf79vf/0nc9xYlODIVbqu8QMJq+zP7Kk1w0QgPmCVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZArsfe/1Mp6/EjKNnVU/CMrds3STVRaC3tVWSvo5/1jHvq3S5st38YSz3UQ1UKTP
         iK5kxu+i0LzPo6K4nshIahcga2UMYrwyAXeVz91BCL8MJ0QTXbIIDHgMwsT1pJJPB6
         m7KoBQCUCm9n01oVf1N82kU0iWnaO5ABNTYAgbz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/264] RDMA/qedr: Fix inline size returned for iWARP
Date:   Tue, 27 Oct 2020 14:53:21 +0100
Message-Id: <20201027135437.406645330@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 7b26afc7fef35..f847f0a9f204d 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2522,7 +2522,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	qp_attr->cap.max_recv_wr = qp->rq.max_wr;
 	qp_attr->cap.max_send_sge = qp->sq.max_sges;
 	qp_attr->cap.max_recv_sge = qp->rq.max_sges;
-	qp_attr->cap.max_inline_data = ROCE_REQ_MAX_INLINE_DATA_SIZE;
+	qp_attr->cap.max_inline_data = dev->attr.max_inline;
 	qp_init_attr->cap = qp_attr->cap;
 
 	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ROCE;
-- 
2.25.1



