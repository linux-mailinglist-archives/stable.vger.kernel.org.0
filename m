Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CA3318E4D
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhBKPY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhBKPUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:20:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A791964F2A;
        Thu, 11 Feb 2021 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056018;
        bh=vj2aHSOFXXBCts6sUIu+zrKVjqZR+D/lPuQ6t/dw5RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2xG9p6NAwBTjfr8YtVZtqlGeR2gNrc3snE6T4nNH3KCDAeopT7AB9iP81t1rgzyu
         0A2rGfDUZ7/0srnYxRFme+7bWRCOUorJSJ23yvuHXZ3D9dtH5pG/YiSu5yZUoHbWIV
         J+Z8xtwPXGMGZm9Ej3we9yIxOClISQ5qa79EInl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/24] memcg: fix a crash in wb_workfn when a device disappears
Date:   Thu, 11 Feb 2021 16:02:52 +0100
Message-Id: <20210211150148.555189808@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 68f23b89067fdf187763e75a56087550624fdbee ]

Without memcg, there is a one-to-one mapping between the bdi and
bdi_writeback structures.  In this world, things are fairly
straightforward; the first thing bdi_unregister() does is to shutdown
the bdi_writeback structure (or wb), and part of that writeback ensures
that no other work queued against the wb, and that the wb is fully
drained.

With memcg, however, there is a one-to-many relationship between the bdi
and bdi_writeback structures; that is, there are multiple wb objects
which can all point to a single bdi.  There is a refcount which prevents
the bdi object from being released (and hence, unregistered).  So in
theory, the bdi_unregister() *should* only get called once its refcount
goes to zero (bdi_put will drop the refcount, and when it is zero,
release_bdi gets called, which calls bdi_unregister).

Unfortunately, del_gendisk() in block/gen_hd.c never got the memo about
the Brave New memcg World, and calls bdi_unregister directly.  It does
this without informing the file system, or the memcg code, or anything
else.  This causes the root wb associated with the bdi to be
unregistered, but none of the memcg-specific wb's are shutdown.  So when
one of these wb's are woken up to do delayed work, they try to
dereference their wb->bdi->dev to fetch the device name, but
unfortunately bdi->dev is now NULL, thanks to the bdi_unregister()
called by del_gendisk().  As a result, *boom*.

Fortunately, it looks like the rest of the writeback path is perfectly
happy with bdi->dev and bdi->owner being NULL, so the simplest fix is to
create a bdi_dev_name() function which can handle bdi->dev being NULL.
This also allows us to bulletproof the writeback tracepoints to prevent
them from dereferencing a NULL pointer and crashing the kernel if one is
tracing with memcg's enabled, and an iSCSI device dies or a USB storage
stick is pulled.

The most common way of triggering this will be hotremoval of a device
while writeback with memcg enabled is going on.  It was triggering
several times a day in a heavily loaded production environment.

Google Bug Id: 145475544

Link: https://lore.kernel.org/r/20191227194829.150110-1-tytso@mit.edu
Link: http://lkml.kernel.org/r/20191228005211.163952-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c                |  2 +-
 include/linux/backing-dev.h      | 10 ++++++++++
 include/trace/events/writeback.h | 29 +++++++++++++----------------
 mm/backing-dev.c                 |  1 +
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f2d0c4acb3cbb..a247cb4b00e2d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1986,7 +1986,7 @@ void wb_workfn(struct work_struct *work)
 						struct bdi_writeback, dwork);
 	long pages_written;
 
-	set_worker_desc("flush-%s", dev_name(wb->bdi->dev));
+	set_worker_desc("flush-%s", bdi_dev_name(wb->bdi));
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c28a47cbe355e..1ef4aca7b953f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/blkdev.h>
+#include <linux/device.h>
 #include <linux/writeback.h>
 #include <linux/blk-cgroup.h>
 #include <linux/backing-dev-defs.h>
@@ -498,4 +499,13 @@ static inline int bdi_rw_congested(struct backing_dev_info *bdi)
 				  (1 << WB_async_congested));
 }
 
+extern const char *bdi_unknown_name;
+
+static inline const char *bdi_dev_name(struct backing_dev_info *bdi)
+{
+	if (!bdi || !bdi->dev)
+		return bdi_unknown_name;
+	return dev_name(bdi->dev);
+}
+
 #endif	/* _LINUX_BACKING_DEV_H */
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index b463e2575117e..300afa559f467 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -66,8 +66,8 @@ TRACE_EVENT(writeback_dirty_page,
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    mapping ? dev_name(inode_to_bdi(mapping->host)->dev) : "(unknown)",
-			    32);
+			    bdi_dev_name(mapping ? inode_to_bdi(mapping->host) :
+					 NULL), 32);
 		__entry->ino = mapping ? mapping->host->i_ino : 0;
 		__entry->index = page->index;
 	),
@@ -96,8 +96,7 @@ DECLARE_EVENT_CLASS(writeback_dirty_inode_template,
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 
 		/* may be called for files on pseudo FSes w/ unregistered bdi */
-		strscpy_pad(__entry->name,
-			    bdi->dev ? dev_name(bdi->dev) : "(unknown)", 32);
+		strscpy_pad(__entry->name, bdi_dev_name(bdi), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->flags		= flags;
@@ -177,7 +176,7 @@ DECLARE_EVENT_CLASS(writeback_write_inode_template,
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    dev_name(inode_to_bdi(inode)->dev), 32);
+			    bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->sync_mode	= wbc->sync_mode;
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
@@ -220,9 +219,7 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 		__field(unsigned int, cgroup_ino)
 	),
 	TP_fast_assign(
-		strscpy_pad(__entry->name,
-			    wb->bdi->dev ? dev_name(wb->bdi->dev) :
-			    "(unknown)", 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->nr_pages = work->nr_pages;
 		__entry->sb_dev = work->sb ? work->sb->s_dev : 0;
 		__entry->sync_mode = work->sync_mode;
@@ -275,7 +272,7 @@ DECLARE_EVENT_CLASS(writeback_class,
 		__field(unsigned int, cgroup_ino)
 	),
 	TP_fast_assign(
-		strscpy_pad(__entry->name, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->cgroup_ino = __trace_wb_assign_cgroup(wb);
 	),
 	TP_printk("bdi %s: cgroup_ino=%u",
@@ -297,7 +294,7 @@ TRACE_EVENT(writeback_bdi_register,
 		__array(char, name, 32)
 	),
 	TP_fast_assign(
-		strscpy_pad(__entry->name, dev_name(bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(bdi), 32);
 	),
 	TP_printk("bdi %s",
 		__entry->name
@@ -322,7 +319,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 	),
 
 	TP_fast_assign(
-		strscpy_pad(__entry->name, dev_name(bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(bdi), 32);
 		__entry->nr_to_write	= wbc->nr_to_write;
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->sync_mode	= wbc->sync_mode;
@@ -373,7 +370,7 @@ TRACE_EVENT(writeback_queue_io,
 		__field(unsigned int,	cgroup_ino)
 	),
 	TP_fast_assign(
-		strncpy_pad(__entry->name, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->older	= dirtied_before;
 		__entry->age	= (jiffies - dirtied_before) * 1000 / HZ;
 		__entry->moved	= moved;
@@ -458,7 +455,7 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 	),
 
 	TP_fast_assign(
-		strscpy_pad(__entry->bdi, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 		__entry->write_bw	= KBps(wb->write_bandwidth);
 		__entry->avg_write_bw	= KBps(wb->avg_write_bandwidth);
 		__entry->dirty_rate	= KBps(dirty_rate);
@@ -523,7 +520,7 @@ TRACE_EVENT(balance_dirty_pages,
 
 	TP_fast_assign(
 		unsigned long freerun = (thresh + bg_thresh) / 2;
-		strscpy_pad(__entry->bdi, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 
 		__entry->limit		= global_wb_domain.dirty_limit;
 		__entry->setpoint	= (global_wb_domain.dirty_limit +
@@ -584,7 +581,7 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    dev_name(inode_to_bdi(inode)->dev), 32);
+			    bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
@@ -658,7 +655,7 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    dev_name(inode_to_bdi(inode)->dev), 32);
+			    bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 72e6d0c55cfad..0a970be24a28d 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -19,6 +19,7 @@ struct backing_dev_info noop_backing_dev_info = {
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
 static struct class *bdi_class;
+const char *bdi_unknown_name = "(unknown)";
 
 /*
  * bdi_lock protects updates to bdi_list. bdi_list has RCU reader side
-- 
2.27.0



