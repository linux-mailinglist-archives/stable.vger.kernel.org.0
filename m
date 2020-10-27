Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC029BDC4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812942AbgJ0Qqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801514AbgJ0Plf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0C82231B;
        Tue, 27 Oct 2020 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813292;
        bh=Ipbrfp+TB1YW9I7/mHmATpAiPXfxukvk59aH0x2vq+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrR213zQ91htPAFHvVU8JT+daM/AAn+PfadtGYdujN4q48tKvH3GStTLEg+rKOsVr
         ozXJ47G9SlIOMto8gA3YZslwG1kqz4zPRpBAuyZb2A5dX/+igjPmaHKwwiHunvn0V0
         xNyUUW7K4UEKQtz+pFVuyZ065db4f4a2FCXWbguU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+459a5dce0b4cb70fd076@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Hillf Danton <hdanton@sina.com>,
        syzkaller-bugs@googlegroups.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 502/757] afs: Fix rapid cell addition/removal by not using RCU on cells tree
Date:   Tue, 27 Oct 2020 14:52:32 +0100
Message-Id: <20201027135513.999516747@linuxfoundation.org>
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

[ Upstream commit 92e3cc91d8f51ce64a8b7c696377180953dd316e ]

There are a number of problems that are being seen by the rapidly mounting
and unmounting an afs dynamic root with an explicit cell and volume
specified (which should probably be rejected, but that's a separate issue):

What the tests are doing is to look up/create a cell record for the name
given and then tear it down again without actually using it to try to talk
to a server.  This is repeated endlessly, very fast, and the new cell
collides with the old one if it's not quick enough to reuse it.

It appears (as suggested by Hillf Danton) that the search through the RB
tree under a read_seqbegin_or_lock() under RCU conditions isn't safe and
that it's not blocking the write_seqlock(), despite taking two passes at
it.  He suggested that the code should take a ref on the cell it's
attempting to look at - but this shouldn't be necessary until we've
compared the cell names.  It's possible that I'm missing a barrier
somewhere.

However, using an RCU search for this is overkill, really - we only need to
access the cell name in a few places, and they're places where we're may
end up sleeping anyway.

Fix this by switching to an R/W semaphore instead.

Additionally, draw the down_read() call inside the function (renamed to
afs_find_cell()) since all the callers were taking the RCU read lock (or
should've been[*]).

[*] afs_probe_cell_name() should have been, but that doesn't appear to be
involved in the bug reports.

The symptoms of this look like:

	general protection fault, probably for non-canonical address 0xf27d208691691fdb: 0000 [#1] PREEMPT SMP KASAN
	KASAN: maybe wild-memory-access in range [0x93e924348b48fed8-0x93e924348b48fedf]
	...
	RIP: 0010:strncasecmp lib/string.c:52 [inline]
	RIP: 0010:strncasecmp+0x5f/0x240 lib/string.c:43
	 afs_lookup_cell_rcu+0x313/0x720 fs/afs/cell.c:88
	 afs_lookup_cell+0x2ee/0x1440 fs/afs/cell.c:249
	 afs_parse_source fs/afs/super.c:290 [inline]
	...

Fixes: 989782dcdc91 ("afs: Overhaul cell database management")
Reported-by: syzbot+459a5dce0b4cb70fd076@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hillf Danton <hdanton@sina.com>
cc: syzkaller-bugs@googlegroups.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c     | 131 ++++++++++++++++++++--------------------------
 fs/afs/dynroot.c  |  21 +++-----
 fs/afs/internal.h |   6 +--
 fs/afs/main.c     |   2 +-
 fs/afs/super.c    |   4 +-
 5 files changed, 71 insertions(+), 93 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 5b79cdceefa0f..5da83e84952a2 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -41,15 +41,15 @@ static void afs_set_cell_timer(struct afs_net *net, time64_t delay)
 }
 
 /*
- * Look up and get an activation reference on a cell record under RCU
- * conditions.  The caller must hold the RCU read lock.
+ * Look up and get an activation reference on a cell record.  The caller must
+ * hold net->cells_lock at least read-locked.
  */
-struct afs_cell *afs_lookup_cell_rcu(struct afs_net *net,
-				     const char *name, unsigned int namesz)
+static struct afs_cell *afs_find_cell_locked(struct afs_net *net,
+					     const char *name, unsigned int namesz)
 {
 	struct afs_cell *cell = NULL;
 	struct rb_node *p;
-	int n, seq = 0, ret = 0;
+	int n;
 
 	_enter("%*.*s", namesz, namesz, name);
 
@@ -58,61 +58,48 @@ struct afs_cell *afs_lookup_cell_rcu(struct afs_net *net,
 	if (namesz > AFS_MAXCELLNAME)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	do {
-		/* Unfortunately, rbtree walking doesn't give reliable results
-		 * under just the RCU read lock, so we have to check for
-		 * changes.
-		 */
-		if (cell)
-			afs_put_cell(net, cell);
-		cell = NULL;
-		ret = -ENOENT;
-
-		read_seqbegin_or_lock(&net->cells_lock, &seq);
-
-		if (!name) {
-			cell = rcu_dereference_raw(net->ws_cell);
-			if (cell) {
-				afs_get_cell(cell);
-				ret = 0;
-				break;
-			}
-			ret = -EDESTADDRREQ;
-			continue;
-		}
+	if (!name) {
+		cell = net->ws_cell;
+		if (!cell)
+			return ERR_PTR(-EDESTADDRREQ);
+		afs_get_cell(cell);
+		return cell;
+	}
 
-		p = rcu_dereference_raw(net->cells.rb_node);
-		while (p) {
-			cell = rb_entry(p, struct afs_cell, net_node);
-
-			n = strncasecmp(cell->name, name,
-					min_t(size_t, cell->name_len, namesz));
-			if (n == 0)
-				n = cell->name_len - namesz;
-			if (n < 0) {
-				p = rcu_dereference_raw(p->rb_left);
-			} else if (n > 0) {
-				p = rcu_dereference_raw(p->rb_right);
-			} else {
-				if (atomic_inc_not_zero(&cell->usage)) {
-					ret = 0;
-					break;
-				}
-				/* We want to repeat the search, this time with
-				 * the lock properly locked.
-				 */
-			}
-			cell = NULL;
-		}
+	p = net->cells.rb_node;
+	while (p) {
+		cell = rb_entry(p, struct afs_cell, net_node);
 
-	} while (need_seqretry(&net->cells_lock, seq));
+		n = strncasecmp(cell->name, name,
+				min_t(size_t, cell->name_len, namesz));
+		if (n == 0)
+			n = cell->name_len - namesz;
+		if (n < 0)
+			p = p->rb_left;
+		else if (n > 0)
+			p = p->rb_right;
+		else
+			goto found;
+	}
+
+	return ERR_PTR(-ENOENT);
 
-	done_seqretry(&net->cells_lock, seq);
+found:
+	if (!atomic_inc_not_zero(&cell->usage))
+		return ERR_PTR(-ENOENT);
 
-	if (ret != 0 && cell)
-		afs_put_cell(net, cell);
+	return cell;
+}
 
-	return ret == 0 ? cell : ERR_PTR(ret);
+struct afs_cell *afs_find_cell(struct afs_net *net,
+			       const char *name, unsigned int namesz)
+{
+	struct afs_cell *cell;
+
+	down_read(&net->cells_lock);
+	cell = afs_find_cell_locked(net, name, namesz);
+	up_read(&net->cells_lock);
+	return cell;
 }
 
 /*
@@ -245,9 +232,7 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 	_enter("%s,%s", name, vllist);
 
 	if (!excl) {
-		rcu_read_lock();
-		cell = afs_lookup_cell_rcu(net, name, namesz);
-		rcu_read_unlock();
+		cell = afs_find_cell(net, name, namesz);
 		if (!IS_ERR(cell))
 			goto wait_for_cell;
 	}
@@ -268,7 +253,7 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 	/* Find the insertion point and check to see if someone else added a
 	 * cell whilst we were allocating.
 	 */
-	write_seqlock(&net->cells_lock);
+	down_write(&net->cells_lock);
 
 	pp = &net->cells.rb_node;
 	parent = NULL;
@@ -293,7 +278,7 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 	rb_link_node_rcu(&cell->net_node, parent, pp);
 	rb_insert_color(&cell->net_node, &net->cells);
 	atomic_inc(&net->cells_outstanding);
-	write_sequnlock(&net->cells_lock);
+	up_write(&net->cells_lock);
 
 	queue_work(afs_wq, &cell->manager);
 
@@ -323,7 +308,7 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 		afs_get_cell(cursor);
 		ret = 0;
 	}
-	write_sequnlock(&net->cells_lock);
+	up_write(&net->cells_lock);
 	kfree(candidate);
 	if (ret == 0)
 		goto wait_for_cell;
@@ -377,10 +362,10 @@ int afs_cell_init(struct afs_net *net, const char *rootcell)
 		afs_get_cell(new_root);
 
 	/* install the new cell */
-	write_seqlock(&net->cells_lock);
-	old_root = rcu_access_pointer(net->ws_cell);
-	rcu_assign_pointer(net->ws_cell, new_root);
-	write_sequnlock(&net->cells_lock);
+	down_write(&net->cells_lock);
+	old_root = net->ws_cell;
+	net->ws_cell = new_root;
+	up_write(&net->cells_lock);
 
 	afs_put_cell(net, old_root);
 	_leave(" = 0");
@@ -674,12 +659,12 @@ static void afs_manage_cell(struct work_struct *work)
 	switch (cell->state) {
 	case AFS_CELL_INACTIVE:
 	case AFS_CELL_FAILED:
-		write_seqlock(&net->cells_lock);
+		down_write(&net->cells_lock);
 		usage = 1;
 		deleted = atomic_try_cmpxchg_relaxed(&cell->usage, &usage, 0);
 		if (deleted)
 			rb_erase(&cell->net_node, &net->cells);
-		write_sequnlock(&net->cells_lock);
+		up_write(&net->cells_lock);
 		if (deleted)
 			goto final_destruction;
 		if (cell->state == AFS_CELL_FAILED)
@@ -779,7 +764,7 @@ void afs_manage_cells(struct work_struct *work)
 	 * lack of use and cells whose DNS results have expired and dispatch
 	 * their managers.
 	 */
-	read_seqlock_excl(&net->cells_lock);
+	down_read(&net->cells_lock);
 
 	for (cursor = rb_first(&net->cells); cursor; cursor = rb_next(cursor)) {
 		struct afs_cell *cell =
@@ -824,7 +809,7 @@ void afs_manage_cells(struct work_struct *work)
 			queue_work(afs_wq, &cell->manager);
 	}
 
-	read_sequnlock_excl(&net->cells_lock);
+	up_read(&net->cells_lock);
 
 	/* Update the timer on the way out.  We have to pass an increment on
 	 * cells_outstanding in the namespace that we are in to the timer or
@@ -854,10 +839,10 @@ void afs_cell_purge(struct afs_net *net)
 
 	_enter("");
 
-	write_seqlock(&net->cells_lock);
-	ws = rcu_access_pointer(net->ws_cell);
-	RCU_INIT_POINTER(net->ws_cell, NULL);
-	write_sequnlock(&net->cells_lock);
+	down_write(&net->cells_lock);
+	ws = net->ws_cell;
+	net->ws_cell = NULL;
+	up_write(&net->cells_lock);
 	afs_put_cell(net, ws);
 
 	_debug("del timer");
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index 7b784af604fd9..5b8de4fee6cda 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -123,7 +123,7 @@ static int afs_probe_cell_name(struct dentry *dentry)
 		len--;
 	}
 
-	cell = afs_lookup_cell_rcu(net, name, len);
+	cell = afs_find_cell(net, name, len);
 	if (!IS_ERR(cell)) {
 		afs_put_cell(net, cell);
 		return 0;
@@ -179,7 +179,6 @@ static struct dentry *afs_lookup_atcell(struct dentry *dentry)
 	struct afs_cell *cell;
 	struct afs_net *net = afs_d2net(dentry);
 	struct dentry *ret;
-	unsigned int seq = 0;
 	char *name;
 	int len;
 
@@ -191,17 +190,13 @@ static struct dentry *afs_lookup_atcell(struct dentry *dentry)
 	if (!name)
 		goto out_p;
 
-	rcu_read_lock();
-	do {
-		read_seqbegin_or_lock(&net->cells_lock, &seq);
-		cell = rcu_dereference_raw(net->ws_cell);
-		if (cell) {
-			len = cell->name_len;
-			memcpy(name, cell->name, len + 1);
-		}
-	} while (need_seqretry(&net->cells_lock, seq));
-	done_seqretry(&net->cells_lock, seq);
-	rcu_read_unlock();
+	down_read(&net->cells_lock);
+	cell = net->ws_cell;
+	if (cell) {
+		len = cell->name_len;
+		memcpy(name, cell->name, len + 1);
+	}
+	up_read(&net->cells_lock);
 
 	ret = ERR_PTR(-ENOENT);
 	if (!cell)
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index e5f0446f27e5f..257c0f07742fb 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -263,11 +263,11 @@ struct afs_net {
 
 	/* Cell database */
 	struct rb_root		cells;
-	struct afs_cell __rcu	*ws_cell;
+	struct afs_cell		*ws_cell;
 	struct work_struct	cells_manager;
 	struct timer_list	cells_timer;
 	atomic_t		cells_outstanding;
-	seqlock_t		cells_lock;
+	struct rw_semaphore	cells_lock;
 	struct mutex		cells_alias_lock;
 
 	struct mutex		proc_cells_lock;
@@ -917,7 +917,7 @@ static inline bool afs_cb_is_broken(unsigned int cb_break,
  * cell.c
  */
 extern int afs_cell_init(struct afs_net *, const char *);
-extern struct afs_cell *afs_lookup_cell_rcu(struct afs_net *, const char *, unsigned);
+extern struct afs_cell *afs_find_cell(struct afs_net *, const char *, unsigned);
 extern struct afs_cell *afs_lookup_cell(struct afs_net *, const char *, unsigned,
 					const char *, bool);
 extern struct afs_cell *afs_get_cell(struct afs_cell *);
diff --git a/fs/afs/main.c b/fs/afs/main.c
index 31b472f7c734c..accdd8970e7c0 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -78,7 +78,7 @@ static int __net_init afs_net_init(struct net *net_ns)
 	mutex_init(&net->socket_mutex);
 
 	net->cells = RB_ROOT;
-	seqlock_init(&net->cells_lock);
+	init_rwsem(&net->cells_lock);
 	INIT_WORK(&net->cells_manager, afs_manage_cells);
 	timer_setup(&net->cells_timer, afs_cells_timer, 0);
 
diff --git a/fs/afs/super.c b/fs/afs/super.c
index b552357b1d137..0be99016ecfb9 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -634,9 +634,7 @@ static int afs_init_fs_context(struct fs_context *fc)
 	ctx->net = afs_net(fc->net_ns);
 
 	/* Default to the workstation cell. */
-	rcu_read_lock();
-	cell = afs_lookup_cell_rcu(ctx->net, NULL, 0);
-	rcu_read_unlock();
+	cell = afs_find_cell(ctx->net, NULL, 0);
 	if (IS_ERR(cell))
 		cell = NULL;
 	ctx->cell = cell;
-- 
2.25.1



