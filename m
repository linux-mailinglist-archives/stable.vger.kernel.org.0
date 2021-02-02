Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E130C894
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhBBRzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:55:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233714AbhBBOJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:09:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D3E065034;
        Tue,  2 Feb 2021 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273850;
        bh=AOUhKaCFn6u5J0d1fxZko9/uv+1GNJWTU8oqLm9ZLeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcvQiTK1YSdx+siynBFb766T9cCyJBVmIjI9/osTboBbzk51EbnnMg8lXcxxc/gZ5
         psQSJEHoOvO6lwDI1KlJ/ecqqiMSgS8emcENIoRmROtPgkuZL2hrGiY4PXSxxe20bz
         dXS67bJ1mkt8T8mXViBvobOlCMKJ5Z9ebvDUnVTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/32] RDMA/cxgb4: Fix the reported max_recv_sge value
Date:   Tue,  2 Feb 2021 14:38:47 +0100
Message-Id: <20210202132942.980853989@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit a372173bf314d374da4dd1155549d8ca7fc44709 ]

The max_recv_sge value is wrongly reported when calling query_qp, This is
happening due to a typo when assigning the max_recv_sge value, the value
of sq_max_sges was assigned instead of rq_max_sges.

Fixes: 3e5c02c9ef9a ("iw_cxgb4: Support query_qp() verb")
Link: https://lore.kernel.org/r/20210114191423.423529-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index bb45eb22ba1f5..36bdb04f8f018 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1976,7 +1976,7 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	init_attr->cap.max_send_wr = qhp->attr.sq_num_entries;
 	init_attr->cap.max_recv_wr = qhp->attr.rq_num_entries;
 	init_attr->cap.max_send_sge = qhp->attr.sq_max_sges;
-	init_attr->cap.max_recv_sge = qhp->attr.sq_max_sges;
+	init_attr->cap.max_recv_sge = qhp->attr.rq_max_sges;
 	init_attr->cap.max_inline_data = T4_MAX_SEND_INLINE;
 	init_attr->sq_sig_type = qhp->sq_sig_all ? IB_SIGNAL_ALL_WR : 0;
 	return 0;
-- 
2.27.0



