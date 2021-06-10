Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF223A36FD
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFJW1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhFJW1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31030613DE;
        Thu, 10 Jun 2021 22:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363901;
        bh=85ZXu5gscZ3VTDGK7qsTlNIYFxPwB6uDQccahFU1xJ0=;
        h=Date:From:To:Subject:From;
        b=NvVxIYL2SBa1DsUG2LL9UPczOiTsdD8rBAXKyNtmPC263rOCQ96UScEDG5jWlhu7v
         d0Kay3XtnBMZBNKV5kFnGslU6FQ0RiEXPeMHvWvweLpVyQrYFDyeN5Vsu5S3DiW0nY
         7ti4DR5urYQ+xp8pQfeBFM5flp0xqkN6u+YvnOBU=
Date:   Thu, 10 Jun 2021 15:25:00 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        wangyugui@e16-tech.com, willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch added to
 -mm tree
Message-ID: <20210610222500.QDhA726bW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
has been added to the -mm tree.  Its filename is
     mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()

There is a race between THP unmapping and truncation, when truncate sees
pmd_none() and skips the entry, after munmap's zap_huge_pmd() cleared it,
but before its page_remove_rmap() gets to decrement compound_mapcount:
generating false "BUG: Bad page cache" reports that the page is still
mapped when deleted.  This commit fixes that, but not in the way I hoped.

The first attempt used try_to_unmap(page, TTU_SYNC|TTU_IGNORE_MLOCK)
instead of unmap_mapping_range() in truncate_cleanup_page(): it has often
been an annoyance that we usually call unmap_mapping_range() with no pages
locked, but there apply it to a single locked page.  try_to_unmap() looks
more suitable for a single locked page.

However, try_to_unmap_one() contains a VM_BUG_ON_PAGE(!pvmw.pte,page): it
is used to insert THP migration entries, but not used to unmap THPs.  Copy
zap_huge_pmd() and add THP handling now?  Perhaps, but their TLB needs are
different, I'm too ignorant of the DAX cases, and couldn't decide how far
to go for anon+swap.  Set that aside.

The second attempt took a different tack: make no change in truncate.c,
but modify zap_huge_pmd() to insert an invalidated huge pmd instead of
clearing it initially, then pmd_clear() between page_remove_rmap() and
unlocking at the end.  Nice.  But powerpc blows that approach out of the
water, with its serialize_against_pte_lookup(), and interesting pgtable
usage.  It would need serious help to get working on powerpc (with a minor
optimization issue on s390 too).  Set that aside.

Just add an "if (page_mapped(page)) synchronize_rcu();" or other such
delay, after unmapping in truncate_cleanup_page()?  Perhaps, but though
that's likely to reduce or eliminate the number of incidents, it would
give less assurance of whether we had identified the problem correctly.

This successful iteration introduces "unmap_mapping_page(page)" instead of
try_to_unmap(), and goes the usual unmap_mapping_range_tree() route, with
an addition to details.  Then zap_pmd_range() watches for this case, and
does spin_unlock(pmd_lock) if so - just like page_vma_mapped_walk() now
does in the PVMW_SYNC case.  Not pretty, but safe.

Note that unmap_mapping_page() is doing a VM_BUG_ON(!PageLocked) to assert
its interface; but currently that's only used to make sure that
page->mapping is stable, and zap_pmd_range() doesn't care if the page is
locked or not.  Along these lines, in invalidate_inode_pages2_range() move
the initial unmap_mapping_range() out from under page lock, before then
calling unmap_mapping_page() under page lock if still mapped.

