Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAF42ACC8
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhJLTAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 15:00:12 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:44814
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232648AbhJLTAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 15:00:11 -0400
Received: from mussarela (unknown [177.9.89.30])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E056A3F044;
        Tue, 12 Oct 2021 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634065087;
        bh=cmYtI7bXUnsLPfs56Qxs+Az6PvpR/YxQ/1rY8vXKZAE=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=gWSbGeItsj9E4+cCI4VlOlKiOYilSwwt8bcUtsNJfJuayQIQVyeVJv4RFfRbVuyxI
         dq0uE/BCQsptSFTghdFdYQ+8ItJdok3EcfeLDDnIow2jNp0p5mCkCC0Ru2tSEyMa3Q
         6SGYjlL46acap3uQFnkW2jONLVq/xhPgd24q59XCE/u6Wsl23+OS2Dmu5YQkbizwJH
         Fi5dbaE/Yt/pIuvSsNfhywkEZLxpE/6f/2ffHh8y7IyLMSPOb3QVQFzYzthwU4tqKz
         mAROZZNJdDx9+OEgmhWqqZWaIBhQ73U0D4sUIk4Ua0+3nlsi2s5njZ1husfBtqB9JD
         hvx3kQ5rlD23g==
Date:   Tue, 12 Oct 2021 15:57:51 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org,
        jannh@google.com, torvalds@linux-foundation.org, peterx@redhat.com,
        aarcange@redhat.com, david@redhat.com, jgg@ziepe.ca,
        ktkhai@virtuozzo.com, shli@fb.com, namit@vmware.com, hch@lst.de,
        oleg@redhat.com, kirill@shutemov.name, willy@infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
Message-ID: <YWXar5/JJD4NYcHa@mussarela>
References: <20211012015244.693594-1-surenb@google.com>
 <20211012080649.GE9697@quack2.suse.cz>
 <b9568b73-70ef-cd0f-f533-41556cae6a0f@suse.cz>
 <YWVKgIUY6hWagEPo@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SgIC40tiGMOi4sUs"
