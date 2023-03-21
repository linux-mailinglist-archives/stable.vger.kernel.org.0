Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7304C6C3C84
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 22:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCUVSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 17:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCUVSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 17:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858BD12BE7;
        Tue, 21 Mar 2023 14:18:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2102B61C52;
        Tue, 21 Mar 2023 21:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7266DC433D2;
        Tue, 21 Mar 2023 21:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679433523;
        bh=k4ojawdEAg0EYgIYP3L7W9N2nt9iU/O26aVRMwmph60=;
        h=Date:To:From:Subject:From;
        b=lbYgqxG8YinK8WHGJ6XzLBXjTZKUDfnjixCNvfph+KlXT69WzUZejD0CGXi39ylhq
         s/zBungnBq7VPYwJ7+jfSZcYnHT0DW1v76tUZoMEvlElTXbEZHZX8xvn4znUgQFmmY
         jqSRpKstD5YLYtgqOsDV6ndzPXb/Vs1R4UxZWuhQ=
Date:   Tue, 21 Mar 2023 14:18:42 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20230321211843.7266DC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix uffd wr-protection for CoW optimization path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix uffd wr-protection for CoW optimization path
Date: Tue, 21 Mar 2023 15:18:40 -0400

This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
writable even with uffd-wp bit set.  It only happens with all these
conditions met: (1) hugetlb memory (2) private mapping (3) original
mapping was missing, then (4) being wr-protected (IOW, pte marker
installed).  Then write to the page to trigger.

Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
even reaching hugetlb_wp() to avoid taking more locks that userfault won't
need.  However there's one CoW optimization path for missing hugetlb page
that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass
the userfaultfd-wp traps.

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

  (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
  for uffd-wp privately mapped pages.

This patch chose option (3) which contains the minimum changeset (simplest
for backport) and also make sure hugetlb_wp() itself will start to be
always safe with uffd-wp ptes even if called elsewhere in the future.

This patch will be needed for v5.19+ hence copy stable.

Link: https://lkml.kernel.org/r/20230321191840.1897940-1-peterx@redhat.com
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path
+++ a/mm/hugetlb.c
@@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		       struct folio *pagecache_folio, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
-	pte_t pte;
+	pte_t pte, newpte;
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page;
 	struct folio *new_folio;
@@ -5622,8 +5622,10 @@ retry_avoidcopy:
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
 		page_remove_rmap(old_page, vma, true);
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
-		set_huge_pte_at(mm, haddr, ptep,
-				make_huge_pte(vma, &new_folio->page, !unshare));
+		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
+		if (huge_pte_uffd_wp(pte))
+			newpte = huge_pte_mkuffd_wp(newpte);
+		set_huge_pte_at(mm, haddr, ptep, newpte);
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
 		new_folio = page_folio(old_page);
_

Patches currently in -mm which might be from peterx@redhat.com are

kselftest-vm-fix-unused-variable-warning.patch
tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

