Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9261C22DF1A
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGZMkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 08:40:13 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:57037 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgGZMkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 08:40:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C5D34678;
        Sun, 26 Jul 2020 08:40:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 26 Jul 2020 08:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9AVAJA
        CNsgY2Hu9FecG2E0dIAoQbpyZycaOXn0V5KpU=; b=LlbOuPXlRc+X9aSrK/Xi1P
        Wqg2X224CbB0rJCdqykrNkZqowy/vQKqo/CIEzQLcOGVChe/zrKM7ZYIrWT2T9HR
        mBbTb9OERjR8Wx0UUwj/ulupUnBByGmV4K+ca5Ubkg2z94XA0G0w6p+i7VbrjdeT
        ZanJRGQrzVesikqcoEtvApGPGcbLdKBm5g6iyHNexuxaXT/I4GWUwZgP1vMk7xNq
        9DYFm53Q6FmSLqfaCYRl5T7m/2SlIKPrVBE7KNm5n0KHTqAJZqb8TT3i75Ujbj+7
        v0UIXumh+YNMoMscYp1FvQtGZMtc/IP8/nnZx7LEHFmgEzqn5cX6PB/aqz5K8xzw
        ==
X-ME-Sender: <xms:q3kdX5Qb0vLFVTG6i6wpJJ9tSUjc2vCleKwmEep-LBR7ZltC00T6iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrheejgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:q3kdXyzSojRsxrXmj4q0k_uGkWz3CARg96ENjGaw_jNgG6oOq0wSAA>
    <xmx:q3kdX-1cF5J8pEc-htAU9SfnoIdxYFSggvxnp-bnrlulkl8ArpxOHQ>
    <xmx:q3kdXxDrzqZZbxYIcewfU2PikbrsIeso_yEvs8D-kHFzTzm8G8raww>
    <xmx:q3kdX4eepg21sZkv6k4iTW9CenQ0TxP8r7kzuvXVoBu0_EbD-L3JBjDRVaA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E94463280064;
        Sun, 26 Jul 2020 08:40:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix mount failure caused by race with umount" failed to apply to 4.4-stable tree
To:     boris@bur.io, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Jul 2020 14:40:01 +0200
Message-ID: <159576720120107@kroah.com>
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

