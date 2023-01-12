Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FB566677D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbjALAPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbjALAPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C76E140AE;
        Wed, 11 Jan 2023 16:15:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A9EF61F15;
        Thu, 12 Jan 2023 00:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A582C433EF;
        Thu, 12 Jan 2023 00:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482513;
        bh=0nW8ef3WKNAoPZdcJFg8ZD/5PjJ/AvfCsX/kvuxnjiQ=;
        h=Date:To:From:Subject:From;
        b=pOGdYwwvsMyme3/LXkVYARjY+uWYcec+roY4jA1o5WMb+e03vY5HsNRySiQz4dhy/
         w8evYhOvZHl9Ss68SM9hhjEErF2zCOLUiryl3ufidvhMYl9J+efjF+00ARY0YvlB2H
         7jRYiDYPAfRulhb9x01xLsChfvIN913anfE+155o=
Date:   Wed, 11 Jan 2023 16:15:12 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, jthoughton@google.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-pre-allocate-pgtable-pages-for-uffd-wr-protects.patch removed from -mm tree
Message-Id: <20230112001513.5A582C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: pre-allocate pgtable pages for uffd wr-protects
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-pre-allocate-pgtable-pages-for-uffd-wr-protects.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
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

