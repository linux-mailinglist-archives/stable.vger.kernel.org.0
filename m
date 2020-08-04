Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3D623B1F6
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 02:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgHDA4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 20:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgHDA4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 20:56:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B4D42073E;
        Tue,  4 Aug 2020 00:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596502611;
        bh=Xpz2/8MbuIU1sDtTSLDJAmGGd33Iw35lQFOZK4XJOpE=;
        h=Date:From:To:Subject:From;
        b=RtLfwi2sBIA13lh/B8S213mJBiUUrPO/VZROjB5j+pNOXwi1FgVuYrug+4AVdTcrE
         7cALSsAAQmt6Nq5Nu9twuDAJBMQwUcLoKevAQS36x3OozeMvWqXmq+KgPzZfXxYA+T
         SZYJ6CrviJoLlqvPkjmGCEvarN4J3dKCRR3Ts03Q=
Date:   Mon, 03 Aug 2020 17:56:50 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        stable@vger.kernel.org
Subject:  +
 khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch added to -mm
 tree
Message-ID: <20200804005650.84ZKn9_Ru%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: khugepaged: khugepaged_test_exit() check mmget_still_valid()
has been added to the -mm tree.  Its filename is
     khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch

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
Subject: khugepaged: khugepaged_test_exit() check mmget_still_valid()

Move collapse_huge_page()'s mmget_still_valid() check into
khugepaged_test_exit() itself.  collapse_huge_page() is used for anon THP
only, and earned its mmget_still_valid() check because it inserts a huge
pmd entry in place of the page table's pmd entry; whereas
collapse_file()'s retract_page_tables() or collapse_pte_mapped_thp()
merely clears the page table's pmd entry.  But core dumping without mmap
lock must have been as open to mistaking a racily cleared pmd entry for a
page table at physical page 0, as exit_mmap() was.  And we certainly have
no interest in mapping as a THP once dumping core.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021217020.27773@eggly.anvils
Fixes: 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page() and core dumping")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/khugepaged.c~khugepaged-khugepaged_test_exit-check-mmget_still_valid
+++ a/mm/khugepaged.c
@@ -431,7 +431,7 @@ static void insert_to_mm_slots_hash(stru
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
-	return atomic_read(&mm->mm_users) == 0;
+	return atomic_read(&mm->mm_users) == 0 || !mmget_still_valid(mm);
 }
 
 static bool hugepage_vma_check(struct vm_area_struct *vma,
@@ -1100,9 +1100,6 @@ static void collapse_huge_page(struct mm
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	mmap_write_lock(mm);
-	result = SCAN_ANY_PROCESS;
-	if (!mmget_still_valid(mm))
-		goto out;
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch
khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch
khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch
khugepaged-retract_page_tables-remember-to-test-exit.patch
khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch

