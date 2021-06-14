Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C14F3A63E0
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbhFNLSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232877AbhFNLQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A019461418;
        Mon, 14 Jun 2021 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667788;
        bh=UKGhRPRh/INDDeqP6Sq1fGRy//ZCJqH5IbQ0JB3HDQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQ9V6++e36siY5719SN3weOtXsodEdZjH2O1EGgcveL8PrBO9o/TzwawOqHDjJyoV
         qGQE2cpiOkjSkXW4ygmmWGQ18h4vl8TdK2zyetwN1hSNNcccTAYtMmP0uNR3QgUAzJ
         C0KFz67GeujTCJld18Gn+rlpKcv9D3cBr+A7FHUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 075/173] btrfs: zoned: fix zone number to sector/physical calculation
Date:   Mon, 14 Jun 2021 12:26:47 +0200
Message-Id: <20210614102700.653688505@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 5b434df8778771d181bc19fb4593bca114d1c4eb upstream.

In btrfs_get_dev_zone_info(), we have "u32 sb_zone" and calculate "sector_t
sector" by shifting it. But, this "sector" is calculated in 32bit, leading
it to be 0 for the 2nd superblock copy.

Since zone number is u32, shifting it to sector (sector_t) or physical
address (u64) can easily trigger a missing cast bug like this.

This commit introduces helpers to convert zone number to sector/LBA, so we
won't fall into the same pitfall again.

Reported-by: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
CC: stable@vger.kernel.org # 5.11+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -150,6 +150,18 @@ static inline u32 sb_zone_number(int shi
 	return (u32)zone;
 }
 
+static inline sector_t zone_start_sector(u32 zone_number,
+					 struct block_device *bdev)
+{
+	return (sector_t)zone_number << ilog2(bdev_zone_sectors(bdev));
+}
+
+static inline u64 zone_start_physical(u32 zone_number,
+				      struct btrfs_zoned_device_info *zone_info)
+{
+	return (u64)zone_number << zone_info->zone_size_shift;
+}
+
 /*
  * Emulate blkdev_report_zones() for a non-zoned device. It slices up the block
  * device into static sized chunks and fake a conventional zone on each of
@@ -405,8 +417,8 @@ int btrfs_get_dev_zone_info(struct btrfs
 		if (sb_zone + 1 >= zone_info->nr_zones)
 			continue;
 
-		sector = sb_zone << (zone_info->zone_size_shift - SECTOR_SHIFT);
-		ret = btrfs_get_dev_zones(device, sector << SECTOR_SHIFT,
+		ret = btrfs_get_dev_zones(device,
+					  zone_start_physical(sb_zone, zone_info),
 					  &zone_info->sb_zones[sb_pos],
 					  &nr_zones);
 		if (ret)
@@ -721,7 +733,7 @@ int btrfs_sb_log_location_bdev(struct bl
 	if (sb_zone + 1 >= nr_zones)
 		return -ENOENT;
 
-	ret = blkdev_report_zones(bdev, sb_zone << zone_sectors_shift,
+	ret = blkdev_report_zones(bdev, zone_start_sector(sb_zone, bdev),
 				  BTRFS_NR_SB_LOG_ZONES, copy_zone_info_cb,
 				  zones);
 	if (ret < 0)
@@ -826,7 +838,7 @@ int btrfs_reset_sb_log_zones(struct bloc
 		return -ENOENT;
 
 	return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
-				sb_zone << zone_sectors_shift,
+				zone_start_sector(sb_zone, bdev),
 				zone_sectors * BTRFS_NR_SB_LOG_ZONES, GFP_NOFS);
 }
 
@@ -878,7 +890,8 @@ u64 btrfs_find_allocatable_zones(struct
 			if (!(end <= sb_zone ||
 			      sb_zone + BTRFS_NR_SB_LOG_ZONES <= begin)) {
 				have_sb = true;
-				pos = ((u64)sb_zone + BTRFS_NR_SB_LOG_ZONES) << shift;
+				pos = zone_start_physical(
+					sb_zone + BTRFS_NR_SB_LOG_ZONES, zinfo);
 				break;
 			}
 


