Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC08E3419E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFDISh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:18:37 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38861 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726732AbfFDISg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:18:36 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 634612CD8;
        Tue,  4 Jun 2019 04:18:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=b8jXfM
        D/uhh7XHOdEJ97MqVVbqGW4e9KzWV3+q0FoSY=; b=Bn1JjLvOstNqVeLsE2BEir
        UsciB8L5b0ROhD309BEySwm6LkXCKwNOETyn1sLAUbksZWR9Vq83ETy24ifOVmpV
        3g+AVY3cfZoAe6bN3HzeM2gVoJ7O2OivTjQcfocZ8ujN3eXEnrJ/fMMLmup1Nz2+
        XRPbU5X4OoXCEJrwlP7qRSMeEolknvQVCf1dJH5DAJBlV6tdjJbIC/IqbAmO+yFD
        DFb6clvHp/b7FGZQbzPmVwOv58vmeHHrDAo7DLyDIwuEdNIqWnM66Q+h6f0EBn8j
        Gk0Zhc94XPHyggEoUrbsjYB+l8oQoeEHRBih6nvYaRjytpTUUFnT2rsX+mpF88LQ
        ==
X-ME-Sender: <xms:Win2XHEkiW29LkGUhvwrW58KE2x7O7YzUxIRSRdlDxZ_gFL_nPlV3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:Win2XIyuQ7h6VasyhB07xxZsv3NMAdBK5i-V1c2LC5JuB8PoEK5H9g>
    <xmx:Win2XF5RlVp7-NbyI0qyB2FEMMVyyz6Nr1iR7UD4npj7QDG0-b_V8w>
    <xmx:Win2XHDsGc8v1FpeQ0D65GjSMrFi5nBc4d0kBUX9g6okQZOSaX520A>
    <xmx:Wyn2XMvNw5Rb3wv0P2mlDqslFT2AQlH8WbzjVwuEoXQtLGQhNPCC0g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7247480059;
        Tue,  4 Jun 2019 04:18:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: Ensure replaced device doesn't have pending chunk" failed to apply to 4.14-stable tree
To:     nborisov@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 10:18:30 +0200
Message-ID: <155963631091185@kroah.com>
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
 

