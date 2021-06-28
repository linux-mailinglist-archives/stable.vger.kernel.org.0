Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120EE3B61E6
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhF1OkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhF1Ohc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD7F61CB8;
        Mon, 28 Jun 2021 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890658;
        bh=AZwZVaPR8GXuQ1RC23CGlyhzIthTTDSAwUV0OqmorDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBFNTqxc9iCI9CMRyPb+sEeDWdW6zZ3aZOSJoVqhd/kcROc4CGPFLU2qJRNjcJCmY
         /jSgH9LCoCFbkiaKjqauQc4jRy67KVkSqEevmFlBWssgFJXTsS1Tb5Ib9XEek8/Xb5
         dvd1fMnWIEKsmzl6BOg5uyi7Ay7A8lS1aISlI2525W03ZDwHWQv9kxo8+WQXc73/ti
         wSYfSM/f4dVLx0o+8VHit3r5+CEg4V8tLfLZuan7EMSNwsy26ZSPvjgtik8WCRPcDR
         ZT1vWTvBjH1P62PfcTSBTJcMxjBzzYctqhXHPI1JGPqwD8vOwJD6NypHD2oK5IrknV
         SldH81fq7T4YA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>, Jan Kara <jack@suse.cz>,
        Jue Wang <juew@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 52/71] mm/thp: fix vma_address() if virtual address below file offset
Date:   Mon, 28 Jun 2021 10:29:45 -0400
Message-Id: <20210628143004.32596-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 494334e43c16d63b878536a26505397fce6ff3a2 ]

Running certain tests with a DEBUG_VM kernel would crash within hours,
on the total_mapcount BUG() in split_huge_page_to_list(), while trying
to free up some memory by punching a hole in a shmem huge page: split's
try_to_unmap() was unable to find all the mappings of the page (which,
on a !DEBUG_VM kernel, would then keep the huge page pinned in memory).

When that BUG() was changed to a WARN(), it would later crash on the
VM_BUG_ON_VMA(end < vma->vm_start || start >= vma->vm_end, vma) in
mm/internal.h:vma_address(), used by rmap_walk_file() for
try_to_unmap().

vma_address() is usually correct, but there's a wraparound case when the
vm_start address is unusually low, but vm_pgoff not so low:
vma_address() chooses max(start, vma->vm_start), but that decides on the
wrong address, because start has become almost ULONG_MAX.

Rewrite vma_address() to be more careful about vm_pgoff; move the
VM_BUG_ON_VMA() out of it, returning -EFAULT for errors, so that it can
be safely used from page_mapped_in_vma() and page_address_in_vma() too.

Add vma_address_end() to apply similar care to end address calculation,
in page_vma_mapped_walk() and page_mkclean_one() and try_to_unmap_one();
though it raises a question of whether callers would do better to supply
pvmw->end to page_vma_mapped_walk() - I chose not, for a smaller patch.

An irritation is that their apparent generality breaks down on KSM
pages, which cannot be located by the page->index that page_to_pgoff()
uses: as commit 4b0ece6fa016 ("mm: migrate: fix remove_migration_pte()
for ksm pages") once discovered.  I dithered over the best thing to do
about that, and have ended up with a VM_BUG_ON_PAGE(PageKsm) in both
vma_address() and vma_address_end(); though the only place in danger of
using it on them was try_to_unmap_one().

Sidenote: vma_address() and vma_address_end() now use compound_nr() on a
head page, instead of thp_size(): to make the right calculation on a
hugetlbfs page, whether or not THPs are configured.  try_to_unmap() is
used on hugetlbfs pages, but perhaps the wrong calculation never
mattered.

Link: https://lkml.kernel.org/r/caf1c1a3-7cfb-7f8f-1beb-ba816e932825@google.com
Fixes: a8fa41ad2f6f ("mm, rmap: check all VMAs that PTE-mapped THP can be part of")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Note on stable backport: fixed up conflicts on intervening thp_size().

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/internal.h        | 53 ++++++++++++++++++++++++++++++++------------
 mm/page_vma_mapped.c | 16 +++++--------
 mm/rmap.c            | 16 ++++++-------
 3 files changed, 53 insertions(+), 32 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 7dd7fbb577a9..cf382549dd70 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -339,27 +339,52 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
- * At what user virtual address is page expected in @vma?
+ * At what user virtual address is page expected in vma?
+ * Returns -EFAULT if all of the page is outside the range of vma.
+ * If page is a compound head, the entire compound page is considered.
  */
 static inline unsigned long
-__vma_address(struct page *page, struct vm_area_struct *vma)
+vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page_to_pgoff(page);
-	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	pgoff_t pgoff;
+	unsigned long address;
+
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	pgoff = page_to_pgoff(page);
+	if (pgoff >= vma->vm_pgoff) {
+		address = vma->vm_start +
+			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		/* Check for address beyond vma (or wrapped through 0?) */
+		if (address < vma->vm_start || address >= vma->vm_end)
+			address = -EFAULT;
+	} else if (PageHead(page) &&
+		   pgoff + compound_nr(page) - 1 >= vma->vm_pgoff) {
+		/* Test above avoids possibility of wrap to 0 on 32-bit */
+		address = vma->vm_start;
+	} else {
+		address = -EFAULT;
+	}
+	return address;
 }
 
