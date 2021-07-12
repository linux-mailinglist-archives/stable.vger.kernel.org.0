Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03E13C5367
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352382AbhGLHym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350318AbhGLHuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C455C613EF;
        Mon, 12 Jul 2021 07:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075878;
        bh=oqKVGSqsCNGCEmFPZw5W9mOojvwxldUYS7Omr2wh9ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/tBtC9ILwFOGO73/IaZuYMhx+PV0VdkTekdBRkQA/moTLHW5nmP93pbhuOKuv7D8
         Ot0sdjgu3PH5EKmuLRcbdfhtJBgLHdPK8rFojXBVqYx8UAsRokSTUE0oVw5yMXPTPc
         Y/Jl+B7NR/eeV83H9dzA9nAT1CLKHtMn6vE6Bcok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixian Liu <liuyixian@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 403/800] RDMA/hns: Remove the condition of light load for posting DWQE
Date:   Mon, 12 Jul 2021 08:07:06 +0200
Message-Id: <20210712061010.049938833@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

[ Upstream commit 591f762b2750c628df9412d1c795b56e83a34b3e ]

Even in the case of heavy load, direct WQE can still be posted. The
hardware will decide whether to drop the DWQE or not. Thus, the limit
needs to be removed.

Fixes: 01584a5edcc4 ("RDMA/hns: Add support of direct wqe")
Link: https://lore.kernel.org/r/1619593950-29414-1-git-send-email-liweihang@huawei.com
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 7652dafe32ec..49bb4f51466c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -791,8 +791,7 @@ out:
 		qp->sq.head += nreq;
 		qp->next_sge = sge_idx;
 
-		if (nreq == 1 && qp->sq.head == qp->sq.tail + 1 &&
-		    (qp->en_flags & HNS_ROCE_QP_CAP_DIRECT_WQE))
+		if (nreq == 1 && (qp->en_flags & HNS_ROCE_QP_CAP_DIRECT_WQE))
 			write_dwqe(hr_dev, qp, wqe);
 		else
 			update_sq_db(hr_dev, qp);
-- 
2.30.2



