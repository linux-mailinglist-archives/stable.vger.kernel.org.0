Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC792C06A6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgKWMdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731163AbgKWMdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:33:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2094F208C3;
        Mon, 23 Nov 2020 12:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134785;
        bh=oqkeIbWPCbIgmY9+bquH2m/ZuvMZuBZj97pZZzTEU4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noMXAH0nI/lWbatZwnfNTiC8zJ8EAiyLZwGh1W9sU3C0EHCOWPT2BtSAOy6EPhc/k
         69UoJYP9UC13lRfFYBOMYFfkh3rs+4FY9M/3/wwZajGMBIGbJFez2mirbi/budZIt5
         WXEvz5Vo/FVvLXUNzWelM8VTjfgTDsk5bq4I3Q78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 4.19 82/91] xtensa: disable preemption around cache alias management calls
Date:   Mon, 23 Nov 2020 13:22:42 +0100
Message-Id: <20201123121813.309367717@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 3a860d165eb5f4d7cf0bf81ef6a5b5c5e1754422 upstream.

Although cache alias management calls set up and tear down TLB entries
and fast_second_level_miss is able to restore TLB entry should it be
evicted they absolutely cannot preempt each other because they use the
same TLBTEMP area for different purposes.
Disable preemption around all cache alias management calls to enforce
that.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/mm/cache.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/xtensa/mm/cache.c
+++ b/arch/xtensa/mm/cache.c
@@ -71,8 +71,10 @@ static inline void kmap_invalidate_coher
 			kvaddr = TLBTEMP_BASE_1 +
 				(page_to_phys(page) & DCACHE_ALIAS_MASK);
 
+			preempt_disable();
 			__invalidate_dcache_page_alias(kvaddr,
 						       page_to_phys(page));
+			preempt_enable();
 		}
 	}
 }
@@ -157,6 +159,7 @@ void flush_dcache_page(struct page *page
 		if (!alias && !mapping)
 			return;
 
+		preempt_disable();
 		virt = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
 		__flush_invalidate_dcache_page_alias(virt, phys);
 
@@ -167,6 +170,7 @@ void flush_dcache_page(struct page *page
 
 		if (mapping)
 			__invalidate_icache_page_alias(virt, phys);
+		preempt_enable();
 	}
 
 	/* There shouldn't be an entry in the cache for this page anymore. */
@@ -200,8 +204,10 @@ void local_flush_cache_page(struct vm_ar
 	unsigned long phys = page_to_phys(pfn_to_page(pfn));
 	unsigned long virt = TLBTEMP_BASE_1 + (address & DCACHE_ALIAS_MASK);
 
+	preempt_disable();
 	__flush_invalidate_dcache_page_alias(virt, phys);
 	__invalidate_icache_page_alias(virt, phys);
+	preempt_enable();
 }
 EXPORT_SYMBOL(local_flush_cache_page);
 
@@ -228,11 +234,13 @@ update_mmu_cache(struct vm_area_struct *
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
@@ -266,7 +274,9 @@ void copy_to_user_page(struct vm_area_st
 
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
+		preempt_disable();
 		__flush_invalidate_dcache_page_alias(t, phys);
+		preempt_enable();
 	}
 
 	/* Copy data */
@@ -281,9 +291,11 @@ void copy_to_user_page(struct vm_area_st
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
 
+		preempt_disable();
 		__flush_invalidate_dcache_range((unsigned long) dst, len);
 		if ((vma->vm_flags & VM_EXEC) != 0)
 			__invalidate_icache_page_alias(t, phys);
+		preempt_enable();
 
 	} else if ((vma->vm_flags & VM_EXEC) != 0) {
 		__flush_dcache_range((unsigned long)dst,len);
@@ -305,7 +317,9 @@ extern void copy_from_user_page(struct v
 
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
+		preempt_disable();
 		__flush_invalidate_dcache_page_alias(t, phys);
+		preempt_enable();
 	}
 
 	memcpy(dst, src, len);


