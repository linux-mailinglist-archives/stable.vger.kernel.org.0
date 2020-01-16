Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498B113F5F5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbgAPTAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388913AbgAPRGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 129C82051A;
        Thu, 16 Jan 2020 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194380;
        bh=ryvnHzpuITDiog6yAtNfhu9cp1jL8iaUbsyk6nz4nM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qx0OnJNEim3M9wFHVkGDpPi+xwlhaJAbVJYhP46n1nK0eWdQ+vbOAvIIlTxUnK3pU
         RrbGlGRH6dP2GnLEuapeclou9wXkv0YlA9P0xGGmsju9Cokn2u1WyemUoAZ/gD3urp
         zLdYSiTNy3i4ewMum1lYBlMupMztNZ5VixQ+ar9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jonathan Billings <jsbillin@umich.edu>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 311/671] afs: Further fix file locking
Date:   Thu, 16 Jan 2020 11:59:09 -0500
Message-Id: <20200116170509.12787-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4be5975aea154e164696128d049dec9ed341585c ]

Further fix the file locking in the afs filesystem client in a number of
ways, including:

 (1) Don't submit the operation to obtain a lock from the server in a work
     queue context, but rather do it in the process context of whoever
     issued the requesting system call.

 (2) The owner of the file_lock struct at the front of the pending_locks
     queue now owns right to talk to the server.

 (3) Write locks can be instantly granted if they don't overlap with any
     other locks *and* we have a write lock on the server.

 (4) In the event of an authentication/permission error, all other matching
     pending locks requests are also immediately aborted.

 (5) Properly use VFS core locks_lock_file_wait() to distribute the server
     lock amongst local client locks, including waiting for the lock to
     become available.

Test with:

	sqlite3 /afs/.../scratch/billings.sqlite <<EOF
	CREATE TABLE hosts (
	    hostname varchar(80),
	    shorthost varchar(80),
	    room varchar(30),
	    building varchar(30),
	    PRIMARY KEY(shorthost)
	    );
	EOF

With the version of sqlite3 that I have, this should fail consistently with
EAGAIN, whether or not the program is straced (which introduces some delays
between lock syscalls).

Fixes: 0fafdc9f888b ("afs: Fix file locking")
Reported-by: Jonathan Billings <jsbillin@umich.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/flock.c | 390 ++++++++++++++++++++++++-------------------------
 1 file changed, 195 insertions(+), 195 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index dffbb456629c..075fe7f94810 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -13,9 +13,11 @@
 
 #define AFS_LOCK_GRANTED	0
 #define AFS_LOCK_PENDING	1
+#define AFS_LOCK_YOUR_TRY	2
 
 struct workqueue_struct *afs_lock_manager;
 
+static void afs_next_locker(struct afs_vnode *vnode, int error);
 static void afs_fl_copy_lock(struct file_lock *new, struct file_lock *fl);
 static void afs_fl_release_private(struct file_lock *fl);
 
@@ -24,6 +26,12 @@ static const struct file_lock_operations afs_lock_ops = {
 	.fl_release_private	= afs_fl_release_private,
 };
 
+static inline void afs_set_lock_state(struct afs_vnode *vnode, enum afs_lock_state state)
+{
+	_debug("STATE %u -> %u", vnode->lock_state, state);
+	vnode->lock_state = state;
+}
+
 /*
  * if the callback is broken on this vnode, then the lock may now be available
  */
@@ -31,7 +39,13 @@ void afs_lock_may_be_available(struct afs_vnode *vnode)
 {
 	_enter("{%x:%u}", vnode->fid.vid, vnode->fid.vnode);
 
-	queue_delayed_work(afs_lock_manager, &vnode->lock_work, 0);
+	if (vnode->lock_state != AFS_VNODE_LOCK_WAITING_FOR_CB)
+		return;
+
+	spin_lock(&vnode->lock);
+	if (vnode->lock_state == AFS_VNODE_LOCK_WAITING_FOR_CB)
+		afs_next_locker(vnode, 0);
+	spin_unlock(&vnode->lock);
 }
 
 /*
@@ -49,22 +63,65 @@ static void afs_schedule_lock_extension(struct afs_vnode *vnode)
  * first lock in the queue is itself a readlock)
  * - the caller must hold the vnode lock
  */
