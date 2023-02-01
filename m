Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220CB685C58
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjBAApd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjBAApP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07175140B;
        Tue, 31 Jan 2023 16:45:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C38361759;
        Wed,  1 Feb 2023 00:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17FBC433EF;
        Wed,  1 Feb 2023 00:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212313;
        bh=nAYCSkJYZcY59a696y7A7A/df0zq+ox1TRyY4NDD2fo=;
        h=Date:To:From:Subject:From;
        b=fpqWIVa0U9ba0Kp5m78LDPWDUCj3Nb6CPhiYYfn0e7BKXno8YizzhsgDfItL+Jc3S
         /0fCgEuWVwLo+3wGNSLALpkggo/U/Yk1owqo4TT0C+PcsD2GjGglv81h+cl2PYArfp
         +4wEFpEzClKTPJXpCuHJ4+lqQpmbIhGEsmu4Mkgw=
Date:   Tue, 31 Jan 2023 16:45:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, jthoughton@google.com,
        david@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch removed from -mm tree
Message-Id: <20230201004513.A17FBC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: simplification, per David]
[akpm@linux-foundation.org: hugetlb.h: include page_ref.h for page_count()]
Link: https://lkml.kernel.org/r/20230126222721.222195-2-mike.kravetz@oracle.com
Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    4 +---
 include/linux/hugetlb.h |   13 +++++++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -745,9 +745,7 @@ static int smaps_hugetlb_range(pte_t *pt
 			page = pfn_swap_entry_to_page(swpent);
 	}
 	if (page) {
-		int mapcount = page_mapcount(page);
-
-		if (mapcount >= 2)
+		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
--- a/include/linux/hugetlb.h~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps
+++ a/include/linux/hugetlb.h
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
+#include <linux/page_ref.h>
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/pgtable.h>
@@ -1187,6 +1188,18 @@ static inline __init void hugetlb_cma_re
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


