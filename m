Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780DA2018AA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388261AbgFSQvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387872AbgFSOi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:38:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39469208B8;
        Fri, 19 Jun 2020 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577505;
        bh=De7F3m3rW+T10kJmCQOv8roxfowte3gkP6o+M1Kt4Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2d2vAzt5513+j9Jca/JmuLkXrtpSz2et26uvtIxa2iz/TuMJfY5LUajhjDxEXwzy
         49efl5qR812EpSPF8ymMiclI9OYfgQBlNa1gfecXG3/63L2bWGtduMkEYVLZmdmFbm
         9wtTBPM+p9xov+iSG53R8QSWwXWm6vJlhfvuEfrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 078/101] Btrfs: fix unreplayable log after snapshot delete + parent dir fsync
Date:   Fri, 19 Jun 2020 16:33:07 +0200
Message-Id: <20200619141618.084763574@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1ec9a1ae1e30c733077c0b288c4301b66b7a81f2 ]

If we delete a snapshot, fsync its parent directory and crash/power fail
before the next transaction commit, on the next mount when we attempt to
replay the log tree of the root containing the parent directory we will
fail and prevent the filesystem from mounting, which is solvable by wiping
out the log trees with the btrfs-zero-log tool but very inconvenient as
we will lose any data and metadata fsynced before the parent directory
was fsynced.

For example:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt
  $ mkdir /mnt/testdir
  $ btrfs subvolume snapshot /mnt /mnt/testdir/snap
  $ btrfs subvolume delete /mnt/testdir/snap
  $ xfs_io -c "fsync" /mnt/testdir
  < crash / power failure and reboot >
  $ mount /dev/sdc /mnt
  mount: mount(2) failed: No such file or directory

And in dmesg/syslog we get the following message and trace:

[192066.361162] BTRFS info (device dm-0): failed to delete reference to snap, inode 257 parent 257
[192066.363010] ------------[ cut here ]------------
[192066.365268] WARNING: CPU: 4 PID: 5130 at fs/btrfs/inode.c:3986 __btrfs_unlink_inode+0x17a/0x354 [btrfs]()
[192066.367250] BTRFS: Transaction aborted (error -2)
[192066.368401] Modules linked in: btrfs dm_flakey dm_mod ppdev sha256_generic xor raid6_pq hmac drbg ansi_cprng aesni_intel acpi_cpufreq tpm_tis aes_x86_64 tpm ablk_helper evdev cryptd sg parport_pc i2c_piix4 psmouse lrw parport i2c_core pcspkr gf128mul processor serio_raw glue_helper button loop autofs4 ext4 crc16 mbcache jbd2 sd_mod sr_mod cdrom ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring crc32c_intel scsi_mod e1000 virtio floppy [last unloaded: btrfs]
[192066.377154] CPU: 4 PID: 5130 Comm: mount Tainted: G        W       4.4.0-rc6-btrfs-next-20+ #1
[192066.378875] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS by qemu-project.org 04/01/2014
[192066.380889]  0000000000000000 ffff880143923670 ffffffff81257570 ffff8801439236b8
[192066.382561]  ffff8801439236a8 ffffffff8104ec07 ffffffffa039dc2c 00000000fffffffe
[192066.384191]  ffff8801ed31d000 ffff8801b9fc9c88 ffff8801086875e0 ffff880143923710
[192066.385827] Call Trace:
[192066.386373]  [<ffffffff81257570>] dump_stack+0x4e/0x79
[192066.387387]  [<ffffffff8104ec07>] warn_slowpath_common+0x99/0xb2
[192066.388429]  [<ffffffffa039dc2c>] ? __btrfs_unlink_inode+0x17a/0x354 [btrfs]
[192066.389236]  [<ffffffff8104ec68>] warn_slowpath_fmt+0x48/0x50
[192066.389884]  [<ffffffffa039dc2c>] __btrfs_unlink_inode+0x17a/0x354 [btrfs]
[192066.390621]  [<ffffffff81184b55>] ? iput+0xb0/0x266
[192066.391200]  [<ffffffffa039ea25>] btrfs_unlink_inode+0x1c/0x3d [btrfs]
[192066.391930]  [<ffffffffa03ca623>] check_item_in_log+0x1fe/0x29b [btrfs]
[192066.392715]  [<ffffffffa03ca827>] replay_dir_deletes+0x167/0x1cf [btrfs]
[192066.393510]  [<ffffffffa03cccc7>] replay_one_buffer+0x417/0x570 [btrfs]
[192066.394241]  [<ffffffffa03ca164>] walk_up_log_tree+0x10e/0x1dc [btrfs]
[192066.394958]  [<ffffffffa03cac72>] walk_log_tree+0xa5/0x190 [btrfs]
[192066.395628]  [<ffffffffa03ce8b8>] btrfs_recover_log_trees+0x239/0x32c [btrfs]
[192066.396790]  [<ffffffffa03cc8b0>] ? replay_one_extent+0x50a/0x50a [btrfs]
[192066.397891]  [<ffffffffa0394041>] open_ctree+0x1d8b/0x2167 [btrfs]
[192066.398897]  [<ffffffffa03706e1>] btrfs_mount+0x5ef/0x729 [btrfs]
[192066.399823]  [<ffffffff8108ad98>] ? trace_hardirqs_on+0xd/0xf
[192066.400739]  [<ffffffff8108959b>] ? lockdep_init_map+0xb9/0x1b3
[192066.401700]  [<ffffffff811714b9>] mount_fs+0x67/0x131
[192066.402482]  [<ffffffff81188560>] vfs_kern_mount+0x6c/0xde
[192066.403930]  [<ffffffffa03702bd>] btrfs_mount+0x1cb/0x729 [btrfs]
[192066.404831]  [<ffffffff8108ad98>] ? trace_hardirqs_on+0xd/0xf
[192066.405726]  [<ffffffff8108959b>] ? lockdep_init_map+0xb9/0x1b3
[192066.406621]  [<ffffffff811714b9>] mount_fs+0x67/0x131
[192066.407401]  [<ffffffff81188560>] vfs_kern_mount+0x6c/0xde
[192066.408247]  [<ffffffff8118ae36>] do_mount+0x893/0x9d2
[192066.409047]  [<ffffffff8113009b>] ? strndup_user+0x3f/0x8c
[192066.409842]  [<ffffffff8118b187>] SyS_mount+0x75/0xa1
[192066.410621]  [<ffffffff8147e517>] entry_SYSCALL_64_fastpath+0x12/0x6b
[192066.411572] ---[ end trace 2de42126c1e0a0f0 ]---
[192066.412344] BTRFS: error (device dm-0) in __btrfs_unlink_inode:3986: errno=-2 No such entry
[192066.413748] BTRFS: error (device dm-0) in btrfs_replay_log:2464: errno=-2 No such entry (Failed to recover log tree)
[192066.415458] BTRFS error (device dm-0): cleaner transaction attach returned -30
[192066.444613] BTRFS: open_ctree failed

