Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BEA3DD867
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhHBNv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234232AbhHBNuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCD736112F;
        Mon,  2 Aug 2021 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912241;
        bh=Ms1imVTFSXqUA0GLpX3Ht2o/XDTQBWj2Sk9Kklav728=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6dNVzbzBbqmJfVi2E9HGcX5pv7UGS2KhgmY4HcMbXOUvW6NVzYCEPXJ0qCQD0NU8
         Y100u/qO3YKvBzQD83T8JbRIzBF0YOapGjmcUHcqoGCVAPwRH7aeyF+42+VTCEnPFK
         Fm2yaLCfM1ySb6Mh0drwjZtb1PTIef37z6K8kT/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a70e2ad0879f160b9217@syzkaller.appspotmail.com,
        Anand Jain <anand.jain@oracle.com>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 03/40] btrfs: fix rw device counting in __btrfs_free_extra_devids
Date:   Mon,  2 Aug 2021 15:44:43 +0200
Message-Id: <20210802134335.512087153@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit b2a616676839e2a6b02c8e40be7f886f882ed194 upstream.

When removing a writeable device in __btrfs_free_extra_devids, the rw
device count should be decremented.

This error was caught by Syzbot which reported a warning in
close_fs_devices:

  WARNING: CPU: 1 PID: 9355 at fs/btrfs/volumes.c:1168 close_fs_devices+0x763/0x880 fs/btrfs/volumes.c:1168
  Modules linked in:
  CPU: 0 PID: 9355 Comm: syz-executor552 Not tainted 5.13.0-rc1-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:close_fs_devices+0x763/0x880 fs/btrfs/volumes.c:1168
  RSP: 0018:ffffc9000333f2f0 EFLAGS: 00010293
  RAX: ffffffff8365f5c3 RBX: 0000000000000001 RCX: ffff888029afd4c0
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
  RBP: ffff88802846f508 R08: ffffffff8365f525 R09: ffffed100337d128
  R10: ffffed100337d128 R11: 0000000000000000 R12: dffffc0000000000
  R13: ffff888019be8868 R14: 1ffff1100337d10d R15: 1ffff1100337d10a
  FS:  00007f6f53828700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000000047c410 CR3: 00000000302a6000 CR4: 00000000001506f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   btrfs_close_devices+0xc9/0x450 fs/btrfs/volumes.c:1180
   open_ctree+0x8e1/0x3968 fs/btrfs/disk-io.c:3693
   btrfs_fill_super fs/btrfs/super.c:1382 [inline]
   btrfs_mount_root+0xac5/0xc60 fs/btrfs/super.c:1749
   legacy_get_tree+0xea/0x180 fs/fs_context.c:592
   vfs_get_tree+0x86/0x270 fs/super.c:1498
   fc_mount fs/namespace.c:993 [inline]
   vfs_kern_mount+0xc9/0x160 fs/namespace.c:1023
   btrfs_mount+0x3d3/0xb50 fs/btrfs/super.c:1809
   legacy_get_tree+0xea/0x180 fs/fs_context.c:592
   vfs_get_tree+0x86/0x270 fs/super.c:1498
   do_new_mount fs/namespace.c:2905 [inline]
   path_mount+0x196f/0x2be0 fs/namespace.c:3235
   do_mount fs/namespace.c:3248 [inline]
   __do_sys_mount fs/namespace.c:3456 [inline]
   __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3433
   do_syscall_64+0x3f/0xb0 arch/x86/entry/common.c:47
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Because fs_devices->rw_devices was not 0 after
closing all devices. Here is the call trace that was observed:

  btrfs_mount_root():
    btrfs_scan_one_device():
      device_list_add();   <---------------- device added
    btrfs_open_devices():
      open_fs_devices():
        btrfs_open_one_device();   <-------- writable device opened,
	                                     rw device count ++
    btrfs_fill_super():
      open_ctree():
        btrfs_free_extra_devids():
	  __btrfs_free_extra_devids();  <--- writable device removed,
	                              rw device count not decremented
	  fail_tree_roots:
	    btrfs_close_devices():
	      close_fs_devices();   <------- rw device count off by 1

As a note, prior to commit cf89af146b7e ("btrfs: dev-replace: fail
mount if we don't have replace item with target device"), rw_devices
was decremented on removing a writable device in
__btrfs_free_extra_devids only if the BTRFS_DEV_STATE_REPLACE_TGT bit
was not set for the device. However, this check does not need to be
reinstated as it is now redundant and incorrect.

In __btrfs_free_extra_devids, we skip removing the device if it is the
target for replacement. This is done by checking whether device->devid
== BTRFS_DEV_REPLACE_DEVID. Since BTRFS_DEV_STATE_REPLACE_TGT is set
only on the device with devid BTRFS_DEV_REPLACE_DEVID, no devices
should have the BTRFS_DEV_STATE_REPLACE_TGT bit set after the check,
and so it's redundant to test for that bit.

Additionally, following commit 82372bc816d7 ("Btrfs: make
the logic of source device removing more clear"), rw_devices is
incremented whenever a writeable device is added to the alloc
list (including the target device in btrfs_dev_replace_finishing), so
all removals of writable devices from the alloc list should also be
accompanied by a decrement to rw_devices.

Reported-by: syzbot+a70e2ad0879f160b9217@syzkaller.appspotmail.com
Fixes: cf89af146b7e ("btrfs: dev-replace: fail mount if we don't have replace item with target device")
CC: stable@vger.kernel.org # 5.10+
Tested-by: syzbot+a70e2ad0879f160b9217@syzkaller.appspotmail.com
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1266,6 +1266,7 @@ again:
 		if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 			list_del_init(&device->dev_alloc_list);
 			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
+			fs_devices->rw_devices--;
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;


