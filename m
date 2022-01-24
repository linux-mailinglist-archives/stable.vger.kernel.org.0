Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5BF4979CE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 08:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiAXHxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 02:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241902AbiAXHxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 02:53:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C52C06173D
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 23:53:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 748706111C
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 07:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365CAC340E1;
        Mon, 24 Jan 2022 07:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643010810;
        bh=9fvHuIVJ78Cj54c1/3cxvCCyBLl3WnhVWeveLr+HsD0=;
        h=Subject:To:Cc:From:Date:From;
        b=S5FDnjOATqMJlJBx0YqiMTadxk9AwffNXYPnYU65oAl/xEtVKtildTyaKn5E1PUte
         uF6dVbfGCwAueW7XuoFQSz2OPrrTl7qj1sjWr3V7UsUNFTe5eLQJspv5Cozlhxslye
         Cu6buuY9pATZZGnjTxwCTcCofZ5fr8zMChY+ra34=
Subject: FAILED: patch "[PATCH] ext4: fix an use-after-free issue about data=journal" failed to apply to 5.4-stable tree
To:     yi.zhang@huawei.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 08:53:25 +0100
Message-ID: <1643010805136188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c48a7df91499e371ef725895b2e2d21a126e227 Mon Sep 17 00:00:00 2001
From: Zhang Yi <yi.zhang@huawei.com>
Date: Sat, 25 Dec 2021 17:09:37 +0800
Subject: [PATCH] ext4: fix an use-after-free issue about data=journal
 writeback mode

Our syzkaller report an use-after-free issue that accessing the freed
buffer_head on the writeback page in __ext4_journalled_writepage(). The
problem is that if there was a truncate racing with the data=journalled
writeback procedure, the writeback length could become zero and
bget_one() refuse to get buffer_head's refcount, then the truncate
procedure release buffer once we drop page lock, finally, the last
ext4_walk_page_buffers() trigger the use-after-free problem.

sync                               truncate
ext4_sync_file()
 file_write_and_wait_range()
                                   ext4_setattr(0)
                                    inode->i_size = 0
  ext4_writepage()
   len = 0
   __ext4_journalled_writepage()
    page_bufs = page_buffers(page)
    ext4_walk_page_buffers(bget_one) <- does not get refcount
                                    do_invalidatepage()
                                      free_buffer_head()
    ext4_walk_page_buffers(page_bufs) <- trigger use-after-free

After commit bdf96838aea6 ("ext4: fix race between truncate and
__ext4_journalled_writepage()"), we have already handled the racing
case, so the bget_one() and bput_one() are not needed. So this patch
simply remove these hunk, and recheck the i_size to make it safe.

Fixes: bdf96838aea6 ("ext4: fix race between truncate and __ext4_journalled_writepage()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211225090937.712867-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bca9951634d9..68070f34f0cf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1845,30 +1845,16 @@ int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 	return 0;
 }
 
-static int bget_one(handle_t *handle, struct inode *inode,
-		    struct buffer_head *bh)
-{
-	get_bh(bh);
-	return 0;
-}
-
-static int bput_one(handle_t *handle, struct inode *inode,
-		    struct buffer_head *bh)
-{
-	put_bh(bh);
-	return 0;
-}
-
 static int __ext4_journalled_writepage(struct page *page,
 				       unsigned int len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	struct buffer_head *page_bufs = NULL;
 	handle_t *handle = NULL;
 	int ret = 0, err = 0;
 	int inline_data = ext4_has_inline_data(inode);
 	struct buffer_head *inode_bh = NULL;
+	loff_t size;
 
 	ClearPageChecked(page);
 
@@ -1878,14 +1864,6 @@ static int __ext4_journalled_writepage(struct page *page,
 		inode_bh = ext4_journalled_write_inline_data(inode, len, page);
 		if (inode_bh == NULL)
 			goto out;
-	} else {
-		page_bufs = page_buffers(page);
-		if (!page_bufs) {
-			BUG();
-			goto out;
-		}
-		ext4_walk_page_buffers(handle, inode, page_bufs, 0, len,
-				       NULL, bget_one);
 	}
 	/*
 	 * We need to release the page lock before we start the
@@ -1906,7 +1884,8 @@ static int __ext4_journalled_writepage(struct page *page,
 
 	lock_page(page);
 	put_page(page);
-	if (page->mapping != mapping) {
+	size = i_size_read(inode);
+	if (page->mapping != mapping || page_offset(page) > size) {
 		/* The page got truncated from under us */
 		ext4_journal_stop(handle);
 		ret = 0;
@@ -1916,6 +1895,13 @@ static int __ext4_journalled_writepage(struct page *page,
 	if (inline_data) {
 		ret = ext4_mark_inode_dirty(handle, inode);
 	} else {
+		struct buffer_head *page_bufs = page_buffers(page);
+
+		if (page->index == size >> PAGE_SHIFT)
+			len = size & ~PAGE_MASK;
+		else
+			len = PAGE_SIZE;
+
 		ret = ext4_walk_page_buffers(handle, inode, page_bufs, 0, len,
 					     NULL, do_journal_get_write_access);
 
@@ -1936,9 +1922,6 @@ static int __ext4_journalled_writepage(struct page *page,
 out:
 	unlock_page(page);
 out_no_pagelock:
-	if (!inline_data && page_bufs)
-		ext4_walk_page_buffers(NULL, inode, page_bufs, 0, len,
-				       NULL, bput_one);
 	brelse(inode_bh);
 	return ret;
 }

