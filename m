Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156CD4C48FB
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbiBYPcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiBYPcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:32:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBFF218CD9
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:31:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B96D61846
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C01EC340E7;
        Fri, 25 Feb 2022 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645803099;
        bh=aqj69JMGo6XKHfUNZ5XrbHA8iKz8tK9joywDtJjGZdY=;
        h=Subject:To:Cc:From:Date:From;
        b=qufDcuA/Lrb2pY0THmVRxRyreuSNpoljD9tKeaSrfedZOpjEBblrXEXfGXuWvWCSp
         s/b2qvDTMxHM4dqBn8IqXD3V8abM+r3hJG+gdwxFaogYg/xqonOuxB/3bU/s6mfmoi
         sVp9/zW8Co9yVB+bM2Xs5uUaeRNjt/3njlhmxQng=
Subject: FAILED: patch "[PATCH] net: mv643xx_eth: process retval from of_get_mac_address" failed to apply to 5.4-stable tree
To:     maukka@ext.kapsi.fi, andrew@lunn.ch, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:31:29 +0100
Message-ID: <164580308958176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42404d8f1c01861b22ccfa1d70f950242720ae57 Mon Sep 17 00:00:00 2001
From: Mauri Sandberg <maukka@ext.kapsi.fi>
Date: Wed, 23 Feb 2022 16:23:37 +0200
Subject: [PATCH] net: mv643xx_eth: process retval from of_get_mac_address

Obtaining a MAC address may be deferred in cases when the MAC is stored
in an NVMEM block, for example, and it may not be ready upon the first
retrieval attempt and return EPROBE_DEFER.

It is also possible that a port that does not rely on NVMEM has been
already created when getting the defer request. Thus, also the resources
allocated previously must be freed when doing a roll-back.

Fixes: 76723bca2802 ("net: mv643xx_eth: add DT parsing support")
Signed-off-by: Mauri Sandberg <maukka@ext.kapsi.fi>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220223142337.41757-1-maukka@ext.kapsi.fi
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 105247582684..143ca8be5eb5 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2704,6 +2704,16 @@ MODULE_DEVICE_TABLE(of, mv643xx_eth_shared_ids);
 
 static struct platform_device *port_platdev[3];
 
+static void mv643xx_eth_shared_of_remove(void)
+{
+	int n;
+
+	for (n = 0; n < 3; n++) {
+		platform_device_del(port_platdev[n]);
+		port_platdev[n] = NULL;
+	}
+}
+
 static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 					  struct device_node *pnp)
 {
@@ -2740,7 +2750,9 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	of_get_mac_address(pnp, ppd.mac_addr);
+	ret = of_get_mac_address(pnp, ppd.mac_addr);
+	if (ret)
+		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
 	mv643xx_eth_property(pnp, "tx-sram-addr", ppd.tx_sram_addr);
@@ -2804,21 +2816,13 @@ static int mv643xx_eth_shared_of_probe(struct platform_device *pdev)
 		ret = mv643xx_eth_shared_of_add_port(pdev, pnp);
 		if (ret) {
 			of_node_put(pnp);
+			mv643xx_eth_shared_of_remove();
 			return ret;
 		}
 	}
 	return 0;
 }
 
-static void mv643xx_eth_shared_of_remove(void)
-{
-	int n;
-
-	for (n = 0; n < 3; n++) {
-		platform_device_del(port_platdev[n]);
-		port_platdev[n] = NULL;
-	}
-}
 #else
 static inline int mv643xx_eth_shared_of_probe(struct platform_device *pdev)
 {

