Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A534B65779
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfGKM6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 08:58:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:34520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725971AbfGKM6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 08:58:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D8C6B12A;
        Thu, 11 Jul 2019 12:58:45 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3734F1E43CB; Thu, 11 Jul 2019 14:58:44 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-mm@kvack.org>
Cc:     mgorman@suse.de, mhocko@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH RFC] mm: migrate: Fix races of __find_get_block() and page migration
Date:   Thu, 11 Jul 2019 14:58:38 +0200
Message-Id: <20190711125838.32565-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

buffer_migrate_page_norefs() can race with bh users in a following way:

CPU1					CPU2
buffer_migrate_page_norefs()
  buffer_migrate_lock_buffers()
  checks bh refs
  spin_unlock(&mapping->private_lock)
					__find_get_block()
					  spin_lock(&mapping->private_lock)
					  grab bh ref
					  spin_unlock(&mapping->private_lock)
  move page				  do bh work

This can result in various issues like lost updates to buffers (i.e.
metadata corruption) or use after free issues for the old page.

Closing this race window is relatively difficult. We could hold
mapping->private_lock in buffer_migrate_page_norefs() until we are
finished with migrating the page but the lock hold times would be rather
big. So let's revert to a more careful variant of page migration requiring
eviction of buffers on migrated page. This is effectively
fallback_migrate_page() that additionally invalidates bh LRUs in case
try_to_free_buffers() failed.

CC: stable@vger.kernel.org
Fixes: 89cb0888ca14 "mm: migrate: provide buffer_migrate_page_norefs()"
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/migrate.c | 161 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 78 insertions(+), 83 deletions(-)

I've lightly tested this with config-workload-thpfioscale which didn't
show any obvious issue but the patch probably needs more testing (especially
to verify that memory unplug is still able to succeed in reasonable time).
That's why this is RFC.

diff --git a/mm/migrate.c b/mm/migrate.c
index e9594bc0d406..893698d37d50 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -697,6 +697,47 @@ int migrate_page(struct address_space *mapping,
 }
 EXPORT_SYMBOL(migrate_page);
 
