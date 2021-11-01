Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A731441FFC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 19:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhKAS0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 14:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhKAS0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 14:26:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8978E60F24;
        Mon,  1 Nov 2021 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635791044;
        bh=05120Uij6/xNXBH76cTfnHuBXkTUcV9TEPEbwDgCew8=;
        h=Date:From:To:Subject:From;
        b=wJ7ZaMBUAfE8K1vD07dBWpWRB9PbndZcQFVbG8A15XbnfZDRGwwDRlYIGDcHawYPY
         uxw9A8hHZbocea9oEgbb2b6KMKAefENcUD+ZvqWaaoVQldYNhc5f6JfsjcGuear0hw
         8FS5wYARlb7FSOH3S41yxVFyJ80JbANrbSkel9JA=
Date:   Mon, 01 Nov 2021 11:24:04 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-hwpoison-remove-the-unnecessary-thp-check.patch removed from -mm tree
Message-ID: <20211101182404.WcCadw8Ab%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: remove the unnecessary THP check
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-the-unnecessary-thp-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: hwpoison: remove the unnecessary THP check

When handling THP hwpoison checked if the THP is in allocation or free
stage since hwpoison may mistreat it as hugetlb page.  After commit
415c64c1453a ("mm/memory-failure: split thp earlier in memory error
handling") the problem has been fixed, so this check is no longer needed. 
Remove it.  The side effect of the removal is hwpoison may report unsplit
THP instead of unknown error for shmem THP.  It seems not like a big deal.

The following patch "mm: filemap: check if THP has hwpoisoned subpage for
PMD page fault" depends on this, which fixes shmem THP with hwpoisoned
subpage(s) are mapped PMD wrongly.  So this patch needs to be backported
to -stable as well.

Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-the-unnecessary-thp-check
+++ a/mm/memory-failure.c
@@ -1147,20 +1147,6 @@ static int __get_hwpoison_page(struct pa
 	if (!HWPoisonHandlable(head))
 		return -EBUSY;
 
-	if (PageTransHuge(head)) {
-		/*
-		 * Non anonymous thp exists only in allocation/free time. We
-		 * can't handle such a case correctly, so let's give it up.
-		 * This should be better than triggering BUG_ON when kernel
-		 * tries to touch the "partially handled" page.
-		 */
-		if (!PageAnon(head)) {
-			pr_err("Memory failure: %#lx: non anonymous thp\n",
-				page_to_pfn(page));
-			return 0;
-		}
-	}
-
 	if (get_page_unless_zero(head)) {
 		if (head == compound_head(page))
 			return 1;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

