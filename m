Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1E26C72D0
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 23:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjCWWMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 18:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjCWWMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 18:12:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DDD22C92
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 15:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679609520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BdUUJpvBYjmASyn2bJRVEYYq1jXnao8uWURPAVj9ZuA=;
        b=M+kcaM1wrX57MuuuWJak74i5lQy1Vr9B3wtycL3KLAvPQy6xvPFB8s2L+/Kx/ebJBRcNFj
        bWWhNI4nQdripCWskfmbGUYZxcukFFSu+hwygqKeapEHk4fizoEmlD08HhU1mlg4wbHGGB
        hMMB196vPAbTBMsvZJQ2jX0P8vzxlcI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-o0aqaE9PO_i1rqZEhfXMzw-1; Thu, 23 Mar 2023 18:11:58 -0400
X-MC-Unique: o0aqaE9PO_i1rqZEhfXMzw-1
Received: by mail-qt1-f198.google.com with SMTP id t15-20020a05622a180f00b003e37dd114e3so7016493qtc.10
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 15:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609518;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BdUUJpvBYjmASyn2bJRVEYYq1jXnao8uWURPAVj9ZuA=;
        b=Nmj4W8Q007jw2OzxIOhpUEcUx2KW3H/HaiwRnVhtp+PIMkU72rJWcTsZC0YOFbzGbe
         wN/qmF8cqwWQv6Emf+Vux/Fc57KQi7RzzG3Ub/OSiffqrKgikWgMT1dIGuDTDPMPyOmg
         mWqy1ZZZt1/g1rVZU00zyEAeu0f04ldv7HKpI+ylylZbCd677DUttMtKR5B6GIGvwK91
         /BYv7v7UwOE04+ajJMhYscEJXu6+dyyQU98Pgu+LYy7IpSCFGNzCn2RiMKbN3QEbnF2i
         mVwKYT7x8GzqtSLS5XPrjsOKLV/kbZJVMzkXfFlRkdvLUanc6S61A/c+QOqJY1i5sUoY
         8m2Q==
X-Gm-Message-State: AAQBX9cLafsyQPYwIrviWZQ4Rjn4Uke98bo7UAQe4g2oIIJG3j0VfuLA
        ZiU4oBj0p4hvScJ81BN9Cpshrdy+2A7le9jLh0Pdi7NTOXkWzHp00n+EXZWkm2c/w/G83Hne22+
        3K4IKfRm9PX5OkU1G
X-Received: by 2002:a05:6214:5289:b0:572:54c1:c14e with SMTP id kj9-20020a056214528900b0057254c1c14emr698348qvb.5.1679609517710;
        Thu, 23 Mar 2023 15:11:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350YBlxw12POHwLjWBno5c2aXDai3cLQ8JVAyA6GrrMtmktG7KD8PtGtInbK3TmVArYNPVj7p4w==
X-Received: by 2002:a05:6214:5289:b0:572:54c1:c14e with SMTP id kj9-20020a056214528900b0057254c1c14emr698317qvb.5.1679609517384;
        Thu, 23 Mar 2023 15:11:57 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id e7-20020ad450c7000000b005dd8b934592sm190729qvq.42.2023.03.23.15.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 15:11:56 -0700 (PDT)
Date:   Thu, 23 Mar 2023 18:11:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
Message-ID: <ZBzOqwF2wrHgBVZb@x1n>
References: <20230321191840.1897940-1-peterx@redhat.com>
 <44aae7fc-fb1f-b38e-bc17-504abf054e3f@redhat.com>
 <ZBoKod6+twRYvSYz@x1n>
 <f411b983-0c47-73f8-775b-928fcf61620a@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="le5JTZlZZI66lfKs"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f411b983-0c47-73f8-775b-928fcf61620a@collabora.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--le5JTZlZZI66lfKs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Mar 23, 2023 at 08:33:07PM +0500, Muhammad Usama Anjum wrote:
