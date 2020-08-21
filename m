Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C5D24E382
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 00:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHUWea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 18:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgHUWe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 18:34:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3B920738;
        Fri, 21 Aug 2020 22:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598049267;
        bh=vMCcvLmB1fGttY0T2cJTmLRhF1zms0Yr2mtvqVPMFZU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EFRlN0aWCRaZQEJDDHxuD8n5K/dKUzj0zSdVuo57/Zj4IM8zpXizEJcb/AqTBpayh
         SpFfT8O37i/7v1i1GhLC1ZDrG+1jvFpa4+z0sH0R5Xjh9nvGrtIG3vLDTeQnsNBrC6
         uIz//DhB3jaFYTW/TFKGdzeynV6aPeCtFf3kHjus=
Date:   Fri, 21 Aug 2020 15:34:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chris-wilson.co.uk, jroedel@suse.de,
        mm-commits@vger.kernel.org, pavel@ucw.cz, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  +
 mm-track-page-table-modifications-in-__apply_to_page_range.patch added to
 -mm tree
Message-ID: <20200821223427.OHtszKWdH%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: track page table modifications in __apply_to_page_range()
has been added to the -mm tree.  Its filename is
     mm-track-page-table-modifications-in-__apply_to_page_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-track-page-table-modifications-in-__apply_to_page_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-track-page-table-modifications-in-__apply_to_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joerg Roedel <jroedel@suse.de>
Subject: mm: track page table modifications in __apply_to_page_range()

__apply_to_page_range() is also used to change and/or allocate page-table
pages in the vmalloc area of the address space.  Make sure these changes
get synchronized to other page-tables in the system by calling
arch_sync_kernel_mappings() when necessary.

The impact appears limited to x86-32, where apply_to_page_range may miss
updating the PMD.  That leads to explosions in drivers like

[   24.227844] BUG: unable to handle page fault for address: fe036000
[   24.228076] #PF: supervisor write access in kernel mode
[   24.228294] #PF: error_code(0x0002) - not-present page
[   24.228494] *pde = 00000000
[   24.228640] Oops: 0002 [#1] SMP
[   24.228788] CPU: 3 PID: 1300 Comm: gem_concurrent_ Not tainted 5.9.0-rc1+ #16
[   24.228957] Hardware name:  /NUC6i3SYB, BIOS SYSKLi35.86A.0024.2015.1027.2142 10/27/2015
[   24.229297] EIP: __execlists_context_alloc+0x132/0x2d0 [i915]
[   24.229462] Code: 31 d2 89 f0 e8 2f 55 02 00 89 45 e8 3d 00 f0 ff ff 0f 87 11 01 00 00 8b 4d e8 03 4b 30 b8 5a 5a 5a 5a ba 01 00 00 00 8d 79 04 <c7> 01 5a 5a 5a 5a c7 81 fc 0f 00 00 5a 5a 5a 5a 83 e7 fc 29 f9 81
[   24.229759] EAX: 5a5a5a5a EBX: f60ca000 ECX: fe036000 EDX: 00000001
[   24.229915] ESI: f43b7340 EDI: fe036004 EBP: f6389cb8 ESP: f6389c9c
[   24.230072] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010286
[   24.230229] CR0: 80050033 CR2: fe036000 CR3: 2d361000 CR4: 001506d0
[   24.230385] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   24.230539] DR6: fffe0ff0 DR7: 00000400
[   24.230675] Call Trace:
[   24.230957]  execlists_context_alloc+0x10/0x20 [i915]
[   24.231266]  intel_context_alloc_state+0x3f/0x70 [i915]
[   24.231547]  __intel_context_do_pin+0x117/0x170 [i915]
[   24.231850]  i915_gem_do_execbuffer+0xcc7/0x2500 [i915]
[   24.232024]  ? __kmalloc_track_caller+0x54/0x230
[   24.232181]  ? ktime_get+0x3e/0x120
[   24.232333]  ? dma_fence_signal+0x34/0x50
[   24.232617]  i915_gem_execbuffer2_ioctl+0xcd/0x1f0 [i915]
[   24.232912]  ? i915_gem_execbuffer_ioctl+0x2e0/0x2e0 [i915]
[   24.233084]  drm_ioctl_kernel+0x8f/0xd0
[   24.233236]  drm_ioctl+0x223/0x3d0
[   24.233505]  ? i915_gem_execbuffer_ioctl+0x2e0/0x2e0 [i915]
[   24.233684]  ? pick_next_task_fair+0x1b5/0x3d0
[   24.233873]  ? __switch_to_asm+0x36/0x50
[   24.234021]  ? drm_ioctl_kernel+0xd0/0xd0
[   24.234167]  __ia32_sys_ioctl+0x1ab/0x760
[   24.234313]  ? exit_to_user_mode_prepare+0xe5/0x110
[   24.234453]  ? syscall_exit_to_user_mode+0x23/0x130
[   24.234601]  __do_fast_syscall_32+0x3f/0x70
[   24.234744]  do_fast_syscall_32+0x29/0x60
[   24.234885]  do_SYSENTER_32+0x15/0x20
[   24.235021]  entry_SYSENTER_32+0x9f/0xf2
[   24.235157] EIP: 0xb7f28559
[   24.235288] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[   24.235576] EAX: ffffffda EBX: 00000005 ECX: c0406469 EDX: bf95556c
[   24.235722] ESI: b7e68000 EDI: c0406469 EBP: 00000005 ESP: bf9554d8
[   24.235869] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
[   24.236018] Modules linked in: i915 x86_pkg_temp_thermal intel_powerclamp crc32_pclmul crc32c_intel intel_cstate intel_uncore intel_gtt drm_kms_helper intel_pch_thermal video button autofs4 i2c_i801 i2c_smbus fan
[   24.236336] CR2: 00000000fe036000

