Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E9754F703
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 13:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382044AbiFQLuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 07:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382049AbiFQLuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 07:50:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0CC6CF63
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 04:50:50 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o2AUv-0007VZ-HO; Fri, 17 Jun 2022 13:50:45 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1o2AUt-00131d-65; Fri, 17 Jun 2022 13:50:44 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1o2AUu-00GneX-13; Fri, 17 Jun 2022 13:50:44 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     dmaengine@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
Subject: [PATCH] dmaengine: imx-sdma: only restart cyclic channel when enabled
Date:   Fri, 17 Jun 2022 13:50:42 +0200
Message-Id: <20220617115042.4004062-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An interrupt for a channel might be pending even after struct
dma_device::device_terminate_all has been called. In that case the
recently introduced warning message "restart cyclic channel..." triggers
and the channel will be restarted. This is not desired as the channel
has just been stopped. Only restart the channel when we still have a
descriptor set for it (which will be set to NULL in
sdma_terminate_all()).

Fixes: 5b215c28b9235 ("dmaengine: imx-sdma: restart cyclic channel if needed")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 8535018ee7a2e..5356cce41bffc 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -891,7 +891,7 @@ static void sdma_update_channel_loop(struct sdma_channel *sdmac)
 	 * SDMA stops cyclic channel when DMA request triggers a channel and no SDMA
 	 * owned buffer is available (i.e. BD_DONE was set too late).
 	 */
-	if (!is_sdma_channel_enabled(sdmac->sdma, sdmac->channel)) {
+	if (sdmac->desc && !is_sdma_channel_enabled(sdmac->sdma, sdmac->channel)) {
 		dev_warn(sdmac->sdma->dev, "restart cyclic channel %d\n", sdmac->channel);
 		sdma_enable_channel(sdmac->sdma, sdmac->channel);
 	}
-- 
2.30.2

