Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 500DE2F182
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfE3ENj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbfE3DQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:20 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23BF245D8;
        Thu, 30 May 2019 03:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186179;
        bh=SsyLdrVu3g1kfXDJ3CVlT1l7yvhaQ2LxfJLp6ZCpiok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is+vb4n++RIssMOO6CEMXfM2+vmnmjbZDKIS7NjF2c/Yg1JG0O6xgwOzGNw7mp3ne
         6AKaSDPM3GfYAF+zjbk8wGRklNayJYR/bQpWG7sICKlURNz4C/8wFgPxXWPX+j+5g/
         zDWxxdyZtBSALJjoH/QirNu+uK6cXFa9VYrOloAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 043/276] Revert "btrfs: Honour FITRIM range constraints during free space trim"
Date:   Wed, 29 May 2019 20:03:21 -0700
Message-Id: <20190530030527.261513597@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

This reverts commit 8b13bb911f0c0c77d41e5ddc41ad3c127c356b8a.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10788,9 +10788,9 @@ int btrfs_error_unpin_extent_range(struc
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
@@ -10833,8 +10833,8 @@ static int btrfs_trim_free_extents(struc
 		if (!trans)
 			up_read(&fs_info->commit_root_sem);
 
-		ret = find_free_dev_extent_start(trans, device, range->minlen,
-						 start, &start, &len);
+		ret = find_free_dev_extent_start(trans, device, minlen, start,
+						 &start, &len);
 		if (trans) {
 			up_read(&fs_info->commit_root_sem);
 			btrfs_put_transaction(trans);
@@ -10847,16 +10847,6 @@ static int btrfs_trim_free_extents(struc
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
 
@@ -10866,10 +10856,6 @@ static int btrfs_trim_free_extents(struc
 		start += len;
 		*trimmed += bytes;
 
-		/* We've trimmed enough */
-		if (*trimmed >= range->len)
-			break;
-
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -10953,7 +10939,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
-		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
+		ret = btrfs_trim_free_extents(device, range->minlen,
+					      &group_trimmed);
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;


