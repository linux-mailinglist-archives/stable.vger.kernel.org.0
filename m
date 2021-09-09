Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2635404D15
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbhIIMAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244997AbhIIL4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89ED4613CD;
        Thu,  9 Sep 2021 11:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187921;
        bh=z0THs/1Oh55gmjciGgW4r9gh4aRELpxW2NrVBsxpcbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHUWMT3sRxOYNNMRLiaqsRA+ZpsIIa15zsn8J0Fai12stCRrpdC5HhikBGwPdW7/D
         pm0fUWwMm1wtwgWnu5pv6d7j8NghbqEsrneLNMANtymbMHVfLPZpF84zFT/uvdX14a
         zB3pIgIj7/SsKCXoTxIzjl+NeWSOBbQb/Xg6k7w7AFMoXorX/rXIVC1sRPaKOytT4s
         cZRy5QhkscTJ1rlJbPSno73b1/CdKKuByqoRBNNpGmMGYa1ttKB2tqxAAEQTwpOqhT
         s+wnsdtkvttH05wqyONVrptcuU7c7XvuxRtB1/QN9Dr8HgdFUxsgQCIlXvNBNI9Age
         004g3TThii/Fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 195/252] btrfs: subpage: fix a potential use-after-free in writeback helper
Date:   Thu,  9 Sep 2021 07:40:09 -0400
Message-Id: <20210909114106.141462-195-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 7c11d0ae439565b4560b0c0f36bf05171ed1a146 ]

[BUG]
There is a possible use-after-free bug when running generic/095.

 BUG: Unable to handle kernel data access on write at 0x6b6b6b6b6b6b725b
 Faulting instruction address: 0xc000000000283654
 c000000000283078 do_raw_spin_unlock+0x88/0x230
 c0000000012b1e14 _raw_spin_unlock_irqrestore+0x44/0x90
 c000000000a918dc btrfs_subpage_clear_writeback+0xac/0xe0
 c0000000009e0458 end_bio_extent_writepage+0x158/0x270
 c000000000b6fd14 bio_endio+0x254/0x270
 c0000000009fc0f0 btrfs_end_bio+0x1a0/0x200
 c000000000b6fd14 bio_endio+0x254/0x270
 c000000000b781fc blk_update_request+0x46c/0x670
 c000000000b8b394 blk_mq_end_request+0x34/0x1d0
 c000000000d82d1c lo_complete_rq+0x11c/0x140
 c000000000b880a4 blk_complete_reqs+0x84/0xb0
 c0000000012b2ca4 __do_softirq+0x334/0x680
 c0000000001dd878 irq_exit+0x148/0x1d0
 c000000000016f4c do_IRQ+0x20c/0x240
 c000000000009240 hardware_interrupt_common_virt+0x1b0/0x1c0

[CAUSE]
There is very small race window like the following in generic/095.

	Thread 1		|		Thread 2
--------------------------------+------------------------------------
  end_bio_extent_writepage()	| btrfs_releasepage()
  |- spin_lock_irqsave()	| |
  |- end_page_writeback()	| |
  |				| |- if (PageWriteback() ||...)
  |				| |- clear_page_extent_mapped()
  |				|    |- kfree(subpage);
  |- spin_unlock_irqrestore().

The race can also happen between writeback and btrfs_invalidatepage(),
although that would be much harder as btrfs_invalidatepage() has much
more work to do before the clear_page_extent_mapped() call.

[FIX]
Here we "wait" for the subapge spinlock to be released before we detach
subpage structure.
So this patch will introduce a new function, wait_subpage_spinlock(), to
do the "wait" by acquiring the spinlock and release it.

Since the caller has ensured the page is not dirty nor writeback, and
page is already locked, the only way to hold the subpage spinlock is
from endio function.
Thus we only need to acquire the spinlock to wait for any existing
holder.

Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Tested-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c    |  8 ++++----
 fs/btrfs/inode.c   | 39 ++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/subpage.c |  4 +++-
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8c57af3702fa..d3f2623a2af0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1343,10 +1343,10 @@ static int prepare_uptodate_page(struct inode *inode,
 
 		/*
 		 * Since btrfs_readpage() will unlock the page before it
-		 * returns, there is a window where btrfs_releasepage() can
-		 * be called to release the page.
-		 * Here we check both inode mapping and PagePrivate() to
-		 * make sure the page was not released.
+		 * returns, there is a window where btrfs_releasepage() can be
+		 * called to release the page.  Here we check both inode
+		 * mapping and PagePrivate() to make sure the page was not
+		 * released.
 		 *
 		 * The private flag check is essential for subpage as we need
 		 * to store extra bitmap using page->private.
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ef6e1798fc2d..34dd4af72246 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8413,11 +8413,47 @@ static void btrfs_readahead(struct readahead_control *rac)
 	extent_readahead(rac);
 }
 
+/*
+ * For releasepage() and invalidatepage() we have a race window where
+ * end_page_writeback() is called but the subpage spinlock is not yet released.
+ * If we continue to release/invalidate the page, we could cause use-after-free
+ * for subpage spinlock.  So this function is to spin and wait for subpage
+ * spinlock.
+ */
+static void wait_subpage_spinlock(struct page *page)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
+	struct btrfs_subpage *subpage;
+
+	if (fs_info->sectorsize == PAGE_SIZE)
+		return;
+
+	ASSERT(PagePrivate(page) && page->private);
+	subpage = (struct btrfs_subpage *)page->private;
+
+	/*
+	 * This may look insane as we just acquire the spinlock and release it,
+	 * without doing anything.  But we just want to make sure no one is
+	 * still holding the subpage spinlock.
+	 * And since the page is not dirty nor writeback, and we have page
+	 * locked, the only possible way to hold a spinlock is from the endio
+	 * function to clear page writeback.
+	 *
+	 * Here we just acquire the spinlock so that all existing callers
+	 * should exit and we're safe to release/invalidate the page.
+	 */
+	spin_lock_irq(&subpage->lock);
+	spin_unlock_irq(&subpage->lock);
+}
+
 static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	int ret = try_release_extent_mapping(page, gfp_flags);
-	if (ret == 1)
+
+	if (ret == 1) {
+		wait_subpage_spinlock(page);
 		clear_page_extent_mapped(page);
+	}
 	return ret;
 }
 
@@ -8481,6 +8517,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	 * do double ordered extent accounting on the same page.
 	 */
 	wait_on_page_writeback(page);
+	wait_subpage_spinlock(page);
 
 	/*
 	 * For subpage case, we have call sites like
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 640bcd21bf28..9408232e1dc9 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -435,8 +435,10 @@ void btrfs_subpage_clear_writeback(const struct btrfs_fs_info *fs_info,
 
 	spin_lock_irqsave(&subpage->lock, flags);
 	subpage->writeback_bitmap &= ~tmp;
-	if (subpage->writeback_bitmap == 0)
+	if (subpage->writeback_bitmap == 0) {
+		ASSERT(PageWriteback(page));
 		end_page_writeback(page);
+	}
 	spin_unlock_irqrestore(&subpage->lock, flags);
 }
 
-- 
2.30.2

