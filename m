Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C23487E7
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 05:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCYEae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 00:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhCYEa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 00:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FCFC61A14;
        Thu, 25 Mar 2021 04:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616646628;
        bh=GzGfcPzU0S+PDow3L08zAISSA1Nd4wMv2D/YAM2pnQI=;
        h=Date:From:To:Subject:From;
        b=Uqb+mqRhzXyOreaPXvJpPmVmI47SXbN9eG3w5K4JWGXwblgzaMgcmr56NgmC3dJaC
         SL2tQkoedwwZTEy2tBuPVnrXXltzCKoMZfr0p13ybjRFoNYzDS2GRcI/e+ZIIeS220
         hCaqVhO9BcppeZnzW3ISRFA7W9uqtlzigbxsE3A0=
Date:   Wed, 24 Mar 2021 21:30:27 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.vnet.ibm.com,
        linmiaohe@huawei.com, liwp.linux@gmail.com, lkp@intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?hugetlb=5Fcgroup-fix-imbalanced-css=5Fget-and-css=5Fput-p?=
 =?US-ASCII?Q?air-for-shared-mappings-v3.patch?= removed from -mm tree
Message-ID: <20210325043027._BMsb1523%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: fix imbalanced css_get and css_put pair for shared mappings
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3.patch

This patch was dropped because it was folded into hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch

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
mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge.patch
mm-huge_memoryc-make-get_huge_zero_page-return-bool.patch
mm-huge_memoryc-rework-the-function-do_huge_pmd_numa_page-slightly.patch
mm-huge_memoryc-remove-redundant-pagecompound-check.patch
mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag.patch
mm-huge_memoryc-use-helper-function-migration_entry_to_page.patch

