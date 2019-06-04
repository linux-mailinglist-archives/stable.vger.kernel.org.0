Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D8434151
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFDIOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:14:24 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48191 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbfFDIOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:14:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8080C291C;
        Tue,  4 Jun 2019 04:14:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SoZQOv
        436Ucj8lHLQj1XBOHU1gi5+ppZneJJRYSTx2g=; b=Lzscw4Wnd5rGYad3mmtswW
        lvxnzOCu9nxa4CQZ3aVcob/qpj+AUSrEKGRsYjFBP4a32ilV9DpR1p4f32Ym0/b0
        /fCa3YCGg4QZxAAkvvXdqYLGmtA3sFe/HJM+x1RwZVScf0PHwQ81XebxLkw+GqWK
        L+0mkSqbO/+WahiihxyBbrPp0FEMN7AlZfVOGt4KJK9SDTVjlzikLupysuNfkBpg
        ba+y1B4nZSIJIIeawpvVnoIob7iYW9kHEznaJUMdZa9uxBi8lg18cVkdXm74Cmf9
        GPxSGIkWAiLG+stC+PaREqnp9tuI7ITwzA2/aV7lnmBbBsd2swZ/GJr8JSiSZwgg
        ==
X-ME-Sender: <xms:Xij2XOyfdtuLZ-QAjdl-27eBYXMScJsDXW0cWng5plSeJpJLYDy_Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Xij2XFyqh1276kON31T6hYg4TegjxoCqlvcTIK80OhM-aj8XWaIFZA>
    <xmx:Xij2XFaAxO2f0sZeuXWrNLmY6GfZsizAE2vPNqMzlVyitCHMkGoXsg>
    <xmx:Xij2XDe10Sw9oq8UeW_a03_pqhhULKviq0DexYlP2ag24Dfv3sUSuw>
    <xmx:Xyj2XIRTrtePhSLm9r2AvmpeoOkbCmMtg0aG6B2Y2AA8pjAa4opnaw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 68AF1380083;
        Tue,  4 Jun 2019 04:14:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix wrong ctime and mtime of a directory after log" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 10:14:20 +0200
Message-ID: <1559636060209238@kroah.com>
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

From 5338e43abbab13791144d37fd8846847062351c6 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 15 May 2019 16:02:47 +0100
Subject: [PATCH] Btrfs: fix wrong ctime and mtime of a directory after log
 replay

When replaying a log that contains a new file or directory name that needs
to be added to its parent directory, we end up updating the mtime and the
ctime of the parent directory to the current time after we have set their
values to the correct ones (set at fsync time), efectivelly losing them.

Sample reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/dir
  $ touch /mnt/dir/file

  # fsync of the directory is optional, not needed
  $ xfs_io -c fsync /mnt/dir
  $ xfs_io -c fsync /mnt/dir/file

  $ stat -c %Y /mnt/dir
  1557856079

  <power failure>

  $ sleep 3
  $ mount /dev/sdb /mnt
  $ stat -c %Y /mnt/dir
  1557856082

    --> should have been 1557856079, the mtime is updated to the current
        time when replaying the log

Fix this by not updating the mtime and ctime to the current time at
btrfs_add_link() when we are replaying a log tree.

This could be triggered by my recent fsync fuzz tester for fstests, for
which an fstests patch exists titled "fstests: generic, fsync fuzz tester
with fsstress".

Fixes: e02119d5a7b43 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b6d549c993f6..6bebc0ca751d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6433,8 +6433,18 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(parent_inode, parent_inode->vfs_inode.i_size +
 			   name_len * 2);
 	inode_inc_iversion(&parent_inode->vfs_inode);
-	parent_inode->vfs_inode.i_mtime = parent_inode->vfs_inode.i_ctime =
-		current_time(&parent_inode->vfs_inode);
+	/*
+	 * If we are replaying a log tree, we do not want to update the mtime
+	 * and ctime of the parent directory with the current time, since the
+	 * log replay procedure is responsible for setting them to their correct
+	 * values (the ones it had when the fsync was done).
+	 */
+	if (!test_bit(BTRFS_FS_LOG_RECOVERING, &root->fs_info->flags)) {
+		struct timespec64 now = current_time(&parent_inode->vfs_inode);
+
+		parent_inode->vfs_inode.i_mtime = now;
+		parent_inode->vfs_inode.i_ctime = now;
+	}
 	ret = btrfs_update_inode(trans, root, &parent_inode->vfs_inode);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);

