Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8479649254C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 13:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbiARMAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 07:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbiARMAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 07:00:36 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AD9C061574;
        Tue, 18 Jan 2022 04:00:35 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id l35-20020a05600c1d2300b0034d477271c1so3282000wms.3;
        Tue, 18 Jan 2022 04:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HA4ESTFs25OMuYhDg2twMGj0iH/c0h6PHoeBSRM4/oo=;
        b=m3BaXGK+q+hH9rY7V+dUYfVyTm0n1NZQtFtorEJk9FGcq0K4QNZAgo1o8RN2PpVMFD
         1AdZK5pGNheFGgNGuQ/IfPKmAR6tapK0qAkERTC2lp6W1nrjJswA0MBsKlV9bB9GUel/
         MiEzQ5SJt8mP32vxYj+dGZIbymZCUekpFdqqSX+tun1t3Ory5z5eCcamvM+81a/82jNm
         INtMHIFpQcDR8mCA2mIXmIvB/s+1qrpa7IKukhLygAnBfWEUxbFajJBWhk0HOHcD0B8u
         ZB1gDqIElny+rwmMFVxY6RWKvdwPy4wSuGHFImJCY71XpcaqYNGiL52ayohlvE8fjzze
         Em7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HA4ESTFs25OMuYhDg2twMGj0iH/c0h6PHoeBSRM4/oo=;
        b=LROmoudFNhrcxk06pKyGnoP3EoVBsqs1cjH6jQlD0BhwGPFXaXa7Z+aAyYSzsddAjQ
         PdnxxAZykEfioCR2ggcV9mVjvMqr+9wJ9tsUEZZ2uPHU1l4gtMY3+Gno+GzNXmOCcbC5
         Ig2+dgsXUay2+ZasedXqeUivB9SsFPF5OR8vBO3aOLO3Zsx/dhiU1hLyG6ffOmCjUwhP
         1oWK5iQ5K8EgU1ueSh5uKw6vYp/HS7kqJdQ7WRiKY5o40cCHJnDPUJGKv6prieeOnZAA
         6lWoS4J+5DmUBUUOX3BRMZcfZvX7Xx0mddf7wBMWxlKHh2Mh9ICrfef4GcbXEKsQzgat
         iTYw==
X-Gm-Message-State: AOAM533mg+9RfaQY4aj0mObinayvNRNjbxYEVx4lD8MTsHTAbKRDj9ln
        mVmXFepCEgwyL8wphm5VdHA=
X-Google-Smtp-Source: ABdhPJyvZAjjKPVT0+mBfA8mbZ6rWZP1tZAgd7e1S3GiT71MukQ1H80VPW+mUXSWumQrOMRrTxxMWA==
X-Received: by 2002:a5d:4584:: with SMTP id p4mr23536890wrq.607.1642507234232;
        Tue, 18 Jan 2022 04:00:34 -0800 (PST)
Received: from localhost.localdomain ([82.114.46.14])
        by smtp.gmail.com with ESMTPSA id m40sm2369188wms.34.2022.01.18.04.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 04:00:33 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Matthew Bobrowski <repnop@google.com>,
        Ivan Delalande <colona@arista.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] fnotify: invalidate dcache before IN_DELETE event
Date:   Tue, 18 Jan 2022 14:00:31 +0200
Message-Id: <20220118120031.196123-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apparently, there are some applications that use IN_DELETE event as an
invalidation mechanism and expect that if they try to open a file with
the name reported with the delete event, that it should not contain the
content of the deleted file.

Commit 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of
d_delete()") moved the fsnotify delete hook before d_delete() so fsnotify
will have access to a positive dentry.

This allowed a race where opening the deleted file via cached dentry
is now possible after receiving the IN_DELETE event.

To fix the regression, we use two different techniques:
1) For call sites that call d_delete() with elevated refcount, convert
   the call to d_drop() and move the fsnotify hook after d_drop().
2) For the vfs helpers that may turn dentry to negative on d_delete(),
   use a helper d_delete_notify() to pin the inode, so we can pass it
   to an fsnotify hook after d_delete().

Create a new hook fsnotify_delete() that allows to pass a negative
dentry and takes the unlinked inode as an argument.

Add a missing fsnotify_unlink() hook in nfsdfs that was found during
the call sites audit.

Note that the call sites in simple_recursive_removal() follow
d_invalidate(), so they require no change.

Backporting hint: this regression is from v5.3. Although patch will
apply with only trivial conflicts to v5.4 and v5.10, it won't build,
because fsnotify_delete() implementation is different in each of those
versions (see fsnotify_link()).

Reported-by: Ivan Delalande <colona@arista.com>
Link: https://lore.kernel.org/linux-fsdevel/YeNyzoDM5hP5LtGW@visor/
Fixes: 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of d_delete()")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Jan,

This turned into an audit of fsnotify_unlink/rmdir() call sites, so
besides fixing the regression, I also added one missing hook and replaced
most of the d_delete() calls with d_drop() to simplify things.

I will follow up with backports for v5.4 and v5.10 and will send the
repro to LTP guys.

