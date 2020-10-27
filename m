Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E4929B263
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750048AbgJ0Okq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761444AbgJ0Ojq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87469206B2;
        Tue, 27 Oct 2020 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809586;
        bh=nEk72TrHRG95IVHErBb/dy6NFNAX7Inln2ybtwljyts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzIxbHpwzfOGmM3fzHnZY/TrKS2qD5nhjMVJBA7COZ2LPQUt5CXkS8WS2UHMeiL1D
         MYah0T/KkwBlaDBcqXx+ixL98KYkTtHYd2Fx7dmkyuiXi4Fi4nP5B0xu0RMOXd+eo4
         /RvjfzySWvFJdZOV4Bj9INXQMduubPrTImXefZdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 219/408] RDMA/qedr: Fix use of uninitialized field
Date:   Tue, 27 Oct 2020 14:52:37 +0100
Message-Id: <20201027135505.249060857@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit a379ad54e55a12618cae7f6333fd1b3071de9606 ]

dev->attr.page_size_caps was used uninitialized when setting device
attributes

Fixes: ec72fce401c6 ("qedr: Add support for RoCE HW init")
Link: https://lore.kernel.org/r/20200902165741.8355-4-michal.kalderon@marvell.com
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 4494dab8c3d83..93040c994e2e3 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -601,7 +601,7 @@ static int qedr_set_device_attr(struct qedr_dev *dev)
 	qed_attr = dev->ops->rdma_query_device(dev->rdma_ctx);
 
 	/* Part 2 - check capabilities */
-	page_size = ~dev->attr.page_size_caps + 1;
+	page_size = ~qed_attr->page_size_caps + 1;
 	if (page_size > PAGE_SIZE) {
 		DP_ERR(dev,
 		       "Kernel PAGE_SIZE is %ld which is smaller than minimum page size (%d) required by qedr\n",
-- 
2.25.1



