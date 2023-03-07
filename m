Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BD86AEECC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjCGSQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbjCGSQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:16:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E28AFBAF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE301B81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B83C433D2;
        Tue,  7 Mar 2023 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212665;
        bh=SvgJwTMq25TXgKoaDTs0u6hC9Qev2eNdT1dXSWByrdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ngh2x41R1/LOddxh7rwGbKhy2xtKcJhhDrD6PXhlRDgpKIU6vE+NcEpoGsPLKliHz
         PWI3D/brZaUZB2uIxaFfjAatgeKsCA2Mx3slNZc8wIqy4OYDr5+nG5RnV3zJ5kzLh4
         oF+CfO83pkG3+Ad7BwfNUUpfC8G0UjKdgfyBvWvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/885] net: bcmgenet: fix MoCA LED control
Date:   Tue,  7 Mar 2023 17:53:12 +0100
Message-Id: <20230307170013.208523863@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit a7515af9fb8f0890fe540b108def4a86b9e8330a ]

When the bcmgenet_mii_config() code was refactored it was missed
that the LED control for the MoCA interface got overwritten by
the port_ctrl value. Its previous programming is restored here.

Fixes: 4f8d81b77e66 ("net: bcmgenet: Refactor register access in bcmgenet_mii_config")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 7ded559842e83..ded0e64a9f6a1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -169,15 +169,6 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 
 static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 {
-	u32 reg;
-
-	if (!GENET_IS_V5(priv)) {
-		/* Speed settings are set in bcmgenet_mii_setup() */
-		reg = bcmgenet_sys_readl(priv, SYS_PORT_CTRL);
-		reg |= LED_ACT_SOURCE_MAC;
-		bcmgenet_sys_writel(priv, reg, SYS_PORT_CTRL);
-	}
-
 	if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
 		fixed_phy_set_link_update(priv->dev->phydev,
 					  bcmgenet_fixed_phy_link_update);
@@ -210,6 +201,8 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 
 		if (!phy_name) {
 			phy_name = "MoCA";
+			if (!GENET_IS_V5(priv))
+				port_ctrl |= LED_ACT_SOURCE_MAC;
 			bcmgenet_moca_phy_setup(priv);
 		}
 		break;
-- 
2.39.2