Link: https://lkml.kernel.org/r/a2a4a148-cdd8-942c-4ef8-51b77f643dbe@google.com
Fixes: fc127da085c2 ("truncate: handle file thp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/memory.c        |   41 +++++++++++++++++++++++++++++++++++++++++
 mm/truncate.c      |   43 +++++++++++++++++++------------------------
 3 files changed, 63 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page
+++ a/include/linux/mm.h
@@ -1719,6 +1719,7 @@ struct zap_details {
 	struct address_space *check_mapping;	/* Check page->mapping if set */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
+	struct page *single_page;		/* Locked page to be unmapped */
 };
 
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
@@ -1766,6 +1767,7 @@ extern vm_fault_t handle_mm_fault(struct
 extern int fixup_user_fault(struct mm_struct *mm,
 			    unsigned long address, unsigned int fault_flags,
 			    bool *unlocked);
+void unmap_mapping_page(struct page *page);
 void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows);
 void unmap_mapping_range(struct address_space *mapping,
@@ -1786,6 +1788,7 @@ static inline int fixup_user_fault(struc
 	BUG();
 	return -EFAULT;
 }
+static inline void unmap_mapping_page(struct page *page) { }
 static inline void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows) { }
 static inline void unmap_mapping_range(struct address_space *mapping,
--- a/mm/memory.c~mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page
+++ a/mm/memory.c
@@ -1361,7 +1361,18 @@ static inline unsigned long zap_pmd_rang
 			else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
 			/* fall through */
+		} else if (details && details->single_page &&
+			   PageTransCompound(details->single_page) &&
+			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
+			spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
+			/*
+			 * Take and drop THP pmd lock so that we cannot return
+			 * prematurely, while zap_huge_pmd() has cleared *pmd,
+			 * but not yet decremented compound_mapcount().
+			 */
+			spin_unlock(ptl);
 		}
+
 		/*
 		 * Here there can be other concurrent MADV_DONTNEED or
 		 * trans huge page faults running, and if the pmd is
@@ -3237,6 +3248,36 @@ static inline void unmap_mapping_range_t
 }
 
 /**
+ * unmap_mapping_page() - Unmap single page from processes.
+ * @page: The locked page to be unmapped.
+ *
+ * Unmap this page from any userspace process which still has it mmaped.
+ * Typically, for efficiency, the range of nearby pages has already been
+ * unmapped by unmap_mapping_pages() or unmap_mapping_range().  But once
+ * truncation or invalidation holds the lock on a page, it may find that
+ * the page has been remapped again: and then uses unmap_mapping_page()
+ * to unmap it finally.
+ */
+void unmap_mapping_page(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct zap_details details = { };
+
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(PageTail(page));
+
+	details.check_mapping = mapping;
+	details.first_index = page->index;
+	details.last_index = page->index + thp_nr_pages(page) - 1;
+	details.single_page = page;
+
+	i_mmap_lock_write(mapping);
+	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+		unmap_mapping_range_tree(&mapping->i_mmap, &details);
+	i_mmap_unlock_write(mapping);
+}
+
+/**
  * unmap_mapping_pages() - Unmap pages from processes.
  * @mapping: The address space containing pages to be unmapped.
  * @start: Index of first page to be unmapped.
--- a/mm/truncate.c~mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page
+++ a/mm/truncate.c
@@ -167,13 +167,10 @@ void do_invalidatepage(struct page *page
  * its lock, b) when a concurrent invalidate_mapping_pages got there first and
  * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
  */
-static void
-truncate_cleanup_page(struct address_space *mapping, struct page *page)
+static void truncate_cleanup_page(struct page *page)
 {
-	if (page_mapped(page)) {
-		unsigned int nr = thp_nr_pages(page);
-		unmap_mapping_pages(mapping, page->index, nr, false);
-	}
+	if (page_mapped(page))
+		unmap_mapping_page(page);
 
 	if (page_has_private(page))
 		do_invalidatepage(page, 0, thp_size(page));
@@ -218,7 +215,7 @@ int truncate_inode_page(struct address_s
 	if (page->mapping != mapping)
 		return -EIO;
 
-	truncate_cleanup_page(mapping, page);
+	truncate_cleanup_page(page);
 	delete_from_page_cache(page);
 	return 0;
 }
@@ -325,7 +322,7 @@ void truncate_inode_pages_range(struct a
 		index = indices[pagevec_count(&pvec) - 1] + 1;
 		truncate_exceptional_pvec_entries(mapping, &pvec, indices);
 		for (i = 0; i < pagevec_count(&pvec); i++)
-			truncate_cleanup_page(mapping, pvec.pages[i]);
+			truncate_cleanup_page(pvec.pages[i]);
 		delete_from_page_cache_batch(mapping, &pvec);
 		for (i = 0; i < pagevec_count(&pvec); i++)
 			unlock_page(pvec.pages[i]);
@@ -639,6 +636,16 @@ int invalidate_inode_pages2_range(struct
 				continue;
 			}
 
+			if (!did_range_unmap && page_mapped(page)) {
+				/*
+				 * If page is mapped, before taking its lock,
+				 * zap the rest of the file in one hit.
+				 */
+				unmap_mapping_pages(mapping, index,
+						(1 + end - index), false);
+				did_range_unmap = 1;
+			}
+
 			lock_page(page);
 			WARN_ON(page_to_index(page) != index);
 			if (page->mapping != mapping) {
@@ -646,23 +653,11 @@ int invalidate_inode_pages2_range(struct
 				continue;
 			}
 			wait_on_page_writeback(page);
-			if (page_mapped(page)) {
-				if (!did_range_unmap) {
-					/*
-					 * Zap the rest of the file in one hit.
-					 */
-					unmap_mapping_pages(mapping, index,
-						(1 + end - index), false);
-					did_range_unmap = 1;
-				} else {
-					/*
-					 * Just zap this page
-					 */
-					unmap_mapping_pages(mapping, index,
-								1, false);
-				}
-			}
+
+			if (page_mapped(page))
+				unmap_mapping_page(page);
 			BUG_ON(page_mapped(page));
+
 			ret2 = do_launder_page(mapping, page);
 			if (ret2 == 0) {
 				if (!invalidate_complete_page2(mapping, page))
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch
mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch
mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch
mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch
mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch
mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmd_read_atomic.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

