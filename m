Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9854F7CF
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 14:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbiFQMqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 08:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiFQMqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 08:46:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D08E2ED51
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 05:46:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A69A51474
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 05:46:53 -0700 (PDT)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 36F4F3F7F5
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 05:46:53 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10] dma-direct: don't over-decrypt memory
Date:   Fri, 17 Jun 2022 13:46:49 +0100
Message-Id: <5de33f5cb5e1f80497b898e4690d36ed85ad396a.1655468052.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.36.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4a37f3dd9a83186cb88d44808ab35b78375082c9 ]

The original x86 sev_alloc() only called set_memory_decrypted() on
memory returned by alloc_pages_node(), so the page order calculation
fell out of that logic. However, the common dma-direct code has several
potential allocators, not all of which are guaranteed to round up the
underlying allocation to a power-of-two size, so carrying over that
calculation for the encryption/decryption size was a mistake. Fix it by
rounding to a *number* of pages, rather than an order.

Until recently there was an even worse interaction with DMA_DIRECT_REMAP
where we could have ended up decrypting part of the next adjacent
vmalloc area, only averted by no architecture actually supporting both
configs at once. Don't ask how I found that one out...

Fixes: c10f07aa27da ("dma/direct: Handle force decryption for DMA coherent buffers in common code")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Rientjes <rientjes@google.com>
[ backport the functional change without all the prior refactoring ]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---

Hi Greg, Sasha,

I see you managed to resolve this back as far as 5.15 already, so please
consider this backport to complete the set. This may need to end up in
the Android 5.10 kernel in future for unpleasant reasons, but as an
upstream fix I figure it may as well take the upstream stable route too.

Thanks,
Robin.

 kernel/dma/direct.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 8ca84610d4d4..944fdadb5a64 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -191,7 +191,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 			goto out_free_pages;
 		if (force_dma_unencrypted(dev)) {
 			err = set_memory_decrypted((unsigned long)ret,
-						   1 << get_order(size));
+						   PFN_UP(size));
 			if (err)
 				goto out_free_pages;
 		}
@@ -213,7 +213,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	ret = page_address(page);
 	if (force_dma_unencrypted(dev)) {
 		err = set_memory_decrypted((unsigned long)ret,
-					   1 << get_order(size));
+					   PFN_UP(size));
 		if (err)
 			goto out_free_pages;
 	}
@@ -234,7 +234,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 out_encrypt_pages:
 	if (force_dma_unencrypted(dev)) {
 		err = set_memory_encrypted((unsigned long)page_address(page),
-					   1 << get_order(size));
+					   PFN_UP(size));
 		/* If memory cannot be re-encrypted, it must be leaked */
 		if (err)
 			return NULL;
@@ -247,8 +247,6 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 void dma_direct_free(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
-	unsigned int page_order = get_order(size);
-
 	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
 	    !force_dma_unencrypted(dev)) {
 		/* cpu_addr is a struct page cookie, not a kernel address */
@@ -269,7 +267,7 @@ void dma_direct_free(struct device *dev, size_t size,
 		return;
 
 	if (force_dma_unencrypted(dev))
-		set_memory_encrypted((unsigned long)cpu_addr, 1 << page_order);
+		set_memory_encrypted((unsigned long)cpu_addr, PFN_UP(size));
 
 	if (IS_ENABLED(CONFIG_DMA_REMAP) && is_vmalloc_addr(cpu_addr))
 		vunmap(cpu_addr);
@@ -305,8 +303,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 
 	ret = page_address(page);
 	if (force_dma_unencrypted(dev)) {
-		if (set_memory_decrypted((unsigned long)ret,
-				1 << get_order(size)))
+		if (set_memory_decrypted((unsigned long)ret, PFN_UP(size)))
 			goto out_free_pages;
 	}
 	memset(ret, 0, size);
@@ -322,7 +319,6 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 		struct page *page, dma_addr_t dma_addr,
 		enum dma_data_direction dir)
 {
-	unsigned int page_order = get_order(size);
 	void *vaddr = page_address(page);
 
 	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
@@ -331,7 +327,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 		return;
 
 	if (force_dma_unencrypted(dev))
-		set_memory_encrypted((unsigned long)vaddr, 1 << page_order);
+		set_memory_encrypted((unsigned long)vaddr, PFN_UP(size));
 
 	dma_free_contiguous(dev, page, size);
 }
-- 
2.36.1.dirty

