Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F263608BAB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiJVKcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiJVKcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C423235CD;
        Sat, 22 Oct 2022 02:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A85860B0A;
        Sat, 22 Oct 2022 07:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C68C433C1;
        Sat, 22 Oct 2022 07:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425163;
        bh=PiM5G2FI8VQ/X/sDFT0sCf2uTCLjmCF8dIB0FZuzEo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUjxoYZx//+22+ogmrr6XIvUsLbZiLwcYiTnxVySCHvi8zEG8lm+BePoWbnpuxoS8
         q3bVo0jjIZP8rt9cAEKF6I7n+9BfyWX0afcbW0dumKQ36P1eHFjISjmmEKpv7dy2d1
         OiZn/NwPSWDkst5x79ujM2WUUOiTLBLIVzRGRbLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Reichl <m.reichl@fivetechno.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Peter Geis <pgwipeout@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 411/717] phy: rockchip-inno-usb2: Return zero after otg sync
Date:   Sat, 22 Oct 2022 09:24:50 +0200
Message-Id: <20221022072516.272003002@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit f340ed8664a55a467850ec1689996e63d9ee971a ]

The otg sync state patch reuses the ret variable, but fails to set it to
zero after use. This leads to a situation when the otg port is in
peripheral mode where the otg phy aborts halfway through setup.  It also
fails to account for a failure to register the extcon notifier. Fix this
by using our own variable and skipping otg sync in case of failure.

Fixes: 8dc60f8da22f ("phy: rockchip-inno-usb2: Sync initial otg state")
Reported-by: Markus Reichl <m.reichl@fivetechno.de>
Reported-by: Michael Riesch <michael.riesch@wolfvision.net>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Tested-by: Michael Riesch <michael.riesch@wolfvision.net>
Tested-by: Markus Reichl <m.reichl@fivetechno.de>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20220902184543.1234835-1-pgwipeout@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index 5223d4c9afdf..39f14a5b78cd 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -1124,7 +1124,7 @@ static int rockchip_usb2phy_otg_port_init(struct rockchip_usb2phy *rphy,
 					  struct rockchip_usb2phy_port *rport,
 					  struct device_node *child_np)
 {
-	int ret;
+	int ret, id;
 
 	rport->port_id = USB2PHY_PORT_OTG;
 	rport->port_cfg = &rphy->phy_cfg->port_cfgs[USB2PHY_PORT_OTG];
@@ -1162,13 +1162,15 @@ static int rockchip_usb2phy_otg_port_init(struct rockchip_usb2phy *rphy,
 
 		ret = devm_extcon_register_notifier(rphy->dev, rphy->edev,
 					EXTCON_USB_HOST, &rport->event_nb);
-		if (ret)
+		if (ret) {
 			dev_err(rphy->dev, "register USB HOST notifier failed\n");
+			goto out;
+		}
 
 		if (!of_property_read_bool(rphy->dev->of_node, "extcon")) {
 			/* do initial sync of usb state */
-			ret = property_enabled(rphy->grf, &rport->port_cfg->utmi_id);
-			extcon_set_state_sync(rphy->edev, EXTCON_USB_HOST, !ret);
+			id = property_enabled(rphy->grf, &rport->port_cfg->utmi_id);
+			extcon_set_state_sync(rphy->edev, EXTCON_USB_HOST, !id);
 		}
 	}
 
-- 
2.35.1



