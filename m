Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5252B63B2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbgKQNko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732867AbgKQNkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41AFA2467A;
        Tue, 17 Nov 2020 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620439;
        bh=4lrcF6ydvbchNyBo9t4miFAAH7Ucf42zswJvz6ah/Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07zpFJ85NXRiHTzVuDDYPLsiuehCQhi1rcAoOD42Tama30g9vJube4dPdElhzCTPw
         o+bzfq+ZUhEbM35NJeQGLSDX5gkOjhy6iJgBuDEa0nDPtwvriYbEUJJMzw5txFYA2p
         HKMFzk33xw2s+IzBVad+GV/bRDV9L46Fv3jPyB7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4cfe71a4da060be47502@syzkaller.appspotmail.com,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 190/255] btrfs: dev-replace: fail mount if we dont have replace item with target device
Date:   Tue, 17 Nov 2020 14:05:30 +0100
Message-Id: <20201117122148.176595405@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit cf89af146b7e62af55470cf5f3ec3c56ec144a5e upstream.

If there is a device BTRFS_DEV_REPLACE_DEVID without the device replace
item, then it means the filesystem is inconsistent state. This is either
corruption or a crafted image.  Fail the mount as this needs a closer
look what is actually wrong.

As of now if BTRFS_DEV_REPLACE_DEVID is present without the replace
item, in __btrfs_free_extra_devids() we determine that there is an
extra device, and free those extra devices but continue to mount the
device.
However, we were wrong in keeping tack of the rw_devices so the syzbot
testcase failed:

  WARNING: CPU: 1 PID: 3612 at fs/btrfs/volumes.c:1166 close_fs_devices.part.0+0x607/0x800 fs/btrfs/volumes.c:1166
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 1 PID: 3612 Comm: syz-executor.2 Not tainted 5.9.0-rc4-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x198/0x1fd lib/dump_stack.c:118
   panic+0x347/0x7c0 kernel/panic.c:231
   __warn.cold+0x20/0x46 kernel/panic.c:600
   report_bug+0x1bd/0x210 lib/bug.c:198
   handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
   exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
   asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
  RIP: 0010:close_fs_devices.part.0+0x607/0x800 fs/btrfs/volumes.c:1166
  RSP: 0018:ffffc900091777e0 EFLAGS: 00010246
  RAX: 0000000000040000 RBX: ffffffffffffffff RCX: ffffc9000c8b7000
  RDX: 0000000000040000 RSI: ffffffff83097f47 RDI: 0000000000000007
  RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff8880988a187f
  R10: 0000000000000000 R11: 0000000000000001 R12: ffff88809593a130
  R13: ffff88809593a1ec R14: ffff8880988a1908 R15: ffff88809593a050
   close_fs_devices fs/btrfs/volumes.c:1193 [inline]
   btrfs_close_devices+0x95/0x1f0 fs/btrfs/volumes.c:1179
   open_ctree+0x4984/0x4a2d fs/btrfs/disk-io.c:3434
   btrfs_fill_super fs/btrfs/super.c:1316 [inline]
   btrfs_mount_root.cold+0x14/0x165 fs/btrfs/super.c:1672

The fix here is, when we determine that there isn't a replace item
then fail the mount if there is a replace target device (devid 0).

CC: stable@vger.kernel.org # 4.19+
Reported-by: syzbot+4cfe71a4da060be47502@syzkaller.appspotmail.com
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/dev-replace.c |   26 ++++++++++++++++++++++++--
 fs/btrfs/volumes.c     |   26 +++++++-------------------
 2 files changed, 31 insertions(+), 21 deletions(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -95,6 +95,17 @@ int btrfs_init_dev_replace(struct btrfs_
 	ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
 	if (ret) {
 no_valid_dev_replace_entry_found:
+		/*
+		 * We don't have a replace item or it's corrupted.  If there is
+		 * a replace target, fail the mount.
+		 */
+		if (btrfs_find_device(fs_info->fs_devices,
+				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL, false)) {
+			btrfs_err(fs_info,
+			"found replace target device without a valid replace item");
+			ret = -EUCLEAN;
+			goto out;
+		}
 		ret = 0;
 		dev_replace->replace_state =
 			BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
@@ -147,8 +158,19 @@ no_valid_dev_replace_entry_found:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
-		dev_replace->srcdev = NULL;
-		dev_replace->tgtdev = NULL;
+		/*
+		 * We don't have an active replace item but if there is a
+		 * replace target, fail the mount.
+		 */
+		if (btrfs_find_device(fs_info->fs_devices,
+				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL, false)) {
+			btrfs_err(fs_info,
+			"replace devid present without an active replace item");
+			ret = -EUCLEAN;
+		} else {
+			dev_replace->srcdev = NULL;
+			dev_replace->tgtdev = NULL;
+		}
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1064,22 +1064,13 @@ again:
 			continue;
 		}
 
-		if (device->devid == BTRFS_DEV_REPLACE_DEVID) {
-			/*
-			 * In the first step, keep the device which has
-			 * the correct fsid and the devid that is used
-			 * for the dev_replace procedure.
-			 * In the second step, the dev_replace state is
-			 * read from the device tree and it is known
-			 * whether the procedure is really active or
-			 * not, which means whether this device is
-			 * used or whether it should be removed.
-			 */
-			if (step == 0 || test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-						  &device->dev_state)) {
-				continue;
-			}
-		}
+		/*
+		 * We have already validated the presence of BTRFS_DEV_REPLACE_DEVID,
+		 * in btrfs_init_dev_replace() so just continue.
+		 */
+		if (device->devid == BTRFS_DEV_REPLACE_DEVID)
+			continue;
+
 		if (device->bdev) {
 			blkdev_put(device->bdev, device->mode);
 			device->bdev = NULL;
@@ -1088,9 +1079,6 @@ again:
 		if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 			list_del_init(&device->dev_alloc_list);
 			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
-			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-				      &device->dev_state))
-				fs_devices->rw_devices--;
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;


