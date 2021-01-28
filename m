Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4C4306869
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 01:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhA1ALW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 19:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhA1AKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 19:10:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF05164DD1;
        Thu, 28 Jan 2021 00:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611792568;
        bh=meprjUpGiIVBheb707rmwX6RwWZvg57o5VvC2n4HDsk=;
        h=Date:From:To:Subject:From;
        b=pAHMDIQWJs4RMHGI0v3zCbPf0bTPThIpu7LAdSKfcRTiznKEcNldhW7/sOzbohdzF
         DFqOKsbZDPuRtOpTnDKTtoHhQHQBEEjr9QgFQ+HOSsdH8BOyuh4aA5Bxj3Xt01GskV
         7DlZQUnUvBfF1t9PDUJ4mm6vlWzdn76yHeBrK0rk=
Date:   Wed, 27 Jan 2021 16:09:27 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com, louhongxiang@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, vbabka@suse.cz,
        walken@google.com
Subject:  +
 mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch added to -mm
 tree
Message-ID: <20210128000927.MhVdMWp-o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix potential pte_unmap on an not mapped pte
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

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
Subject: mm/rmap: fix potential pte_unmap on an not mapped pte

For PMD-mapped page (usually THP), pvmw->pte is NULL.  For PTE-mapped THP,
pvmw->pte is mapped.  But for HugeTLB pages, pvmw->pte is not mapped and
set to the relevant page table entry.  So in page_vma_mapped_walk_done(),
we may do pte_unmap() for HugeTLB pte which is not mapped.  Fix this by
checking pvmw->page against PageHuge before trying to do pte_unmap().

Link: https://lkml.kernel.org/r/20210127093349.39081-1-linmiaohe@huawei.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/include/linux/rmap.h
@@ -213,7 +213,8 @@ struct page_vma_mapped_walk {
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
 {
-	if (pvmw->pte)
+	/* HugeTLB pte is set to the relevant page table entry without pte_mapped. */
+	if (pvmw->pte && !PageHuge(pvmw->page))
 		pte_unmap(pvmw->pte);
 	if (pvmw->ptl)
 		spin_unlock(pvmw->ptl);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

