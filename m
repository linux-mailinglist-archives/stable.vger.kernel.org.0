Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D160460ACE4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbiJXOQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiJXOPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063382126E;
        Mon, 24 Oct 2022 05:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD1561281;
        Mon, 24 Oct 2022 12:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517E9C433D7;
        Mon, 24 Oct 2022 12:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616040;
        bh=C7El9trPxMiStklp7uiGfwL+maeAvCDhRvisZCZ/KXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwoHLlahBVsQzEUlz1G7WMUe1QgdDLYvEf5NMnNSwWbjeAYWWKF+8vi5eqnTjZn9K
         +m/c1NNHCR60hXVXeh6My+XbQVgHzvfok3y5yqlR5Qbtm6GCI2Lp5mQW3o7i9Up4KX
         pIESnYeg04SE1ItX0asmpodZdBf3pCoBl6IeBmDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/530] clk: zynqmp: pll: rectify rate rounding in zynqmp_pll_round_rate
Date:   Mon, 24 Oct 2022 13:33:43 +0200
Message-Id: <20221024113106.737538083@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 30eaf02149ecc3c5815e45d27187bf09e925071d ]

The function zynqmp_pll_round_rate is used to find a most appropriate
PLL frequency which the hardware can generate according to the desired
frequency. For example, if the desired frequency is 297MHz, considering
the limited range from PS_PLL_VCO_MIN (1.5GHz) to PS_PLL_VCO_MAX (3.0GHz)
of PLL, zynqmp_pll_round_rate should return 1.872GHz (297MHz * 5).

There are two problems with the current code of zynqmp_pll_round_rate:

1) When the rate is below PS_PLL_VCO_MIN, it can't find a correct rate
when the parameter "rate" is an integer multiple of *prate, in other words,
if "f" is zero, zynqmp_pll_round_rate won't return a valid frequency which
is from PS_PLL_VCO_MIN to PS_PLL_VCO_MAX. For example, *prate is 33MHz
and the rate is 660MHz, zynqmp_pll_round_rate will not boost up rate and
just return 660MHz, and this will cause clk_calc_new_rates failure since
zynqmp_pll_round_rate returns an invalid rate out of its boundaries.

2) Even if the rate is higher than PS_PLL_VCO_MIN, there is still a risk
that zynqmp_pll_round_rate returns an invalid rate because the function
DIV_ROUND_CLOSEST makes some loss in the fractional part. If the parent
clock *prate is 33333333Hz and we want to set the PLL rate to 1.5GHz,
this function will return 1499999985Hz by using the formula below:
    value = *prate * DIV_ROUND_CLOSEST(rate, *prate)).
This value is also invalid since it's slightly smaller than PS_PLL_VCO_MIN.
because DIV_ROUND_CLOSEST makes some loss in the fractional part.

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20220826142030.213805-1-quanyang.wang@windriver.com
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/pll.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/zynqmp/pll.c b/drivers/clk/zynqmp/pll.c
index 036e4ff64a2f..bc066f300345 100644
--- a/drivers/clk/zynqmp/pll.c
+++ b/drivers/clk/zynqmp/pll.c
@@ -102,26 +102,25 @@ static long zynqmp_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 				  unsigned long *prate)
 {
 	u32 fbdiv;
-	long rate_div, f;
+	u32 mult, div;
 
-	/* Enable the fractional mode if needed */
-	rate_div = (rate * FRAC_DIV) / *prate;
-	f = rate_div % FRAC_DIV;
-	if (f) {
-		if (rate > PS_PLL_VCO_MAX) {
-			fbdiv = rate / PS_PLL_VCO_MAX;
-			rate = rate / (fbdiv + 1);
-		}
-		if (rate < PS_PLL_VCO_MIN) {
-			fbdiv = DIV_ROUND_UP(PS_PLL_VCO_MIN, rate);
-			rate = rate * fbdiv;
-		}
-		return rate;
+	/* Let rate fall inside the range PS_PLL_VCO_MIN ~ PS_PLL_VCO_MAX */
+	if (rate > PS_PLL_VCO_MAX) {
+		div = DIV_ROUND_UP(rate, PS_PLL_VCO_MAX);
+		rate = rate / div;
+	}
+	if (rate < PS_PLL_VCO_MIN) {
+		mult = DIV_ROUND_UP(PS_PLL_VCO_MIN, rate);
+		rate = rate * mult;
 	}
 
 	fbdiv = DIV_ROUND_CLOSEST(rate, *prate);
-	fbdiv = clamp_t(u32, fbdiv, PLL_FBDIV_MIN, PLL_FBDIV_MAX);
-	return *prate * fbdiv;
+	if (fbdiv < PLL_FBDIV_MIN || fbdiv > PLL_FBDIV_MAX) {
+		fbdiv = clamp_t(u32, fbdiv, PLL_FBDIV_MIN, PLL_FBDIV_MAX);
+		rate = *prate * fbdiv;
+	}
+
+	return rate;
 }
 
 /**
-- 
2.35.1



