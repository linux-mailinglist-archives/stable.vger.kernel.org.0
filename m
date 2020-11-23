Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A95D2C0BE2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgKWNc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730097AbgKWM0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:26:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4301C20781;
        Mon, 23 Nov 2020 12:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134364;
        bh=17XM+x+BSMdMb/jJ7ByVbll6woXgIqnGpsDv23YlgPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S39SxQUcywUyj42/wZybFSSb4uf2wUb0GoRAhdQFEbrsbGjgevd04LROkS6Ug7d7m
         d8TDXVPqKr60r6SxnS0tnbJuTu6c7B7N7K5OMyWGbKvo0IuxXQ4gtaHz4blDw2y3Vd
         wA+MVd01ctYxNvGXz1rcgT6zwhzy7kpjFmhFhL2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 4.9 42/47] xtensa: disable preemption around cache alias management calls
Date:   Mon, 23 Nov 2020 13:22:28 +0100
Message-Id: <20201123121807.592116314@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
@@ -74,8 +74,10 @@ static inline void kmap_invalidate_coher
 			kvaddr = TLBTEMP_BASE_1 +
 				(page_to_phys(page) & DCACHE_ALIAS_MASK);
 
+			preempt_disable();
 			__invalidate_dcache_page_alias(kvaddr,
 						       page_to_phys(page));
+			preempt_enable();
 		}
 	}
 }
@@ -160,6 +162,7 @@ void flush_dcache_page(struct page *page
 		if (!alias && !mapping)
 			return;
 
+		preempt_disable();
 		virt = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
 		__flush_invalidate_dcache_page_alias(virt, phys);
 
@@ -170,6 +173,7 @@ void flush_dcache_page(struct page *page
 
 		if (mapping)
 			__invalidate_icache_page_alias(virt, phys);
+		preempt_enable();
 	}
 
 	/* There shouldn't be an entry in the cache for this page anymore. */
@@ -203,8 +207,10 @@ void local_flush_cache_page(struct vm_ar
 	unsigned long phys = page_to_phys(pfn_to_page(pfn));
 	unsigned long virt = TLBTEMP_BASE_1 + (address & DCACHE_ALIAS_MASK);
 
+	preempt_disable();
 	__flush_invalidate_dcache_page_alias(virt, phys);
 	__invalidate_icache_page_alias(virt, phys);
+	preempt_enable();
 }
 EXPORT_SYMBOL(local_flush_cache_page);
 
@@ -231,11 +237,13 @@ update_mmu_cache(struct vm_area_struct *
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
@@ -269,7 +277,9 @@ void copy_to_user_page(struct vm_area_st
 
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
+		preempt_disable();
 		__flush_invalidate_dcache_page_alias(t, phys);
+		preempt_enable();
 	}
 
 	/* Copy data */
@@ -284,9 +294,11 @@ void copy_to_user_page(struct vm_area_st
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
 
+		preempt_disable();
 		__flush_invalidate_dcache_range((unsigned long) dst, len);
 		if ((vma->vm_flags & VM_EXEC) != 0)
 			__invalidate_icache_page_alias(t, phys);
+		preempt_enable();
 
 	} else if ((vma->vm_flags & VM_EXEC) != 0) {
 		__flush_dcache_range((unsigned long)dst,len);
@@ -308,7 +320,9 @@ extern void copy_from_user_page(struct v
 
 	if (alias) {
 		unsigned long t = TLBTEMP_BASE_1 + (vaddr & DCACHE_ALIAS_MASK);
+		preempt_disable();
 		__flush_invalidate_dcache_page_alias(t, phys);
+		preempt_enable();
 	}
 
 	memcpy(dst, src, len);


