Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4662400F5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 04:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHJCkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 22:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCka (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7A92065D;
        Mon, 10 Aug 2020 02:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027229;
        bh=+Fzf+snOmFn0ncNI1VLqE1ZKP1olEgWiXBO2ciGLdSw=;
        h=Date:From:To:Subject:From;
        b=nTchpt+LF0+X5kFyGtC7ny4NCEqXqj1EpEFd7f9swVeJVS9YKE0ybUgooHQ3cFzdz
         HEYDQLSujml6maK0WZq25UKQhOSgNOJKcrKcUnmujHR9Bc+9Z4o3N7w007H1SJ+0G6
         64RgnwhZUn/E/pNHGICJLfR66hVjGZ6BXfArAbHI=
Date:   Sun, 09 Aug 2020 19:40:29 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        stable@vger.kernel.org
Subject:  [merged]
 khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch removed from
 -mm tree
Message-ID: <20200810024029.oQCllf2gD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: khugepaged: collapse_pte_mapped_thp() flush the right range
has been removed from the -mm tree.  Its filename was
     khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


