Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457435A9228
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 10:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiIAIgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 04:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiIAIgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 04:36:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0895311D90D
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 01:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662021369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/mtezMuJaLKRvru6XrovNRtNHrsgsjKFpG6lGINA/6k=;
        b=T9iXQxqxyA++aSMjRscATxPs7iFU2N95PSWMToGvljMkSzYEAjL/+X5rhXryisSMDk1GCc
        GL4RnIzBOZry/SDK7LIl0guqyzKxb/RpeOH7DxV2Dpy9OCSKq85oVvxZKaWXv0ELUTl6af
        ET8XpOtpMDugGHKAlHisXx7mMyX54jg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-YS0GZzlRNGq-ofOdChtTwA-1; Thu, 01 Sep 2022 04:36:06 -0400
X-MC-Unique: YS0GZzlRNGq-ofOdChtTwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E95038032F1;
        Thu,  1 Sep 2022 08:36:05 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ED034C819;
        Thu,  1 Sep 2022 08:36:00 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Nadav Amit <namit@vmware.com>, Yang Shi <shy828301@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Christoph von Recklinghausen <crecklin@redhat.com>,
        Don Dutile <ddutile@redhat.com>
Subject: [PATCH v1] mm: fix PageAnonExclusive clearing racing with concurrent RCU GUP-fast
Date:   Thu,  1 Sep 2022 10:35:59 +0200
Message-Id: <20220901083559.67446-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
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
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h   |  9 ++++--
 include/linux/rmap.h | 66 ++++++++++++++++++++++++++++++++++++++++----
 mm/gup.c             |  7 +++++
 mm/huge_memory.c     |  3 ++
 mm/ksm.c             |  1 +
 mm/migrate_device.c  | 23 +++++++--------
 mm/rmap.c            | 11 ++++----
 7 files changed, 95 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21f8b27bd9fd..9641a2a488c1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2975,8 +2975,8 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
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
@@ -2997,6 +2997,11 @@ static inline bool gup_must_unshare(unsigned int flags, struct page *page)
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
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index bf80adca980b..72b2bcc37f73 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -267,7 +267,7 @@ static inline int page_try_dup_anon_rmap(struct page *page, bool compound,
  * @page: the exclusive anonymous page to try marking possibly shared
  *
  * The caller needs to hold the PT lock and has to have the page table entry
- * cleared/invalidated+flushed, to properly sync against GUP-fast.
+ * cleared/invalidated.
  *
  * This is similar to page_try_dup_anon_rmap(), however, not used during fork()
  * to duplicate a mapping, but instead to prepare for KSM or temporarily
@@ -283,12 +283,68 @@ static inline int page_try_share_anon_rmap(struct page *page)
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
+
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
 
diff --git a/mm/gup.c b/mm/gup.c
index 5abdaf487460..750fb317a41a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -158,6 +158,13 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
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
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e9414ee57c5b..2aef8d76fcf2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2140,6 +2140,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 *
 		 * In case we cannot clear PageAnonExclusive(), split the PMD
 		 * only and let try_to_migrate_one() fail later.
+		 *
+		 * See page_try_share_anon_rmap(): invalidate PMD first.
 		 */
 		anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
@@ -3177,6 +3179,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
 	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
+	/* See page_try_share_anon_rmap(): invalidate PMD first. */
 	anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 	if (anon_exclusive && page_try_share_anon_rmap(page)) {
 		set_pmd_at(mm, address, pvmw->pmd, pmdval);
diff --git a/mm/ksm.c b/mm/ksm.c
index 42ab153335a2..27e067f77097 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1095,6 +1095,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct page *page,
 			goto out_unlock;
 		}
 
+		/* See page_try_share_anon_rmap(): clear PTE first. */
 		if (anon_exclusive && page_try_share_anon_rmap(page)) {
 			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 27fb37d65476..0858bb4ba584 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -193,20 +193,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
+			ptep_get_and_clear(mm, addr, ptep);
+
+			/* See page_try_share_anon_rmap(): clear PTE first. */
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
-			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
-				ptep_clear_flush(vma, addr, ptep);
-
-				if (page_try_share_anon_rmap(page)) {
-					set_pte_at(mm, addr, ptep, pte);
-					unlock_page(page);
-					put_page(page);
-					mpfn = 0;
-					goto next;
-				}
-			} else {
-				ptep_get_and_clear(mm, addr, ptep);
+			if (anon_exclusive && page_try_share_anon_rmap(page)) {
+				set_pte_at(mm, addr, ptep, pte);
+				unlock_page(page);
+				put_page(page);
+				mpfn = 0;
+				goto next;
 			}
 
 			migrate->cpages++;
diff --git a/mm/rmap.c b/mm/rmap.c
index edc06c52bc82..b3a21ea9f3d0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1579,11 +1579,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -1714,6 +1711,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
+
+			/* See page_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    page_try_share_anon_rmap(subpage)) {
 				swap_free(entry);
@@ -2045,6 +2044,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			}
 			VM_BUG_ON_PAGE(pte_write(pteval) && folio_test_anon(folio) &&
 				       !anon_exclusive, subpage);
+
+			/* See page_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    page_try_share_anon_rmap(subpage)) {
 				if (folio_test_hugetlb(folio))
-- 
2.37.1

