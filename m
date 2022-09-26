Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8443C5EA1A9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbiIZKzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbiIZKyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C915A2CE;
        Mon, 26 Sep 2022 03:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06D11609FB;
        Mon, 26 Sep 2022 10:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC508C433D6;
        Mon, 26 Sep 2022 10:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188069;
        bh=0bcvpj+nDJF5b0kabJCU70IRobcvmtfUiQO6/T/pPwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlCemyB/mGMPgAoiwX2sf6KlJCTj0LWncYH96u4PJ67H/eMsFsjnqHisBYwIfSJeI
         h8GzSbapuxECAUKImxab2zEQ72noZg95HXE/Gou+D1CQ7Bn96M5nwENGAwllAGIjMK
         nT3dtrC8ZBGDpQIUcpRHELCuJRYOu9wFstxZhPSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/141] vfio/type1: Prepare for batched pinning with struct vfio_batch
Date:   Mon, 26 Sep 2022 12:10:57 +0200
Message-Id: <20220926100755.635418577@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 4b6c33b3229678e38a6b0bbd4367d4b91366b523 ]

Get ready to pin more pages at once with struct vfio_batch, which
represents a batch of pinned pages.

The struct has a fallback page pointer to avoid two unlikely scenarios:
pointlessly allocating a page if disable_hugepages is enabled or failing
the whole pinning operation if the kernel can't allocate memory.

vaddr_get_pfn() becomes vaddr_get_pfns() to prepare for handling
multiple pages, though for now only one page is stored in the pages
array.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: 873aefb376bb ("vfio/type1: Unpin zero pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 71 +++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2d26244f9c32..0c15cffd5ef1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -98,6 +98,12 @@ struct vfio_dma {
 	unsigned long		*bitmap;
 };
 
+struct vfio_batch {
+	struct page		**pages;	/* for pin_user_pages_remote */
+	struct page		*fallback_page; /* if pages alloc fails */
+	int			capacity;	/* length of pages array */
+};
+
 struct vfio_group {
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
@@ -428,6 +434,31 @@ static int put_pfn(unsigned long pfn, int prot)
 	return 0;
 }
 
+#define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
+
+static void vfio_batch_init(struct vfio_batch *batch)
+{
+	if (unlikely(disable_hugepages))
+		goto fallback;
+
+	batch->pages = (struct page **) __get_free_page(GFP_KERNEL);
+	if (!batch->pages)
+		goto fallback;
+
+	batch->capacity = VFIO_BATCH_MAX_CAPACITY;
+	return;
+
+fallback:
+	batch->pages = &batch->fallback_page;
+	batch->capacity = 1;
+}
+
+static void vfio_batch_fini(struct vfio_batch *batch)
+{
+	if (batch->capacity == VFIO_BATCH_MAX_CAPACITY)
+		free_page((unsigned long)batch->pages);
+}
+
 static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
@@ -468,10 +499,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
  * Returns the positive number of pfns successfully obtained or a negative
  * error code.
  */
-static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
-			 int prot, unsigned long *pfn)
+static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
+			  long npages, int prot, unsigned long *pfn,
+			  struct page **pages)
 {
-	struct page *page[1];
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
 	int ret;
@@ -480,10 +511,10 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
-	ret = pin_user_pages_remote(mm, vaddr, 1, flags | FOLL_LONGTERM,
-				    page, NULL, NULL);
-	if (ret == 1) {
-		*pfn = page_to_pfn(page[0]);
+	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
+				    pages, NULL, NULL);
+	if (ret > 0) {
+		*pfn = page_to_pfn(pages[0]);
 		goto done;
 	}
 
@@ -516,7 +547,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
  */
 static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
-				  unsigned long limit)
+				  unsigned long limit, struct vfio_batch *batch)
 {
 	unsigned long pfn = 0;
 	long ret, pinned = 0, lock_acct = 0;
@@ -527,7 +558,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	if (!current->mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, pfn_base,
+			     batch->pages);
 	if (ret < 0)
 		return ret;
 
@@ -554,7 +586,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	/* Lock all the consecutive pages from pfn_base */
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
-		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
+		ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, &pfn,
+				     batch->pages);
 		if (ret < 0)
 			break;
 
@@ -617,6 +650,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
+	struct page *pages[1];
 	struct mm_struct *mm;
 	int ret;
 
@@ -624,7 +658,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
 	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
@@ -1270,15 +1304,19 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 {
 	dma_addr_t iova = dma->iova;
 	unsigned long vaddr = dma->vaddr;
+	struct vfio_batch batch;
 	size_t size = map_size;
 	long npage;
 	unsigned long pfn, limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret = 0;
 
+	vfio_batch_init(&batch);
+
 	while (size) {
 		/* Pin a contiguous chunk of memory */
 		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
-					      size >> PAGE_SHIFT, &pfn, limit);
+					      size >> PAGE_SHIFT, &pfn, limit,
+					      &batch);
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
@@ -1298,6 +1336,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		dma->size += npage << PAGE_SHIFT;
 	}
 
+	vfio_batch_fini(&batch);
 	dma->iommu_mapped = true;
 
 	if (ret)
@@ -1456,6 +1495,7 @@ static int vfio_bus_type(struct device *dev, void *data)
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
+	struct vfio_batch batch;
 	struct vfio_domain *d = NULL;
 	struct rb_node *n;
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -1466,6 +1506,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		d = list_first_entry(&iommu->domain_list,
 				     struct vfio_domain, next);
 
+	vfio_batch_init(&batch);
+
 	n = rb_first(&iommu->dma_list);
 
 	for (; n; n = rb_next(n)) {
@@ -1513,7 +1555,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
 				npage = vfio_pin_pages_remote(dma, vaddr,
 							      n >> PAGE_SHIFT,
-							      &pfn, limit);
+							      &pfn, limit,
+							      &batch);
 				if (npage <= 0) {
 					WARN_ON(!npage);
 					ret = (int)npage;
@@ -1546,6 +1589,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		dma->iommu_mapped = true;
 	}
 
+	vfio_batch_fini(&batch);
 	return 0;
 
 unwind:
@@ -1586,6 +1630,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		}
 	}
 
+	vfio_batch_fini(&batch);
 	return ret;
 }
 
-- 
2.35.1



