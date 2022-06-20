Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09A5551C82
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345628AbiFTNOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343578AbiFTNMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5B11D328;
        Mon, 20 Jun 2022 06:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1B8F614F4;
        Mon, 20 Jun 2022 13:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B485DC3411B;
        Mon, 20 Jun 2022 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730245;
        bh=GYU38HEj4rh8+X71tEHJGkKhTn4HiMBRUlYTJJu1n1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hS/P4HDDr67NvzmQmihjeEiq+otZoEN6SVshYrz9HoPZPK7W1tMjRz7ZgmfzmWhZn
         0BiVDXshGmu+BdUIX2MzjSFwQGOTsGfy2lABIJ+HBr34Cf5r1BdN2nmF1k5LB2PeH7
         ktr8k/CDzsMo2suvVhLw0neddIsYEPg77XEOlVLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 5.10 78/84] dma-direct: dont over-decrypt memory
Date:   Mon, 20 Jun 2022 14:51:41 +0200
Message-Id: <20220620124723.196723432@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 4a37f3dd9a83186cb88d44808ab35b78375082c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/direct.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -188,7 +188,7 @@ void *dma_direct_alloc(struct device *de
 			goto out_free_pages;
 		if (force_dma_unencrypted(dev)) {
 			err = set_memory_decrypted((unsigned long)ret,
-						   1 << get_order(size));
+						   PFN_UP(size));
 			if (err)
 				goto out_free_pages;
 		}
@@ -210,7 +210,7 @@ void *dma_direct_alloc(struct device *de
 	ret = page_address(page);
 	if (force_dma_unencrypted(dev)) {
 		err = set_memory_decrypted((unsigned long)ret,
-					   1 << get_order(size));
+					   PFN_UP(size));
 		if (err)
 			goto out_free_pages;
 	}
@@ -231,7 +231,7 @@ done:
 out_encrypt_pages:
 	if (force_dma_unencrypted(dev)) {
 		err = set_memory_encrypted((unsigned long)page_address(page),
-					   1 << get_order(size));
+					   PFN_UP(size));
 		/* If memory cannot be re-encrypted, it must be leaked */
 		if (err)
 			return NULL;
@@ -244,8 +244,6 @@ out_free_pages:
 void dma_direct_free(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
-	unsigned int page_order = get_order(size);
-
 	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
 	    !force_dma_unencrypted(dev)) {
 		/* cpu_addr is a struct page cookie, not a kernel address */
@@ -266,7 +264,7 @@ void dma_direct_free(struct device *dev,
 		return;
 
 	if (force_dma_unencrypted(dev))
-		set_memory_encrypted((unsigned long)cpu_addr, 1 << page_order);
+		set_memory_encrypted((unsigned long)cpu_addr, PFN_UP(size));
 
 	if (IS_ENABLED(CONFIG_DMA_REMAP) && is_vmalloc_addr(cpu_addr))
 		vunmap(cpu_addr);
@@ -302,8 +300,7 @@ struct page *dma_direct_alloc_pages(stru
 
 	ret = page_address(page);
 	if (force_dma_unencrypted(dev)) {
-		if (set_memory_decrypted((unsigned long)ret,
-				1 << get_order(size)))
+		if (set_memory_decrypted((unsigned long)ret, PFN_UP(size)))
 			goto out_free_pages;
 	}
 	memset(ret, 0, size);
@@ -318,7 +315,6 @@ void dma_direct_free_pages(struct device
 		struct page *page, dma_addr_t dma_addr,
 		enum dma_data_direction dir)
 {
-	unsigned int page_order = get_order(size);
 	void *vaddr = page_address(page);
 
 	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
@@ -327,7 +323,7 @@ void dma_direct_free_pages(struct device
 		return;
 
 	if (force_dma_unencrypted(dev))
-		set_memory_encrypted((unsigned long)vaddr, 1 << page_order);
+		set_memory_encrypted((unsigned long)vaddr, PFN_UP(size));
 
 	dma_free_contiguous(dev, page, size);
 }


