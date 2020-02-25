Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CBD16BBC5
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 09:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgBYIXX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 25 Feb 2020 03:23:23 -0500
Received: from skedge03.snt-world.com ([91.208.41.68]:49644 "EHLO
        skedge03.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgBYIXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 03:23:23 -0500
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge03.snt-world.com (Postfix) with ESMTPS id 8458367A7D5;
        Tue, 25 Feb 2020 09:23:20 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 25 Feb
 2020 09:23:20 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Tue, 25 Feb 2020 09:23:20 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Dan Williams <dan.j.williams@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "Vinod Koul" <vkoul@kernel.org>
CC:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] dmaengine: imx-sdma: Fix the event id check to include RX
 event for UART6
Thread-Topic: [PATCH v2] dmaengine: imx-sdma: Fix the event id check to
 include RX event for UART6
Thread-Index: AQHV67TW1CT++vzAE0CZMa71bI30KA==
Date:   Tue, 25 Feb 2020 08:23:20 +0000
Message-ID: <20200225082139.7646-1-frieder.schrempf@kontron.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 8458367A7D5.ADFDA
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        festevam@gmail.com, kernel@pengutronix.de,
        linus.ml.walleij@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-imx@nxp.com, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, shawnguo@kernel.org, stable@vger.kernel.org,
        vkoul@kernel.org
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

On i.MX6UL/ULL and i.MX6SX the DMA event id for the RX channel of
UART6 is '0'. To fix the broken DMA support for UART6, we change
the check for event_id0 to include '0' as a valid id.

Fixes: 1ec1e82f2510 ("dmaengine: Add Freescale i.MX SDMA support")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
---
Changes in v2:
  * Be more specific about the affected SoCs in the commit message
  * Fix the prefix in the subject to 'dmaengine'
  * Add Fabio's R-b tag
---
 drivers/dma/imx-sdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 066b21a32232..3d4aac97b1fc 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1331,7 +1331,7 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
 
 	sdma_channel_synchronize(chan);
 
-	if (sdmac->event_id0)
+	if (sdmac->event_id0 >= 0)
 		sdma_event_disable(sdmac, sdmac->event_id0);
 	if (sdmac->event_id1)
 		sdma_event_disable(sdmac, sdmac->event_id1);
@@ -1631,7 +1631,7 @@ static int sdma_config(struct dma_chan *chan,
 	memcpy(&sdmac->slave_config, dmaengine_cfg, sizeof(*dmaengine_cfg));
 
 	/* Set ENBLn earlier to make sure dma request triggered after that */
-	if (sdmac->event_id0) {
+	if (sdmac->event_id0 >= 0) {
 		if (sdmac->event_id0 >= sdmac->sdma->drvdata->num_events)
 			return -EINVAL;
 		sdma_event_enable(sdmac, sdmac->event_id0);
-- 
2.17.1
