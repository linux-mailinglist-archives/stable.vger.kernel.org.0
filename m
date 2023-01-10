Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3866490A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239135AbjAJSRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbjAJSQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8137AD5D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:15:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC0016182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DB6C433EF;
        Tue, 10 Jan 2023 18:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374504;
        bh=cnZlEloloM0ArrjYXpSXD8jMSDXQ6W0bZNsO3rFj+bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ac0hpftLm1yvTy7eZfdibdReBVQpL9hcDeQy4ZIpwCbezzPt/UJ7R7d5H38OHGvAC
         rZl3iM4dTkJxQ42VDRnPqt1G1fzzYvPZQW/zPyAJMlwMZw+Q6obDBCkPmJk+mkMh2i
         vSSWS7KRNuA/OWaJwxlCp9qVk2xsiu1NqPM23hig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/159] net: lan966x: Fix configuration of the PCS
Date:   Tue, 10 Jan 2023 19:02:54 +0100
Message-Id: <20230110180019.141577123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit d717f9474e3fb7e6bd3e43ca16e131f04320ed6f ]

When the PCS was taken out of reset, we were changing by mistake also
the speed to 100 Mbit. But in case the link was going down, the link
up routine was setting correctly the link speed. If the link was not
getting down then the speed was forced to run at 100 even if the
speed was something else.
On lan966x, to set the speed link to 1G or 2.5G a value of 1 needs to be
written in DEV_CLOCK_CFG_LINK_SPEED. This is similar to the procedure in
lan966x_port_init.

The issue was reproduced using 1000base-x sfp module using the commands:
ip link set dev eth2 up
ip link addr add 10.97.10.2/24 dev eth2
ethtool -s eth2 speed 1000 autoneg off

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Link: https://lore.kernel.org/r/20221221093315.939133-1-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 1a61c6cdb077..0050fcb988b7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -381,7 +381,7 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 	}
 
 	/* Take PCS out of reset */
-	lan_rmw(DEV_CLOCK_CFG_LINK_SPEED_SET(2) |
+	lan_rmw(DEV_CLOCK_CFG_LINK_SPEED_SET(LAN966X_SPEED_1000) |
 		DEV_CLOCK_CFG_PCS_RX_RST_SET(0) |
 		DEV_CLOCK_CFG_PCS_TX_RST_SET(0),
 		DEV_CLOCK_CFG_LINK_SPEED |
-- 
2.35.1



