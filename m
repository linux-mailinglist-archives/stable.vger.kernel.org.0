Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E925AA31F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 00:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiIAWdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 18:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiIAWdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 18:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E03C64;
        Thu,  1 Sep 2022 15:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 139D362017;
        Thu,  1 Sep 2022 22:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692D4C433D6;
        Thu,  1 Sep 2022 22:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662071631;
        bh=QA8Ot9fW28Lj0opQ0rfELQi8e3MbeWQma8DHBibugqY=;
        h=Date:To:From:Subject:From;
        b=KxNnMTr6Nx133nR9juak8AwdPYTjgSCykTi/LLn3Mui+d4jbZWLkdmhTQ7ErZuWNe
         hnwzwwkTuRCdY0ZxROM0PQFwCH2mmaq9KvTVdj+ErwNCbMZ74EWcsfTVpYC2lJxf6A
         PgqTLRoasBZ7+M7UExUfIEBVKJYhQ6Q/IcOrzulU=
Date:   Thu, 01 Sep 2022 15:33:50 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        stable@vger.kernel.org, shy828301@gmail.com, peterz@infradead.org,
        peterx@redhat.com, paulmck@kernel.org, parri.andrea@gmail.com,
        namit@vmware.com, mike.kravetz@oracle.com, mhocko@kernel.org,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        ddutile@redhat.com, crecklin@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast.patch added to mm-hotfixes-unstable branch
Message-Id: <20220901223351.692D4C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix PageAnonExclusive clearing racing with concurrent RCU GUP-fast
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: fix PageAnonExclusive clearing racing with concurrent RCU GUP-fast
Date: Thu, 1 Sep 2022 10:35:59 +0200

commit 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with
PG_anon_exclusive") made sure that when PageAnonExclusive() has to be
cleared during temporary unmapping of a page, that the PTE is
cleared/invalidated and that the TLB is flushed.

What we want to achieve in all cases is that we cannot end up with a pin on
an anonymous page that may be shared, because such pins would be
unreliable and could result in memory corruptions when the mapped page
and the pin go out of sync due to a write fault.

That TLB flush handling was inspired by an outdated comment in
mm/ksm.c:write_protect_page(), which similarly required the TLB flush in
the past to synchronize with GUP-fast. However, ever since general RCU GUP
fast was introduced in commit 2667f50e8b81 ("mm: introduce a general RCU
get_user_pages_fast()"), a TLB flush is no longer sufficient to handle
concurrent GUP-fast in all cases -- it only handles traditional IPI-based
GUP-fast correctly.

Peter Xu (thankfully) questioned whether that TLB flush is really
required. On architectures that send an IPI broadcast on TLB flush,
it works as expected. To synchronize with RCU GUP-fast properly, we're
conceptually fine, however, we have to enforce a certain memory order and
are missing memory barriers.

Let's document that, avoid the TLB flush where possible and use proper
explicit memory barriers where required. We shouldn't really care about the
additional memory barriers here, as we're not on extremely hot paths --
and we're getting rid of some TLB flushes.

We use a smp_mb() pair for handling concurrent pinning and a
smp_rmb()/smp_wmb() pair for handling the corner case of only temporary
PTE changes but permanent PageAnonExclusive changes.

One extreme example, whereby GUP-fast takes a R/O pin and KSM wants to
convert an exclusive anonymous page to a KSM page, and that page is already
mapped write-protected (-> no PTE change) would be:

	Thread 0 (KSM)			Thread 1 (GUP-fast)

					(B1) Read the PTE
					# (B2) skipped without FOLL_WRITE
	(A1) Clear PTE
	smp_mb()
	(A2) Check pinned
					(B3) Pin the mapped page
					smp_mb()
	(A3) Clear PageAnonExclusive
	smp_wmb()
	(A4) Restore PTE
					(B4) Check if the PTE changed
					smp_rmb()
					(B5) Check PageAnonExclusive

Thread 1 will properly detect that PageAnonExclusive was cleared and
back off.

Note that we don't need a memory barrier between checking if the page is
pinned and clearing PageAnonExclusive, because stores are not
speculated.

The possible issues due to reordering are of theoretical nature so far
and attempts to reproduce the race failed.

Especially the "no PTE change" case isn't the common case, because we'd
need an exclusive anonymous page that's mapped R/O and the PTE is clean
in KSM code -- and using KSM with page pinning isn't extremely common.
Further, the clear+TLB flush we used for now implies a memory barrier.
So the problematic missing part should be the missing memory barrier
after pinning but before checking if the PTE changed.

Link: https://lkml.kernel.org/r/20220901083559.67446-1-david@redhat.com
Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Christoph von Recklinghausen <crecklin@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    9 ++++-
 include/linux/rmap.h |   66 +++++++++++++++++++++++++++++++++++++----
 mm/gup.c             |    7 ++++
 mm/huge_memory.c     |    3 +
 mm/ksm.c             |    1 
 mm/migrate_device.c  |   23 ++++++--------
 mm/rmap.c            |   11 +++---
 7 files changed, 95 insertions(+), 25 deletions(-)

--- a/include/linux/mm.h~mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast
+++ a/include/linux/mm.h
@@ -2975,8 +2975,8 @@ static inline int vm_fault_to_errno(vm_f
  * PageAnonExclusive() has to protect against concurrent GUP:
  * * Ordinary GUP: Using the PT lock
  * * GUP-fast and fork(): mm->write_protect_seq
- * * GUP-fast and KSM or temporary unmapping (swap, migration):
- *   clear/invalidate+flush of the page table entry
+ * * GUP-fast and KSM or temporary unmapping (swap, migration): see
+ *    page_try_share_anon_rmap()
  *
  * Must be called with the (sub)page that's actually referenced via the
  * page table entry, which might not necessarily be the head page for a
@@ -2997,6 +2997,11 @@ static inline bool gup_must_unshare(unsi
 	 */
 	if (!PageAnon(page))
 		return false;
+
+	/* Paired with a memory barrier in page_try_share_anon_rmap(). */
+	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+		smp_rmb();
+
 	/*
 	 * Note that PageKsm() pages cannot be exclusive, and consequently,
 	 * cannot get pinned.
--- a/include/linux/rmap.h~mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast
+++ a/include/linux/rmap.h
@@ -267,7 +267,7 @@ dup:
  * @page: the exclusive anonymous page to try marking possibly shared
  *
  * The caller needs to hold the PT lock and has to have the page table entry
- * cleared/invalidated+flushed, to properly sync against GUP-fast.
+ * cleared/invalidated.
  *
  * This is similar to page_try_dup_anon_rmap(), however, not used during fork()
  * to duplicate a mapping, but instead to prepare for KSM or temporarily
@@ -283,12 +283,68 @@ static inline int page_try_share_anon_rm
 {
 	VM_BUG_ON_PAGE(!PageAnon(page) || !PageAnonExclusive(page), page);
 
-	/* See page_try_dup_anon_rmap(). */
-	if (likely(!is_device_private_page(page) &&
-	    unlikely(page_maybe_dma_pinned(page))))
-		return -EBUSY;
+	/* device private pages cannot get pinned via GUP. */
+	if (unlikely(is_device_private_page(page))) {
+		ClearPageAnonExclusive(page);
+		return 0;
+	}
+
+	/*
+	 * We have to make sure that when we clear PageAnonExclusive, that
+	 * the page is not pinned and that concurrent GUP-fast won't succeed in
+	 * concurrently pinning the page.
+	 *
+	 * Conceptually, PageAnonExclusive clearing consists of:
+	 * (A1) Clear PTE
+	 * (A2) Check if the page is pinned; back off if so.
+	 * (A3) Clear PageAnonExclusive
+	 * (A4) Restore PTE (optional, but certainly not writable)
+	 *
+	 * When clearing PageAnonExclusive, we cannot possibly map the page
+	 * writable again, because anon pages that may be shared must never
+	 * be writable. So in any case, if the PTE was writable it cannot
+	 * be writable anymore afterwards and there would be a PTE change. Only
+	 * if the PTE wasn't writable, there might not be a PTE change.
+	 *
+	 * Conceptually, GUP-fast pinning of an anon page consists of:
+	 * (B1) Read the PTE
+	 * (B2) FOLL_WRITE: check if the PTE is not writable; back off if so.
+	 * (B3) Pin the mapped page
+	 * (B4) Check if the PTE changed by re-reading it; back off if so.
+	 * (B5) If the original PTE is not writable, check if
+	 *	PageAnonExclusive is not set; back off if so.
+	 *
+	 * If the PTE was writable, we only have to make sure that GUP-fast
+	 * observes a PTE change and properly backs off.
+	 *
+	 * If the PTE was not writable, we have to make sure that GUP-fast either
+	 * detects a (temporary) PTE change or that PageAnonExclusive is cleared
+	 * and properly backs off.
+	 *
+	 * Consequently, when clearing PageAnonExclusive(), we have to make
+	 * sure that (A1), (A2)/(A3) and (A4) happen in the right memory
+	 * order. In GUP-fast pinning code, we have to make sure that (B3),(B4)
+	 * and (B5) happen in the right memory order.
+	 *
+	 * We assume that there might not be a memory barrier after
+	 * clearing/invalidating the PTE (A1) and before restoring the PTE (A4),
+	 * so we use explicit ones here.
+	 */
+
+	/* Paired with the memory barrier in try_grab_folio(). */
+	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+		smp_mb();
 
+	if (unlikely(page_maybe_dma_pinned(page)))
+		return -EBUSY;
 	ClearPageAnonExclusive(page);
+
+	/*
+	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
+	 * gup_must_unshare().
+	 */
+	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+		smp_mb__after_atomic();
 	return 0;
 }
 
--- a/mm/gup.c~mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast
+++ a/mm/gup.c
@@ -158,6 +158,13 @@ struct folio *try_grab_folio(struct page
 		else
 			folio_ref_add(folio,
 					refs * (GUP_PIN_COUNTING_BIAS - 1));
+		/*
+		 * Adjust the pincount before re-checking the PTE for changes.
+		 * This is essentially a smp_mb() and is paired with a memory
+		 * barrier in page_try_share_anon_rmap().
+		 */
+		smp_mb__after_atomic();
+
 		node_stat_mod_folio(folio, NR_FOLL_PIN_ACQUIRED, refs);
 
 		return folio;
--- a/mm/huge_memory.c~mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast
+++ a/mm/huge_memory.c
@@ -2140,6 +2140,8 @@ static void __split_huge_pmd_locked(stru
 		 *
 		 * In case we cannot clear PageAnonExclusive(), split the PMD
 		 * only and let try_to_migrate_one() fail later.
+		 *
+		 * See page_try_share_anon_rmap(): invalidate PMD first.
 		 */
 		anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
@@ -3177,6 +3179,7 @@ int set_pmd_migration_entry(struct page_
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
 	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
+	/* See page_try_share_anon_rmap(): invalidate PMD first. */
 	anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 	if (anon_exclusive && page_try_share_anon_rmap(page)) {
 		set_pmd_at(mm, address, pvmw->pmd, pmdval);
--- a/mm/ksm.c~mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast
+++ a/mm/ksm.c
@@ -1095,6 +1095,7 @@ static int write_protect_page(struct vm_
 			goto out_unlock;
 		}
 
+		/* See page_try_share_anon_rmap(): clear PTE first. */
 		if (anon_exclusive && page_try_share_anon_rmap(page)) {
 			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
--- a/mm/migrate_device.c~mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast
+++ a/mm/migrate_device.c
@@ -193,20 +193,17 @@ again:
 			bool anon_exclusive;
 			pte_t swp_pte;
 
-			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
-			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
-				ptep_clear_flush(vma, addr, ptep);
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
+			ptep_get_and_clear(mm, addr, ptep);
 
-				if (page_try_share_anon_rmap(page)) {
-					set_pte_at(mm, addr, ptep, pte);
-					unlock_page(page);
-					put_page(page);
-					mpfn = 0;
-					goto next;
-				}
-			} else {
-				ptep_get_and_clear(mm, addr, ptep);
+			/* See page_try_share_anon_rmap(): clear PTE first. */
+			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+			if (anon_exclusive && page_try_share_anon_rmap(page)) {
+				set_pte_at(mm, addr, ptep, pte);
+				unlock_page(page);
+				put_page(page);
+				mpfn = 0;
+				goto next;
 			}
 
 			migrate->cpages++;
--- a/mm/rmap.c~mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast
+++ a/mm/rmap.c
@@ -1579,11 +1579,8 @@ static bool try_to_unmap_one(struct foli
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
 		} else {
 			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
-			/*
-			 * Nuke the page table entry. When having to clear
-			 * PageAnonExclusive(), we always have to flush.
-			 */
-			if (should_defer_flush(mm, flags) && !anon_exclusive) {
+			/* Nuke the page table entry. */
+			if (should_defer_flush(mm, flags)) {
 				/*
 				 * We clear the PTE but do not flush so potentially
 				 * a remote CPU could still be writing to the folio.
@@ -1714,6 +1711,8 @@ static bool try_to_unmap_one(struct foli
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
+
+			/* See page_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    page_try_share_anon_rmap(subpage)) {
 				swap_free(entry);
@@ -2045,6 +2044,8 @@ static bool try_to_migrate_one(struct fo
 			}
 			VM_BUG_ON_PAGE(pte_write(pteval) && folio_test_anon(folio) &&
 				       !anon_exclusive, subpage);
+
+			/* See page_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    page_try_share_anon_rmap(subpage)) {
 				if (folio_test_hugetlb(folio))
_

Patches currently in -mm which might be from david@redhat.com are

mm-fix-pageanonexclusive-clearing-racing-with-concurrent-rcu-gup-fast.patch
mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch
mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch
mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch

