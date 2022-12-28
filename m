Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0C3657E33
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiL1PvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiL1PvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:51:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D22D186BF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22130B81733
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B8C433EF;
        Wed, 28 Dec 2022 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242667;
        bh=MDEkBS14t9zOKpOegTTLz/PJjOLWSO9yvycEsJs76RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fo8ilHUCse9Z+SUTpR/738f5Ui++MBaiyHxc8RWB2qb8zZb4LBi8KJfOH8oO2BWOA
         QHRlxlyVGXukSAo948lOSxoj9hctq1Vk4GzM+Th6928oWTDkbzYg2DP6rAKQEwXNcm
         hb6G+uxOrGA7rGinDTCs0TdTJpn2l/w0mL5dgb1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0400/1146] clk: imx8mn: fix imx8mn_sai2_sels clocks list
Date:   Wed, 28 Dec 2022 15:32:19 +0100
Message-Id: <20221228144341.028599371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 34d996747a74e3a86990f9f9c48de09159d78edb ]

According to the "Clock Root" table of the reference manual (document
IMX8MNRM Rev 2, 07/2022):

     Clock Root     offset     Source Select (CCM_TARGET_ROOTn[MUX])
        ...          ...                    ...
   SAI2_CLK_ROOT    0xA600            000 - 24M_REF_CLK
                                      001 - AUDIO_PLL1_CLK
                                      010 - AUDIO_PLL2_CLK
                                      011 - VIDEO_PLL_CLK
                                      100 - SYSTEM_PLL1_DIV6
                                      110 - EXT_CLK_2
                                      111 - EXT_CLK_3
        ...          ...                    ...

while the imx8mn_sai2_sels list contained clk_ext3 and clk_ext4 for
source select bits 110b and 111b.

Fixes: 96d6392b54dbb ("clk: imx: Add support for i.MX8MN clock driver")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Acked-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20221117113637.1978703-5-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index b80af5d1ef46..37128c35198d 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -109,7 +109,7 @@ static const char * const imx8mn_disp_pixel_sels[] = {"osc_24m", "video_pll_out"
 
 static const char * const imx8mn_sai2_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
 						"video_pll_out", "sys_pll1_133m", "dummy",
-						"clk_ext3", "clk_ext4", };
+						"clk_ext2", "clk_ext3", };
 
 static const char * const imx8mn_sai3_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
 						"video_pll_out", "sys_pll1_133m", "dummy",
-- 
2.35.1



