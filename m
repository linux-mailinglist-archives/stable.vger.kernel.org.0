Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A94915EF84
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388869AbgBNRs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:48:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388965AbgBNP7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D40024688;
        Fri, 14 Feb 2020 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695978;
        bh=etzUjo5SB8lRMJUN8Z+EUaIVz1ztdnj+e9dCu+IdJfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0ALUcG41JDpykHMUSuVal3IbDidRdXlfZn9268N3c02QfHra/aATYH6xZjvYS3+0
         HnAhmx6b2uthep+mzhbPDuP2MXenarpvoND+YV6kEIZtHGtScrdg04fVvIJaYPn9o9
         64JnWJnR0v/N311GPZbpuCNkkCVuPiiv4y1Bmbdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 503/542] btrfs: do not do delalloc reservation under page lock
Date:   Fri, 14 Feb 2020 10:48:15 -0500
Message-Id: <20200214154854.6746-503-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f4b1363cae43fef7c86c993b7ca7fe7d546b3c68 ]

We ran into a deadlock in production with the fixup worker.  The stack
traces were as follows:

Thread responsible for the writeout, waiting on the page lock

  [<0>] io_schedule+0x12/0x40
  [<0>] __lock_page+0x109/0x1e0
  [<0>] extent_write_cache_pages+0x206/0x360
  [<0>] extent_writepages+0x40/0x60
  [<0>] do_writepages+0x31/0xb0
  [<0>] __writeback_single_inode+0x3d/0x350
  [<0>] writeback_sb_inodes+0x19d/0x3c0
  [<0>] __writeback_inodes_wb+0x5d/0xb0
  [<0>] wb_writeback+0x231/0x2c0
  [<0>] wb_workfn+0x308/0x3c0
  [<0>] process_one_work+0x1e0/0x390
  [<0>] worker_thread+0x2b/0x3c0
  [<0>] kthread+0x113/0x130
  [<0>] ret_from_fork+0x35/0x40
  [<0>] 0xffffffffffffffff

Thread of the fixup worker who is holding the page lock

  [<0>] start_delalloc_inodes+0x241/0x2d0
  [<0>] btrfs_start_delalloc_roots+0x179/0x230
  [<0>] btrfs_alloc_data_chunk_ondemand+0x11b/0x2e0
  [<0>] btrfs_check_data_free_space+0x53/0xa0
  [<0>] btrfs_delalloc_reserve_space+0x20/0x70
  [<0>] btrfs_writepage_fixup_worker+0x1fc/0x2a0
  [<0>] normal_work_helper+0x11c/0x360
  [<0>] process_one_work+0x1e0/0x390
  [<0>] worker_thread+0x2b/0x3c0
  [<0>] kthread+0x113/0x130
  [<0>] ret_from_fork+0x35/0x40
  [<0>] 0xffffffffffffffff

Thankfully the stars have to align just right to hit this.  First you
have to end up in the fixup worker, which is tricky by itself (my
reproducer does DIO reads into a MMAP'ed region, so not a common
operation).  Then you have to have less than a page size of free data
space and 0 unallocated space so you go down the "commit the transaction
to free up pinned space" path.  This was accomplished by a random
balance that was running on the host.  Then you get this deadlock.

I'm still in the process of trying to force the deadlock to happen on
demand, but I've hit other issues.  I can still trigger the fixup worker
path itself so this patch has been tested in that regard, so the normal
case is fine.

Fixes: 87826df0ec36 ("btrfs: delalloc for page dirtied out-of-band in fixup worker")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 76 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 60 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 27f2c554cac32..537b4c563f09c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2191,6 +2191,7 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 /* see btrfs_writepage_start_hook for details on why this is required */
 struct btrfs_writepage_fixup {
 	struct page *page;
+	struct inode *inode;
 	struct btrfs_work work;
 };
 
@@ -2205,9 +2206,20 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	u64 page_start;
 	u64 page_end;
 	int ret = 0;
