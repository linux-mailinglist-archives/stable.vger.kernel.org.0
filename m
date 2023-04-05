Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1128E6D877B
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 21:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbjDET4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 15:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjDET4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 15:56:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FE3126;
        Wed,  5 Apr 2023 12:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DC9B6408D;
        Wed,  5 Apr 2023 19:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7092EC433EF;
        Wed,  5 Apr 2023 19:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680724598;
        bh=O1wAzMmk+s8Y9wIwOYI5U0pfet0phDr+t7fnpIlf2N4=;
        h=Date:To:From:Subject:From;
        b=pUFTneTw5F9/gnSe9lQQaDgDoegadsoj6s0ZpaYkrCIkdDAmptf4XgFjr4OMnsEiq
         D5hNKRmPNYTAab7PkCVAUjFXI2FWaBBSUxB7FYaoctx+uIkpTbFSczDueyk6afpTU8
         76yc0PVsg0616ngRvDrBaAafDuP6BNy/LI269TM8=
Date:   Wed, 05 Apr 2023 12:56:37 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        david@redhat.com, axelrasmussen@google.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230405195638.7092EC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: check again on anon uffd-wp during isolation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch

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
Subject: mm/khugepaged: check again on anon uffd-wp during isolation
Date: Wed, 5 Apr 2023 11:51:20 -0400

Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd
round done in __collapse_huge_page_isolate() after
hpage_collapse_scan_pmd(), during which all the locks will be released
temporarily.  It means the pgtable can change during this phase before 2nd
round starts.

It's logically possible some ptes got wr-protected during this phase, and
we can errornously collapse a thp without noticing some ptes are
wr-protected by userfault.  e1e267c7928f wanted to avoid it but it only
did that for the 1st phase, not the 2nd phase.

Since __collapse_huge_page_isolate() happens after a round of small page
swapins, we don't need to worry on any !present ptes - if it existed
khugepaged will already bail out.  So we only need to check present ptes
with uffd-wp bit set there.

This is something I found only but never had a reproducer, I thought it
was one caused a bug in Muhammad's recent pagemap new ioctl work, but it
turns out it's not the cause of that but an userspace bug.  However this
seems to still be a real bug even with a very small race window, still
worth to have it fixed and copy stable.

Link: https://lkml.kernel.org/r/20230405155120.3608140-1-peterx@redhat.com
Fixes: e1e267c7928f ("khugepaged: skip collapse if uffd-wp detected")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation
+++ a/mm/khugepaged.c
@@ -573,6 +573,10 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
 		}
+		if (pte_uffd_wp(pteval)) {
+			result = SCAN_PTE_UFFD_WP;
+			goto out;
+		}
 		page = vm_normal_page(vma, address, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch
mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

