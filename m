Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A3F38A560
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhETKQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236154AbhETKO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81AC661969;
        Thu, 20 May 2021 09:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503883;
        bh=ilqyrJZLWX5vtcWYSj8gZZF9qtB2CvUPCXl+ANBzMw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8/wfNRKbybV/fmgVzyc/h8jS0zkwwN3tvXHDpJ2pR5hQTY4APoBciEiJSwez4cVo
         QwpZ1QUmJupRkGjuJX/JC2bek4aZ74WinvcvJlM49nrzLFgXpSu3ZfwrOrKm9Ph3xe
         28dbEAfH98tarmI0v0zcjiQb6m2VTZh50opf8zjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 4.19 422/425] iomap: fix sub-page uptodate handling
Date:   Thu, 20 May 2021 11:23:11 +0200
Message-Id: <20210520092145.266430111@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 1cea335d1db1ce6ab71b3d2f94a807112b738a0f upstream.

bio completions can race when a page spans more than one file system
block.  Add a spinlock to synchronize marking the page uptodate.

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap.c            |   34 ++++++++++++++++++++++++----------
 include/linux/iomap.h |    1 +
 2 files changed, 25 insertions(+), 10 deletions(-)

--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -116,6 +116,7 @@ iomap_page_create(struct inode *inode, s
 	iop = kmalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
 	atomic_set(&iop->read_count, 0);
 	atomic_set(&iop->write_count, 0);
+	spin_lock_init(&iop->uptodate_lock);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
 
 	/*
@@ -204,25 +205,38 @@ iomap_adjust_read_range(struct inode *in
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
 
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -108,6 +108,7 @@ struct iomap_ops {
 struct iomap_page {
 	atomic_t		read_count;
 	atomic_t		write_count;
+	spinlock_t		uptodate_lock;
 	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
 };
 


