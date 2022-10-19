Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEEB6041C1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiJSKsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiJSKqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09E215A32C;
        Wed, 19 Oct 2022 03:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3297FB8245F;
        Wed, 19 Oct 2022 09:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91372C433C1;
        Wed, 19 Oct 2022 09:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170045;
        bh=ARqMNczG9AC7cTclunG4sGzC2KLFxA0jYdI0tZNSQo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kN4LESQPz9uxwFljqq1zsC9Rqv2DUWjGn8+HBuDSqkf74J6gi3aPimzKC3+hDZZtk
         7nQrIqOl5ud9C6EEOXo2kW4qNaiiXD5K4V0Uc6xuYn/6dCirqIgMv4eYCt0a4D+Xls
         dwDZRjJ1xk8G4Q/MjkZ+SQnYpBUQrtynwZImKCSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Reichl <m.reichl@fivetechno.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Peter Geis <pgwipeout@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 506/862] phy: rockchip-inno-usb2: Return zero after otg sync
Date:   Wed, 19 Oct 2022 10:29:53 +0200
Message-Id: <20221019083312.345036441@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
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
index 0b1e9337ee8e..e6ededc51523 100644
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



