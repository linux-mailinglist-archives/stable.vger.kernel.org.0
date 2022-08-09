Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8E358DEC5
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiHISXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347402AbiHISW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:22:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCDC31DE6;
        Tue,  9 Aug 2022 11:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FC52B818C2;
        Tue,  9 Aug 2022 18:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA402C4347C;
        Tue,  9 Aug 2022 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068446;
        bh=bTdcFfwKJ/nbB6gJvzfhysdQBts1d5oaJWWzgVsCDuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ad0hxGuRVBjomg6S32i3X4fc2BK673vrekKy8Ux8EXJP6zTCwzvine9L6HdY4rs7V
         1/wJsMyyAAyYHCCHHN9+h5njZOyqHSCo/UO4tQEJR1Xx9tcpF/WCHhrNXN3QWWyhr/
         RVOrTFZry03UEVx7reE2fYc5YQfp9DFuYw8EoZ4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 22/35] btrfs: zoned: drop optimization of zone finish
Date:   Tue,  9 Aug 2022 20:00:51 +0200
Message-Id: <20220809175515.877774133@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

commit b3a3b0255797e1d395253366ba24a4cc6c8bdf9c upstream.

We have an optimization in do_zone_finish() to send REQ_OP_ZONE_FINISH only
when necessary, i.e. we don't send REQ_OP_ZONE_FINISH when we assume we
wrote fully into the zone.

The assumption is determined by "alloc_offset == capacity". This condition
won't work if the last ordered extent is canceled due to some errors. In
that case, we consider the zone is deactivated without sending the finish
command while it's still active.

This inconstancy results in activating another block group while we cannot
really activate the underlying zone, which causes the active zone exceeds
errors like below.

    BTRFS error (device nvme3n2): allocation failed flags 1, wanted 520192 tree-log 0, relocation: 0
    nvme3n2: I/O Cmd(0x7d) @ LBA 160432128, 127 blocks, I/O Error (sct 0x1 / sc 0xbd) MORE DNR
    active zones exceeded error, dev nvme3n2, sector 0 op 0xd:(ZONE_APPEND) flags 0x4800 phys_seg 1 prio class 0
    nvme3n2: I/O Cmd(0x7d) @ LBA 160432128, 127 blocks, I/O Error (sct 0x1 / sc 0xbd) MORE DNR
    active zones exceeded error, dev nvme3n2, sector 0 op 0xd:(ZONE_APPEND) flags 0x4800 phys_seg 1 prio class 0

Fix the issue by removing the optimization for now.

Fixes: 8376d9e1ed8f ("btrfs: zoned: finish superblock zone once no space left for new SB")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2005,6 +2005,7 @@ void btrfs_zone_finish_endio(struct btrf
 	struct btrfs_device *device;
 	u64 min_alloc_bytes;
 	u64 physical;
+	int i;
 
 	if (!btrfs_is_zoned(fs_info))
 		return;
@@ -2039,13 +2040,25 @@ void btrfs_zone_finish_endio(struct btrf
 	spin_unlock(&block_group->lock);
 
 	map = block_group->physical_map;
-	device = map->stripes[0].dev;
-	physical = map->stripes[0].physical;
+	for (i = 0; i < map->num_stripes; i++) {
+		int ret;
 
-	if (!device->zone_info->max_active_zones)
-		goto out;
+		device = map->stripes[i].dev;
+		physical = map->stripes[i].physical;
+
+		if (device->zone_info->max_active_zones == 0)
+			continue;
+
+		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+				       physical >> SECTOR_SHIFT,
+				       device->zone_info->zone_size >> SECTOR_SHIFT,
+				       GFP_NOFS);
 
-	btrfs_dev_clear_active_zone(device, physical);
+		if (ret)
+			return;
+
+		btrfs_dev_clear_active_zone(device, physical);
+	}
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
 	ASSERT(!list_empty(&block_group->active_bg_list));


