Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23254FD1A9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344455AbiDLG7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352642AbiDLG4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5744160A;
        Mon, 11 Apr 2022 23:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF7F060A21;
        Tue, 12 Apr 2022 06:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CAAC385A1;
        Tue, 12 Apr 2022 06:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745978;
        bh=IOovzYC0GjLr5QhhclSKwqs0PgtcJowYk7HNrU5jM5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oilqc9IgQi8tP8/j8ohlWVaNNT/tfaIr4JdrADEc3fCbB+4oz24TgtlY3bs2Pkrcf
         5RDO4Ic/zDxJQ+bm3zstiDRTzxT554dMqT3Lrg9EsVUhTA+CC9uqNm4B/JuLePJqbA
         dI9rIshhhRclAIXptDEwqn3bwFVkFJAqDDSTfc5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/277] clk: rockchip: drop CLK_SET_RATE_PARENT from dclk_vop* on rk3568
Date:   Tue, 12 Apr 2022 08:28:39 +0200
Message-Id: <20220412062945.397645975@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit ff3187eabb5ce478d15b6ed62eb286756adefac3 ]

The pixel clocks dclk_vop[012] can be clocked from hpll, vpll, gpll or
cpll. gpll and cpll also drive many other clocks, so changing the
dclk_vop[012] clocks could change these other clocks as well. Drop
CLK_SET_RATE_PARENT to fix that. With this change the VOP2 driver can
only adjust the pixel clocks with the divider between the PLL and the
dclk_vop[012] which means the user may have to adjust the PLL clock to a
suitable rate using the assigned-clock-rate device tree property.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20220126145549.617165-25-s.hauer@pengutronix.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3568.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3568.c b/drivers/clk/rockchip/clk-rk3568.c
index 75ca855e720d..6e5440841d1e 100644
--- a/drivers/clk/rockchip/clk-rk3568.c
+++ b/drivers/clk/rockchip/clk-rk3568.c
@@ -1038,13 +1038,13 @@ static struct rockchip_clk_branch rk3568_clk_branches[] __initdata = {
 			RK3568_CLKGATE_CON(20), 8, GFLAGS),
 	GATE(HCLK_VOP, "hclk_vop", "hclk_vo", 0,
 			RK3568_CLKGATE_CON(20), 9, GFLAGS),
-	COMPOSITE(DCLK_VOP0, "dclk_vop0", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+	COMPOSITE(DCLK_VOP0, "dclk_vop0", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3568_CLKSEL_CON(39), 10, 2, MFLAGS, 0, 8, DFLAGS,
 			RK3568_CLKGATE_CON(20), 10, GFLAGS),
-	COMPOSITE(DCLK_VOP1, "dclk_vop1", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+	COMPOSITE(DCLK_VOP1, "dclk_vop1", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3568_CLKSEL_CON(40), 10, 2, MFLAGS, 0, 8, DFLAGS,
 			RK3568_CLKGATE_CON(20), 11, GFLAGS),
-	COMPOSITE(DCLK_VOP2, "dclk_vop2", hpll_vpll_gpll_cpll_p, 0,
+	COMPOSITE(DCLK_VOP2, "dclk_vop2", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3568_CLKSEL_CON(41), 10, 2, MFLAGS, 0, 8, DFLAGS,
 			RK3568_CLKGATE_CON(20), 12, GFLAGS),
 	GATE(CLK_VOP_PWM, "clk_vop_pwm", "xin24m", 0,
-- 
2.35.1



