Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E83C167295
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgBUIEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbgBUIEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:04:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E31620801;
        Fri, 21 Feb 2020 08:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272291;
        bh=nQa12Rm/LxowxBPaeH8ajSnhzeTA9jws0lehStZau60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ9HnspFOlCPiIvSKQbZzF3fZwleJzmzPYZF2RnqTbsABqBFBrPD9mgCwQ8DZAhPu
         aKmNgTQcC9vjW18o8ebwd6ODsqbU3M6d4uxiOj32QjpiXSqobqirmJsSp9T9qG/eBS
         rNsWLplWzsm85okyJcZbpztTuIs1vocibntB8Gk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/344] Btrfs: keep pages dirty when using btrfs_writepage_fixup_worker
Date:   Fri, 21 Feb 2020 08:38:06 +0100
Message-Id: <20200221072356.874460288@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mason <clm@fb.com>

[ Upstream commit 25f3c5021985e885292980d04a1423fd83c967bb ]

For COW, btrfs expects pages dirty pages to have been through a few setup
steps.  This includes reserving space for the new block allocations and marking
the range in the state tree for delayed allocation.

A few places outside btrfs will dirty pages directly, especially when unmapping
mmap'd pages.  In order for these to properly go through COW, we run them
through a fixup worker to wait for stable pages, and do the delalloc prep.

87826df0ec36 added a window where the dirty pages were cleaned, but pending
more action from the fixup worker.  We clear_page_dirty_for_io() before
we call into writepage, so the page is no longer dirty.  The commit
changed it so now we leave the page clean between unlocking it here and
the fixup worker starting at some point in the future.

During this window, page migration can jump in and relocate the page.  Once our
fixup work actually starts, it finds page->mapping is NULL and we end up
freeing the page without ever writing it.

This leads to crc errors and other exciting problems, since it screws up the
whole statemachine for waiting for ordered extents.  The fix here is to keep
the page dirty while we're waiting for the fixup worker to get to work.
This is accomplished by returning -EAGAIN from btrfs_writepage_cow_fixup
if we queued the page up for fixup, which will cause the writepage
function to redirty the page.

Because we now expect the page to be dirty once it gets to the fixup
worker we must adjust the error cases to call clear_page_dirty_for_io()
on the page.  That is the bulk of the patch, but it is not the fix, the
fix is the -EAGAIN from btrfs_writepage_cow_fixup.  We cannot separate
these two changes out because the error conditions change with the new
expectations.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 61 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6f0568fb58997..1b4ab02be9243 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2181,17 +2181,27 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	struct inode *inode;
 	u64 page_start;
 	u64 page_end;
-	int ret;
+	int ret = 0;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
 again:
 	lock_page(page);
-	if (!page->mapping || !PageDirty(page) || !PageChecked(page)) {
-		ClearPageChecked(page);
+
+	/*
+	 * Before we queued this fixup, we took a reference on the page.
+	 * page->mapping may go NULL, but it shouldn't be moved to a different
+	 * address space.
+	 */
+	if (!page->mapping || !PageDirty(page) || !PageChecked(page))
 		goto out_page;
-	}
 
+	/*
+	 * We keep the PageChecked() bit set until we're done with the
+	 * btrfs_start_ordered_extent() dance that we do below.  That drops and
+	 * retakes the page lock, so we don't want new fixup workers queued for
+	 * this page during the churn.
+	 */
 	inode = page->mapping->host;
 	page_start = page_offset(page);
 	page_end = page_offset(page) + PAGE_SIZE - 1;
@@ -2216,24 +2226,22 @@ again:
 
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   PAGE_SIZE);
-	if (ret) {
-		mapping_set_error(page->mapping, ret);
-		end_extent_writepage(page, ret, page_start, page_end);
-		ClearPageChecked(page);
+	if (ret)
 		goto out;
-	 }
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
 					&cached_state);
-	if (ret) {
-		mapping_set_error(page->mapping, ret);
-		end_extent_writepage(page, ret, page_start, page_end);
-		ClearPageChecked(page);
+	if (ret)
 		goto out_reserved;
-	}
 
-	ClearPageChecked(page);
-	set_page_dirty(page);
+	/*
+	 * Everything went as planned, we're now the owner of a dirty page with
+	 * delayed allocation bits set and space reserved for our COW
+	 * destination.
+	 *
+	 * The page was dirty when we started, nothing should have cleaned it.
+	 */
+	BUG_ON(!PageDirty(page));
 out_reserved:
 	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 	if (ret)
@@ -2243,6 +2251,17 @@ out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			     &cached_state);
 out_page:
+	if (ret) {
+		/*
+		 * We hit ENOSPC or other errors.  Update the mapping and page
+		 * to reflect the errors and clean the page.
+		 */
+		mapping_set_error(page->mapping, ret);
+		end_extent_writepage(page, ret, page_start, page_end);
+		clear_page_dirty_for_io(page);
+		SetPageError(page);
+	}
+	ClearPageChecked(page);
 	unlock_page(page);
 	put_page(page);
 	kfree(fixup);
@@ -2270,6 +2289,13 @@ int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end)
 	if (TestClearPagePrivate2(page))
 		return 0;
 
+	/*
+	 * PageChecked is set below when we create a fixup worker for this page,
+	 * don't try to create another one if we're already PageChecked()
+	 *
+	 * The extent_io writepage code will redirty the page if we send back
+	 * EAGAIN.
+	 */
 	if (PageChecked(page))
 		return -EAGAIN;
 
@@ -2282,7 +2308,8 @@ int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end)
 	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL, NULL);
 	fixup->page = page;
 	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);
-	return -EBUSY;
+
+	return -EAGAIN;
 }
 
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
-- 
2.20.1



