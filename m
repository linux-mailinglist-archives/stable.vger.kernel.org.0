Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01FB4FDEC
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfFWUWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:22:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36315 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbfFWUWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:22:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D4E5422007;
        Sun, 23 Jun 2019 16:22:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/Nzq5L
        TSufZPa28J6vhh68EJvqVAOwAcXBl13bQRSC8=; b=r2OoX0dlZBvjFdF0PDy/xm
        GHcBAk8qQvgvi5N3ckrf5uvZuAhdrL/LU83y99KI5oDGoqv2+GAqT8Q5kdQjGDmp
        isxpKLg88uVf5dyzbiLnF6Yy9x7g+ERCGHMVHeQsECVevZCBR0HkC5YWwzMY1Lkl
        thPQTrmVEBdCFBWsSb/LkNUtho+fRAf8hFnmTf2kfN6F0xOt2SstUCp8nafy8Mf1
        o6aLZObqg7Kcagg/ZhCL+VI+0GsA3P9/kSOvHbYaaJBWEG+YTQdnRfp8+DAhj2As
        Ixq9PBo9cPyjFL374tJROtZOkvGbuMZvgtHkKQaIp8iajBeMidh1t7gomTZUwlkg
        ==
X-ME-Sender: <xms:iN8PXVFZcjcb0wyrwCc5JlPMYSs2oGUTQm2SzWjl9EoW6UBs_gJrew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:iN8PXenCv41TWc0pjYJ5XYg-bpzp4bI9ZA4i3CFNK0ODPjKSDZtO6g>
    <xmx:iN8PXSJAOiKSdmAf5oDJdBtaHcOqZW-Ksi_g2Eio94FGNlJgKvj_Jg>
    <xmx:iN8PXfbjwpIZkadZnzV2vtPXiQOsnUK-1TsgAqXWj95jjUnqYw_ybQ>
    <xmx:iN8PXbYX2Lu0KUCPTRdrOYi6OzdaRk0PP7eylNnuTbci3itNPdhTyg>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id F149A380083;
        Sun, 23 Jun 2019 16:22:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix failure to persist compression property xattr" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:21:37 +0200
Message-ID: <156132129721639@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