-static void afs_grant_locks(struct afs_vnode *vnode, struct file_lock *fl)
+static void afs_grant_locks(struct afs_vnode *vnode)
 {
 	struct file_lock *p, *_p;
+	bool exclusive = (vnode->lock_type == AFS_LOCK_WRITE);
 
-	list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
-	if (fl->fl_type == F_RDLCK) {
-		list_for_each_entry_safe(p, _p, &vnode->pending_locks,
-					 fl_u.afs.link) {
-			if (p->fl_type == F_RDLCK) {
-				p->fl_u.afs.state = AFS_LOCK_GRANTED;
-				list_move_tail(&p->fl_u.afs.link,
-					       &vnode->granted_locks);
-				wake_up(&p->fl_wait);
-			}
+	list_for_each_entry_safe(p, _p, &vnode->pending_locks, fl_u.afs.link) {
+		if (!exclusive && p->fl_type == F_WRLCK)
+			continue;
+
+		list_move_tail(&p->fl_u.afs.link, &vnode->granted_locks);
+		p->fl_u.afs.state = AFS_LOCK_GRANTED;
+		wake_up(&p->fl_wait);
+	}
+}
+
+/*
+ * If an error is specified, reject every pending lock that matches the
+ * authentication and type of the lock we failed to get.  If there are any
+ * remaining lockers, try to wake up one of them to have a go.
+ */
+static void afs_next_locker(struct afs_vnode *vnode, int error)
+{
+	struct file_lock *p, *_p, *next = NULL;
+	struct key *key = vnode->lock_key;
+	unsigned int fl_type = F_RDLCK;
+
+	_enter("");
+
+	if (vnode->lock_type == AFS_LOCK_WRITE)
+		fl_type = F_WRLCK;
+
+	list_for_each_entry_safe(p, _p, &vnode->pending_locks, fl_u.afs.link) {
+		if (error &&
+		    p->fl_type == fl_type &&
+		    afs_file_key(p->fl_file) == key) {
+			list_del_init(&p->fl_u.afs.link);
+			p->fl_u.afs.state = error;
+			wake_up(&p->fl_wait);
 		}
+
+		/* Select the next locker to hand off to. */
+		if (next &&
+		    (next->fl_type == F_WRLCK || p->fl_type == F_RDLCK))
+			continue;
+		next = p;
 	}
+
+	vnode->lock_key = NULL;
+	key_put(key);
+
+	if (next) {
+		afs_set_lock_state(vnode, AFS_VNODE_LOCK_SETTING);
+		next->fl_u.afs.state = AFS_LOCK_YOUR_TRY;
+		wake_up(&next->fl_wait);
+	} else {
+		afs_set_lock_state(vnode, AFS_VNODE_LOCK_NONE);
+	}
+
+	_leave("");
 }
 
 /*
@@ -170,8 +227,6 @@ void afs_lock_work(struct work_struct *work)
 {
 	struct afs_vnode *vnode =
 		container_of(work, struct afs_vnode, lock_work.work);
-	struct file_lock *fl, *next;
-	afs_lock_type_t type;
 	struct key *key;
 	int ret;
 
@@ -184,7 +239,7 @@ void afs_lock_work(struct work_struct *work)
 	switch (vnode->lock_state) {
 	case AFS_VNODE_LOCK_NEED_UNLOCK:
 		_debug("unlock");
-		vnode->lock_state = AFS_VNODE_LOCK_UNLOCKING;
+		afs_set_lock_state(vnode, AFS_VNODE_LOCK_UNLOCKING);
 		spin_unlock(&vnode->lock);
 
 		/* attempt to release the server lock; if it fails, we just
@@ -196,22 +251,9 @@ void afs_lock_work(struct work_struct *work)
 			       vnode->fid.vid, vnode->fid.vnode, ret);
 
 		spin_lock(&vnode->lock);
-		key_put(vnode->lock_key);
-		vnode->lock_key = NULL;
-		vnode->lock_state = AFS_VNODE_LOCK_NONE;
-
-		if (list_empty(&vnode->pending_locks)) {
-			spin_unlock(&vnode->lock);
-			return;
-		}
-
-		/* The new front of the queue now owns the state variables. */
-		next = list_entry(vnode->pending_locks.next,
-				  struct file_lock, fl_u.afs.link);
-		vnode->lock_key = key_get(afs_file_key(next->fl_file));
-		vnode->lock_type = (next->fl_type == F_RDLCK) ? AFS_LOCK_READ : AFS_LOCK_WRITE;
-		vnode->lock_state = AFS_VNODE_LOCK_WAITING_FOR_CB;
-		goto again;
+		afs_next_locker(vnode, 0);
+		spin_unlock(&vnode->lock);
+		return;
 
 	/* If we've already got a lock, then it must be time to extend that
 	 * lock as AFS locks time out after 5 minutes.
@@ -222,7 +264,7 @@ void afs_lock_work(struct work_struct *work)
 		ASSERT(!list_empty(&vnode->granted_locks));
 
 		key = key_get(vnode->lock_key);
-		vnode->lock_state = AFS_VNODE_LOCK_EXTENDING;
+		afs_set_lock_state(vnode, AFS_VNODE_LOCK_EXTENDING);
 		spin_unlock(&vnode->lock);
 
 		ret = afs_extend_lock(vnode, key); /* RPC */
@@ -236,72 +278,26 @@ void afs_lock_work(struct work_struct *work)
 
 		if (vnode->lock_state != AFS_VNODE_LOCK_EXTENDING)
 			goto again;
-		vnode->lock_state = AFS_VNODE_LOCK_GRANTED;
+		afs_set_lock_state(vnode, AFS_VNODE_LOCK_GRANTED);
 
-		if (ret == 0)
-			afs_schedule_lock_extension(vnode);
-		else
+		if (ret != 0)
 			queue_delayed_work(afs_lock_manager, &vnode->lock_work,
 					   HZ * 10);
 		spin_unlock(&vnode->lock);
 		_leave(" [ext]");
 		return;
 
-		/* If we don't have a granted lock, then we must've been called
-		 * back by the server, and so if might be possible to get a
-		 * lock we're currently waiting for.
-		 */
+	/* If we're waiting for a callback to indicate lock release, we can't
+	 * actually rely on this, so need to recheck at regular intervals.  The
+	 * problem is that the server might not notify us if the lock just
+	 * expires (say because a client died) rather than being explicitly
+	 * released.
+	 */
 	case AFS_VNODE_LOCK_WAITING_FOR_CB:
-		_debug("get");
-
-		key = key_get(vnode->lock_key);
-		type = vnode->lock_type;
-		vnode->lock_state = AFS_VNODE_LOCK_SETTING;
+		_debug("retry");
+		afs_next_locker(vnode, 0);
 		spin_unlock(&vnode->lock);
-
-		ret = afs_set_lock(vnode, key, type); /* RPC */
-		key_put(key);
-
-		spin_lock(&vnode->lock);
-		switch (ret) {
-		case -EWOULDBLOCK:
-			_debug("blocked");
-			break;
-		case 0:
-			_debug("acquired");
-			vnode->lock_state = AFS_VNODE_LOCK_GRANTED;
-			/* Fall through */
-		default:
-			/* Pass the lock or the error onto the first locker in
-			 * the list - if they're looking for this type of lock.
-			 * If they're not, we assume that whoever asked for it
-			 * took a signal.
-			 */
-			if (list_empty(&vnode->pending_locks)) {
-				_debug("withdrawn");
-				vnode->lock_state = AFS_VNODE_LOCK_NEED_UNLOCK;
-				goto again;
-			}
-
-			fl = list_entry(vnode->pending_locks.next,
-					struct file_lock, fl_u.afs.link);
-			type = (fl->fl_type == F_RDLCK) ? AFS_LOCK_READ : AFS_LOCK_WRITE;
-			if (vnode->lock_type != type) {
-				_debug("changed");
-				vnode->lock_state = AFS_VNODE_LOCK_NEED_UNLOCK;
-				goto again;
-			}
-
-			fl->fl_u.afs.state = ret;
-			if (ret == 0)
-				afs_grant_locks(vnode, fl);
-			else
-				list_del_init(&fl->fl_u.afs.link);
-			wake_up(&fl->fl_wait);
-			spin_unlock(&vnode->lock);
-			_leave(" [granted]");
-			return;
-		}
+		return;
 
 	default:
 		/* Looks like a lock request was withdrawn. */
@@ -319,14 +315,15 @@ void afs_lock_work(struct work_struct *work)
  */
 static void afs_defer_unlock(struct afs_vnode *vnode)
 {
-	_enter("");
+	_enter("%u", vnode->lock_state);
 
-	if (vnode->lock_state == AFS_VNODE_LOCK_GRANTED ||
-	    vnode->lock_state == AFS_VNODE_LOCK_EXTENDING) {
+	if (list_empty(&vnode->granted_locks) &&
+	    (vnode->lock_state == AFS_VNODE_LOCK_GRANTED ||
+	     vnode->lock_state == AFS_VNODE_LOCK_EXTENDING)) {
 		cancel_delayed_work(&vnode->lock_work);
 
-		vnode->lock_state = AFS_VNODE_LOCK_NEED_UNLOCK;
-		afs_lock_may_be_available(vnode);
+		afs_set_lock_state(vnode, AFS_VNODE_LOCK_NEED_UNLOCK);
+		queue_delayed_work(afs_lock_manager, &vnode->lock_work, 0);
 	}
 }
 
@@ -375,50 +372,6 @@ static int afs_do_setlk_check(struct afs_vnode *vnode, struct key *key,
 	return 0;
 }
 
-/*
- * Remove the front runner from the pending queue.
- * - The caller must hold vnode->lock.
- */
-static void afs_dequeue_lock(struct afs_vnode *vnode, struct file_lock *fl)
-{
-	struct file_lock *next;
-
-	_enter("");
-
-	/* ->lock_type, ->lock_key and ->lock_state only belong to this
-	 * file_lock if we're at the front of the pending queue or if we have
-	 * the lock granted or if the lock_state is NEED_UNLOCK or UNLOCKING.
-	 */
-	if (vnode->granted_locks.next == &fl->fl_u.afs.link &&
-	    vnode->granted_locks.prev == &fl->fl_u.afs.link) {
-		list_del_init(&fl->fl_u.afs.link);
-		afs_defer_unlock(vnode);
-		return;
-	}
-
-	if (!list_empty(&vnode->granted_locks) ||
-	    vnode->pending_locks.next != &fl->fl_u.afs.link) {
-		list_del_init(&fl->fl_u.afs.link);
-		return;
-	}
-
-	list_del_init(&fl->fl_u.afs.link);
-	key_put(vnode->lock_key);
-	vnode->lock_key = NULL;
-	vnode->lock_state = AFS_VNODE_LOCK_NONE;
-
-	if (list_empty(&vnode->pending_locks))
-		return;
-
-	/* The new front of the queue now owns the state variables. */
-	next = list_entry(vnode->pending_locks.next,
-			  struct file_lock, fl_u.afs.link);
-	vnode->lock_key = key_get(afs_file_key(next->fl_file));
-	vnode->lock_type = (next->fl_type == F_RDLCK) ? AFS_LOCK_READ : AFS_LOCK_WRITE;
-	vnode->lock_state = AFS_VNODE_LOCK_WAITING_FOR_CB;
-	afs_lock_may_be_available(vnode);
-}
-
 /*
  * request a lock on a file on the server
  */
@@ -443,44 +396,66 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
 		return ret;
 
 	spin_lock(&vnode->lock);
+	list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
 
-	/* If we've already got a readlock on the server then we instantly
-	 * grant another readlock, irrespective of whether there are any
-	 * pending writelocks.
+	/* If we've already got a lock on the server then try to move to having
+	 * the VFS grant the requested lock.  Note that this means that other
+	 * clients may get starved out.
 	 */
-	if (type == AFS_LOCK_READ &&
-	    vnode->lock_state == AFS_VNODE_LOCK_GRANTED &&
-	    vnode->lock_type == AFS_LOCK_READ) {
-		_debug("instant readlock");
-		ASSERT(!list_empty(&vnode->granted_locks));
-		goto share_existing_lock;
-	}
+	_debug("try %u", vnode->lock_state);
+	if (vnode->lock_state == AFS_VNODE_LOCK_GRANTED) {
+		if (type == AFS_LOCK_READ) {
+			_debug("instant readlock");
+			list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
+			fl->fl_u.afs.state = AFS_LOCK_GRANTED;
+			goto vnode_is_locked_u;
+		}
 
-	list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
+		if (vnode->lock_type == AFS_LOCK_WRITE) {
+			_debug("instant writelock");
+			list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
+			fl->fl_u.afs.state = AFS_LOCK_GRANTED;
+			goto vnode_is_locked_u;
+		}
+	}
 
 	if (vnode->lock_state != AFS_VNODE_LOCK_NONE)
 		goto need_to_wait;
 
+try_to_lock:
 	/* We don't have a lock on this vnode and we aren't currently waiting
 	 * for one either, so ask the server for a lock.
 	 *
 	 * Note that we need to be careful if we get interrupted by a signal
 	 * after dispatching the request as we may still get the lock, even
 	 * though we don't wait for the reply (it's not too bad a problem - the
-	 * lock will expire in 10 mins anyway).
+	 * lock will expire in 5 mins anyway).
 	 */
 	_debug("not locked");
 	vnode->lock_key = key_get(key);
 	vnode->lock_type = type;
-	vnode->lock_state = AFS_VNODE_LOCK_SETTING;
+	afs_set_lock_state(vnode, AFS_VNODE_LOCK_SETTING);
 	spin_unlock(&vnode->lock);
 
 	ret = afs_set_lock(vnode, key, type); /* RPC */
 
 	spin_lock(&vnode->lock);
 	switch (ret) {
+	case -EKEYREJECTED:
+	case -EKEYEXPIRED:
+	case -EKEYREVOKED:
+	case -EPERM:
+	case -EACCES:
+		fl->fl_u.afs.state = ret;
+		list_del_init(&fl->fl_u.afs.link);
+		afs_next_locker(vnode, ret);
+		goto error_unlock;
+
 	default:
-		goto abort_attempt;
+		fl->fl_u.afs.state = ret;
+		list_del_init(&fl->fl_u.afs.link);
+		afs_next_locker(vnode, 0);
+		goto error_unlock;
 
 	case -EWOULDBLOCK:
 		/* The server doesn't have a lock-waiting queue, so the client
@@ -490,29 +465,23 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
 		_debug("would block");
 		ASSERT(list_empty(&vnode->granted_locks));
 		ASSERTCMP(vnode->pending_locks.next, ==, &fl->fl_u.afs.link);
-		vnode->lock_state = AFS_VNODE_LOCK_WAITING_FOR_CB;
-		goto need_to_wait;
+		goto lock_is_contended;
 
 	case 0:
 		_debug("acquired");
-		break;
+		afs_set_lock_state(vnode, AFS_VNODE_LOCK_GRANTED);
+		afs_grant_locks(vnode);
+		goto vnode_is_locked_u;
 	}
 
-	/* we've acquired a server lock, but it needs to be renewed after 5
-	 * mins */
-	vnode->lock_state = AFS_VNODE_LOCK_GRANTED;
-	afs_schedule_lock_extension(vnode);
-
-share_existing_lock:
-	/* the lock has been granted as far as we're concerned... */
-	fl->fl_u.afs.state = AFS_LOCK_GRANTED;
-	list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
-
-given_lock:
-	/* ... but we do still need to get the VFS's blessing */
+vnode_is_locked_u:
 	spin_unlock(&vnode->lock);
+vnode_is_locked:
+	/* the lock has been granted by the server... */
+	ASSERTCMP(fl->fl_u.afs.state, ==, AFS_LOCK_GRANTED);
 
-	ret = posix_lock_file(file, fl, NULL);
+	/* ... but the VFS still needs to distribute access on this client. */
+	ret = locks_lock_file_wait(file, fl);
 	if (ret < 0)
 		goto vfs_rejected_lock;
 
@@ -524,38 +493,61 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
 	_leave(" = 0");
 	return 0;
 
+lock_is_contended:
+	if (!(fl->fl_flags & FL_SLEEP)) {
+		list_del_init(&fl->fl_u.afs.link);
+		afs_next_locker(vnode, 0);
+		ret = -EAGAIN;
+		goto error_unlock;
+	}
+
+	afs_set_lock_state(vnode, AFS_VNODE_LOCK_WAITING_FOR_CB);
+	queue_delayed_work(afs_lock_manager, &vnode->lock_work, HZ * 5);
+
 need_to_wait:
 	/* We're going to have to wait.  Either this client doesn't have a lock
 	 * on the server yet and we need to wait for a callback to occur, or
-	 * the client does have a lock on the server, but it belongs to some
-	 * other process(es) and is incompatible with the lock we want.
+	 * the client does have a lock on the server, but it's shared and we
+	 * need an exclusive lock.
 	 */
-	ret = -EAGAIN;
-	if (fl->fl_flags & FL_SLEEP) {
-		spin_unlock(&vnode->lock);
+	spin_unlock(&vnode->lock);
 
-		_debug("sleep");
-		ret = wait_event_interruptible(fl->fl_wait,
-					       fl->fl_u.afs.state != AFS_LOCK_PENDING);
+	_debug("sleep");
+	ret = wait_event_interruptible(fl->fl_wait,
+				       fl->fl_u.afs.state != AFS_LOCK_PENDING);
+	_debug("wait = %d", ret);
 
+	if (fl->fl_u.afs.state >= 0 && fl->fl_u.afs.state != AFS_LOCK_GRANTED) {
 		spin_lock(&vnode->lock);
-	}
 
-	if (fl->fl_u.afs.state == AFS_LOCK_GRANTED)
-		goto given_lock;
-	if (fl->fl_u.afs.state < 0)
-		ret = fl->fl_u.afs.state;
+		switch (fl->fl_u.afs.state) {
+		case AFS_LOCK_YOUR_TRY:
+			fl->fl_u.afs.state = AFS_LOCK_PENDING;
+			goto try_to_lock;
+		case AFS_LOCK_PENDING:
+			if (ret > 0) {
+				/* We need to retry the lock.  We may not be
+				 * notified by the server if it just expired
+				 * rather than being released.
+				 */
+				ASSERTCMP(vnode->lock_state, ==, AFS_VNODE_LOCK_WAITING_FOR_CB);
+				afs_set_lock_state(vnode, AFS_VNODE_LOCK_SETTING);
+				fl->fl_u.afs.state = AFS_LOCK_PENDING;
+				goto try_to_lock;
+			}
+			goto error_unlock;
+		case AFS_LOCK_GRANTED:
+		default:
+			break;
+		}
 
-abort_attempt:
-	/* we aren't going to get the lock, either because we're unwilling to
-	 * wait, or because some signal happened */
-	_debug("abort");
-	afs_dequeue_lock(vnode, fl);
+		spin_unlock(&vnode->lock);
+	}
 
-error_unlock:
-	spin_unlock(&vnode->lock);
-	_leave(" = %d", ret);
-	return ret;
+	if (fl->fl_u.afs.state == AFS_LOCK_GRANTED)
+		goto vnode_is_locked;
+	ret = fl->fl_u.afs.state;
+	goto error;
 
 vfs_rejected_lock:
 	/* The VFS rejected the lock we just obtained, so we have to discard
@@ -565,9 +557,13 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
 	_debug("vfs refused %d", ret);
 	spin_lock(&vnode->lock);
 	list_del_init(&fl->fl_u.afs.link);
-	if (list_empty(&vnode->granted_locks))
-		afs_defer_unlock(vnode);
-	goto error_unlock;
+	afs_defer_unlock(vnode);
+
+error_unlock:
+	spin_unlock(&vnode->lock);
+error:
+	_leave(" = %d", ret);
+	return ret;
 }
 
 /*
@@ -583,7 +579,7 @@ static int afs_do_unlk(struct file *file, struct file_lock *fl)
 	/* Flush all pending writes before doing anything with locks. */
 	vfs_fsync(file, 0);
 
-	ret = posix_lock_file(file, fl, NULL);
+	ret = locks_lock_file_wait(file, fl);
 	_leave(" = %d [%u]", ret, vnode->lock_state);
 	return ret;
 }
@@ -705,7 +701,11 @@ static void afs_fl_release_private(struct file_lock *fl)
 	_enter("");
 
 	spin_lock(&vnode->lock);
-	afs_dequeue_lock(vnode, fl);
+
+	list_del_init(&fl->fl_u.afs.link);
+	if (list_empty(&vnode->granted_locks))
+		afs_defer_unlock(vnode);
+
 	_debug("state %u for %p", vnode->lock_state, vnode);
 	spin_unlock(&vnode->lock);
 }
-- 
2.20.1

