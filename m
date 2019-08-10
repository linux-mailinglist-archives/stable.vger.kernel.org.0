Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9446A88D95
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHJUrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:47:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55054 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726841AbfHJUoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00053i-KT; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003fP-9m; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Aurelien Aptel" <aaptel@suse.com>,
        "Steve French" <stfrench@microsoft.com>,
        "Pavel Shilovsky" <pshilov@microsoft.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.46415781@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 092/157] CIFS: keep FileInfo handle live during
 oplock break
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Aptel <aaptel@suse.com>

commit b98749cac4a695f084a5ff076f4510b23e353ecd upstream.

In the oplock break handler, writing pending changes from pages puts
the FileInfo handle. If the refcount reaches zero it closes the handle
and waits for any oplock break handler to return, thus causing a deadlock.

To prevent this situation:

* We add a wait flag to cifsFileInfo_put() to decide whether we should
  wait for running/pending oplock break handlers

* We keep an additionnal reference of the SMB FileInfo handle so that
  for the rest of the handler putting the handle won't close it.
  - The ref is bumped everytime we queue the handler via the
    cifs_queue_oplock_break() helper.
  - The ref is decremented at the end of the handler

This bug was triggered by xfstest 464.

Also important fix to address the various reports of
oops in smb2_push_mandatory_locks

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/file.c     | 30 +++++++++++++++++++++++++-----
 fs/cifs/misc.c     | 25 +++++++++++++++++++++++--
 fs/cifs/smb2misc.c |  6 +++---
 4 files changed, 53 insertions(+), 10 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1092,6 +1092,7 @@ cifsFileInfo_get_locked(struct cifsFileI
 }
 
 struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
+void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_hdlr);
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 
 #define CIFS_CACHE_READ_FLG	1
@@ -1579,6 +1580,7 @@ GLOBAL_EXTERN spinlock_t gidsidlock;
 #endif /* CONFIG_CIFS_ACL */
 
 void cifs_oplock_break(struct work_struct *work);
+void cifs_queue_oplock_break(struct cifsFileInfo *cfile);
 
 extern const struct slow_work_ops cifs_oplock_break_ops;
 extern struct workqueue_struct *cifsiod_wq;
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -359,13 +359,31 @@ cifsFileInfo_get(struct cifsFileInfo *ci
 	return cifs_file;
 }
 
-/*
- * Release a reference on the file private data. This may involve closing
- * the filehandle out on the server. Must be called without holding
- * tcon->open_file_lock and cifs_file->file_info_lock.
+/**
+ * cifsFileInfo_put - release a reference of file priv data
+ *
+ * Always potentially wait for oplock handler. See _cifsFileInfo_put().
  */
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
+	_cifsFileInfo_put(cifs_file, true);
+}
+
+/**
+ * _cifsFileInfo_put - release a reference of file priv data
+ *
+ * This may involve closing the filehandle @cifs_file out on the
+ * server. Must be called without holding tcon->open_file_lock and
+ * cifs_file->file_info_lock.
+ *
+ * If @wait_for_oplock_handler is true and we are releasing the last
+ * reference, wait for any running oplock break handler of the file
+ * and cancel any pending one. If calling this function from the
+ * oplock break handler, you need to pass false.
+ *
+ */
+void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
+{
 	struct inode *inode = cifs_file->dentry->d_inode;
 	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
@@ -412,7 +430,8 @@ void cifsFileInfo_put(struct cifsFileInf
 
 	spin_unlock(&tcon->open_file_lock);
 
-	oplock_break_cancelled = cancel_work_sync(&cifs_file->oplock_break);
+	oplock_break_cancelled = wait_oplock_handler ?
+		cancel_work_sync(&cifs_file->oplock_break) : false;
 
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		struct TCP_Server_Info *server = tcon->ses->server;
@@ -3701,6 +3720,7 @@ void cifs_oplock_break(struct work_struc
 							     cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
+	_cifsFileInfo_put(cfile, false /* do not wait for ourself */);
 	cifs_done_oplock_break(cinode);
 }
 
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -477,8 +477,7 @@ is_valid_oplock_break(char *buffer, stru
 					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
 					   &pCifsInode->flags);
 
-				queue_work(cifsoplockd_wq,
-					   &netfile->oplock_break);
+				cifs_queue_oplock_break(netfile);
 				netfile->oplock_break_cancelled = false;
 
 				spin_unlock(&tcon->open_file_lock);
@@ -610,6 +609,28 @@ void cifs_put_writer(struct cifsInodeInf
 	spin_unlock(&cinode->writers_lock);
 }
 
+/**
+ * cifs_queue_oplock_break - queue the oplock break handler for cfile
+ *
+ * This function is called from the demultiplex thread when it
+ * receives an oplock break for @cfile.
+ *
+ * Assumes the tcon->open_file_lock is held.
+ * Assumes cfile->file_info_lock is NOT held.
+ */
+void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
+{
+	/*
+	 * Bump the handle refcount now while we hold the
+	 * open_file_lock to enforce the validity of it for the oplock
+	 * break handler. The matching put is done at the end of the
+	 * handler.
+	 */
+	cifsFileInfo_get(cfile);
+
+	queue_work(cifsoplockd_wq, &cfile->oplock_break);
+}
+
 void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
 {
 	clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -458,7 +458,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tc
 			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
 				  &cinode->flags);
 
-		queue_work(cifsoplockd_wq, &cfile->oplock_break);
+		cifs_queue_oplock_break(cfile);
 		kfree(lw);
 		return true;
 	}
@@ -602,8 +602,8 @@ smb2_is_valid_oplock_break(char *buffer,
 					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
 					   &cinode->flags);
 				spin_unlock(&cfile->file_info_lock);
-				queue_work(cifsoplockd_wq,
-					   &cfile->oplock_break);
+
+				cifs_queue_oplock_break(cfile);
 
 				spin_unlock(&tcon->open_file_lock);
 				spin_unlock(&cifs_tcp_ses_lock);

