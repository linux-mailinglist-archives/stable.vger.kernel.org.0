Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F413C628097
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbiKNNHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbiKNNHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80F22AE35
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60EF5B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF1C433D7;
        Mon, 14 Nov 2022 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431227;
        bh=EZlVuAnDu+GzcJlwOmvR6tf+oolmhRFtcqrOmns71o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUbLIIoV8VPdiFQqlsWOQij4p9IJY2E8d4g/ObLxEukeAMlaIl33BiKymFRP0PL6e
         tBc6UjFIX0BCvfMD8Z4L4mVq0Jq8hgwbQpreC8LuCkQP/zcqbs/XTBfdNy8mYnJPQl
         9UhL69O9p0Easp8ZO6iFcwhxP+AS9J5TeRkuEnhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 148/190] btrfs: zoned: clone zoned device info when cloning a device
Date:   Mon, 14 Nov 2022 13:46:12 +0100
Message-Id: <20221114124505.275523244@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 21e61ec6d0bb786818490e926aa9aeb4de95ad0d upstream.

When cloning a btrfs_device, we're not cloning the associated
btrfs_zoned_device_info structure of the device in case of a zoned
filesystem.

Later on this leads to a NULL pointer dereference when accessing the
device's zone_info for instance when setting a zone as active.

This was uncovered by fstests' testcase btrfs/161.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   12 ++++++++++++
 fs/btrfs/zoned.c   |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h   |   11 +++++++++++
 3 files changed, 63 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1009,6 +1009,18 @@ static struct btrfs_fs_devices *clone_fs
 			rcu_assign_pointer(device->name, name);
 		}
 
+		if (orig_dev->zone_info) {
+			struct btrfs_zoned_device_info *zone_info;
+
+			zone_info = btrfs_clone_dev_zone_info(orig_dev);
+			if (!zone_info) {
+				btrfs_free_device(device);
+				ret = -ENOMEM;
+				goto error;
+			}
+			device->zone_info = zone_info;
+		}
+
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -639,6 +639,46 @@ void btrfs_destroy_dev_zone_info(struct
 	device->zone_info = NULL;
 }
 
+struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(struct btrfs_device *orig_dev)
+{
+	struct btrfs_zoned_device_info *zone_info;
+
+	zone_info = kmemdup(orig_dev->zone_info, sizeof(*zone_info), GFP_KERNEL);
+	if (!zone_info)
+		return NULL;
+
+	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
+	if (!zone_info->seq_zones)
+		goto out;
+
+	bitmap_copy(zone_info->seq_zones, orig_dev->zone_info->seq_zones,
+		    zone_info->nr_zones);
+
+	zone_info->empty_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
+	if (!zone_info->empty_zones)
+		goto out;
+
+	bitmap_copy(zone_info->empty_zones, orig_dev->zone_info->empty_zones,
+		    zone_info->nr_zones);
+
+	zone_info->active_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
+	if (!zone_info->active_zones)
+		goto out;
+
+	bitmap_copy(zone_info->active_zones, orig_dev->zone_info->active_zones,
+		    zone_info->nr_zones);
+	zone_info->zone_cache = NULL;
+
+	return zone_info;
+
+out:
+	bitmap_free(zone_info->seq_zones);
+	bitmap_free(zone_info->empty_zones);
+	bitmap_free(zone_info->active_zones);
+	kfree(zone_info);
+	return NULL;
+}
+
 int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 		       struct blk_zone *zone)
 {
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -36,6 +36,7 @@ int btrfs_get_dev_zone(struct btrfs_devi
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
 int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache);
 void btrfs_destroy_dev_zone_info(struct btrfs_device *device);
+struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(struct btrfs_device *orig_dev);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 int btrfs_check_mountopts_zoned(struct btrfs_fs_info *info);
 int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
@@ -103,6 +104,16 @@ static inline int btrfs_get_dev_zone_inf
 
 static inline void btrfs_destroy_dev_zone_info(struct btrfs_device *device) { }
 
+/*
+ * In case the kernel is compiled without CONFIG_BLK_DEV_ZONED we'll never call
+ * into btrfs_clone_dev_zone_info() so it's safe to return NULL here.
+ */
+static inline struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(
+						 struct btrfs_device *orig_dev)
+{
+	return NULL;
+}
+
 static inline int btrfs_check_zoned_mode(const struct btrfs_fs_info *fs_info)
 {
 	if (!btrfs_is_zoned(fs_info))


