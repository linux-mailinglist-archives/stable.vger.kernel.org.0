Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7863D627AD9
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiKNKnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiKNKm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:42:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697E01EAF8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 298ACB80DBA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739D9C433C1;
        Mon, 14 Nov 2022 10:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668422574;
        bh=unX3Vf+dt/2M6UafOTObqazpAi7kFzv3muEuD2BRzU4=;
        h=Subject:To:Cc:From:Date:From;
        b=Z+hegJJHS+e6pi8n9jAmMC0uWubrmNgNUkHPMQ4rf7mYnNQBdyvSLYjw42EkmyXD3
         d+0tNi3kkcmtKohsXPikb9Weqimjm1KE+ZLsHoiBN415tmgOlZcO9TLeKSfpux/l9V
         6n4Ain2icshBs2mTb5/EJ2RBHVzUlJy1R0z/a/QI=
Subject: FAILED: patch "[PATCH] btrfs: zoned: clone zoned device info when cloning a device" failed to apply to 5.15-stable tree
To:     johannes.thumshirn@wdc.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:42:51 +0100
Message-ID: <166842257185184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

21e61ec6d0bb ("btrfs: zoned: clone zoned device info when cloning a device")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 21e61ec6d0bb786818490e926aa9aeb4de95ad0d Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Fri, 4 Nov 2022 07:12:33 -0700
Subject: [PATCH] btrfs: zoned: clone zoned device info when cloning a device

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

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f09d09c259f5..3cb968ede675 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1011,6 +1011,18 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
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
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e2d073b08a7d..1912abf6d020 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -639,6 +639,46 @@ void btrfs_destroy_dev_zone_info(struct btrfs_device *device)
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
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index e17462db3a84..8bd16d40b7c6 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -36,6 +36,7 @@ int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
 int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache);
 void btrfs_destroy_dev_zone_info(struct btrfs_device *device);
+struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(struct btrfs_device *orig_dev);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 int btrfs_check_mountopts_zoned(struct btrfs_fs_info *info);
 int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
@@ -103,6 +104,16 @@ static inline int btrfs_get_dev_zone_info(struct btrfs_device *device,
 
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

