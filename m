Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94E0522F7A
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbiEKJe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbiEKJe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:34:58 -0400
Received: from vsp-unauthed02.binero.net (vsp-unauthed02.binero.net [195.74.38.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D015D233A6F
        for <stable@vger.kernel.org>; Wed, 11 May 2022 02:34:56 -0700 (PDT)
X-Halon-ID: 9ae4119c-d10d-11ec-9628-0050569116f7
Authorized-sender: andreas@gaisler.com
Received: from andreas.got.gaisler.com (h-98-128-223-123.na.cust.bahnhof.se [98.128.223.123])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 9ae4119c-d10d-11ec-9628-0050569116f7;
        Wed, 11 May 2022 11:34:54 +0200 (CEST)
From:   Andreas Larsson <andreas@gaisler.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 1/2] can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
Date:   Wed, 11 May 2022 11:34:47 +0200
Message-Id: <20220511093448.14058-1-andreas@gaisler.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

backport of commit 1e93ed26acf03fe6c97c6d573a10178596aadd43 upstream.

The systemid property was checked for in the wrong place of the device
tree and compared to the wrong value.

Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
Link: https://lore.kernel.org/all/20220429084656.29788-3-andreas@gaisler.com
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/grcan.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index a2dbd7ae9db2..e126516ba648 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -245,7 +245,7 @@ struct grcan_device_config {
 		.rxsize		= GRCAN_DEFAULT_BUFFER_SIZE,	\
 		}
 
-#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	0x4100
+#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	4100
 #define GRLIB_VERSION_MASK		0xffff
 
 /* GRCAN private data structure */
@@ -1665,6 +1665,7 @@ static int grcan_setup_netdev(struct platform_device *ofdev,
 static int grcan_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
+	struct device_node *sysid_parent;
 	struct resource *res;
 	u32 sysid, ambafreq;
 	int irq, err;
@@ -1674,10 +1675,15 @@ static int grcan_probe(struct platform_device *ofdev)
 	/* Compare GRLIB version number with the first that does not
 	 * have the tx bug (see start_xmit)
 	 */
-	err = of_property_read_u32(np, "systemid", &sysid);
-	if (!err && ((sysid & GRLIB_VERSION_MASK)
-		     >= GRCAN_TXBUG_SAFE_GRLIB_VERSION))
-		txbug = false;
+	sysid_parent = of_find_node_by_path("/ambapp0");
+	if (sysid_parent) {
+		of_node_get(sysid_parent);
+		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
+		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
+			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
+			txbug = false;
+		of_node_put(sysid_parent);
+	}
 
 	err = of_property_read_u32(np, "freq", &ambafreq);
 	if (err) {
-- 
2.17.1

