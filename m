Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C1399AC4
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390398AbfHVRIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390389AbfHVRIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:35 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E27C22341D;
        Thu, 22 Aug 2019 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493714;
        bh=eOG/9O+o+bwLlESBHf18XtsMhZvQveP+DSpLB/qDpY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXrghtNn00cNXOfzyR44VYE1acCtokqCNozInIR7wIHFzQoB5yATZrk2L+lR5J9FN
         QtdYu+Cx0589WRmzFjm9yU5Nqg08EgNH0P0CLuHx6i4ZXFoFnV/qM1IN0KdfqMQaR5
         HqxXgTVYVS0Z7Gt71MIqNsg8i4G627LmwJGlOASg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xi Wang <wangxi11@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 037/135] RDMA/hns: Fix sg offset non-zero issue
Date:   Thu, 22 Aug 2019 13:06:33 -0400
Message-Id: <20190822170811.13303-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 60c3becfd1a138fdcfe48f2a5ef41ef0078d481e ]

When run perftest in many times, the system will report a BUG as follows:

   BUG: Bad rss-counter state mm:(____ptrval____) idx:0 val:-1
   BUG: Bad rss-counter state mm:(____ptrval____) idx:1 val:1

We tested with different kernel version and found it started from the the
following commit:

commit d10bcf947a3e ("RDMA/umem: Combine contiguous PAGE_SIZE regions in
SGEs")

In this commit, the sg->offset is always 0 when sg_set_page() is called in
ib_umem_get() and the drivers are not allowed to change the sgl, otherwise
it will get bad page descriptor when unfolding SGEs in __ib_umem_release()
as sg_page_count() will get wrong result while sgl->offset is not 0.

However, there is a weird sgl usage in the current hns driver, the driver
modified sg->offset after calling ib_umem_get(), which caused we iterate
past the wrong number of pages in for_each_sg_page iterator.

This patch fixes it by correcting the non-standard sgl usage found in the
hns_roce_db_map_user() function.

Fixes: d10bcf947a3e ("RDMA/umem: Combine contiguous PAGE_SIZE regions in SGEs")
Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Link: https://lore.kernel.org/r/1562808737-45723-1-git-send-email-oulijun@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_db.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
index 0c6c1fe87705c..d60453e98db7c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_db.c
+++ b/drivers/infiniband/hw/hns/hns_roce_db.c
@@ -12,13 +12,15 @@ int hns_roce_db_map_user(struct hns_roce_ucontext *context,
 			 struct ib_udata *udata, unsigned long virt,
 			 struct hns_roce_db *db)
 {
+	unsigned long page_addr = virt & PAGE_MASK;
 	struct hns_roce_user_db_page *page;
+	unsigned int offset;
 	int ret = 0;
 
 	mutex_lock(&context->page_mutex);
 
 	list_for_each_entry(page, &context->page_list, list)
-		if (page->user_virt == (virt & PAGE_MASK))
+		if (page->user_virt == page_addr)
 			goto found;
 
 	page = kmalloc(sizeof(*page), GFP_KERNEL);
@@ -28,8 +30,8 @@ int hns_roce_db_map_user(struct hns_roce_ucontext *context,
 	}
 
 	refcount_set(&page->refcount, 1);
-	page->user_virt = (virt & PAGE_MASK);
-	page->umem = ib_umem_get(udata, virt & PAGE_MASK, PAGE_SIZE, 0, 0);
+	page->user_virt = page_addr;
+	page->umem = ib_umem_get(udata, page_addr, PAGE_SIZE, 0, 0);
 	if (IS_ERR(page->umem)) {
 		ret = PTR_ERR(page->umem);
 		kfree(page);
@@ -39,10 +41,9 @@ int hns_roce_db_map_user(struct hns_roce_ucontext *context,
 	list_add(&page->list, &context->page_list);
 
 found:
-	db->dma = sg_dma_address(page->umem->sg_head.sgl) +
-		  (virt & ~PAGE_MASK);
-	page->umem->sg_head.sgl->offset = virt & ~PAGE_MASK;
-	db->virt_addr = sg_virt(page->umem->sg_head.sgl);
+	offset = virt - page_addr;
+	db->dma = sg_dma_address(page->umem->sg_head.sgl) + offset;
+	db->virt_addr = sg_virt(page->umem->sg_head.sgl) + offset;
 	db->u.user_page = page;
 	refcount_inc(&page->refcount);
 
-- 
2.20.1