+/*
+ * Then at what user virtual address will none of the page be found in vma?
+ * Assumes that vma_address() already returned a good starting address.
+ * If page is a compound head, the entire compound page is considered.
+ */
 static inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
+vma_address_end(struct page *page, struct vm_area_struct *vma)
 {
-	unsigned long start, end;
-
-	start = __vma_address(page, vma);
-	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
-
-	/* page should be within @vma mapping range */
-	VM_BUG_ON_VMA(end < vma->vm_start || start >= vma->vm_end, vma);
-
-	return max(start, vma->vm_start);
+	pgoff_t pgoff;
+	unsigned long address;
+
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	pgoff = page_to_pgoff(page) + compound_nr(page);
+	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	/* Check for address beyond vma (or wrapped through 0?) */
+	if (address < vma->vm_start || address > vma->vm_end)
+		address = vma->vm_end;
+	return address;
 }
 
 static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 5a2a371a2c98..d4e0440fef2a 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -223,18 +223,18 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	if (!map_pte(pvmw))
 		goto next_pte;
 	while (1) {
+		unsigned long end;
+
 		if (check_pte(pvmw))
 			return true;
 next_pte:
 		/* Seek to next pte only makes sense for THP */
 		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
 			return not_found(pvmw);
+		end = vma_address_end(pvmw->page, pvmw->vma);
 		do {
 			pvmw->address += PAGE_SIZE;
-			if (pvmw->address >= pvmw->vma->vm_end ||
-			    pvmw->address >=
-					__vma_address(pvmw->page, pvmw->vma) +
-					hpage_nr_pages(pvmw->page) * PAGE_SIZE)
+			if (pvmw->address >= end)
 				return not_found(pvmw);
 			/* Did we cross page table boundary? */
 			if (pvmw->address % PMD_SIZE == 0) {
@@ -272,14 +272,10 @@ int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 		.vma = vma,
 		.flags = PVMW_SYNC,
 	};
-	unsigned long start, end;
-
-	start = __vma_address(page, vma);
-	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
 
-	if (unlikely(end < vma->vm_start || start >= vma->vm_end))
+	pvmw.address = vma_address(page, vma);
+	if (pvmw.address == -EFAULT)
 		return 0;
-	pvmw.address = max(start, vma->vm_start);
 	if (!page_vma_mapped_walk(&pvmw))
 		return 0;
 	page_vma_mapped_walk_done(&pvmw);
diff --git a/mm/rmap.c b/mm/rmap.c
index c61a6384d950..dfadc8364aa9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -687,7 +687,6 @@ static bool should_defer_flush(struct mm_struct *mm, enum ttu_flags flags)
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
-	unsigned long address;
 	if (PageAnon(page)) {
 		struct anon_vma *page__anon_vma = page_anon_vma(page);
 		/*
@@ -702,10 +701,8 @@ unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 			return -EFAULT;
 	} else
 		return -EFAULT;
-	address = __vma_address(page, vma);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		return -EFAULT;
-	return address;
+
+	return vma_address(page, vma);
 }
 
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
@@ -899,7 +896,7 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
 				0, vma, vma->vm_mm, address,
-				min(vma->vm_end, address + page_size(page)));
+				vma_address_end(page, vma));
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -1383,9 +1380,10 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	 * Note that the page can not be free in this function as call of
 	 * try_to_unmap() must hold a reference on the page.
 	 */
+	range.end = PageKsm(page) ?
+			address + PAGE_SIZE : vma_address_end(page, vma);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				address,
-				min(vma->vm_end, address + page_size(page)));
+				address, range.end);
 	if (PageHuge(page)) {
 		/*
 		 * If sharing is possible, start and end will be adjusted
@@ -1843,6 +1841,7 @@ static void rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc,
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 
+		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
@@ -1897,6 +1896,7 @@ static void rmap_walk_file(struct page *page, struct rmap_walk_control *rwc,
 			pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(page, vma);
 
+		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
-- 
2.30.2

