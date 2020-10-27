Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA7E29B49A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790252AbgJ0PEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505068AbgJ0PEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:04:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2BFB22284;
        Tue, 27 Oct 2020 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811049;
        bh=HKyghNfICmJouEuqLHUmzl9xLcGZjPkpJfsDLiagvcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YykgV+Jy7M899ivMSfdlbzDy0D3K8Rm+kS2NX9wohwDHEgPTzALgHQyyQD19F/dVz
         6pcg5cAlORBxuCDO5PgeqY7rDagaWupUC0WGZoWCqYw7gA6O7rfPFaTpVMNBQkJryD
         gmN3x01stgX/xKrkYQX4uHjOAE7uU6GXb0/7aOxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 356/633] RDMA/qedr: Fix use of uninitialized field
Date:   Tue, 27 Oct 2020 14:51:39 +0100
Message-Id: <20201027135539.387513802@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index ccaedfd53e49e..679766abb436e 100644
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



