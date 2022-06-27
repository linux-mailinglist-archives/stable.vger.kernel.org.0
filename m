Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CF255CB64
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbiF0Ltb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238373AbiF0LsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91856FD26;
        Mon, 27 Jun 2022 04:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2545F611B8;
        Mon, 27 Jun 2022 11:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354A7C36AE2;
        Mon, 27 Jun 2022 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330057;
        bh=rtkociItVY4GySdFeYnZVICr5i00ah2LEMi002RbqO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnRCI6fMtiw2tiT3Pyj6w++XBn2nTP9HeT8mlFqXGz/VyXI7wj9L2rnPaZIutl+tn
         80Ub27oV/fkQ6KTJqJKdDXBE4t4i1eb1smNCPuj3eG4gktUTsyzBcXAJED3k0cmP+N
         6EdwkC+6xgp/d8kxLHn+gSvs5r9/XS2QoRJgiD0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 069/181] net: phy: at803x: fix NULL pointer dereference on AR9331 PHY
Date:   Mon, 27 Jun 2022 13:20:42 +0200
Message-Id: <20220627111946.565417165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 9926de7315be3d606cc011a305ad9adb9e8e14c9 ]

Latest kernel will explode on the PHY interrupt config, since it depends
now on allocated priv. So, run probe to allocate priv to fix it.

 ar9331_switch ethernet.1:10 lan0 (uninitialized): PHY [!ahb!ethernet@1a000000!mdio!switch@10:00] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
 CPU 0 Unable to handle kernel paging request at virtual address 0000000a, epc == 8050e8a8, ra == 80504b34
         ...
 Call Trace:
 [<8050e8a8>] at803x_config_intr+0x5c/0xd0
 [<80504b34>] phy_request_interrupt+0xa8/0xd0
 [<8050289c>] phylink_bringup_phy+0x2d8/0x3ac
 [<80502b68>] phylink_fwnode_phy_connect+0x118/0x130
 [<8074d8ec>] dsa_slave_create+0x270/0x420
 [<80743b04>] dsa_port_setup+0x12c/0x148
 [<8074580c>] dsa_register_switch+0xaf0/0xcc0
 [<80511344>] ar9331_sw_probe+0x370/0x388
 [<8050cb78>] mdio_probe+0x44/0x70
 [<804df300>] really_probe+0x200/0x424
 [<804df7b4>] __driver_probe_device+0x290/0x298
 [<804df810>] driver_probe_device+0x54/0xe4
 [<804dfd50>] __device_attach_driver+0xe4/0x130
 [<804dcb00>] bus_for_each_drv+0xb4/0xd8
 [<804dfac4>] __device_attach+0x104/0x1a4
 [<804ddd24>] bus_probe_device+0x48/0xc4
 [<804deb44>] deferred_probe_work_func+0xf0/0x10c
 [<800a0ffc>] process_one_work+0x314/0x4d4
 [<800a17fc>] worker_thread+0x2a4/0x354
 [<800a9a54>] kthread+0x134/0x13c
 [<8006306c>] ret_from_kernel_thread+0x14/0x1c

Same Issue would affect some other PHYs (QCA8081, QCA9561), so fix it
too.

Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 6a467e7817a6..59fe356942b5 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2072,6 +2072,8 @@ static struct phy_driver at803x_driver[] = {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
 	.name			= "Qualcomm Atheros AR9331 built-in PHY",
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
@@ -2087,6 +2089,8 @@ static struct phy_driver at803x_driver[] = {
 	/* Qualcomm Atheros QCA9561 */
 	PHY_ID_MATCH_EXACT(QCA9561_PHY_ID),
 	.name			= "Qualcomm Atheros QCA9561 built-in PHY",
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
@@ -2151,6 +2155,8 @@ static struct phy_driver at803x_driver[] = {
 	PHY_ID_MATCH_EXACT(QCA8081_PHY_ID),
 	.name			= "Qualcomm QCA8081",
 	.flags			= PHY_POLL_CABLE_TEST,
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
-- 
2.35.1



