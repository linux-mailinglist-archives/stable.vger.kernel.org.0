Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4886864A1A0
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiLLNno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiLLNnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B0814028
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C819B80D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F9C433EF;
        Mon, 12 Dec 2022 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852532;
        bh=s0LUIJvPpkur9LY6RxVIboEMBRomuSPgB+BetF6F2XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHzGtm6OiS+iuo6ABX3o2awi3O7EKrYfKBGnEcY7GbEnjBxPzrYC+76tSAeEhKQnK
         tXm6r3MusCLJPfSlUSgi0Cd2DPge2dSYgpU8hNw5bzy4MIbTIbEuDjvGk+boaYoDn7
         zVAIw9YhYlMynv5IvjTy9ur+0W7YT9YK5nIkOLZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Schuyler Patton <spatton@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 100/157] net: ethernet: ti: am65-cpsw: Fix RGMII configuration at SPEED_10
Date:   Mon, 12 Dec 2022 14:17:28 +0100
Message-Id: <20221212130938.850463482@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 6c681f899e0360803b924ac8c96ee21965118649 ]

The am65-cpsw driver supports configuring all RGMII variants at interface
speed of 10 Mbps. However, in the process of shifting to the PHYLINK
framework, the support for all variants of RGMII except the
PHY_INTERFACE_MODE_RGMII variant was accidentally removed.

Fix this by using phy_interface_mode_is_rgmii() to check for all variants
of RGMII mode.

Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Reported-by: Schuyler Patton <spatton@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20221129050639.111142-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 95baacd6c761..47da11b9ac28 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1450,7 +1450,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 
 	if (speed == SPEED_1000)
 		mac_control |= CPSW_SL_CTL_GIG;
-	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
+	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
 		/* Can be used with in band mode only */
 		mac_control |= CPSW_SL_CTL_EXT_EN;
 	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
-- 
2.35.1



