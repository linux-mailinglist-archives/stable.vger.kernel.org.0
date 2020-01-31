Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF5D14E89A
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgAaGLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8E87206A2;
        Fri, 31 Jan 2020 06:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580451065;
        bh=N7OHm/VqCm5qgaf0tHVNN1wmpHdquIzIEPJgdWkVlcw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=emuz966esjhXXbYVVExKLghskWcheGDjwKBDy7wyxfsQy0I09dXJRqQjWnT0NNY0p
         EXSbZXj20UkLnU8dEe7VpYcAX7HKMVUgN8A2vELGr7VgQxICHg3rfd5h54ewfmE367
         6wQ4qvhi4bRyCqmZaYt1KeWWV0U9EPZq+N+hIm9U=
Date:   Thu, 30 Jan 2020 22:11:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, clm@fb.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, tytso@mit.edu
Subject:  [patch 002/118] memcg: fix a crash in wb_workfn when a
 device disappears
Message-ID: <20200131061104.0SpfKNUrL%akpm@linux-foundation.org>
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Theodore Ts'o" <tytso@mit.edu>
Subject: memcg: fix a crash in wb_workfn when a device disappears

Without memcg, there is a one-to-one mapping between the bdi and
bdi_writeback structures.  In this world, things are fairly
straightforward; the first thing bdi_unregister() does is to shutdown the
bdi_writeback structure (or wb), and part of that writeback ensures that
no other work queued against the wb, and that the wb is fully drained.

With memcg, however, there is a one-to-many relationship between the bdi
and bdi_writeback structures; that is, there are multiple wb objects which
can all point to a single bdi.  There is a refcount which prevents the bdi
object from being released (and hence, unregistered).  So in theory, the
bdi_unregister() *should* only get called once its refcount goes to zero
(bdi_put will drop the refcount, and when it is zero, release_bdi gets
called, which calls bdi_unregister).

Unfortunately, del_gendisk() in block/gen_hd.c never got the memo about
the Brave New memcg World, and calls bdi_unregister directly.  It does
this without informing the file system, or the memcg code, or anything
else.  This causes the root wb associated with the bdi to be unregistered,
but none of the memcg-specific wb's are shutdown.  So when one of these
wb's are woken up to do delayed work, they try to dereference their
wb->bdi->dev to fetch the device name, but unfortunately bdi->dev is now
NULL, thanks to the bdi_unregister() called by del_gendisk().  As a
result, *boom*.

Fortunately, it looks like the rest of the writeback path is perfectly
happy with bdi->dev and bdi->owner being NULL, so the simplest fix is to
create a bdi_dev_name() function which can handle bdi->dev being NULL. 
This also allows us to bulletproof the writeback tracepoints to prevent
them from dereferencing a NULL pointer and crashing the kernel if one is
tracing with memcg's enabled, and an iSCSI device dies or a USB storage
stick is pulled.

The most common way of triggering this will be hotremoval of a device
while writeback with memcg enabled is going on.  It was triggering several
times a day in a heavily loaded production environment.

Google Bug Id: 145475544

Link: https://lore.kernel.org/r/20191227194829.150110-1-tytso@mit.edu
Link: http://lkml.kernel.org/r/20191228005211.163952-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |    2 -
 include/linux/backing-dev.h      |   10 +++++++
 include/trace/events/writeback.h |   37 +++++++++++++----------------
 mm/backing-dev.c                 |    1 
 4 files changed, 29 insertions(+), 21 deletions(-)

--- a/fs/fs-writeback.c~memcg-fix-a-crash-in-wb_workfn-when-a-device-disappears
+++ a/fs/fs-writeback.c
@@ -2063,7 +2063,7 @@ void wb_workfn(struct work_struct *work)
 						struct bdi_writeback, dwork);
 	long pages_written;
 
-	set_worker_desc("flush-%s", dev_name(wb->bdi->dev));
+	set_worker_desc("flush-%s", bdi_dev_name(wb->bdi));
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
--- a/include/linux/backing-dev.h~memcg-fix-a-crash-in-wb_workfn-when-a-device-disappears
+++ a/include/linux/backing-dev.h
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/blkdev.h>
+#include <linux/device.h>
 #include <linux/writeback.h>
 #include <linux/blk-cgroup.h>
 #include <linux/backing-dev-defs.h>
@@ -504,4 +505,13 @@ static inline int bdi_rw_congested(struc
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
--- a/include/trace/events/writeback.h~memcg-fix-a-crash-in-wb_workfn-when-a-device-disappears
+++ a/include/trace/events/writeback.h
@@ -67,8 +67,8 @@ DECLARE_EVENT_CLASS(writeback_page_templ
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    mapping ? dev_name(inode_to_bdi(mapping->host)->dev) : "(unknown)",
-			    32);
+			    bdi_dev_name(mapping ? inode_to_bdi(mapping->host) :
+					 NULL), 32);
 		__entry->ino = mapping ? mapping->host->i_ino : 0;
 		__entry->index = page->index;
 	),
