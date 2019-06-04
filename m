Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA2B3419A
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfFDISJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:18:09 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:37519 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfFDISJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:18:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1C9762CD8;
        Tue,  4 Jun 2019 04:18:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:18:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pBEWLx
        5F5DWBvvUebtIl0d61rN0sFSnrjENMiANyo58=; b=q6CvsHtLxUXTos/Yw5bahi
        DKYk6XYOb1auZgnDBMzIYtasLPrXyeAKCJ250TXmJ3+ODXx52JwHhe7crY6PTwIe
        RPMTWjKiNmb8ksvKxzLQYakwzeHXdq+G3/yW/AA87cXv+XnrvatyeXjsvu8Adoow
        JC+d9nz2kD1V6RRdx96h4JeMAbAL0jo5cpbtmsVW42pFt5p3MnV2eXuCDJol50ha
        QtRErf6+BnybJ4un5ZmU00br9v+ZnhdelwV8AArv03STGNadhtm2GXjbOk6RBLnn
        DHmX+YGtqPMKtfUlgW6gq0E7GK/8BeFSJffiWjwLWXpecDz0zuI07zizkNj/HvTQ
        ==
X-ME-Sender: <xms:Pyn2XGKhhXuVH_phRol3XUdX3pXbo5idylGDYjtiIBdgdrkVeAPu6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:Pyn2XJ9iAhaYOAoiZ3D8_Ztx3J1YDPUouFS0PsjqxOpRka1wX7v7Gw>
    <xmx:Pyn2XNL7mWsOWFRDq5H2D-54YHfYdAehfW1mFQpY56fDKXp1Zb4u6g>
    <xmx:Pyn2XIHpkf5-ycpfE3_BE5nseBLaBGuV9T3uZkGfP6PxGWWFkPUrCw>
    <xmx:Pyn2XLv7qrViyRGXodH6r6olPnssszK2Z9BnPQa1jXGQKUafHlTX0Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25223380085;
        Tue,  4 Jun 2019 04:18:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: incremental send, fix file corruption when no-holes" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 10:17:58 +0200
Message-ID: <1559636278204153@kroah.com>
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

From 6b1f72e5b82a5c2a4da4d1ebb8cc01913ddbea21 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 20 May 2019 09:55:42 +0100
Subject: [PATCH] Btrfs: incremental send, fix file corruption when no-holes
 feature is enabled

When using the no-holes feature, if we have a file with prealloc extents
with a start offset beyond the file's eof, doing an incremental send can
cause corruption of the file due to incorrect hole detection. Such case
requires that the prealloc extent(s) exist in both the parent and send
snapshots, and that a hole is punched into the file that covers all its
extents that do not cross the eof boundary.

Example reproducer:

  $ mkfs.btrfs -f -O no-holes /dev/sdb
  $ mount /dev/sdb /mnt/sdb

  $ xfs_io -f -c "pwrite -S 0xab 0 500K" /mnt/sdb/foobar
  $ xfs_io -c "falloc -k 1200K 800K" /mnt/sdb/foobar

  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/base

  $ btrfs send -f /tmp/base.snap /mnt/sdb/base

  $ xfs_io -c "fpunch 0 500K" /mnt/sdb/foobar

  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/incr

  $ btrfs send -p /mnt/sdb/base -f /tmp/incr.snap /mnt/sdb/incr

  $ md5sum /mnt/sdb/incr/foobar
  816df6f64deba63b029ca19d880ee10a   /mnt/sdb/incr/foobar

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ btrfs receive -f /tmp/base.snap /mnt/sdc
  $ btrfs receive -f /tmp/incr.snap /mnt/sdc

  $ md5sum /mnt/sdc/incr/foobar
  cf2ef71f4a9e90c2f6013ba3b2257ed2   /mnt/sdc/incr/foobar

    --> Different checksum, because the prealloc extent beyond the
        file's eof confused the hole detection code and it assumed
        a hole starting at offset 0 and ending at the offset of the
        prealloc extent (1200Kb) instead of ending at the offset
        500Kb (the file's size).

Fix this by ensuring we never cross the file's size when issuing the
write operations for a hole.

Fixes: 16e7549f045d33 ("Btrfs: incompatible format change to remove hole extents")
CC: stable@vger.kernel.org # 3.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index dd38dfe174df..ca30b1f06e2d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4999,6 +4999,12 @@ static int send_hole(struct send_ctx *sctx, u64 end)
 	if (offset >= sctx->cur_inode_size)
 		return 0;
 
+	/*
+	 * Don't go beyond the inode's i_size due to prealloc extents that start
+	 * after the i_size.
+	 */
+	end = min_t(u64, end, sctx->cur_inode_size);
+
 	if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA)
 		return send_update_extent(sctx, offset, end - offset);
 