It looks like kasan, xen and i915 are vulnerable.

Actual impact is "on thinkpad X60 in 5.9-rc1, screen starts blinking after
30-or-so minutes, and machine is unusable"

[chris@chris-wilson.co.uk: changelog addition]
[pavel@ucw.cz: changelog addition]
Link: https://lkml.kernel.org/r/20200821123746.16904-1-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Chris Wilson <chris@chris-wilson.co.uk>	[x86-32]
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/mm/memory.c~mm-track-page-table-modifications-in-__apply_to_page_range
+++ a/mm/memory.c
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
@@ -2214,7 +2216,7 @@ static int apply_to_pte_range(struct mm_
 
 	if (create) {
 		pte = (mm == &init_mm) ?
-			pte_alloc_kernel(pmd, addr) :
+			pte_alloc_kernel_track(pmd, addr, mask) :
 			pte_alloc_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
 			return -ENOMEM;
@@ -2235,6 +2237,7 @@ static int apply_to_pte_range(struct mm_
 				break;
 		}
 	} while (addr += PAGE_SIZE, addr != end);
+	*mask |= PGTBL_PTE_MODIFIED;
 
 	arch_leave_lazy_mmu_mode();
 
@@ -2245,7 +2248,8 @@ static int apply_to_pte_range(struct mm_
 
 static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create)
+				     pte_fn_t fn, void *data, bool create,
+				     pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -2254,7 +2258,7 @@ static int apply_to_pmd_range(struct mm_
 	BUG_ON(pud_huge(*pud));
 
 	if (create) {
-		pmd = pmd_alloc(mm, pud, addr);
+		pmd = pmd_alloc_track(mm, pud, addr, mask);
 		if (!pmd)
 			return -ENOMEM;
 	} else {
@@ -2264,7 +2268,7 @@ static int apply_to_pmd_range(struct mm_
 		next = pmd_addr_end(addr, end);
 		if (create || !pmd_none_or_clear_bad(pmd)) {
 			err = apply_to_pte_range(mm, pmd, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2274,14 +2278,15 @@ static int apply_to_pmd_range(struct mm_
 
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
@@ -2291,7 +2296,7 @@ static int apply_to_pud_range(struct mm_
 		next = pud_addr_end(addr, end);
 		if (create || !pud_none_or_clear_bad(pud)) {
 			err = apply_to_pmd_range(mm, pud, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2301,14 +2306,15 @@ static int apply_to_pud_range(struct mm_
 
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
@@ -2318,7 +2324,7 @@ static int apply_to_p4d_range(struct mm_
 		next = p4d_addr_end(addr, end);
 		if (create || !p4d_none_or_clear_bad(p4d)) {
 			err = apply_to_pud_range(mm, p4d, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2331,8 +2337,9 @@ static int __apply_to_page_range(struct
 				 void *data, bool create)
 {
 	pgd_t *pgd;
-	unsigned long next;
+	unsigned long start = addr, next;
 	unsigned long end = addr + size;
+	pgtbl_mod_mask mask = 0;
 	int err = 0;
 
 	if (WARN_ON(addr >= end))
@@ -2343,11 +2350,14 @@ static int __apply_to_page_range(struct
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
 
_

Patches currently in -mm which might be from jroedel@suse.de are

mm-track-page-table-modifications-in-__apply_to_page_range.patch

