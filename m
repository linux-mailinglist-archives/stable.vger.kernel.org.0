Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9273B4BDDE6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347772AbiBUJKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:10:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347684AbiBUJJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:09:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511FF1C91B;
        Mon, 21 Feb 2022 01:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2896B80EAF;
        Mon, 21 Feb 2022 09:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB9EC340E9;
        Mon, 21 Feb 2022 09:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434129;
        bh=QyhWKbi3kTTQzo1FfuRzhxXPERoG6pREIGQuWkvw8zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixINp6TxUXZDcROqIh1EEGyrb8tiNxJvQ6ZP3tb3YGi2UuyIXuNB7ME2jTtO8FiyI
         2w92qn09RNgm/ZYeHdCxQ8pbKg2RNMIwzZwL+R5pMTCpc8OYc71y4DwhVff0FxMsVq
         od8fnCZ6UAvGeyQJFgzKFabfZvT3gX1AW/nJxt2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com,
        David Hildenbrand <david@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 005/121] fs/proc: task_mmu.c: dont read mapcount for migration entry
Date:   Mon, 21 Feb 2022 09:48:17 +0100
Message-Id: <20220221084921.330715455@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit 24d7275ce2791829953ed4e72f68277ceb2571c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -430,7 +430,8 @@ static void smaps_page_accumulate(struct
 }
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty, bool locked)
+		bool compound, bool young, bool dirty, bool locked,
+		bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -457,8 +458,15 @@ static void smaps_account(struct mem_siz
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
@@ -495,6 +503,7 @@ static void smaps_pte_entry(pte_t *pte,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
@@ -514,9 +523,10 @@ static void smaps_pte_entry(pte_t *pte,
 			} else {
 				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
 			}
-		} else if (is_migration_entry(swpent))
+		} else if (is_migration_entry(swpent)) {
+			migration = true;
 			page = migration_entry_to_page(swpent);
-		else if (is_device_private_entry(swpent))
+		} else if (is_device_private_entry(swpent))
 			page = device_private_entry_to_page(swpent);
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
@@ -530,7 +540,8 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte), locked);
+	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
+		      locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -541,6 +552,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pmd_present(*pmd)) {
 		/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -548,8 +560,10 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
-		if (is_migration_entry(entry))
+		if (is_migration_entry(entry)) {
+			migration = true;
 			page = migration_entry_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
@@ -561,7 +575,9 @@ static void smaps_pmd_entry(pmd_t *pmd,
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
@@ -1366,6 +1382,7 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1383,8 +1400,10 @@ static pagemap_entry_t pte_to_pagemap_en
 			frame = swp_type(entry) |
 				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 		flags |= PM_SWAP;
-		if (is_migration_entry(entry))
+		if (is_migration_entry(entry)) {
+			migration = true;
 			page = migration_entry_to_page(entry);
+		}
 
 		if (is_device_private_entry(entry))
 			page = device_private_entry_to_page(entry);
@@ -1392,7 +1411,7 @@ static pagemap_entry_t pte_to_pagemap_en
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && page_mapcount(page) == 1)
+	if (page && !migration && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1408,8 +1427,9 @@ static int pagemap_pmd_range(pmd_t *pmdp
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
@@ -1444,11 +1464,12 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			if (pmd_swp_soft_dirty(pmd))
 				flags |= PM_SOFT_DIRTY;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
+			migration = is_migration_entry(entry);
 			page = migration_entry_to_page(entry);
 		}
 #endif
 
-		if (page && page_mapcount(page) == 1)
+		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {


