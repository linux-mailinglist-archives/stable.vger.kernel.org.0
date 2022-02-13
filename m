Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349EB4B3B16
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 12:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiBMLXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 06:23:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbiBMLXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 06:23:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCAC5B883
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 03:23:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 380F060FF8
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE88C004E1;
        Sun, 13 Feb 2022 11:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644751383;
        bh=ICJDNxq+vv1kQXvjaJGDJ3MH5qyRZqk1wCkbSdCXWag=;
        h=Subject:To:Cc:From:Date:From;
        b=POeN0g+0C/iYPVOS2S66X65xez2RWU+sOi2bWMLeUAja4xCCzAONaOXoa0sN4aNaa
         OB1wK2SYnNoduZ0OKkMfr9STsPEwhwn/Z00UYflcppSUoCOciI66UmRzoOsrRi738j
         Ub6JVf7t0WXX97f7KkuBGE5XmFuPshq1+/xLbkyw=
Subject: FAILED: patch "[PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry" failed to apply to 5.4-stable tree
To:     shy828301@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, david@redhat.com, jannh@google.com,
        kirill.shutemov@linux.intel.com, nathan@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Feb 2022 12:22:54 +0100
Message-ID: <164475137413510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 24d7275ce2791829953ed4e72f68277ceb2571c6 Mon Sep 17 00:00:00 2001
From: Yang Shi <shy828301@gmail.com>
Date: Fri, 11 Feb 2022 16:32:26 -0800
Subject: [PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry

The syzbot reported the below BUG:

  kernel BUG at include/linux/page-flags.h:785!
  invalid opcode: 0000 [#1] PREEMPT SMP KASAN
  CPU: 1 PID: 4392 Comm: syz-executor560 Not tainted 5.16.0-rc6-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
  RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
  Call Trace:
    page_mapcount include/linux/mm.h:837 [inline]
    smaps_account+0x470/0xb10 fs/proc/task_mmu.c:466
    smaps_pte_entry fs/proc/task_mmu.c:538 [inline]
    smaps_pte_range+0x611/0x1250 fs/proc/task_mmu.c:601
    walk_pmd_range mm/pagewalk.c:128 [inline]
    walk_pud_range mm/pagewalk.c:205 [inline]
    walk_p4d_range mm/pagewalk.c:240 [inline]
    walk_pgd_range mm/pagewalk.c:277 [inline]
    __walk_page_range+0xe23/0x1ea0 mm/pagewalk.c:379
    walk_page_vma+0x277/0x350 mm/pagewalk.c:530
    smap_gather_stats.part.0+0x148/0x260 fs/proc/task_mmu.c:768
    smap_gather_stats fs/proc/task_mmu.c:741 [inline]
    show_smap+0xc6/0x440 fs/proc/task_mmu.c:822
    seq_read_iter+0xbb0/0x1240 fs/seq_file.c:272
    seq_read+0x3e0/0x5b0 fs/seq_file.c:162
    vfs_read+0x1b5/0x600 fs/read_write.c:479
    ksys_read+0x12d/0x250 fs/read_write.c:619
    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    entry_SYSCALL_64_after_hwframe+0x44/0xae

The reproducer was trying to read /proc/$PID/smaps when calling
MADV_FREE at the mean time.  MADV_FREE may split THPs if it is called
for partial THP.  It may trigger the below race:

           CPU A                         CPU B
           -----                         -----
  smaps walk:                      MADV_FREE:
  page_mapcount()
    PageCompound()
                                   split_huge_page()
    page = compound_head(page)
    PageDoubleMap(page)

When calling PageDoubleMap() this page is not a tail page of THP anymore
so the BUG is triggered.

This could be fixed by elevated refcount of the page before calling
mapcount, but that would prevent it from counting migration entries, and
it seems overkilling because the race just could happen when PMD is
split so all PTE entries of tail pages are actually migration entries,
and smaps_account() does treat migration entries as mapcount == 1 as
Kirill pointed out.

Add a new parameter for smaps_account() to tell this entry is migration
entry then skip calling page_mapcount().  Don't skip getting mapcount
for device private entries since they do track references with mapcount.

Pagemap also has the similar issue although it was not reported.  Fixed
it as well.

[shy828301@gmail.com: v4]
  Link: https://lkml.kernel.org/r/20220203182641.824731-1-shy828301@gmail.com
[nathan@kernel.org: avoid unused variable warning in pagemap_pmd_range()]
  Link: https://lkml.kernel.org/r/20220207171049.1102239-1-nathan@kernel.org
Link: https://lkml.kernel.org/r/20220120202805.3369-1-shy828301@gmail.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 18f8c3acbb85..6e97ed775074 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -440,7 +440,8 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 }
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty, bool locked)
+		bool compound, bool young, bool dirty, bool locked,
+		bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -467,8 +468,15 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 	 * page_count(page) == 1 guarantees the page is mapped exactly once.
 	 * If any subpage of the compound page mapped with PTE it would elevate
 	 * page_count().
+	 *
+	 * The page_mapcount() is called to get a snapshot of the mapcount.
+	 * Without holding the page lock this snapshot can be slightly wrong as
+	 * we cannot always read the mapcount atomically.  It is not safe to
+	 * call page_mapcount() even with PTL held if the page is not mapped,
+	 * especially for migration entries.  Treat regular migration entries
+	 * as mapcount == 1.
 	 */
-	if (page_count(page) == 1) {
+	if ((page_count(page) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
 			locked, true);
 		return;
@@ -517,6 +525,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
@@ -536,8 +545,11 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 			} else {
 				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
 			}
-		} else if (is_pfn_swap_entry(swpent))
+		} else if (is_pfn_swap_entry(swpent)) {
+			if (is_migration_entry(swpent))
+				migration = true;
 			page = pfn_swap_entry_to_page(swpent);
+		}
 	} else {
 		smaps_pte_hole_lookup(addr, walk);
 		return;
@@ -546,7 +558,8 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte), locked);
+	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
+		      locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -557,6 +570,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pmd_present(*pmd)) {
 		/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -564,8 +578,10 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
-		if (is_migration_entry(entry))
+		if (is_migration_entry(entry)) {
+			migration = true;
 			page = pfn_swap_entry_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
@@ -577,7 +593,9 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 		/* pass */;
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd), locked);
+
+	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
+		      locked, migration);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -1378,6 +1396,7 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1399,13 +1418,14 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 			frame = swp_type(entry) |
 				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 		flags |= PM_SWAP;
+		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 	}
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && page_mapcount(page) == 1)
+	if (page && !migration && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1421,8 +1441,9 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bool migration = false;
+
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
 		u64 flags = 0, frame = 0;
@@ -1461,11 +1482,12 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
+			migration = is_migration_entry(entry);
 			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
-		if (page && page_mapcount(page) == 1)
+		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {

