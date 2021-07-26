Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3CA3D6244
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbhGZPfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236333AbhGZPeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE27860F5A;
        Mon, 26 Jul 2021 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316085;
        bh=coqtVgG0wSPKKNK308MudOo7idkgrWjPnSCtxuFbz0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wW5YIz2drNka3o5GyxSVJ53LO09Te7PY+FW+R3FmDo+IKvX2tZR0okDxQwIptVfeu
         YTAWu6TCFcj5gjPLorZxgkkqa7jboHRXZ1Dr3M4Iroy8OOvdWrLEbonh2PgHKu+Mv8
         LjpK65BLm6asJSwWTswUzuO4fNy0Ial4H7A1QzuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 181/223] btrfs: check for missing device in btrfs_trim_fs
Date:   Mon, 26 Jul 2021 17:39:33 +0200
Message-Id: <20210726153852.114638618@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 16a200f66ede3f9afa2e51d90ade017aaa18d213 upstream.

A fstrim on a degraded raid1 can trigger the following null pointer
dereference:

  BTRFS info (device loop0): allowing degraded mounts
  BTRFS info (device loop0): disk space caching is enabled
  BTRFS info (device loop0): has skinny extents
  BTRFS warning (device loop0): devid 2 uuid 97ac16f7-e14d-4db1-95bc-3d489b424adb is missing
  BTRFS warning (device loop0): devid 2 uuid 97ac16f7-e14d-4db1-95bc-3d489b424adb is missing
  BTRFS info (device loop0): enabling ssd optimizations
  BUG: kernel NULL pointer dereference, address: 0000000000000620
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP NOPTI
  CPU: 0 PID: 4574 Comm: fstrim Not tainted 5.13.0-rc7+ #31
  Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
  RIP: 0010:btrfs_trim_fs+0x199/0x4a0 [btrfs]
  RSP: 0018:ffff959541797d28 EFLAGS: 00010293
  RAX: 0000000000000000 RBX: ffff946f84eca508 RCX: a7a67937adff8608
  RDX: ffff946e8122d000 RSI: 0000000000000000 RDI: ffffffffc02fdbf0
  RBP: ffff946ea4615000 R08: 0000000000000001 R09: 0000000000000000
  R10: 0000000000000000 R11: ffff946e8122d960 R12: 0000000000000000
  R13: ffff959541797db8 R14: ffff946e8122d000 R15: ffff959541797db8
  FS:  00007f55917a5080(0000) GS:ffff946f9bc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000620 CR3: 000000002d2c8001 CR4: 00000000000706f0
  Call Trace:
  btrfs_ioctl_fitrim+0x167/0x260 [btrfs]
  btrfs_ioctl+0x1c00/0x2fe0 [btrfs]
  ? selinux_file_ioctl+0x140/0x240
  ? syscall_trace_enter.constprop.0+0x188/0x240
  ? __x64_sys_ioctl+0x83/0xb0
  __x64_sys_ioctl+0x83/0xb0

Reproducer:

  $ mkfs.btrfs -fq -d raid1 -m raid1 /dev/loop0 /dev/loop1
  $ mount /dev/loop0 /btrfs
  $ umount /btrfs
  $ btrfs dev scan --forget
  $ mount -o degraded /dev/loop0 /btrfs

  $ fstrim /btrfs

The reason is we call btrfs_trim_free_extents() for the missing device,
which uses device->bdev (NULL for missing device) to find if the device
supports discard.

Fix is to check if the device is missing before calling
btrfs_trim_free_extents().

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6034,6 +6034,9 @@ int btrfs_trim_fs(struct btrfs_fs_info *
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
+		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
+			continue;
+
 		ret = btrfs_trim_free_extents(device, &group_trimmed);
 		if (ret) {
 			dev_failed++;


