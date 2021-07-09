Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772043C24A6
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhGINYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232590AbhGINYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB6C0608FE;
        Fri,  9 Jul 2021 13:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836894;
        bh=G3knDO8hvEoMaerUD4jhi2NGOoFusBiyj1HkTkIv4QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFSfkTuheRXku+rXoGgVeAfiDQ3E/RiO4InehpVS0s433RYY2LT4Sqa2oROb++4yb
         lNoIUbHqKPnmNf6XSZ93lwzNoZqPeVcAOevMX1xs9mFUe4F9x8WKdk0U8cy7/SDE74
         LojrK7QXCy36ZLuwlAJym5XHHYVtRAZKpNp0ARt8=
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
Subject: [PATCH 4.19 19/34] mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
Date:   Fri,  9 Jul 2021 15:20:35 +0200
Message-Id: <20210709131654.967840668@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit a9a7504d9beaf395481faa91e70e2fd08f7a3dde ]

Running certain tests with a DEBUG_VM kernel would crash within hours,
on the total_mapcount BUG() in split_huge_page_to_list(), while trying
to free up some memory by punching a hole in a shmem huge page: split's
try_to_unmap() was unable to find all the mappings of the page (which,
on a !DEBUG_VM kernel, would then keep the huge page pinned in memory).

Crash dumps showed two tail pages of a shmem huge page remained mapped
by pte: ptes in a non-huge-aligned vma of a gVisor process, at the end
of a long unmapped range; and no page table had yet been allocated for
the head of the huge page to be mapped into.

Although designed to handle these odd misaligned huge-page-mapped-by-pte
cases, page_vma_mapped_walk() falls short by returning false prematurely
when !pmd_present or !pud_present or !p4d_present or !pgd_present: there
are cases when a huge page may span the boundary, with ptes present in
the next.

Restructure page_vma_mapped_walk() as a loop to continue in these cases,
while keeping its layout much as before.  Add a step_forward() helper to
advance pvmw->address across those boundaries: originally I tried to use
mm's standard p?d_addr_end() macros, but hit the same crash 512 times
less often: because of the way redundant levels are folded together, but
folded differently in different configurations, it was just too
difficult to use them correctly; and step_forward() is simpler anyway.

Link: https://lkml.kernel.org/r/fedb8632-1798-de42-f39e-873551d5bc81@google.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
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
 mm/page_vma_mapped.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 7239c38e99e2..b7a8009c1549 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -111,6 +111,13 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw)
 	return pfn_in_hpage(pvmw->page, pfn);
 }
 
+static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
+{
+	pvmw->address = (pvmw->address + size) & ~(size - 1);
+	if (!pvmw->address)
+		pvmw->address = ULONG_MAX;
+}
+
 /**
  * page_vma_mapped_walk - check if @pvmw->page is mapped in @pvmw->vma at
  * @pvmw->address
@@ -179,16 +186,22 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->pte)
 		goto next_pte;
 restart:
-	{
+	do {
 		pgd = pgd_offset(mm, pvmw->address);
-		if (!pgd_present(*pgd))
-			return false;
+		if (!pgd_present(*pgd)) {
+			step_forward(pvmw, PGDIR_SIZE);
+			continue;
+		}
 		p4d = p4d_offset(pgd, pvmw->address);
-		if (!p4d_present(*p4d))
-			return false;
+		if (!p4d_present(*p4d)) {
+			step_forward(pvmw, P4D_SIZE);
+			continue;
+		}
 		pud = pud_offset(p4d, pvmw->address);
-		if (!pud_present(*pud))
-			return false;
+		if (!pud_present(*pud)) {
+			step_forward(pvmw, PUD_SIZE);
+			continue;
+		}
 
 		pvmw->pmd = pmd_offset(pud, pvmw->address);
 		/*
@@ -235,7 +248,8 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
 				spin_unlock(ptl);
 			}
-			return false;
+			step_forward(pvmw, PMD_SIZE);
+			continue;
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
@@ -265,7 +279,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_lock(pvmw->ptl);
 		}
 		goto this_pte;
-	}
+	} while (pvmw->address < end);
+
+	return false;
 }
 
 /**
-- 
2.30.2



