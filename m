Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932C64A8B9D
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 19:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiBCS0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 13:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353422AbiBCS0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 13:26:52 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A37C061714;
        Thu,  3 Feb 2022 10:26:52 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id j16so2876845plx.4;
        Thu, 03 Feb 2022 10:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+UWTZfIIw6vBphVS0iDa4Bn1P/iiOtii+RT3gDvcpYM=;
        b=BYVa0XPN9/C0GZnne6WH3u6IsaHNRvy9BVtpAcuKv9xat71+KvfUBNbjAJHFkieKgR
         HWmAia3EJJs2FJmlABVLY4d4Y/MOfE9SAQg9GQ+LcYa2MZUb5za360O8O2iwhaP3wqBp
         wzVVWJm6RAQ1pDIiak3XcdzeYPw3e36pzd1Wqpxhed/8+cWsZyFwqlb2+j7e1bsOUHXL
         Tx1I2d6JBuz5n64i9/AgkmCiFmxv1Kx+m9fH7kojdO/KCePWpACA0AOZLbriE5pzGu5A
         wpz3QLpCsh64qwG9PR2ZJy6/cG+jQbT3vZqYhB2xBTr6JtiX+5PTQfAf5Bod7ZmWYy6+
         jVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+UWTZfIIw6vBphVS0iDa4Bn1P/iiOtii+RT3gDvcpYM=;
        b=r1eFAGNVrTVpPE2NmnAFySLBAI64WaHzsaV8ZNss/dwfF1nIv7+9Xftckx7UvR6K2x
         IyApgLsoH8mBaZvaxHCbF6TIf4dzejP8ZSN7OUpnVJ0k4oo16kOcblm3lue35sczbgaR
         WIAbrOcka80rnFxjTyeXjao6JCIev/w4pguMEOJmn7czoQfHUBvL+owL7xdqq/NxLIKB
         T/UsId6e7pfDDyFj9cJrruzGut8WQzbYwuzPC07DcCaMLp+AXFDbD+N49nfAUonIc18v
         /J60dwVsMulHLObYOOf2upPRnYnrrk0njDwnoL5X6mb2LoWjhxFyVZuDUWAOHJD08TXH
         93+w==
X-Gm-Message-State: AOAM533xtQRpehTMSJgk2f+m64NtHqL4c078rhT6nE+5MNWkv+Z7NS/r
        sihVoOyooWC+X9HL7UVIXL/bMkzcXdM=
X-Google-Smtp-Source: ABdhPJwFrnT0GD9Knf86flQ/HlmQ+/ihBU+UI6Vq1wWQtHAK2sUfoWQxcVY+WtxiiEEhpH2+6QtSow==
X-Received: by 2002:a17:902:ec86:: with SMTP id x6mr37289585plg.96.1643912811831;
        Thu, 03 Feb 2022 10:26:51 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net. [67.174.241.145])
        by smtp.gmail.com with ESMTPSA id l13sm37418602pgs.16.2022.02.03.10.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:26:46 -0800 (PST)
From:   Yang Shi <shy828301@gmail.com>
To:     kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, david@redhat.com, akpm@linux-foundation.org
Cc:     shy828301@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
Date:   Thu,  3 Feb 2022 10:26:41 -0800
Message-Id: <20220203182641.824731-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

The reproducer was trying to reading /proc/$PID/smaps when calling
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
mapcount, but it prevents from counting migration entries, and it seems
overkilling because the race just could happen when PMD is split so all
PTE entries of tail pages are actually migration entries, and
smaps_account() does treat migration entries as mapcount == 1 as Kirill
pointed out.

Add a new parameter for smaps_account() to tell this entry is migration
entry then skip calling page_mapcount().  Don't skip getting mapcount for
device private entries since they do track references with mapcount.

Pagemap also has the similar issue although it was not reported.  Fixed
it as well.

Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Yang Shi <shy828301@gmail.com>
---
v4: * s/Treated/Treat per David
    * Collected acked-by tag from David
v3: * Fixed the fix tag, the one used by v2 was not accurate
    * Added comment about the risk calling page_mapcount() per David
    * Fix pagemap
v2: * Added proper fix tag per Jann Horn
    * Rebased to the latest linus's tree

 fs/proc/task_mmu.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 18f8c3acbb85..bc2f46033231 100644
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
@@ -1421,6 +1441,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
+	bool migration = false;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmdp, vma);
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
-- 
2.26.3

