Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90E3D2A37
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhGVQKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235199AbhGVQIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31E2261DB8;
        Thu, 22 Jul 2021 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972505;
        bh=JkCW2x4ekEsXgQMxDAI+JwOMym1FFxFLC7TIw46Uq0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivWgOT9CMmNGc2jhKW6YOivFvGcJegH0fG2S3m36n1o/cJ1Fd3+6dvQWjBJPQptK/
         Rvo/ScFrLfedxZ5Xjri8hM7zGaM1NRV+upNJ61f8GXFqIZ4URTFpv6/IJe5IKyrDyn
         xGtUA5X61dTvKyGuSW0dtemDa3XVZpSHqVGhR4xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.13 138/156] vboxsf: Add vboxsf_[create|release]_sf_handle() helpers
Date:   Thu, 22 Jul 2021 18:31:53 +0200
Message-Id: <20210722155632.815897390@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 02f840f90764f22f5c898901849bdbf0cee752ba upstream.

Factor out the code to create / release a struct vboxsf_handle into
2 new helper functions.

This is a preparation patch for adding atomic_open support.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/vboxsf/file.c   |   71 ++++++++++++++++++++++++++++++++---------------------
 fs/vboxsf/vfsmod.h |    7 +++++
 2 files changed, 51 insertions(+), 27 deletions(-)

--- a/fs/vboxsf/file.c
+++ b/fs/vboxsf/file.c
@@ -20,17 +20,39 @@ struct vboxsf_handle {
 	struct list_head head;
 };
 
-static int vboxsf_file_open(struct inode *inode, struct file *file)
+struct vboxsf_handle *vboxsf_create_sf_handle(struct inode *inode,
+					      u64 handle, u32 access_flags)
 {
 	struct vboxsf_inode *sf_i = VBOXSF_I(inode);
-	struct shfl_createparms params = {};
 	struct vboxsf_handle *sf_handle;
-	u32 access_flags = 0;
-	int err;
 
 	sf_handle = kmalloc(sizeof(*sf_handle), GFP_KERNEL);
 	if (!sf_handle)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
+
+	/* the host may have given us different attr then requested */
+	sf_i->force_restat = 1;
+
+	/* init our handle struct and add it to the inode's handles list */
+	sf_handle->handle = handle;
+	sf_handle->root = VBOXSF_SBI(inode->i_sb)->root;
+	sf_handle->access_flags = access_flags;
+	kref_init(&sf_handle->refcount);
+
+	mutex_lock(&sf_i->handle_list_mutex);
+	list_add(&sf_handle->head, &sf_i->handle_list);
+	mutex_unlock(&sf_i->handle_list_mutex);
+
+	return sf_handle;
+}
+
+static int vboxsf_file_open(struct inode *inode, struct file *file)
+{
+	struct vboxsf_sbi *sbi = VBOXSF_SBI(inode->i_sb);
+	struct shfl_createparms params = {};
+	struct vboxsf_handle *sf_handle;
+	u32 access_flags = 0;
+	int err;
 
 	/*
 	 * We check the value of params.handle afterwards to find out if
@@ -83,23 +105,14 @@ static int vboxsf_file_open(struct inode
 	err = vboxsf_create_at_dentry(file_dentry(file), &params);
 	if (err == 0 && params.handle == SHFL_HANDLE_NIL)
 		err = (params.result == SHFL_FILE_EXISTS) ? -EEXIST : -ENOENT;
-	if (err) {
-		kfree(sf_handle);
+	if (err)
 		return err;
-	}
 
-	/* the host may have given us different attr then requested */
-	sf_i->force_restat = 1;
-
-	/* init our handle struct and add it to the inode's handles list */
-	sf_handle->handle = params.handle;
-	sf_handle->root = VBOXSF_SBI(inode->i_sb)->root;
-	sf_handle->access_flags = access_flags;
-	kref_init(&sf_handle->refcount);
-
-	mutex_lock(&sf_i->handle_list_mutex);
-	list_add(&sf_handle->head, &sf_i->handle_list);
-	mutex_unlock(&sf_i->handle_list_mutex);
+	sf_handle = vboxsf_create_sf_handle(inode, params.handle, access_flags);
+	if (IS_ERR(sf_handle)) {
+		vboxsf_close(sbi->root, params.handle);
+		return PTR_ERR(sf_handle);
+	}
 
 	file->private_data = sf_handle;
 	return 0;
@@ -114,22 +127,26 @@ static void vboxsf_handle_release(struct
 	kfree(sf_handle);
 }
 
-static int vboxsf_file_release(struct inode *inode, struct file *file)
+void vboxsf_release_sf_handle(struct inode *inode, struct vboxsf_handle *sf_handle)
 {
 	struct vboxsf_inode *sf_i = VBOXSF_I(inode);
-	struct vboxsf_handle *sf_handle = file->private_data;
 
+	mutex_lock(&sf_i->handle_list_mutex);
+	list_del(&sf_handle->head);
+	mutex_unlock(&sf_i->handle_list_mutex);
+
+	kref_put(&sf_handle->refcount, vboxsf_handle_release);
+}
+
+static int vboxsf_file_release(struct inode *inode, struct file *file)
+{
 	/*
 	 * When a file is closed on our (the guest) side, we want any subsequent
 	 * accesses done on the host side to see all changes done from our side.
 	 */
 	filemap_write_and_wait(inode->i_mapping);
 
-	mutex_lock(&sf_i->handle_list_mutex);
-	list_del(&sf_handle->head);
-	mutex_unlock(&sf_i->handle_list_mutex);
-
-	kref_put(&sf_handle->refcount, vboxsf_handle_release);
+	vboxsf_release_sf_handle(inode, file->private_data);
 	return 0;
 }
 
--- a/fs/vboxsf/vfsmod.h
+++ b/fs/vboxsf/vfsmod.h
@@ -18,6 +18,8 @@
 #define VBOXSF_SBI(sb)	((struct vboxsf_sbi *)(sb)->s_fs_info)
 #define VBOXSF_I(i)	container_of(i, struct vboxsf_inode, vfs_inode)
 
+struct vboxsf_handle;
+
 struct vboxsf_options {
 	unsigned long ttl;
 	kuid_t uid;
@@ -80,6 +82,11 @@ extern const struct file_operations vbox
 extern const struct address_space_operations vboxsf_reg_aops;
 extern const struct dentry_operations vboxsf_dentry_ops;
 
+/* from file.c */
+struct vboxsf_handle *vboxsf_create_sf_handle(struct inode *inode,
+					      u64 handle, u32 access_flags);
+void vboxsf_release_sf_handle(struct inode *inode, struct vboxsf_handle *sf_handle);
+
 /* from utils.c */
 struct inode *vboxsf_new_inode(struct super_block *sb);
 int vboxsf_init_inode(struct vboxsf_sbi *sbi, struct inode *inode,


