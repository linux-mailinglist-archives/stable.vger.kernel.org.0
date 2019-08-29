Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284FAA24AA
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfH2SYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbfH2SQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1415923404;
        Thu, 29 Aug 2019 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102576;
        bh=xVe0SO2iGzckCruoLW2k9E9IGcjFTpDGhy4yyzlE/XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1XkF2vLtqt1hVdrVrYx2V/YcotWXlPn83DJ+uxyZmedyU8oAwUWxhQC1hp/eOKC3
         wBUTWr1vXzaCQ+WxQ+Cz1KzBzRDtkfmoU6x31GV/P659In2WjG4Altal7QlUoQ8Axb
         FzOWLr7KTixc69Fjka9aNN7UBmH6KaTYDyAx8G3M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Bill O'Donnell <billodo@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/45] vfs: fix page locking deadlocks when deduping files
Date:   Thu, 29 Aug 2019 14:15:22 -0400
Message-Id: <20190829181547.8280-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit edc58dd0123b552453a74369bd0c8d890b497b4b ]

When dedupe wants to use the page cache to compare parts of two files
for dedupe, we must be very careful to handle locking correctly.  The
current code doesn't do this.  It must lock and unlock the page only
once if the two pages are the same, since the overlapping range check
doesn't catch this when blocksize < pagesize.  If the pages are distinct
but from the same file, we must observe page locking order and lock them
in order of increasing offset to avoid clashing with writeback locking.

Fixes: 876bec6f9bbfcb3 ("vfs: refactor clone/dedupe_file_range common functions")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 85fd7a8ee29eb..5fb5ee5b8cd70 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1888,10 +1888,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(vfs_clone_file_range);
 
-/*
- * Read a page's worth of file data into the page cache.  Return the page
- * locked.
- */
+/* Read a page's worth of file data into the page cache. */
 static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
 {
 	struct address_space *mapping;
@@ -1907,10 +1904,32 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
 		put_page(page);
 		return ERR_PTR(-EIO);
 	}
-	lock_page(page);
 	return page;
 }
 
+/*
+ * Lock two pages, ensuring that we lock in offset order if the pages are from
+ * the same file.
+ */
+static void vfs_lock_two_pages(struct page *page1, struct page *page2)
+{
+	/* Always lock in order of increasing index. */
+	if (page1->index > page2->index)
+		swap(page1, page2);
+
+	lock_page(page1);
+	if (page1 != page2)
+		lock_page(page2);
+}
+
+/* Unlock two pages, being careful not to unlock the same page twice. */
+static void vfs_unlock_two_pages(struct page *page1, struct page *page2)
+{
+	unlock_page(page1);
+	if (page1 != page2)
+		unlock_page(page2);
+}
+
 /*
  * Compare extents of two files to see if they are the same.
  * Caller must have locked both inodes to prevent write races.
@@ -1948,10 +1967,24 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		dest_page = vfs_dedupe_get_page(dest, destoff);
 		if (IS_ERR(dest_page)) {
 			error = PTR_ERR(dest_page);
-			unlock_page(src_page);
 			put_page(src_page);
 			goto out_error;
 		}
+
+		vfs_lock_two_pages(src_page, dest_page);
+
+		/*
+		 * Now that we've locked both pages, make sure they're still
+		 * mapped to the file data we're interested in.  If not,
+		 * someone is invalidating pages on us and we lose.
+		 */
+		if (!PageUptodate(src_page) || !PageUptodate(dest_page) ||
+		    src_page->mapping != src->i_mapping ||
+		    dest_page->mapping != dest->i_mapping) {
+			same = false;
+			goto unlock;
+		}
+
 		src_addr = kmap_atomic(src_page);
 		dest_addr = kmap_atomic(dest_page);
 
@@ -1963,8 +1996,8 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 
 		kunmap_atomic(dest_addr);
 		kunmap_atomic(src_addr);
-		unlock_page(dest_page);
-		unlock_page(src_page);
+unlock:
+		vfs_unlock_two_pages(src_page, dest_page);
 		put_page(dest_page);
 		put_page(src_page);
 
-- 
2.20.1

