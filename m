Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E16451E7D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344920AbhKPAgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344985AbhKOTZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D863633FF;
        Mon, 15 Nov 2021 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003295;
        bh=jbaPyBZWByad9QK5R1KgpYF0VSBWrg8U/fSOmpMxjz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J01AoJlEUlRiWFovnUhWdc7zuYUO+wIMRMr4FgRxNsx73EOgQjeT6xT/j5MJz658b
         SV2P5DDpdqwtqGzyzBaXDlWHNilqejJ99b2vpNG/59+00qQS+nwMJ2h/ALXwJb/z03
         iP/dtZOGMYvf5vnL/8QDOx1LZy5vBHQ0d+rV/Idg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, stable@kernel.org
Subject: [PATCH 5.15 850/917] parisc: Flush kernel data mapping in set_pte_at() when installing pte for user page
Date:   Mon, 15 Nov 2021 18:05:45 +0100
Message-Id: <20211115165457.851760707@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit 38860b2c8bb1b92f61396eb06a63adff916fc31d upstream.

For years, there have been random segmentation faults in userspace on
SMP PA-RISC machines.  It occurred to me that this might be a problem in
set_pte_at().  MIPS and some other architectures do cache flushes when
installing PTEs with the present bit set.

Here I have adapted the code in update_mmu_cache() to flush the kernel
mapping when the kernel flush is deferred, or when the kernel mapping
may alias with the user mapping.  This simplifies calls to
update_mmu_cache().

I also changed the barrier in set_pte() from a compiler barrier to a
full memory barrier.  I know this change is not sufficient to fix the
problem.  It might not be needed.

I have had a few days of operation with 5.14.16 to 5.15.1 and haven't
seen any random segmentation faults on rp3440 or c8000 so far.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@kernel.org # 5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/pgtable.h |   10 ++++++++--
 arch/parisc/kernel/cache.c        |    4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -76,6 +76,8 @@ static inline void purge_tlb_entries(str
 	purge_tlb_end(flags);
 }
 
+extern void __update_cache(pte_t pte);
+
 /* Certain architectures need to do special things when PTEs
  * within a page table are directly modified.  Thus, the following
  * hook is made available.
@@ -83,11 +85,14 @@ static inline void purge_tlb_entries(str
 #define set_pte(pteptr, pteval)			\
 	do {					\
 		*(pteptr) = (pteval);		\
-		barrier();			\
+		mb();				\
 	} while(0)
 
 #define set_pte_at(mm, addr, pteptr, pteval)	\
 	do {					\
+		if (pte_present(pteval) &&	\
+		    pte_user(pteval))		\
+			__update_cache(pteval);	\
 		*(pteptr) = (pteval);		\
 		purge_tlb_entries(mm, addr);	\
 	} while (0)
@@ -303,6 +308,7 @@ extern unsigned long *empty_zero_page;
 
 #define pte_none(x)     (pte_val(x) == 0)
 #define pte_present(x)	(pte_val(x) & _PAGE_PRESENT)
+#define pte_user(x)	(pte_val(x) & _PAGE_USER)
 #define pte_clear(mm, addr, xp)  set_pte_at(mm, addr, xp, __pte(0))
 
 #define pmd_flag(x)	(pmd_val(x) & PxD_FLAG_MASK)
@@ -410,7 +416,7 @@ extern void paging_init (void);
 
 #define PG_dcache_dirty         PG_arch_1
 
-extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
+#define update_mmu_cache(vms,addr,ptep) __update_cache(*ptep)
 
 /* Encode and de-code a swap entry */
 
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -83,9 +83,9 @@ EXPORT_SYMBOL(flush_cache_all_local);
 #define pfn_va(pfn)	__va(PFN_PHYS(pfn))
 
 void
-update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
+__update_cache(pte_t pte)
 {
-	unsigned long pfn = pte_pfn(*ptep);
+	unsigned long pfn = pte_pfn(pte);
 	struct page *page;
 
 	/* We don't have pte special.  As a result, we can be called with


