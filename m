Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD183B21
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfHFVdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfHFVdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:33:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B09EB2089E;
        Tue,  6 Aug 2019 21:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127201;
        bh=eOG/9O+o+bwLlESBHf18XtsMhZvQveP+DSpLB/qDpY8=;
        h=From:To:Cc:Subject:Date:From;
        b=NCLWyyjitZoEq9sa6svsUDvj8BLsT2iGjFXTxPtUfc14RdMddOBmhPu4tsBJMmNCd
         m7jISFZfWq7qRsSppdhsXJj0K2wUlczIwxAwaomV0CJyvuGITE2eTEA7rMnx9paBNB
         8oYrUTIaqB2L0zWFf16C37l10RdaiN8j/UxpYALk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xi Wang <wangxi11@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 01/59] RDMA/hns: Fix sg offset non-zero issue
Date:   Tue,  6 Aug 2019 17:32:21 -0400
Message-Id: <20190806213319.19203-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
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

