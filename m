Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA85D5B7072
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiIMO3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiIMO2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91694696C5;
        Tue, 13 Sep 2022 07:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC7E614D6;
        Tue, 13 Sep 2022 14:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259D6C433D6;
        Tue, 13 Sep 2022 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078661;
        bh=KAQNNwhHGi/oFnB6JdG9CeVbc8sA1N98qSSDSfnaNpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/NhOSwu5qwof0A1r67JpXe9RIMFdhInoC2djAYSjtVGuH6SpmJDAEH8B9oINHxn2
         Kp9VNNoitbK5zUDyOipBhQfnYwg1q8qMTTmQHcR3LTTuA4ci4aNK1zft/7cQLNNee6
         3Ut4tZ1VcUzh+6MjN6LAlTMhpd7a7wPjqcZHnBhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 033/121] btrfs: zoned: set pseudo max append zone limit in zone emulation mode
Date:   Tue, 13 Sep 2022 16:03:44 +0200
Message-Id: <20220913140358.775326883@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit cac5c44c48c9fb9cc31bea15ebd9ef0c6462314f upstream.

The commit 7d7672bc5d10 ("btrfs: convert count_max_extents() to use
fs_info->max_extent_size") introduced a division by
fs_info->max_extent_size. This max_extent_size is initialized with max
zone append limit size of the device btrfs runs on. However, in zone
emulation mode, the device is not zoned then its zone append limit is
zero. This resulted in zero value of fs_info->max_extent_size and caused
zero division error.

Fix the error by setting non-zero pseudo value to max append zone limit
in zone emulation mode. Set the pseudo value based on max_segments as
suggested in the commit c2ae7b772ef4 ("btrfs: zoned: revive
max_zone_append_bytes").

Fixes: 7d7672bc5d10 ("btrfs: convert count_max_extents() to use fs_info->max_extent_size")
CC: stable@vger.kernel.org # 5.12+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -392,10 +392,19 @@ int btrfs_get_dev_zone_info(struct btrfs
 	 * since btrfs adds the pages one by one to a bio, and btrfs cannot
 	 * increase the metadata reservation even if it increases the number of
 	 * extents, it is safe to stick with the limit.
+	 *
+	 * With the zoned emulation, we can have non-zoned device on the zoned
+	 * mode. In this case, we don't have a valid max zone append size. So,
+	 * use max_segments * PAGE_SIZE as the pseudo max_zone_append_size.
 	 */
-	zone_info->max_zone_append_size =
-		min_t(u64, (u64)bdev_max_zone_append_sectors(bdev) << SECTOR_SHIFT,
-		      (u64)bdev_max_segments(bdev) << PAGE_SHIFT);
+	if (bdev_is_zoned(bdev)) {
+		zone_info->max_zone_append_size = min_t(u64,
+			(u64)bdev_max_zone_append_sectors(bdev) << SECTOR_SHIFT,
+			(u64)bdev_max_segments(bdev) << PAGE_SHIFT);
+	} else {
+		zone_info->max_zone_append_size =
+			(u64)bdev_max_segments(bdev) << PAGE_SHIFT;
+	}
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 


