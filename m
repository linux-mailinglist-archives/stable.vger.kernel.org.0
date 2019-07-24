Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F8174603
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391353AbfGYFpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405272AbfGYFpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 967EA22BF3;
        Thu, 25 Jul 2019 05:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033551;
        bh=zNQupbiFs9PvuXXguj8gzL9X5NiI7yxyqCdNkPocXbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjRTzcYFjyGRQWO1spRKUWzzyfnF0s1q/tDTqTXuyrsQZr+z6ctRokM1ZziodPNYD
         7LbgmhkuxmwtdzPz/5AU+26UQAgy+unIEJPm+HT9OISlKVzXjCAlwdMX52rNnVdhOm
         vycr7oRsCG+Gv8gpfPziBvYIADmsL3mwo+qwdgkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 246/271] xfs: dont ever put nlink > 0 inodes on the unlinked list
Date:   Wed, 24 Jul 2019 21:21:55 +0200
Message-Id: <20190724191716.273954390@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c4a6bf7f6cc7eb4cce120fb7eb1e1fb8b2d65e09 upstream.

When XFS creates an O_TMPFILE file, the inode is created with nlink = 1,
put on the unlinked list, and then the VFS sets nlink = 0 in d_tmpfile.
If we crash before anything logs the inode (it's dirty incore but the
vfs doesn't tell us it's dirty so we never log that change), the iunlink
processing part of recovery will then explode with a pile of:

XFS: Assertion failed: VFS_I(ip)->i_nlink == 0, file:
fs/xfs/xfs_log_recover.c, line: 5072

Worse yet, since nlink is nonzero, the inodes also don't get cleaned up
and they just leak until the next xfs_repair run.

Therefore, change xfs_iunlink to require that inodes being put on the
unlinked list have nlink == 0, change the tmpfile callers to instantiate
nodes that way, and set the nlink to 1 just prior to calling d_tmpfile.
Fix the comment for xfs_iunlink while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c | 16 ++++++----------
 fs/xfs/xfs_iops.c  | 13 +++++++++++--
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ae07baa7bdbf..5ed84d6c7059 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1332,7 +1332,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip);
+	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1907,11 +1907,8 @@ xfs_inactive(
 }
 
 /*
- * This is called when the inode's link count goes to 0 or we are creating a
- * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
- * set to true as the link count is dropped to zero by the VFS after we've
- * created the file successfully, so we have to add it to the unlinked list
- * while the link count is non-zero.
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
  *
  * We place the on-disk inode on a list in the AGI.  It will be pulled from this
  * list when the inode is freed.
@@ -1931,6 +1928,7 @@ xfs_iunlink(
 	int		offset;
 	int		error;
 
+	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 
 	/*
@@ -2837,11 +2835,9 @@ xfs_rename_alloc_whiteout(
 
 	/*
 	 * Prepare the tmpfile inode as if it were created through the VFS.
-	 * Otherwise, the link increment paths will complain about nlink 0->1.
-	 * Drop the link count as done by d_tmpfile(), complete the inode setup
-	 * and flag it as linkable.
+	 * Complete the inode setup and flag it as linkable.  nlink is already
+	 * zero, so we can skip the drop_nlink.
 	 */
-	drop_nlink(VFS_I(tmpfile));
 	xfs_setup_iops(tmpfile);
 	xfs_finish_inode_setup(tmpfile);
 	VFS_I(tmpfile)->i_state |= I_LINKABLE;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7a8d3e..1efef69a7f1c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -191,9 +191,18 @@ xfs_generic_create(
 
 	xfs_setup_iops(ip);
 
-	if (tmpfile)
+	if (tmpfile) {
+		/*
+		 * The VFS requires that any inode fed to d_tmpfile must have
+		 * nlink == 1 so that it can decrement the nlink in d_tmpfile.
+		 * However, we created the temp file with nlink == 0 because
+		 * we're not allowed to put an inode with nlink > 0 on the
+		 * unlinked list.  Therefore we have to set nlink to 1 so that
+		 * d_tmpfile can immediately set it back to zero.
+		 */
+		set_nlink(inode, 1);
 		d_tmpfile(dentry, inode);
-	else
+	} else
 		d_instantiate(dentry, inode);
 
 	xfs_finish_inode_setup(ip);
-- 
2.20.1



