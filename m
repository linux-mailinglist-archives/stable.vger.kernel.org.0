Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB9130C0AB
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhBBOD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233487AbhBBOC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:02:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BAA464F7B;
        Tue,  2 Feb 2021 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273647;
        bh=yauYUa5OcB0J7FDh4uHAC5VmXWfWJTbgKJD2EDOTMDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gjlmGDcLqgCh2EWtBfQjTUm+zmRZEXAunni3BIO3OmBZEAZkhrZ4NpXrPQbawLq0
         IeRhiSuy5WETLFH7U+oWj0oN1Vu+IqTRmChfIxFmLOJ6srJke9laksR66rDcvjqQRo
         EdOk0bhlbifLIR/IZujFppnpl88N8qzko0nEgSYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/61] RDMA/cxgb4: Fix the reported max_recv_sge value
Date:   Tue,  2 Feb 2021 14:38:18 +0100
Message-Id: <20210202132948.160703572@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
index 89ac2f9ae6dd8..e7472f0da59d2 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -2471,7 +2471,7 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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



