Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D93B24BFD3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgHTNyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgHTJ0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:26:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F1C22BEB;
        Thu, 20 Aug 2020 09:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915589;
        bh=BWIFhBcJkDPjoIakh06/+fl++GlwpNvJo517PZVI+mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqSbeEVmlvJUmubjlUcc1nrXJz6+rSdB1qvATHzGif4DsSgQu5Lo2r6h04Y+zmrbA
         7E5YRDwVZ63Rc421O2Hk5ZwfgTcBrEvrXOpeL2DXT3F9/pYpCdaXwcdK+AapWFmnPX
         cPn9E2I+lcC8UY6UWTNXtRO886o1qvvMpYgKZmHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 027/232] btrfs: add missing check for nocow and compression inode flags
Date:   Thu, 20 Aug 2020 11:17:58 +0200
Message-Id: <20200820091614.064283777@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit f37c563bab4297024c300b05c8f48430e323809d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -164,8 +164,11 @@ static int btrfs_ioctl_getflags(struct f
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
@@ -174,9 +177,19 @@ static int check_fsflags(unsigned int fl
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
 
@@ -190,7 +203,7 @@ static int btrfs_ioctl_setflags(struct f
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
-	u32 binode_flags = binode->flags;
+	u32 binode_flags;
 
 	if (!inode_owner_or_capable(inode))
 		return -EPERM;
@@ -201,22 +214,23 @@ static int btrfs_ioctl_setflags(struct f
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


