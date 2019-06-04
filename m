Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550363419D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFDISe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:18:34 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40067 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfFDISe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:18:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A877A372;
        Tue,  4 Jun 2019 04:18:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ac01qy
        +cj0rQ5iJQY6Ykanbr4BoqHYPD9PGqe8f9xbU=; b=zg9hGqpiAJGtW24LEgaSr5
        3LcpugVQ5lM+2jRc4m3SVtnbaGfcdBOEa9nvG6cSFJxSiqh9w9F/9oZxQ7a0Jz47
        Jz1AfBTS1BFqIYEN+TfTB9zxRQdRYw1Hq3ka/Zp/NQH9qJfbM4YfsQ5rYBrd1VVS
        kesi/c2Qakolqu4n8g+Zjd5sALfRCLiBW4N76Q6j6lzQp9pSuVudOnR8O4Vuz16c
        qBH2F8T+jgJgqjnMKaTnM6mzp7LFVqboegDhXqeXhrC7lopf9Frfyif9vDYUbMnV
        +p4b2ur7m2iJlAsZ1V9UaYs5UhTzuyPoSEPQMJ9cMD+jFyG1+oAQxn8jGYiPVAQA
        ==
X-ME-Sender: <xms:WSn2XKj4iF9jxVxnek4kl8r_wWDA12zHk5DVHk2esH50fqBEnwYnZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:WSn2XGZmIcDThvVtQriQ4PAHUfWmsH4cjBWhg-fFN1vCTwB11yULFA>
    <xmx:WSn2XP_BVQJxMifs_GjTfTsjRHOnZ5O8-kAx04FSM3Yh1Uh6Wjpirg>
    <xmx:WSn2XOY8_6qDF__L-keun4L0DT5QMhmEThVyS7tYOn-C-FbP-r-Zgg>
    <xmx:WSn2XLtSrxLCp69daQYDYxySt6WNeAm1nuldTmr_UIW7zipvRaIrqQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C29CE8005B;
        Tue,  4 Jun 2019 04:18:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: Ensure replaced device doesn't have pending chunk" failed to apply to 4.19-stable tree
To:     nborisov@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 10:18:29 +0200
Message-ID: <155963630921244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From debd1c065d2037919a7da67baf55cc683fee09f0 Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Fri, 17 May 2019 10:44:25 +0300
Subject: [PATCH] btrfs: Ensure replaced device doesn't have pending chunk
 allocation

Recent FITRIM work, namely bbbf7243d62d ("btrfs: combine device update
operations during transaction commit") combined the way certain
operations are recoded in a transaction. As a result an ASSERT was added
in dev_replace_finish to ensure the new code works correctly.
Unfortunately I got reports that it's possible to trigger the assert,
meaning that during a device replace it's possible to have an unfinished
chunk allocation on the source device.

This is supposed to be prevented by the fact that a transaction is
committed before finishing the replace oepration and alter acquiring the
chunk mutex. This is not sufficient since by the time the transaction is
committed and the chunk mutex acquired it's possible to allocate a chunk
depending on the workload being executed on the replaced device. This
bug has been present ever since device replace was introduced but there
was never code which checks for it.

The correct way to fix is to ensure that there is no pending device
modification operation when the chunk mutex is acquire and if there is
repeat transaction commit. Unfortunately it's not possible to just
exclude the source device from btrfs_fs_devices::dev_alloc_list since
this causes ENOSPC to be hit in transaction commit.

Fixing that in another way would need to add special cases to handle the
last writes and forbid new ones. The looped transaction fix is more
obvious, and can be easily backported. The runtime of dev-replace is
long so there's no noticeable delay caused by that.

Reported-by: David Sterba <dsterba@suse.com>
Fixes: 391cd9df81ac ("Btrfs: fix unprotected alloc list insertion during the finishing procedure of replace")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 55c15f31d00d..ee0989c7e3a9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -603,17 +603,33 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	}
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-		return PTR_ERR(trans);
+	/*
+	 * We have to use this loop approach because at this point src_device
+	 * has to be available for transaction commit to complete, yet new
+	 * chunks shouldn't be allocated on the device.
+	 */
+	while (1) {
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans)) {
+			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
+			return PTR_ERR(trans);
+		}
+		ret = btrfs_commit_transaction(trans);
+		WARN_ON(ret);
+
+		/* Prevent write_all_supers() during the finishing procedure */
+		mutex_lock(&fs_info->fs_devices->device_list_mutex);
+		/* Prevent new chunks being allocated on the source device */
+		mutex_lock(&fs_info->chunk_mutex);
+
+		if (!list_empty(&src_device->post_commit_list)) {
+			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+			mutex_unlock(&fs_info->chunk_mutex);
+		} else {
+			break;
+		}
 	}
-	ret = btrfs_commit_transaction(trans);
-	WARN_ON(ret);
 
-	/* keep away write_all_supers() during the finishing procedure */
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	mutex_lock(&fs_info->chunk_mutex);
 	down_write(&dev_replace->rwsem);
 	dev_replace->replace_state =
 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
@@ -662,7 +678,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	btrfs_device_set_disk_total_bytes(tgt_device,
 					  src_device->disk_total_bytes);
 	btrfs_device_set_bytes_used(tgt_device, src_device->bytes_used);
-	ASSERT(list_empty(&src_device->post_commit_list));
 	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
 	tgt_device->commit_bytes_used = src_device->bytes_used;
 

