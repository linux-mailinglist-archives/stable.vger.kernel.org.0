Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2382E3878
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgL1NKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731447AbgL1NKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 397B621D94;
        Mon, 28 Dec 2020 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161005;
        bh=JkZOmcCqO+Q/QpBu1t9axmGuSDVFeQ+pf9AU+6gf4iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r27uuiAUrB9B9ZKKI5YycIPbXjjXM3NoahmQ4PByxpehZraoWKmk9AaFBZJtkR6D/
         gef6pCXOUQG9+PFFsTUhtzCriV2QGczxp6lCvMjsmGdXSrfNWrrH0jXAfg05jH5cds
         dVhY82CUyBUkHA6Wu1ttZ8974EsXjB2qHsebW+/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 068/242] RDMA/bnxt_re: Set queue pair state when being queried
Date:   Mon, 28 Dec 2020 13:47:53 +0100
Message-Id: <20201228124908.032215806@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 53839b51a7671eeb3fb44d479d541cf3a0f2dd45 ]

The API for ib_query_qp requires the driver to set cur_qp_state on return,
add the missing set.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/20201021114952.38876-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ef9135aa392c1..ab218767bf05f 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1590,6 +1590,7 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		goto out;
 	}
 	qp_attr->qp_state = __to_ib_qp_state(qplib_qp->state);
+	qp_attr->cur_qp_state = __to_ib_qp_state(qplib_qp->cur_qp_state);
 	qp_attr->en_sqd_async_notify = qplib_qp->en_sqd_async_notify ? 1 : 0;
 	qp_attr->qp_access_flags = __to_ib_access_flags(qplib_qp->access);
 	qp_attr->pkey_index = qplib_qp->pkey_index;
-- 
2.27.0



