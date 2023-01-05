Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F865E2AD
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 02:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjAEBvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 20:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjAEBu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 20:50:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96B71A9;
        Wed,  4 Jan 2023 17:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E798B818F2;
        Thu,  5 Jan 2023 01:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21B9C433D2;
        Thu,  5 Jan 2023 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672883453;
        bh=3IwpuhvFgEf1pNQYVfQ95yp/uzVDYIt+HX+XhxBIVqg=;
        h=Date:To:From:Subject:From;
        b=gMTBxIxmE2TamX3Lh3WppqU5bEJRo1KZIobfmQeCTpU+lfswZG+u+fMkA98rpE8ij
         AChro2QvbbWO9MmRvgSxWcY/LJEHv2LFBWpTzptKG3WFZkAyBn/JC+vPwqwlEVHnDF
         hp8Wznj+8PNUF3XzuWmgDJFAYJ/KEIfUsBHxkYpY=
Date:   Wed, 04 Jan 2023 17:50:52 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, jthoughton@google.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-pre-allocate-pgtable-pages-for-uffd-wr-protects.patch added to mm-hotfixes-unstable branch
Message-Id: <20230105015053.D21B9C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: pre-allocate pgtable pages for uffd wr-protects
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-pre-allocate-pgtable-pages-for-uffd-wr-protects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-pre-allocate-pgtable-pages-for-uffd-wr-protects.patch

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
Subject: mm/hugetlb: pre-allocate pgtable pages for uffd wr-protects
Date: Wed, 4 Jan 2023 17:52:05 -0500

Userfaultfd-wp uses pte markers to mark wr-protected pages for both shmem
and hugetlb.  Shmem has pre-allocation ready for markers, but hugetlb path
was overlooked.

Doing so by calling huge_pte_alloc() if the initial pgtable walk fails to
find the huge ptep.  It's possible that huge_pte_alloc() can fail with
high memory pressure, in that case stop the loop immediately and fail
silently.  This is not the most ideal solution but it matches with what we
do with shmem meanwhile it avoids the splat in dmesg.

Link: https://lkml.kernel.org/r/20230104225207.1066932-2-peterx@redhat.com
Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-pre-allocate-pgtable-pages-for-uffd-wr-protects
+++ a/mm/hugetlb.c
@@ -6660,8 +6660,17 @@ unsigned long hugetlb_change_protection(
 		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address, psize);
 		if (!ptep) {
-			address |= last_addr_mask;
-			continue;
+			if (!uffd_wp) {
+				address |= last_addr_mask;
+				continue;
+			}
+			/*
+			 * Userfaultfd wr-protect requires pgtable
+			 * pre-allocations to install pte markers.
+			 */
+			ptep = huge_pte_alloc(mm, vma, address, psize);
+			if (!ptep)
+				break;
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, vma, address, ptep)) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-pre-allocate-pgtable-pages-for-uffd-wr-protects.patch
mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch
mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker.patch
mm-uffd-always-wr-protect-pte-in-ptepmd_mkuffd_wp.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-mprotect-use-long-for-page-accountings-and-retval.patch
mm-uffd-detect-pgtable-allocation-failures.patch

