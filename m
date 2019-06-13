Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF61043F43
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbfFMPzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbfFMIvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECCD6215EA;
        Thu, 13 Jun 2019 08:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415897;
        bh=PH6dG94hNLWF7W1sTLFFWbqMCAI3bu5OdGA+wHUVEiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvUrYAFbFHisBrvfWT3JSvvVGdQ7Mp9hiJxbQ872ixM2yVPTYGY31hPa/17/jaLNw
         3LsdmoA+PtpF0OkLGNxOR5OveKJHuCQmtvVD/AtlKbtxtWuZY/7g0h5r0R8SIWxlFt
         rGQASZoVPULv/qylrUDyP0rx9gCygNPml8IaPpAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.1 154/155] ovl: check the capability before cred overridden
Date:   Thu, 13 Jun 2019 10:34:26 +0200
Message-Id: <20190613075701.378918396@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

commit 98487de318a6f33312471ae1e2afa16fbf8361fe upstream.

We found that it return success when we set IMMUTABLE_FL flag to a file in
docker even though the docker didn't have the capability
CAP_LINUX_IMMUTABLE.

The commit d1d04ef8572b ("ovl: stack file ops") and dab5ca8fd9dd ("ovl: add
lsattr/chattr support") implemented chattr operations on a regular overlay
file. ovl_real_ioctl() overridden the current process's subjective
credentials with ofs->creator_cred which have the capability
CAP_LINUX_IMMUTABLE so that it will return success in
vfs_ioctl()->cap_capable().

Fix this by checking the capability before cred overridden. And here we
only care about APPEND_FL and IMMUTABLE_FL, so get these information from
inode.

[SzM: move check and call to underlying fs inside inode locked region to
prevent two such calls from racing with each other]

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/file.c |   79 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 18 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -11,6 +11,7 @@
 #include <linux/mount.h>
 #include <linux/xattr.h>
 #include <linux/uio.h>
+#include <linux/uaccess.h>
 #include "overlayfs.h"
 
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -372,10 +373,68 @@ static long ovl_real_ioctl(struct file *
 	return ret;
 }
 
-static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static unsigned int ovl_get_inode_flags(struct inode *inode)
+{
+	unsigned int flags = READ_ONCE(inode->i_flags);
+	unsigned int ovl_iflags = 0;
+
+	if (flags & S_SYNC)
+		ovl_iflags |= FS_SYNC_FL;
+	if (flags & S_APPEND)
+		ovl_iflags |= FS_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		ovl_iflags |= FS_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		ovl_iflags |= FS_NOATIME_FL;
+
+	return ovl_iflags;
+}
+
+static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
+	unsigned int flags;
+	unsigned int old_flags;
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	if (get_user(flags, (int __user *) arg))
+		return -EFAULT;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	inode_lock(inode);
+
+	/* Check the capability before cred override */
+	ret = -EPERM;
+	old_flags = ovl_get_inode_flags(inode);
+	if (((flags ^ old_flags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) &&
+	    !capable(CAP_LINUX_IMMUTABLE))
+		goto unlock;
+
+	ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
+	if (ret)
+		goto unlock;
+
+	ret = ovl_real_ioctl(file, FS_IOC_SETFLAGS, arg);
+
+	ovl_copyflags(ovl_inode_real(inode), inode);
+unlock:
+	inode_unlock(inode);
+
+	mnt_drop_write_file(file);
+
+	return ret;
+
+}
+
+static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
@@ -383,23 +442,7 @@ static long ovl_ioctl(struct file *file,
 		break;
 
 	case FS_IOC_SETFLAGS:
-		if (!inode_owner_or_capable(inode))
-			return -EACCES;
-
-		ret = mnt_want_write_file(file);
-		if (ret)
-			return ret;
-
-		ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
-		if (!ret) {
-			ret = ovl_real_ioctl(file, cmd, arg);
-
-			inode_lock(inode);
-			ovl_copyflags(ovl_inode_real(inode), inode);
-			inode_unlock(inode);
-		}
-
-		mnt_drop_write_file(file);
+		ret = ovl_ioctl_set_flags(file, arg);
 		break;
 
 	default:


