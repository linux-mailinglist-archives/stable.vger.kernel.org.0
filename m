Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A352E67D8BC
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 23:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjAZWsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 17:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjAZWsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 17:48:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E695222E4;
        Thu, 26 Jan 2023 14:48:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32A4A61981;
        Thu, 26 Jan 2023 22:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90856C433EF;
        Thu, 26 Jan 2023 22:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674773294;
        bh=Bj7rRXnktVjIvpVG8heRlGl49GGfpOPBGwd3Bf//mvo=;
        h=Date:To:From:Subject:From;
        b=S3zlenej+TC0gXdzou9m+skWv7RIMBd2kPMKolx0WiY/UGZW1gT1eyQsKgmIlxyVk
         draxuIJ69O+jrR0k6wk9A8tVcHlAX7D6x5ODMPIcaSPtmasgkIVKkwSQkY9sfyfOIB
         IuFlJfrae7i0x/InFm45e4MVTqzB1WFP4iFBQMZs=
Date:   Thu, 26 Jan 2023 14:48:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, jthoughton@google.com,
        david@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch added to mm-hotfixes-unstable branch
Message-Id: <20230126224814.90856C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
Date: Thu, 26 Jan 2023 14:27:20 -0800

Patch series "Fixes for hugetlb mapcount at most 1 for shared PMDs".

This issue of mapcount in hugetlb pages referenced by shared PMDs was
discussed in [1].  The following two patches address user visible behavior
caused by this issue.

[1] https://lore.kernel.org/linux-mm/Y9BF+OCdWnCSilEu@monkey/


This patch (of 2):

A hugetlb page will have a mapcount of 1 if mapped by multiple processes
via a shared PMD.  This is because only the first process increases the
map count, and subsequent processes just add the shared PMD page to their
page table.

page_mapcount is being used to decide if a hugetlb page is shared or
private in /proc/PID/smaps.  Pages referenced via a shared PMD were
incorrectly being counted as private.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is found
count the hugetlb page as shared.  A new helper to check for a shared PMD
is added.

Link: https://lkml.kernel.org/r/20230126222721.222195-2-mike.kravetz@oracle.com
Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   10 ++++++++--
 include/linux/hugetlb.h |   12 ++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -749,8 +749,14 @@ static int smaps_hugetlb_range(pte_t *pt
 
 		if (mapcount >= 2)
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
-		else
-			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
+		else {
+			if (hugetlb_pmd_shared(pte))
+				mss->shared_hugetlb +=
+						huge_page_size(hstate_vma(vma));
+			else
+				mss->private_hugetlb +=
+						huge_page_size(hstate_vma(vma));
+		}
 	}
 	return 0;
 }
--- a/include/linux/hugetlb.h~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps
+++ a/include/linux/hugetlb.h
@@ -1187,6 +1187,18 @@ static inline __init void hugetlb_cma_re
 }
 #endif
 
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return page_count(virt_to_page(pte)) > 1;
+}
+#else
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return false;
+}
+#endif
+
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
 
 #ifndef __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch
migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration.patch

