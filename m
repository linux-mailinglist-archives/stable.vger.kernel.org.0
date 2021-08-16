Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CF63ED5B9
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhHPNNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239677AbhHPNLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1EAF6113D;
        Mon, 16 Aug 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119411;
        bh=BRtz3slX71brG4Bs8hBw1Osu+rYFy4MTVySo7WP9ZRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBzAYzqlbJG+wIEj6Tb7IHFhLNfTKTImZdtFRLTCR14wEZOivncemACz8BicUnXgk
         eMthU0vfZ7jigPi+su5UIm3qn71Yqbqd4ShYwMIptDPxd4aIuBl3PkYp/eFk9F3TeZ
         Dw2KT2ZOkUgzBNRamLC8KuJO8PVIblTUZwuDEoik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 016/151] cifs: Call close synchronously during unlink/rename/lease break.
Date:   Mon, 16 Aug 2021 15:00:46 +0200
Message-Id: <20210816125444.610096891@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

commit 9e992755be8f2d458a0bcbefd19e493483c1dba2 upstream.

During unlink/rename/lease break, deferred work for close is
scheduled immediately but in an asynchronous manner which might
lead to race with actual(unlink/rename) commands.

This change will schedule close synchronously which will avoid
the race conditions with other commands.

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org # 5.13
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h |    5 +++++
 fs/cifs/file.c     |   35 +++++++++++++++++------------------
 fs/cifs/misc.c     |   46 ++++++++++++++++++++++++++++++++++------------
 3 files changed, 56 insertions(+), 30 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1615,6 +1615,11 @@ struct dfs_info3_param {
 	int ttl;
 };
 
+struct file_list {
+	struct list_head list;
+	struct cifsFileInfo *cfile;
+};
+
 /*
  * common struct for holding inode info when searching for or updating an
  * inode with new info
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4860,34 +4860,33 @@ void cifs_oplock_break(struct work_struc
 
 oplock_break_ack:
 	/*
-	 * releasing stale oplock after recent reconnect of smb session using
-	 * a now incorrect file handle is not a data integrity issue but do
-	 * not bother sending an oplock release if session to server still is
-	 * disconnected since oplock already released by the server
-	 */
-	if (!cfile->oplock_break_cancelled) {
-		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
-							     cinode);
-		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
-	}
-	/*
 	 * When oplock break is received and there are no active
 	 * file handles but cached, then schedule deferred close immediately.
 	 * So, new open will not use cached handle.
 	 */
 	spin_lock(&CIFS_I(inode)->deferred_lock);
 	is_deferred = cifs_is_deferred_close(cfile, &dclose);
+	spin_unlock(&CIFS_I(inode)->deferred_lock);
 	if (is_deferred &&
 	    cfile->deferred_close_scheduled &&
 	    delayed_work_pending(&cfile->deferred)) {
-		/*
-		 * If there is no pending work, mod_delayed_work queues new work.
-		 * So, Increase the ref count to avoid use-after-free.
-		 */
-		if (!mod_delayed_work(deferredclose_wq, &cfile->deferred, 0))
-			cifsFileInfo_get(cfile);
+		if (cancel_delayed_work(&cfile->deferred)) {
+			_cifsFileInfo_put(cfile, false, false);
+			goto oplock_break_done;
+		}
 	}
-	spin_unlock(&CIFS_I(inode)->deferred_lock);
+	/*
+	 * releasing stale oplock after recent reconnect of smb session using
+	 * a now incorrect file handle is not a data integrity issue but do
+	 * not bother sending an oplock release if session to server still is
+	 * disconnected since oplock already released by the server
+	 */
+	if (!cfile->oplock_break_cancelled) {
+		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
+							     cinode);
+		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
+	}
+oplock_break_done:
 	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -735,20 +735,32 @@ void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *cfile = NULL;
+	struct file_list *tmp_list, *tmp_next_list;
+	struct list_head file_head;
 
 	if (cifs_inode == NULL)
 		return;
 
+	INIT_LIST_HEAD(&file_head);
+	spin_lock(&cifs_inode->open_file_lock);
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
-			/*
-			 * If there is no pending work, mod_delayed_work queues new work.
-			 * So, Increase the ref count to avoid use-after-free.
-			 */
-			if (!mod_delayed_work(deferredclose_wq, &cfile->deferred, 0))
-				cifsFileInfo_get(cfile);
+			if (cancel_delayed_work(&cfile->deferred)) {
+				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
+				if (tmp_list == NULL)
+					continue;
+				tmp_list->cfile = cfile;
+				list_add_tail(&tmp_list->list, &file_head);
+			}
 		}
 	}
+	spin_unlock(&cifs_inode->open_file_lock);
+
+	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
+		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		list_del(&tmp_list->list);
+		kfree(tmp_list);
+	}
 }
 
 void
@@ -756,20 +768,30 @@ cifs_close_all_deferred_files(struct cif
 {
 	struct cifsFileInfo *cfile;
 	struct list_head *tmp;
+	struct file_list *tmp_list, *tmp_next_list;
+	struct list_head file_head;
 
+	INIT_LIST_HEAD(&file_head);
 	spin_lock(&tcon->open_file_lock);
 	list_for_each(tmp, &tcon->openFileList) {
 		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
 		if (delayed_work_pending(&cfile->deferred)) {
-			/*
-			 * If there is no pending work, mod_delayed_work queues new work.
-			 * So, Increase the ref count to avoid use-after-free.
-			 */
-			if (!mod_delayed_work(deferredclose_wq, &cfile->deferred, 0))
-				cifsFileInfo_get(cfile);
+			if (cancel_delayed_work(&cfile->deferred)) {
+				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
+				if (tmp_list == NULL)
+					continue;
+				tmp_list->cfile = cfile;
+				list_add_tail(&tmp_list->list, &file_head);
+			}
 		}
 	}
 	spin_unlock(&tcon->open_file_lock);
+
+	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
+		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		list_del(&tmp_list->list);
+		kfree(tmp_list);
+	}
 }
 
 /* parses DFS refferal V3 structure


