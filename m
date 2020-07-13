Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2750621D3CE
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 12:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgGMKeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 06:34:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:54114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgGMKeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 06:34:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B92A6AE54;
        Mon, 13 Jul 2020 10:34:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6E9DADA809; Mon, 13 Jul 2020 12:33:50 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH v2] btrfs: add missing check for nocow and compression inode flags
Date:   Mon, 13 Jul 2020 12:33:49 +0200
Message-Id: <20200713103349.22448-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200710100553.13567-1-dsterba@suse.com>
References: <20200710100553.13567-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

User Forza reported on IRC that some invalid combinations of file
attributes are accepted by chattr.

The NODATACOW and compression file flags/attributes are mutually
exclusive, but they could be set by 'chattr +c +C' on an empty file. The
nodatacow will be in effect because it's checked first in
btrfs_run_delalloc_range.

Extend the flag validation to catch the following cases:

  - input flags are conflicting
  - old and new flags are conflicting
  - initialize the local variable with inode flags after inode ls locked

Inode attributes take precedence over mount options and are an
independent setting.

Nocompress would be a no-op with nodatacow, but we don't want to mix
any compression-related options with nodatacow.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---

v2:
- update chanelog: mount options vs attributes, nocompress vs nodatacow

 fs/btrfs/ioctl.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3a566cf71fc6..0c13bb38425b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -164,8 +164,11 @@ static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 	return 0;
 }
 
-/* Check if @flags are a supported and valid set of FS_*_FL flags */
-static int check_fsflags(unsigned int flags)
+/*
+ * Check if @flags are a supported and valid set of FS_*_FL flags and that
+ * the old and new flags are not conflicting
+ */
+static int check_fsflags(unsigned int old_flags, unsigned int flags)
 {
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
@@ -174,9 +177,19 @@ static int check_fsflags(unsigned int flags)
 		      FS_NOCOW_FL))
 		return -EOPNOTSUPP;
 
+	/* COMPR and NOCOMP on new/old are valid */
 	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
 		return -EINVAL;
 
+	if ((flags & FS_COMPR_FL) && (flags & FS_NOCOW_FL))
+		return -EINVAL;
+
+	/* NOCOW and compression options are mutually exclusive */
+	if ((old_flags & FS_NOCOW_FL) && (flags & (FS_COMPR_FL | FS_NOCOMP_FL)))
+		return -EINVAL;
+	if ((flags & FS_NOCOW_FL) && (old_flags & (FS_COMPR_FL | FS_NOCOMP_FL)))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -190,7 +203,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
-	u32 binode_flags = binode->flags;
+	u32 binode_flags;
 
 	if (!inode_owner_or_capable(inode))
 		return -EPERM;
@@ -201,22 +214,23 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (copy_from_user(&fsflags, arg, sizeof(fsflags)))
 		return -EFAULT;
 
-	ret = check_fsflags(fsflags);
-	if (ret)
-		return ret;
-
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
 
 	inode_lock(inode);
-
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
 	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
+
 	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
 	if (ret)
 		goto out_unlock;
 
+	ret = check_fsflags(old_fsflags, fsflags);
+	if (ret)
+		goto out_unlock;
+
+	binode_flags = binode->flags;
 	if (fsflags & FS_SYNC_FL)
 		binode_flags |= BTRFS_INODE_SYNC;
 	else
-- 
2.25.0

