Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA4E56FCF2
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiGKJtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbiGKJsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:48:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70283EAD;
        Mon, 11 Jul 2022 02:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86964B80CEF;
        Mon, 11 Jul 2022 09:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8051C34115;
        Mon, 11 Jul 2022 09:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531410;
        bh=DviDe3YdOiK48VV2ouMZ/mwRhFKQstraiLFaIzZug6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKio/0v65gs/cZQyZOVHGIwowt2KPVGWajRpdajdIwBEkpPKFeTbPqe/FRSnK8ypb
         iyQyjbG7HspjmzRoiMISqUXIRHjm3ClmhKNSsjXswFBNlIZ3h/di9EkB0VHb8zsifW
         NQq8fWrcne1d7aIVJp+aXyfcVhYg5OodlROUgztk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Luca=20B=C3=A9la=20Palkovics?= 
        <luca.bela.palkovics@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/230] btrfs: remove device item and update super block in the same transaction
Date:   Mon, 11 Jul 2022 11:05:44 +0200
Message-Id: <20220711090606.568460790@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit bbac58698a55cc0a6f0c0d69a6dcd3f9f3134c11 ]

[BUG]
There is a report that a btrfs has a bad super block num devices.

This makes btrfs to reject the fs completely.

  BTRFS error (device sdd3): super_num_devices 3 mismatch with num_devices 2 found here
  BTRFS error (device sdd3): failed to read chunk tree: -22
  BTRFS error (device sdd3): open_ctree failed

[CAUSE]
During btrfs device removal, chunk tree and super block num devs are
updated in two different transactions:

  btrfs_rm_device()
  |- btrfs_rm_dev_item(device)
  |  |- trans = btrfs_start_transaction()
  |  |  Now we got transaction X
  |  |
  |  |- btrfs_del_item()
  |  |  Now device item is removed from chunk tree
  |  |
  |  |- btrfs_commit_transaction()
  |     Transaction X got committed, super num devs untouched,
  |     but device item removed from chunk tree.
  |     (AKA, super num devs is already incorrect)
  |
  |- cur_devices->num_devices--;
  |- cur_devices->total_devices--;
  |- btrfs_set_super_num_devices()
     All those operations are not in transaction X, thus it will
     only be written back to disk in next transaction.

So after the transaction X in btrfs_rm_dev_item() committed, but before
transaction X+1 (which can be minutes away), a power loss happen, then
we got the super num mismatch.

[FIX]
Instead of starting and committing a transaction inside
btrfs_rm_dev_item(), start a transaction in side btrfs_rm_device() and
pass it to btrfs_rm_dev_item().

And only commit the transaction after everything is done.

Reported-by: Luca Béla Palkovics <luca.bela.palkovics@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+8xDSpvdm_U0QLBAnrH=zqDq_cWCOH5TiV46CKmp3igr44okQ@mail.gmail.com/
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 65 ++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3bd68f1b79e6..cec54c6e1cdd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1942,23 +1942,18 @@ static void update_dev_time(const char *device_path)
 	path_put(&path);
 }
 
-static int btrfs_rm_dev_item(struct btrfs_device *device)
+static int btrfs_rm_dev_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_device *device)
 {
 	struct btrfs_root *root = device->fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct btrfs_trans_handle *trans;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
-		return PTR_ERR(trans);
-	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
@@ -1969,21 +1964,12 @@ static int btrfs_rm_dev_item(struct btrfs_device *device)
 	if (ret) {
 		if (ret > 0)
 			ret = -ENOENT;
-		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans);
 		goto out;
 	}
 
 	ret = btrfs_del_item(trans, root, path);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans);
-	}
-
 out:
 	btrfs_free_path(path);
-	if (!ret)
-		ret = btrfs_commit_transaction(trans);
 	return ret;
 }
 
@@ -2124,6 +2110,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		    struct btrfs_dev_lookup_args *args,
 		    struct block_device **bdev, fmode_t *mode)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_devices;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
@@ -2139,7 +2126,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
-		goto out;
+		return ret;
 
 	device = btrfs_find_device(fs_info->fs_devices, args);
 	if (!device) {
@@ -2147,27 +2134,22 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 		else
 			ret = -ENOENT;
-		goto out;
+		return ret;
 	}
 
 	if (btrfs_pinned_by_swapfile(fs_info, device)) {
 		btrfs_warn_in_rcu(fs_info,
 		  "cannot remove device %s (devid %llu) due to active swapfile",
 				  rcu_str_deref(device->name), device->devid);
-		ret = -ETXTBSY;
-		goto out;
+		return -ETXTBSY;
 	}
 
-	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
-		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
-		goto out;
-	}
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+		return BTRFS_ERROR_DEV_TGT_REPLACE;
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
-	    fs_info->fs_devices->rw_devices == 1) {
-		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
-		goto out;
-	}
+	    fs_info->fs_devices->rw_devices == 1)
+		return BTRFS_ERROR_DEV_ONLY_WRITABLE;
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
@@ -2182,14 +2164,22 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 	if (ret)
 		goto error_undo;
 
-	/*
-	 * TODO: the superblock still includes this device in its num_devices
-	 * counter although write_all_supers() is not locked out. This
-	 * could give a filesystem state which requires a degraded mount.
-	 */
-	ret = btrfs_rm_dev_item(device);
-	if (ret)
+	trans = btrfs_start_transaction(fs_info->chunk_root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto error_undo;
+	}
+
+	ret = btrfs_rm_dev_item(trans, device);
+	if (ret) {
+		/* Any error in dev item removal is critical */
+		btrfs_crit(fs_info,
+			   "failed to remove device item for devid %llu: %d",
+			   device->devid, ret);
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
+		return ret;
+	}
 
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	btrfs_scrub_cancel_dev(device);
@@ -2264,7 +2254,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		free_fs_devices(cur_devices);
 	}
 
-out:
+	ret = btrfs_commit_transaction(trans);
+
 	return ret;
 
 error_undo:
@@ -2276,7 +2267,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		device->fs_devices->rw_devices++;
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
-	goto out;
+	return ret;
 }
 
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev)
-- 
2.35.1



