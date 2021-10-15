Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B77D42FCF8
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 22:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhJOU20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 16:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232768AbhJOU20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 16:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32CA0611C8;
        Fri, 15 Oct 2021 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634329579;
        bh=AjhQ67GN7QB3t0/uQiLrDnGvOy4pyh5jQpoy12gN06g=;
        h=Date:From:To:Subject:From;
        b=LkgVR0/hUgBMReIQlzZn5mNue3iEOPloR+bq1fdIRVSFmebppv9ixTEcIgZYKKWbz
         PiXgfLhxSsoJQ9kFYSpV7kceaY73NmKhC5hjPaEZMiIh56DcgcOpnARhBWUE89iAn2
         5tXr1zJDUuIbxb4JMzGMvvECx1OEeniGmzQKp5mM=
Date:   Fri, 15 Oct 2021 13:26:18 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  + mm-hwpoison-remove-the-unnecessary-thp-check.patch
 added to -mm tree
Message-ID: <20211015202618.wVAkjGZIk%akpm@linux-foundation.org>
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

Patch series "Solve silent data loss caused by poisoned page cache (shmem/tmpfs)", v4.

When discussing the patch that splits page cache THP in order to offline
the poisoned page, Noaya mentioned there is a bigger problem [1] that
prevents this from working since the page cache page will be truncated if
uncorrectable errors happen.  By looking this deeper it turns out this
approach (truncating poisoned page) may incur silent data loss for all
non-readonly filesystems if the page is dirty.  It may be worse for
in-memory filesystem, e.g.  shmem/tmpfs since the data blocks are actually
gone.

To solve this problem we could keep the poisoned dirty page in page cache
then notify the users on any later access, e.g.  page fault, read/write,
etc.  The clean page could be truncated as is since they can be reread
from disk later on.

The consequence is the filesystems may find poisoned page and manipulate
it as healthy page since all the filesystems actually don't check if the
page is poisoned or not in all the relevant paths except page fault.  In
general, we need make the filesystems be aware of poisoned page before we
could keep the poisoned page in page cache in order to solve the data loss
problem.

To make filesystems be aware of poisoned page we should consider:
- The page should be not written back: clearing dirty flag could prevent from
  writeback.
- The page should not be dropped (it shows as a clean page) by drop caches or
  other callers: the refcount pin from hwpoison could prevent from invalidating
  (called by cache drop, inode cache shrinking, etc), but it doesn't avoid
  invalidation in DIO path.
- The page should be able to get truncated/hole punched/unlinked: it works as it
  is.
- Notify users when the page is accessed, e.g. read/write, page fault and other
  paths (compression, encryption, etc).

The scope of the last one is huge since almost all filesystems need do it once
a page is returned from page cache lookup.  There are a couple of options to
do it:

1. Check hwpoison flag for every path, the most straightforward way.
2. Return NULL for poisoned page from page cache lookup, the most callsites
   check if NULL is returned, this should have least work I think.  But the
   error handling in filesystems just return -ENOMEM, the error code will incur
   confusion to the users obviously.
3. To improve #2, we could return error pointer, e.g. ERR_PTR(-EIO), but this
   will involve significant amount of code change as well since all the paths
   need check if the pointer is ERR or not just like option #1.

I did prototype for both #1 and #3, but it seems #3 may require more
changes than #1.  For #3 ERR_PTR will be returned so all the callers need
to check the return value otherwise invalid pointer may be dereferenced,
but not all callers really care about the content of the page, for
example, partial truncate which just sets the truncated range in one page
to 0.  So for such paths it needs additional modification if ERR_PTR is
returned.  And if the callers have their own way to handle the problematic
pages we need to add a new FGP flag to tell FGP functions to return the
pointer to the page.

It may happen very rarely, but once it happens the consequence (data
corruption) could be very bad and it is very hard to debug.  It seems this
problem had been slightly discussed before, but seems no action was taken
at that time.  [2]

As the aforementioned investigation, it needs huge amount of work to solve
the potential data loss for all filesystems.  But it is much easier for
in-memory filesystems and such filesystems actually suffer more than
others since even the data blocks are gone due to truncating.  So this
patchset starts from shmem/tmpfs by taking option #1.

TODO:
* The unpoison has been broken since commit 0ed950d1f281 ("mm,hwpoison: make
  get_hwpoison_page() call get_any_page()"), and this patch series make
  refcount check for unpoisoning shmem page fail.
* Expand to other filesystems.  But I haven't heard feedback from filesystem
  developers yet.

Patch breakdown:
Patch #1: cleanup, depended by patch #2
Patch #2: fix THP with hwpoisoned subpage(s) PMD map bug
Patch #3: coding style cleanup
Patch #4: refactor and preparation.
Patch #5: keep the poisoned page in page cache and handle such case for all
          the paths.
Patch #6: the previous patches unblock page cache THP split, so this patch
          add page cache THP split support.


This patch (of 6):

When handling THP hwpoison checked if the THP is in allocation or free
stage since hwpoison may mistreat it as hugetlb page.  After commit
415c64c1453a ("mm/memory-failure: split thp earlier in memory error
handling") the problem has been fixed, so this check is no longer needed. 
Remove it.  The side effect of the removal is hwpoison may report unsplit
THP instead of unknown error for shmem THP.  It seems not like a big deal.

The following patch depends on this, which fixes shmem THP with hwpoisoned
subpage(s) are mapped PMD wrongly.  So this patch needs to be backported
to -stable as well.

Link: https://lkml.kernel.org/r/20211014191615.6674-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20211014191615.6674-2-shy828301@gmail.com
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-the-unnecessary-thp-check
+++ a/mm/memory-failure.c
@@ -1148,20 +1148,6 @@ static int __get_hwpoison_page(struct pa
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
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

