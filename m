Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8263C3A811
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbfFIQ4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733020AbfFIQ4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:56:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B054205ED;
        Sun,  9 Jun 2019 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099397;
        bh=SX8Gd4znDD0RUnNL/swJqYt2dOsIYTp0NigTjBys+vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8fZsWZYSZwpnyMd1OJPZjkQzFhOPVK0R28Y/pzUsx8EOUZ0N41rJOU2EpRG594Z7
         mdFBkPI6pwK1v6gaUJ9+GjoJwyvGF0uU5Iabn1gUNUMFWMzY9+Yg2jtTVUM2sxRAeA
         sYDN+AQKS3mplkC7gq8nbp2LNzvxUUo91Q0tvKX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiufei Xue <xuejiufei@gmail.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.4 027/241] writeback: synchronize sync(2) against cgroup writeback membership switches
Date:   Sun,  9 Jun 2019 18:39:29 +0200
Message-Id: <20190609164148.562655559@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 7fc5854f8c6efae9e7624970ab49a1eac2faefb1 upstream.

sync_inodes_sb() can race against cgwb (cgroup writeback) membership
switches and fail to writeback some inodes.  For example, if an inode
switches to another wb while sync_inodes_sb() is in progress, the new
wb might not be visible to bdi_split_work_to_wbs() at all or the inode
might jump from a wb which hasn't issued writebacks yet to one which
already has.

This patch adds backing_dev_info->wb_switch_rwsem to synchronize cgwb
switch path against sync_inodes_sb() so that sync_inodes_sb() is
guaranteed to see all the target wbs and inodes can't jump wbs to
escape syncing.

v2: Fixed misplaced rwsem init.  Spotted by Jiufei.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jiufei Xue <xuejiufei@gmail.com>
Link: http://lkml.kernel.org/r/dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c                |   40 +++++++++++++++++++++++++++++++++++++--
 include/linux/backing-dev-defs.h |    1 
 mm/backing-dev.c                 |    1 
 3 files changed, 40 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -331,11 +331,22 @@ struct inode_switch_wbs_context {
 	struct work_struct	work;
 };
 
+static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi)
+{
+	down_write(&bdi->wb_switch_rwsem);
+}
+
+static void bdi_up_write_wb_switch_rwsem(struct backing_dev_info *bdi)
+{
+	up_write(&bdi->wb_switch_rwsem);
+}
+
 static void inode_switch_wbs_work_fn(struct work_struct *work)
 {
 	struct inode_switch_wbs_context *isw =
 		container_of(work, struct inode_switch_wbs_context, work);
 	struct inode *inode = isw->inode;
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
 	struct bdi_writeback *new_wb = isw->new_wb;
@@ -344,6 +355,12 @@ static void inode_switch_wbs_work_fn(str
 	void **slot;
 
 	/*
+	 * If @inode switches cgwb membership while sync_inodes_sb() is
+	 * being issued, sync_inodes_sb() might miss it.  Synchronize.
+	 */
+	down_read(&bdi->wb_switch_rwsem);
+
+	/*
 	 * By the time control reaches here, RCU grace period has passed
 	 * since I_WB_SWITCH assertion and all wb stat update transactions
 	 * between unlocked_inode_to_wb_begin/end() are guaranteed to be
@@ -435,6 +452,8 @@ skip_switch:
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
+	up_read(&bdi->wb_switch_rwsem);
+
 	if (switched) {
 		wb_wakeup(new_wb);
 		wb_put(old_wb);
@@ -475,9 +494,18 @@ static void inode_switch_wbs(struct inod
 	if (inode->i_state & I_WB_SWITCH)
 		return;
 
+	/*
+	 * Avoid starting new switches while sync_inodes_sb() is in
+	 * progress.  Otherwise, if the down_write protected issue path
+	 * blocks heavily, we might end up starting a large number of
+	 * switches which will block on the rwsem.
+	 */
+	if (!down_read_trylock(&bdi->wb_switch_rwsem))
+		return;
+
 	isw = kzalloc(sizeof(*isw), GFP_ATOMIC);
 	if (!isw)
-		return;
+		goto out_unlock;
 
 	/* find and pin the new wb */
 	rcu_read_lock();
@@ -511,12 +539,14 @@ static void inode_switch_wbs(struct inod
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
-	return;
+	goto out_unlock;
 
 out_free:
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
 	kfree(isw);
+out_unlock:
+	up_read(&bdi->wb_switch_rwsem);
 }
 
 /**
@@ -896,6 +926,9 @@ fs_initcall(cgroup_writeback_init);
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
+static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi) { }
+static void bdi_up_write_wb_switch_rwsem(struct backing_dev_info *bdi) { }
+
 static struct bdi_writeback *
 locked_inode_to_wb_and_lock_list(struct inode *inode)
 	__releases(&inode->i_lock)
@@ -2341,8 +2374,11 @@ void sync_inodes_sb(struct super_block *
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
+	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
+	bdi_down_write_wb_switch_rwsem(bdi);
 	bdi_split_work_to_wbs(bdi, &work, false);
 	wb_wait_for_completion(bdi, &done);
+	bdi_up_write_wb_switch_rwsem(bdi);
 
 	wait_sb_inodes(sb);
 }
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -157,6 +157,7 @@ struct backing_dev_info {
 	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
 	struct rb_root cgwb_congested_tree; /* their congested states */
 	atomic_t usage_cnt; /* counts both cgwbs and cgwb_contested's */
+	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
 #else
 	struct bdi_writeback_congested *wb_congested;
 #endif
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -669,6 +669,7 @@ static int cgwb_bdi_init(struct backing_
 	INIT_RADIX_TREE(&bdi->cgwb_tree, GFP_ATOMIC);
 	bdi->cgwb_congested_tree = RB_ROOT;
 	atomic_set(&bdi->usage_cnt, 1);
+	init_rwsem(&bdi->wb_switch_rwsem);
 
 	ret = wb_init(&bdi->wb, bdi, 1, GFP_KERNEL);
 	if (!ret) {


