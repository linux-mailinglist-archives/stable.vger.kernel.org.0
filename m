Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9903A0260
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbhFHTDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234142AbhFHTBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C11660FEA;
        Tue,  8 Jun 2021 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177860;
        bh=aR6QnCtBE47cE0pFzkuLpENCA5vOFSjeC6SulkNuY/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHw16F1cEtSDXpaxmRKcCIyL3Knn3gVoQztR4I63mppItceNizz9CKDt3EpJcQZZx
         uiSlh1VocZKP2ICYZfBL+HNpvqwvqio6QaOZHn7LmWFepNh/wAnVUOkSG+LW/YZsjO
         3soxBpcT4DHGHp76eYc3FpSH5cJ/RLCaZgQ7xhe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 127/137] btrfs: fix unmountable seed device after fstrim
Date:   Tue,  8 Jun 2021 20:27:47 +0200
Message-Id: <20210608175946.679122079@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 5e753a817b2d5991dfe8a801b7b1e8e79a1c5a20 upstream.

The following test case reproduces an issue of wrongly freeing in-use
blocks on the readonly seed device when fstrim is called on the rw sprout
device. As shown below.

Create a seed device and add a sprout device to it:

  $ mkfs.btrfs -fq -dsingle -msingle /dev/loop0
  $ btrfstune -S 1 /dev/loop0
  $ mount /dev/loop0 /btrfs
  $ btrfs dev add -f /dev/loop1 /btrfs
  BTRFS info (device loop0): relocating block group 290455552 flags system
  BTRFS info (device loop0): relocating block group 1048576 flags system
  BTRFS info (device loop0): disk added /dev/loop1
  $ umount /btrfs

Mount the sprout device and run fstrim:

  $ mount /dev/loop1 /btrfs
  $ fstrim /btrfs
  $ umount /btrfs

Now try to mount the seed device, and it fails:

  $ mount /dev/loop0 /btrfs
  mount: /btrfs: wrong fs type, bad option, bad superblock on /dev/loop0, missing codepage or helper program, or other error.

Block 5292032 is missing on the readonly seed device:

 $ dmesg -kt | tail
 <snip>
 BTRFS error (device loop0): bad tree block start, want 5292032 have 0
 BTRFS warning (device loop0): couldn't read-tree root
 BTRFS error (device loop0): open_ctree failed

>From the dump-tree of the seed device (taken before the fstrim). Block
5292032 belonged to the block group starting at 5242880:

  $ btrfs inspect dump-tree -e /dev/loop0 | grep -A1 BLOCK_GROUP
  <snip>
  item 3 key (5242880 BLOCK_GROUP_ITEM 8388608) itemoff 16169 itemsize 24
  	block group used 114688 chunk_objectid 256 flags METADATA
  <snip>

>From the dump-tree of the sprout device (taken before the fstrim).
fstrim used block-group 5242880 to find the related free space to free:

  $ btrfs inspect dump-tree -e /dev/loop1 | grep -A1 BLOCK_GROUP
  <snip>
  item 1 key (5242880 BLOCK_GROUP_ITEM 8388608) itemoff 16226 itemsize 24
  	block group used 32768 chunk_objectid 256 flags METADATA
  <snip>

BPF kernel tracing the fstrim command finds the missing block 5292032
within the range of the discarded blocks as below:

  kprobe:btrfs_discard_extent {
  	printf("freeing start %llu end %llu num_bytes %llu:\n",
  		arg1, arg1+arg2, arg2);
  }

  freeing start 5259264 end 5406720 num_bytes 147456
  <snip>

Fix this by avoiding the discard command to the readonly seed device.

Reported-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1297,16 +1297,20 @@ int btrfs_discard_extent(struct btrfs_fs
 		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
 			u64 bytes;
 			struct request_queue *req_q;
+			struct btrfs_device *device = stripe->dev;
 
-			if (!stripe->dev->bdev) {
+			if (!device->bdev) {
 				ASSERT(btrfs_test_opt(fs_info, DEGRADED));
 				continue;
 			}
-			req_q = bdev_get_queue(stripe->dev->bdev);
+			req_q = bdev_get_queue(device->bdev);
 			if (!blk_queue_discard(req_q))
 				continue;
 
-			ret = btrfs_issue_discard(stripe->dev->bdev,
+			if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+				continue;
+
+			ret = btrfs_issue_discard(device->bdev,
 						  stripe->physical,
 						  stripe->length,
 						  &bytes);


