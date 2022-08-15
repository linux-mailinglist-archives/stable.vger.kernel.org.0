Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C88594AF8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348165AbiHPAIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354632AbiHPAGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:06:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607881705F9;
        Mon, 15 Aug 2022 13:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CE3C61089;
        Mon, 15 Aug 2022 20:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755D0C433C1;
        Mon, 15 Aug 2022 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595304;
        bh=1zVo5EEaQatHXI3wYiQzTgBe1L4ws1B/mp02biI9KXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xM7dg68dgMHMa9w06L6WAUOhlejlqcEc2z+eKk/R+SuVU21WVoyOBoiY6rPnXEnNb
         eR1+0wsm10ifFFnE7/p3Z0CaJTY08VaOSymQKUM4XA9u8dxfN/Ohfx010BE3zeh+HX
         noTPoyVrxqA2gB/AvhGOMmO3WPOYTx7bpx5k89sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0721/1157] clk: imx93: use adc_root as the parent clock of adc1
Date:   Mon, 15 Aug 2022 20:01:17 +0200
Message-Id: <20220815180508.329065034@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 18d6d8fe4f24938985844d52c481b86fcce9d102 ]

When debug, find after system boot up, all adc register operation
will trigger system hang, this is because the internal adc ipg
clock is gate off. In dts, only reference the IMX93_CLK_ADC1_GATE,
which is adc1, no one touch the adc_root, so adc_root will be gate
off automatically after system boot up.

Fixes: 24defbe194b6 ("clk: imx: add i.MX93 clk")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20220609132902.3504651-2-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index edcc87661d1f..172cd56c9610 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -150,7 +150,7 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_A55_GATE,		"a55",		"a55_root",		0x8000, },
 	/* M33 critical clk for system run */
 	{ IMX93_CLK_CM33_GATE,		"cm33",		"m33_root",		0x8040, CLK_IS_CRITICAL },
-	{ IMX93_CLK_ADC1_GATE,		"adc1",		"osc_24m",		0x82c0, },
+	{ IMX93_CLK_ADC1_GATE,		"adc1",		"adc_root",		0x82c0, },
 	{ IMX93_CLK_WDOG1_GATE,		"wdog1",	"osc_24m",		0x8300, },
 	{ IMX93_CLK_WDOG2_GATE,		"wdog2",	"osc_24m",		0x8340, },
 	{ IMX93_CLK_WDOG3_GATE,		"wdog3",	"osc_24m",		0x8380, },
-- 
2.35.1



