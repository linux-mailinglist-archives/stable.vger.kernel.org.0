Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66C86BB284
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjCOMgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjCOMgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:36:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489BD9AA32
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CAD461D7D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409A1C433EF;
        Wed, 15 Mar 2023 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883700;
        bh=mb0HX/SGQsDLsYMLVC2aqEhKx/fK9KlG6dFHMVQcFxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jO0WJ3t0cKyIRnIkhYFE/H/O3ndfIc/8wgp6Wi8PQAqrQomTMgWRk6qXC2/QwcddI
         zwZy22m+OA6Ntva8q7GiM8j/kcZj25GhYvqL3m6/lVd9USUhkALTzMcrFy8+OI9jMp
         VxbVY0NODbC5hufGwQjDxAeJEz/DoYGqbA+l0WL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/143] scsi: sd: Fix wrong zone_write_granularity value during revalidate
Date:   Wed, 15 Mar 2023 13:13:04 +0100
Message-Id: <20230315115743.488312335@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 288b3271d920c9ba949c3bab0f749f4cecc70e09 ]

When the sd driver revalidates host-managed SMR disks, it calls
disk_set_zoned() which changes the zone_write_granularity attribute value
to the logical block size regardless of the device type. After that, the sd
driver overwrites the value in sd_zbc_read_zone() with the physical block
size, since ZBC/ZAC requires this for host-managed disks. Between the calls
to disk_set_zoned() and sd_zbc_read_zone(), there exists a window where the
attribute shows the logical block size as the zone_write_granularity value,
which is wrong for host-managed disks. The duration of the window is from
20ms to 200ms, depending on report zone command execution time.

To avoid the wrong zone_write_granularity value between disk_set_zoned()
and sd_zbc_read_zone(), modify the value not in sd_zbc_read_zone() but
just after disk_set_zoned() call.

Fixes: a805a4fa4fa3 ("block: introduce zone_write_granularity limit")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20230306063024.3376959-1-shinichiro.kawasaki@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c     | 7 ++++++-
 drivers/scsi/sd_zbc.c | 8 --------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba0550216..e934779bf05c8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2933,8 +2933,13 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	}
 
 	if (sdkp->device->type == TYPE_ZBC) {
-		/* Host-managed */
+		/*
+		 * Host-managed: Per ZBC and ZAC specifications, writes in
+		 * sequential write required zones of host-managed devices must
+		 * be aligned to the device physical block size.
+		 */
 		disk_set_zoned(sdkp->disk, BLK_ZONED_HM);
+		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
 	} else {
 		sdkp->zoned = zoned;
 		if (sdkp->zoned == 1) {
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c63228..4c35b4a916355 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -956,14 +956,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	disk_set_max_active_zones(disk, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
-	/*
-	 * Per ZBC and ZAC specifications, writes in sequential write required
-	 * zones of host-managed devices must be aligned to the device physical
-	 * block size.
-	 */
-	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
-		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
-
 	sdkp->early_zone_info.nr_zones = nr_zones;
 	sdkp->early_zone_info.zone_blocks = zone_blocks;
 
-- 
2.39.2



