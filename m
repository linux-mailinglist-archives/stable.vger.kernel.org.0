Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3902478CCB
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbhLQNvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:51:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49552 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbhLQNvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:51:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A722E62213
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 13:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CC1C36AE1;
        Fri, 17 Dec 2021 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639749109;
        bh=p8oCCY3+oL1guPuPEaT4T8L6GnI9t4RGLV2pfwYEbPQ=;
        h=Subject:To:Cc:From:Date:From;
        b=EZEKX6TH1tTEsesP3ROmE+BuZrnssFCGCzJrRCiYch8DDwymrJBF6N+WGTaZNfcJE
         PomnNAHLcRRwthhK3QYdPujpxGGLJ45lBTWAZ4LP2f3w1jokHlCAZysAaXQaETSVj+
         VEnVNxSz3AurieWsPdipApkHVschWPUpMwsbV7rM=
Subject: FAILED: patch "[PATCH] ceph: fix up non-directory creation in SGID directories" failed to apply to 5.10-stable tree
To:     christian.brauner@ubuntu.com, idryomov@gmail.com,
        jlayton@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Dec 2021 14:51:46 +0100
Message-ID: <163974910684103@kroah.com>
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

From fd84bfdddd169c219c3a637889a8b87f70a072c2 Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Mon, 29 Nov 2021 12:16:39 +0100
Subject: [PATCH] ceph: fix up non-directory creation in SGID directories

Ceph always inherits the SGID bit if it is set on the parent inode,
while the generic inode_init_owner does not do this in a few cases where
it can create a possible security problem (cf. [1]).

Update ceph to strip the SGID bit just as inode_init_owner would.

This bug was detected by the mapped mount testsuite in [3]. The
testsuite tests all core VFS functionality and semantics with and
without mapped mounts. That is to say it functions as a generic VFS
testsuite in addition to a mapped mount testsuite. While working on
mapped mount support for ceph, SIGD inheritance was the only failing
test for ceph after the port.

The same bug was detected by the mapped mount testsuite in XFS in
January 2021 (cf. [2]).

[1]: commit 0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
[2]: commit 01ea173e103e ("xfs: fix up non-directory creation in SGID directories")
[3]: https://git.kernel.org/fs/xfs/xfstests-dev.git

Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index b24442e27e4e..c138e8126286 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -605,13 +605,25 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.cap.realm = cpu_to_le64(ci->i_snap_realm->ino);
 	in.cap.flags = CEPH_CAP_FLAG_AUTH;
 	in.ctime = in.mtime = in.atime = iinfo.btime;
-	in.mode = cpu_to_le32((u32)mode);
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
 	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
-	in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_mode & S_ISGID ?
-				dir->i_gid : current_fsgid()));
+	if (dir->i_mode & S_ISGID) {
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
+
+		/* Directories always inherit the setgid bit. */
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
+			 !in_group_p(dir->i_gid) &&
+			 !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
+			mode &= ~S_ISGID;
+	} else {
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
+	}
+	in.mode = cpu_to_le32((u32)mode);
+
 	in.nlink = cpu_to_le32(1);
 	in.max_size = cpu_to_le64(lo->stripe_unit);
 

