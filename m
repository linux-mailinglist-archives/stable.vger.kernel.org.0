Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20D5249B8A
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgHSLSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:18:39 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42929 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgHSLSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:18:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id F12CD19426E7;
        Wed, 19 Aug 2020 07:18:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=h0DQxJ
        eg7Idc5xnv7UL64oHOEc3kHBbTXIVY1/C3n3c=; b=nSSTNYCbUKYR7eYf/QSAXv
        ckGkmw6Cu1tj1aFlreve04FEzs0PKPA/bsvGTEBYEoGD79TRp3Nqt2LJmGz5l4Ct
        3rht+wK664WbKUvc/ijzlyHdK3qeQrnkP+4JIvGw3H1pvEd/Q75QRlQt6nosSjZM
        QUJPjFr8ZRPMTav1nLUz+m9VIsUfFDWeLdp8xhkjrBFJUltxU8ODkGLRsJ/pNSqs
        vxy6TO7jGDyjJJPbff62DJiINodvhmQnsVHis1r/nPwyJIKmW4OTP6Ci0CZMWwWV
        uL/ToBMB/19nFpx9MmgIaggRKohNJgLRxiyoFCtXu3CwdVrV7hKjxMZzgH3RaE3A
        ==
X-ME-Sender: <xms:igo9X47t1bdgmx6AvEHv_L2Ic33hnFhsuNYXXzCFHpwymdepDSXvEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:igo9X57VYeSVLNOV0n6eNNKyTxiDSuQdBpL07d3SDzumt7FejiW4jw>
    <xmx:igo9X3dAnAycjpGFYtUdL0Xn0FnHb8OvKwgy9mlihFoJAqLD9q8wuA>
    <xmx:igo9X9LICaX5arWpX9rTiUlZkBpTThRI4-jXoE973Qcfki1T8CsOaQ>
    <xmx:igo9XxU89aQznk94yXrg1Mbstp-_3adutiH7pWXVJZVUr2KmVIVCpw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7FBF9328005A;
        Wed, 19 Aug 2020 07:18:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: add missing check for nocow and compression inode" failed to apply to 4.9-stable tree
To:     dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:18:57 +0200
Message-ID: <1597835937206110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f37c563bab4297024c300b05c8f48430e323809d Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Fri, 10 Jul 2020 09:49:56 +0200
Subject: [PATCH] btrfs: add missing check for nocow and compression inode
 flags

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

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b4ddf51ae377..bd3511c5ca81 100644
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

