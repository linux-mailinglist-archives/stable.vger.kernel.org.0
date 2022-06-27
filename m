Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BEA55C77A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiF0LiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiF0Lhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3227428E;
        Mon, 27 Jun 2022 04:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C399C609D0;
        Mon, 27 Jun 2022 11:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88273C3411D;
        Mon, 27 Jun 2022 11:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329603;
        bh=wzRgcUUicdNbJvqPsdmDmco70kK+s770X+3oBxpih3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXcruiE2XyOw3bbSS19h6DGjWCTDvAHCJDOz1yvsxwC/1LHmkv7dlqJN9eUGpwwa4
         odgal72VlzRw0Pus8D160NvwMkIWHRT7JHA6ct23PWLItsaT3DlzVuVRikgETCYQq6
         wlTlSuIF9iCQqnPTSG+qH5P6ywgXxqTaCnE+CkDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/135] scsi: scsi_debug: Fix zone transition to full condition
Date:   Mon, 27 Jun 2022 13:20:43 +0200
Message-Id: <20220627111939.207028712@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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
index cfeadd5f61f1..747e1cbb7ec9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2747,6 +2747,24 @@ static void zbc_open_zone(struct sdebug_dev_info *devip,
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
@@ -2759,7 +2777,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
 		zsp->z_wp += num;
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 		return;
 	}
 
@@ -2778,7 +2796,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 			n = num;
 		}
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 
 		num -= n;
 		lba += n;
-- 
2.35.1



