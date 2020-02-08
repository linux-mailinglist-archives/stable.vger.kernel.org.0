Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D669156613
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgBHSbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34656 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727951AbgBHS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:49 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003jd-Tu; Sat, 08 Feb 2020 18:29:43 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CWP-Hj; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pavel Shilovsky" <pshilov@microsoft.com>,
        "Dave Wysochanski" <dwysocha@redhat.com>,
        "Ronnie Sahlberg" <lsahlber@redhat.com>
Date:   Sat, 08 Feb 2020 18:21:11 +0000
Message-ID: <lsq.1581185941.562502646@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 132/148] cifs: Fix cifsInodeInfo lock_sem deadlock
 when reconnect occurs
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Wysochanski <dwysocha@redhat.com>

commit d46b0da7a33dd8c99d969834f682267a45444ab3 upstream.

There's a deadlock that is possible and can easily be seen with
a test where multiple readers open/read/close of the same file
and a disruption occurs causing reconnect.  The deadlock is due
a reader thread inside cifs_strict_readv calling down_read and
obtaining lock_sem, and then after reconnect inside
cifs_reopen_file calling down_read a second time.  If in
between the two down_read calls, a down_write comes from
another process, deadlock occurs.

        CPU0                    CPU1
        ----                    ----
cifs_strict_readv()
 down_read(&cifsi->lock_sem);
                               _cifsFileInfo_put
                                  OR
                               cifs_new_fileinfo
                                down_write(&cifsi->lock_sem);
cifs_reopen_file()
 down_read(&cifsi->lock_sem);

Fix the above by changing all down_write(lock_sem) calls to
down_write_trylock(lock_sem)/msleep() loop, which in turn
makes the second down_read call benign since it will never
block behind the writer while holding lock_sem.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Suggested-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed--by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifsglob.h  |  5 +++++
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/file.c      | 23 +++++++++++++++--------
 fs/cifs/smb2file.c  |  2 +-
 4 files changed, 22 insertions(+), 9 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1113,6 +1113,11 @@ void cifsFileInfo_put(struct cifsFileInf
 struct cifsInodeInfo {
 	bool can_cache_brlcks;
 	struct list_head llist;	/* locks helb by this inode */
+	/*
+	 * NOTE: Some code paths call down_read(lock_sem) twice, so
+	 * we must always use use cifs_down_write() instead of down_write()
+	 * for this semaphore to avoid deadlocks.
+	 */
 	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -137,6 +137,7 @@ extern int cifs_unlock_range(struct cifs
 			     struct file_lock *flock, const unsigned int xid);
 extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
 
+extern void cifs_down_write(struct rw_semaphore *sem);
 extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
 					      struct file *file,
 					      struct tcon_link *tlink,
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -281,6 +281,13 @@ cifs_has_mand_locks(struct cifsInodeInfo
 	return has_locks;
 }
 
+void
+cifs_down_write(struct rw_semaphore *sem)
+{
+	while (!down_write_trylock(sem))
+		msleep(10);
+}
+
 struct cifsFileInfo *
 cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
@@ -306,7 +313,7 @@ cifs_new_fileinfo(struct cifs_fid *fid,
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile = cfile;
 	cfile->llist = fdlocks;
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_add(&fdlocks->llist, &cinode->llist);
 	up_write(&cinode->lock_sem);
 
@@ -462,7 +469,7 @@ void _cifsFileInfo_put(struct cifsFileIn
 	 * Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
 	 */
-	down_write(&cifsi->lock_sem);
+	cifs_down_write(&cifsi->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
 		list_del(&li->llist);
 		cifs_del_lock_waiters(li);
@@ -970,7 +977,7 @@ static void
 cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_add_tail(&lock->llist, &cfile->llist->locks);
 	up_write(&cinode->lock_sem);
 }
@@ -992,7 +999,7 @@ cifs_lock_add_if(struct cifsFileInfo *cf
 
 try_again:
 	exist = false;
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 					lock->type, &conf_lock, CIFS_LOCK_OP);
@@ -1014,7 +1021,7 @@ try_again:
 					(lock->blist.next == &lock->blist));
 		if (!rc)
 			goto try_again;
-		down_write(&cinode->lock_sem);
+		cifs_down_write(&cinode->lock_sem);
 		list_del_init(&lock->blist);
 	}
 
@@ -1067,7 +1074,7 @@ cifs_posix_lock_set(struct file *file, s
 		return rc;
 
 try_again:
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
 		up_write(&cinode->lock_sem);
 		return rc;
@@ -1267,7 +1274,7 @@ cifs_push_locks(struct cifsFileInfo *cfi
 	int rc = 0;
 
 	/* we are going to update can_cache_brlcks here - need a write access */
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
 		up_write(&cinode->lock_sem);
 		return rc;
@@ -1451,7 +1458,7 @@ cifs_unlock_range(struct cifsFileInfo *c
 	if (!buf)
 		return -ENOMEM;
 
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -114,7 +114,7 @@ smb2_unlock_range(struct cifsFileInfo *c
 
 	cur = buf;
 
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 		if (flock->fl_start > li->offset ||
 		    (flock->fl_start + length) <

