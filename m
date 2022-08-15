Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558E459495F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbiHOXce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347802AbiHOXbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:31:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222F014F95C;
        Mon, 15 Aug 2022 13:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B9EAB80EA8;
        Mon, 15 Aug 2022 20:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0DDC433C1;
        Mon, 15 Aug 2022 20:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594086;
        bh=SKEygmUBXzgJPwifGS9B38zKqN9dE7k1jJLKHwEV9f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlB6QNRoi/t6gIGCreXAVVhkCUhPcLYEbBBbQB845pnFpwObS4CoQ+NDiNHGhaLqW
         g/r2B9OkHpE+wwjvfOn8Ik3CnCtCzqu31BrPk57qck3dpxcfJ+5b0NS13915WweQOl
         2ReJMqLByhjWXQpff6zP7pGitMrhovfvd3l3Z39g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1019/1095] btrfs: zoned: revive max_zone_append_bytes
Date:   Mon, 15 Aug 2022 20:06:58 +0200
Message-Id: <20220815180511.239026764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit c2ae7b772ef4e86c5ddf3fd47bf59045ae96a414 ]

This patch is basically a revert of commit 5a80d1c6a270 ("btrfs: zoned:
remove max_zone_append_size logic"), but without unnecessary ASSERT and
check. The max_zone_append_size will be used as a hint to estimate the
number of extents to cover delalloc/writeback region in the later commits.

The size of a ZONE APPEND bio is also limited by queue_max_segments(), so
this commit considers it to calculate max_zone_append_size. Technically, a
bio can be larger than queue_max_segments() * PAGE_SIZE if the pages are
contiguous. But, it is safe to consider "queue_max_segments() * PAGE_SIZE"
as an upper limit of an extent size to calculate the number of extents
needed to write data.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/zoned.c | 17 +++++++++++++++++
 fs/btrfs/zoned.h |  1 +
 3 files changed, 20 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 077c95e9baa5..1c377bcfe787 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1050,6 +1050,8 @@ struct btrfs_fs_info {
 		u64 zoned;
 	};
 
+	/* Max size to emit ZONE_APPEND write command */
+	u64 max_zone_append_size;
 	struct mutex zoned_meta_io_lock;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 84b6d39509bd..1d5b9308f5ef 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -407,6 +407,16 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	nr_sectors = bdev_nr_sectors(bdev);
 	zone_info->zone_size_shift = ilog2(zone_info->zone_size);
 	zone_info->nr_zones = nr_sectors >> ilog2(zone_sectors);
+	/*
+	 * We limit max_zone_append_size also by max_segments *
+	 * PAGE_SIZE. Technically, we can have multiple pages per segment. But,
+	 * since btrfs adds the pages one by one to a bio, and btrfs cannot
+	 * increase the metadata reservation even if it increases the number of
+	 * extents, it is safe to stick with the limit.
+	 */
+	zone_info->max_zone_append_size =
+		min_t(u64, (u64)bdev_max_zone_append_sectors(bdev) << SECTOR_SHIFT,
+		      (u64)bdev_max_segments(bdev) << PAGE_SHIFT);
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
@@ -632,6 +642,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 	u64 zoned_devices = 0;
 	u64 nr_devices = 0;
 	u64 zone_size = 0;
+	u64 max_zone_append_size = 0;
 	const bool incompat_zoned = btrfs_fs_incompat(fs_info, ZONED);
 	int ret = 0;
 
@@ -666,6 +677,11 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 				ret = -EINVAL;
 				goto out;
 			}
+			if (!max_zone_append_size ||
+			    (zone_info->max_zone_append_size &&
+			     zone_info->max_zone_append_size < max_zone_append_size))
+				max_zone_append_size =
+					zone_info->max_zone_append_size;
 		}
 		nr_devices++;
 	}
@@ -715,6 +731,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 	}
 
 	fs_info->zone_size = zone_size;
+	fs_info->max_zone_append_size = max_zone_append_size;
 	fs_info->fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_ZONED;
 
 	/*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index cf6320feef46..2d6da8f4b55a 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -23,6 +23,7 @@ struct btrfs_zoned_device_info {
 	 */
 	u64 zone_size;
 	u8  zone_size_shift;
+	u64 max_zone_append_size;
 	u32 nr_zones;
 	unsigned int max_active_zones;
 	atomic_t active_zones_left;
-- 
2.35.1



