Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09295B1EE9
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389456AbfIMNOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389451AbfIMNOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:05 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825FE208C2;
        Fri, 13 Sep 2019 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380444;
        bh=QYGKkCfgXw70TE01oCtAzDArIkGCi9WQwwNCnEAhal8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWVETDnevhmS79Jg9LwH3HJH3CRVRJK0WuzwRGfmTHAJoy3z1e7HqOsXBjy2wr4zy
         m0GrazZa1BIig41hI1Od2UXlvh277tvknFYCXGW6B7AuaT3ii0nazx3d1wulsXd3hH
         fzzQGl2nRhn1BygCa06d5yLnYElX1C/Ui71xbhX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/190] Btrfs: fix deadlock with memory reclaim during scrub
Date:   Fri, 13 Sep 2019 14:05:21 +0100
Message-Id: <20190913130604.992998334@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a5fb11429167ee6ddeeacc554efaf5776b36433a ]

When a transaction commit starts, it attempts to pause scrub and it blocks
until the scrub is paused. So while the transaction is blocked waiting for
scrub to pause, we can not do memory allocation with GFP_KERNEL from scrub,
otherwise we risk getting into a deadlock with reclaim.

Checking for scrub pause requests is done early at the beginning of the
while loop of scrub_stripe() and later in the loop, scrub_extent() and
scrub_raid56_parity() are called, which in turn call scrub_pages() and
scrub_pages_for_parity() respectively. These last two functions do memory
allocations using GFP_KERNEL. Same problem could happen while scrubbing
the super blocks, since it calls scrub_pages().

We also can not have any of the worker tasks, created by the scrub task,
doing GFP_KERNEL allocations, because before pausing, the scrub task waits
for all the worker tasks to complete (also done at scrub_stripe()).

So make sure GFP_NOFS is used for the memory allocations because at any
time a scrub pause request can happen from another task that started to
commit a transaction.

Fixes: 58c4e173847a ("btrfs: scrub: use GFP_KERNEL on the submission path")
CC: stable@vger.kernel.org # 4.6+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4bcc275f76128..5a2d10ba747f7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -322,6 +322,7 @@ static struct full_stripe_lock *insert_full_stripe_lock(
 	struct rb_node *parent = NULL;
 	struct full_stripe_lock *entry;
 	struct full_stripe_lock *ret;
+	unsigned int nofs_flag;
 
 	lockdep_assert_held(&locks_root->lock);
 
@@ -339,8 +340,17 @@ static struct full_stripe_lock *insert_full_stripe_lock(
 		}
 	}
 
-	/* Insert new lock */
+	/*
+	 * Insert new lock.
+	 *
+	 * We must use GFP_NOFS because the scrub task might be waiting for a
+	 * worker task executing this function and in turn a transaction commit
+	 * might be waiting the scrub task to pause (which needs to wait for all
+	 * the worker tasks to complete before pausing).
+	 */
+	nofs_flag = memalloc_nofs_save();
 	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 	ret->logical = fstripe_logical;
@@ -1622,8 +1632,19 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 	mutex_lock(&sctx->wr_lock);
 again:
 	if (!sctx->wr_curr_bio) {
+		unsigned int nofs_flag;
+
+		/*
+		 * We must use GFP_NOFS because the scrub task might be waiting
+		 * for a worker task executing this function and in turn a
+		 * transaction commit might be waiting the scrub task to pause
+		 * (which needs to wait for all the worker tasks to complete
+		 * before pausing).
+		 */
+		nofs_flag = memalloc_nofs_save();
 		sctx->wr_curr_bio = kzalloc(sizeof(*sctx->wr_curr_bio),
 					      GFP_KERNEL);
+		memalloc_nofs_restore(nofs_flag);
 		if (!sctx->wr_curr_bio) {
 			mutex_unlock(&sctx->wr_lock);
 			return -ENOMEM;
@@ -3775,6 +3796,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	struct scrub_ctx *sctx;
 	int ret;
 	struct btrfs_device *dev;
+	unsigned int nofs_flag;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
@@ -3878,6 +3900,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
 
+	/*
+	 * In order to avoid deadlock with reclaim when there is a transaction
+	 * trying to pause scrub, make sure we use GFP_NOFS for all the
+	 * allocations done at btrfs_scrub_pages() and scrub_pages_for_parity()
+	 * invoked by our callees. The pausing request is done when the
+	 * transaction commit starts, and it blocks the transaction until scrub
+	 * is paused (done at specific points at scrub_stripe() or right above
+	 * before incrementing fs_info->scrubs_running).
+	 */
+	nofs_flag = memalloc_nofs_save();
 	if (!is_dev_replace) {
 		/*
 		 * by holding device list mutex, we can
@@ -3890,6 +3922,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	if (!ret)
 		ret = scrub_enumerate_chunks(sctx, dev, start, end);
+	memalloc_nofs_restore(nofs_flag);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
-- 
2.20.1



