Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB22261992
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732214AbgIHSVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731443AbgIHQKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 642F824763;
        Tue,  8 Sep 2020 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579702;
        bh=io22j2W5J0jUP4Xcc0zjYON9kfoXqTdxAT6+zgSmmts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaecDKJa8tBmEoGf4AQZxGnmWVEFI7zKxY/uK9qrseCibtqV92oq6KUd4n49aiFw0
         FCcziO/J6G+0YzMzbLJFLw9rgx8bvHuBfUX6No9Zcdl0NF1pak0RUV6by/B75xsoWd
         M11JgcU26+A5zC68ounAKKG+RzdlmgqZjWdvqjI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 5.8 173/186] mm: track page table modifications in __apply_to_page_range()
Date:   Tue,  8 Sep 2020 17:25:15 +0200
Message-Id: <20200908152250.046403540@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit e80d3909be42f7e38cc350c1ba109cf0aa51956a upstream.

__apply_to_page_range() is also used to change and/or allocate
page-table pages in the vmalloc area of the address space.  Make sure
these changes get synchronized to other page-tables in the system by
calling arch_sync_kernel_mappings() when necessary.

The impact appears limited to x86-32, where apply_to_page_range may miss
updating the PMD.  That leads to explosions in drivers like

  BUG: unable to handle page fault for address: fe036000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  *pde = 00000000
  Oops: 0002 [#1] SMP
  CPU: 3 PID: 1300 Comm: gem_concurrent_ Not tainted 5.9.0-rc1+ #16
  Hardware name:  /NUC6i3SYB, BIOS SYSKLi35.86A.0024.2015.1027.2142 10/27/2015
  EIP: __execlists_context_alloc+0x132/0x2d0 [i915]
  Code: 31 d2 89 f0 e8 2f 55 02 00 89 45 e8 3d 00 f0 ff ff 0f 87 11 01 00 00 8b 4d e8 03 4b 30 b8 5a 5a 5a 5a ba 01 00 00 00 8d 79 04 <c7> 01 5a 5a 5a 5a c7 81 fc 0f 00 00 5a 5a 5a 5a 83 e7 fc 29 f9 81
  EAX: 5a5a5a5a EBX: f60ca000 ECX: fe036000 EDX: 00000001
  ESI: f43b7340 EDI: fe036004 EBP: f6389cb8 ESP: f6389c9c
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010286
  CR0: 80050033 CR2: fe036000 CR3: 2d361000 CR4: 001506d0
  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
  DR6: fffe0ff0 DR7: 00000400
  Call Trace:
    execlists_context_alloc+0x10/0x20 [i915]
    intel_context_alloc_state+0x3f/0x70 [i915]
    __intel_context_do_pin+0x117/0x170 [i915]
    i915_gem_do_execbuffer+0xcc7/0x2500 [i915]
    i915_gem_execbuffer2_ioctl+0xcd/0x1f0 [i915]
    drm_ioctl_kernel+0x8f/0xd0
    drm_ioctl+0x223/0x3d0
    __ia32_sys_ioctl+0x1ab/0x760
    __do_fast_syscall_32+0x3f/0x70
    do_fast_syscall_32+0x29/0x60
    do_SYSENTER_32+0x15/0x20
    entry_SYSENTER_32+0x9f/0xf2
  EIP: 0xb7f28559
  Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
  EAX: ffffffda EBX: 00000005 ECX: c0406469 EDX: bf95556c
  ESI: b7e68000 EDI: c0406469 EBP: 00000005 ESP: bf9554d8
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
  Modules linked in: i915 x86_pkg_temp_thermal intel_powerclamp crc32_pclmul crc32c_intel intel_cstate intel_uncore intel_gtt drm_kms_helper intel_pch_thermal video button autofs4 i2c_i801 i2c_smbus fan
  CR2: 00000000fe036000

It looks like kasan, xen and i915 are vulnerable.

Actual impact is "on thinkpad X60 in 5.9-rc1, screen starts blinking
after 30-or-so minutes, and machine is unusable"

[sfr@canb.auug.org.au: ARCH_PAGE_TABLE_SYNC_MASK needs vmalloc.h]
  Link: https://lkml.kernel.org/r/20200825172508.16800a4f@canb.auug.org.au
[chris@chris-wilson.co.uk: changelog addition]
[pavel@ucw.cz: changelog addition]

Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Fixes: 86cf69f1d893 ("x86/mm/32: implement arch_sync_kernel_mappings()")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Chris Wilson <chris@chris-wilson.co.uk>	[x86-32]
Tested-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>	[5.8+]
Link: https://lkml.kernel.org/r/20200821123746.16904-1-joro@8bytes.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -71,6 +71,7 @@
 #include <linux/dax.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/vmalloc.h>
 
 #include <trace/events/kmem.h>
 
@@ -2201,7 +2202,8 @@ EXPORT_SYMBOL(vm_iomap_memory);
 
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create)
+				     pte_fn_t fn, void *data, bool create,
+				     pgtbl_mod_mask *mask)
 {
 	pte_t *pte;
 	int err = 0;
@@ -2209,7 +2211,7 @@ static int apply_to_pte_range(struct mm_
 
 	if (create) {
 		pte = (mm == &init_mm) ?
-			pte_alloc_kernel(pmd, addr) :
+			pte_alloc_kernel_track(pmd, addr, mask) :
 			pte_alloc_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
 			return -ENOMEM;
@@ -2230,6 +2232,7 @@ static int apply_to_pte_range(struct mm_
 				break;
 		}
 	} while (addr += PAGE_SIZE, addr != end);
+	*mask |= PGTBL_PTE_MODIFIED;
 
 	arch_leave_lazy_mmu_mode();
 
@@ -2240,7 +2243,8 @@ static int apply_to_pte_range(struct mm_
 
 static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create)
+				     pte_fn_t fn, void *data, bool create,
+				     pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -2249,7 +2253,7 @@ static int apply_to_pmd_range(struct mm_
 	BUG_ON(pud_huge(*pud));
 
 	if (create) {
-		pmd = pmd_alloc(mm, pud, addr);
+		pmd = pmd_alloc_track(mm, pud, addr, mask);
 		if (!pmd)
 			return -ENOMEM;
 	} else {
@@ -2259,7 +2263,7 @@ static int apply_to_pmd_range(struct mm_
 		next = pmd_addr_end(addr, end);
 		if (create || !pmd_none_or_clear_bad(pmd)) {
 			err = apply_to_pte_range(mm, pmd, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2269,14 +2273,15 @@ static int apply_to_pmd_range(struct mm_
 
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
@@ -2286,7 +2291,7 @@ static int apply_to_pud_range(struct mm_
 		next = pud_addr_end(addr, end);
 		if (create || !pud_none_or_clear_bad(pud)) {
 			err = apply_to_pmd_range(mm, pud, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2296,14 +2301,15 @@ static int apply_to_pud_range(struct mm_
 
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
@@ -2313,7 +2319,7 @@ static int apply_to_p4d_range(struct mm_
 		next = p4d_addr_end(addr, end);
 		if (create || !p4d_none_or_clear_bad(p4d)) {
 			err = apply_to_pud_range(mm, p4d, addr, next, fn, data,
-						 create);
+						 create, mask);
 			if (err)
 				break;
 		}
@@ -2326,8 +2332,9 @@ static int __apply_to_page_range(struct
 				 void *data, bool create)
 {
 	pgd_t *pgd;
-	unsigned long next;
+	unsigned long start = addr, next;
 	unsigned long end = addr + size;
+	pgtbl_mod_mask mask = 0;
 	int err = 0;
 
 	if (WARN_ON(addr >= end))
@@ -2338,11 +2345,14 @@ static int __apply_to_page_range(struct
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
 


