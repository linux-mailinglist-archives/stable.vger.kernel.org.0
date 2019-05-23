Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFD6287BD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389761AbfEWTWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389471AbfEWTWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8BEA20868;
        Thu, 23 May 2019 19:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639363;
        bh=6w0XLcK3kA/Yt7EYerfmqZO1sv5gIWUrf5GK4rnJhIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXsZ78qZPgFF6CKvXReBFAfqk15LuG5P0Z99nMyksOeJkupVpXb7AVIEo0my9TVhA
         GhEZezaVHP6fYguMaXmxBmbBqRsskXMY5byqT9e67uSvxBD+N7YZNIx71Ld2c7V0jl
         jdNyQqwPL8sShZ5VaoIRvaFNI6B/IR+WKfoQLekk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.0 060/139] ovl: fix missing upper fs freeze protection on copy up for ioctl
Date:   Thu, 23 May 2019 21:05:48 +0200
Message-Id: <20190523181728.514620443@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 3428030da004a1128cbdcf93dc03e16f184d845b upstream.

Generalize the helper ovl_open_maybe_copy_up() and use it to copy up file
with data before FS_IOC_SETFLAGS ioctl.

The FS_IOC_SETFLAGS ioctl is a bit of an odd ball in vfs, which probably
caused the confusion.  File may be open O_RDONLY, but ioctl modifies the
file.  VFS does not call mnt_want_write_file() nor lock inode mutex, but
fs-specific code for FS_IOC_SETFLAGS does.  So ovl_ioctl() calls
mnt_want_write_file() for the overlay file, and fs-specific code calls
mnt_want_write_file() for upper fs file, but there was no call for
ovl_want_write() for copy up duration which prevents overlayfs from copying
up on a frozen upper fs.

Fixes: dab5ca8fd9dd ("ovl: add lsattr/chattr support")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/copy_up.c   |    6 +++---
 fs/overlayfs/file.c      |    5 ++---
 fs/overlayfs/overlayfs.h |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -909,14 +909,14 @@ static bool ovl_open_need_copy_up(struct
 	return true;
 }
 
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
+int ovl_maybe_copy_up(struct dentry *dentry, int flags)
 {
 	int err = 0;
 
-	if (ovl_open_need_copy_up(dentry, file_flags)) {
+	if (ovl_open_need_copy_up(dentry, flags)) {
 		err = ovl_want_write(dentry);
 		if (!err) {
-			err = ovl_copy_up_flags(dentry, file_flags);
+			err = ovl_copy_up_flags(dentry, flags);
 			ovl_drop_write(dentry);
 		}
 	}
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -116,11 +116,10 @@ static int ovl_real_fdget(const struct f
 
 static int ovl_open(struct inode *inode, struct file *file)
 {
-	struct dentry *dentry = file_dentry(file);
 	struct file *realfile;
 	int err;
 
-	err = ovl_open_maybe_copy_up(dentry, file->f_flags);
+	err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
 	if (err)
 		return err;
 
@@ -390,7 +389,7 @@ static long ovl_ioctl(struct file *file,
 		if (ret)
 			return ret;
 
-		ret = ovl_copy_up_with_data(file_dentry(file));
+		ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
 		if (!ret) {
 			ret = ovl_real_ioctl(file, cmd, arg);
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -421,7 +421,7 @@ extern const struct file_operations ovl_
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
+int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);


