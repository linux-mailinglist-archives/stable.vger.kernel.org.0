Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1D03CA666
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbhGOSro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236922AbhGOSr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73251613CF;
        Thu, 15 Jul 2021 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374672;
        bh=7yMWqCIA3d8qUk5SyDwTbY40Dj2FSKyVQne6PXQ9peQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUtsyjB6BY1fAfjN1I33BLM5kFrr6M24JpIvJcdvwNNwBDCkJF6O6UVA6sz7Jqsms
         4NA9HcQHBmxeqMbXxg8b7LfJ5zhVfx9ar30UP4frv7yuwNVd3Ezm4zHmvsBx3WklmE
         a9EfoXFE2xqaA5FpkHaDSboBVN4YRDufWa96PB5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 099/122] ubifs: Fix races between xattr_{set|get} and listxattr operations
Date:   Thu, 15 Jul 2021 20:39:06 +0200
Message-Id: <20210715182518.469044389@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit f4e3634a3b642225a530c292fdb1e8a4007507f5 upstream.

UBIFS may occur some problems with concurrent xattr_{set|get} and
listxattr operations, such as assertion failure, memory corruption,
stale xattr value[1].

Fix it by importing a new rw-lock in @ubifs_inode to serilize write
operations on xattr, concurrent read operations are still effective,
just like ext4.

[1] https://lore.kernel.org/linux-mtd/20200630130438.141649-1-houtao1@huawei.com

