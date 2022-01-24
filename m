Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7221499526
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392275AbiAXUvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390235AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6BCC0613A6;
        Mon, 24 Jan 2022 11:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0B8960B56;
        Mon, 24 Jan 2022 19:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25BBC340E5;
        Mon, 24 Jan 2022 19:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054143;
        bh=PgU5/HgFGDp/MIMNYfxiJlEP6GPrvT3oRWfVLrJRIoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdzTBkhkguYTa89AYOnKMM3lWMalR5riuRh0svrELFsEjviCqOmQoTxs3nGaqfqja
         shl/EC48zPmR5KTXn5WJfbMEHsrNQj39cZzgK7t6pZn0kINJI1nh3J9oFRsqKXeaaT
         iSXBP6VZhdUUd6g+KmVqiqQDX0iu5W6pxUM1YrSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/563] RDMA/cxgb4: Set queue pair state when being queried
Date:   Mon, 24 Jan 2022 19:40:58 +0100
Message-Id: <20220124184034.578172665@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit e375b9c92985e409c4bb95dd43d34915ea7f5e28 ]

The API for ib_query_qp requires the driver to set cur_qp_state on return,
add the missing set.

Fixes: 67bbc05512d8 ("RDMA/cxgb4: Add query_qp support")
Link: https://lore.kernel.org/r/20211220152530.60399-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 861e19fdfeb46..12e5461581cb4 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -2469,6 +2469,7 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	memset(attr, 0, sizeof(*attr));
 	memset(init_attr, 0, sizeof(*init_attr));
 	attr->qp_state = to_ib_qp_state(qhp->attr.state);
+	attr->cur_qp_state = to_ib_qp_state(qhp->attr.state);
 	init_attr->cap.max_send_wr = qhp->attr.sq_num_entries;
 	init_attr->cap.max_recv_wr = qhp->attr.rq_num_entries;
 	init_attr->cap.max_send_sge = qhp->attr.sq_max_sges;
-- 
2.34.1



