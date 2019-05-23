Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 601BF28A2E
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbfEWTKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387722AbfEWTKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:10:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5655C2133D;
        Thu, 23 May 2019 19:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638610;
        bh=d2lz/LRhtp1gvkecaybs2OEfgoE9qS63fMgr3EWksjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWtjzCP/sa6mikPpmfGGGT00I/TJjPjgoFCxlNmHExS3iX+sC88lZg+9C6BuB1iZn
         pAKdRk4UnH/nzAKDJ+aMnQznclUPyvbDqRse+awE/rwB0OP+1CRxx4wbNwwPpq+qiL
         E7QbTkLkBsIBIjUUUK0rfHxHBXTaX3eukH2AIw6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 53/53] btrfs: Honour FITRIM range constraints during free space trim
Date:   Thu, 23 May 2019 21:06:17 +0200
Message-Id: <20190523181719.388423466@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit c2d1b3aae33605a61cbab445d8ae1c708ccd2698 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/btrfs/extent-tree.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11150,9 +11150,9 @@ int btrfs_error_unpin_extent_range(struc
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
@@ -11188,8 +11188,8 @@ static int btrfs_trim_free_extents(struc
 			atomic_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
-		ret = find_free_dev_extent_start(trans, device, minlen, start,
-						 &start, &len);
+		ret = find_free_dev_extent_start(trans, device, range->minlen,
+						 start, &start, &len);
 		if (trans)
 			btrfs_put_transaction(trans);
 
@@ -11201,6 +11201,16 @@ static int btrfs_trim_free_extents(struc
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
@@ -11211,6 +11221,10 @@ static int btrfs_trim_free_extents(struc
 		start += len;
 		*trimmed += bytes;
 
+		/* We've trimmed enough */
+		if (*trimmed >= range->len)
+			break;
+
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -11295,8 +11309,7 @@ int btrfs_trim_fs(struct btrfs_root *roo
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
-		ret = btrfs_trim_free_extents(device, range->minlen,
-					      &group_trimmed);
+		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;


