Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FA44920ED
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343907AbiARIHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343799AbiARIHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:07:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51BFC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43AB3613F9
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2100CC00446;
        Tue, 18 Jan 2022 08:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642493266;
        bh=KmOyuksjd+cNaG7aIPo4XndR46NzAYFv6CP7ipFFD/k=;
        h=Subject:To:Cc:From:Date:From;
        b=vSw1P+dS79J4RHhnG4JmpiQBhwrPYxT1JfKfTvk36aQ1gxovNlFqEbnmguesTGNN0
         UV+1WO74DaIjDbIjW/sqJB0DmolN2jtuDEFVvDWdjNK+qBZGNqcEq0hmGepadK9IbU
         npDcEgR0WN64YiS+yXYONc4DHvG/O971fQUQGYeE=
Subject: FAILED: patch "[PATCH] 9p: only copy valid iattrs in 9P2000.L setattr implementation" failed to apply to 5.4-stable tree
To:     christian.brauner@ubuntu.com, asmadeus@codewreck.org,
        ericvh@gmail.com, lucho@ionkov.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 09:07:28 +0100
Message-ID: <164249324816447@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3cb6ee991496b67ee284c6895a0ba007e2d7bac3 Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Mon, 29 Nov 2021 12:44:34 +0100
Subject: [PATCH] 9p: only copy valid iattrs in 9P2000.L setattr implementation

The 9P2000.L setattr method v9fs_vfs_setattr_dotl() copies struct iattr
values without checking whether they are valid causing unitialized
values to be copied. The 9P2000 setattr method v9fs_vfs_setattr() method
gets this right. Check whether struct iattr fields are valid first
before copying in v9fs_vfs_setattr_dotl() too and make sure that all
other fields are set to 0 apart from {g,u}id which should be set to
INVALID_{G,U}ID. This ensure that they can be safely sent over the wire
or printed for debugging later on.

Link: https://lkml.kernel.org/r/20211129114434.3637938-1-brauner@kernel.org
Link: https://lkml.kernel.org/r/000000000000a0d53f05d1c72a4c%40google.com
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: stable@kernel.org
Cc: v9fs-developer@lists.sourceforge.net
Reported-by: syzbot+dfac92a50024b54acaa4@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
[Dominique: do not set a/mtime with just ATTR_A/MTIME as discussed]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 7dee89ba32e7..52f8ae79db21 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -551,7 +551,10 @@ int v9fs_vfs_setattr_dotl(struct user_namespace *mnt_userns,
 {
 	int retval, use_dentry = 0;
 	struct p9_fid *fid = NULL;
-	struct p9_iattr_dotl p9attr;
+	struct p9_iattr_dotl p9attr = {
+		.uid = INVALID_UID,
+		.gid = INVALID_GID,
+	};
 	struct inode *inode = d_inode(dentry);
 
 	p9_debug(P9_DEBUG_VFS, "\n");
@@ -561,14 +564,22 @@ int v9fs_vfs_setattr_dotl(struct user_namespace *mnt_userns,
 		return retval;
 
 	p9attr.valid = v9fs_mapped_iattr_valid(iattr->ia_valid);
-	p9attr.mode = iattr->ia_mode;
-	p9attr.uid = iattr->ia_uid;
-	p9attr.gid = iattr->ia_gid;
-	p9attr.size = iattr->ia_size;
-	p9attr.atime_sec = iattr->ia_atime.tv_sec;
-	p9attr.atime_nsec = iattr->ia_atime.tv_nsec;
-	p9attr.mtime_sec = iattr->ia_mtime.tv_sec;
-	p9attr.mtime_nsec = iattr->ia_mtime.tv_nsec;
+	if (iattr->ia_valid & ATTR_MODE)
+		p9attr.mode = iattr->ia_mode;
+	if (iattr->ia_valid & ATTR_UID)
+		p9attr.uid = iattr->ia_uid;
+	if (iattr->ia_valid & ATTR_GID)
+		p9attr.gid = iattr->ia_gid;
+	if (iattr->ia_valid & ATTR_SIZE)
+		p9attr.size = iattr->ia_size;
+	if (iattr->ia_valid & ATTR_ATIME_SET) {
+		p9attr.atime_sec = iattr->ia_atime.tv_sec;
+		p9attr.atime_nsec = iattr->ia_atime.tv_nsec;
+	}
+	if (iattr->ia_valid & ATTR_MTIME_SET) {
+		p9attr.mtime_sec = iattr->ia_mtime.tv_sec;
+		p9attr.mtime_nsec = iattr->ia_mtime.tv_nsec;
+	}
 
 	if (iattr->ia_valid & ATTR_FILE) {
 		fid = iattr->ia_file->private_data;

