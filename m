Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A0E498A39
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbiAXTCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:02:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56764 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343972AbiAXS5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:57:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F2B361571;
        Mon, 24 Jan 2022 18:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2F0C340E5;
        Mon, 24 Jan 2022 18:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050663;
        bh=Qjjcms0dCT2MCUurdm3bONYYlLGmNucgLwcM9IbxerE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCpIuFmHfdgEV/6wEf6JytC1c0lRO8d7n+/UA4TOT7GFxRp+zuwi1p83Pbk6EPrnI
         HHNUSJL75ibyQWQKQLyH4RPETIAUPHxu1gs+Xlj/Lz8SaU9GwVSH4qOchzQfm18nl7
         OkkxRmsuzPP4ii83/j9Yzy0naN+NcLoXvts1UnQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 072/157] RDMA/cxgb4: Set queue pair state when being queried
Date:   Mon, 24 Jan 2022 19:42:42 +0100
Message-Id: <20220124183935.077018026@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
index 87bc7b0db892b..2eeac8401c927 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1974,6 +1974,7 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	memset(attr, 0, sizeof *attr);
 	memset(init_attr, 0, sizeof *init_attr);
 	attr->qp_state = to_ib_qp_state(qhp->attr.state);
+	attr->cur_qp_state = to_ib_qp_state(qhp->attr.state);
 	init_attr->cap.max_send_wr = qhp->attr.sq_num_entries;
 	init_attr->cap.max_recv_wr = qhp->attr.rq_num_entries;
 	init_attr->cap.max_send_sge = qhp->attr.sq_max_sges;
-- 
2.34.1



