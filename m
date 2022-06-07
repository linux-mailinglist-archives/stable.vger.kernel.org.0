Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81666540BF6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351401AbiFGSdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352496AbiFGSbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A6714558A;
        Tue,  7 Jun 2022 10:56:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 309A0B82368;
        Tue,  7 Jun 2022 17:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4EAC385A5;
        Tue,  7 Jun 2022 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624576;
        bh=s+TZyYCAjcs72aLPTkcMgMcyOxUoBNSc3jMP77WNwEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u38tDbSGueqCI3aR+8D0prMnu58UQdtQBF7/DfipnVc3h/6rMP4um3Ol697l6oGY
         r87JrHLSOg6b3bfiFBBJkCqie6sMqcWN4QAbQwxNmA/59zmH/tsh0ezzLnbd5n8QqG
         8BoplxfEiL9xGhiUhhe5V3hK0v93JIY5G88JsLSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 377/667] dma-direct: factor out dma_set_{de,en}crypted helpers
Date:   Tue,  7 Jun 2022 19:00:42 +0200
Message-Id: <20220607164946.056219979@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4d0564785bb03841e4b5c5b31aa4ecd1eb0d01bb ]

Factor out helpers the make dealing with memory encryption a little less
cumbersome.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 56 ++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index a1573ed2ea18..b9513fd68239 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -75,6 +75,20 @@ static bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
 		min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit);
 }
 
+static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
+{
+	if (!force_dma_unencrypted(dev))
+		return 0;
+	return set_memory_decrypted((unsigned long)vaddr, 1 << get_order(size));
+}
+
+static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
+{
+	if (!force_dma_unencrypted(dev))
+		return 0;
+	return set_memory_encrypted((unsigned long)vaddr, 1 << get_order(size));
+}
+
 static void __dma_direct_free_pages(struct device *dev, struct page *page,
 				    size_t size)
 {
@@ -175,7 +189,6 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 {
 	struct page *page;
 	void *ret;
-	int err;
 
 	size = PAGE_ALIGN(size);
 	if (attrs & DMA_ATTR_NO_WARN)
@@ -228,12 +241,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 				__builtin_return_address(0));
 		if (!ret)
 			goto out_free_pages;
-		if (force_dma_unencrypted(dev)) {
-			err = set_memory_decrypted((unsigned long)ret,
-						   1 << get_order(size));
-			if (err)
-				goto out_free_pages;
-		}
+		if (dma_set_decrypted(dev, ret, size))
+			goto out_free_pages;
 		memset(ret, 0, size);
 		goto done;
 	}
@@ -250,13 +259,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	}
 
 	ret = page_address(page);
-	if (force_dma_unencrypted(dev)) {
-		err = set_memory_decrypted((unsigned long)ret,
-					   1 << get_order(size));
-		if (err)
-			goto out_free_pages;
-	}
-
+	if (dma_set_decrypted(dev, ret, size))
+		goto out_free_pages;
 	memset(ret, 0, size);
 
 	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
@@ -271,13 +275,9 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	return ret;
 
 out_encrypt_pages:
-	if (force_dma_unencrypted(dev)) {
-		err = set_memory_encrypted((unsigned long)page_address(page),
-					   1 << get_order(size));
-		/* If memory cannot be re-encrypted, it must be leaked */
-		if (err)
-			return NULL;
-	}
+	/* If memory cannot be re-encrypted, it must be leaked */
+	if (dma_set_encrypted(dev, page_address(page), size))
+		return NULL;
 out_free_pages:
 	__dma_direct_free_pages(dev, page, size);
 	return NULL;
@@ -316,8 +316,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	    dma_free_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
 		return;
 
-	if (force_dma_unencrypted(dev))
-		set_memory_encrypted((unsigned long)cpu_addr, 1 << page_order);
+	dma_set_encrypted(dev, cpu_addr, 1 << page_order);
 
 	if (IS_ENABLED(CONFIG_DMA_REMAP) && is_vmalloc_addr(cpu_addr))
 		vunmap(cpu_addr);
@@ -343,11 +342,8 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		return NULL;
 
 	ret = page_address(page);
-	if (force_dma_unencrypted(dev)) {
-		if (set_memory_decrypted((unsigned long)ret,
-				1 << get_order(size)))
-			goto out_free_pages;
-	}
+	if (dma_set_decrypted(dev, ret, size))
+		goto out_free_pages;
 	memset(ret, 0, size);
 	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page));
 	return page;
@@ -368,9 +364,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	    dma_free_from_pool(dev, vaddr, size))
 		return;
 
-	if (force_dma_unencrypted(dev))
-		set_memory_encrypted((unsigned long)vaddr, 1 << page_order);
-
+	dma_set_encrypted(dev, vaddr, 1 << page_order);
 	__dma_direct_free_pages(dev, page, size);
 }
 
-- 
2.35.1



