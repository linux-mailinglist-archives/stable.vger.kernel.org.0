Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B704C74F0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiB1RtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239121AbiB1RsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:48:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8075FA1474;
        Mon, 28 Feb 2022 09:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24126B815B3;
        Mon, 28 Feb 2022 17:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A228C340F3;
        Mon, 28 Feb 2022 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069918;
        bh=e9qSJssGN+HZrIwdyr6Y6yzckhlwCSUpu93cFoY6+y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoSHnDFNY521Tt/Fl1UcIF0ypQrdo5TKElOh5rUTebQefmIdoseG5G0TM7z9nv2Qo
         SCzz1IZc3SFj1be15MVcL4R9Og6OdAVCWLTP0VZmRmX90FfWWb3qJnmYYTHxvnRog8
         eqKCc2WSPfUPzVMcLc+LR9emJlXhKI2v19UxNgi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauri Sandberg <maukka@ext.kapsi.fi>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 060/139] net: mv643xx_eth: process retval from of_get_mac_address
Date:   Mon, 28 Feb 2022 18:23:54 +0100
Message-Id: <20220228172354.001537175@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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

From: Mauri Sandberg <maukka@ext.kapsi.fi>

commit 42404d8f1c01861b22ccfa1d70f950242720ae57 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2700,6 +2700,16 @@ MODULE_DEVICE_TABLE(of, mv643xx_eth_shar
 
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
@@ -2736,7 +2746,9 @@ static int mv643xx_eth_shared_of_add_por
 		return -EINVAL;
 	}
 
-	of_get_mac_address(pnp, ppd.mac_addr);
+	ret = of_get_mac_address(pnp, ppd.mac_addr);
+	if (ret)
+		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
 	mv643xx_eth_property(pnp, "tx-sram-addr", ppd.tx_sram_addr);
@@ -2800,21 +2812,13 @@ static int mv643xx_eth_shared_of_probe(s
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


