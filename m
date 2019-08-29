Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F56FA244C
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfH2SRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbfH2SRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78C5233FF;
        Thu, 29 Aug 2019 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102634;
        bh=QxZaXZ0zijJUWnGqXLJsdGGyfICNLhjFRpE5M0KDN0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9PWQ1lXTWfYFzYI0DkBas47B87ahSU+uQJGxjGaO2X1v7WLWUmyXdM8rJqd9seRl
         WtEyG0If35SfHgBQiE8+wCuxs+q0+rRRsSsmMrm5N+NA/imkcLOVfHCduAcVpdx+Cy
         BeIzOHHzOFABECU5K1czt4dJ8wKR8g40CrlAJqlw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Bill O'Donnell <billodo@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/27] vfs: fix page locking deadlocks when deduping files
Date:   Thu, 29 Aug 2019 14:16:40 -0400
Message-Id: <20190829181655.8741-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181655.8741-1-sashal@kernel.org>
References: <20190829181655.8741-1-sashal@kernel.org>
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
index d6f8bfb0f7942..38a8bcccf0dd0 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1882,10 +1882,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
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
@@ -1901,10 +1898,32 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
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
@@ -1942,10 +1961,24 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
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
 
@@ -1957,8 +1990,8 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 
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

