Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F03137A4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhBHP2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232995AbhBHPYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:24:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C5DC64EB1;
        Mon,  8 Feb 2021 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797283;
        bh=eeZLm0gwuVMKgd8oJsyfhkpWbsqf7K69YBI0Pzqy5h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TySWFwSx0Ia8hLDzyv9CS0ZjDoN2AhlbM2ZFw3DjQ94W7mp1wehOJEM0upJULK+dX
         YugJHrS0eUaxVMbWkEDz9PBcyjwTJ44LjL6kuNlLHYrMaTUul7cJ1GGGx4gtBNMSQW
         r0Ich+B3xqwpdET8cd3ksXm2ffB73/+QY2scEIiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 055/120] ovl: avoid deadlock on directory ioctl
Date:   Mon,  8 Feb 2021 16:00:42 +0100
Message-Id: <20210208145820.615921124@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit b854cc659dcb80f172cb35dbedc15d39d49c383f upstream.

The function ovl_dir_real_file() currently uses the inode lock to serialize
writes to the od->upperfile field.

However, this function will get called by ovl_ioctl_set_flags(), which
utilizes the inode lock too.  In this case ovl_dir_real_file() will try to
claim a lock that is owned by a function in its call stack, which won't get
released before ovl_dir_real_file() returns.

Fix by replacing the open coded compare and exchange by an explicit atomic
op.

Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
Cc: stable@vger.kernel.org # v5.10
Reported-by: Icenowy Zheng <icenowy@aosc.io>
Tested-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/readdir.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -865,7 +865,7 @@ struct file *ovl_dir_real_file(const str
 
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
-	struct file *realfile = od->realfile;
+	struct file *old, *realfile = od->realfile;
 
 	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
 		return want_upper ? NULL : realfile;
@@ -874,29 +874,20 @@ struct file *ovl_dir_real_file(const str
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
 	if (!od->is_upper) {
-		struct inode *inode = file_inode(file);
-
 		realfile = READ_ONCE(od->upperfile);
 		if (!realfile) {
 			struct path upperpath;
 
 			ovl_path_upper(dentry, &upperpath);
 			realfile = ovl_dir_open_realfile(file, &upperpath);
+			if (IS_ERR(realfile))
+				return realfile;
 
-			inode_lock(inode);
-			if (!od->upperfile) {
-				if (IS_ERR(realfile)) {
-					inode_unlock(inode);
-					return realfile;
-				}
-				smp_store_release(&od->upperfile, realfile);
-			} else {
-				/* somebody has beaten us to it */
-				if (!IS_ERR(realfile))
-					fput(realfile);
-				realfile = od->upperfile;
+			old = cmpxchg_release(&od->upperfile, NULL, realfile);
+			if (old) {
+				fput(realfile);
+				realfile = old;
 			}
-			inode_unlock(inode);
 		}
 	}
 


