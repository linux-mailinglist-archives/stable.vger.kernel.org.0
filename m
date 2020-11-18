Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E8F2B75A8
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 06:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgKRFSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 00:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgKRFSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 00:18:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E6B824654;
        Wed, 18 Nov 2020 05:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605676725;
        bh=uJ2yaRpp3xOZzVHwZ6cl8syQlBayqXLn6oyOhwtAOPk=;
        h=Date:From:To:Subject:From;
        b=I7GY0nSIz2kdr1y5MHUVieQWyfmBgG2ZGt9tOTEXERCR2Qe+Pene0UpE8EXKMBs/C
         1ZBBM6jynQyawTwKbLb+GMMgoNm7ldofpfsysmKwABEJwTW3B/PLwcRHqaMDt6lpNA
         +ENFmSU0lOI7u9oqWcGfI3PUdMyDOYr6/K/ogpPs=
Date:   Tue, 17 Nov 2020 21:18:44 -0800
From:   akpm@linux-foundation.org
To:     harish@linux.ibm.com, hch@infradead.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org, tony@atomide.com, urezki@gmail.com
Subject:  + mm-zsmallocc-drop-zsmalloc_pgtable_mapping.patch added
 to -mm tree
Message-ID: <20201118051844.VJ0VzT8MU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING
has been added to the -mm tree.  Its filename is
     mm-zsmallocc-drop-zsmalloc_pgtable_mapping.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zsmallocc-drop-zsmalloc_pgtable_mapping.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmallocc-drop-zsmalloc_pgtable_mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

We can fix this by removing the ZSMALLOC_PGTABLE_MAPPING feature (whcih
contains the offending calling code) from zsmalloc.

Even though this option showed some amount improvement(e.g., 30%) in some
arm32 platforms, it has been headache to maintain since it have abused
APIs[1](e.g., unmap_kernel_range in atomic context).

Since we are approaching to deprecate 32bit machines and already made the
config option available for only builtin build since v5.8, lastly it has
been not default option in zsmalloc, it's time to drop the option for
better maintainance.

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

Patches currently in -mm which might be from minchan@kernel.org are

mm-zsmallocc-drop-zsmalloc_pgtable_mapping.patch
zram-support-a-page-writeback.patch

