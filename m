Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DA59D3D5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbiHWIRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242964AbiHWIQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33E54E614;
        Tue, 23 Aug 2022 01:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D776128D;
        Tue, 23 Aug 2022 08:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3AC433D6;
        Tue, 23 Aug 2022 08:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242249;
        bh=6mxxRCHil7BriKiwGC+xNzPurzC8Acc2JNZN7S7i1AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCshTyijpqwKWMynlTsGF4J797lGsK3Uq+lS1CTIHKZF3VNHozpP0ln7ev+nkn/vQ
         UN4AQVp3aR2lwEmJgucFi1kbzCXHkOsmi7ciktnkqgtfR6+iBKqa4qx7ZQpGVxTJ+j
         WFeAt7DI0kTEJbIEBsnfPqMrS9hn5DqsP/6QzmsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 083/365] net: bcmgenet: Indicate MAC is in charge of PHY PM
Date:   Tue, 23 Aug 2022 09:59:44 +0200
Message-Id: <20220823080121.665495529@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Florian Fainelli <f.fainelli@gmail.com>

commit bc3410f250219660a7be032c01c954a53b2c26ab upstream.

Avoid the PHY library call unnecessarily into the suspend/resume functions by
setting phydev->mac_managed_pm to true. The GENET driver essentially does
exactly what mdio_bus_phy_resume() does by calling phy_init_hw() plus
phy_resume().

Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220804173605.1266574-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -393,6 +393,9 @@ int bcmgenet_mii_probe(struct net_device
 	if (priv->internal_phy && !GENET_IS_V5(priv))
 		dev->phydev->irq = PHY_MAC_INTERRUPT;
 
+	/* Indicate that the MAC is responsible for PHY PM */
+	dev->phydev->mac_managed_pm = true;
+
 	return 0;
 }
 


