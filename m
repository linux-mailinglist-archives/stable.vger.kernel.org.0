Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C0C2400F4
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 04:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJCk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 22:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77FF206C3;
        Mon, 10 Aug 2020 02:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027227;
        bh=CmEyyYigoOmyKgn52QYwu6+WTrl1epM9xz+kCVbY3GQ=;
        h=Date:From:To:Subject:From;
        b=2JoyNZWkwTLRp7mWPAKWavtsBSkn0yLqogeEGcCA8ap10K4aewM1kK3sqF8nKlktf
         iRlfYAFAtC96P3T6nzkCLAlvp73wSh+1GEvt/ukuB/h+AY7SaKBbp0WsJDk8Oz2/k4
         lU6hNxokKrAnuV2v+/agKaWJ8FbryNfwvwpeNTF0=
Date:   Sun, 09 Aug 2020 19:40:26 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-hugetlb-fix-calculation-of-adjust_range_if_pmd_sharing_possible.patch
 removed from -mm tree
Message-ID: <20200810024026.NYpa6jXx0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-calculation-of-adjust_range_if_pmd_sharing_possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

This is found by code observation only.

Firstly, the worst case scenario should assume the whole range was covered
by pmd sharing.  The old algorithm might not work as expected for ranges
like (1g-2m, 1g+2m), where the adjusted range should be (0, 1g+2m) but the
expected range should be (0, 2g).

Since at it, remove the loop since it should not be required.  With that,
the new code should be faster too when the invalidating range is huge.

Mike said:

: With range (1g-2m, 1g+2m) within a vma (0, 2g) the existing code will only
: adjust to (0, 1g+2m) which is incorrect.
: 
: We should cc stable.  The original reason for adjusting the range was to
: prevent data corruption (getting wrong page).  Since the range is not
: always adjusted correctly, the potential for corruption still exists.
: 
: However, I am fairly confident that adjust_range_if_pmd_sharing_possible
: is only gong to be called in two cases:
: 
: 1) for a single page
: 2) for range == entire vma
: 
: In those cases, the current code should produce the correct results.
: 
: To be safe, let's just cc stable.

Link: http://lkml.kernel.org/r/20200730201636.74778-1-peterx@redhat.com
Fixes: 017b1660df89 ("mm: migration: fix migration of huge PMD shared pages")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-calculation-of-adjust_range_if_pmd_sharing_possible
+++ a/mm/hugetlb.c
@@ -5314,25 +5314,21 @@ static bool vma_shareable(struct vm_area
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long check_addr;
+	unsigned long a_start, a_end;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
 
-	for (check_addr = *start; check_addr < *end; check_addr += PUD_SIZE) {
-		unsigned long a_start = check_addr & PUD_MASK;
-		unsigned long a_end = a_start + PUD_SIZE;
+	/* Extend the range to be PUD aligned for a worst case scenario */
+	a_start = ALIGN_DOWN(*start, PUD_SIZE);
+	a_end = ALIGN(*end, PUD_SIZE);
 
-		/*
-		 * If sharing is possible, adjust start/end if necessary.
-		 */
-		if (range_in_vma(vma, a_start, a_end)) {
-			if (a_start < *start)
-				*start = a_start;
-			if (a_end > *end)
-				*end = a_end;
-		}
-	}
+	/*
+	 * Intersect the range with the vma range, since pmd sharing won't be
+	 * across vma after all
+	 */
+	*start = max(vma->vm_start, a_start);
+	*end = min(vma->vm_end, a_end);
 }
 
 /*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-do-page-fault-accounting-in-handle_mm_fault.patch
mm-alpha-use-general-page-fault-accounting.patch
mm-arc-use-general-page-fault-accounting.patch
mm-arm-use-general-page-fault-accounting.patch
mm-arm64-use-general-page-fault-accounting.patch
mm-csky-use-general-page-fault-accounting.patch
mm-hexagon-use-general-page-fault-accounting.patch
mm-ia64-use-general-page-fault-accounting.patch
mm-m68k-use-general-page-fault-accounting.patch
mm-microblaze-use-general-page-fault-accounting.patch
mm-mips-use-general-page-fault-accounting.patch
mm-nds32-use-general-page-fault-accounting.patch
mm-nios2-use-general-page-fault-accounting.patch
mm-openrisc-use-general-page-fault-accounting.patch
mm-parisc-use-general-page-fault-accounting.patch
mm-powerpc-use-general-page-fault-accounting.patch
mm-riscv-use-general-page-fault-accounting.patch
mm-s390-use-general-page-fault-accounting.patch
mm-sh-use-general-page-fault-accounting.patch
mm-sparc32-use-general-page-fault-accounting.patch
mm-sparc64-use-general-page-fault-accounting.patch
mm-x86-use-general-page-fault-accounting.patch
mm-xtensa-use-general-page-fault-accounting.patch
mm-clean-up-the-last-pieces-of-page-fault-accountings.patch
mm-gup-remove-task_struct-pointer-for-all-gup-code.patch

