Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCEE3C4DAB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbhGLHNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240099AbhGLHMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC7E610FA;
        Mon, 12 Jul 2021 07:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073794;
        bh=7ZGpz8llyWui7Z9BbsoSQs+FUFVD67qfNy5qg8f+6q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghHzkSQaqfqcCmTSHy7K6eUsW2V42GO1gFO83kzAt/JTdbVjZnIjRoQ0zOoN02KMz
         BExhr4EQbVi0nBv6OjdoXYAf190vP2C350NFsVEFqD6OA88cjhv/Cuo4jGTFe/ktSu
         qY2T1CKnqOB/27hyORx26zUjjtZeSzJ6glCAemYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixian Liu <liuyixian@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 363/700] RDMA/hns: Remove the condition of light load for posting DWQE
Date:   Mon, 12 Jul 2021 08:07:26 +0200
Message-Id: <20210712061014.994788047@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index ad3cee54140e..3344b80ecf04 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -750,8 +750,7 @@ out:
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



