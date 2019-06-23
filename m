Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828094FDEE
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfFWUWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:22:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37157 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbfFWUWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:22:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5C1F721C0F;
        Sun, 23 Jun 2019 16:22:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ae5H5p
        qifkZe83+i1yCRRqOfeqMqq/VRCN86RqmbJfs=; b=uCZkeMkLmzvaVXLkMqiL4q
        5g7k1WoOw/MOvm2VnH7Tkahtu06LqYzIcMmQkx57dxF1yI4IpP7/Dxr0Rf5w9RYk
        VirK3+RBIEW50DrNFbQIKqlsVrliXU3UxtnPeLiQW1MXoKvvFk0g1LNNOho0oHLu
        irYpu6u26U95t9IMkQsmZR9psN65DXTtLxt2GTNoFC6m93c2oN5E5i/QXhXgwz0T
        WzFaB75X57QEUixQjg8ose3HbYuvJC2cphwleZcNarNqLVVTJJpHvQiTlVRljAue
        wikqQH9pwlQXw+Wa1/e9TPfiU3gf3/4xKMMlCCfF6IyyTY/treuEqVaKqjOkEw4Q
        ==
X-ME-Sender: <xms:mt8PXYfKgUocj7Y6dzyrDOrFRJf83BSCNxG1zHTw6y7saViD-qBjow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:mt8PXZe9YkCU1Z0pbVQHRCZkmWUqO6q1Ax_2NqP0jBRNlI9RyThlUw>
    <xmx:mt8PXcVX8_PLeU3_6e6DHi0k85zqnzIqTYt8xPIg9Kryg6a4Nmcl0w>
    <xmx:mt8PXVc05bvdYIGgHZe_z4eUR5VCMc9CJ6dFqna3aIbPf4_Zfc3f7A>
    <xmx:mt8PXRbEqpSV7CjvcEggwiaUe5xX9Op1r1q0NavPwhsqt_JyMS-jEw>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8899C80061;
        Sun, 23 Jun 2019 16:22:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix failure to persist compression property xattr" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:21:38 +0200
Message-ID: <156132129816554@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

