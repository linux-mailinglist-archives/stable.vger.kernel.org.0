Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7463451330
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347886AbhKOTsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:48:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245457AbhKOTUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C882763543;
        Mon, 15 Nov 2021 18:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001302;
        bh=Pr59h03XGWYuT65ux/Vp28vFAiQUb36H4exyA+ikFmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJGJ0oh4eRWeEyElxsclh9liqtPV9XaqyjRfZuKMImLUuwwn+POmKElez0q7T5kC7
         bevO9IXApoGl6sDRE812A7jv8+VgmrbXdZg1gUyPm13wU0js7YkS1XOCqxaLYTfvj0
         Q0W0hoqjNVVUZ9b029gvr2vS7h3S6q39kdlPIVrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Kevin Locke <kevin@kevinlocke.name>
Subject: [PATCH 5.15 139/917] ovl: fix filattr copy-up failure
Date:   Mon, 15 Nov 2021 17:53:54 +0100
Message-Id: <20211115165433.482700314@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 5b0a414d06c3ed2097e32ef7944a4abb644b89bd upstream.

This regression can be reproduced with ntfs-3g and overlayfs:

  mkdir lower upper work overlay
  dd if=/dev/zero of=ntfs.raw bs=1M count=2
  mkntfs -F ntfs.raw
  mount ntfs.raw lower
  touch lower/file.txt
  mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work - overlay
  mv overlay/file.txt overlay/file2.txt

mv fails and (misleadingly) prints

  mv: cannot move 'overlay/file.txt' to a subdirectory of itself, 'overlay/file2.txt'

The reason is that ovl_copy_fileattr() is triggered due to S_NOATIME being
set on all inodes (by fuse) regardless of fileattr.

ovl_copy_fileattr() tries to retrieve file attributes from lower file, but
that fails because filesystem does not support this ioctl (this should fail
with ENOTTY, but ntfs-3g return EINVAL instead).  This failure is
propagated to origial operation (in this case rename) that triggered the
copy-up.

The fix is to ignore ENOTTY and EINVAL errors from fileattr_get() in copy
up.  This also requires turning the internal ENOIOCTLCMD into ENOTTY.

As a further measure to prevent unnecessary failures, only try the
fileattr_get/set on upper if there are any flags to copy up.

Side note: a number of filesystems set S_NOATIME (and sometimes other inode
flags) irrespective of fileattr flags.  This causes unnecessary calls
during copy up, which might lead to a performance issue, especially if
latency is high.  To fix this, the kernel would need to differentiate
between the two cases.  E.g. introduce SB_NOATIME_UPDATE, a per-sb variant
of S_NOATIME.  SB_NOATIME doesn't work, because that's interpreted as
"filesystem doesn't store an atime attribute"

Reported-and-tested-by: Kevin Locke <kevin@kevinlocke.name>
Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
Cc: <stable@vger.kernel.org> # v5.15
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   23 ++++++++++++++++++-----
 fs/overlayfs/inode.c   |    5 ++++-
 2 files changed, 22 insertions(+), 6 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -140,12 +140,14 @@ static int ovl_copy_fileattr(struct inod
 	int err;
 
 	err = ovl_real_fileattr_get(old, &oldfa);
-	if (err)
-		return err;
-
-	err = ovl_real_fileattr_get(new, &newfa);
-	if (err)
+	if (err) {
+		/* Ntfs-3g returns -EINVAL for "no fileattr support" */
+		if (err == -ENOTTY || err == -EINVAL)
+			return 0;
+		pr_warn("failed to retrieve lower fileattr (%pd2, err=%i)\n",
+			old, err);
 		return err;
+	}
 
 	/*
 	 * We cannot set immutable and append-only flags on upper inode,
@@ -159,6 +161,17 @@ static int ovl_copy_fileattr(struct inod
 			return err;
 	}
 
+	/* Don't bother copying flags if none are set */
+	if (!(oldfa.flags & OVL_COPY_FS_FLAGS_MASK))
+		return 0;
+
+	err = ovl_real_fileattr_get(new, &newfa);
+	if (err) {
+		pr_warn("failed to retrieve upper fileattr (%pd2, err=%i)\n",
+			new, err);
+		return err;
+	}
+
 	BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
 	newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
 	newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -610,7 +610,10 @@ int ovl_real_fileattr_get(struct path *r
 	if (err)
 		return err;
 
-	return vfs_fileattr_get(realpath->dentry, fa);
+	err = vfs_fileattr_get(realpath->dentry, fa);
+	if (err == -ENOIOCTLCMD)
+		err = -ENOTTY;
+	return err;
 }
 
 int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa)


