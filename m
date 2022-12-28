Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC29B657D8B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiL1PoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiL1PoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D6A17431
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C21ECE136C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81012C433EF;
        Wed, 28 Dec 2022 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242253;
        bh=JehI8lHjyA+rDPC7y/veHkX6Zg9KtWooSzccuAqeEWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nobqesvpgi3Hgv97rZ9uYXyuV0al5x5AT+8dM2wZXrJMHWqp38WkccwDeRBhq4WM6
         ICDhp59z5sn/UNyZvA/yLlNB5G56SIW7cL8MrQlH58G6BX2xUeladtpV24PqSXJbzg
         sJ1+iHbZlRaq/pKpqWmoTTpmL5WJTgGwn2koaZJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0385/1073] clk: imx8mn: fix imx8mn_enet_phy_sels clocks list
Date:   Wed, 28 Dec 2022 15:32:53 +0100
Message-Id: <20221228144338.466112485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 2626cf67f20b28446dfc3a5b9493dd535cdb747b ]

According to the "Clock Root" table of the reference manual (document
IMX8MNRM Rev 2, 07/2022):

     Clock Root         offset     Source Select (CCM_TARGET_ROOTn[MUX])
        ...              ...                    ...
 ENET_PHY_REF_CLK_ROOT  0xAA80            000 - 24M_REF_CLK
                                          001 - SYSTEM_PLL2_DIV20
                                          010 - SYSTEM_PLL2_DIV8
                                          011 - SYSTEM_PLL2_DIV5
                                          100 - SYSTEM_PLL2_DIV2
                                          101 - AUDIO_PLL1_CLK
                                          110 - VIDEO_PLL_CLK
                                          111 - AUDIO_PLL2_CLK
        ...              ...                    ...

while the imx8mn_enet_phy_sels list didn't contained audio_pll1_out for
source select bits 101b.

Fixes: 96d6392b54dbb ("clk: imx: Add support for i.MX8MN clock driver")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Acked-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20221117113637.1978703-6-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index 37128c35198d..2afea905f7f3 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -140,8 +140,8 @@ static const char * const imx8mn_enet_timer_sels[] = {"osc_24m", "sys_pll2_100m"
 						      "clk_ext4", "video_pll_out", };
 
 static const char * const imx8mn_enet_phy_sels[] = {"osc_24m", "sys_pll2_50m", "sys_pll2_125m",
-						    "sys_pll2_200m", "sys_pll2_500m", "video_pll_out",
-						    "audio_pll2_out", };
+						    "sys_pll2_200m", "sys_pll2_500m", "audio_pll1_out",
+						    "video_pll_out", "audio_pll2_out", };
 
 static const char * const imx8mn_nand_sels[] = {"osc_24m", "sys_pll2_500m", "audio_pll1_out",
 						"sys_pll1_400m", "audio_pll2_out", "sys_pll3_out",
-- 
2.35.1



