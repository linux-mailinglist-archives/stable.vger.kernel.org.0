Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D612E6625
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388712AbgL1NY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388710AbgL1NYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:24:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32912208BA;
        Mon, 28 Dec 2020 13:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161847;
        bh=RoUZ9kKXFxKG8Fqtw0YjNDsguWd6fxBG9IAQ6XZfCkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/PvDIeKDKMErZZh+KrfYDJKMg3B6DMr6Q3di7Ieuyp4I8tjThDQ9Qla7VmpqeFg3
         e6HbUoB9GH8fOFQHPc+2uD6n9rmGTrxro41sRSPS8GYbONdtEYIDtah6vburStR5JY
         AlNEgneIXC9LOoEFwnNVB9nhAjIGxpIPznZFYOIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/346] RDMA/bnxt_re: Set queue pair state when being queried
Date:   Mon, 28 Dec 2020 13:47:02 +0100
Message-Id: <20201228124924.762685545@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 957da3ffe593c..f8c9caa8aad6d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1838,6 +1838,7 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		goto out;
 	}
 	qp_attr->qp_state = __to_ib_qp_state(qplib_qp->state);
+	qp_attr->cur_qp_state = __to_ib_qp_state(qplib_qp->cur_qp_state);
 	qp_attr->en_sqd_async_notify = qplib_qp->en_sqd_async_notify ? 1 : 0;
 	qp_attr->qp_access_flags = __to_ib_access_flags(qplib_qp->access);
 	qp_attr->pkey_index = qplib_qp->pkey_index;
-- 
2.27.0



