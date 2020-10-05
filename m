Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7DE283AE8
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgJEPi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgJEPbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D35D20B80;
        Mon,  5 Oct 2020 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911865;
        bh=jH4jClLwJrkIjfPQMOvt7j/zMDnmHSmCWpBQ6MI6EQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbOSWJelunvskhblVbzNfanjRAhesUrWcCvBholm3K73uIG4dRj1U0dMj4ZDIkK+q
         5cmhGn9qzODty4tYC5BYBWaZozZ+MEMAeP0scQDCWflZSaQADe+GaF0HHcu2NB07TM
         ziUycGw2y7xfqC1j9hz3MnI2tZnm5XotwtIw4+AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 02/85] btrfs: fix filesystem corruption after a device replace
Date:   Mon,  5 Oct 2020 17:25:58 +0200
Message-Id: <20201005142114.858736343@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 4c8f353272dd1262013873990c0fafd0e3c8f274 upstream.

We use a device's allocation state tree to track ranges in a device used
for allocated chunks, and we set ranges in this tree when allocating a new
chunk. However after a device replace operation, we were not setting the
allocated ranges in the new device's allocation state tree, so that tree
is empty after a device replace.

This means that a fitrim operation after a device replace will trim the
device ranges that have allocated chunks and extents, as we trim every
range for which there is not a range marked in the device's allocation
state tree. It is also important during chunk allocation, since the
device's allocation state is used to determine if a range is already
allocated when allocating a new chunk.

This is trivial to reproduce and the following script triggers the bug:

  $ cat reproducer.sh
  #!/bin/bash

  DEV1="/dev/sdg"
  DEV2="/dev/sdh"
  DEV3="/dev/sdi"

  wipefs -a $DEV1 $DEV2 $DEV3 &> /dev/null

  # Create a raid1 test fs on 2 devices.
  mkfs.btrfs -f -m raid1 -d raid1 $DEV1 $DEV2 > /dev/null
  mount $DEV1 /mnt/btrfs

  xfs_io -f -c "pwrite -S 0xab 0 10M" /mnt/btrfs/foo

  echo "Starting to replace $DEV1 with $DEV3"
  btrfs replace start -B $DEV1 $DEV3 /mnt/btrfs
  echo

  echo "Running fstrim"
  fstrim /mnt/btrfs
  echo

  echo "Unmounting filesystem"
  umount /mnt/btrfs

  echo "Mounting filesystem in degraded mode using $DEV3 only"
  wipefs -a $DEV1 $DEV2 &> /dev/null
  mount -o degraded $DEV3 /mnt/btrfs
  if [ $? -ne 0 ]; then
          dmesg | tail
          echo
          echo "Failed to mount in degraded mode"
          exit 1
  fi

  echo
  echo "File foo data (expected all bytes = 0xab):"
  od -A d -t x1 /mnt/btrfs/foo

  umount /mnt/btrfs

When running the reproducer:

  $ ./replace-test.sh
  wrote 10485760/10485760 bytes at offset 0
  10 MiB, 2560 ops; 0.0901 sec (110.877 MiB/sec and 28384.5216 ops/sec)
  Starting to replace /dev/sdg with /dev/sdi

  Running fstrim

  Unmounting filesystem
  Mounting filesystem in degraded mode using /dev/sdi only
  mount: /mnt/btrfs: wrong fs type, bad option, bad superblock on /dev/sdi, missing codepage or helper program, or other error.
  [19581.748641] BTRFS info (device sdg): dev_replace from /dev/sdg (devid 1) to /dev/sdi started
  [19581.803842] BTRFS info (device sdg): dev_replace from /dev/sdg (devid 1) to /dev/sdi finished
  [19582.208293] BTRFS info (device sdi): allowing degraded mounts
  [19582.208298] BTRFS info (device sdi): disk space caching is enabled
  [19582.208301] BTRFS info (device sdi): has skinny extents
  [19582.212853] BTRFS warning (device sdi): devid 2 uuid 1f731f47-e1bb-4f00-bfbb-9e5a0cb4ba9f is missing
  [19582.213904] btree_readpage_end_io_hook: 25839 callbacks suppressed
  [19582.213907] BTRFS error (device sdi): bad tree block start, want 30490624 have 0
  [19582.214780] BTRFS warning (device sdi): failed to read root (objectid=7): -5
  [19582.231576] BTRFS error (device sdi): open_ctree failed

  Failed to mount in degraded mode

So fix by setting all allocated ranges in the replace target device when
the replace operation is finishing, when we are holding the chunk mutex
and we can not race with new chunk allocations.

A test case for fstests follows soon.

Fixes: 1c11b63eff2a67 ("btrfs: replace pending/pinned chunks lists with io tree")
CC: stable@vger.kernel.org # 5.2+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/dev-replace.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -599,6 +599,37 @@ static void btrfs_rm_dev_replace_unblock
 	wake_up(&fs_info->dev_replace.replace_wait);
 }
 
+/*
+ * When finishing the device replace, before swapping the source device with the
+ * target device we must update the chunk allocation state in the target device,
+ * as it is empty because replace works by directly copying the chunks and not
+ * through the normal chunk allocation path.
+ */
+static int btrfs_set_target_alloc_state(struct btrfs_device *srcdev,
+					struct btrfs_device *tgtdev)
+{
+	struct extent_state *cached_state = NULL;
+	u64 start = 0;
+	u64 found_start;
+	u64 found_end;
+	int ret = 0;
+
+	lockdep_assert_held(&srcdev->fs_info->chunk_mutex);
+
+	while (!find_first_extent_bit(&srcdev->alloc_state, start,
+				      &found_start, &found_end,
+				      CHUNK_ALLOCATED, &cached_state)) {
+		ret = set_extent_bits(&tgtdev->alloc_state, found_start,
+				      found_end, CHUNK_ALLOCATED);
+		if (ret)
+			break;
+		start = found_end + 1;
+	}
+
+	free_extent_state(cached_state);
+	return ret;
+}
+
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				       int scrub_ret)
 {
@@ -673,8 +704,14 @@ static int btrfs_dev_replace_finishing(s
 	dev_replace->time_stopped = ktime_get_real_seconds();
 	dev_replace->item_needs_writeback = 1;
 
-	/* replace old device with new one in mapping tree */
+	/*
+	 * Update allocation state in the new device and replace the old device
+	 * with the new one in the mapping tree.
+	 */
 	if (!scrub_ret) {
+		scrub_ret = btrfs_set_target_alloc_state(src_device, tgt_device);
+		if (scrub_ret)
+			goto error;
 		btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
 								src_device,
 								tgt_device);
@@ -685,6 +722,7 @@ static int btrfs_dev_replace_finishing(s
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
 				 rcu_str_deref(tgt_device->name), scrub_ret);
+error:
 		up_write(&dev_replace->rwsem);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);


