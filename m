Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5F733FD98
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 04:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhCRDMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 23:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230226AbhCRDMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 23:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A93764EED;
        Thu, 18 Mar 2021 03:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616037109;
        bh=2pzQy79hR4wFUXzO4EX8JiZmJ6WObZ7/dhz1YgeYCWc=;
        h=Date:From:To:Subject:From;
        b=rxo3Lekc4yGjGfDLaqp9q8bBZc5tQw5FfoV2GcMQc1qjuI+qurhBwihL/A6byMp6/
         W38nnUYeRKZztNerwPdXNL1b6mgWyRK501dLHKqelGPQqn6qP/4ZW4bnFNfppks4Sz
         4J2IEV2iaIorKMN5SIVCtxksS4PLELSTyzlsJClk=
Date:   Wed, 17 Mar 2021 20:11:48 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.vnet.ibm.com,
        linmiaohe@huawei.com, liwp.linux@gmail.com, lkp@intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?hugetlb=5Fcgroup-fix-imbalanced-css=5Fget-and-css=5Fput-p?=
 =?US-ASCII?Q?air-for-shared-mappings-v3.patch?= added to -mm tree
Message-ID: <20210318031148.B3PWbGSo4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: fix imbalanced css_get and css_put pair for shared mappings
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: fix imbalanced css_get and css_put pair for shared mappings

reshape some comments, per Mike

Link: https://lkml.kernel.org/r/20210316023002.53921-1-linmiaohe@huawei.com
Fixes: 075a61d07a8e ("hugetlb_cgroup: add accounting for shared mappings")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: kernel test robot <lkp@intel.com> (auto build test ERROR)
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |   13 ++++++-------
 mm/hugetlb_cgroup.c |    3 +--
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3
+++ a/mm/hugetlb.c
@@ -281,13 +281,12 @@ static void record_hugetlb_cgroup_unchar
 			&h_cg->rsvd_hugepage[hstate_index(h)];
 		nrg->css = &h_cg->css;
 		/*
-		 * The caller (hugetlb_reserve_pages now) will only hold one
-		 * h_cg->css reference for the whole contiguous reservation
-		 * region. But this area might be scattered when there are
-		 * already some file_regions reside in it. As a result, many
-		 * file_regions may share only one h_cg->css reference. In
-		 * order to ensure that one file_region must hold and only
-		 * hold one h_cg->css reference, we should do css_get for
+		 * The caller will hold exactly one h_cg->css reference for the
+		 * whole contiguous reservation region. But this area might be
+		 * scattered when there are already some file_regions reside in
+		 * it. As a result, many file_regions may share only one css
+		 * reference. In order to ensure that one file_region must hold
+		 * exactly one h_cg->css reference, we should do css_get for
 		 * each file_region and leave the reference held by caller
 		 * untouched.
 		 */
--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3
+++ a/mm/hugetlb_cgroup.c
@@ -403,8 +403,7 @@ void hugetlb_cgroup_uncharge_file_region
 				      nr_pages * resv->pages_per_hpage);
 		/*
 		 * Only do css_put(rg->css) when we delete the entire region
-		 * because one file_region must hold and only hold one rg->css
-		 * reference.
+		 * because one file_region must hold exactly one css reference.
 		 */
 		if (region_del)
 			css_put(rg->css);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch
khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch
khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch
khugepaged-use-helper-khugepaged_test_exit-in-__khugepaged_enter.patch
khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch
mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch

