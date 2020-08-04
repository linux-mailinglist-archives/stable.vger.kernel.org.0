Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D732123B1F2
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 02:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgHDA4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 20:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgHDA4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 20:56:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 160CA2073E;
        Tue,  4 Aug 2020 00:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596502603;
        bh=tXkyPmpo7UI6pexHwYfY6vXz8chg0rnv8My25Ca0dOM=;
        h=Date:From:To:Subject:From;
        b=oYotjQYZLg1HtPwi22Thfp5uaYUWnBhWWPBpuCLq/+Kx4ITDwynj/Ei3jzsoqXQeh
         MJNJNm9lLc4Z46MrsuUqfN2FWE7OQ5VLxbONmsu79Phh4X2ZRzJN6xOxKZ6/atWppG
         /14yyBohIJ/6c87+9gEA2RHE3RwlIvhlGIthZNw4=
Date:   Mon, 03 Aug 2020 17:56:42 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        stable@vger.kernel.org
Subject:  +
 khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch added to -mm
 tree
Message-ID: <20200804005642.eY-Fjgl2j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: khugepaged: collapse_pte_mapped_thp() flush the right range
has been added to the -mm tree.  Its filename is
     khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch

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
Subject: khugepaged: collapse_pte_mapped_thp() flush the right range

pmdp_collapse_flush() should be given the start address at which the huge
page is mapped, haddr: it was given addr, which at that point has been
used as a local variable, incremented to the end address of the extent.

Found by source inspection while chasing a hugepage locking bug, which I
then could not explain by this.  At first I thought this was very bad;
then saw that all of the page translations that were not flushed would
actually still point to the right pages afterwards, so harmless; then
realized that I know nothing of how different architectures and models
cache intermediate paging structures, so maybe it matters after all -
particularly since the page table concerned is immediately freed.

Much easier to fix than to think about.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021204390.27773@eggly.anvils
Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-collapse_pte_mapped_thp-flush-the-right-range
+++ a/mm/khugepaged.c
@@ -1502,7 +1502,7 @@ void collapse_pte_mapped_thp(struct mm_s
 
 	/* step 4: collapse pmd */
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	_pmd = pmdp_collapse_flush(vma, addr, pmd);
+	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
 	pte_free(mm, pmd_pgtable(_pmd));
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch
khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch
khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch
khugepaged-retract_page_tables-remember-to-test-exit.patch
khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch

