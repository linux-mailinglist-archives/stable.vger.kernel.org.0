Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D7F3C2AE4
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 23:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhGIVgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 17:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230519AbhGIVgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB5B4613D0;
        Fri,  9 Jul 2021 21:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866447;
        bh=tL1OChLliHIQqGGy0p89douybyL2u95XMCS0uZUyqI8=;
        h=Date:From:To:Subject:From;
        b=QTRSAoo8Npi8LykGLg1EmQSunA7OO002NNL387nqXBRx9dJDVd95HASunvDOjvuzi
         qLAh78JguDhcLecO44rpkIASXeQHv20za+HetaevWt2q5AlSrRxl/mjxkQiHEn716Z
         Doz5QCPLnH5IKWguU5TJw75i33Zg7bR5IbG8YTPQ=
Date:   Fri, 09 Jul 2021 14:34:06 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page?=
 =?US-ASCII?Q?-table-entries.patch?= removed from -mm tree
Message-ID: <20210709213406.9ZeEsG8ty%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mremap: hold the rmap lock in write mode when moving page table entries.
has been removed from the -mm tree.  Its filename was
     mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: hold the rmap lock in write mode when moving page table entries.

To avoid a race between rmap walk and mremap, mremap does
take_rmap_locks().  The lock was taken to ensure that rmap walk don't miss
a page table entry due to PTE moves via move_pagetables().  The kernel
does further optimization of this lock such that if we are going to find
the newly added vma after the old vma, the rmap lock is not taken.  This
is because rmap walk would find the vmas in the same order and if we don't
find the page table attached to older vma we would find it with the new
vma which we would iterate later.

As explained in commit eb66ae030829 ("mremap: properly flush TLB before
releasing the page") mremap is special in that it doesn't take ownership
of the page.  The optimized version for PUD/PMD aligned mremap also
doesn't hold the ptl lock.  This can result in stale TLB entries as show
below.

This patch updates the rmap locking requirement in mremap to handle the race condition
explained below with optimized mremap::

Optmized PMD move

    CPU 1                           CPU 2                                   CPU 3

    mremap(old_addr, new_addr)      page_shrinker/try_to_unmap_one

    mmap_write_lock_killable()

                                    addr = old_addr
                                    lock(pte_ptl)
    lock(pmd_ptl)
    pmd = *old_pmd
    pmd_clear(old_pmd)
    flush_tlb_range(old_addr)

    *new_pmd = pmd
                                                                            *new_addr = 10; and fills
                                                                            TLB with new addr
                                                                            and old pfn

    unlock(pmd_ptl)
                                    ptep_clear_flush()
                                    old pfn is free.
                                                                            Stale TLB entry

Optimized PUD move also suffers from a similar race.  Both the above race
condition can be fixed if we force mremap path to take rmap lock.

Link: https://lkml.kernel.org/r/20210616045239.370802-7-aneesh.kumar@linux.ibm.com
Fixes: 2c91bd4a4e2e ("mm: speed up mremap by 20x on large regions")
Fixes: c49dd3401802 ("mm: speedup mremap on 1GB or larger regions")
Link: https://lore.kernel.org/linux-mm/CAHk-=wgXVR04eBNtxQfevontWnP6FDm+oj5vauQXP3S-huwbPw@mail.gmail.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries
+++ a/mm/mremap.c
@@ -504,7 +504,7 @@ unsigned long move_page_tables(struct vm
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
 
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
-					   old_pud, new_pud, need_rmap_locks))
+					   old_pud, new_pud, true))
 				continue;
 		}
 
@@ -531,7 +531,7 @@ unsigned long move_page_tables(struct vm
 			 * moving at the PMD level if possible.
 			 */
 			if (move_pgt_entry(NORMAL_PMD, vma, old_addr, new_addr,
-					   old_pmd, new_pmd, need_rmap_locks))
+					   old_pmd, new_pmd, true))
 				continue;
 		}
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


