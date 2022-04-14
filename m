Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3C2501458
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345316AbiDNNxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344945AbiDNNo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690D71FCFD;
        Thu, 14 Apr 2022 06:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E03E161D73;
        Thu, 14 Apr 2022 13:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA9CC385A1;
        Thu, 14 Apr 2022 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943651;
        bh=jdRZxhGVBh24b1pO4PjXneg0iSK34WICAWHCxcRCZRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bc6ZzLZCORjgg8OGasTrJaPawHQUBxct6UFv5HyOR+UmTHWHGpUqxQzTeCBmZy03I
         cFy0b+nAvzqY/433/arDznxZAKLQmiWk72/Wd8YY/J+PuhuTKAM+bHw2UHk74QYxm8
         GzSJ+dILXdwdmlGdxgRemV9s2TmbE2jWcg0vHFUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Maxime Ripard <mripard@kernel.org>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 233/475] phy: dphy: Correct lpx parameter and its derivatives(ta_{get,go,sure})
Date:   Thu, 14 Apr 2022 15:10:18 +0200
Message-Id: <20220414110901.643180267@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 3153fa38e38af566cf6454a03b1dbadaf6f323c0 ]

According to the comment of the function phy_mipi_dphy_get_default_config(),
it uses minimum D-PHY timings based on MIPI D-PHY specification.  They are
derived from the valid ranges specified in Section 6.9, Table 14, Page 41
of the D-PHY specification (v1.2).  The table 14 explicitly mentions that
the minimum T-LPX parameter is 50 nanoseconds and the minimum TA-SURE
parameter is T-LPX nanoseconds.  Likewise, the kernel doc of the 'lpx' and
'ta_sure' members of struct phy_configure_opts_mipi_dphy mentions that
the minimum values are 50000 picoseconds and @lpx picoseconds respectively.
Also, the function phy_mipi_dphy_config_validate() checks if cfg->lpx is
less than 50000 picoseconds and if cfg->ta_sure is less than cfg->lpx,
which hints the same minimum values.

Without this patch, the function phy_mipi_dphy_get_default_config()
wrongly sets cfg->lpx to 60000 picoseconds and cfg->ta_sure to 2 * cfg->lpx.
So, let's correct them to 50000 picoseconds and cfg->lpx respectively.

Note that I've only tested the patch with RM67191 DSI panel on i.MX8mq EVK.
Help is needed to test with other i.MX8mq, Meson and Rockchip platforms,
as I don't have the hardwares.

Fixes: dddc97e82303 ("phy: dphy: Add configuration helpers")
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Link: https://lore.kernel.org/r/20220216071257.1647703-1-victor.liu@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-core-mipi-dphy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
index 14e0551cd319..0aa740b73d0d 100644
--- a/drivers/phy/phy-core-mipi-dphy.c
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -66,10 +66,10 @@ int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
 	cfg->hs_trail = max(4 * 8 * ui, 60000 + 4 * 4 * ui);
 
 	cfg->init = 100;
-	cfg->lpx = 60000;
+	cfg->lpx = 50000;
 	cfg->ta_get = 5 * cfg->lpx;
 	cfg->ta_go = 4 * cfg->lpx;
-	cfg->ta_sure = 2 * cfg->lpx;
+	cfg->ta_sure = cfg->lpx;
 	cfg->wakeup = 1000;
 
 	cfg->hs_clk_rate = hs_clk_rate;
-- 
2.34.1



