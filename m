Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9EE4B7A51
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 23:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241997AbiBOWQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 17:16:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbiBOWQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 17:16:32 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AFF27CCB;
        Tue, 15 Feb 2022 14:16:21 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so525380pjh.3;
        Tue, 15 Feb 2022 14:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7OEw+12Tu+QGErYY6AYOCWyYZULkoTChQDoAkZujfG4=;
        b=NSakA9Wjkggsq0RUgo7lk36re2BF88vTUf51mIuRZNptGy/SWlQTeC+5HHwhIVgIme
         bDepDeuTIm3HqaoTelNUyFXgdXX8Chk4B5E+dc78twJPZs1eViklFO4XwjW61SyZnx7Y
         FBJPCYio6ZdrHaIYH8oFpIINWR0202Uf/cEU7EaDEiKq8fnArEKBap4kcHhnOweGQAkV
         KF12RZ8gi8nWI5AMIJkbPQKgS4P+JEtZkTq8qRL+KW7Qh9VjHVSH++OxyIUg+0BRCVVw
         WzmfSwoAgqUoZTkfYixxzp6ubL7p8IH/RmG/i8prC5eRgqEqApwrGEOsehWiCDZF9pwA
         FPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7OEw+12Tu+QGErYY6AYOCWyYZULkoTChQDoAkZujfG4=;
        b=l+lJIh7f1f5yxFhm2mrK6wt9bUZe4L30vxFUjyGOzaZNXOjSHWAXTZY+Ldc8zApFBN
         cx05O7BPBOAYA73a18tGGjqIOHSi+71k8h3zyc6hzNfFYJfQrUL91W7LVx0eJEdriLJF
         eH/EFC8OP2+NqfOYCyWKJPRqX66saBtPx6Pcs/8yiJl1khwYf6/B9pAINuNcvxLFOac/
         ziM5MtHIcbJeyhk/D44Eu31zHF7ajufQ6qIoaYMzycXD1KvdXaNCS5wkF7xJLTlyw7ks
         Uqp1Nt7dbnbo5AkzzOJ+HnvoAgTqk+6pTbIjs43dEWbOgHh0FGQ4nKyRa+f32EqP4Vz9
         UWxA==
X-Gm-Message-State: AOAM532DkOs3eg/epgSHU3uqFFXdGTVT13C5/Y+9kNCF2qGJEEfqLbjq
        pnDIXV9XNXpydIO8AYSiYfc=
X-Google-Smtp-Source: ABdhPJxWNNyUE4Sb/s61TxH0rnP7VtPJZsvTc4fOMDVNe7zAE43p6zMnKV6EL7C9bU5p7hVLBURrZg==
X-Received: by 2002:a17:90a:760d:b0:1b5:5b63:d052 with SMTP id s13-20020a17090a760d00b001b55b63d052mr6948901pjk.24.1644963380809;
        Tue, 15 Feb 2022 14:16:20 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net. [67.174.241.145])
        by smtp.gmail.com with ESMTPSA id om2sm3641648pjb.39.2022.02.15.14.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:16:18 -0800 (PST)
From:   Yang Shi <shy828301@gmail.com>
To:     gregkh@linuxfoundation.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, david@redhat.com, jannh@google.com,
        kirill.shutemov@linux.intel.com, nathan@kernel.org,
        willy@infradead.org
Cc:     shy828301@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [stable-5.10 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
Date:   Tue, 15 Feb 2022 14:16:16 -0800
Message-Id: <20220215221616.855894-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 24d7275ce2791829953ed4e72f68277ceb2571c6 upstream

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
---
 fs/proc/task_mmu.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3931f60e421f..ba98371e9d16 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -430,7 +430,8 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 }
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty, bool locked)
+		bool compound, bool young, bool dirty, bool locked,
+		bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -457,8 +458,15 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
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
@@ -495,6 +503,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
@@ -514,9 +523,10 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
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
@@ -530,7 +540,8 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte), locked);
+	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
+		      locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -541,6 +552,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pmd_present(*pmd)) {
 		/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -548,8 +560,10 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
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
@@ -561,7 +575,9 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
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
@@ -1366,6 +1382,7 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1383,8 +1400,10 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
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
@@ -1392,7 +1411,7 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && page_mapcount(page) == 1)
+	if (page && !migration && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1408,8 +1427,9 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
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
@@ -1444,11 +1464,12 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
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
-- 
2.26.3

