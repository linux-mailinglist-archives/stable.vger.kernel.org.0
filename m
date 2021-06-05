Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAE339C555
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 05:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFEDDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 23:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhFEDDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8A64613F9;
        Sat,  5 Jun 2021 03:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862069;
        bh=bplJu7IkscH2KZdtTIwutE1/8FYSspwB97IfgmLEMeA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j5RXIlaA3HXQfAl1gh7R5bdxXgoxlRRUnS0l3PIa91KSn9Y1xSiHzpJBahvtAO8BB
         j3O+yAe1Qpnku9ZfMBi3aG6qyTROL7LweH42pN3iMEOMbGqdJXHmxYTbekeg+FuUoS
         Q/rQzqgOGWfGHLyM9wB2IYc20Envr+49S/pCcsis=
Date:   Fri, 04 Jun 2021 20:01:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, huangpei@loongson.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, npiggin@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, zhouyanjie@wanyeetech.com
Subject:  [patch 01/13] Revert "MIPS: make userspace mapping young
 by default"
Message-ID: <20210605030108.r5awe5RRw%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Revert "MIPS: make userspace mapping young by default"

This reverts commit f685a533a7fab35c5d069dcd663f59c8e4171a75.

MIPS cache flush logic needs to know whether the mapping was already
established to decide how to flush caches.  This is done by checking the
valid bit in the PTE.  The commit above breaks this logic by setting the
valid in the PTE in new mappings, which causes kernel crashes.

Link: https://lkml.kernel.org/r/20210526094335.92948-1-tsbogend@alpha.franken.de
Fixes: f685a533a7f ("MIPS: make userspace mapping young by default")
Reported-by: Zhou Yanjie <zhouyanjie@wanyeetech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Huang Pei <huangpei@loongson.cn>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c    |   30 ++++++++++++++----------------
 include/linux/pgtable.h |    8 ++++++++
 mm/memory.c             |    4 ++++
 3 files changed, 26 insertions(+), 16 deletions(-)

--- a/arch/mips/mm/cache.c~revert-mips-make-userspace-mapping-young-by-default
+++ a/arch/mips/mm/cache.c
@@ -158,31 +158,29 @@ unsigned long _page_cachable_default;
 EXPORT_SYMBOL(_page_cachable_default);
 
 #define PM(p)	__pgprot(_page_cachable_default | (p))
-#define PVA(p)	PM(_PAGE_VALID | _PAGE_ACCESSED | (p))
 
 static inline void setup_protection_map(void)
 {
 	protection_map[0]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[1]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[2]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[3]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[4]  = PVA(_PAGE_PRESENT);
-	protection_map[5]  = PVA(_PAGE_PRESENT);
-	protection_map[6]  = PVA(_PAGE_PRESENT);
-	protection_map[7]  = PVA(_PAGE_PRESENT);
+	protection_map[1]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[2]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
+	protection_map[3]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[4]  = PM(_PAGE_PRESENT);
+	protection_map[5]  = PM(_PAGE_PRESENT);
+	protection_map[6]  = PM(_PAGE_PRESENT);
+	protection_map[7]  = PM(_PAGE_PRESENT);
 
 	protection_map[8]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[9]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[10] = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE |
+	protection_map[9]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[10] = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE |
 				_PAGE_NO_READ);
-	protection_map[11] = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
-	protection_map[12] = PVA(_PAGE_PRESENT);
-	protection_map[13] = PVA(_PAGE_PRESENT);
-	protection_map[14] = PVA(_PAGE_PRESENT);
-	protection_map[15] = PVA(_PAGE_PRESENT);
+	protection_map[11] = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
+	protection_map[12] = PM(_PAGE_PRESENT);
+	protection_map[13] = PM(_PAGE_PRESENT);
+	protection_map[14] = PM(_PAGE_PRESENT | _PAGE_WRITE);
+	protection_map[15] = PM(_PAGE_PRESENT | _PAGE_WRITE);
 }
 
-#undef _PVA
 #undef PM
 
 void cpu_cache_init(void)
--- a/include/linux/pgtable.h~revert-mips-make-userspace-mapping-young-by-default
+++ a/include/linux/pgtable.h
@@ -432,6 +432,14 @@ static inline void ptep_set_wrprotect(st
  * To be differentiate with macro pte_mkyoung, this macro is used on platforms
  * where software maintains page access bit.
  */
+#ifndef pte_sw_mkyoung
+static inline pte_t pte_sw_mkyoung(pte_t pte)
+{
+	return pte;
+}
+#define pte_sw_mkyoung	pte_sw_mkyoung
+#endif
+
 #ifndef pte_savedwrite
 #define pte_savedwrite pte_write
 #endif
--- a/mm/memory.c~revert-mips-make-userspace-mapping-young-by-default
+++ a/mm/memory.c
@@ -2939,6 +2939,7 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
+		entry = pte_sw_mkyoung(entry);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 
 		/*
@@ -3602,6 +3603,7 @@ static vm_fault_t do_anonymous_page(stru
 	__SetPageUptodate(page);
 
 	entry = mk_pte(page, vma->vm_page_prot);
+	entry = pte_sw_mkyoung(entry);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
@@ -3786,6 +3788,8 @@ void do_set_pte(struct vm_fault *vmf, st
 
 	if (prefault && arch_wants_old_prefaulted_pte())
 		entry = pte_mkold(entry);
+	else
+		entry = pte_sw_mkyoung(entry);
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
_
