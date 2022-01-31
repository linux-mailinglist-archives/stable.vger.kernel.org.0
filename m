Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC14A4A434B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349662AbiAaLUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50266 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358963AbiAaLQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0513460ED0;
        Mon, 31 Jan 2022 11:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B7DC340E8;
        Mon, 31 Jan 2022 11:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627817;
        bh=/2J71IQHV04YtvG+x0KtFRFNMteVquUGnfAUT22H+Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAhFowMzLY3y1f0/i46Hr6nKCoYyTtmNwW+8TlYq0NelmBwsJ8sBdBvXepWm4y4k+
         abuoHoS1eiOod3qjSVGt0TxmGZIhA4aBRMPeQaqXIzDB769OUHtoY7CQEj8KgDfPAP
         GLRAXF+ZQC0lBAGPo8OahRzqsJa517CxO9pnx4Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Delalande <colona@arista.com>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.16 035/200] fsnotify: invalidate dcache before IN_DELETE event
Date:   Mon, 31 Jan 2022 11:54:58 +0100
Message-Id: <20220131105234.747022009@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit a37d9a17f099072fe4d3a9048b0321978707a918 upstream.

Apparently, there are some applications that use IN_DELETE event as an
invalidation mechanism and expect that if they try to open a file with
the name reported with the delete event, that it should not contain the
content of the deleted file.

Commit 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of
d_delete()") moved the fsnotify delete hook before d_delete() so fsnotify
will have access to a positive dentry.

This allowed a race where opening the deleted file via cached dentry
is now possible after receiving the IN_DELETE event.

To fix the regression, create a new hook fsnotify_delete() that takes
the unlinked inode as an argument and use a helper d_delete_notify() to
pin the inode, so we can pass it to fsnotify_delete() after d_delete().

Backporting hint: this regression is from v5.3. Although patch will
apply with only trivial conflicts to v5.4 and v5.10, it won't build,
because fsnotify_delete() implementation is different in each of those
versions (see fsnotify_link()).

A follow up patch will fix the fsnotify_unlink/rmdir() calls in pseudo
filesystem that do not need to call d_delete().

Link: https://lore.kernel.org/r/20220120215305.282577-1-amir73il@gmail.com
Reported-by: Ivan Delalande <colona@arista.com>
Link: https://lore.kernel.org/linux-fsdevel/YeNyzoDM5hP5LtGW@visor/
Fixes: 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of d_delete()")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c         |    6 +----
 fs/namei.c               |   10 ++++-----
 include/linux/fsnotify.h |   49 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 50 insertions(+), 15 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3126,10 +3126,8 @@ static noinline int btrfs_ioctl_snap_des
 	btrfs_inode_lock(inode, 0);
 	err = btrfs_delete_subvolume(dir, dentry);
 	btrfs_inode_unlock(inode, 0);
-	if (!err) {
-		fsnotify_rmdir(dir, dentry);
-		d_delete(dentry);
-	}
+	if (!err)
+		d_delete_notify(dir, dentry);
 
 out_dput:
 	dput(dentry);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3973,13 +3973,12 @@ int vfs_rmdir(struct user_namespace *mnt
 	dentry->d_inode->i_flags |= S_DEAD;
 	dont_mount(dentry);
 	detach_mounts(dentry);
-	fsnotify_rmdir(dir, dentry);
 
 out:
 	inode_unlock(dentry->d_inode);
 	dput(dentry);
 	if (!error)
-		d_delete(dentry);
+		d_delete_notify(dir, dentry);
 	return error;
 }
 EXPORT_SYMBOL(vfs_rmdir);
@@ -4101,7 +4100,6 @@ int vfs_unlink(struct user_namespace *mn
 			if (!error) {
 				dont_mount(dentry);
 				detach_mounts(dentry);
-				fsnotify_unlink(dir, dentry);
 			}
 		}
 	}
@@ -4109,9 +4107,11 @@ out:
 	inode_unlock(target);
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
-	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+	if (!error && dentry->d_flags & DCACHE_NFSFS_RENAMED) {
+		fsnotify_unlink(dir, dentry);
+	} else if (!error) {
 		fsnotify_link_count(target);
-		d_delete(dentry);
+		d_delete_notify(dir, dentry);
 	}
 
 	return error;
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -222,16 +222,53 @@ static inline void fsnotify_link(struct
 }
 
 /*
+ * fsnotify_delete - @dentry was unlinked and unhashed
+ *
+ * Caller must make sure that dentry->d_name is stable.
+ *
+ * Note: unlike fsnotify_unlink(), we have to pass also the unlinked inode
+ * as this may be called after d_delete() and old_dentry may be negative.
+ */
+static inline void fsnotify_delete(struct inode *dir, struct inode *inode,
+				   struct dentry *dentry)
+{
+	__u32 mask = FS_DELETE;
+
+	if (S_ISDIR(inode->i_mode))
+		mask |= FS_ISDIR;
+
+	fsnotify_name(mask, inode, FSNOTIFY_EVENT_INODE, dir, &dentry->d_name,
+		      0);
+}
+
+/**
+ * d_delete_notify - delete a dentry and call fsnotify_delete()
+ * @dentry: The dentry to delete
+ *
+ * This helper is used to guaranty that the unlinked inode cannot be found
+ * by lookup of this name after fsnotify_delete() event has been delivered.
+ */
+static inline void d_delete_notify(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = d_inode(dentry);
+
+	ihold(inode);
+	d_delete(dentry);
+	fsnotify_delete(dir, inode, dentry);
+	iput(inode);
+}
+
+/*
  * fsnotify_unlink - 'name' was unlinked
  *
  * Caller must make sure that dentry->d_name is stable.
  */
 static inline void fsnotify_unlink(struct inode *dir, struct dentry *dentry)
 {
-	/* Expected to be called before d_delete() */
-	WARN_ON_ONCE(d_is_negative(dentry));
+	if (WARN_ON_ONCE(d_is_negative(dentry)))
+		return;
 
-	fsnotify_dirent(dir, dentry, FS_DELETE);
+	fsnotify_delete(dir, d_inode(dentry), dentry);
 }
 
 /*
@@ -255,10 +292,10 @@ static inline void fsnotify_mkdir(struct
  */
 static inline void fsnotify_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	/* Expected to be called before d_delete() */
-	WARN_ON_ONCE(d_is_negative(dentry));
+	if (WARN_ON_ONCE(d_is_negative(dentry)))
+		return;
 
-	fsnotify_dirent(dir, dentry, FS_DELETE | FS_ISDIR);
+	fsnotify_delete(dir, d_inode(dentry), dentry);
 }
 
 /*


