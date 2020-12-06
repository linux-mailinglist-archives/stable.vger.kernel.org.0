Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD7E2D0126
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 07:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgLFGPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 01:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgLFGPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 01:15:35 -0500
Date:   Sat, 05 Dec 2020 22:14:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235293;
        bh=DoO5WKkihVsou738paX48uPDiMMJVQG9M3iLZY5SvP4=;
        h=From:To:Subject:In-Reply-To:From;
        b=MnoB9zIJp6xHK1OmpuMbKCNGm+/GhCt+CUTEHoz9zu6pR4WiT2Zg5OABgOPwinatp
         FgX08/5DquOPuKMZo07+6G/gBjfOB7IN2wLhPR4x1pmBFBHN7fZxIPDLQclxL3h0Pd
         Rx6kFhFqyqxrQU/Qrx4w+nITZl2jB+ZudgJJocoA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, harish@linux.ibm.com, hch@infradead.org,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 05/12] mm/zsmalloc.c: drop
 ZSMALLOC_PGTABLE_MAPPING
Message-ID: <20201206061451.IlxWUdUQr%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

While I was doing zram testing, I found sometimes decompression failed
since the compression buffer was corrupted.  With investigation, I found
below commit calls cond_resched unconditionally so it could make a problem
in atomic context if the task is reschedule.

[   55.109012] BUG: sleeping function called from invalid context at mm/vmalloc.c:108
[   55.110774] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
[   55.111973] 3 locks held by memhog/946:
[   55.112807]  #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
[   55.114151]  #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
[   55.115848]  #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
[   55.118947] CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
[   55.121265] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
[   55.122540] Call Trace:
[   55.122974]  dump_stack+0x8b/0xb8
[   55.123588]  ___might_sleep.cold+0xb6/0xc6
[   55.124328]  unmap_kernel_range_noflush+0x2eb/0x350
[   55.125198]  unmap_kernel_range+0x14/0x30
[   55.125920]  zs_unmap_object+0xd5/0xe0
[   55.126604]  zram_bvec_rw.isra.0+0x38c/0x8e0
[   55.127462]  zram_rw_page+0x90/0x101
[   55.128199]  bdev_write_page+0x92/0xe0
[   55.128957]  ? swap_slot_free_notify+0xb0/0xb0
[   55.129841]  __swap_writepage+0x94/0x4a0
[   55.130636]  ? do_raw_spin_unlock+0x4b/0xa0
[   55.131462]  ? _raw_spin_unlock+0x1f/0x30
[   55.132261]  ? page_swapcount+0x6c/0x90
[   55.133038]  pageout+0xe3/0x3a0
[   55.133702]  shrink_page_list+0xb94/0xd60
[   55.134626]  shrink_inactive_list+0x158/0x460

We can fix this by removing the ZSMALLOC_PGTABLE_MAPPING feature (which
contains the offending calling code) from zsmalloc.

Even though this option showed some amount improvement(e.g., 30%) in some
arm32 platforms, it has been headache to maintain since it have abused
APIs[1](e.g., unmap_kernel_range in atomic context).

Since we are approaching to deprecate 32bit machines and already made the
config option available for only builtin build since v5.8, lastly it has
been not default option in zsmalloc, it's time to drop the option for
better maintenance.

