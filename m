Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAFF6D719
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391701AbfGRXGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37821 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id i70so2810920pgd.4;
        Thu, 18 Jul 2019 16:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vmLjoAykF7SC/W4iSm7Wt7PkUxoMMGGLnWy2r5LRqEE=;
        b=YULNQLZyQA2C4oymezVOwMbfu8JcqUusiR93XA1nh2cUAl5MumaFhCNPGC253gzPsL
         jbEC5O4fkCQyfAlFlKvE40aAgtD09manJFPKjvTBJhxDKN6bsxeKByhZCDkLRf6wcx2h
         kEyCd6jE93T3sa4Nn31gJdMIJI561OS8wKY0hX6KQIQPS8UxV4gQCQ+37VQjgjFntzqI
         QRX1pmBxb9qC5sKjJlmwG6MrnS7JVCGJ5x0pd1hcwdQplpJ8eAW7KP+4Bfvgdw5uF8O/
         no+9MEHNpr3uqzJPOrvhexrjlAC61F8u41OTWjG5SzLh9DYGwG5o3BMQxooYZWzJ0Gvl
         6y3w==
X-Gm-Message-State: APjAAAVDfwEL2RAIbkI+9ra9Fa9t8VaRYURlyWeieB6VR8M6hY6/Bss9
        l13YYK7tG1U5HRRZz22inr8=
X-Google-Smtp-Source: APXvYqxHvghnpumeN8uqUXgjgbta+fe/HsXKb0cb65cRzkBkkvsi5UeEkRyNBtbPPPnxEV+jri9hsw==
X-Received: by 2002:a17:90a:cf8f:: with SMTP id i15mr4025698pju.110.1563491189702;
        Thu, 18 Jul 2019 16:06:29 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id h70sm22615444pgc.36.2019.07.18.16.06.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:26 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 5327E41399; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5/9] xfs: don't ever put nlink > 0 inodes on the unlinked list
Date:   Thu, 18 Jul 2019 23:06:13 +0000
Message-Id: <20190718230617.7439-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

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

