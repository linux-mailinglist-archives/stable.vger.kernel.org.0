Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71C2278E19
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgIYQTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729525AbgIYQTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:19:52 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50235C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:52 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id i17so1991637qvj.22
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Xsqlditrsk6GVxN9jY99/azWQCZYdTfiLb7CYYf9Bt0=;
        b=i2efdHgf1Rm3w216zh6uAaPZtqy0VAWPgJ+HqOmx/Vq2fUVJGZJ6vjzyqbnsBFljzZ
         TcRPxU/39fjPTd+P89uk0GEBL6yN/S/IFQJ3lzlI0ZSAGIDJ/+D3fy4afzbqwmbc8lLM
         0rHhpNamSZfUYGurwddwDole4pQO3tOFzLneIRHV9glMw9BhI/F8vyon/Oy8n+DFjwlx
         rGJcZMVVjfIiD6XBCZ/122BfP5r2atDJnjB5HdwJgbkwOhtkIFrT3z7Hf3h5inWatdKn
         nNdneX7M04HO2ERrld0myhawu7OxXzVJDhuj3Qg7BrTT6SfkGlEaL+1SFEk4EHOnzHYh
         jw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Xsqlditrsk6GVxN9jY99/azWQCZYdTfiLb7CYYf9Bt0=;
        b=pNkGjscbdZe9I4DdcIRQq4VW+RPW99JB6g1ekbiqwrWNbpGl/I6+TCg3UP5NeZl0Ka
         +OI2Lxzo0W47wTnMoTz6ZM6z1ntzxMWWmUlWz9H4UuW9MyaYwp0qqyh5+Xmq26vECAHS
         iJU03sWFp8PUIZC3/iedlg+kLmWr4E67oRzaDLFSEshKc7o8kWxKMzJxhpIN5p3PD84n
         9t4aZZEZTVbPTdqyQ7d3ym4Z1A943zgBynMcWCsdLuVjW4heXDtPuByKnWeAsyhIFsKG
         3N3HeJlzcE7g6DFP5U3xFTV73kR1Nzgkb/nkXu6iEeqqMC+CCq+IASMo8Dye+ZPVoemD
         RXvA==
X-Gm-Message-State: AOAM531gzwlgQaDMFklVdhCDxOdvojgtvvLPxbrmYwIrNnaVXHboGISn
        Oalz83SVXZ/7O1ckqnzEKVFUkkqMbecW5KBkMH216Cls1mZzcey/7DPDXFS8vzZFLidKoKsEKZF
        uV1rxWnfKTi2REhttAVL+lJCPYigO4xiqCEvTuAGuKXlIlxkumYFEykYG7yR9+g==
X-Google-Smtp-Source: ABdhPJx6JUhVbGxbK2Xn6OCIywxc/kiGNGKxbKGZA3O3bYgvjeEIIF0E8PHR0eh3LamF1X3eWZejTdvK6P8=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a05:6214:84:: with SMTP id
 n4mr204994qvr.26.1601050791432; Fri, 25 Sep 2020 09:19:51 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:47 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-2-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 01/30 for 5.4] dma-direct: remove __dma_direct_free_pages
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream acaade1af3587132e7ea585f470a95261e14f60c commit.

We can just call dma_free_contiguous directly instead of wrapping it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 include/linux/dma-direct.h |  1 -
 kernel/dma/direct.c        | 11 +++--------
 kernel/dma/remap.c         |  4 ++--
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 6a18a97b76a8..02a418520062 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -76,6 +76,5 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
 struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs);
-void __dma_direct_free_pages(struct device *dev, size_t size, struct page *page);
 int dma_direct_supported(struct device *dev, u64 mask);
 #endif /* _LINUX_DMA_DIRECT_H */
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 0a093a675b63..86f580439c9c 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -154,7 +154,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 		 * so log an error and fail.
 		 */
 		dev_info(dev, "Rejecting highmem page from CMA.\n");
-		__dma_direct_free_pages(dev, size, page);
+		dma_free_contiguous(dev, page, size);
 		return NULL;
 	}
 
@@ -176,11 +176,6 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	return ret;
 }
 
-void __dma_direct_free_pages(struct device *dev, size_t size, struct page *page)
-{
-	dma_free_contiguous(dev, page, size);
-}
-
 void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs)
 {
@@ -189,7 +184,7 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
 	    !force_dma_unencrypted(dev)) {
 		/* cpu_addr is a struct page cookie, not a kernel address */
-		__dma_direct_free_pages(dev, size, cpu_addr);
+		dma_free_contiguous(dev, cpu_addr, size);
 		return;
 	}
 
@@ -199,7 +194,7 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 	if (IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
 	    dma_alloc_need_uncached(dev, attrs))
 		cpu_addr = cached_kernel_address(cpu_addr);
-	__dma_direct_free_pages(dev, size, virt_to_page(cpu_addr));
+	dma_free_contiguous(dev, virt_to_page(cpu_addr), size);
 }
 
 void *dma_direct_alloc(struct device *dev, size_t size,
diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index c00b9258fa6a..fb1e50c2d48a 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -238,7 +238,7 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 			dma_pgprot(dev, PAGE_KERNEL, attrs),
 			__builtin_return_address(0));
 	if (!ret) {
-		__dma_direct_free_pages(dev, size, page);
+		dma_free_contiguous(dev, page, size);
 		return ret;
 	}
 
@@ -256,7 +256,7 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 		struct page *page = pfn_to_page(__phys_to_pfn(phys));
 
 		vunmap(vaddr);
-		__dma_direct_free_pages(dev, size, page);
+		dma_free_contiguous(dev, page, size);
 	}
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

