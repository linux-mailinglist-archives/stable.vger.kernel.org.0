Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BA04355C5
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 00:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJTWPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 18:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 18:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC162611CC;
        Wed, 20 Oct 2021 22:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634767976;
        bh=p8kbeUqtKX3PuFxBQh4y+MBlItyRkCFal1G4mehpmKI=;
        h=Date:From:To:Subject:From;
        b=PR+DS/PSo0USa4/CSrqvS3xJ5iiQYkhHg/TBGZstsSfHl0irCZx3lyvpj4rGDW38c
         wOKIvBZ49oRlHZoCMquBbEZjIzZfcwW7NEBvUyoa2Rb3KhS1NLOjvJlawzQi3h6QD9
         SaqsbOMBS0vwXe6kBehfS70uhojoOl/33jun70is=
Date:   Wed, 20 Oct 2021 15:12:55 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  + mm-hwpoison-remove-the-unnecessary-thp-check.patch
 added to -mm tree
Message-ID: <20211020221255.OJQ8SwOCh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: remove the unnecessary THP check
has been added to the -mm tree.  Its filename is
     mm-hwpoison-remove-the-unnecessary-thp-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-remove-the-unnecessary-thp-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-remove-the-unnecessary-thp-check.patch

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

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch

