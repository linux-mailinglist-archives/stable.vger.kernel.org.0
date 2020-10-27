Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4229BDC2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812938AbgJ0Qqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798640AbgJ0Plk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E83922403;
        Tue, 27 Oct 2020 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813297;
        bh=sOBfROZy+sZq87PsvuQXqPc3XHKYsXiIuMFcVsdy/JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mis2Va0SnGx3FpnV0V1HRtz7fZYnJOUYXicDFT2WU2+kcr+lyyanVUwK7pIxf6bi8
         bje+tDrO73rTxvNJ0/Wi0/SzP1Gxmfnq60wUKIwGBMo6/6fnxslgDMN+TxxfuZxBu/
         Q57VTJ1qSJSUf3OpRZOPXeSO/hsX7bOgQP2SddqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 503/757] afs: Fix cell refcounting by splitting the usage counter
Date:   Tue, 27 Oct 2020 14:52:33 +0100
Message-Id: <20201027135514.047214280@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 88c853c3f5c0a07c5db61b494ee25152535cfeee ]

Management of the lifetime of afs_cell struct has some problems due to the
usage counter being used to determine whether objects of that type are in
use in addition to whether anyone might be interested in the structure.

This is made trickier by cell objects being cached for a period of time in
case they're quickly reused as they hold the result of a setup process that
may be slow (DNS lookups, AFS RPC ops).

Problems include the cached root volume from alias resolution pinning its
parent cell record, rmmod occasionally hanging and occasionally producing
assertion failures.

Fix this by splitting the count of active users from the struct reference
count.  Things then work as follows:

 (1) The cell cache keeps +1 on the cell's activity count and this has to
     be dropped before the cell can be removed.  afs_manage_cell() tries to
     exchange the 1 to a 0 with the cells_lock write-locked, and if
     successful, the record is removed from the net->cells.

 (2) One struct ref is 'owned' by the activity count.  That is put when the
     active count is reduced to 0 (final_destruction label).

 (3) A ref can be held on a cell whilst it is queued for management on a
     work queue without confusing the active count.  afs_queue_cell() is
     added to wrap this.

 (4) The queue's ref is dropped at the end of the management.  This is
     split out into a separate function, afs_manage_cell_work().

 (5) The root volume record is put after a cell is removed (at the
     final_destruction label) rather then in the RCU destruction routine.

 (6) Volumes hold struct refs, but aren't active users.

 (7) Both counts are displayed in /proc/net/afs/cells.

There are some management function changes:

 (*) afs_put_cell() now just decrements the refcount and triggers the RCU
     destruction if it becomes 0.  It no longer sets a timer to have the
     manager do this.

 (*) afs_use_cell() and afs_unuse_cell() are added to increase and decrease
     the active count.  afs_unuse_cell() sets the management timer.

 (*) afs_queue_cell() is added to queue a cell with approprate refs.

There are also some other fixes:

 (*) Don't let /proc/net/afs/cells access a cell's vllist if it's NULL.

 (*) Make sure that candidate cells in lookups are properly destroyed
     rather than being simply kfree'd.  This ensures the bits it points to
     are destroyed also.

 (*) afs_dec_cells_outstanding() is now called in cell destruction rather
     than at "final_destruction".  This ensures that cell->net is still
     valid to the end of the destructor.

 (*) As a consequence of the previous two changes, move the increment of
     net->cells_outstanding that was at the point of insertion into the
     tree to the allocation routine to correctly balance things.

Fixes: 989782dcdc91 ("afs: Overhaul cell database management")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c      | 149 +++++++++++++++++++++++++++++++--------------
 fs/afs/dynroot.c   |   2 +-
 fs/afs/internal.h  |   8 ++-
 fs/afs/mntpt.c     |   4 +-
 fs/afs/proc.c      |  23 ++++---
 fs/afs/super.c     |  12 ++--
 fs/afs/vl_alias.c  |   8 +--
 fs/afs/vl_rotate.c |   2 +-
 fs/afs/volume.c    |   4 +-
 9 files changed, 136 insertions(+), 76 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 5da83e84952a2..c906000b0ff84 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -19,7 +19,7 @@ static unsigned __read_mostly afs_cell_gc_delay = 10;
 static unsigned __read_mostly afs_cell_min_ttl = 10 * 60;
 static unsigned __read_mostly afs_cell_max_ttl = 24 * 60 * 60;
 
-static void afs_manage_cell(struct work_struct *);
+static void afs_manage_cell_work(struct work_struct *);
 
 static void afs_dec_cells_outstanding(struct afs_net *net)
 {
@@ -62,8 +62,7 @@ static struct afs_cell *afs_find_cell_locked(struct afs_net *net,
 		cell = net->ws_cell;
 		if (!cell)
 			return ERR_PTR(-EDESTADDRREQ);
-		afs_get_cell(cell);
-		return cell;
+		goto found;
 	}
 
 	p = net->cells.rb_node;
@@ -85,12 +84,12 @@ static struct afs_cell *afs_find_cell_locked(struct afs_net *net,
 	return ERR_PTR(-ENOENT);
 
 found:
-	if (!atomic_inc_not_zero(&cell->usage))
-		return ERR_PTR(-ENOENT);
-
-	return cell;
+	return afs_use_cell(cell);
 }
 
+/*
+ * Look up and get an activation reference on a cell record.
+ */
 struct afs_cell *afs_find_cell(struct afs_net *net,
 			       const char *name, unsigned int namesz)
 {
@@ -153,8 +152,9 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 		cell->name[i] = tolower(name[i]);
 	cell->name[i] = 0;
 
-	atomic_set(&cell->usage, 2);
-	INIT_WORK(&cell->manager, afs_manage_cell);
+	atomic_set(&cell->ref, 1);
+	atomic_set(&cell->active, 0);
+	INIT_WORK(&cell->manager, afs_manage_cell_work);
 	cell->volumes = RB_ROOT;
 	INIT_HLIST_HEAD(&cell->proc_volumes);
 	seqlock_init(&cell->volume_lock);
@@ -193,6 +193,7 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 	cell->dns_source = vllist->source;
 	cell->dns_status = vllist->status;
 	smp_store_release(&cell->dns_lookup_count, 1); /* vs source/status */
+	atomic_inc(&net->cells_outstanding);
 
 	_leave(" = %p", cell);
 	return cell;
@@ -275,12 +276,12 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 
 	cell = candidate;
 	candidate = NULL;
+	atomic_set(&cell->active, 2);
 	rb_link_node_rcu(&cell->net_node, parent, pp);
 	rb_insert_color(&cell->net_node, &net->cells);
-	atomic_inc(&net->cells_outstanding);
 	up_write(&net->cells_lock);
 
-	queue_work(afs_wq, &cell->manager);
+	afs_queue_cell(cell);
 
 wait_for_cell:
 	_debug("wait_for_cell");
@@ -305,16 +306,17 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 	if (excl) {
 		ret = -EEXIST;
 	} else {
-		afs_get_cell(cursor);
+		afs_use_cell(cursor);
 		ret = 0;
 	}
 	up_write(&net->cells_lock);
-	kfree(candidate);
+	if (candidate)
+		afs_put_cell(candidate);
 	if (ret == 0)
 		goto wait_for_cell;
 	goto error_noput;
 error:
-	afs_put_cell(net, cell);
+	afs_unuse_cell(net, cell);
 error_noput:
 	_leave(" = %d [error]", ret);
 	return ERR_PTR(ret);
@@ -359,7 +361,7 @@ int afs_cell_init(struct afs_net *net, const char *rootcell)
 	}
 
 	if (!test_and_set_bit(AFS_CELL_FL_NO_GC, &new_root->flags))
-		afs_get_cell(new_root);
+		afs_use_cell(new_root);
 
 	/* install the new cell */
 	down_write(&net->cells_lock);
@@ -367,7 +369,7 @@ int afs_cell_init(struct afs_net *net, const char *rootcell)
 	net->ws_cell = new_root;
 	up_write(&net->cells_lock);
 
-	afs_put_cell(net, old_root);
+	afs_unuse_cell(net, old_root);
 	_leave(" = 0");
 	return 0;
 }
@@ -473,18 +475,21 @@ static int afs_update_cell(struct afs_cell *cell)
 static void afs_cell_destroy(struct rcu_head *rcu)
 {
 	struct afs_cell *cell = container_of(rcu, struct afs_cell, rcu);
+	struct afs_net *net = cell->net;
+	int u;
 
 	_enter("%p{%s}", cell, cell->name);
 
-	ASSERTCMP(atomic_read(&cell->usage), ==, 0);
+	u = atomic_read(&cell->ref);
+	ASSERTCMP(u, ==, 0);
 
-	afs_put_volume(cell->net, cell->root_volume, afs_volume_trace_put_cell_root);
-	afs_put_vlserverlist(cell->net, rcu_access_pointer(cell->vl_servers));
-	afs_put_cell(cell->net, cell->alias_of);
+	afs_put_vlserverlist(net, rcu_access_pointer(cell->vl_servers));
+	afs_unuse_cell(net, cell->alias_of);
 	key_put(cell->anonymous_key);
 	kfree(cell->name);
 	kfree(cell);
 
+	afs_dec_cells_outstanding(net);
 	_leave(" [destroyed]");
 }
 
@@ -519,16 +524,50 @@ void afs_cells_timer(struct timer_list *timer)
  */
 struct afs_cell *afs_get_cell(struct afs_cell *cell)
 {
-	atomic_inc(&cell->usage);
+	if (atomic_read(&cell->ref) <= 0)
+		BUG();
+
+	atomic_inc(&cell->ref);
 	return cell;
 }
 
 /*
  * Drop a reference on a cell record.
  */
-void afs_put_cell(struct afs_net *net, struct afs_cell *cell)
+void afs_put_cell(struct afs_cell *cell)
+{
+	if (cell) {
+		unsigned int u, a;
+
+		u = atomic_dec_return(&cell->ref);
+		if (u == 0) {
+			a = atomic_read(&cell->active);
+			WARN(a != 0, "Cell active count %u > 0\n", a);
+			call_rcu(&cell->rcu, afs_cell_destroy);
+		}
+	}
+}
+
+/*
+ * Note a cell becoming more active.
+ */
+struct afs_cell *afs_use_cell(struct afs_cell *cell)
+{
+	if (atomic_read(&cell->ref) <= 0)
+		BUG();
+
+	atomic_inc(&cell->active);
+	return cell;
+}
+
+/*
+ * Record a cell becoming less active.  When the active counter reaches 1, it
+ * is scheduled for destruction, but may get reactivated.
+ */
+void afs_unuse_cell(struct afs_net *net, struct afs_cell *cell)
 {
 	time64_t now, expire_delay;
+	int a;
 
 	if (!cell)
 		return;
@@ -541,11 +580,21 @@ void afs_put_cell(struct afs_net *net, struct afs_cell *cell)
 	if (cell->vl_servers->nr_servers)
 		expire_delay = afs_cell_gc_delay;
 
-	if (atomic_dec_return(&cell->usage) > 1)
-		return;
+	a = atomic_dec_return(&cell->active);
+	WARN_ON(a == 0);
+	if (a == 1)
+		/* 'cell' may now be garbage collected. */
+		afs_set_cell_timer(net, expire_delay);
+}
 
-	/* 'cell' may now be garbage collected. */
-	afs_set_cell_timer(net, expire_delay);
+/*
+ * Queue a cell for management, giving the workqueue a ref to hold.
+ */
+void afs_queue_cell(struct afs_cell *cell)
+{
+	afs_get_cell(cell);
+	if (!queue_work(afs_wq, &cell->manager))
+		afs_put_cell(cell);
 }
 
 /*
@@ -645,12 +694,11 @@ static void afs_deactivate_cell(struct afs_net *net, struct afs_cell *cell)
  * Manage a cell record, initialising and destroying it, maintaining its DNS
  * records.
  */
-static void afs_manage_cell(struct work_struct *work)
+static void afs_manage_cell(struct afs_cell *cell)
 {
-	struct afs_cell *cell = container_of(work, struct afs_cell, manager);
 	struct afs_net *net = cell->net;
 	bool deleted;
-	int ret, usage;
+	int ret, active;
 
 	_enter("%s", cell->name);
 
@@ -660,10 +708,11 @@ static void afs_manage_cell(struct work_struct *work)
 	case AFS_CELL_INACTIVE:
 	case AFS_CELL_FAILED:
 		down_write(&net->cells_lock);
-		usage = 1;
-		deleted = atomic_try_cmpxchg_relaxed(&cell->usage, &usage, 0);
-		if (deleted)
+		active = 1;
+		deleted = atomic_try_cmpxchg_relaxed(&cell->active, &active, 0);
+		if (deleted) {
 			rb_erase(&cell->net_node, &net->cells);
+		}
 		up_write(&net->cells_lock);
 		if (deleted)
 			goto final_destruction;
@@ -688,7 +737,7 @@ static void afs_manage_cell(struct work_struct *work)
 		goto again;
 
 	case AFS_CELL_ACTIVE:
-		if (atomic_read(&cell->usage) > 1) {
+		if (atomic_read(&cell->active) > 1) {
 			if (test_and_clear_bit(AFS_CELL_FL_DO_LOOKUP, &cell->flags)) {
 				ret = afs_update_cell(cell);
 				if (ret < 0)
@@ -701,7 +750,7 @@ static void afs_manage_cell(struct work_struct *work)
 		goto again;
 
 	case AFS_CELL_DEACTIVATING:
-		if (atomic_read(&cell->usage) > 1)
+		if (atomic_read(&cell->active) > 1)
 			goto reverse_deactivation;
 		afs_deactivate_cell(net, cell);
 		smp_store_release(&cell->state, AFS_CELL_INACTIVE);
@@ -733,9 +782,18 @@ static void afs_manage_cell(struct work_struct *work)
 	return;
 
 final_destruction:
-	call_rcu(&cell->rcu, afs_cell_destroy);
-	afs_dec_cells_outstanding(net);
-	_leave(" [destruct %d]", atomic_read(&net->cells_outstanding));
+	/* The root volume is pinning the cell */
+	afs_put_volume(cell->net, cell->root_volume, afs_volume_trace_put_cell_root);
+	cell->root_volume = NULL;
+	afs_put_cell(cell);
+}
+
+static void afs_manage_cell_work(struct work_struct *work)
+{
+	struct afs_cell *cell = container_of(work, struct afs_cell, manager);
+
+	afs_manage_cell(cell);
+	afs_put_cell(cell);
 }
 
 /*
@@ -769,21 +827,20 @@ void afs_manage_cells(struct work_struct *work)
 	for (cursor = rb_first(&net->cells); cursor; cursor = rb_next(cursor)) {
 		struct afs_cell *cell =
 			rb_entry(cursor, struct afs_cell, net_node);
-		unsigned usage;
+		unsigned active;
 		bool sched_cell = false;
 
-		usage = atomic_read(&cell->usage);
-		_debug("manage %s %u", cell->name, usage);
+		active = atomic_read(&cell->active);
+		_debug("manage %s %u %u", cell->name, atomic_read(&cell->ref), active);
 
-		ASSERTCMP(usage, >=, 1);
+		ASSERTCMP(active, >=, 1);
 
 		if (purging) {
 			if (test_and_clear_bit(AFS_CELL_FL_NO_GC, &cell->flags))
-				usage = atomic_dec_return(&cell->usage);
-			ASSERTCMP(usage, ==, 1);
+				atomic_dec(&cell->active);
 		}
 
-		if (usage == 1) {
+		if (active == 1) {
 			struct afs_vlserver_list *vllist;
 			time64_t expire_at = cell->last_inactive;
 
@@ -806,7 +863,7 @@ void afs_manage_cells(struct work_struct *work)
 		}
 
 		if (sched_cell)
-			queue_work(afs_wq, &cell->manager);
+			afs_queue_cell(cell);
 	}
 
 	up_read(&net->cells_lock);
@@ -843,7 +900,7 @@ void afs_cell_purge(struct afs_net *net)
 	ws = net->ws_cell;
 	net->ws_cell = NULL;
 	up_write(&net->cells_lock);
-	afs_put_cell(net, ws);
+	afs_unuse_cell(net, ws);
 
 	_debug("del timer");
 	if (del_timer_sync(&net->cells_timer))
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index 5b8de4fee6cda..da32797dd4257 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -125,7 +125,7 @@ static int afs_probe_cell_name(struct dentry *dentry)
 
 	cell = afs_find_cell(net, name, len);
 	if (!IS_ERR(cell)) {
-		afs_put_cell(net, cell);
+		afs_unuse_cell(net, cell);
 		return 0;
 	}
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 257c0f07742fb..0363511290c8d 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -363,7 +363,8 @@ struct afs_cell {
 #endif
 	time64_t		dns_expiry;	/* Time AFSDB/SRV record expires */
 	time64_t		last_inactive;	/* Time of last drop of usage count */
-	atomic_t		usage;
+	atomic_t		ref;		/* Struct refcount */
+	atomic_t		active;		/* Active usage counter */
 	unsigned long		flags;
 #define AFS_CELL_FL_NO_GC	0		/* The cell was added manually, don't auto-gc */
 #define AFS_CELL_FL_DO_LOOKUP	1		/* DNS lookup requested */
@@ -920,8 +921,11 @@ extern int afs_cell_init(struct afs_net *, const char *);
 extern struct afs_cell *afs_find_cell(struct afs_net *, const char *, unsigned);
 extern struct afs_cell *afs_lookup_cell(struct afs_net *, const char *, unsigned,
 					const char *, bool);
+extern struct afs_cell *afs_use_cell(struct afs_cell *);
+extern void afs_unuse_cell(struct afs_net *, struct afs_cell *);
 extern struct afs_cell *afs_get_cell(struct afs_cell *);
-extern void afs_put_cell(struct afs_net *, struct afs_cell *);
+extern void afs_put_cell(struct afs_cell *);
+extern void afs_queue_cell(struct afs_cell *);
 extern void afs_manage_cells(struct work_struct *);
 extern void afs_cells_timer(struct timer_list *);
 extern void __net_exit afs_cell_purge(struct afs_net *);
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index 79bc5f1338edf..c69a0282960cc 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -88,7 +88,7 @@ static int afs_mntpt_set_params(struct fs_context *fc, struct dentry *mntpt)
 		ctx->force = true;
 	}
 	if (ctx->cell) {
-		afs_put_cell(ctx->net, ctx->cell);
+		afs_unuse_cell(ctx->net, ctx->cell);
 		ctx->cell = NULL;
 	}
 	if (test_bit(AFS_VNODE_PSEUDODIR, &vnode->flags)) {
@@ -124,7 +124,7 @@ static int afs_mntpt_set_params(struct fs_context *fc, struct dentry *mntpt)
 		char *buf;
 
 		if (src_as->cell)
-			ctx->cell = afs_get_cell(src_as->cell);
+			ctx->cell = afs_use_cell(src_as->cell);
 
 		if (size < 2 || size > PAGE_SIZE - 1)
 			return -EINVAL;
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index e8babb62ed442..76fbe0560cfb7 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -38,7 +38,7 @@ static int afs_proc_cells_show(struct seq_file *m, void *v)
 
 	if (v == SEQ_START_TOKEN) {
 		/* display header on line 1 */
-		seq_puts(m, "USE    TTL SV ST NAME\n");
+		seq_puts(m, "USE ACT    TTL SV ST NAME\n");
 		return 0;
 	}
 
@@ -46,10 +46,11 @@ static int afs_proc_cells_show(struct seq_file *m, void *v)
 	vllist = rcu_dereference(cell->vl_servers);
 
 	/* display one cell per line on subsequent lines */
-	seq_printf(m, "%3u %6lld %2u %2u %s\n",
-		   atomic_read(&cell->usage),
+	seq_printf(m, "%3u %3u %6lld %2u %2u %s\n",
+		   atomic_read(&cell->ref),
+		   atomic_read(&cell->active),
 		   cell->dns_expiry - ktime_get_real_seconds(),
-		   vllist->nr_servers,
+		   vllist ? vllist->nr_servers : 0,
 		   cell->state,
 		   cell->name);
 	return 0;
@@ -128,7 +129,7 @@ static int afs_proc_cells_write(struct file *file, char *buf, size_t size)
 		}
 
 		if (test_and_set_bit(AFS_CELL_FL_NO_GC, &cell->flags))
-			afs_put_cell(net, cell);
+			afs_unuse_cell(net, cell);
 	} else {
 		goto inval;
 	}
@@ -154,13 +155,11 @@ static int afs_proc_rootcell_show(struct seq_file *m, void *v)
 	struct afs_net *net;
 
 	net = afs_seq2net_single(m);
-	if (rcu_access_pointer(net->ws_cell)) {
-		rcu_read_lock();
-		cell = rcu_dereference(net->ws_cell);
-		if (cell)
-			seq_printf(m, "%s\n", cell->name);
-		rcu_read_unlock();
-	}
+	down_read(&net->cells_lock);
+	cell = net->ws_cell;
+	if (cell)
+		seq_printf(m, "%s\n", cell->name);
+	up_read(&net->cells_lock);
 	return 0;
 }
 
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 0be99016ecfb9..e72c223f831d2 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -294,7 +294,7 @@ static int afs_parse_source(struct fs_context *fc, struct fs_parameter *param)
 			       cellnamesz, cellnamesz, cellname ?: "");
 			return PTR_ERR(cell);
 		}
-		afs_put_cell(ctx->net, ctx->cell);
+		afs_unuse_cell(ctx->net, ctx->cell);
 		ctx->cell = cell;
 	}
 
@@ -389,8 +389,8 @@ static int afs_validate_fc(struct fs_context *fc)
 				_debug("switch to alias");
 				key_put(ctx->key);
 				ctx->key = NULL;
-				cell = afs_get_cell(ctx->cell->alias_of);
-				afs_put_cell(ctx->net, ctx->cell);
+				cell = afs_use_cell(ctx->cell->alias_of);
+				afs_unuse_cell(ctx->net, ctx->cell);
 				ctx->cell = cell;
 				goto reget_key;
 			}
@@ -508,7 +508,7 @@ static struct afs_super_info *afs_alloc_sbi(struct fs_context *fc)
 		if (ctx->dyn_root) {
 			as->dyn_root = true;
 		} else {
-			as->cell = afs_get_cell(ctx->cell);
+			as->cell = afs_use_cell(ctx->cell);
 			as->volume = afs_get_volume(ctx->volume,
 						    afs_volume_trace_get_alloc_sbi);
 		}
@@ -521,7 +521,7 @@ static void afs_destroy_sbi(struct afs_super_info *as)
 	if (as) {
 		struct afs_net *net = afs_net(as->net_ns);
 		afs_put_volume(net, as->volume, afs_volume_trace_put_destroy_sbi);
-		afs_put_cell(net, as->cell);
+		afs_unuse_cell(net, as->cell);
 		put_net(as->net_ns);
 		kfree(as);
 	}
