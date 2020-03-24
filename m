Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2727190FA0
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgCXNVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728923AbgCXNVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:21:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D177208C3;
        Tue, 24 Mar 2020 13:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056093;
        bh=6FsquY7iFcnNADPoP9NlvSUgozOsnBwZr9Y3ZVymeZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVM3BwHmGKXlMiVY/C3KOPYCULCsPIfFako5VEnty6MrWyyx8iPruJ0FJnDHnaNVA
         6fjYUykcNF3rwAQJCcPWsPvKbGhyG3Gs8WNfJAyxJG0QqEZdEGZ60ICQF+TJHWeGX3
         QK1s82W8gxFQNyflJeHR5KCGVSofqBizszOBTFjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        NeilBrown <neilb@suse.de>, Jeff Layton <jlayton@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 002/119] locks: reinstate locks_delete_block optimization
Date:   Tue, 24 Mar 2020 14:09:47 +0100
Message-Id: <20200324130808.263988721@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit dcf23ac3e846ca0cf626c155a0e3fcbbcf4fae8a ]

There is measurable performance impact in some synthetic tests due to
commit 6d390e4b5d48 (locks: fix a potential use-after-free problem when
wakeup a waiter). Fix the race condition instead by clearing the
fl_blocker pointer after the wake_up, using explicit acquire/release
semantics.

This does mean that we can no longer use the clearing of fl_blocker as
the wait condition, so switch the waiters over to checking whether the
fl_blocked_member list_head is empty.

Reviewed-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Fixes: 6d390e4b5d48 (locks: fix a potential use-after-free problem when wakeup a waiter)
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c |  3 ++-
 fs/locks.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5b1460486535e..dc195435519b4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1175,7 +1175,8 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 	rc = posix_lock_file(file, flock, NULL);
 	up_write(&cinode->lock_sem);
 	if (rc == FILE_LOCK_DEFERRED) {
-		rc = wait_event_interruptible(flock->fl_wait, !flock->fl_blocker);
+		rc = wait_event_interruptible(flock->fl_wait,
+					list_empty(&flock->fl_blocked_member));
 		if (!rc)
 			goto try_again;
 		locks_delete_block(flock);
diff --git a/fs/locks.c b/fs/locks.c
index 426b55d333d5b..b8a31c1c4fff3 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -725,7 +725,6 @@ static void __locks_delete_block(struct file_lock *waiter)
 {
 	locks_delete_global_blocked(waiter);
 	list_del_init(&waiter->fl_blocked_member);
-	waiter->fl_blocker = NULL;
 }
 
 static void __locks_wake_up_blocks(struct file_lock *blocker)
@@ -740,6 +739,13 @@ static void __locks_wake_up_blocks(struct file_lock *blocker)
 			waiter->fl_lmops->lm_notify(waiter);
 		else
 			wake_up(&waiter->fl_wait);
+
+		/*
+		 * The setting of fl_blocker to NULL marks the "done"
+		 * point in deleting a block. Paired with acquire at the top
+		 * of locks_delete_block().
+		 */
+		smp_store_release(&waiter->fl_blocker, NULL);
 	}
 }
 
@@ -753,11 +759,42 @@ int locks_delete_block(struct file_lock *waiter)
 {
 	int status = -ENOENT;
 
+	/*
+	 * If fl_blocker is NULL, it won't be set again as this thread "owns"
+	 * the lock and is the only one that might try to claim the lock.
+	 *
+	 * We use acquire/release to manage fl_blocker so that we can
+	 * optimize away taking the blocked_lock_lock in many cases.
+	 *
+	 * The smp_load_acquire guarantees two things:
+	 *
+	 * 1/ that fl_blocked_requests can be tested locklessly. If something
+	 * was recently added to that list it must have been in a locked region
+	 * *before* the locked region when fl_blocker was set to NULL.
+	 *
+	 * 2/ that no other thread is accessing 'waiter', so it is safe to free
+	 * it.  __locks_wake_up_blocks is careful not to touch waiter after
+	 * fl_blocker is released.
+	 *
+	 * If a lockless check of fl_blocker shows it to be NULL, we know that
+	 * no new locks can be inserted into its fl_blocked_requests list, and
+	 * can avoid doing anything further if the list is empty.
+	 */
+	if (!smp_load_acquire(&waiter->fl_blocker) &&
+	    list_empty(&waiter->fl_blocked_requests))
+		return status;
+
 	spin_lock(&blocked_lock_lock);
 	if (waiter->fl_blocker)
 		status = 0;
 	__locks_wake_up_blocks(waiter);
 	__locks_delete_block(waiter);
+
+	/*
+	 * The setting of fl_blocker to NULL marks the "done" point in deleting
+	 * a block. Paired with acquire at the top of this function.
+	 */
+	smp_store_release(&waiter->fl_blocker, NULL);
 	spin_unlock(&blocked_lock_lock);
 	return status;
 }
@@ -1350,7 +1387,8 @@ static int posix_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 		error = posix_lock_inode(inode, fl, NULL);
 		if (error != FILE_LOCK_DEFERRED)
 			break;
-		error = wait_event_interruptible(fl->fl_wait, !fl->fl_blocker);
+		error = wait_event_interruptible(fl->fl_wait,
+					list_empty(&fl->fl_blocked_member));
 		if (error)
 			break;
 	}
@@ -1435,7 +1473,8 @@ int locks_mandatory_area(struct inode *inode, struct file *filp, loff_t start,
 		error = posix_lock_inode(inode, &fl, NULL);
 		if (error != FILE_LOCK_DEFERRED)
 			break;
-		error = wait_event_interruptible(fl.fl_wait, !fl.fl_blocker);
+		error = wait_event_interruptible(fl.fl_wait,
+					list_empty(&fl.fl_blocked_member));
 		if (!error) {
 			/*
 			 * If we've been sleeping someone might have
@@ -1638,7 +1677,8 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
 
 	locks_dispose_list(&dispose);
 	error = wait_event_interruptible_timeout(new_fl->fl_wait,
-						!new_fl->fl_blocker, break_time);
+					list_empty(&new_fl->fl_blocked_member),
+					break_time);
 
 	percpu_down_read(&file_rwsem);
 	spin_lock(&ctx->flc_lock);
@@ -2122,7 +2162,8 @@ static int flock_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 		error = flock_lock_inode(inode, fl);
 		if (error != FILE_LOCK_DEFERRED)
 			break;
-		error = wait_event_interruptible(fl->fl_wait, !fl->fl_blocker);
+		error = wait_event_interruptible(fl->fl_wait,
+				list_empty(&fl->fl_blocked_member));
 		if (error)
 			break;
 	}
@@ -2399,7 +2440,8 @@ static int do_lock_file_wait(struct file *filp, unsigned int cmd,
 		error = vfs_lock_file(filp, cmd, fl, NULL);
 		if (error != FILE_LOCK_DEFERRED)
 			break;
-		error = wait_event_interruptible(fl->fl_wait, !fl->fl_blocker);
+		error = wait_event_interruptible(fl->fl_wait,
+					list_empty(&fl->fl_blocked_member));
 		if (error)
 			break;
 	}
-- 
2.20.1



