Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE03232D7E
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgG3ILN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729932AbgG3ILM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:11:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0BFF2070B;
        Thu, 30 Jul 2020 08:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096671;
        bh=uzaJ1Hrt8fWl2UcZ0QCknCLZsysGh44FvIFGK3geyeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTzy6OjAEkAWNP2Q82VIHwzgD27c/TKPS+FBTLCFeIXTM2pYYVJQqdMhLxQsV7PYB
         pEeKHma5XwDUX9eljuyrZT2aSLNpgwmwmaBOppRbUoToM7MHw9vOff7/98S/liHAdb
         uz55Fy6W1GvjvUQeYqlsqi/1EDTK01WE0oDtAR/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 16/54] btrfs: fix mount failure caused by race with umount
Date:   Thu, 30 Jul 2020 10:04:55 +0200
Message-Id: <20200730074421.991597288@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Burkov <boris@bur.io>

[ Upstream commit 48cfa61b58a1fee0bc49eef04f8ccf31493b7cdd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 55ce6543050d9..dcae0cf4924b7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6693,6 +6693,14 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	mutex_lock(&uuid_mutex);
 	lock_chunks(root);
 
+	/*
+	 * It is possible for mount and umount to race in such a way that
+	 * we execute this code path, but open_fs_devices failed to clear
+	 * total_rw_bytes. We certainly want it cleared before reading the
+	 * device items, so clear it here.
+	 */
+	root->fs_info->fs_devices->total_rw_bytes = 0;
+
 	/*
 	 * Read all device items, and then all the chunk items. All
 	 * device items are found before any chunk item (their object id
-- 
2.25.1