Thanks,
Amir.

 fs/btrfs/ioctl.c         |  5 ++---
 fs/configfs/dir.c        |  6 +++---
 fs/devpts/inode.c        |  2 +-
 fs/namei.c               | 27 ++++++++++++++++++++++-----
 fs/nfsd/nfsctl.c         |  5 +++--
 include/linux/fsnotify.h | 20 ++++++++++++++++++++
 net/sunrpc/rpc_pipe.c    |  4 ++--
 7 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index edfecfe62b4b..121e8f439996 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3060,10 +3060,9 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	btrfs_inode_lock(inode, 0);
 	err = btrfs_delete_subvolume(dir, dentry);
 	btrfs_inode_unlock(inode, 0);
-	if (!err) {
+	d_drop(dentry);
+	if (!err)
 		fsnotify_rmdir(dir, dentry);
-		d_delete(dentry);
-	}
 
 out_dput:
 	dput(dentry);
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 1466b5d01cbb..d3cd2a94d1e8 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1780,8 +1780,8 @@ void configfs_unregister_group(struct config_group *group)
 	configfs_detach_group(&group->cg_item);
 	d_inode(dentry)->i_flags |= S_DEAD;
 	dont_mount(dentry);
+	d_drop(dentry);
 	fsnotify_rmdir(d_inode(parent), dentry);
-	d_delete(dentry);
 	inode_unlock(d_inode(parent));
 
 	dput(dentry);
@@ -1922,10 +1922,10 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	configfs_detach_group(&group->cg_item);
 	d_inode(dentry)->i_flags |= S_DEAD;
 	dont_mount(dentry);
-	fsnotify_rmdir(d_inode(root), dentry);
 	inode_unlock(d_inode(dentry));
 
-	d_delete(dentry);
+	d_drop(dentry);
+	fsnotify_rmdir(d_inode(root), dentry);
 
 	inode_unlock(d_inode(root));
 
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 42e5a766d33c..4f25015aa534 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -621,8 +621,8 @@ void devpts_pty_kill(struct dentry *dentry)
 
 	dentry->d_fsdata = NULL;
 	drop_nlink(dentry->d_inode);
-	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
 	d_drop(dentry);
+	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
 	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 1f9d2187c765..b11991b57f9b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3929,6 +3929,23 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
 }
 
+/**
+ * d_delete_notify - delete a dentry and call fsnotify_delete()
+ * @dentry: The dentry to delete
+ *
+ * This helper is used to guaranty that the unlinked inode cannot be found
+ * by lookup of this name after fsnotify_delete() event has been delivered.
+ */
+static void d_delete_notify(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = d_inode(dentry);
+
+	ihold(inode);
+	d_delete(dentry);
+	fsnotify_delete(dir, inode, dentry);
+	iput(inode);
+}
+
 /**
  * vfs_rmdir - remove directory
  * @mnt_userns:	user namespace of the mount the inode was found from
@@ -3973,13 +3990,12 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
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
@@ -4101,7 +4117,6 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
 			if (!error) {
 				dont_mount(dentry);
 				detach_mounts(dentry);
-				fsnotify_unlink(dir, dentry);
 			}
 		}
 	}
@@ -4109,9 +4124,11 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
 	inode_unlock(target);
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
-	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
+		fsnotify_unlink(dir, dentry);
+	} else if (!error) {
 		fsnotify_link_count(target);
-		d_delete(dentry);
+		d_delete_notify(dir, dentry);
 	}
 
 	return error;
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 51a49e0cfe37..d0761ca8cb54 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1249,7 +1249,8 @@ static void nfsdfs_remove_file(struct inode *dir, struct dentry *dentry)
 	clear_ncl(d_inode(dentry));
 	dget(dentry);
 	ret = simple_unlink(dir, dentry);
-	d_delete(dentry);
+	d_drop(dentry);
+	fsnotify_unlink(dir, dentry);
 	dput(dentry);
 	WARN_ON_ONCE(ret);
 }
@@ -1340,8 +1341,8 @@ void nfsd_client_rmdir(struct dentry *dentry)
 	dget(dentry);
 	ret = simple_rmdir(dir, dentry);
 	WARN_ON_ONCE(ret);
+	d_drop(dentry);
 	fsnotify_rmdir(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	inode_unlock(dir);
 }
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 3a2d7dc3c607..b4a4085adc89 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -224,6 +224,26 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode,
 		      dir, &new_dentry->d_name, 0);
 }
 
+/*
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
 /*
  * fsnotify_unlink - 'name' was unlinked
  *
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index ee5336d73fdd..35588f0afa86 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -600,9 +600,9 @@ static int __rpc_rmdir(struct inode *dir, struct dentry *dentry)
 
 	dget(dentry);
 	ret = simple_rmdir(dir, dentry);
+	d_drop(dentry);
 	if (!ret)
 		fsnotify_rmdir(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	return ret;
 }
@@ -613,9 +613,9 @@ static int __rpc_unlink(struct inode *dir, struct dentry *dentry)
 
 	dget(dentry);
 	ret = simple_unlink(dir, dentry);
+	d_drop(dentry);
 	if (!ret)
 		fsnotify_unlink(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	return ret;
 }
-- 
2.34.1

