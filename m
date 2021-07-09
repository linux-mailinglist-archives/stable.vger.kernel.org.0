Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9A33C245D
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhGINW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232215AbhGINWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C116128A;
        Fri,  9 Jul 2021 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836777;
        bh=HKAMT1+n+jJsN5RDFBgrIH5PaNUPjlXuDFbC3PkpPjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9J0CcOtgNgHOZp++OhxpHcUT+Q4tyLIO0oEiFFP0fhCtU2y24qeNrdsAI8BN66Wl
         YczmlUR2tWGZ8G8x1qkq8BsWs/s0k3mcTsQib1p/Oo4RxgdIZL5QT3R4mFL8aDOB1x
         KjmcvB2RtRNVMOc3sZ0B4YJLNdez67iybtkXlExI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/25] mm: page_vma_mapped_walk(): add a level of indentation
Date:   Fri,  9 Jul 2021 15:18:45 +0200
Message-Id: <20210709131636.273956243@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit b3807a91aca7d21c05d5790612e49969117a72b9 ]

page_vma_mapped_walk() cleanup: add a level of indentation to much of
the body, making no functional change in this commit, but reducing the
later diff when this is all converted to a loop.

[hughd@google.com: : page_vma_mapped_walk(): add a level of indentation fix]
  Link: https://lkml.kernel.org/r/7f817555-3ce1-c785-e438-87d8efdcaf26@google.com

Link: https://lkml.kernel.org/r/efde211-f3e2-fe54-977-ef481419e7f3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 105 ++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 50 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2463ba78959b..911c6dbe85f9 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -168,62 +168,67 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->pte)
 		goto next_pte;
 restart:
-	pgd = pgd_offset(mm, pvmw->address);
-	if (!pgd_present(*pgd))
-		return false;
-	p4d = p4d_offset(pgd, pvmw->address);
-	if (!p4d_present(*p4d))
-		return false;
-	pud = pud_offset(p4d, pvmw->address);
-	if (!pud_present(*pud))
-		return false;
-	pvmw->pmd = pmd_offset(pud, pvmw->address);
-	/*
-	 * Make sure the pmd value isn't cached in a register by the
-	 * compiler and used as a stale value after we've observed a
-	 * subsequent update.
-	 */
-	pmde = READ_ONCE(*pvmw->pmd);
-	if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
-		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-		pmde = *pvmw->pmd;
-		if (likely(pmd_trans_huge(pmde))) {
-			if (pvmw->flags & PVMW_MIGRATION)
-				return not_found(pvmw);
-			if (pmd_page(pmde) != page)
-				return not_found(pvmw);
-			return true;
-		}
-		if (!pmd_present(pmde)) {
-			swp_entry_t entry;
+	{
+		pgd = pgd_offset(mm, pvmw->address);
+		if (!pgd_present(*pgd))
+			return false;
+		p4d = p4d_offset(pgd, pvmw->address);
+		if (!p4d_present(*p4d))
+			return false;
+		pud = pud_offset(p4d, pvmw->address);
+		if (!pud_present(*pud))
+			return false;
 
-			if (!thp_migration_supported() ||
-			    !(pvmw->flags & PVMW_MIGRATION))
-				return not_found(pvmw);
-			entry = pmd_to_swp_entry(pmde);
-			if (!is_migration_entry(entry) ||
-			    migration_entry_to_page(entry) != page)
-				return not_found(pvmw);
-			return true;
-		}
-		/* THP pmd was split under us: handle on pte level */
-		spin_unlock(pvmw->ptl);
-		pvmw->ptl = NULL;
-	} else if (!pmd_present(pmde)) {
+		pvmw->pmd = pmd_offset(pud, pvmw->address);
 		/*
-		 * If PVMW_SYNC, take and drop THP pmd lock so that we
-		 * cannot return prematurely, while zap_huge_pmd() has
-		 * cleared *pmd but not decremented compound_mapcount().
+		 * Make sure the pmd value isn't cached in a register by the
+		 * compiler and used as a stale value after we've observed a
+		 * subsequent update.
 		 */
-		if ((pvmw->flags & PVMW_SYNC) && PageTransCompound(page)) {
-			spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+		pmde = READ_ONCE(*pvmw->pmd);
+
+		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			pmde = *pvmw->pmd;
+			if (likely(pmd_trans_huge(pmde))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (pmd_page(pmde) != page)
+					return not_found(pvmw);
+				return true;
+			}
+			if (!pmd_present(pmde)) {
+				swp_entry_t entry;
+
+				if (!thp_migration_supported() ||
+				    !(pvmw->flags & PVMW_MIGRATION))
+					return not_found(pvmw);
+				entry = pmd_to_swp_entry(pmde);
+				if (!is_migration_entry(entry) ||
+				    migration_entry_to_page(entry) != page)
+					return not_found(pvmw);
+				return true;
+			}
+			/* THP pmd was split under us: handle on pte level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		} else if (!pmd_present(pmde)) {
+			/*
+			 * If PVMW_SYNC, take and drop THP pmd lock so that we
+			 * cannot return prematurely, while zap_huge_pmd() has
+			 * cleared *pmd but not decremented compound_mapcount().
+			 */
+			if ((pvmw->flags & PVMW_SYNC) &&
+			    PageTransCompound(page)) {
+				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
 
-			spin_unlock(ptl);
+				spin_unlock(ptl);
+			}
+			return false;
 		}
-		return false;
+		if (!map_pte(pvmw))
+			goto next_pte;
 	}
-	if (!map_pte(pvmw))
-		goto next_pte;
 	while (1) {
 		unsigned long end;
 
-- 
2.30.2



