Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394BA55D3AD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiF0LXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiF0LXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:23:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A608B6465;
        Mon, 27 Jun 2022 04:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 623F3B81125;
        Mon, 27 Jun 2022 11:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B715AC3411D;
        Mon, 27 Jun 2022 11:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329025;
        bh=6g+0kDNDTJ6rzAV6vLpGtfTRgDWoLZS/lo3rJxyabA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dX8E6P9BDtHJlTi9k3NIpJEFq1dSEUUQJYTxOw5+7AGYdqPanj/0myt+VLtCgKmKt
         UEf9IC+yrO87R+5QXavm8Vra0jyzY/qgNMfehY9wne0h+ARj2llAbghuRflLbf6+Ho
         p4ocINOiQ0sYCtq7az+yPD1BCECmyI7ylV0Ga3kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/102] scsi: scsi_debug: Fix zone transition to full condition
Date:   Mon, 27 Jun 2022 13:20:36 +0200
Message-Id: <20220627111934.213721698@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 566d3c57eb526f32951af15866086e236ce1fc8a ]

When a write command to a sequential write required or sequential write
preferred zone result in the zone write pointer reaching the end of the
zone, the zone condition must be set to full AND the number of implicitly
or explicitly open zones updated to have a correct accounting for zone
resources. However, the function zbc_inc_wp() only sets the zone condition
to full without updating the open zone counters, resulting in a zone state
machine breakage.

Introduce the helper function zbc_set_zone_full() and use it in
zbc_inc_wp() to correctly transition zones to the full condition.

Link: https://lore.kernel.org/r/20220608011302.92061-1-damien.lemoal@opensource.wdc.com
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6b00de6b6f0e..5eb959b5f701 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2746,6 +2746,24 @@ static void zbc_open_zone(struct sdebug_dev_info *devip,
 	}
 }
 
+static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
+				     struct sdeb_zone_state *zsp)
+{
+	switch (zsp->z_cond) {
+	case ZC2_IMPLICIT_OPEN:
+		devip->nr_imp_open--;
+		break;
+	case ZC3_EXPLICIT_OPEN:
+		devip->nr_exp_open--;
+		break;
+	default:
+		WARN_ONCE(true, "Invalid zone %llu condition %x\n",
+			  zsp->z_start, zsp->z_cond);
+		break;
+	}
+	zsp->z_cond = ZC5_FULL;
+}
+
 static void zbc_inc_wp(struct sdebug_dev_info *devip,
 		       unsigned long long lba, unsigned int num)
 {
@@ -2758,7 +2776,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
 		zsp->z_wp += num;
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 		return;
 	}
 
@@ -2777,7 +2795,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 			n = num;
 		}
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 
 		num -= n;
 		lba += n;
-- 
2.35.1



