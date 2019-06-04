Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C303419C
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfFDISc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:18:32 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36577 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfFDISc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:18:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3437D2CD5;
        Tue,  4 Jun 2019 04:18:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/dcoCO
        MSe3zPVB/63De1msCjmSvAqbjdWEEMebEAUQI=; b=GurgfZM6Q4WsYAycTTfXgH
        ocFv+YPCKWoVAkx8xZCEr8bW4BaXC/rD/w+gOfo/n+AHOivc0D9Na6IXgYpK3rwX
        o/nICLZlLo4eDrUQAd12SMsdRLHFQ3+HuUk1fEtv5Qe5W+jelld8utLpsyILwFCZ
        iAy6MkIH4q93xlmLFdEJvzaP4I6V6OE98LkrfPvDBUtR5Ko7qwJqNHggt6drHVRd
        MSGFxym8Uf/Oh7F44LTlsE1FMGTaF8K7sTGezMtLNVtyV7Wwv6/ywuwnfg4ecAIR
        V25C4uRVEcrIefcE3ncnPYXvnhssV96L2CVKVb1KmP0/1ynxGarxKGMlsYq3gf+w
        ==
X-ME-Sender: <xms:Vin2XOufcS2ptBRAlRoRYCgA1wBcqKFY09LQtiR8HYtmd_3UPC_meQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:Vin2XHsu10ajtO4zLKQhTMt1AHGTM6BoAO0pTxoxqueokA6UiOv6xQ>
    <xmx:Vin2XEw5cMLBySB0cTlK22tiu_af1Wvw8iKIopxAumkjfr6APOfXpQ>
    <xmx:Vin2XNi2UWbXLbP75XsL44yfVmTA586P0PzDJ7I0Bn8EODjQqv9o3g>
    <xmx:Vin2XIijxl06HWi7ewLyozAZngQyTSsrdmz-nxUcJ2vHHlquUXoXYQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 306748005B;
        Tue,  4 Jun 2019 04:18:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: Ensure replaced device doesn't have pending chunk" failed to apply to 5.1-stable tree
To:     nborisov@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 10:18:28 +0200
Message-ID: <155963630867216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
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
 

