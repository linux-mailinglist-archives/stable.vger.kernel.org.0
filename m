Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA60B60FDE7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbiJ0RAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbiJ0RAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A557C7CE2E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 621A5B82716
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0099C433D6;
        Thu, 27 Oct 2022 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890012;
        bh=KGEWOrxp/OLpYQphNT1WyMb0ti+8gG8rUcQH663VMA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SU+ZCke4U2lVZ776xMkyGenkaiM5QXe3VjlVERYDJP+2XmuWh8ENXi0HuRT7VlpyQ
         tq5k+VkdC9QSHwsytlwUiYjN3Wv9M9hUtrKasTnfkjQbmlsk/BnZb7SUw7YJyes/VL
         PaGUl9J158vakkFhyLqdI5s2DvDa9xT+BEszw8LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Riemann <felix.riemann@sma.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 83/94] net: phy: dp83822: disable MDI crossover status change interrupt
Date:   Thu, 27 Oct 2022 18:55:25 +0200
Message-Id: <20221027165100.549100979@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 8549e0e356c9..b60db8b6f477 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -254,8 +254,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
 		if (!dp83822->fx_enabled)
-			misr_status |= DP83822_MDI_XOVER_INT_EN |
-				       DP83822_ANEG_ERR_INT_EN |
+			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
 		err = phy_write(phydev, MII_DP83822_MISR2, misr_status);
-- 
2.35.1



