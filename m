Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AC630192A
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 03:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAXCFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 21:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbhAXCFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 21:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A6A229EF;
        Sun, 24 Jan 2021 02:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611453873;
        bh=UU5zkx0PUtomZepyoiLiKvYjumr+fS7jKTAIKNmMPqk=;
        h=Date:From:To:Subject:From;
        b=bV4wdy3RKbA/W8kV+zP2C2U15mn4wA0wSAmMsFMvxTQnYvJqtgM2sw8L8Rxbe/fy/
         dk0iVNoaGCN4b+DTXhjERu5F7JOUancNUsl/u4ESEvZZYjFYN8eTTjamERssiFK90f
         majTSinn0IEUnHhtCSRoZnC+o6pSapdfSy+RakZA=
Date:   Sat, 23 Jan 2021 18:04:32 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org,
        sergey.senozhatsky.work@gmail.com, stable@vger.kernel.org
Subject:  + mm-thp-fix-madv_remove-deadlock-on-shmem-thp.patch
 added to -mm tree
Message-ID: <20210124020432.9gYUePFNh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: thp: fix MADV_REMOVE deadlock on shmem THP
has been added to the -mm tree.  Its filename is
     mm-thp-fix-madv_remove-deadlock-on-shmem-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-madv_remove-deadlock-on-shmem-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-madv_remove-deadlock-on-shmem-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: thp: fix MADV_REMOVE deadlock on shmem THP

Sergey reported deadlock between kswapd correctly doing its usual
lock_page(page) followed by down_read(page->mapping->i_mmap_rwsem), and
madvise(MADV_REMOVE) on an madvise(MADV_HUGEPAGE) area doing
down_write(page->mapping->i_mmap_rwsem) followed by lock_page(page).

This happened when shmem_fallocate(punch hole)'s unmap_mapping_range()
reaches zap_pmd_range()'s call to __split_huge_pmd().  The same deadlock
could occur when partially truncating a mapped huge tmpfs file, or using
fallocate(FALLOC_FL_PUNCH_HOLE) on it.

__split_huge_pmd()'s page lock was added in 5.8, to make sure that any
concurrent use of reuse_swap_page() (holding page lock) could not catch
the anon THP's mapcounts and swapcounts while they were being split.

Fortunately, reuse_swap_page() is never applied to a shmem or file THP
(not even by khugepaged, which checks PageSwapCache before calling), and
anonymous THPs are never created in shmem or file areas: so that
__split_huge_pmd()'s page lock can only be necessary for anonymous THPs,
on which there is no risk of deadlock with i_mmap_rwsem.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2101161409470.2022@eggly.anvils
Fixes: c444eb564fb1 ("mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-madv_remove-deadlock-on-shmem-thp
+++ a/mm/huge_memory.c
@@ -2202,7 +2202,7 @@ void __split_huge_pmd(struct vm_area_str
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
-	bool was_locked = false;
+	bool do_unlock_page = false;
 	pmd_t _pmd;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
@@ -2218,7 +2218,6 @@ void __split_huge_pmd(struct vm_area_str
 	VM_BUG_ON(freeze && !page);
 	if (page) {
 		VM_WARN_ON_ONCE(!PageLocked(page));
-		was_locked = true;
 		if (page != pmd_page(*pmd))
 			goto out;
 	}
@@ -2227,19 +2226,29 @@ repeat:
 	if (pmd_trans_huge(*pmd)) {
 		if (!page) {
 			page = pmd_page(*pmd);
-			if (unlikely(!trylock_page(page))) {
-				get_page(page);
-				_pmd = *pmd;
-				spin_unlock(ptl);
-				lock_page(page);
-				spin_lock(ptl);
-				if (unlikely(!pmd_same(*pmd, _pmd))) {
-					unlock_page(page);
+			/*
+			 * An anonymous page must be locked, to ensure that a
+			 * concurrent reuse_swap_page() sees stable mapcount;
+			 * but reuse_swap_page() is not used on shmem or file,
+			 * and page lock must not be taken when zap_pmd_range()
+			 * calls __split_huge_pmd() while i_mmap_lock is held.
+			 */
+			if (PageAnon(page)) {
+				if (unlikely(!trylock_page(page))) {
+					get_page(page);
+					_pmd = *pmd;
+					spin_unlock(ptl);
+					lock_page(page);
+					spin_lock(ptl);
+					if (unlikely(!pmd_same(*pmd, _pmd))) {
+						unlock_page(page);
+						put_page(page);
+						page = NULL;
+						goto repeat;
+					}
 					put_page(page);
-					page = NULL;
-					goto repeat;
 				}
-				put_page(page);
+				do_unlock_page = true;
 			}
 		}
 		if (PageMlocked(page))
@@ -2249,7 +2258,7 @@ repeat:
 	__split_huge_pmd_locked(vma, pmd, range.start, freeze);
 out:
 	spin_unlock(ptl);
-	if (!was_locked && page)
+	if (do_unlock_page)
 		unlock_page(page);
 	/*
 	 * No need to double call mmu_notifier->invalidate_range() callback.
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-madv_remove-deadlock-on-shmem-thp.patch

