Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB0F59A131
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351162AbiHSQGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351474AbiHSQFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:05:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E3E10C82A;
        Fri, 19 Aug 2022 08:55:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA5E461776;
        Fri, 19 Aug 2022 15:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B47C433B5;
        Fri, 19 Aug 2022 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924509;
        bh=wt9KvOk5EEzuJmu2ClumGbvpW3ZLwgYX7P4Fdntpui8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMF2alBDlJeLSa9AFZuHL0f22943FgXlV6XHaORKCmi+DeQbiTy+poRb2vYtHm1vs
         B0pSlND68EcUb5FZGy705jjzYFoIp8ANxxbHeMrLCAw8cZCMi716S6l09pASpfhKJX
         B22VFqUu3rivy95zEYHE2RjU+g67hEWD8NbAV4W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/545] drm/vc4: dsi: Use snprintf for the PHY clocks instead of an array
Date:   Fri, 19 Aug 2022 17:39:24 +0200
Message-Id: <20220819153838.043508678@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit dc0bf36401e891c853e0a25baeb4e0b4e6f3626d ]

The DSI clocks setup function has been using an array to store the clock
name of either the DSI0 or DSI1 blocks, using the port ID to choose the
proper one.

Let's switch to an snprintf call to do the same thing and simplify the
array a bit.

Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201203132543.861591-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 6222e4058c85..80cd2599c57b 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1388,12 +1388,12 @@ vc4_dsi_init_phy_clocks(struct vc4_dsi *dsi)
 	struct device *dev = &dsi->pdev->dev;
 	const char *parent_name = __clk_get_name(dsi->pll_phy_clock);
 	static const struct {
-		const char *dsi0_name, *dsi1_name;
+		const char *name;
 		int div;
 	} phy_clocks[] = {
-		{ "dsi0_byte", "dsi1_byte", 8 },
-		{ "dsi0_ddr2", "dsi1_ddr2", 4 },
-		{ "dsi0_ddr", "dsi1_ddr", 2 },
+		{ "byte", 8 },
+		{ "ddr2", 4 },
+		{ "ddr", 2 },
 	};
 	int i;
 
@@ -1409,8 +1409,12 @@ vc4_dsi_init_phy_clocks(struct vc4_dsi *dsi)
 	for (i = 0; i < ARRAY_SIZE(phy_clocks); i++) {
 		struct clk_fixed_factor *fix = &dsi->phy_clocks[i];
 		struct clk_init_data init;
+		char clk_name[16];
 		int ret;
 
+		snprintf(clk_name, sizeof(clk_name),
+			 "dsi%u_%s", dsi->port, phy_clocks[i].name);
+
 		/* We just use core fixed factor clock ops for the PHY
 		 * clocks.  The clocks are actually gated by the
 		 * PHY_AFEC0_DDRCLK_EN bits, which we should be
@@ -1427,10 +1431,7 @@ vc4_dsi_init_phy_clocks(struct vc4_dsi *dsi)
 		memset(&init, 0, sizeof(init));
 		init.parent_names = &parent_name;
 		init.num_parents = 1;
-		if (dsi->port == 1)
-			init.name = phy_clocks[i].dsi1_name;
-		else
-			init.name = phy_clocks[i].dsi0_name;
+		init.name = clk_name;
 		init.ops = &clk_fixed_factor_ops;
 
 		ret = devm_clk_hw_register(dev, &fix->hw);
-- 
2.35.1