@@ -607,7 +607,7 @@ static void afs_free_fc(struct fs_context *fc)
 
 	afs_destroy_sbi(fc->s_fs_info);
 	afs_put_volume(ctx->net, ctx->volume, afs_volume_trace_put_free_fc);
-	afs_put_cell(ctx->net, ctx->cell);
+	afs_unuse_cell(ctx->net, ctx->cell);
 	key_put(ctx->key);
 	kfree(ctx);
 }
diff --git a/fs/afs/vl_alias.c b/fs/afs/vl_alias.c
index 5082ef04e99c5..ddb4cb67d0fd9 100644
--- a/fs/afs/vl_alias.c
+++ b/fs/afs/vl_alias.c
@@ -177,7 +177,7 @@ static int afs_compare_cell_roots(struct afs_cell *cell)
 
 is_alias:
 	rcu_read_unlock();
-	cell->alias_of = afs_get_cell(p);
+	cell->alias_of = afs_use_cell(p);
 	return 1;
 }
 
@@ -247,18 +247,18 @@ static int afs_query_for_alias(struct afs_cell *cell, struct key *key)
 			continue;
 		if (p->root_volume)
 			continue; /* Ignore cells that have a root.cell volume. */
-		afs_get_cell(p);
+		afs_use_cell(p);
 		mutex_unlock(&cell->net->proc_cells_lock);
 
 		if (afs_query_for_alias_one(cell, key, p) != 0)
 			goto is_alias;
 
 		if (mutex_lock_interruptible(&cell->net->proc_cells_lock) < 0) {
-			afs_put_cell(cell->net, p);
+			afs_unuse_cell(cell->net, p);
 			return -ERESTARTSYS;
 		}
 
