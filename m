Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD44FDEB
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfFWUWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:22:15 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58609 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbfFWUWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:22:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EA1B921F8A;
        Sun, 23 Jun 2019 16:22:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mNGC6E
        IzsZjyTIjZVX+LLJHBhAs/ayob5lqQGK3CeIk=; b=yS5dv/YBtG8uFbwzm1AIyN
        HwTAsoxFijQhvr4tA1RAs50eWAxZH+ilaSdXshDllyGbA41m5RmLLKJfXleZDnh1
        ceipJKMyvZ04/trAYFrXsNm+VqH6M3OTM5QE/2oP89aiXYrKy3e2CnhBffplyti0
        zzltzGJ1mSG8Up4jQoB6j564nrsoHgUXCWdk5yVDh1IbGU5zZJBgUyvvzLEeb8AJ
        6UsihzQgNnmb6BneA8Z2pWJrjkekvgbpVZd0rFmMYhV+lu0R/iLkSHC6bhJpaHbq
        ZsxHpk1FnPGi7tE4iP1IdbgUiYYe2Ma7aOy1KspEvlYZ+puv97dWdnJDGW17xF1g
        ==
X-ME-Sender: <xms:dd8PXSuk5S3DHm0KnOMDC5U3NI-4TRpDB-eWeJr2ds0HvtmluF2mqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:dd8PXQDdsdrAAzZLpBkkJPt9-rKF-B1-kLQas4pH3EVc_vpGgspkWQ>
    <xmx:dd8PXU29QkPY9CYQcFnWd3Sf-YY36FezTfUYtirlgroSCkxvGIAkOg>
    <xmx:dd8PXSQlTf-3kpzO1TW_vb1GcpQaJjrhl0X3XdidhCQkhfymU-HBAA>
    <xmx:dd8PXYoSsg0XZzLrzBYWW3ljCjJmfMaHgWLL3gQZaLW5EcrLVAsIsw>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28440380076;
        Sun, 23 Jun 2019 16:22:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix failure to persist compression property xattr" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:21:36 +0200
Message-ID: <1561321296143167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3763771cf60236caaf7ccc79cea244c63d7c49a0 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 12 Jun 2019 15:14:11 +0100
Subject: [PATCH] Btrfs: fix failure to persist compression property xattr
 deletion on fsync

After the recent series of cleanups in the properties and xattrs modules
that landed in the 5.2 merge window, we ended up with a regression where
after deleting the compression xattr property through the setflags ioctl,
we don't set the BTRFS_INODE_COPY_EVERYTHING flag in the inode anymore.
As a consequence, if the inode was fsync'ed when it had the compression
property set, after deleting the compression property through the setflags
ioctl and fsync'ing again the inode, the log will still contain the
compression xattr, because the inode did not had that bit set, which
made the fsync not delete all xattrs from the log and copy all xattrs
from the subvolume tree to the log tree.

This regression happens due to the fact that that series of cleanups
made btrfs_set_prop() call the old function do_setxattr() (which is now
named btrfs_setxattr()), and not the old version of btrfs_setxattr(),
which is now called btrfs_setxattr_trans().

Fix this by setting the BTRFS_INODE_COPY_EVERYTHING bit in the current
btrfs_setxattr() function and remove it from everywhere else, including
its setup at btrfs_ioctl_setflags(). This is cleaner, avoids similar
regressions in the future, and centralizes the setup of the bit. After
all, the need to setup this bit should only be in the xattrs module,
since it is an implementation of xattrs.

Fixes: 04e6863b19c722 ("btrfs: split btrfs_setxattr calls regarding transaction")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6dafa857bbb9..2a1be0d1a698 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -312,8 +312,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 			btrfs_abort_transaction(trans, ret);
 			goto out_end_trans;
 		}
-		set_bit(BTRFS_INODE_COPY_EVERYTHING,
-			&BTRFS_I(inode)->runtime_flags);
 	} else {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL,
 				     0, 0);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 78b6ba2029e8..95d9aebff2c4 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -213,6 +213,9 @@ int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
 	}
 out:
 	btrfs_free_path(path);
+	if (!ret)
+		set_bit(BTRFS_INODE_COPY_EVERYTHING,
+			&BTRFS_I(inode)->runtime_flags);
 	return ret;
 }
 
@@ -236,7 +239,6 @@ int btrfs_setxattr_trans(struct inode *inode, const char *name,
 
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
-	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
 out:
@@ -388,8 +390,6 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 	if (!ret) {
 		inode_inc_iversion(inode);
 		inode->i_ctime = current_time(inode);
-		set_bit(BTRFS_INODE_COPY_EVERYTHING,
-			&BTRFS_I(inode)->runtime_flags);
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
 	}

