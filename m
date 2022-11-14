Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E13628098
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbiKNNHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237854AbiKNNHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C092A977
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06D2FB80EA6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAE9C433C1;
        Mon, 14 Nov 2022 13:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431229;
        bh=mJNU0xZvVwSfreCcXr7WC/hWPH4n8YYOlp62sGbLEGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHdH/EazfJwxP6n4Hg6CWOr/5GudRHYs91y2hRcvj8LddhppZpyIoc+glBJUWzs1J
         7S5WkpShSnY7TZwiojX2yYEz8hKtCjN06BmjPFU8T5dO4NnVrFjIAlDVo4OAvBzAiX
         xU2uyqBVrGhYJ8z6c3N/4I2Xmmj5Mo2Fh+K3QphM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 149/190] btrfs: zoned: initialize devices zone info for seeding
Date:   Mon, 14 Nov 2022 13:46:13 +0100
Message-Id: <20221114124505.324993295@linuxfoundation.org>
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

commit a8d1b1647bf8244a5f270538e9e636e2657fffa3 upstream.

When performing seeding on a zoned filesystem it is necessary to
initialize each zoned device's btrfs_zoned_device_info structure,
otherwise mounting the filesystem will cause a NULL pointer dereference.

This was uncovered by fstests' testcase btrfs/163.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    4 +++-
 fs/btrfs/volumes.c |   11 +++++++++--
 fs/btrfs/volumes.h |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2544,7 +2544,9 @@ static int btrfs_read_roots(struct btrfs
 		fs_info->dev_root = root;
 	}
 	/* Initialize fs_info for all devices in any case */
-	btrfs_init_devices_late(fs_info);
+	ret = btrfs_init_devices_late(fs_info);
+	if (ret)
+		goto out;
 
 	/*
 	 * This tree can share blocks with some other fs tree during relocation
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7643,10 +7643,11 @@ error:
 	return ret;
 }
 
-void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
+int btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices, *seed_devs;
 	struct btrfs_device *device;
+	int ret = 0;
 
 	fs_devices->fs_info = fs_info;
 
@@ -7655,12 +7656,18 @@ void btrfs_init_devices_late(struct btrf
 		device->fs_info = fs_info;
 
 	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
-		list_for_each_entry(device, &seed_devs->devices, dev_list)
+		list_for_each_entry(device, &seed_devs->devices, dev_list) {
 			device->fs_info = fs_info;
+			ret = btrfs_get_dev_zone_info(device, false);
+			if (ret)
+				break;
+		}
 
 		seed_devs->fs_info = fs_info;
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
+
+	return ret;
 }
 
 static u64 btrfs_dev_stats_value(const struct extent_buffer *eb,
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -629,7 +629,7 @@ int find_free_dev_extent(struct btrfs_de
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			struct btrfs_ioctl_get_dev_stats *stats);
-void btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
+int btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
 int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans);
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);


