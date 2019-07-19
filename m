Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649246D7AF
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 02:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfGSAMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 20:12:49 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:54514 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfGSAMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 20:12:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=bo.liu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TXEcbpw_1563495165;
Received: from localhost(mailfrom:bo.liu@linux.alibaba.com fp:SMTPD_---0TXEcbpw_1563495165)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Jul 2019 08:12:45 +0800
From:   Liu Bo <bo.liu@linux.alibaba.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peng Tao <tao.peng@linux.alibaba.com>
Subject: [PATCH] mm: fix livelock caused by iterating multi order entry
Date:   Fri, 19 Jul 2019 08:12:40 +0800
Message-Id: <1563495160-25647-1-git-send-email-bo.liu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The livelock can be triggerred in the following pattern,

	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
				min(end - index, (pgoff_t)PAGEVEC_SIZE),
				indices)) {
		...
		for (i = 0; i < pagevec_count(&pvec); i++) {
			index = indices[i];
			...
		}
		index++; /* BUG */
	}

multi order exceptional entry is not specially considered in
invalidate_inode_pages2_range() and it ended up with a livelock because
both index 0 and index 1 finds the same pmd, but this pmd is binded to
index 0, so index is set to 0 again.

This introduces a helper to take the pmd entry's length into account when
deciding the next index.

Note that there're other users of the above pattern which doesn't need to
fix,

- dax_layout_busy_page
It's been fixed in commit d7782145e1ad
("filesystem-dax: Fix dax_layout_busy_page() livelock")

- truncate_inode_pages_range
This won't loop forever since the exceptional entries are immediately
removed from radix tree after the search.

Fixes: 642261a ("dax: add struct iomap based DAX PMD support")
Cc: <stable@vger.kernel.org> since 4.9 to 4.19
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---

The problem is gone after commit f280bf092d48 ("page cache: Convert
find_get_entries to XArray"), but since xarray seems too new to backport
to 4.19, I made this fix based on radix tree implementation.

 fs/dax.c            | 19 +++++++++++++++++++
 include/linux/dax.h |  8 ++++++++
 mm/truncate.c       | 26 ++++++++++++++++++++++++--
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ac334bc..cd05337 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -764,6 +764,25 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 	return __dax_invalidate_mapping_entry(mapping, index, false);
 }
 
+pgoff_t dax_get_multi_order(struct address_space *mapping, pgoff_t index,
+			    void *entry)
+{
+	struct radix_tree_root *pages = &mapping->i_pages;
+	pgoff_t nr_pages = 1;
+
+	if (!dax_mapping(mapping))
+		return nr_pages;
+
+	xa_lock_irq(pages);
+	entry = get_unlocked_mapping_entry(mapping, index, NULL);
+	if (entry)
+		nr_pages = 1UL << dax_radix_order(entry);
+	put_unlocked_mapping_entry(mapping, index, entry);
+	xa_unlock_irq(pages);
+
+	return nr_pages;
+}
+
 static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		sector_t sector, size_t size, struct page *to,
 		unsigned long vaddr)
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a846184..f3c95c6 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -91,6 +91,8 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 struct page *dax_layout_busy_page(struct address_space *mapping);
 bool dax_lock_mapping_entry(struct page *page);
 void dax_unlock_mapping_entry(struct page *page);
+pgoff_t dax_get_multi_order(struct address_space *mapping, pgoff_t index,
+			    void *entry);
 #else
 static inline bool bdev_dax_supported(struct block_device *bdev,
 		int blocksize)
@@ -134,6 +136,12 @@ static inline bool dax_lock_mapping_entry(struct page *page)
 static inline void dax_unlock_mapping_entry(struct page *page)
 {
 }
+
+static inline pgoff_t dax_get_multi_order(struct address_space *mapping,
+					  pgoff_t index, void *entry)
+{
+	return 1;
+}
 #endif
 
 int dax_read_lock(void);
diff --git a/mm/truncate.c b/mm/truncate.c
index 71b65aa..835911f 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -557,6 +557,8 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
 			indices)) {
+		pgoff_t nr_pages = 1;
+
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
@@ -568,6 +570,15 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 			if (radix_tree_exceptional_entry(page)) {
 				invalidate_exceptional_entry(mapping, index,
 							     page);
+				/*
+				 * Account for multi-order entries at
+				 * the end of the pagevec.
+				 */
+				if (i < pagevec_count(&pvec) - 1)
+					continue;
+
+				nr_pages = dax_get_multi_order(mapping, index,
+							       page);
 				continue;
 			}
 
@@ -607,7 +618,7 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		cond_resched();
-		index++;
+		index += nr_pages;
 	}
 	return count;
 }
@@ -688,6 +699,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
 			indices)) {
+		pgoff_t nr_pages = 1;
+
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
@@ -700,6 +713,15 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 				if (!invalidate_exceptional_entry2(mapping,
 								   index, page))
 					ret = -EBUSY;
+				/*
+				 * Account for multi-order entries at
+				 * the end of the pagevec.
+				 */
+				if (i < pagevec_count(&pvec) - 1)
+					continue;
+
+				nr_pages = dax_get_multi_order(mapping, index,
+							       page);
 				continue;
 			}
 
@@ -739,7 +761,7 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		cond_resched();
-		index++;
+		index += nr_pages;
 	}
 	/*
 	 * For DAX we invalidate page tables after invalidating radix tree.  We
-- 
1.8.3.1

