Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98B278E3C
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgIYQUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7114C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o11so2419624pjj.9
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=f3bkGq4TDjR+hhspYidSvBzq+erXc7WyryfUsbbYVGg=;
        b=PSP6OEpytCgvmeBoQZXNKwHkXviBLv70Okv1Cd891H6sI/LM+x/oux062RtgPpnsBs
         v1hbuASSSl63ZV3ukmHCUtvjO7fnDpkn8HpS6cs5nMgm3edx/T6f3DcvKFdj/yOga63i
         IyIkSngx2SrHsdIrwI8su7+tehmiTy/P4HRiC+PbMd49WHj7tVBK9UPx9fh8kIHkPeP3
         CMZUft6uIxa+oqI3YPN99bbFoqR775hdqtIqqyYv2Q8su/QDmibS2TEx7LsoZamc5A9W
         B0MF45ZIVKJyOZ4WyDabUAtnf659q2Or7SSWUQX/Q3JTKZOhblCluHiQOcj6/H6XedjM
         yQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f3bkGq4TDjR+hhspYidSvBzq+erXc7WyryfUsbbYVGg=;
        b=A/nRCujjMDS43LNDXPNCPvY2lCwocLw3JeW0C1ZxyQeyX7CxwRQwIvTrhn/GSCH6DD
         kyWx+/0bokDcvHyKF2XX32BlsuLnnm3IyyotWaJ0Bx9zEMn9FG6X4K+byyC8JxLWd09y
         VF/nLwyKAWJ88xC44XeTNrnNpVlWFgd6JHeCdZ5UirTomb/OzQEh05tRGnOQfcDwpmAR
         tLiB8hb9NAPVtjYr85rQ/LOHcoNFJGI1Om+Hc6FBJbRXbTRlGr70sAyu1ydNEawcal6r
         wT7JW7X2iseuL+pzsCjepSIp86HY/g/F8ZiBcUMvU9wckObOaLft7lTWa3JzUI7IZAgy
         raDQ==
X-Gm-Message-State: AOAM5304vma7+21bG3JrPlK5tbDnitrq3FTZL5n6MioKOT7X69dlZC+A
        Mwv/D/B8nnlEqV3mj2nQvJNmPYSPpnS7bg6uOzOMdBlWCWHQMqFNiB2aCspDsrw4WUmJ6SIhWco
        HdgwEcniv/BQzKoXhwjIbhOqfirEuNgxDf8uEepp/pmRmdPr5xSaQRbDmg7XEYg==
X-Google-Smtp-Source: ABdhPJzF90ZOuqYIYaFmgBVGj1KR7S1uz22QZ0yVy78JoWaocfqFzpCjYRPL/mv2bU+BOiO67CEipIADUSw=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a63:2319:: with SMTP id j25mr680949pgj.75.1601050822067;
 Fri, 25 Sep 2020 09:20:22 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:04 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-19-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 18/30 for 5.4] dma-direct: always align allocation size in dma_direct_alloc_pages()
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream 633d5fce78a61e8727674467944939f55b0bcfab commit.

dma_alloc_contiguous() does size >> PAGE_SHIFT and set_memory_decrypted()
works at page granularity.  It's necessary to page align the allocation
size in dma_direct_alloc_pages() for consistent behavior.

This also fixes an issue when arch_dma_prep_coherent() is called on an
unaligned allocation size for dma_alloc_need_uncached() when
CONFIG_DMA_DIRECT_REMAP is disabled but CONFIG_ARCH_HAS_DMA_SET_UNCACHED
is enabled.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Change-Id: I6ede6ca2864a9fb3ace42df7a0da6725ae453f1c
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/direct.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index bb5cb5af9f7d..e72bb0dc8150 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -126,11 +126,12 @@ static inline bool dma_should_free_from_pool(struct device *dev,
 struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 		gfp_t gfp, unsigned long attrs)
 {
-	size_t alloc_size = PAGE_ALIGN(size);
 	int node = dev_to_node(dev);
 	struct page *page = NULL;
 	u64 phys_mask;
 
+	WARN_ON_ONCE(!PAGE_ALIGNED(size));
+
 	if (attrs & DMA_ATTR_NO_WARN)
 		gfp |= __GFP_NOWARN;
 
@@ -138,14 +139,14 @@ struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	gfp &= ~__GFP_ZERO;
 	gfp |= dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
 			&phys_mask);
-	page = dma_alloc_contiguous(dev, alloc_size, gfp);
+	page = dma_alloc_contiguous(dev, size, gfp);
 	if (page && !dma_coherent_ok(dev, page_to_phys(page), size)) {
-		dma_free_contiguous(dev, page, alloc_size);
+		dma_free_contiguous(dev, page, size);
 		page = NULL;
 	}
 again:
 	if (!page)
-		page = alloc_pages_node(node, gfp, get_order(alloc_size));
+		page = alloc_pages_node(node, gfp, get_order(size));
 	if (page && !dma_coherent_ok(dev, page_to_phys(page), size)) {
 		dma_free_contiguous(dev, page, size);
 		page = NULL;
@@ -172,8 +173,10 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	struct page *page;
 	void *ret;
 
+	size = PAGE_ALIGN(size);
+
 	if (dma_should_alloc_from_pool(dev, gfp, attrs)) {
-		ret = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &page, gfp);
+		ret = dma_alloc_from_pool(dev, size, &page, gfp);
 		if (!ret)
 			return NULL;
 		goto done;
@@ -197,10 +200,10 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	     dma_alloc_need_uncached(dev, attrs)) ||
 	    (IS_ENABLED(CONFIG_DMA_REMAP) && PageHighMem(page))) {
 		/* remove any dirty cache lines on the kernel alias */
-		arch_dma_prep_coherent(page, PAGE_ALIGN(size));
+		arch_dma_prep_coherent(page, size);
 
 		/* create a coherent mapping */
-		ret = dma_common_contiguous_remap(page, PAGE_ALIGN(size),
+		ret = dma_common_contiguous_remap(page, size,
 				dma_pgprot(dev, PAGE_KERNEL, attrs),
 				__builtin_return_address(0));
 		if (!ret)
-- 
2.28.0.618.gf4bc123cb7-goog

