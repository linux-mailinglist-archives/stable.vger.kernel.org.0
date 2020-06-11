Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4FC1F6352
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 10:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgFKIMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 04:12:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:58478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgFKIMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 04:12:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC432AC51;
        Thu, 11 Jun 2020 08:12:07 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 9D5AD1E128B; Thu, 11 Jun 2020 10:12:03 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Martijn Coenen <maco@android.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] writeback: Fix sync livelock due to b_dirty_time processing
Date:   Thu, 11 Jun 2020 10:11:54 +0200
Message-Id: <20200611081203.18161-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200611075033.1248-1-jack@suse.cz>
References: <20200611075033.1248-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we are processing writeback for sync(2), move_expired_inodes()
didn't set any inode expiry value (older_than_this). This can result in
writeback never completing if there's steady stream of inodes added to
b_dirty_time list as writeback rechecks dirty lists after each writeback
round whether there's more work to be done. Fix the problem by using
sync(2) start time is inode expiry value when processing b_dirty_time
list similarly as for ordinarily dirtied inodes. This requires some
refactoring of older_than_this handling which simplifies the code
noticeably as a bonus.

Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c                | 44 ++++++++++++++++------------------------
 include/trace/events/writeback.h | 13 ++++++------
 2 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f470c10641c5..ae17d64a3e18 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -42,7 +42,6 @@
 struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
-	unsigned long *older_than_this;
 	enum writeback_sync_modes sync_mode;
 	unsigned int tagged_writepages:1;
 	unsigned int for_kupdate:1;
@@ -1234,16 +1233,13 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
 #define EXPIRE_DIRTY_ATIME 0x0001
 
 /*
- * Move expired (dirtied before work->older_than_this) dirty inodes from
+ * Move expired (dirtied before dirtied_before) dirty inodes from
  * @delaying_queue to @dispatch_queue.
  */
 static int move_expired_inodes(struct list_head *delaying_queue,
 			       struct list_head *dispatch_queue,
-			       int flags,
-			       struct wb_writeback_work *work)
+			       int flags, unsigned long dirtied_before)
 {
-	unsigned long *older_than_this = NULL;
-	unsigned long expire_time;
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
@@ -1251,16 +1247,9 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 	int do_sb_sort = 0;
 	int moved = 0;
 
-	if ((flags & EXPIRE_DIRTY_ATIME) == 0)
-		older_than_this = work->older_than_this;
-	else if (!work->for_sync) {
-		expire_time = jiffies - (dirtytime_expire_interval * HZ);
-		older_than_this = &expire_time;
-	}
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
-		if (older_than_this &&
-		    inode_dirtied_after(inode, *older_than_this))
+		if (inode_dirtied_after(inode, dirtied_before))
 			break;
 		list_move(&inode->i_io_list, &tmp);
 		moved++;
@@ -1306,18 +1295,22 @@ static int move_expired_inodes(struct list_head *delaying_queue,
  *                                           |
  *                                           +--> dequeue for IO
  */
-static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
+static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work,
+		     unsigned long dirtied_before)
 {
 	int moved;
+	unsigned long time_expire_jif = dirtied_before;
 
 	assert_spin_locked(&wb->list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
-	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, 0, work);
+	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, 0, dirtied_before);
+	if (!work->for_sync)
+		time_expire_jif = jiffies - dirtytime_expire_interval * HZ;
 	moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
-				     EXPIRE_DIRTY_ATIME, work);
+				     EXPIRE_DIRTY_ATIME, time_expire_jif);
 	if (moved)
 		wb_io_lists_populated(wb);
-	trace_writeback_queue_io(wb, work, moved);
+	trace_writeback_queue_io(wb, work, dirtied_before, moved);
 }
 
 static int write_inode(struct inode *inode, struct writeback_control *wbc)
@@ -1829,7 +1822,7 @@ static long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 	blk_start_plug(&plug);
 	spin_lock(&wb->list_lock);
 	if (list_empty(&wb->b_io))
-		queue_io(wb, &work);
+		queue_io(wb, &work, jiffies);
 	__writeback_inodes_wb(wb, &work);
 	spin_unlock(&wb->list_lock);
 	blk_finish_plug(&plug);
@@ -1849,7 +1842,7 @@ static long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
  * takes longer than a dirty_writeback_interval interval, then leave a
  * one-second gap.
  *
- * older_than_this takes precedence over nr_to_write.  So we'll only write back
+ * dirtied_before takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
 static long wb_writeback(struct bdi_writeback *wb,
@@ -1857,14 +1850,11 @@ static long wb_writeback(struct bdi_writeback *wb,
 {
 	unsigned long wb_start = jiffies;
 	long nr_pages = work->nr_pages;
-	unsigned long oldest_jif;
+	unsigned long dirtied_before = jiffies;
 	struct inode *inode;
 	long progress;
 	struct blk_plug plug;
 
-	oldest_jif = jiffies;
-	work->older_than_this = &oldest_jif;
-
 	blk_start_plug(&plug);
 	spin_lock(&wb->list_lock);
 	for (;;) {
@@ -1898,14 +1888,14 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * safe.
 		 */
 		if (work->for_kupdate) {
-			oldest_jif = jiffies -
+			dirtied_before = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
 		} else if (work->for_background)
-			oldest_jif = jiffies;
+			dirtied_before = jiffies;
 
 		trace_writeback_start(wb, work);
 		if (list_empty(&wb->b_io))
-			queue_io(wb, work);
+			queue_io(wb, work, dirtied_before);
 		if (work->sb)
 			progress = writeback_sb_inodes(work->sb, wb, work);
 		else
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 10f5d1fa7347..7565dcd59697 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -498,8 +498,9 @@ DEFINE_WBC_EVENT(wbc_writepage);
 TRACE_EVENT(writeback_queue_io,
 	TP_PROTO(struct bdi_writeback *wb,
 		 struct wb_writeback_work *work,
+		 unsigned long dirtied_before,
 		 int moved),
-	TP_ARGS(wb, work, moved),
+	TP_ARGS(wb, work, dirtied_before, moved),
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
 		__field(unsigned long,	older)
@@ -509,19 +510,17 @@ TRACE_EVENT(writeback_queue_io,
 		__field(ino_t,		cgroup_ino)
 	),
 	TP_fast_assign(
-		unsigned long *older_than_this = work->older_than_this;
 		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
-		__entry->older	= older_than_this ?  *older_than_this : 0;
-		__entry->age	= older_than_this ?
-				  (jiffies - *older_than_this) * 1000 / HZ : -1;
+		__entry->older	= dirtied_before;
+		__entry->age	= (jiffies - dirtied_before) * 1000 / HZ;
 		__entry->moved	= moved;
 		__entry->reason	= work->reason;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
 	),
 	TP_printk("bdi %s: older=%lu age=%ld enqueue=%d reason=%s cgroup_ino=%lu",
 		__entry->name,
-		__entry->older,	/* older_than_this in jiffies */
-		__entry->age,	/* older_than_this in relative milliseconds */
+		__entry->older,	/* dirtied_before in jiffies */
+		__entry->age,	/* dirtied_before in relative milliseconds */
 		__entry->moved,
 		__print_symbolic(__entry->reason, WB_WORK_REASON),
 		(unsigned long)__entry->cgroup_ino
-- 
2.16.4

