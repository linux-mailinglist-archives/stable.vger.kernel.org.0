Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F434F3834
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376422AbiDELV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349433AbiDEJtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9244E24BD1;
        Tue,  5 Apr 2022 02:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D7AA61675;
        Tue,  5 Apr 2022 09:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DE1C385A2;
        Tue,  5 Apr 2022 09:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151945;
        bh=zPCGveBQgJIlDVIMeFHkX0aMMcRrkc0ZJmZXhkmwY1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fmoh3PC9MkzVVgVISbnNSsyTDV8g6RlMqccTT0cT0nBLqfa0WK9fNdMMmLuCBQ+8M
         pQ8YHjtZGJ3YRiiuYjYwxdlBeunIeRa6inmubpMZsULPGas/+PanBM+zHcBhSHTRjj
         aGCDiDhowCQnT1yEaNYuqZeado5DEgPOiP7tXpJU=
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
Subject: [PATCH 5.15 598/913] phy: dphy: Correct lpx parameter and its derivatives(ta_{get,go,sure})
Date:   Tue,  5 Apr 2022 09:27:40 +0200
Message-Id: <20220405070357.767344907@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index ccb4045685cd..929e86d6558e 100644
--- a/drivers/phy/phy-core-mipi-dphy.c
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -64,10 +64,10 @@ int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
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



