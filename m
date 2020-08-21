Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC8224D521
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgHUMiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 08:38:01 -0400
Received: from 8bytes.org ([81.169.241.247]:36604 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgHUMiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 08:38:01 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 59C01284;
        Fri, 21 Aug 2020 14:37:59 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH v2] mm: Track page table modifications in __apply_to_page_range()
Date:   Fri, 21 Aug 2020 14:37:46 +0200
Message-Id: <20200821123746.16904-1-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The __apply_to_page_range() function is also used to change and/or
allocate page-table pages in the vmalloc area of the address space.
Make sure these changes get synchronized to other page-tables in the
system by calling arch_sync_kernel_mappings() when necessary.

Tested-by: Chris Wilson <chris@chris-wilson.co.uk> #x86-32
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 mm/memory.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3a7779d9891d..1b7d846f6992 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -83,6 +83,7 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
+#include "pgalloc-track.h"
 #include "internal.h"
 
 #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
@@ -2206,7 +2207,8 @@ EXPORT_SYMBOL(vm_iomap_memory);
 
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create)
+				     pte_fn_t fn, void *data, bool create,
+				     pgtbl_mod_mask *mask)
 {
 	pte_t *pte;
 	int err = 0;
@@ -2214,7 +2216,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	if (create) {
 		pte = (mm == &init_mm) ?
-			pte_alloc_kernel(pmd, addr) :
+			pte_alloc_kernel_track(pmd, addr, mask) :
 			pte_alloc_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
 			return -ENOMEM;
@@ -2235,6 +2237,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				break;
 		}
 	} while (addr += PAGE_SIZE, addr != end);
+	*mask |= PGTBL_PTE_MODIFIED;
 
 	arch_leave_lazy_mmu_mode();
 
@@ -2245,7 +2248,8 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create)
+				     pte_fn_t fn, void *data, bool create,
+				     pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -2254,7 +2258,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 	BUG_ON(pud_huge(*pud));
 
 	if (create) {
-		pmd = pmd_alloc(mm, pud, addr);
+		pmd = pmd_alloc_track(mm, pud, addr, mask);
 		if (!pmd)
 			return -ENOMEM;
 	} else {
@@ -2264,7 +2268,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 		next = pmd_addr_end(addr, end);
 		if (create || !pmd_none_or_clear_bad(pmd)) {
 			err = apply_to_pte_range(mm, pmd, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2274,14 +2278,15 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 
 static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create)
+				     pte_fn_t fn, void *data, bool create,
+				     pgtbl_mod_mask *mask)
 {
 	pud_t *pud;
 	unsigned long next;
 	int err = 0;
 
 	if (create) {
-		pud = pud_alloc(mm, p4d, addr);
+		pud = pud_alloc_track(mm, p4d, addr, mask);
 		if (!pud)
 			return -ENOMEM;
 	} else {
@@ -2291,7 +2296,7 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 		next = pud_addr_end(addr, end);
 		if (create || !pud_none_or_clear_bad(pud)) {
 			err = apply_to_pmd_range(mm, pud, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2301,14 +2306,15 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 
 static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create)
+				     pte_fn_t fn, void *data, bool create,
+				     pgtbl_mod_mask *mask)
 {
 	p4d_t *p4d;
 	unsigned long next;
 	int err = 0;
 
 	if (create) {
-		p4d = p4d_alloc(mm, pgd, addr);
+		p4d = p4d_alloc_track(mm, pgd, addr, mask);
 		if (!p4d)
 			return -ENOMEM;
 	} else {
@@ -2318,7 +2324,7 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 		next = p4d_addr_end(addr, end);
 		if (create || !p4d_none_or_clear_bad(p4d)) {
 			err = apply_to_pud_range(mm, p4d, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2331,8 +2337,9 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 				 void *data, bool create)
 {
 	pgd_t *pgd;
-	unsigned long next;
+	unsigned long start = addr, next;
 	unsigned long end = addr + size;
+	pgtbl_mod_mask mask = 0;
 	int err = 0;
 
 	if (WARN_ON(addr >= end))
@@ -2343,11 +2350,14 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 		next = pgd_addr_end(addr, end);
 		if (!create && pgd_none_or_clear_bad(pgd))
 			continue;
-		err = apply_to_p4d_range(mm, pgd, addr, next, fn, data, create);
+		err = apply_to_p4d_range(mm, pgd, addr, next, fn, data, create, &mask);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
 
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, start + size);
+
 	return err;
 }
 
-- 
2.28.0