@@ -111,8 +111,7 @@ DECLARE_EVENT_CLASS(writeback_dirty_inod
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 
 		/* may be called for files on pseudo FSes w/ unregistered bdi */
-		strscpy_pad(__entry->name,
-			    bdi->dev ? dev_name(bdi->dev) : "(unknown)", 32);
+		strscpy_pad(__entry->name, bdi_dev_name(bdi), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->flags		= flags;
@@ -193,7 +192,7 @@ TRACE_EVENT(inode_foreign_history,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(inode_to_bdi(inode)->dev), 32);
+		strncpy(__entry->name, bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
 		__entry->history	= history;
@@ -222,7 +221,7 @@ TRACE_EVENT(inode_switch_wbs,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,	dev_name(old_wb->bdi->dev), 32);
+		strncpy(__entry->name,	bdi_dev_name(old_wb->bdi), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->old_cgroup_ino	= __trace_wb_assign_cgroup(old_wb);
 		__entry->new_cgroup_ino	= __trace_wb_assign_cgroup(new_wb);
@@ -255,7 +254,7 @@ TRACE_EVENT(track_foreign_dirty,
 		struct address_space *mapping = page_mapping(page);
 		struct inode *inode = mapping ? mapping->host : NULL;
 
-		strncpy(__entry->name,	dev_name(wb->bdi->dev), 32);
+		strncpy(__entry->name,	bdi_dev_name(wb->bdi), 32);
 		__entry->bdi_id		= wb->bdi->id;
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
@@ -288,7 +287,7 @@ TRACE_EVENT(flush_foreign,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,	dev_name(wb->bdi->dev), 32);
+		strncpy(__entry->name,	bdi_dev_name(wb->bdi), 32);
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
 		__entry->frn_bdi_id	= frn_bdi_id;
 		__entry->frn_memcg_id	= frn_memcg_id;
@@ -318,7 +317,7 @@ DECLARE_EVENT_CLASS(writeback_write_inod
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    dev_name(inode_to_bdi(inode)->dev), 32);
+			    bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->sync_mode	= wbc->sync_mode;
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
@@ -361,9 +360,7 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		__field(ino_t, cgroup_ino)
 	),
 	TP_fast_assign(
-		strscpy_pad(__entry->name,
-			    wb->bdi->dev ? dev_name(wb->bdi->dev) :
-			    "(unknown)", 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->nr_pages = work->nr_pages;
 		__entry->sb_dev = work->sb ? work->sb->s_dev : 0;
 		__entry->sync_mode = work->sync_mode;
@@ -416,7 +413,7 @@ DECLARE_EVENT_CLASS(writeback_class,
 		__field(ino_t, cgroup_ino)
 	),
 	TP_fast_assign(
-		strscpy_pad(__entry->name, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->cgroup_ino = __trace_wb_assign_cgroup(wb);
 	),
 	TP_printk("bdi %s: cgroup_ino=%lu",
@@ -438,7 +435,7 @@ TRACE_EVENT(writeback_bdi_register,
 		__array(char, name, 32)
 	),
 	TP_fast_assign(
-		strscpy_pad(__entry->name, dev_name(bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(bdi), 32);
 	),
 	TP_printk("bdi %s",
 		__entry->name
@@ -463,7 +460,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 	),
 
 	TP_fast_assign(
-		strscpy_pad(__entry->name, dev_name(bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(bdi), 32);
 		__entry->nr_to_write	= wbc->nr_to_write;
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->sync_mode	= wbc->sync_mode;
@@ -514,7 +511,7 @@ TRACE_EVENT(writeback_queue_io,
 	),
 	TP_fast_assign(
 		unsigned long *older_than_this = work->older_than_this;
-		strscpy_pad(__entry->name, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->older	= older_than_this ?  *older_than_this : 0;
 		__entry->age	= older_than_this ?
 				  (jiffies - *older_than_this) * 1000 / HZ : -1;
@@ -600,7 +597,7 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 	),
 
 	TP_fast_assign(
-		strscpy_pad(__entry->bdi, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 		__entry->write_bw	= KBps(wb->write_bandwidth);
 		__entry->avg_write_bw	= KBps(wb->avg_write_bandwidth);
 		__entry->dirty_rate	= KBps(dirty_rate);
@@ -665,7 +662,7 @@ TRACE_EVENT(balance_dirty_pages,
 
 	TP_fast_assign(
 		unsigned long freerun = (thresh + bg_thresh) / 2;
-		strscpy_pad(__entry->bdi, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 
 		__entry->limit		= global_wb_domain.dirty_limit;
 		__entry->setpoint	= (global_wb_domain.dirty_limit +
@@ -726,7 +723,7 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    dev_name(inode_to_bdi(inode)->dev), 32);
+			    bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
@@ -800,7 +797,7 @@ DECLARE_EVENT_CLASS(writeback_single_ino
 
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
-			    dev_name(inode_to_bdi(inode)->dev), 32);
+			    bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
--- a/mm/backing-dev.c~memcg-fix-a-crash-in-wb_workfn-when-a-device-disappears
+++ a/mm/backing-dev.c
@@ -21,6 +21,7 @@ struct backing_dev_info noop_backing_dev
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
 static struct class *bdi_class;
+const char *bdi_unknown_name = "(unknown)";
 
 /*
  * bdi_lock protects bdi_tree and updates to bdi_list. bdi_list has RCU
_