Fixes: 1e51764a3c2ac05a23 ("UBIFS: add new flash file system")
Cc: stable@vger.kernel.org  # v2.6+
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/super.c |    1 +
 fs/ubifs/ubifs.h |    2 ++
 fs/ubifs/xattr.c |   44 +++++++++++++++++++++++++++++++++-----------
 3 files changed, 36 insertions(+), 11 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -257,6 +257,7 @@ static struct inode *ubifs_alloc_inode(s
 	memset((void *)ui + sizeof(struct inode), 0,
 	       sizeof(struct ubifs_inode) - sizeof(struct inode));
 	mutex_init(&ui->ui_mutex);
+	init_rwsem(&ui->xattr_sem);
 	spin_lock_init(&ui->ui_lock);
 	return &ui->vfs_inode;
 };
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -356,6 +356,7 @@ struct ubifs_gced_idx_leb {
  * @ui_mutex: serializes inode write-back with the rest of VFS operations,
  *            serializes "clean <-> dirty" state changes, serializes bulk-read,
  *            protects @dirty, @bulk_read, @ui_size, and @xattr_size
+ * @xattr_sem: serilizes write operations (remove|set|create) on xattr
  * @ui_lock: protects @synced_i_size
  * @synced_i_size: synchronized size of inode, i.e. the value of inode size
  *                 currently stored on the flash; used only for regular file
@@ -409,6 +410,7 @@ struct ubifs_inode {
 	unsigned int bulk_read:1;
 	unsigned int compr_type:2;
 	struct mutex ui_mutex;
+	struct rw_semaphore xattr_sem;
 	spinlock_t ui_lock;
 	loff_t synced_i_size;
 	loff_t ui_size;
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -285,6 +285,7 @@ int ubifs_xattr_set(struct inode *host,
 	if (!xent)
 		return -ENOMEM;
 
+	down_write(&ubifs_inode(host)->xattr_sem);
 	/*
 	 * The extended attribute entries are stored in LNC, so multiple
 	 * look-ups do not involve reading the flash.
@@ -319,6 +320,7 @@ int ubifs_xattr_set(struct inode *host,
 	iput(inode);
 
 out_free:
+	up_write(&ubifs_inode(host)->xattr_sem);
 	kfree(xent);
 	return err;
 }
@@ -341,18 +343,19 @@ ssize_t ubifs_xattr_get(struct inode *ho
 	if (!xent)
 		return -ENOMEM;
 
+	down_read(&ubifs_inode(host)->xattr_sem);
 	xent_key_init(c, &key, host->i_ino, &nm);
 	err = ubifs_tnc_lookup_nm(c, &key, xent, &nm);
 	if (err) {
 		if (err == -ENOENT)
 			err = -ENODATA;
-		goto out_unlock;
+		goto out_cleanup;
 	}
 
 	inode = iget_xattr(c, le64_to_cpu(xent->inum));
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
-		goto out_unlock;
+		goto out_cleanup;
 	}
 
 	ui = ubifs_inode(inode);
@@ -374,7 +377,8 @@ ssize_t ubifs_xattr_get(struct inode *ho
 out_iput:
 	mutex_unlock(&ui->ui_mutex);
 	iput(inode);
-out_unlock:
+out_cleanup:
+	up_read(&ubifs_inode(host)->xattr_sem);
 	kfree(xent);
 	return err;
 }
@@ -406,16 +410,21 @@ ssize_t ubifs_listxattr(struct dentry *d
 	dbg_gen("ino %lu ('%pd'), buffer size %zd", host->i_ino,
 		dentry, size);
 
+	down_read(&host_ui->xattr_sem);
 	len = host_ui->xattr_names + host_ui->xattr_cnt;
-	if (!buffer)
+	if (!buffer) {
 		/*
 		 * We should return the minimum buffer size which will fit a
 		 * null-terminated list of all the extended attribute names.
 		 */
-		return len;
+		err = len;
+		goto out_err;
+	}
 
-	if (len > size)
-		return -ERANGE;
+	if (len > size) {
+		err = -ERANGE;
+		goto out_err;
+	}
 
 	lowest_xent_key(c, &key, host->i_ino);
 	while (1) {
@@ -437,8 +446,9 @@ ssize_t ubifs_listxattr(struct dentry *d
 		pxent = xent;
 		key_read(c, &xent->key, &key);
 	}
-
 	kfree(pxent);
+	up_read(&host_ui->xattr_sem);
+
 	if (err != -ENOENT) {
 		ubifs_err(c, "cannot find next direntry, error %d", err);
 		return err;
@@ -446,6 +456,10 @@ ssize_t ubifs_listxattr(struct dentry *d
 
 	ubifs_assert(c, written <= size);
 	return written;
+
+out_err:
+	up_read(&host_ui->xattr_sem);
+	return err;
 }
 
 static int remove_xattr(struct ubifs_info *c, struct inode *host,
@@ -504,6 +518,7 @@ int ubifs_purge_xattrs(struct inode *hos
 	ubifs_warn(c, "inode %lu has too many xattrs, doing a non-atomic deletion",
 		   host->i_ino);
 
+	down_write(&ubifs_inode(host)->xattr_sem);
 	lowest_xent_key(c, &key, host->i_ino);
 	while (1) {
 		xent = ubifs_tnc_next_ent(c, &key, &nm);
@@ -523,7 +538,7 @@ int ubifs_purge_xattrs(struct inode *hos
 			ubifs_ro_mode(c, err);
 			kfree(pxent);
 			kfree(xent);
-			return err;
+			goto out_err;
 		}
 
 		ubifs_assert(c, ubifs_inode(xino)->xattr);
@@ -535,7 +550,7 @@ int ubifs_purge_xattrs(struct inode *hos
 			kfree(xent);
 			iput(xino);
 			ubifs_err(c, "cannot remove xattr, error %d", err);
-			return err;
+			goto out_err;
 		}
 
 		iput(xino);
@@ -544,14 +559,19 @@ int ubifs_purge_xattrs(struct inode *hos
 		pxent = xent;
 		key_read(c, &xent->key, &key);
 	}
-
 	kfree(pxent);
+	up_write(&ubifs_inode(host)->xattr_sem);
+
 	if (err != -ENOENT) {
 		ubifs_err(c, "cannot find next direntry, error %d", err);
 		return err;
 	}
 
 	return 0;
+
+out_err:
+	up_write(&ubifs_inode(host)->xattr_sem);
+	return err;
 }
 
 /**
@@ -594,6 +614,7 @@ static int ubifs_xattr_remove(struct ino
 	if (!xent)
 		return -ENOMEM;
 
+	down_write(&ubifs_inode(host)->xattr_sem);
 	xent_key_init(c, &key, host->i_ino, &nm);
 	err = ubifs_tnc_lookup_nm(c, &key, xent, &nm);
 	if (err) {
@@ -618,6 +639,7 @@ static int ubifs_xattr_remove(struct ino
 	iput(inode);
 
 out_free:
+	up_write(&ubifs_inode(host)->xattr_sem);
 	kfree(xent);
 	return err;
 }