This happens because when we are replaying the log and processing the
directory entry pointing to the snapshot in the subvolume tree, we treat
its btrfs_dir_item item as having a location with a key type matching
BTRFS_INODE_ITEM_KEY, which is wrong because the type matches
BTRFS_ROOT_ITEM_KEY and therefore must be processed differently, as the
object id refers to a root number and not to an inode in the root
containing the parent directory.

So fix this by triggering a transaction commit if an fsync against the
parent directory is requested after deleting a snapshot. This is the
simplest approach for a rare use case. Some alternative that avoids the
transaction commit would require more code to explicitly delete the
snapshot at log replay time (factoring out common code from ioctl.c:
btrfs_ioctl_snap_destroy()), special care at fsync time to remove the
log tree of the snapshot's root from the log root of the root of tree
roots, amongst other steps.

A test case for xfstests that triggers the issue follows.

  seq=`basename $0`
  seqres=$RESULT_DIR/$seq
  echo "QA output created by $seq"
  tmp=/tmp/$$
  status=1	# failure is the default!
  trap "_cleanup; exit \$status" 0 1 2 3 15

  _cleanup()
  {
      _cleanup_flakey
      cd /
      rm -f $tmp.*
  }

  # get standard environment, filters and checks
  . ./common/rc
  . ./common/filter
  . ./common/dmflakey

  # real QA test starts here
  _need_to_be_root
  _supported_fs btrfs
  _supported_os Linux
  _require_scratch
  _require_dm_target flakey
  _require_metadata_journaling $SCRATCH_DEV

  rm -f $seqres.full

  _scratch_mkfs >>$seqres.full 2>&1
  _init_flakey
  _mount_flakey

  # Create a snapshot at the root of our filesystem (mount point path), delete it,
  # fsync the mount point path, crash and mount to replay the log. This should
  # succeed and after the filesystem is mounted the snapshot should not be visible
  # anymore.
  _run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap1
  _run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap1
  $XFS_IO_PROG -c "fsync" $SCRATCH_MNT
  _flakey_drop_and_remount
  [ -e $SCRATCH_MNT/snap1 ] && \
      echo "Snapshot snap1 still exists after log replay"

  # Similar scenario as above, but this time the snapshot is created inside a
  # directory and not directly under the root (mount point path).
  mkdir $SCRATCH_MNT/testdir
  _run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/testdir/snap2
  _run_btrfs_util_prog subvolume delete $SCRATCH_MNT/testdir/snap2
  $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir
  _flakey_drop_and_remount
  [ -e $SCRATCH_MNT/testdir/snap2 ] && \
      echo "Snapshot snap2 still exists after log replay"

  _unmount_flakey

  echo "Silence is golden"
  status=0
  exit

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c    |  3 +++
 fs/btrfs/tree-log.c | 15 +++++++++++++++
 fs/btrfs/tree-log.h |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 119b1c5c279b..245a50f490f6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -59,6 +59,7 @@
 #include "props.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "tree-log.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
@@ -2540,6 +2541,8 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
+	if (!err)
+		btrfs_record_snapshot_destroy(trans, dir);
 	ret = btrfs_end_transaction(trans, root);
 	if (ret && !err)
 		err = ret;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4320f346b0b9..3779a660988a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5694,6 +5694,21 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 	BTRFS_I(dir)->last_unlink_trans = trans->transid;
 }
 
+/*
+ * Make sure that if someone attempts to fsync the parent directory of a deleted
+ * snapshot, it ends up triggering a transaction commit. This is to guarantee
+ * that after replaying the log tree of the parent directory's root we will not
+ * see the snapshot anymore and at log replay time we will not see any log tree
+ * corresponding to the deleted snapshot's root, which could lead to replaying
+ * it after replaying the log tree of the parent directory (which would replay
+ * the snapshot delete operation).
+ */
+void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
+				   struct inode *dir)
+{
+	BTRFS_I(dir)->last_unlink_trans = trans->transid;
+}
+
 /*
  * Call this after adding a new name for a file and it will properly
  * update the log to reflect the new name.
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 6916a781ea02..a9f1b75d080d 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -79,6 +79,8 @@ int btrfs_pin_log_trans(struct btrfs_root *root);
 void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 			     struct inode *dir, struct inode *inode,
 			     int for_rename);
+void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
+				   struct inode *dir);
 int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct inode *inode, struct inode *old_dir,
 			struct dentry *parent);
-- 
2.25.1



