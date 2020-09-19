Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9245270A88
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 06:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgISEU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 00:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4312721D43;
        Sat, 19 Sep 2020 04:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489225;
        bh=bbhbkMAaiTaRX+eyq+UtfFxMb5sRulwDpnswRN9D/44=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0ipoy1tNSP6JHZdfQaQy0SvIOVEfcwLyfY5DY75mGeBhSDZ/CAF2uV+xs7deMPEGU
         w2cwvhfrAiTCDBH8wUlgYsF6J6rVbqwzGlWywJ2t61SngP4InoEPoaR0re1jPgLqqH
         bGDWJ2yt0ioU65l5zJfEYZFAOLFa7+byo3etaL8s=
Date:   Fri, 18 Sep 2020 21:20:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        bharata@linux.ibm.com, bskeggs@redhat.com, hch@lst.de,
        jgg@nvidia.com, jglisse@redhat.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shuah@kernel.org, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ziy@nvidia.com
Subject:  [patch 09/15] mm/thp: fix __split_huge_pmd_locked() for
 migration PMD
Message-ID: <20200919042024.huPVYFOJa%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/thp: fix __split_huge_pmd_locked() for migration PMD

A migrating transparent huge page has to already be unmapped.  Otherwise,
the page could be modified while it is being copied to a new page and data
could be lost.  The function __split_huge_pmd() checks for a PMD migration
entry before calling __split_huge_pmd_locked() leading one to think that
__split_huge_pmd_locked() can handle splitting a migrating PMD.

However, the code always increments the page->_mapcount and adjusts the
memory control group accounting assuming the page is mapped.

Also, if the PMD entry is a migration PMD entry, the call to
is_huge_zero_pmd(*pmd) is incorrect because it calls pmd_pfn(pmd) instead
of migration_entry_to_pfn(pmd_to_swp_entry(pmd)).  Fix these problems by
checking for a PMD migration entry.

Link: https://lkml.kernel.org/r/20200903183140.19055-1-rcampbell@nvidia.com
Fixes: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-__split_huge_pmd_locked-for-migration-pmd
+++ a/mm/huge_memory.c
@@ -2022,7 +2022,7 @@ static void __split_huge_pmd_locked(stru
 		put_page(page);
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
-	} else if (is_huge_zero_pmd(*pmd)) {
+	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
@@ -2116,30 +2116,34 @@ static void __split_huge_pmd_locked(stru
 		pte = pte_offset_map(&_pmd, addr);
 		BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, addr, pte, entry);
-		atomic_inc(&page[i]._mapcount);
-		pte_unmap(pte);
-	}
-
-	/*
-	 * Set PG_double_map before dropping compound_mapcount to avoid
-	 * false-negative page_mapped().
-	 */
-	if (compound_mapcount(page) > 1 && !TestSetPageDoubleMap(page)) {
-		for (i = 0; i < HPAGE_PMD_NR; i++)
+		if (!pmd_migration)
 			atomic_inc(&page[i]._mapcount);
+		pte_unmap(pte);
 	}
 
-	lock_page_memcg(page);
-	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
-		/* Last compound_mapcount is gone. */
-		__dec_lruvec_page_state(page, NR_ANON_THPS);
-		if (TestClearPageDoubleMap(page)) {
-			/* No need in mapcount reference anymore */
+	if (!pmd_migration) {
+		/*
+		 * Set PG_double_map before dropping compound_mapcount to avoid
+		 * false-negative page_mapped().
+		 */
+		if (compound_mapcount(page) > 1 &&
+		    !TestSetPageDoubleMap(page)) {
 			for (i = 0; i < HPAGE_PMD_NR; i++)
-				atomic_dec(&page[i]._mapcount);
+				atomic_inc(&page[i]._mapcount);
+		}
+
+		lock_page_memcg(page);
+		if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
+			/* Last compound_mapcount is gone. */
+			__dec_lruvec_page_state(page, NR_ANON_THPS);
+			if (TestClearPageDoubleMap(page)) {
+				/* No need in mapcount reference anymore */
+				for (i = 0; i < HPAGE_PMD_NR; i++)
+					atomic_dec(&page[i]._mapcount);
+			}
 		}
+		unlock_page_memcg(page);
 	}
-	unlock_page_memcg(page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
_
