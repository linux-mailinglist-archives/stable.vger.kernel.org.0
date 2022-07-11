Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748A256FB0E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiGKJZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiGKJYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A6529822;
        Mon, 11 Jul 2022 02:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAA54B80D2C;
        Mon, 11 Jul 2022 09:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBABC36AEB;
        Mon, 11 Jul 2022 09:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530889;
        bh=404RDpCX/R8w6TAuufcmeta5kQhm/fqKDMIEIfueZ68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRFRelNDBAUV1HJrUqnLdB6C63PCqbUa2C6gIqK1eTETL/wiQXwYxbqUoMIv1JdAo
         VV3sADs1ETEyFi06tu2DxDRr6kZwjkWLF+CThe6fr8rK/Z7OOi2kzs3nV53+5vrWQF
         ZyYIK9NKhcldrPQOBmfN6jDdlkuall6d9+1w/LRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 020/112] net: lan966x: hardcode the number of external ports
Date:   Mon, 11 Jul 2022 11:06:20 +0200
Message-Id: <20220711090550.133256899@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Michael Walle <michael@walle.cc>

commit e6fa930f73a15238f3cb0c204e2f786c919b815c upstream.

Instead of counting the child nodes in the device tree, hardcode the
number of ports in the driver itself.  The counting won't work at all
if an ethernet port is marked as disabled, e.g. because it is not
connected on the board at all.

It turns out that the LAN9662 and LAN9668 use the same switching IP
with the same synthesis parameters. The only difference is that the
output ports are not connected. Thus, we can just hardcode the
number of physical ports to 8.

Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220704153654.1167886-1-michael@walle.cc
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c |    8 ++------
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h |    1 +
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -979,7 +979,7 @@ static int lan966x_probe(struct platform
 	struct fwnode_handle *ports, *portnp;
 	struct lan966x *lan966x;
 	u8 mac_addr[ETH_ALEN];
-	int err, i;
+	int err;
 
 	lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
 	if (!lan966x)
@@ -1010,11 +1010,7 @@ static int lan966x_probe(struct platform
 	if (err)
 		return dev_err_probe(&pdev->dev, err, "Reset failed");
 
-	i = 0;
-	fwnode_for_each_available_child_node(ports, portnp)
-		++i;
-
-	lan966x->num_phys_ports = i;
+	lan966x->num_phys_ports = NUM_PHYS_PORTS;
 	lan966x->ports = devm_kcalloc(&pdev->dev, lan966x->num_phys_ports,
 				      sizeof(struct lan966x_port *),
 				      GFP_KERNEL);
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -31,6 +31,7 @@
 /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
 #define QSYS_Q_RSRV			95
 
+#define NUM_PHYS_PORTS			8
 #define CPU_PORT			8
 
 /* Reserved PGIDs */