> Hi Peter,
> 
> Sorry for late reply.
> 
> On 3/22/23 12:50 AM, Peter Xu wrote:
> > On Tue, Mar 21, 2023 at 08:36:35PM +0100, David Hildenbrand wrote:
> >> On 21.03.23 20:18, Peter Xu wrote:
> >>> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> >>> writable even with uffd-wp bit set.  It only happens with all these
> >>> conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
> >>> was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
> >>> write to the page to trigger.
> >>>
> >>> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> >>> even reaching hugetlb_wp() to avoid taking more locks that userfault won't
> >>> need.  However there's one CoW optimization path for missing hugetlb page
> >>> that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
> >>> userfaultfd-wp traps.
> >>>
> >>> A few ways to resolve this:
> >>>
> >>>    (1) Skip the CoW optimization for hugetlb private mapping, considering
> >>>    that private mappings for hugetlb should be very rare, so it may not
> >>>    really be helpful to major workloads.  The worst case is we only skip the
> >>>    optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
> >>>    fault anyway.
> >>>
> >>>    (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
> >>>    into hugetlb_wp().  The major cons is there're a bunch of locks taken
> >>>    when calling hugetlb_wp(), and that will make the changeset unnecessarily
> >>>    complicated due to the lock operations.
> >>>
> >>>    (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
> >>>    for uffd-wp privately mapped pages.
> >>>
> >>> This patch chose option (3) which contains the minimum changeset (simplest
> >>> for backport) and also make sure hugetlb_wp() itself will start to be
> >>> always safe with uffd-wp ptes even if called elsewhere in the future.
> >>>
> >>> This patch will be needed for v5.19+ hence copy stable.
> >>>
> >>> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> >>> Cc: linux-stable <stable@vger.kernel.org>
> >>> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> >>> Signed-off-by: Peter Xu <peterx@redhat.com>
> >>> ---
> >>>   mm/hugetlb.c | 8 +++++---
> >>>   1 file changed, 5 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> >>> index 8bfd07f4c143..22337b191eae 100644
> >>> --- a/mm/hugetlb.c
> >>> +++ b/mm/hugetlb.c
> >>> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> >>>   		       struct folio *pagecache_folio, spinlock_t *ptl)
> >>>   {
> >>>   	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> >>> -	pte_t pte;
> >>> +	pte_t pte, newpte;
> >>>   	struct hstate *h = hstate_vma(vma);
> >>>   	struct page *old_page;
> >>>   	struct folio *new_folio;
> >>> @@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> >>>   		mmu_notifier_invalidate_range(mm, range.start, range.end);
> >>>   		page_remove_rmap(old_page, vma, true);
> >>>   		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
> >>> -		set_huge_pte_at(mm, haddr, ptep,
> >>> -				make_huge_pte(vma, &new_folio->page, !unshare));
> >>> +		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
> >>> +		if (huge_pte_uffd_wp(pte))
> >>> +			newpte = huge_pte_mkuffd_wp(newpte);
> >>> +		set_huge_pte_at(mm, haddr, ptep, newpte);
> >>>   		folio_set_hugetlb_migratable(new_folio);
> >>>   		/* Make the old page be freed below */
> >>>   		new_folio = page_folio(old_page);
> >>
> >> Looks correct to me. Do we have a reproducer?
> > 
> > I used a reproducer for the async mode I wrote (patch 2 attached, need to
> > change to VM_PRIVATE):
> > 
> > https://lore.kernel.org/all/ZBNr4nohj%2FTw4Zhw@x1n/
> > 
> > I don't think kernel kselftest can trigger it because we don't do strict
> > checks yet with uffd-wp bits.  I've already started looking into cleanup
> > the test cases and I do plan to add new tests to cover this.
> > 
> > Meanwhile, let's also wait for an ack from Muhammad.  Even though the async
> > mode is not part of the code base, it'll be a good test for verifying every
> > single uffd-wp bit being set or cleared as expected.
> I've tested by applying this patch. But the bug is still there. Just like
> Peter has mentioned, we are using our in progress patches related to
> pagemap_scan ioctl and userfaultd wp async patches to reproduce it.
> 
> To reproduce please build kernel and run pagemap_ioctl test in mm in
> hugetlb_mem_reproducer branch:
> https://gitlab.collabora.com/usama.anjum/linux-mainline/-/tree/hugetlb_mem_reproducer
> 
> In case you have any question on how to reproduce, please let me know. I'll
> try to provide a cleaner alternative.

Hmm, I think my current fix is incomplete if not wrong.  The root cause
should still be valid, however I overlooked another path:

	if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
		if (!PageAnonExclusive(old_page))
			page_move_anon_rmap(old_page, vma);
		if (likely(!unshare))
			set_huge_ptep_writable(vma, haddr, ptep);

		delayacct_wpcopy_end();
		return 0;
	}

We should bail out early in this path, and it'll be even easier we always
bail out hugetlb_wp() as long as uffd-wp is detected because userfault
should always be handled before any decision to CoW.

v2 attached.. Please give it another shot.

Thanks,

-- 
Peter Xu

--le5JTZlZZI66lfKs
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-mm-hugetlb-Fix-uffd-wr-protection-for-CoW-optimizati.patch"

From 4a294f9ec5d2ba94a6a7ecf03bd096ea35902f2f Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 21 Mar 2023 14:58:42 -0400
Subject: [PATCH v2] mm/hugetlb: Fix uffd wr-protection for CoW optimization path

This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
writable even with uffd-wp bit set.  It only happens with hugetlb private
mappings, when someone firstly wr-protects a missing pte (which will
install a pte marker), followed by a write to the page.  That will trigger
a missing fault and an optimized CoW in the same fault stack.

Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
even reaching hugetlb_wp() to avoid taking more locks that userfault won't
need.  However there's one CoW optimization path for missing hugetlb page
that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
userfaultfd-wp traps.

A few ways to resolve this:

  (1) Skip the CoW optimization for hugetlb private mapping, considering
  that private mappings for hugetlb should be very rare, so it may not
  really be helpful to major workloads.  The worst case is we only skip the
  optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
  fault anyway.

  (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
  into hugetlb_wp().  The major cons is there're a bunch of locks taken
  when calling hugetlb_wp(), and that will make the changeset unnecessarily
  complicated due to the lock operations.

  (3) Skip hugetlb_wp() when uffd-wp bit is still set.  It means it
  requires another hugetlb_fault() to resolve the uffd-wp bit first.

This patch chose option (3) which contains the minimum changeset (simplest
for backport) and also make sure hugetlb_wp() itself will start to be
always safe with uffd-wp ptes even if called elsewhere in the future.

This patch will be needed for v5.19+ hence copy stable.

Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-stable <stable@vger.kernel.org>
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/hugetlb.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8bfd07f4c143..b60959f2a3f0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		       struct folio *pagecache_folio, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
-	pte_t pte;
+	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page;
 	struct folio *new_folio;
@@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long haddr = address & huge_page_mask(h);
 	struct mmu_notifier_range range;
 
+	/*
+	 * Never handle CoW for uffd-wp protected pages.  It should be only
+	 * handled when the uffd-wp protection is removed.
+	 *
+	 * Note that only the CoW optimization path can trigger this and
+	 * got skipped, because hugetlb_fault() will always resolve uffd-wp
+	 * bit first.
+	 */
+	if (huge_pte_uffd_wp(pte))
+		return 0;
+
 	/*
 	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
 	 * PTE mapped R/O such as maybe_mkwrite() would do.
@@ -5500,7 +5511,6 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		return 0;
 	}
 
-	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
 	delayacct_wpcopy_start();
-- 
2.39.1


--le5JTZlZZI66lfKs--