[1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org

Link: https://lkml.kernel.org/r/20201117202916.GA3856507@google.com
Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Harish Sriram <harish@linux.ibm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/omap2plus_defconfig |    1 
 include/linux/zsmalloc.h             |    1 
 mm/Kconfig                           |   13 ------
 mm/zsmalloc.c                        |   54 -------------------------
 4 files changed, 69 deletions(-)

--- a/arch/arm/configs/omap2plus_defconfig~mm-zsmallocc-drop-zsmalloc_pgtable_mapping
+++ a/arch/arm/configs/omap2plus_defconfig
@@ -81,7 +81,6 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_BINFMT_MISC=y
 CONFIG_CMA=y
 CONFIG_ZSMALLOC=m
-CONFIG_ZSMALLOC_PGTABLE_MAPPING=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
--- a/include/linux/zsmalloc.h~mm-zsmallocc-drop-zsmalloc_pgtable_mapping
+++ a/include/linux/zsmalloc.h
@@ -20,7 +20,6 @@
  * zsmalloc mapping modes
  *
  * NOTE: These only make a difference when a mapped object spans pages.
- * They also have no effect when ZSMALLOC_PGTABLE_MAPPING is selected.
  */
 enum zs_mapmode {
 	ZS_MM_RW, /* normal read-write mapping */
--- a/mm/Kconfig~mm-zsmallocc-drop-zsmalloc_pgtable_mapping
+++ a/mm/Kconfig
@@ -707,19 +707,6 @@ config ZSMALLOC
 	  returned by an alloc().  This handle must be mapped in order to
 	  access the allocated space.
 
-config ZSMALLOC_PGTABLE_MAPPING
-	bool "Use page table mapping to access object in zsmalloc"
-	depends on ZSMALLOC=y
-	help
-	  By default, zsmalloc uses a copy-based object mapping method to
-	  access allocations that span two pages. However, if a particular
-	  architecture (ex, ARM) performs VM mapping faster than copying,
-	  then you should select this. This causes zsmalloc to use page table
-	  mapping rather than copying for object mapping.
-
-	  You can check speed with zsmalloc benchmark:
-	  https://github.com/spartacus06/zsmapbench
-
 config ZSMALLOC_STAT
 	bool "Export zsmalloc statistics"
 	depends on ZSMALLOC
--- a/mm/zsmalloc.c~mm-zsmallocc-drop-zsmalloc_pgtable_mapping
+++ a/mm/zsmalloc.c
@@ -293,11 +293,7 @@ struct zspage {
 };
 
 struct mapping_area {
-#ifdef CONFIG_ZSMALLOC_PGTABLE_MAPPING
-	struct vm_struct *vm; /* vm area for mapping object that span pages */
-#else
 	char *vm_buf; /* copy buffer for objects that span pages */
-#endif
 	char *vm_addr; /* address of kmap_atomic()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
@@ -1113,54 +1109,6 @@ static struct zspage *find_get_zspage(st
 	return zspage;
 }
 
-#ifdef CONFIG_ZSMALLOC_PGTABLE_MAPPING
-static inline int __zs_cpu_up(struct mapping_area *area)
-{
-	/*
-	 * Make sure we don't leak memory if a cpu UP notification
-	 * and zs_init() race and both call zs_cpu_up() on the same cpu
-	 */
-	if (area->vm)
-		return 0;
-	area->vm = get_vm_area(PAGE_SIZE * 2, 0);
-	if (!area->vm)
-		return -ENOMEM;
-
-	/*
-	 * Populate ptes in advance to avoid pte allocation with GFP_KERNEL
-	 * in non-preemtible context of zs_map_object.
-	 */
-	return apply_to_page_range(&init_mm, (unsigned long)area->vm->addr,
-			PAGE_SIZE * 2, NULL, NULL);
-}
-
-static inline void __zs_cpu_down(struct mapping_area *area)
-{
-	if (area->vm)
-		free_vm_area(area->vm);
-	area->vm = NULL;
-}
-
-static inline void *__zs_map_object(struct mapping_area *area,
-				struct page *pages[2], int off, int size)
-{
-	unsigned long addr = (unsigned long)area->vm->addr;
-
-	BUG_ON(map_kernel_range(addr, PAGE_SIZE * 2, PAGE_KERNEL, pages) < 0);
-	area->vm_addr = area->vm->addr;
-	return area->vm_addr + off;
-}
-
-static inline void __zs_unmap_object(struct mapping_area *area,
-				struct page *pages[2], int off, int size)
-{
-	unsigned long addr = (unsigned long)area->vm_addr;
-
-	unmap_kernel_range(addr, PAGE_SIZE * 2);
-}
-
-#else /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
 	/*
@@ -1241,8 +1189,6 @@ out:
 	pagefault_enable();
 }
 
-#endif /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-
 static int zs_cpu_prepare(unsigned int cpu)
 {
 	struct mapping_area *area;
_