Content-Disposition: inline
In-Reply-To: <YWVKgIUY6hWagEPo@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SgIC40tiGMOi4sUs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 12, 2021 at 10:42:40AM +0200, Greg KH wrote:
> On Tue, Oct 12, 2021 at 10:14:27AM +0200, Vlastimil Babka wrote:
> > On 10/12/21 10:06, Jan Kara wrote:
> > > On Mon 11-10-21 18:52:44, Suren Baghdasaryan wrote:
> > >> From: Linus Torvalds <torvalds@linux-foundation.org>
> > >> 
> > >> From: Linus Torvalds <torvalds@linux-foundation.org>
> > >> 
> > >> commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.
> > >> 
> > >> Doing a "get_user_pages()" on a copy-on-write page for reading can be
> > >> ambiguous: the page can be COW'ed at any time afterwards, and the
> > >> direction of a COW event isn't defined.
> > >> 
> > >> Yes, whoever writes to it will generally do the COW, but if the thread
> > >> that did the get_user_pages() unmapped the page before the write (and
> > >> that could happen due to memory pressure in addition to any outright
> > >> action), the writer could also just take over the old page instead.
> > >> 
> > >> End result: the get_user_pages() call might result in a page pointer
> > >> that is no longer associated with the original VM, and is associated
> > >> with - and controlled by - another VM having taken it over instead.
> > >> 
> > >> So when doing a get_user_pages() on a COW mapping, the only really safe
> > >> thing to do would be to break the COW when getting the page, even when
> > >> only getting it for reading.
> > >> 
> > >> At the same time, some users simply don't even care.
> > >> 
> > >> For example, the perf code wants to look up the page not because it
> > >> cares about the page, but because the code simply wants to look up the
> > >> physical address of the access for informational purposes, and doesn't
> > >> really care about races when a page might be unmapped and remapped
> > >> elsewhere.
> > >> 
> > >> This adds logic to force a COW event by setting FOLL_WRITE on any
> > >> copy-on-write mapping when FOLL_GET (or FOLL_PIN) is used to get a page
> > >> pointer as a result.
> > >> 
> > >> The current semantics end up being:
> > >> 
> > >>  - __get_user_pages_fast(): no change. If you don't ask for a write,
> > >>    you won't break COW. You'd better know what you're doing.
> > >> 
> > >>  - get_user_pages_fast(): the fast-case "look it up in the page tables
> > >>    without anything getting mmap_sem" now refuses to follow a read-only
> > >>    page, since it might need COW breaking.  Which happens in the slow
> > >>    path - the fast path doesn't know if the memory might be COW or not.
> > >> 
> > >>  - get_user_pages() (including the slow-path fallback for gup_fast()):
> > >>    for a COW mapping, turn on FOLL_WRITE for FOLL_GET/FOLL_PIN, with
> > >>    very similar semantics to FOLL_FORCE.
> > >> 
> > >> If it turns out that we want finer granularity (ie "only break COW when
> > >> it might actually matter" - things like the zero page are special and
> > >> don't need to be broken) we might need to push these semantics deeper
> > >> into the lookup fault path.  So if people care enough, it's possible
> > >> that we might end up adding a new internal FOLL_BREAK_COW flag to go
> > >> with the internal FOLL_COW flag we already have for tracking "I had a
> > >> COW".
> > >> 
> > >> Alternatively, if it turns out that different callers might want to
> > >> explicitly control the forced COW break behavior, we might even want to
> > >> make such a flag visible to the users of get_user_pages() instead of
> > >> using the above default semantics.
> > >> 
> > >> But for now, this is mostly commentary on the issue (this commit message
> > >> being a lot bigger than the patch, and that patch in turn is almost all
> > >> comments), with that minimal "enable COW breaking early" logic using the
> > >> existing FOLL_WRITE behavior.
> > >> 
> > >> [ It might be worth noting that we've always had this ambiguity, and it
> > >>   could arguably be seen as a user-space issue.
> > >> 
> > >>   You only get private COW mappings that could break either way in
> > >>   situations where user space is doing cooperative things (ie fork()
> > >>   before an execve() etc), but it _is_ surprising and very subtle, and
> > >>   fork() is supposed to give you independent address spaces.
> > >> 
> > >>   So let's treat this as a kernel issue and make the semantics of
> > >>   get_user_pages() easier to understand. Note that obviously a true
> > >>   shared mapping will still get a page that can change under us, so this
> > >>   does _not_ mean that get_user_pages() somehow returns any "stable"
> > >>   page ]
> > >> 
> > >> [surenb: backport notes
> > >>         Since gup_pgd_range does not exist, made appropriate changes on
> > >>         the the gup_huge_pgd, gup_huge_pd and gup_pud_range calls instead.
> > >> 	Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_huge_pgd,
> > >>         gup_huge_pd and gup_pud_range.
> > >> 	Removed FOLL_PIN usage in should_force_cow_break since it's missing in
> > >> 	the earlier kernels.]
> > > 
> > > I'd be really careful with backporting this to stable. There was a lot of
> > > userspace breakage caused by this change if I remember right which needed
> > > to be fixed up later. There is a nice summary at
> > > https://lwn.net/Articles/849638/ and https://lwn.net/Articles/849876/ and
> > > some problems are still being found...
> > 
> > Yeah that was my initial reaction. But looks like back in April we agreed
> > that backporting only this commit could be feasible - the relevant subthread
> > starts around here [1]. The known breakage for just this commit was uffd
> > functionality introduced only in 5.7, and strace on dax on pmem (that was
> > never properly root caused). 5.4 stable already has the backport since year
> > ago, Suren posted 4.14 and 4.19 in April after [1]. Looks like nobody
> > reported issues? Continuing with 4.4 and 4.9 makes this consistent at least,
> > although the risk of breaking something is always there and the CVE probably
> > not worth it, but whatever...
> 
> I have had people "complain" that the issue was not fixed on these older
> kernels, now if that is just because those groups have a "it has a CVE
> so it must be fixed!" policy or not, it is hard to tell.
> 
> But this seems to be exploitable, and we have a reproducer somewhere
> around here, so it would be nice to get resolved for the reason of it
> being a bug that we should fix if possible.
> 
> So I would err on the side of "lets merge this" as fixing a known issue
> is ALWAYS better than the fear of "maybe something might break".  We can
> always revert if the latter happens in testing.
> 
> thanks,
> 
> greg k-h

When we backported this to the Ubuntu kernel based on 4.4, we found a
regression that required commit 38e088546522e1e86d2b8f401a1354ad3a9b3303
("mm: check VMA flags to avoid invalid PROT_NONE NUMA balancing") as a fix.

I tested that this was also the case with the 4.4.y stable-rc tree and I am
providing our backport below, which I also tested. The reproducer that
regresses reads from /proc/self/mem. Writing to /proc/self/mem seems to
have been a bug on 4.4 for a while and is also fixed by this backport, so
should be considered in any case.

Cascardo.

--SgIC40tiGMOi4sUs
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-check-VMA-flags-to-avoid-invalid-PROT_NONE-NUMA-b.patch"

From 757597f803f5770ebd7c70d4bf0068aa525c033a Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lstoakes@gmail.com>
Date: Mon, 5 Apr 2021 22:36:00 +0200
Subject: [PATCH 4.4] mm: check VMA flags to avoid invalid PROT_NONE NUMA
 balancing

commit 38e088546522e1e86d2b8f401a1354ad3a9b3303 upstream.

The NUMA balancing logic uses an arch-specific PROT_NONE page table flag
defined by pte_protnone() or pmd_protnone() to mark PTEs or huge page
PMDs respectively as requiring balancing upon a subsequent page fault.
User-defined PROT_NONE memory regions which also have this flag set will
not normally invoke the NUMA balancing code as do_page_fault() will send
a segfault to the process before handle_mm_fault() is even called.

However if access_remote_vm() is invoked to access a PROT_NONE region of
memory, handle_mm_fault() is called via faultin_page() and
__get_user_pages() without any access checks being performed, meaning
the NUMA balancing logic is incorrectly invoked on a non-NUMA memory
region.

A simple means of triggering this problem is to access PROT_NONE mmap'd
memory using /proc/self/mem which reliably results in the NUMA handling
functions being invoked when CONFIG_NUMA_BALANCING is set.

This issue was reported in bugzilla (issue 99101) which includes some
simple repro code.

There are BUG_ON() checks in do_numa_page() and do_huge_pmd_numa_page()
added at commit c0e7cad to avoid accidentally provoking strange
behaviour by attempting to apply NUMA balancing to pages that are in
fact PROT_NONE.  The BUG_ON()'s are consistently triggered by the repro.

This patch moves the PROT_NONE check into mm/memory.c rather than
invoking BUG_ON() as faulting in these pages via faultin_page() is a
valid reason for reaching the NUMA check with the PROT_NONE page table
flag set and is therefore not always a bug.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=99101
Reported-by: Trevor Saunders <tbsaunde@tbsaunde.org>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
[cascardo: context adjustments were necessary]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 mm/huge_memory.c |  3 ---
 mm/memory.c      | 12 +++++++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fae45c56e2ee..2f53786098c5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1340,9 +1340,6 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	bool was_writable;
 	int flags = 0;
 
-	/* A PROT_NONE fault should not end up here */
-	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
-
 	ptl = pmd_lock(mm, pmdp);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
diff --git a/mm/memory.c b/mm/memory.c
index 360d28224a8e..6bfc6a021c4f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3209,9 +3209,6 @@ static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	bool was_writable = pte_write(pte);
 	int flags = 0;
 
-	/* A PROT_NONE fault should not end up here */
-	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
-
 	/*
 	* The "pte" at this point cannot be used safely without
 	* validation through pte_unmap_same(). It's of NUMA type but
@@ -3304,6 +3301,11 @@ static int wp_huge_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
 	return VM_FAULT_FALLBACK;
 }
 
+static inline bool vma_is_accessible(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE);
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -3350,7 +3352,7 @@ static int handle_pte_fault(struct mm_struct *mm,
 					pte, pmd, flags, entry);
 	}
 
-	if (pte_protnone(entry))
+	if (pte_protnone(entry) && vma_is_accessible(vma))
 		return do_numa_page(mm, vma, address, entry, pte, pmd);
 
 	ptl = pte_lockptr(mm, pmd);
@@ -3425,7 +3427,7 @@ static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			if (pmd_trans_splitting(orig_pmd))
 				return 0;
 
-			if (pmd_protnone(orig_pmd))
+			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(mm, vma, address,
 							     orig_pmd, pmd);
 
-- 
2.30.2


--SgIC40tiGMOi4sUs--
