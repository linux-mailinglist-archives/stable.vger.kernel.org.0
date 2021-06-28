Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EE63B6067
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhF1OYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233237AbhF1OXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D43360233;
        Mon, 28 Jun 2021 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890011;
        bh=5W1UdtrxxfiorrxYxTHvBYDv+oE4zYo8bwu+rZHQUz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnjwcehrWrogQxU6RfnCHebavog6l3KxHF7YZmZwJ+KZbQ8PTu+rBIm7RCQ0svZ+L
         1z+bCZXSiwclJq8LAvK+xbILMd+mGRx2pBYE/tiTUC2BUalFyAVEAljTClYVe++V5i
         QeYMXXUrEfhvQl8t6q9hiF/rplibshlEyam7U31//CBYoXKYU2qS0hSLf6sBdCcCNQ
         NxA2Z0eqPTCYEPmhz+HcM+afWLe6C4w0DYhmrmDWh1y9JpJ+Nwb2EfhZSrAgmUGkca
         TsYzA7DCnzZ8jSDDsILc8vwTqPRwo+YegrY17GmaUmrsE4UiKRMb3xWleHOLfKqNYU
         3r/nu/LZLOoCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 098/110] mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
Date:   Mon, 28 Jun 2021 10:18:16 -0400
Message-Id: <20210628141828.31757-99-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit a9a7504d9beaf395481faa91e70e2fd08f7a3dde upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b4c731ca2752..16f139f83ebf 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -116,6 +116,13 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw)
 	return pfn_is_match(pvmw->page, pfn);
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
@@ -183,16 +190,22 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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
@@ -239,7 +252,8 @@ restart:
 
 				spin_unlock(ptl);
 			}
-			return false;
+			step_forward(pvmw, PMD_SIZE);
+			continue;
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
@@ -269,7 +283,9 @@ next_pte:
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

