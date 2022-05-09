Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BFC51F977
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiEIKQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiEIKQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:16:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3614F1666B4
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D842E60A50
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55BDC385AB;
        Mon,  9 May 2022 10:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652090929;
        bh=W7E6IcTXyyUFdkvzjnC+FJ4Dr2nLK52+LnI4DNjGn0g=;
        h=Subject:To:Cc:From:Date:From;
        b=IlmOR+nuM1sEleLqlv5SUboN4w+jy5osP+h8cAd2FY9D963u5pTCo6XSxiujTPOww
         dqZtNt7dNXvOY/O4D3+nqaaA4PMzTM7u3q2rBOLaSCb69r+Xtp+Sortqkk7pAp1qDn
         nK77hA2Li18Orp7qbMYb79mBqMij8LyrKHd318/g=
Subject: FAILED: patch "[PATCH] can: grcan: grcan_probe(): fix broken system id check for" failed to apply to 4.19-stable tree
To:     andreas@gaisler.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:08:38 +0200
Message-ID: <16520909181192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1e93ed26acf03fe6c97c6d573a10178596aadd43 Mon Sep 17 00:00:00 2001
From: Andreas Larsson <andreas@gaisler.com>
Date: Fri, 29 Apr 2022 10:46:55 +0200
Subject: [PATCH] can: grcan: grcan_probe(): fix broken system id check for
 errata workaround needs

The systemid property was checked for in the wrong place of the device
tree and compared to the wrong value.

Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
Link: https://lore.kernel.org/all/20220429084656.29788-3-andreas@gaisler.com
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index f8860900575b..4ca3da56d3aa 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -241,7 +241,7 @@ struct grcan_device_config {
 		.rxsize		= GRCAN_DEFAULT_BUFFER_SIZE,	\
 		}
 
-#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	0x4100
+#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	4100
 #define GRLIB_VERSION_MASK		0xffff
 
 /* GRCAN private data structure */
@@ -1643,6 +1643,7 @@ static int grcan_setup_netdev(struct platform_device *ofdev,
 static int grcan_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
+	struct device_node *sysid_parent;
 	u32 sysid, ambafreq;
 	int irq, err;
 	void __iomem *base;
@@ -1651,10 +1652,15 @@ static int grcan_probe(struct platform_device *ofdev)
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

