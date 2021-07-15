Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250583CA927
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242734AbhGOTFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243391AbhGOTEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 116F2610C7;
        Thu, 15 Jul 2021 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375607;
        bh=SMo/T7Ka7E8f0cAteUTp8D85XzExdOnkdsf86LhuHO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgMf4Pffa6C2BXVbuq0g3uh/c8PuRsetn1I9etGbk6jZ4hly5mt7L46Qmd8B/ZgC/
         ZIsgOulPDE6NC0EW93pG5ZGUvUof9IcEkjJ16d6TdRrVPFLc2TjFbyM6eCcGzi4+MO
         3yRoRdPZG+edUpLx+xkPCAwpOEwn2jfov9BZNz0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Joel Fernandes <joel@joelfernandes.org>,
        Kalesh Singh <kaleshsingh@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 157/242] mm/mremap: hold the rmap lock in write mode when moving page table entries.
Date:   Thu, 15 Jul 2021 20:38:39 +0200
Message-Id: <20210715182620.807276868@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 97113eb39fa7972722ff490b947d8af023e1f6a2 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -439,7 +439,7 @@ unsigned long move_page_tables(struct vm
 			if (!new_pud)
 				break;
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
-					   old_pud, new_pud, need_rmap_locks))
+					   old_pud, new_pud, true))
 				continue;
 		}
 
@@ -466,7 +466,7 @@ unsigned long move_page_tables(struct vm
 			 * moving at the PMD level if possible.
 			 */
 			if (move_pgt_entry(NORMAL_PMD, vma, old_addr, new_addr,
-					   old_pmd, new_pmd, need_rmap_locks))
+					   old_pmd, new_pmd, true))
 				continue;
 		}
 