+/*
+ * Writeback a page to clean the dirty state
+ */
+static int writeout(struct address_space *mapping, struct page *page)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.nr_to_write = 1,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.for_reclaim = 1
+	};
+	int rc;
+
+	if (!mapping->a_ops->writepage)
+		/* No write method for the address space */
+		return -EINVAL;
+
+	if (!clear_page_dirty_for_io(page))
+		/* Someone else already triggered a write */
+		return -EAGAIN;
+
+	/*
+	 * A dirty page may imply that the underlying filesystem has
+	 * the page on some queue. So the page must be clean for
+	 * migration. Writeout may mean we loose the lock and the
+	 * page state is no longer what we checked for earlier.
+	 * At this point we know that the migration attempt cannot
+	 * be successful.
+	 */
+	remove_migration_ptes(page, page, false);
+
+	rc = mapping->a_ops->writepage(page, &wbc);
+
+	if (rc != AOP_WRITEPAGE_ACTIVATE)
+		/* unlocked. Relock */
+		lock_page(page);
+
+	return (rc < 0) ? -EIO : -EAGAIN;
+}
+
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
 static bool buffer_migrate_lock_buffers(struct buffer_head *head,
@@ -736,9 +777,14 @@ static bool buffer_migrate_lock_buffers(struct buffer_head *head,
 	return true;
 }
 
-static int __buffer_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode,
-		bool check_refs)
+/*
+ * Migration function for pages with buffers. This function can only be used
+ * if the underlying filesystem guarantees that no other references to "page"
+ * exist. For example attached buffer heads are accessed only under page lock.
+ */
+int buffer_migrate_page(struct address_space *mapping,
+			struct page *newpage, struct page *page,
+			enum migrate_mode mode)
 {
 	struct buffer_head *bh, *head;
 	int rc;
@@ -756,33 +802,6 @@ static int __buffer_migrate_page(struct address_space *mapping,
 	if (!buffer_migrate_lock_buffers(head, mode))
 		return -EAGAIN;
 
-	if (check_refs) {
-		bool busy;
-		bool invalidated = false;
-
-recheck_buffers:
-		busy = false;
-		spin_lock(&mapping->private_lock);
-		bh = head;
-		do {
-			if (atomic_read(&bh->b_count)) {
-				busy = true;
-				break;
-			}
-			bh = bh->b_this_page;
-		} while (bh != head);
-		spin_unlock(&mapping->private_lock);
-		if (busy) {
-			if (invalidated) {
-				rc = -EAGAIN;
-				goto unlock_buffers;
-			}
-			invalidate_bh_lrus();
-			invalidated = true;
-			goto recheck_buffers;
-		}
-	}
-
 	rc = migrate_page_move_mapping(mapping, newpage, page, mode, 0);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		goto unlock_buffers;
@@ -818,72 +837,48 @@ static int __buffer_migrate_page(struct address_space *mapping,
 
 	return rc;
 }
-
-/*
- * Migration function for pages with buffers. This function can only be used
- * if the underlying filesystem guarantees that no other references to "page"
- * exist. For example attached buffer heads are accessed only under page lock.
- */
-int buffer_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
-{
-	return __buffer_migrate_page(mapping, newpage, page, mode, false);
-}
 EXPORT_SYMBOL(buffer_migrate_page);
 
 /*
- * Same as above except that this variant is more careful and checks that there
- * are also no buffer head references. This function is the right one for
- * mappings where buffer heads are directly looked up and referenced (such as
- * block device mappings).
+ * Same as above except that this variant is more careful.  This function is
+ * the right one for mappings where buffer heads are directly looked up and
+ * referenced (such as block device mappings).
  */
 int buffer_migrate_page_norefs(struct address_space *mapping,
 		struct page *newpage, struct page *page, enum migrate_mode mode)
 {
-	return __buffer_migrate_page(mapping, newpage, page, mode, true);
-}
-#endif
-
-/*
- * Writeback a page to clean the dirty state
- */
-static int writeout(struct address_space *mapping, struct page *page)
-{
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = 1,
-		.range_start = 0,
-		.range_end = LLONG_MAX,
-		.for_reclaim = 1
-	};
-	int rc;
-
-	if (!mapping->a_ops->writepage)
-		/* No write method for the address space */
-		return -EINVAL;
+	bool invalidated = false;
 
-	if (!clear_page_dirty_for_io(page))
-		/* Someone else already triggered a write */
-		return -EAGAIN;
+	if (PageDirty(page)) {
+		/* Only writeback pages in full synchronous migration */
+		switch (mode) {
+		case MIGRATE_SYNC:
+		case MIGRATE_SYNC_NO_COPY:
+			break;
+		default:
+			return -EBUSY;
+		}
+		return writeout(mapping, page);
+	}
 
+retry:
 	/*
-	 * A dirty page may imply that the underlying filesystem has
-	 * the page on some queue. So the page must be clean for
-	 * migration. Writeout may mean we loose the lock and the
-	 * page state is no longer what we checked for earlier.
-	 * At this point we know that the migration attempt cannot
-	 * be successful.
+	 * Buffers may be managed in a filesystem specific way.
+	 * We must have no buffers or drop them.
 	 */
-	remove_migration_ptes(page, page, false);
-
-	rc = mapping->a_ops->writepage(page, &wbc);
-
-	if (rc != AOP_WRITEPAGE_ACTIVATE)
-		/* unlocked. Relock */
-		lock_page(page);
+	if (page_has_private(page) &&
+	    !try_to_release_page(page, GFP_KERNEL)) {
+		if (!invalidated) {
+			invalidate_bh_lrus();
+			invalidated = true;
+			goto retry;
+		}
+		return mode == MIGRATE_SYNC ? -EAGAIN : -EBUSY;
+	}
 
-	return (rc < 0) ? -EIO : -EAGAIN;
+	return migrate_page(mapping, newpage, page, mode);
 }
+#endif
 
 /*
  * Default handling if a filesystem does not provide a migration function.
-- 
2.16.4

