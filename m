Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EA8694909
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjBMOze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjBMOzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:55:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB88CD516
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5617C6106F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDB0C4339E;
        Mon, 13 Feb 2023 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300116;
        bh=zyH6RDb6wPrM7rYOPNOx0UwGdwwUlSWPxzB6iMPQHQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+LooCL+7RMknomwuek6W423y9MohxeUkaTgxIvSscELCIV6uNWF60eHtdchAhR/d
         oJ1syxTbK0ZDyJwaSCBt7XGPUdVnPjvgfUiwO3Z9SfHdhWomyCD4oLKXePXlaDRPF4
         nwevuUztmBvaPM2OoXvzjYF8kWPF3UtbAYL/wD78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Conor Dooley <conor.dooley@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/114] clk: microchip: mpfs-ccc: Use devm_kasprintf() for allocating formatted strings
Date:   Mon, 13 Feb 2023 15:48:25 +0100
Message-Id: <20230213144745.832051751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 86d884f5287f4369c198811aaa4931a3a11f36d2 ]

In various places, string buffers of a fixed size are allocated, and
filled using snprintf() with the same fixed size, which is error-prone.

Replace this by calling devm_kasprintf() instead, which always uses the
appropriate size.

While at it, remove an unneeded intermediate variable, which allows us
to drop a cast as a bonus.

With the initial behavior it would have been possible to have a device tree
with a node address that would make "ccc<node_address>_pll<N>" exceed
18 characters. If that happened, the <N> would be cut off & both
pll 0 & 1 would be named identically. If that happens, pll1 would fail
to register. Thus, the fixes tag has been added to this commit.

Fixes: d39fb172760e ("clk: microchip: add PolarFire SoC fabric clock support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
[claudiu.beznea: added the rationale behind fixes tag]
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/f904fd28b2087d1463ea65f059924e3b1acc193c.1672764239.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/microchip/clk-mpfs-ccc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/microchip/clk-mpfs-ccc.c b/drivers/clk/microchip/clk-mpfs-ccc.c
index 32aae880a14f3..0ddc73e07be42 100644
--- a/drivers/clk/microchip/clk-mpfs-ccc.c
+++ b/drivers/clk/microchip/clk-mpfs-ccc.c
@@ -164,12 +164,11 @@ static int mpfs_ccc_register_outputs(struct device *dev, struct mpfs_ccc_out_hw_
 
 	for (unsigned int i = 0; i < num_clks; i++) {
 		struct mpfs_ccc_out_hw_clock *out_hw = &out_hws[i];
-		char *name = devm_kzalloc(dev, 23, GFP_KERNEL);
+		char *name = devm_kasprintf(dev, GFP_KERNEL, "%s_out%u", parent->name, i);
 
 		if (!name)
 			return -ENOMEM;
 
-		snprintf(name, 23, "%s_out%u", parent->name, i);
 		out_hw->divider.hw.init = CLK_HW_INIT_HW(name, &parent->hw, &clk_divider_ops, 0);
 		out_hw->divider.reg = data->pll_base[i / MPFS_CCC_OUTPUTS_PER_PLL] +
 			out_hw->reg_offset;
@@ -201,14 +200,13 @@ static int mpfs_ccc_register_plls(struct device *dev, struct mpfs_ccc_pll_hw_clo
 
 	for (unsigned int i = 0; i < num_clks; i++) {
 		struct mpfs_ccc_pll_hw_clock *pll_hw = &pll_hws[i];
-		char *name = devm_kzalloc(dev, 18, GFP_KERNEL);
 
-		if (!name)
+		pll_hw->name = devm_kasprintf(dev, GFP_KERNEL, "ccc%s_pll%u",
+					      strchrnul(dev->of_node->full_name, '@'), i);
+		if (!pll_hw->name)
 			return -ENOMEM;
 
 		pll_hw->base = data->pll_base[i];
-		snprintf(name, 18, "ccc%s_pll%u", strchrnul(dev->of_node->full_name, '@'), i);
-		pll_hw->name = (const char *)name;
 		pll_hw->hw.init = CLK_HW_INIT_PARENTS_DATA_FIXED_SIZE(pll_hw->name,
 								      pll_hw->parents,
 								      &mpfs_ccc_pll_ops, 0);
-- 
2.39.0



