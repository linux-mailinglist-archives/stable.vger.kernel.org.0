Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B89321A60
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfEQPPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:15:43 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42721 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729164AbfEQPPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:15:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 53C964B0;
        Fri, 17 May 2019 11:15:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SN8tU/
        oAV9Xv1TInhkt66K6NkfdLFzVqbn09h5AfqH4=; b=0ZAZ/FspPxMG3g/1RrE6Xu
        Fk0izUQGiRl4vODihGctblp2qj8X591YUH8y8TwvtoVbu1ojS8qEYtLwbYe1s6g6
        nNSOLT+pi6sPtJwr34YI5zlsKx8oujaZBezlAFwAsUiSKh8Kll4bgAKPO9Hz7YtH
        vEn1ySt+tCWPU42Og1Xo5ONovA7Nlr81T1Vdie2dHrdgnbMkFB52BEZbpR8QAZne
        /hHDBxpM2vWZUjfSZ3noQN2fycLhE8RAUYeqJovpRhMoF5XDXvDO6peA8fWetloR
        hXA0BWir/haxLhlrXEOmCnl+7JMfGxS4ntL+lgo/xzcFY1eNXRq3EnLqYaBWnsAA
        ==
X-ME-Sender: <xms:HdDeXLz3vhl-I1fEPPRzPc1tA7in-96wkMoMfol5ObtVT8qP3eg4tQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HdDeXA9Djpu-CZP1xp1pK2_guNqbhNu2mOaM3aM9oTu4Em-2s9MNlA>
    <xmx:HdDeXNbuNE47XQcHo-ZCNjpptskptudzYQjEmX4stAZMNoWLL1VzWQ>
    <xmx:HdDeXN7X1tfO4Lmf78F_W_mARgQebi96GjT7exaXnoSIkZPmYSGBXA>
    <xmx:HdDeXIn3Ms4pu-aaKPetQVErQUg2q_0ySK7_q1FDNyGrlwrbu2o7Zg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17FF28005B;
        Fri, 17 May 2019 11:15:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: Honour FITRIM range constraints during free space trim" failed to apply to 4.14-stable tree
To:     nborisov@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:15:39 +0200
Message-ID: <1558106139255170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c2d1b3aae33605a61cbab445d8ae1c708ccd2698 Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Mon, 25 Mar 2019 14:31:21 +0200
Subject: [PATCH] btrfs: Honour FITRIM range constraints during free space trim

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

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa52b0995fba..c5f9e8359c6f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11309,9 +11309,9 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
  * held back allocations.
  */
 static int btrfs_trim_free_extents(struct btrfs_device *device,
-				   u64 minlen, u64 *trimmed)
+				   struct fstrim_range *range, u64 *trimmed)
 {
-	u64 start = 0, len = 0;
+	u64 start = range->start, len = 0;
 	int ret;
 
 	*trimmed = 0;
@@ -11354,8 +11354,8 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		if (!trans)
 			up_read(&fs_info->commit_root_sem);
 
-		ret = find_free_dev_extent_start(trans, device, minlen, start,
-						 &start, &len);
+		ret = find_free_dev_extent_start(trans, device, range->minlen,
+						 start, &start, &len);
 		if (trans) {
 			up_read(&fs_info->commit_root_sem);
 			btrfs_put_transaction(trans);
@@ -11368,6 +11368,16 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
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
 		mutex_unlock(&fs_info->chunk_mutex);
 
@@ -11377,6 +11387,10 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		start += len;
 		*trimmed += bytes;
 
+		/* We've trimmed enough */
+		if (*trimmed >= range->len)
+			break;
+
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -11460,8 +11474,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
-		ret = btrfs_trim_free_extents(device, range->minlen,
-					      &group_trimmed);
+		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;

