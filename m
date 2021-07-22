Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B133D26AC
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhGVOvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232217AbhGVOvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D88561279;
        Thu, 22 Jul 2021 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626967899;
        bh=aJKrrWsmykOMnFps4UmPZX2SQzn85SNT0bFaWCjEcR8=;
        h=Subject:To:Cc:From:Date:From;
        b=K0fqBa6lLfEmKEA7ZKDcf5RpvA1aqvvdW3sA8fyy4SyIakuHbhWwG2YAdcMyUSWTC
         84JNPTzVC/4VYUs9o+3gf/eL3D0VJ6fmkNH6utRvAZslFSZDmDjn596Gcw0Mw8UHQo
         XLKxiaZhYmWz+vg+Qb2ELsGAyOAjX6H6QXd4rtP8=
Subject: FAILED: patch "[PATCH] vboxsf: Honor excl flag to the dir-inode create op" failed to apply to 5.10-stable tree
To:     hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:31:36 +0200
Message-ID: <1626967896238138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc3ddee97cff034cea4d095de4a484c92a219bf5 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Thu, 21 Jan 2021 10:08:59 +0100
Subject: [PATCH] vboxsf: Honor excl flag to the dir-inode create op

Honor the excl flag to the dir-inode create op, instead of behaving
as if it is always set.

Note the old behavior still worked most of the time since a non-exclusive
open only calls the create op, if there is a race and the file is created
between the dentry lookup and the calling of the create call.

While at it change the type of the is_dir parameter to the
vboxsf_dir_create() helper from an int to a bool, to be consistent with
the use of bool for the excl parameter.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index eac6788fc6cf..6ff84343edca 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -253,7 +253,7 @@ static int vboxsf_dir_instantiate(struct inode *parent, struct dentry *dentry,
 }
 
 static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
-			     umode_t mode, int is_dir)
+			     umode_t mode, bool is_dir, bool excl)
 {
 	struct vboxsf_inode *sf_parent_i = VBOXSF_I(parent);
 	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
@@ -261,10 +261,12 @@ static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
 	int err;
 
 	params.handle = SHFL_HANDLE_NIL;
-	params.create_flags = SHFL_CF_ACT_CREATE_IF_NEW |
-			      SHFL_CF_ACT_FAIL_IF_EXISTS |
-			      SHFL_CF_ACCESS_READWRITE |
-			      (is_dir ? SHFL_CF_DIRECTORY : 0);
+	params.create_flags = SHFL_CF_ACT_CREATE_IF_NEW | SHFL_CF_ACCESS_READWRITE;
+	if (is_dir)
+		params.create_flags |= SHFL_CF_DIRECTORY;
+	if (excl)
+		params.create_flags |= SHFL_CF_ACT_FAIL_IF_EXISTS;
+
 	params.info.attr.mode = (mode & 0777) |
 				(is_dir ? SHFL_TYPE_DIRECTORY : SHFL_TYPE_FILE);
 	params.info.attr.additional = SHFLFSOBJATTRADD_NOTHING;
@@ -292,14 +294,14 @@ static int vboxsf_dir_mkfile(struct user_namespace *mnt_userns,
 			     struct inode *parent, struct dentry *dentry,
 			     umode_t mode, bool excl)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 0);
+	return vboxsf_dir_create(parent, dentry, mode, false, excl);
 }
 
 static int vboxsf_dir_mkdir(struct user_namespace *mnt_userns,
 			    struct inode *parent, struct dentry *dentry,
 			    umode_t mode)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 1);
+	return vboxsf_dir_create(parent, dentry, mode, true, true);
 }
 
 static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)