-		afs_put_cell(cell->net, p);
+		afs_unuse_cell(cell->net, p);
 	}
 
 	mutex_unlock(&cell->net->proc_cells_lock);
diff --git a/fs/afs/vl_rotate.c b/fs/afs/vl_rotate.c
index c0458c903b310..da3b072d4d638 100644
--- a/fs/afs/vl_rotate.c
+++ b/fs/afs/vl_rotate.c
@@ -45,7 +45,7 @@ static bool afs_start_vl_iteration(struct afs_vl_cursor *vc)
 	    cell->dns_expiry <= ktime_get_real_seconds()) {
 		dns_lookup_count = smp_load_acquire(&cell->dns_lookup_count);
 		set_bit(AFS_CELL_FL_DO_LOOKUP, &cell->flags);
-		queue_work(afs_wq, &cell->manager);
+		afs_queue_cell(cell);
 
 		if (cell->dns_source == DNS_RECORD_UNAVAILABLE) {
 			if (wait_var_event_interruptible(
diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 9bc0509e3634c..a838030e95634 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -106,7 +106,7 @@ static struct afs_volume *afs_alloc_volume(struct afs_fs_context *params,
 	return volume;
 
 error_1:
-	afs_put_cell(params->net, volume->cell);
+	afs_put_cell(volume->cell);
 	kfree(volume);
 error_0:
 	return ERR_PTR(ret);
@@ -228,7 +228,7 @@ static void afs_destroy_volume(struct afs_net *net, struct afs_volume *volume)
 
 	afs_remove_volume_from_cell(volume);
 	afs_put_serverlist(net, rcu_access_pointer(volume->servers));
-	afs_put_cell(net, volume->cell);
+	afs_put_cell(volume->cell);
 	trace_afs_volume(volume->vid, atomic_read(&volume->usage),
 			 afs_volume_trace_free);
 	kfree_rcu(volume, rcu);
-- 
2.25.1



