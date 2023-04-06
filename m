Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B316D8C6D
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjDFBHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbjDFBG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E13E7293;
        Wed,  5 Apr 2023 18:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28EE264293;
        Thu,  6 Apr 2023 01:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A05C433D2;
        Thu,  6 Apr 2023 01:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743214;
        bh=mTP5ej5Fqqoerj6wJmYRfwAM+BB9hliKoqC03nNcnNg=;
        h=Date:To:From:Subject:From;
        b=UkvgmDgMSRP4A+qNCb0SytQxH3WwJR8o1r7AVModU2VH8VCf8Z9eXVwSTOyjxw62p
         PDAcKbR2ql0ycacA4IN8DPcnMRwCjruQlQf5KNqSPGYTZ9hnd27BsDpol0mT3TaZBu
         xPq/AsoQlP8ijQrDEmK+Sg0LUGI3CejMI4XGCvYQ=
Date:   Wed, 05 Apr 2023 18:06:53 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch removed from -mm tree
Message-Id: <20230406010654.79A05C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix uffd wr-protection for CoW optimization path
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix uffd wr-protection for CoW optimization path
Date: Tue, 21 Mar 2023 15:18:40 -0400

This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
writable even with uffd-wp bit set.  It only happens with hugetlb private
mappings, when someone firstly wr-protects a missing pte (which will
install a pte marker), then a write to the same page without any prior
access to the page.

Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
reaching hugetlb_wp() to avoid taking more locks that userfault won't
need.  However there's one CoW optimization path that can trigger
hugetlb_wp() inside hugetlb_no_page(), which will bypass the trap.

This patch skips hugetlb_wp() for CoW and retries the fault if uffd-wp bit
is detected.  The new path will only trigger in the CoW optimization path
because generic hugetlb_fault() (e.g.  when a present pte was
wr-protected) will resolve the uffd-wp bit already.  Also make sure
anonymous UNSHARE won't be affected and can still be resolved, IOW only
skip CoW not CoR.

This patch will be needed for v5.19+ hence copy stable.

[peterx@redhat.com: v2]
  Link: https://lkml.kernel.org/r/ZBzOqwF2wrHgBVZb@x1n
[peterx@redhat.com: v3]
  Link: https://lkml.kernel.org/r/20230324142620.2344140-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20230321191840.1897940-1-peterx@redhat.com
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path
+++ a/mm/hugetlb.c
@@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		       struct folio *pagecache_folio, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
-	pte_t pte;
+	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page;
 	struct folio *new_folio;
@@ -5488,6 +5488,17 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	struct mmu_notifier_range range;
 
 	/*
+	 * Never handle CoW for uffd-wp protected pages.  It should be only
+	 * handled when the uffd-wp protection is removed.
+	 *
+	 * Note that only the CoW optimization path (in hugetlb_no_page())
+	 * can trigger this, because hugetlb_fault() will always resolve
+	 * uffd-wp bit first.
+	 */
+	if (!unshare && huge_pte_uffd_wp(pte))
+		return 0;
+
+	/*
 	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
 	 * PTE mapped R/O such as maybe_mkwrite() would do.
 	 */
@@ -5500,7 +5511,6 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		return 0;
 	}
 
-	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
 	delayacct_wpcopy_start();
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

