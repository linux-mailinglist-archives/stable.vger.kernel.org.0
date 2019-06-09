Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F401F3A84D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387568AbfFIQ65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbfFIQ64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:58:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E49292081C;
        Sun,  9 Jun 2019 16:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099535;
        bh=x6LZ2e78v5QxGJZJWHNUEfRsCUpZIxWOk0ivuiOSQ48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UD6CzS4ncR+IyMezCaVdLzZ7d74K4LdNDB25aF/pBHHcTwht0Wo539r30m1OVS3Qy
         GiKfBxMpe4rJ8WbPQzj8Li4EKl3ErD9qDyYZmYnHf1zMhcUWTO0YmcpP8K6ES7bPR3
         8D+/Roo+cw/ODRQwz9ohbvlZVCzOOA8jT9a/ptQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 074/241] btrfs: Honour FITRIM range constraints during free space trim
Date:   Sun,  9 Jun 2019 18:40:16 +0200
Message-Id: <20190609164149.909200139@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
@@ -10730,9 +10730,9 @@ int btrfs_error_unpin_extent_range(struc
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
@@ -10768,8 +10768,8 @@ static int btrfs_trim_free_extents(struc
 			atomic_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
-		ret = find_free_dev_extent_start(trans, device, minlen, start,
-						 &start, &len);
+		ret = find_free_dev_extent_start(trans, device, range->minlen,
+						 start, &start, &len);
 		if (trans)
 			btrfs_put_transaction(trans);
 
@@ -10781,6 +10781,16 @@ static int btrfs_trim_free_extents(struc
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
@@ -10791,6 +10801,10 @@ static int btrfs_trim_free_extents(struc
 		start += len;
 		*trimmed += bytes;
 
+		/* We've trimmed enough */
+		if (*trimmed >= range->len)
+			break;
+
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -10857,8 +10871,7 @@ int btrfs_trim_fs(struct btrfs_root *roo
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	devices = &root->fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
-		ret = btrfs_trim_free_extents(device, range->minlen,
-					      &group_trimmed);
+		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
 		if (ret)
 			break;
 


