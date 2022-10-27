Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A600B60FE96
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbiJ0RGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbiJ0RGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:06:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4346619846B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F43623F4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3075C433C1;
        Thu, 27 Oct 2022 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890393;
        bh=1ietTuvYT7MIXV3lAYE65GkR/JyalumTigwboTm5b5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWD/G/bfFFzr9A9HrMkmMVxIkW/IY87hmZK7SUY7w/oXx0vNta/FHNbRn9V/5ODM9
         UdiMFvR9aWpXmvNnWBUp9orHi8O0bKn+rxG9Pqw4UfzZEM3wo+LCUt3h7w8DblLuxr
         QAB9crh2GRRw3h7ahr5MHlyMARz4WZUC57kjeGg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Riemann <felix.riemann@sma.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/79] net: phy: dp83822: disable MDI crossover status change interrupt
Date:   Thu, 27 Oct 2022 18:56:02 +0200
Message-Id: <20221027165056.093050287@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Riemann <felix.riemann@sma.de>

[ Upstream commit 7f378c03aa4952507521174fb0da7b24a9ad0be6 ]

If the cable is disconnected the PHY seems to toggle between MDI and
MDI-X modes. With the MDI crossover status interrupt active this causes
roughly 10 interrupts per second.

As the crossover status isn't checked by the driver, the interrupt can
be disabled to reduce the interrupt load.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Felix Riemann <felix.riemann@sma.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221018104755.30025-1-svc.sw.rte.linux@sma.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 3a8849716459..db651649e0b8 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -268,8 +268,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
 		if (!dp83822->fx_enabled)
-			misr_status |= DP83822_MDI_XOVER_INT_EN |
-				       DP83822_ANEG_ERR_INT_EN |
+			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
 		err = phy_write(phydev, MII_DP83822_MISR2, misr_status);
-- 
2.35.1



