Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616943B5553
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhF0Vz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhF0Vz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:55:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E7661C35;
        Sun, 27 Jun 2021 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830784;
        bh=Vsj9WbFqBnpHy6UspC7qeRR6zlmy2Fa2Cq2Kc7WH8lI=;
        h=Date:From:To:Subject:From;
        b=t+ENurYnJnbDHX4N8K5SBlw7veMvUmO0ZjilMP74uaXyp8EXM3FVbfCA02oHoGQ4o
         yqHPThvxhzhTKpgOVHMN/eNlcUcuAtGMvJdc4tPdCf5Vx+3RZDQzcC5Rq/XlhQBSdH
         KhVZX0IkIgIyMtxLqFDrne8wAlTOi712DJkKcz+8=
Date:   Sun, 27 Jun 2021 14:53:03 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        wangyugui@e16-tech.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch removed from -mm tree
Message-ID: <20210627215303.bJv6jbg27%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: make is_huge_zero_pmd() safe and quicker
has been removed from the -mm tree.  Its filename was
     mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: make is_huge_zero_pmd() safe and quicker

Most callers of is_huge_zero_pmd() supply a pmd already verified present;
but a few (notably zap_huge_pmd()) do not - it might be a pmd migration
entry, in which the pfn is encoded differently from a present pmd: which
might pass the is_huge_zero_pmd() test (though not on x86, since L1TF
forced us to protect against that); or perhaps even crash in pmd_page()
applied to a swap-like entry.

Make it safe by adding pmd_present() check into is_huge_zero_pmd() itself;
and make it quicker by saving huge_zero_pfn, so that is_huge_zero_pmd()
will not need to do that pmd_page() lookup each time.

__split_huge_pmd_locked() checked pmd_trans_huge() before: that worked,
but is unnecessary now that is_huge_zero_pmd() checks present.

Link: https://lkml.kernel.org/r/21ea9ca-a1f5-8b90-5e88-95fb1c49bbfa@google.com
Fixes: e71769ae5260 ("mm: enable thp migration for shmem thp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 +++++++-
 mm/huge_memory.c        |    5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-make-is_huge_zero_pmd-safe-and-quicker
+++ a/include/linux/huge_mm.h
@@ -286,6 +286,7 @@ struct page *follow_devmap_pud(struct vm
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
+extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_page(struct page *page)
 {
@@ -294,7 +295,7 @@ static inline bool is_huge_zero_page(str
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return is_huge_zero_page(pmd_page(pmd));
+	return READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd) && pmd_present(pmd);
 }
 
 static inline bool is_huge_zero_pud(pud_t pud)
@@ -439,6 +440,11 @@ static inline bool is_huge_zero_page(str
 {
 	return false;
 }
+
+static inline bool is_huge_zero_pmd(pmd_t pmd)
+{
+	return false;
+}
 
 static inline bool is_huge_zero_pud(pud_t pud)
 {
--- a/mm/huge_memory.c~mm-thp-make-is_huge_zero_pmd-safe-and-quicker
+++ a/mm/huge_memory.c
@@ -62,6 +62,7 @@ static struct shrinker deferred_split_sh
 
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
+unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
 bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
@@ -98,6 +99,7 @@ retry:
 		__free_pages(zero_page, compound_order(zero_page));
 		goto retry;
 	}
+	WRITE_ONCE(huge_zero_pfn, page_to_pfn(zero_page));
 
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
@@ -147,6 +149,7 @@ static unsigned long shrink_huge_zero_pa
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
+		WRITE_ONCE(huge_zero_pfn, ~0UL);
 		__free_pages(zero_page, compound_order(zero_page));
 		return HPAGE_PMD_NR;
 	}
@@ -2071,7 +2074,7 @@ static void __split_huge_pmd_locked(stru
 		return;
 	}
 
-	if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
+	if (is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

