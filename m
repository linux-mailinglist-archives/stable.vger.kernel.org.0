Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3996148CE0F
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 22:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiALV4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 16:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiALV4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 16:56:33 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339BCC06173F;
        Wed, 12 Jan 2022 13:56:29 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c3so6446700pls.5;
        Wed, 12 Jan 2022 13:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ijM9h79g8cahIAMDtnBNGHSkBrmmHiRrXsU2EXgUnwU=;
        b=jkv8U9bkQmbeI+nH+bC3txAKrP2iFBVpGtt0h8q3hSiJeWIDCQaqWNWzeWhMe8+W74
         HLdVeUYssPePqAWrx3Kfu52ZmHapresCaOCzIxSusgjKGITYEjywPUNBDtppEIFplQMo
         JwOv4rplBBT97MoNt2MsppKlETzx4GAjLu4lxG4WO9EjPyU4wTTgsbvqZDkaXPtTFGwN
         uO7lgH4bgQyGIFPU8Rw/+n/iOgTmBPZXA6YOBhmIEgOkYZ8Bx1NMoqNoPAM5imUyZ86+
         4R/HH5TBs2RMq9WYspdZLfEVP1wlT+4C1RTowIgP/fvmv2U0DVsv1mgjnG+oqrOgM+PI
         XhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ijM9h79g8cahIAMDtnBNGHSkBrmmHiRrXsU2EXgUnwU=;
        b=2xuOvpLrKmaBjZWURSbFUYwNbmGqF/D79dlHgT3NZNPMVDoqvQgUHuuh+oP9IzFLT6
         WuRQV46AV/NiHZTZ7xPdinofMRUGoAHl2Ha+eBh4TPaAlTrkvJOFX8LJ9ib+VGNzvRD2
         jawlT/C9FoGbPnawyeBbmwsQzsAAIgOLLQhV1c4FP0QfnQ2H0yrkAzerO/YqAx/kR9t7
         KVa1OcQJq1Eaq0IrxpS1nQFnStDUBD0UHJJY7uWuQwNkZpOcYyV91N2FYnuVl587zMNt
         rFaQ+WcTc0TfSsOLvw9tW+/UDJvIGWBN8kRD5EB2JGUyLqB/gqwyeqik3VHq9GobNcTK
         WdLA==
X-Gm-Message-State: AOAM5312e3Ve/I4qi12gQBFiXiLp2oQe+UQrXssIEUsss29e7Gp6xAKu
        92Ncjf4wBR9rFgIxvvuEEik=
X-Google-Smtp-Source: ABdhPJydFBxICmFcQQSTntz+PVSthUkQrb8G4mJxrNG3RulO6owoD70opZMv/DaBOVqstBjoa9lhkQ==
X-Received: by 2002:a17:902:d103:b0:14a:421f:a66 with SMTP id w3-20020a170902d10300b0014a421f0a66mr1415598plw.2.1642024588553;
        Wed, 12 Jan 2022 13:56:28 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net. [67.174.241.145])
        by smtp.gmail.com with ESMTPSA id h1sm532505pfi.109.2022.01.12.13.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 13:56:27 -0800 (PST)
From:   Yang Shi <shy828301@gmail.com>
To:     kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, akpm@linux-foundation.org
Cc:     shy828301@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
Date:   Wed, 12 Jan 2022 13:56:25 -0800
Message-Id: <20220112215625.4144871-1-shy828301@gmail.com>
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

Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Yang Shi <shy828301@gmail.com>
---
 fs/proc/task_mmu.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ad667dbc96f5..3146a94a3fe1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -429,7 +429,8 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 }
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty, bool locked)
+		bool compound, bool young, bool dirty, bool locked,
+		bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -456,8 +457,12 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 	 * page_count(page) == 1 guarantees the page is mapped exactly once.
 	 * If any subpage of the compound page mapped with PTE it would elevate
 	 * page_count().
+	 *
+	 * Treated regular migration entries as mapcount == 1 without reading
+	 * mapcount since calling page_mapcount() for migration entries is
+	 * racy against THP splitting.
 	 */
-	if (page_count(page) == 1) {
+	if ((page_count(page) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
 			locked, true);
 		return;
@@ -506,6 +511,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
@@ -525,8 +531,11 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
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
@@ -535,7 +544,8 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte), locked);
+	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
+		      locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -546,6 +556,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pmd_present(*pmd)) {
 		/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -553,8 +564,10 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
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
@@ -566,7 +579,9 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
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
-- 
2.26.3

