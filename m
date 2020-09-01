Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3612595C6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbgIAPp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbgIAPp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:45:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 369732064B;
        Tue,  1 Sep 2020 15:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975125;
        bh=dd+JQCM5s98p+yXm7WOY0Kntz4sLoZOAfBCVDomQIWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWbnkK3xmOUHzmrgY6C+RCfbTJz8AIZqe3qU68HDhYMx7JOiSPqLckUHMFymCLqLD
         mcTPRBP55IG5BJ7IhYDVO1Wao9L/d4hxqXobPcwDi3DHRhmAYiBIii0QGt+rUUDruw
         C/2SsrOZhRkOq/UjjgfUpzZlOaR3HZuUkKss9uDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.8 189/255] writeback: Fix sync livelock due to b_dirty_time processing
Date:   Tue,  1 Sep 2020 17:10:45 +0200
Message-Id: <20200901151009.744929597@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit f9cae926f35e8230330f28c7b743ad088611a8de upstream.

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c                |   44 +++++++++++++++------------------------
 include/trace/events/writeback.h |   13 +++++------
 2 files changed, 23 insertions(+), 34 deletions(-)

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
@@ -1234,16 +1233,13 @@ static bool inode_dirtied_after(struct i
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
@@ -1251,16 +1247,9 @@ static int move_expired_inodes(struct li
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
@@ -1306,18 +1295,22 @@ out:
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
@@ -1829,7 +1822,7 @@ static long writeback_inodes_wb(struct b
 	blk_start_plug(&plug);
 	spin_lock(&wb->list_lock);
 	if (list_empty(&wb->b_io))
-		queue_io(wb, &work);
+		queue_io(wb, &work, jiffies);
 	__writeback_inodes_wb(wb, &work);
 	spin_unlock(&wb->list_lock);
 	blk_finish_plug(&plug);
@@ -1849,7 +1842,7 @@ static long writeback_inodes_wb(struct b
  * takes longer than a dirty_writeback_interval interval, then leave a
  * one-second gap.
  *
- * older_than_this takes precedence over nr_to_write.  So we'll only write back
+ * dirtied_before takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
 static long wb_writeback(struct bdi_writeback *wb,
@@ -1857,14 +1850,11 @@ static long wb_writeback(struct bdi_writ
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
@@ -1898,14 +1888,14 @@ static long wb_writeback(struct bdi_writ
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


