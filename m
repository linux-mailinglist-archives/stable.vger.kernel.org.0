Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88C74521DA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354180AbhKPBHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245361AbhKOTUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC92063348;
        Mon, 15 Nov 2021 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001187;
        bh=TyhqmtIGgPW455S0aLffpgcWlAclk7jNbxxTgC/pIMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVHKT4s4pdOQVeWwgvmQkZBBG6ffBENrC0TVaXD1NIUqz5YeTCZ61TvZfx7kz95RA
         u6YRTd/fLcyI48QQ4/0u6BWMiE+fm+gZoCHKpQJPKxnBJGVtfBDeBYQ6+mLIENRP/k
         dz7H7vnO0y1IUeXFLe6JVCSyVIEacczbTkvkk3tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhang <zhanglikernel@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 061/917] btrfs: clear MISSING device status bit in btrfs_close_one_device
Date:   Mon, 15 Nov 2021 17:52:36 +0100
Message-Id: <20211115165430.837348536@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhang <zhanglikernel@gmail.com>

commit 5d03dbebba2594d2e6fbf3b5dd9060c5a835de3b upstream.

Reported bug: https://github.com/kdave/btrfs-progs/issues/389

There's a problem with scrub reporting aborted status but returning
error code 0, on a filesystem with missing and readded device.

Roughly these steps:

- mkfs -d raid1 dev1 dev2
- fill with data
- unmount
- make dev1 disappear
- mount -o degraded
- copy more data
- make dev1 appear again

Running scrub afterwards reports that the command was aborted, but the
system log message says the exit code was 0.

It seems that the cause of the error is decrementing
fs_devices->missing_devices but not clearing device->dev_state.  Every
time we umount filesystem, it would call close_ctree, And it would
eventually involve btrfs_close_one_device to close the device, but it
only decrements fs_devices->missing_devices but does not clear the
device BTRFS_DEV_STATE_MISSING bit. Worse, this bug will cause Integer
Overflow, because every time umount, fs_devices->missing_devices will
decrease. If fs_devices->missing_devices value hit 0, it would overflow.

With added debugging:

   loop1: detected capacity change from 0 to 20971520
   BTRFS: device fsid 56ad51f1-5523-463b-8547-c19486c51ebb devid 1 transid 21 /dev/loop1 scanned by systemd-udevd (2311)
   loop2: detected capacity change from 0 to 20971520
   BTRFS: device fsid 56ad51f1-5523-463b-8547-c19486c51ebb devid 2 transid 17 /dev/loop2 scanned by systemd-udevd (2313)
   BTRFS info (device loop1): flagging fs with big metadata feature
   BTRFS info (device loop1): allowing degraded mounts
   BTRFS info (device loop1): using free space tree
   BTRFS info (device loop1): has skinny extents
   BTRFS info (device loop1):  before clear_missing.00000000f706684d /dev/loop1 0
   BTRFS warning (device loop1): devid 2 uuid 6635ac31-56dd-4852-873b-c60f5e2d53d2 is missing
   BTRFS info (device loop1):  before clear_missing.0000000000000000 /dev/loop2 1
   BTRFS info (device loop1): flagging fs with big metadata feature
   BTRFS info (device loop1): allowing degraded mounts
   BTRFS info (device loop1): using free space tree
   BTRFS info (device loop1): has skinny extents
   BTRFS info (device loop1):  before clear_missing.00000000f706684d /dev/loop1 0
   BTRFS warning (device loop1): devid 2 uuid 6635ac31-56dd-4852-873b-c60f5e2d53d2 is missing
   BTRFS info (device loop1):  before clear_missing.0000000000000000 /dev/loop2 0
   BTRFS info (device loop1): flagging fs with big metadata feature
   BTRFS info (device loop1): allowing degraded mounts
   BTRFS info (device loop1): using free space tree
   BTRFS info (device loop1): has skinny extents
   BTRFS info (device loop1):  before clear_missing.00000000f706684d /dev/loop1 18446744073709551615
   BTRFS warning (device loop1): devid 2 uuid 6635ac31-56dd-4852-873b-c60f5e2d53d2 is missing
   BTRFS info (device loop1):  before clear_missing.0000000000000000 /dev/loop2 18446744073709551615

If fs_devices->missing_devices is 0, next time it would be 18446744073709551615

After apply this patch, the fs_devices->missing_devices seems to be
right:

  $ truncate -s 10g test1
  $ truncate -s 10g test2
  $ losetup /dev/loop1 test1
  $ losetup /dev/loop2 test2
  $ mkfs.btrfs -draid1 -mraid1 /dev/loop1 /dev/loop2 -f
  $ losetup -d /dev/loop2
  $ mount -o degraded /dev/loop1 /mnt/1
  $ umount /mnt/1
  $ mount -o degraded /dev/loop1 /mnt/1
  $ umount /mnt/1
  $ mount -o degraded /dev/loop1 /mnt/1
  $ umount /mnt/1
  $ dmesg

   loop1: detected capacity change from 0 to 20971520
   loop2: detected capacity change from 0 to 20971520
   BTRFS: device fsid 15aa1203-98d3-4a66-bcae-ca82f629c2cd devid 1 transid 5 /dev/loop1 scanned by mkfs.btrfs (1863)
   BTRFS: device fsid 15aa1203-98d3-4a66-bcae-ca82f629c2cd devid 2 transid 5 /dev/loop2 scanned by mkfs.btrfs (1863)
   BTRFS info (device loop1): flagging fs with big metadata feature
   BTRFS info (device loop1): allowing degraded mounts
   BTRFS info (device loop1): disk space caching is enabled
   BTRFS info (device loop1): has skinny extents
   BTRFS info (device loop1):  before clear_missing.00000000975bd577 /dev/loop1 0
   BTRFS warning (device loop1): devid 2 uuid 8b333791-0b3f-4f57-b449-1c1ab6b51f38 is missing
   BTRFS info (device loop1):  before clear_missing.0000000000000000 /dev/loop2 1
   BTRFS info (device loop1): checking UUID tree
   BTRFS info (device loop1): flagging fs with big metadata feature
   BTRFS info (device loop1): allowing degraded mounts
   BTRFS info (device loop1): disk space caching is enabled
   BTRFS info (device loop1): has skinny extents
   BTRFS info (device loop1):  before clear_missing.00000000975bd577 /dev/loop1 0
   BTRFS warning (device loop1): devid 2 uuid 8b333791-0b3f-4f57-b449-1c1ab6b51f38 is missing
   BTRFS info (device loop1):  before clear_missing.0000000000000000 /dev/loop2 1
   BTRFS info (device loop1): flagging fs with big metadata feature
   BTRFS info (device loop1): allowing degraded mounts
   BTRFS info (device loop1): disk space caching is enabled
   BTRFS info (device loop1): has skinny extents
   BTRFS info (device loop1):  before clear_missing.00000000975bd577 /dev/loop1 0
   BTRFS warning (device loop1): devid 2 uuid 8b333791-0b3f-4f57-b449-1c1ab6b51f38 is missing
   BTRFS info (device loop1):  before clear_missing.0000000000000000 /dev/loop2 1

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Li Zhang <zhanglikernel@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1122,8 +1122,10 @@ static void btrfs_close_one_device(struc
 	if (device->devid == BTRFS_DEV_REPLACE_DEVID)
 		clear_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
 
-	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
+		clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
 		fs_devices->missing_devices--;
+	}
 
 	btrfs_close_bdev(device);
 	if (device->bdev) {


