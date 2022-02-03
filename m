Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE064A9081
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 23:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355716AbiBCWNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 17:13:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51330 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiBCWNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 17:13:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40522B835AD;
        Thu,  3 Feb 2022 22:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B551EC340E8;
        Thu,  3 Feb 2022 22:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643926385;
        bh=o18xTQyoTmUCADBNLUYn3T/m5mcv0I3Q3quUIzZ3xV4=;
        h=Date:To:From:Subject:From;
        b=kI0DlaInRaSsxsntqVNhj7yXnx5hm0n1clRESweQ7DEVFpNsLGv2rgXK1tgW8ie8e
         pcQuTA0WIdW988g0f8pq1++K713QpnmdiT4tn1TjSBrWOgwNnRc3jwnJc+C3azeOnM
         uAFMQ1UdtIrmKb5Y/ai5GA/4tuGho3Nh6NhJMiAg=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 14:13:03 -0800
Date:   Thu, 03 Feb 2022 14:13:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, kirill.shutemov@linux.intel.com,
        jannh@google.com, david@redhat.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4.patch added to -mm tree
Message-Id: <20220203221303.B551EC340E8@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4

v4: * s/Treated/Treat per David
    * Collected acked-by tag from David
v3: * Fixed the fix tag, the one used by v2 was not accurate
    * Added comment about the risk calling page_mapcount() per David
    * Fix pagemap

Link: https://lkml.kernel.org/r/20220203182641.824731-1-shy828301@gmail.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4
+++ a/fs/proc/task_mmu.c
@@ -469,9 +469,12 @@ static void smaps_account(struct mem_siz
 	 * If any subpage of the compound page mapped with PTE it would elevate
 	 * page_count().
 	 *
-	 * Treated regular migration entries as mapcount == 1 without reading
-	 * mapcount since calling page_mapcount() for migration entries is
-	 * racy against THP splitting.
+	 * The page_mapcount() is called to get a snapshot of the mapcount.
+	 * Without holding the page lock this snapshot can be slightly wrong as
+	 * we cannot always read the mapcount atomically.  It is not safe to
+	 * call page_mapcount() even with PTL held if the page is not mapped,
+	 * especially for migration entries.  Treat regular migration entries
+	 * as mapcount == 1.
 	 */
 	if ((page_count(page) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
@@ -1393,6 +1396,7 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1414,13 +1418,14 @@ static pagemap_entry_t pte_to_pagemap_en
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
@@ -1436,6 +1441,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
+	bool migration = false;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmdp, vma);
@@ -1476,11 +1482,12 @@ static int pagemap_pmd_range(pmd_t *pmdp
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

Patches currently in -mm which might be from shy828301@gmail.com are

fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry.patch
fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4.patch

