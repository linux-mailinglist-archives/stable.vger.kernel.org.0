Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFD765805D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiL1QRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiL1QQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A381AA09
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1EAB81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5762EC433EF;
        Wed, 28 Dec 2022 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244048;
        bh=cIG+b7oz0ag4bmz9oA82CvOdSzxhBnQsHmyAQz7rd20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoXG9DrvxhA+x7nzzVYNgdJosF/XljBUemXe4gOxMqqSV8e5wDViW+n0/r5FPds/q
         r+3I3ZX//+kp6bBUFuza/FKmHmPnn0ocJnibnkVMirP/MUpfnabt3UycJ48ysqju3f
         MWdt+0s7CKdat3X0ZMuF1G6mTy5yKs+0KUBu9zzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kamal Heib <kamalheib1@gmail.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0601/1146] RDMA/irdma: Report the correct link speed
Date:   Wed, 28 Dec 2022 15:35:40 +0100
Message-Id: <20221228144346.497580974@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit 4eace75e0853273755b878ffa9cce6de84df975a ]

The active link speed is currently hard-coded in irdma_query_port due
to which the port rate in ibstatus does reflect the active link speed.

Call ib_get_eth_speed in irdma_query_port to get the active link speed.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Reported-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20221104234957.1135-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 35 +++--------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index a22afbb25bc5..434241789f12 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -63,36 +63,6 @@ static int irdma_query_device(struct ib_device *ibdev,
 	return 0;
 }
 
-/**
- * irdma_get_eth_speed_and_width - Get IB port speed and width from netdev speed
- * @link_speed: netdev phy link speed
- * @active_speed: IB port speed
- * @active_width: IB port width
- */
-static void irdma_get_eth_speed_and_width(u32 link_speed, u16 *active_speed,
-					  u8 *active_width)
-{
-	if (link_speed <= SPEED_1000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_SDR;
-	} else if (link_speed <= SPEED_10000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_FDR10;
-	} else if (link_speed <= SPEED_20000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_DDR;
-	} else if (link_speed <= SPEED_25000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_EDR;
-	} else if (link_speed <= SPEED_40000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_FDR10;
-	} else {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_EDR;
-	}
-}
-
 /**
  * irdma_query_port - get port attributes
  * @ibdev: device pointer from stack
@@ -120,8 +90,9 @@ static int irdma_query_port(struct ib_device *ibdev, u32 port,
 		props->state = IB_PORT_DOWN;
 		props->phys_state = IB_PORT_PHYS_STATE_DISABLED;
 	}
-	irdma_get_eth_speed_and_width(SPEED_100000, &props->active_speed,
-				      &props->active_width);
+
+	ib_get_eth_speed(ibdev, port, &props->active_speed,
+			 &props->active_width);
 
 	if (rdma_protocol_roce(ibdev, 1)) {
 		props->gid_tbl_len = 32;
-- 
2.35.1



