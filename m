Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB76582EE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiL1QnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiL1Qm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:42:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76D01F9DE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53BF4B81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E7AC433D2;
        Wed, 28 Dec 2022 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245420;
        bh=ycJSdmVsD2NsqhaOtsUZjC5inYto8Cl7HedkvgHN6Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T45F8PVioYRxdEv7cxXkQT41lr1Ni7UIjCbBwG+vBkkxLtMVh/BW2+zi6dOh9nENQ
         N90vWeiBz91Atjj0PUHtMRMhOn1NwTl0VS+eVJDmQ+c91IjlB9OcL+BRpc0o6xiFwo
         EGZbZFoLo/u2JYKnSV4mMmVd1wiEvHAyWPBC59Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0819/1146] phy: usb: Fix clock imbalance for suspend/resume
Date:   Wed, 28 Dec 2022 15:39:18 +0100
Message-Id: <20221228144352.401411679@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit 8484199c09347bdd5d81ee8a2bc530850f900797 ]

We should be disabling clocks when wake from USB is not needed. Since
this wasn't done, we had a clock imbalance since clocks were always
being enabled on resume.

Fixes: ae532b2b7aa5 ("phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers")
Fixes: b0c0b66c0b43 ("phy: usb: Add support for wake and USB low power mode for 7211 S2/S5")
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/1665005418-15807-7-git-send-email-justinpopo6@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c | 2 --
 drivers/phy/broadcom/phy-brcm-usb-init.h          | 1 -
 drivers/phy/broadcom/phy-brcm-usb.c               | 8 +++++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
index b3386e458dd4..3b374b37b965 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -424,7 +424,6 @@ void brcm_usb_dvr_init_7216(struct brcm_usb_init_params *params)
 
 	params->family_name = "7216";
 	params->ops = &bcm7216_ops;
-	params->suspend_with_clocks = true;
 }
 
 void brcm_usb_dvr_init_7211b0(struct brcm_usb_init_params *params)
@@ -434,5 +433,4 @@ void brcm_usb_dvr_init_7211b0(struct brcm_usb_init_params *params)
 
 	params->family_name = "7211";
 	params->ops = &bcm7211b0_ops;
-	params->suspend_with_clocks = true;
 }
diff --git a/drivers/phy/broadcom/phy-brcm-usb-init.h b/drivers/phy/broadcom/phy-brcm-usb-init.h
index 1ccb5ddab865..3236e9498842 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init.h
+++ b/drivers/phy/broadcom/phy-brcm-usb-init.h
@@ -61,7 +61,6 @@ struct  brcm_usb_init_params {
 	const struct brcm_usb_init_ops *ops;
 	struct regmap *syscon_piarbctl;
 	bool wake_enabled;
-	bool suspend_with_clocks;
 };
 
 void brcm_usb_dvr_init_4908(struct brcm_usb_init_params *params);
diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index c0c3ab9b2a15..2bfd78e2d8fd 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -598,7 +598,7 @@ static int brcm_usb_phy_suspend(struct device *dev)
 		 * and newer XHCI->2.0-clks/3.0-clks.
 		 */
 
-		if (!priv->ini.suspend_with_clocks) {
+		if (!priv->ini.wake_enabled) {
 			if (priv->phys[BRCM_USB_PHY_3_0].inited)
 				clk_disable_unprepare(priv->usb_30_clk);
 			if (priv->phys[BRCM_USB_PHY_2_0].inited ||
@@ -615,8 +615,10 @@ static int brcm_usb_phy_resume(struct device *dev)
 {
 	struct brcm_usb_phy_data *priv = dev_get_drvdata(dev);
 
-	clk_prepare_enable(priv->usb_20_clk);
-	clk_prepare_enable(priv->usb_30_clk);
+	if (!priv->ini.wake_enabled) {
+		clk_prepare_enable(priv->usb_20_clk);
+		clk_prepare_enable(priv->usb_30_clk);
+	}
 	brcm_usb_init_ipp(&priv->ini);
 
 	/*
-- 
2.35.1



