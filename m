Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC86383A9B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbhEQQ7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239927AbhEQQ7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:59:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A8DC061756;
        Mon, 17 May 2021 09:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+5+7LJaWIzTfeOtF/JzDOM8+78UhbcEx6wP6BldceUY=; b=XpLhn3+UagTm7PTnJ9LvRCJ89A
        FNMIq820S+wBvFTz05cdpWRYI41LReLo9oYOmer+NJiuSE7Ieh+EEb8duRYf92pBZFxef3K7/sCWi
        WYn+rBpWuIYJWdsaM7XyrVMd02c1W/Qh2lS5vh7C9RVSRwXzcG6VVrFoGFAQxQ0Yw0a2KkxAAUJUy
        csn/k4HjVGi7wtCB8JgRI7L037PP9WY29sdsMKUl+EaweEhQVTveefTJTGo4ctIkI/oJLbIs3ILab
        FHk47CC05uNVTyHqSXbCx4odrr1TzxxiY3YPpOO/5g2ch/TVvntq1zSxtmpz2LjhI71/b3Vakr6yD
        mNqEYnLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ligYd-00DDY8-Vv; Mon, 17 May 2021 16:57:37 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jan Stancek <jstancek@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 4.19] iomap: fix sub-page uptodate handling
Date:   Mon, 17 May 2021 17:57:24 +0100
Message-Id: <20210517165724.3150255-1-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 1cea335d1db1ce6ab71b3d2f94a807112b738a0f upstream

bio completions can race when a page spans more than one file system
block.  Add a spinlock to synchronize marking the page uptodate.

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap.c            | 34 ++++++++++++++++++++++++----------
 include/linux/iomap.h |  1 +
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 03edf62633dc..ac7b2152c3ad 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -116,6 +116,7 @@ iomap_page_create(struct inode *inode, struct page *page)
 	iop = kmalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
 	atomic_set(&iop->read_count, 0);
 	atomic_set(&iop->write_count, 0);
+	spin_lock_init(&iop->uptodate_lock);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
 
 	/*
@@ -204,25 +205,38 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 }
 
 static void
-iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
+iomap_iop_set_range_uptodate(struct page *page, unsigned off, unsigned len)
 {
 	struct iomap_page *iop = to_iomap_page(page);
 	struct inode *inode = page->mapping->host;
 	unsigned first = off >> inode->i_blkbits;
 	unsigned last = (off + len - 1) >> inode->i_blkbits;
-	unsigned int i;
 	bool uptodate = true;
+	unsigned long flags;
+	unsigned int i;
 
-	if (iop) {
-		for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
-			if (i >= first && i <= last)
-				set_bit(i, iop->uptodate);
-			else if (!test_bit(i, iop->uptodate))
-				uptodate = false;
-		}
+	spin_lock_irqsave(&iop->uptodate_lock, flags);
+	for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
+		if (i >= first && i <= last)
+			set_bit(i, iop->uptodate);
+		else if (!test_bit(i, iop->uptodate))
+			uptodate = false;
 	}
 
-	if (uptodate && !PageError(page))
+	if (uptodate)
+		SetPageUptodate(page);
+	spin_unlock_irqrestore(&iop->uptodate_lock, flags);
+}
+
+static void
+iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
+{
+	if (PageError(page))
+		return;
+
+	if (page_has_private(page))
+		iomap_iop_set_range_uptodate(page, off, len);
+	else
 		SetPageUptodate(page);
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3555d54bf79a..e93ecacb5eaf 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -108,6 +108,7 @@ struct iomap_ops {
 struct iomap_page {
 	atomic_t		read_count;
 	atomic_t		write_count;
+	spinlock_t		uptodate_lock;
 	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
 };
 
-- 
2.30.2

