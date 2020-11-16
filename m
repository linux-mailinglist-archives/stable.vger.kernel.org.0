Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D880A2B412C
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 11:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgKPKbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 05:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbgKPKbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 05:31:10 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CE5C0613CF;
        Mon, 16 Nov 2020 02:31:10 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id d17so24380340lfq.10;
        Mon, 16 Nov 2020 02:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M8U2uahDK/HgIULrCVBIlkVKMme83q7hHqIjlyyGKkQ=;
        b=SQQMa9VSujfRXEUqaNQwQIUQd5QTRuFGIXmJQR/dzuhoJ+t345Fx5p5lCGmy4gkeV8
         m0ZVLme5Zjb8YgJDqEQo2eDUIP8kSvbQrI+rNwOptqlfcxVQiT+7Y2KFvNHX9u/jAS7H
         HYg395VMyjDVw4xwXMEkkIgJVifg6iH9b6koMH28T2HoqSH6h0nhTuXqS7ddvrDMaCAz
         BF1NAA1hrQxeM3rhtQawnpP3v23lt6zCRSP+6Ygu4j5gIOXIiLNGVKIqH+hkk2lpGtIY
         UGinyjp36GuMeJlFm/lN4wu3rTGdliK6AVi6+huxkCWG/RQQ7LqZ1Y/c5NSRJSYCgHWm
         HY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M8U2uahDK/HgIULrCVBIlkVKMme83q7hHqIjlyyGKkQ=;
        b=Y+TL6YsglvQzG4RSr1TnY/BxNdvgfpJ3BNgR0rSFgCqyh908dAW1kSmX4w4DzzAgAC
         JsF4rOcX4SNTUcmJSn98UXa4X6wmOpzxHe0PFyG5SROmi8bjmd2DaTZsX5jXM/5ZP9w3
         yb3vPWJ5I348u9fEpmkeR9PaWAJP0UyfihtlkxhxaIgSGMsc1jCmndtDPB4Cq2bVySNA
         xC0WgwF9nqyiw7EhesRXsZbINekWfIFxFoTwJvQT+x5Jj5udzUS05OceVRD7wJ1OutWA
         Htl4DamlVW2o1OSfJfHKwlP62wiJq0QpqsqXpJg5ullM5V7ScvwWxBB2T4DIMTZrIjhT
         +bVQ==
X-Gm-Message-State: AOAM532z9EQo3eUQU5zaQGRMXu77Y0/cZdsfAh4473HQyBgs0yVTTocV
        6oQM04JDvPnLAqFhLVvYHAvCmwSDcWCEOg==
X-Google-Smtp-Source: ABdhPJzEbY5eNCmIZ+hSKplu6+gcVA08M9MOCaSOpFAXnhkXI8G5tVR56A+mXwi+qvWtNzSgvI2Myg==
X-Received: by 2002:a19:cc16:: with SMTP id c22mr4778889lfg.75.1605522668657;
        Mon, 16 Nov 2020 02:31:08 -0800 (PST)
Received: from octofox.metropolis ([5.19.183.212])
        by smtp.gmail.com with ESMTPSA id f1sm2687362lfm.184.2020.11.16.02.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 02:31:07 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] xtensa: disable preemption around cache alias management calls
Date:   Mon, 16 Nov 2020 02:30:58 -0800
Message-Id: <20201116103058.5461-3-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116103058.5461-1-jcmvbkbc@gmail.com>
References: <20201116103058.5461-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although cache alias management calls set up and tear down TLB entries
and fast_second_level_miss is able to restore TLB entry should it be
evicted they absolutely cannot preempt each other because they use the
same TLBTEMP area for different purposes.
Disable preemption around all cache alias management calls to enforce
that.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/mm/cache.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/xtensa/mm/cache.c b/arch/xtensa/mm/cache.c
index 5835406b3cec..085b8c77b9d9 100644
--- a/arch/xtensa/mm/cache.c
+++ b/arch/xtensa/mm/cache.c
@@ -70,8 +70,10 @@ static inline void kmap_invalidate_coherent(struct page *page,
 			kvaddr = TLBTEMP_BASE_1 +
 				(page_to_phys(page) & DCACHE_ALIAS_MASK);
 
+			preempt_disable();
 			__invalidate_dcache_page_alias(kvaddr,
 						       page_to_phys(page));
+			preempt_enable();
 		}
 	}
 }
@@ -156,6 +158,7 @@ void flush_dcache_page(struct page *page)
 		if (!alias && !mapping)
 			return;
 
+		preempt_disable();
 		virt = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
 		__flush_invalidate_dcache_page_alias(virt, phys);
 
@@ -166,6 +169,7 @@ void flush_dcache_page(struct page *page)
 
 		if (mapping)
 			__invalidate_icache_page_alias(virt, phys);
+		preempt_enable();
 	}
 
 	/* There shouldn't be an entry in the cache for this page anymore. */
@@ -199,8 +203,10 @@ void local_flush_cache_page(struct vm_area_struct *vma, unsigned long address,
 	unsigned long phys = page_to_phys(pfn_to_page(pfn));
 	unsigned long virt = TLBTEMP_BASE_1 + (address & DCACHE_ALIAS_MASK);
 
+	preempt_disable();
 	__flush_invalidate_dcache_page_alias(virt, phys);
 	__invalidate_icache_page_alias(virt, phys);
+	preempt_enable();
 }
 EXPORT_SYMBOL(local_flush_cache_page);
 
@@ -227,11 +233,13 @@ update_mmu_cache(struct vm_area_struct * vma, unsigned long addr, pte_t *ptep)
 		unsigned long phys = page_to_phys(page);
 		unsigned long tmp;
 
+		preempt_disable();
 		tmp = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
 		__flush_invalidate_dcache_page_alias(tmp, phys);
 		tmp = TLBTEMP_BASE_1 + (addr & DCACHE_ALIAS_MASK);
 		__flush_invalidate_dcache_page_alias(tmp, phys);
 		__invalidate_icache_page_alias(tmp, phys);
+		preempt_enable();
 
 		clear_bit(PG_arch_1, &page->flags);
 	}
@@ -265,7 +273,9 @@ void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
+		preempt_disable();
 		__flush_invalidate_dcache_page_alias(t, phys);
+		preempt_enable();
 	}
 
 	/* Copy data */
@@ -280,9 +290,11 @@ void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
 
+		preempt_disable();
 		__flush_invalidate_dcache_range((unsigned long) dst, len);
 		if ((vma->vm_flags & VM_EXEC) != 0)
 			__invalidate_icache_page_alias(t, phys);
+		preempt_enable();
 
 	} else if ((vma->vm_flags & VM_EXEC) != 0) {
 		__flush_dcache_range((unsigned long)dst,len);
@@ -304,7 +316,9 @@ extern void copy_from_user_page(struct vm_area_struct *vma, struct page *page,
 
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
+		preempt_disable();
 		__flush_invalidate_dcache_page_alias(t, phys);
+		preempt_enable();
 	}
 
 	memcpy(dst, src, len);
-- 
2.20.1

