Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2B33C4CB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhCORtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236568AbhCORsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D533764F5B;
        Mon, 15 Mar 2021 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830520;
        bh=eCQgNydi5ZQxBjMS2fyYTn2ZrA/o6A9I8QZjTWlYx9k=;
        h=Date:From:To:Subject:From;
        b=GwpThDINkiwKPOCY2UdKmmDGZHjcIvUPRILY6FrNdZO09M7yVrHNEZCLxNDdeZB/3
         rEhN+ivRto9I0IenO524unPzpz2E4+S1ElaYR0qhmQqgRWaHkB7mSHDggO7iRgvoIf
         cO7tgsu/59TlsvQy7u69rwpVu8nTkfgMOO8fpCJ0=
Date:   Mon, 15 Mar 2021 10:48:39 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, namit@vmware.com,
        peterx@redhat.com, peterz@infradead.org, rppt@linux.vnet.ibm.com,
        stable@vger.kernel.org, will@kernel.org, xemul@openvz.org,
        yuzhao@google.com
Subject:  [merged]
 mm-userfaultfd-fix-memory-corruption-due-to-writeprotect.patch removed from
 -mm tree
Message-ID: <20210315174839.VoNmtO0F9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: fix memory corruption due to writeprotect
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-memory-corruption-due-to-writeprotect.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Nadav Amit <namit@vmware.com>
Subject: mm/userfaultfd: fix memory corruption due to writeprotect

Userfaultfd self-test fails occasionally, indicating a memory corruption.

Analyzing this problem indicates that there is a real bug since mmap_lock
is only taken for read in mwriteprotect_range() and defers flushes, and
since there is insufficient consideration of concurrent deferred TLB
flushes in wp_page_copy().  Although the PTE is flushed from the TLBs in
wp_page_copy(), this flush takes place after the copy has already been
performed, and therefore changes of the page are possible between the time
of the copy and the time in which the PTE is flushed.

To make matters worse, memory-unprotection using userfaultfd also poses a
problem.  Although memory unprotection is logically a promotion of PTE
permissions, and therefore should not require a TLB flush, the current
userrfaultfd code might actually cause a demotion of the architectural PTE
permission: when userfaultfd_writeprotect() unprotects memory region, it
unintentionally *clears* the RW-bit if it was already set.  Note that this
unprotecting a PTE that is not write-protected is a valid use-case: the
userfaultfd monitor might ask to unprotect a region that holds both
write-protected and write-unprotected PTEs.

The scenario that happens in selftests/vm/userfaultfd is as follows:

cpu0				cpu1			cpu2
----				----			----
							[ Writable PTE
							  cached in TLB ]
userfaultfd_writeprotect()
[ write-*unprotect* ]
mwriteprotect_range()
mmap_read_lock()
change_protection()

change_protection_range()
...
change_pte_range()
[ *clear* =E2=80=9Cwrite=E2=80=9D-bit ]
[ defer TLB flushes ]
				[ page-fault ]
				...
				wp_page_copy()
				 cow_user_page()
				  [ copy page ]
							[ write to old
							  page ]
				...
				 set_pte_at_notify()

A similar scenario can happen:

cpu0		cpu1		cpu2		cpu3
----		----		----		----
						[ Writable PTE
				  		  cached in TLB ]
userfaultfd_writeprotect()
[ write-protect ]
[ deferred TLB flush ]
		userfaultfd_writeprotect()
		[ write-unprotect ]
		[ deferred TLB flush]
				[ page-fault ]
				wp_page_copy()
				 cow_user_page()
				 [ copy page ]
				 ...		[ write to page ]
				set_pte_at_notify()

This race exists since commit 292924b26024 ("userfaultfd: wp: apply
_PAGE_UFFD_WP bit").  Yet, as Yu Zhao pointed, these races became apparent
since commit 09854ba94c6a ("mm: do_wp_page() simplification") which made
wp_page_copy() more likely to take place, specifically if page_count(page)
> 1.

To resolve the aforementioned races, check whether there are pending
flushes on uffd-write-protected VMAs, and if there are, perform a flush
before doing the COW.

Further optimizations will follow to avoid during uffd-write-unprotect
unnecassary PTE write-protection and TLB flushes.

Link: https://lkml.kernel.org/r/20210304095423.3825684-1-namit@vmware.com
Fixes: 09854ba94c6a ("mm: do_wp_page() simplification")
Signed-off-by: Nadav Amit <namit@vmware.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory.c~mm-userfaultfd-fix-memory-corruption-due-to-writeprotect
+++ a/mm/memory.c
@@ -3097,6 +3097,14 @@ static vm_fault_t do_wp_page(struct vm_f
 		return handle_userfault(vmf, VM_UFFD_WP);
 	}
=20
+	/*
+	 * Userfaultfd write-protect can defer flushes. Ensure the TLB
+	 * is flushed in this case before copying.
+	 */
+	if (unlikely(userfaultfd_wp(vmf->vma) &&
+		     mm_tlb_flush_pending(vmf->vma->vm_mm)))
+		flush_tlb_page(vmf->vma, vmf->address);
+
 	vmf->page =3D vm_normal_page(vma, vmf->address, vmf->orig_pte);
 	if (!vmf->page) {
 		/*
_

Patches currently in -mm which might be from namit@vmware.com are


