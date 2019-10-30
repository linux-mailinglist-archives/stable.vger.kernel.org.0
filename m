Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834C2EA12A
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfJ3P65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729150AbfJ3P5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:57:51 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C686217D9;
        Wed, 30 Oct 2019 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451069;
        bh=QQnacO8XTYFkVvC98SZyoS78neMj+cLplwvBEkW6pO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbBrvsm4zvy9sKIuL5t5fI2c65Qr8/uvXMS7q8MyE9wJrPhGVbbBQu/qZhQEYlEXE
         SyC/azLSzoabutLBMLlhZHODq+3zWhng+Z0n7tVGtGvhEVxeHNm3Bk5K5XSXIJJ4EA
         DLSkzSm/hDoZ0RyI7KsSb9JdNse/f5fDFSucu1T4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Wysochanski <dwysocha@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 18/18] cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs
Date:   Wed, 30 Oct 2019 11:57:00 -0400
Message-Id: <20191030155700.10748-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155700.10748-1-sashal@kernel.org>
References: <20191030155700.10748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit d46b0da7a33dd8c99d969834f682267a45444ab3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h  |  5 +++++
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/file.c      | 23 +++++++++++++++--------
 fs/cifs/smb2file.c  |  2 +-
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5367b684c1f74..7ae21ad420fbf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1178,6 +1178,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
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
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index cd8025a249bba..cdf244df91c25 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -138,6 +138,7 @@ extern int cifs_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
 extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
 
+extern void cifs_down_write(struct rw_semaphore *sem);
 extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
 					      struct file *file,
 					      struct tcon_link *tlink,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3504ef015493b..1c3f262d9c4d4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -280,6 +280,13 @@ cifs_has_mand_locks(struct cifsInodeInfo *cinode)
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
@@ -305,7 +312,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile = cfile;
 	cfile->llist = fdlocks;
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_add(&fdlocks->llist, &cinode->llist);
 	up_write(&cinode->lock_sem);
 
@@ -457,7 +464,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 	 * Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
 	 */
-	down_write(&cifsi->lock_sem);
+	cifs_down_write(&cifsi->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
 		list_del(&li->llist);
 		cifs_del_lock_waiters(li);
@@ -1011,7 +1018,7 @@ static void
 cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_add_tail(&lock->llist, &cfile->llist->locks);
 	up_write(&cinode->lock_sem);
 }
@@ -1033,7 +1040,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
 
 try_again:
 	exist = false;
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 					lock->type, &conf_lock, CIFS_LOCK_OP);
@@ -1055,7 +1062,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
 					(lock->blist.next == &lock->blist));
 		if (!rc)
 			goto try_again;
-		down_write(&cinode->lock_sem);
+		cifs_down_write(&cinode->lock_sem);
 		list_del_init(&lock->blist);
 	}
 
@@ -1108,7 +1115,7 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 		return rc;
 
 try_again:
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
 		up_write(&cinode->lock_sem);
 		return rc;
@@ -1312,7 +1319,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 	int rc = 0;
 
 	/* we are going to update can_cache_brlcks here - need a write access */
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	if (!cinode->can_cache_brlcks) {
 		up_write(&cinode->lock_sem);
 		return rc;
@@ -1501,7 +1508,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	if (!buf)
 		return -ENOMEM;
 
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index dee5250701deb..41f1a5dd33a53 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -138,7 +138,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 
 	cur = buf;
 
-	down_write(&cinode->lock_sem);
+	cifs_down_write(&cinode->lock_sem);
 	list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 		if (flock->fl_start > li->offset ||
 		    (flock->fl_start + length) <
-- 
2.20.1

