Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74A1238C6
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390100AbfETNvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 09:51:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:42156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389950AbfETNvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 09:51:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93C32AD5C
        for <stable@vger.kernel.org>; Mon, 20 May 2019 13:51:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     stable@vger.kernel.org
Cc:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: Honour FITRIM range constraints during free space trim
Date:   Mon, 20 May 2019 16:51:38 +0300
Message-Id: <20190520135138.5594-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Up until now trimming the freespace was done irrespective of what the
arguments of the FITRIM ioctl were. For example fstrim's -o/-l arguments
will be entirely ignored. Fix it by correctly handling those paramter.
This requires breaking if the found freespace extent is after the end of
the passed range as well as completing trim after trimming
fstrim_range::len bytes.

Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---

Hello, 

Here is a backport of upstream commit c2d1b3aae33605a61cbab445d8ae1c708ccd2698
for 4.14.y. Please apply 
 fs/btrfs/extent-tree.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 83791d13c204..54bb5d79723a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11058,9 +11058,9 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
  * transaction.
  */
 static int btrfs_trim_free_extents(struct btrfs_device *device,
-				   u64 minlen, u64 *trimmed)
+				   struct fstrim_range *range, u64 *trimmed)
 {
-	u64 start = 0, len = 0;
+	u64 start = range->start, len = 0;
 	int ret;
 
 	*trimmed = 0;
@@ -11096,8 +11096,8 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 			refcount_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
-		ret = find_free_dev_extent_start(trans, device, minlen, start,
-						 &start, &len);
+		ret = find_free_dev_extent_start(trans, device, range->minlen,
+						 start, &start, &len);
 		if (trans)
 			btrfs_put_transaction(trans);
 
@@ -11109,6 +11109,16 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 			break;
 		}
 
+		/* If we are out of the passed range break */
+		if (start > range->start + range->len - 1) {
+			mutex_unlock(&fs_info->chunk_mutex);
+			ret = 0;
+			break;
+		}
+
+		start = max(range->start, start);
+		len = min(range->len, len);
+
 		ret = btrfs_issue_discard(device->bdev, start, len, &bytes);
 		up_read(&fs_info->commit_root_sem);
 		mutex_unlock(&fs_info->chunk_mutex);
@@ -11119,6 +11129,10 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		start += len;
 		*trimmed += bytes;
 
+		/* We've trimmed enough */
+		if (*trimmed >= range->len)
+			break;
+
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -11202,8 +11216,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
-		ret = btrfs_trim_free_extents(device, range->minlen,
-					      &group_trimmed);
+		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;
-- 
2.17.1

