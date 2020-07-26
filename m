Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C0C22DF19
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 14:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgGZMkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 08:40:06 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:55165 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgGZMkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 08:40:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5DC056DC;
        Sun, 26 Jul 2020 08:40:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 26 Jul 2020 08:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rlBy47
        gdgPahAWt5wAt7EwUU07rOgkSudlgBzrPDkns=; b=gUPR3hDTXlYHEUx/PviXge
        2N50BORIkkpswzxH5OxTTxqfZFkzSqhJym0VhzOlvJsKJOh4GjX9LEZ4V+naZEwf
        BOn9AQOlzeIQhda3xwKZIycbmpamjnfmIR1HVXCl0vJ/xrasJLwAFFoDInfK0nBF
        iajdGvmq0H6A+/FX74Zc+CnnJuxMnE02AdP74Se5/LBrpWiV28wHW7Z0KjTYVQxN
        zTxmPVlxfMU6tPIPz95UzwBtN9zL0wk0GBDmjHyIZqPJc6W68Wb6j+2sONhfYLuQ
        SEbiEzMKxVbLTXFgv8wDv9vdyOo1Vb7PRvPwuz72BnlrAAm994qGwYpepHniYLYg
        ==
X-ME-Sender: <xms:pHkdX3e2V1i_GDw4MZT4QID1v1_cLf3vROUUpRoDjJr0dLhcMMWRtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrheejgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:pHkdX9O28RrHLXA1PPrgEroUgUNkm2x0bgEJFu1EmUBLSGEbQYoU-Q>
    <xmx:pHkdXwjCEB-LVLpL-hpRfQzUn3O5dxR6R2qjgEYE85Nx1p1aMYQmtQ>
    <xmx:pHkdX485uVz1K98faLc3XOgYO3R8ofqMfERdzRvcPrFfgmNZeJfArg>
    <xmx:pXkdXw7R-IIRieH9IA7FU7H1iOu5d7Vf-bQz3ygc9tKO9sNCDWFz429JW4A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AE853280063;
        Sun, 26 Jul 2020 08:40:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix mount failure caused by race with umount" failed to apply to 4.9-stable tree
To:     boris@bur.io, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Jul 2020 14:39:59 +0200
Message-ID: <1595767199121103@kroah.com>
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

From 48cfa61b58a1fee0bc49eef04f8ccf31493b7cdd Mon Sep 17 00:00:00 2001
From: Boris Burkov <boris@bur.io>
Date: Thu, 16 Jul 2020 13:29:46 -0700
Subject: [PATCH] btrfs: fix mount failure caused by race with umount

It is possible to cause a btrfs mount to fail by racing it with a slow
umount. The crux of the sequence is generic_shutdown_super not yet
calling sop->put_super before btrfs_mount_root calls btrfs_open_devices.
If that occurs, btrfs_open_devices will decide the opened counter is
non-zero, increment it, and skip resetting fs_devices->total_rw_bytes to
0. From here, mount will call sget which will result in grab_super
trying to take the super block umount semaphore. That semaphore will be
held by the slow umount, so mount will block. Before up-ing the
semaphore, umount will delete the super block, resulting in mount's sget
reliably allocating a new one, which causes the mount path to dutifully
fill it out, and increment total_rw_bytes a second time, which causes
the mount to fail, as we see double the expected bytes.

Here is the sequence laid out in greater detail:

CPU0                                                    CPU1
down_write sb->s_umount
btrfs_kill_super
  kill_anon_super(sb)
    generic_shutdown_super(sb);
      shrink_dcache_for_umount(sb);
      sync_filesystem(sb);
      evict_inodes(sb); // SLOW

                                              btrfs_mount_root
                                                btrfs_scan_one_device
                                                fs_devices = device->fs_devices
                                                fs_info->fs_devices = fs_devices
                                                // fs_devices-opened makes this a no-op
                                                btrfs_open_devices(fs_devices, mode, fs_type)
                                                s = sget(fs_type, test, set, flags, fs_info);
                                                  find sb in s_instances
                                                  grab_super(sb);
                                                    down_write(&s->s_umount); // blocks

      sop->put_super(sb)
        // sb->fs_devices->opened == 2; no-op
      spin_lock(&sb_lock);
      hlist_del_init(&sb->s_instances);
      spin_unlock(&sb_lock);
      up_write(&sb->s_umount);
                                                    return 0;
                                                  retry lookup
                                                  don't find sb in s_instances (deleted by CPU0)
                                                  s = alloc_super
                                                  return s;
                                                btrfs_fill_super(s, fs_devices, data)
                                                  open_ctree // fs_devices total_rw_bytes improperly set!
                                                    btrfs_read_chunk_tree
                                                      read_one_dev // increment total_rw_bytes again!!
                                                      super_total_bytes < fs_devices->total_rw_bytes // ERROR!!!

To fix this, we clear total_rw_bytes from within btrfs_read_chunk_tree
before the calls to read_one_dev, while holding the sb umount semaphore
and the uuid mutex.

To reproduce, it is sufficient to dirty a decent number of inodes, then
quickly umount and mount.

  for i in $(seq 0 500)
  do
    dd if=/dev/zero of="/mnt/foo/$i" bs=1M count=1
  done
  umount /mnt/foo&
  mount /mnt/foo

does the trick for me.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0d6e785bcb98..f403fb1e6d37 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7051,6 +7051,14 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	mutex_lock(&uuid_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
 
+	/*
+	 * It is possible for mount and umount to race in such a way that
+	 * we execute this code path, but open_fs_devices failed to clear
+	 * total_rw_bytes. We certainly want it cleared before reading the
+	 * device items, so clear it here.
+	 */
+	fs_info->fs_devices->total_rw_bytes = 0;
+
 	/*
 	 * Read all device items, and then all the chunk items. All
 	 * device items are found before any chunk item (their object id

