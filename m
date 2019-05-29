Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7E22E328
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 19:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfE2RZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 13:25:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:51386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbfE2RZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 13:25:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 449E6ACAA
        for <stable@vger.kernel.org>; Wed, 29 May 2019 17:25:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C77A1DA85E; Wed, 29 May 2019 19:26:01 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH for 5.1.x] Revert "btrfs: Honour FITRIM range constraints during free space trim"
Date:   Wed, 29 May 2019 19:25:47 +0200
Message-Id: <20190529172547.30563-5-dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529112314.GY15290@suse.cz>
References: <20190529112314.GY15290@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit eb432217d775a90c061681c0dfa3c7abfba75123.

There is currently no corresponding patch in master due to additional
changes that would be significantly different from plain revert in the
respective stable branch.

The range argument was not handled correctly and could cause trim to
overlap allocated areas or reach beyond the end of the device. The
address space that fitrim normally operates on is in logical
coordinates, while the discards are done on the physical device extents.
This distinction cannot be made with the current ioctl interface and
caused the confusion.

The bug depends on the layout of block groups and does not always
happen. The whole-fs trim (run by default by the fstrim tool) is not
affected.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d789542edc5a..c5880329ae37 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11315,9 +11315,9 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
  * held back allocations.
  */
 static int btrfs_trim_free_extents(struct btrfs_device *device,
-				   struct fstrim_range *range, u64 *trimmed)
+				   u64 minlen, u64 *trimmed)
 {
-	u64 start = range->start, len = 0;
+	u64 start = 0, len = 0;
 	int ret;
 
 	*trimmed = 0;
@@ -11360,8 +11360,8 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		if (!trans)
 			up_read(&fs_info->commit_root_sem);
 
-		ret = find_free_dev_extent_start(trans, device, range->minlen,
-						 start, &start, &len);
+		ret = find_free_dev_extent_start(trans, device, minlen, start,
+						 &start, &len);
 		if (trans) {
 			up_read(&fs_info->commit_root_sem);
 			btrfs_put_transaction(trans);
@@ -11374,16 +11374,6 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 			break;
 		}
 
-		/* If we are out of the passed range break */
-		if (start > range->start + range->len - 1) {
-			mutex_unlock(&fs_info->chunk_mutex);
-			ret = 0;
-			break;
-		}
-
-		start = max(range->start, start);
-		len = min(range->len, len);
-
 		ret = btrfs_issue_discard(device->bdev, start, len, &bytes);
 		mutex_unlock(&fs_info->chunk_mutex);
 
@@ -11393,10 +11383,6 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		start += len;
 		*trimmed += bytes;
 
-		/* We've trimmed enough */
-		if (*trimmed >= range->len)
-			break;
-
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -11480,7 +11466,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
-		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
+		ret = btrfs_trim_free_extents(device, range->minlen,
+					      &group_trimmed);
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;
-- 
2.21.0