+	bool free_delalloc_space = true;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
+	inode = fixup->inode;
+	page_start = page_offset(page);
+	page_end = page_offset(page) + PAGE_SIZE - 1;
+
+	/*
+	 * This is similar to page_mkwrite, we need to reserve the space before
+	 * we take the page lock.
+	 */
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
+					   PAGE_SIZE);
 again:
 	lock_page(page);
 
@@ -2216,25 +2228,48 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	 * page->mapping may go NULL, but it shouldn't be moved to a different
 	 * address space.
 	 */
-	if (!page->mapping || !PageDirty(page) || !PageChecked(page))
+	if (!page->mapping || !PageDirty(page) || !PageChecked(page)) {
+		/*
+		 * Unfortunately this is a little tricky, either
+		 *
+		 * 1) We got here and our page had already been dealt with and
+		 *    we reserved our space, thus ret == 0, so we need to just
+		 *    drop our space reservation and bail.  This can happen the
+		 *    first time we come into the fixup worker, or could happen
+		 *    while waiting for the ordered extent.
+		 * 2) Our page was already dealt with, but we happened to get an
+		 *    ENOSPC above from the btrfs_delalloc_reserve_space.  In
+		 *    this case we obviously don't have anything to release, but
+		 *    because the page was already dealt with we don't want to
+		 *    mark the page with an error, so make sure we're resetting
+		 *    ret to 0.  This is why we have this check _before_ the ret
+		 *    check, because we do not want to have a surprise ENOSPC
+		 *    when the page was already properly dealt with.
+		 */
+		if (!ret) {
+			btrfs_delalloc_release_extents(BTRFS_I(inode),
+						       PAGE_SIZE);
+			btrfs_delalloc_release_space(inode, data_reserved,
+						     page_start, PAGE_SIZE,
+						     true);
+		}
+		ret = 0;
 		goto out_page;
+	}
 
 	/*
-	 * We keep the PageChecked() bit set until we're done with the
-	 * btrfs_start_ordered_extent() dance that we do below.  That drops and
-	 * retakes the page lock, so we don't want new fixup workers queued for
-	 * this page during the churn.
+	 * We can't mess with the page state unless it is locked, so now that
+	 * it is locked bail if we failed to make our space reservation.
 	 */
-	inode = page->mapping->host;
-	page_start = page_offset(page);
-	page_end = page_offset(page) + PAGE_SIZE - 1;
+	if (ret)
+		goto out_page;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			 &cached_state);
 
 	/* already ordered? We're done */
 	if (PagePrivate2(page))
-		goto out;
+		goto out_reserved;
 
 	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), page_start,
 					PAGE_SIZE);
@@ -2247,11 +2282,6 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 		goto again;
 	}
 
-	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
-					   PAGE_SIZE);
-	if (ret)
-		goto out;
-
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
 					&cached_state);
 	if (ret)
@@ -2265,12 +2295,12 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	 * The page was dirty when we started, nothing should have cleaned it.
 	 */
 	BUG_ON(!PageDirty(page));
+	free_delalloc_space = false;
 out_reserved:
 	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
-	if (ret)
+	if (free_delalloc_space)
 		btrfs_delalloc_release_space(inode, data_reserved, page_start,
 					     PAGE_SIZE, true);
-out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			     &cached_state);
 out_page:
@@ -2289,6 +2319,12 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	put_page(page);
 	kfree(fixup);
 	extent_changeset_free(data_reserved);
+	/*
+	 * As a precaution, do a delayed iput in case it would be the last iput
+	 * that could need flushing space. Recursing back to fixup worker would
+	 * deadlock.
+	 */
+	btrfs_add_delayed_iput(inode);
 }
 
 /*
@@ -2326,10 +2362,18 @@ int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end)
 	if (!fixup)
 		return -EAGAIN;
 
+	/*
+	 * We are already holding a reference to this inode from
+	 * write_cache_pages.  We need to hold it because the space reservation
+	 * takes place outside of the page lock, and we can't trust
+	 * page->mapping outside of the page lock.
+	 */
+	ihold(inode);
 	SetPageChecked(page);
 	get_page(page);
 	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL, NULL);
 	fixup->page = page;
+	fixup->inode = inode;
 	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);
 
 	return -EAGAIN;
-- 
2.20.1

