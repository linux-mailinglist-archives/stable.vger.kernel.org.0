Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8054B3205
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 01:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354404AbiBLAca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 19:32:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346048AbiBLAca (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 19:32:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB1D7E;
        Fri, 11 Feb 2022 16:32:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4E8061D21;
        Sat, 12 Feb 2022 00:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A586C340E9;
        Sat, 12 Feb 2022 00:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625947;
        bh=t7Gdqg8m3Ku1AmNl0cVopVqmVwlq1uiT7wKtTtRcEWw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=T2Q2C8mNVC+9gs/FhOTDR4GW1yCSoaWrMZWJ1hhELNXSyD8ZhIQcXFhM5nNb4JKLw
         f56KO/RDkDQ5314+zMuc65XcIR6SJMELd/pADHKbn4dr3kj/+/fj/QxBV9t8AuFOu4
         ++weOj4Lb9js73f4gXOwvret08PkqgQ84uItzVhs=
Date:   Fri, 11 Feb 2022 16:32:26 -0800
To:     willy@infradead.org, stable@vger.kernel.org, nathan@kernel.org,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        david@redhat.com, adobriyan@gmail.com, shy828301@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 2/5] fs/proc: task_mmu.c: don't read mapcount for migration entry
Message-Id: <20220212003227.1A586C340E9@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: fs/proc: task_mmu.c: don't read mapcount for migration entry

The syzbot reported the below BUG:

kernel BUG at include/linux/page-flags.h:785!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 4392 Comm: syz-executor560 Not tainted 5.16.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
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
RIP: 0033:0x7faa2af6c969
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faa2aefd288 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007faa2aff4418 RCX: 00007faa2af6c969
RDX: 0000000000002025 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00007faa2aff4410 R08: 00007faa2aefd700 R09: 0000000000000000
R10: 00007faa2aefd700 R11: 0000000000000246 R12: 00007faa2afc20ac
R13: 00007fff7e6632bf R14: 00007faa2aefd400 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 24ec93ff95e4ac3d ]---
RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

The reproducer was trying to read /proc/$PID/smaps when calling MADV_FREE
at the mean time.  MADV_FREE may split THPs if it is called for partial
THP.  It may trigger the below race:

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
mapcount, but it prevents from counting migration entries, and it seems
overkilling because the race just could happen when PMD is split so all
PTE entries of tail pages are actually migration entries, and
smaps_account() does treat migration entries as mapcount == 1 as Kirill
pointed out.

Add a new parameter for smaps_account() to tell this entry is migration
entry then skip calling page_mapcount().  Don't skip getting mapcount for
device private entries since they do track references with mapcount.

Pagemap also has the similar issue although it was not reported.  Fixed it
as well.

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
---


--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry
+++ a/fs/proc/task_mmu.c
@@ -440,7 +440,8 @@ static void smaps_page_accumulate(struct
 }
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty, bool locked)
+		bool compound, bool young, bool dirty, bool locked,
+		bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -467,8 +468,15 @@ static void smaps_account(struct mem_siz
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
@@ -517,6 +525,7 @@ static void smaps_pte_entry(pte_t *pte,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
@@ -536,8 +545,11 @@ static void smaps_pte_entry(pte_t *pte,
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
@@ -546,7 +558,8 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte), locked);
+	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
+		      locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -557,6 +570,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pmd_present(*pmd)) {
 		/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -564,8 +578,10 @@ static void smaps_pmd_entry(pmd_t *pmd,
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
@@ -577,7 +593,9 @@ static void smaps_pmd_entry(pmd_t *pmd,
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
@@ -1378,6 +1396,7 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1399,13 +1418,14 @@ static pagemap_entry_t pte_to_pagemap_en
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
@@ -1421,8 +1441,9 @@ static int pagemap_pmd_range(pmd_t *pmdp
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
@@ -1461,11 +1482,12 @@ static int pagemap_pmd_range(pmd_t *pmdp
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
_
