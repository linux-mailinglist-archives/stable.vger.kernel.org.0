Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B69499E6A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345650AbiAXWdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588100AbiAXWbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C72C061769;
        Mon, 24 Jan 2022 11:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50AF26131E;
        Mon, 24 Jan 2022 19:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2E1C340E5;
        Mon, 24 Jan 2022 19:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052971;
        bh=m7JLj5kTr3Bfw//9CcyMcWKFqW+mZabH4MBRc9mSyek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZF1n8P1BdqHUbRwUB9O91haSRITQmwYcf/4bdjuQneytWAJYmXL0u7EIxwvo7QmyT
         fhWRhKF7PuqmrW576fTaWYwku8RoDwSyaK9y2aF17naivb+1uqP04NN20ArGdZZvb9
         5mw0U7KFfbbOuXZgfDMOTSjbafQisUugwWny1HDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 232/320] clk: meson: gxbb: Fix the SDM_EN bit for MPLL0 on GXBB
Date:   Mon, 24 Jan 2022 19:43:36 +0100
Message-Id: <20220124184001.874867416@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit ff54938dd190d85f740b9bf9dde59b550936b621 ]

There are reports that 48kHz audio does not work on the WeTek Play 2
(which uses a GXBB SoC), while 44.1kHz audio works fine on the same
board. There are also reports of 48kHz audio working fine on GXL and
GXM SoCs, which are using an (almost) identical AIU (audio controller).

Experimenting has shown that MPLL0 is causing this problem. In the .dts
we have by default:
	assigned-clocks = <&clkc CLKID_MPLL0>,
			  <&clkc CLKID_MPLL1>,
			  <&clkc CLKID_MPLL2>;
	assigned-clock-rates = <294912000>,
			       <270950400>,
			       <393216000>;
The MPLL0 rate is divisible by 48kHz without remainder and the MPLL1
rate is divisible by 44.1kHz without remainder. Swapping these two clock
rates "fixes" 48kHz audio but breaks 44.1kHz audio.

Everything looks normal when looking at the info provided by the common
clock framework while playing 48kHz audio (via I2S with mclk-fs = 256):
        mpll_prediv                 1        1        0  2000000000
           mpll0_div                1        1        0   294909641
              mpll0                 1        1        0   294909641
                 cts_amclk_sel       1        1        0   294909641
                    cts_amclk_div       1        1        0    12287902
                       cts_amclk       1        1        0    12287902

meson-clk-msr however shows that the actual MPLL0 clock is off by more
than 38MHz:
        mp0_out               333322917    +/-10416Hz

The rate seen by meson-clk-msr is very close to what we would get when
SDM (the fractional part) was ignored:
  (2000000000Hz * 16384) / ((16384 * 6) = 333.33MHz
If SDM was considered the we should get close to:
  (2000000000Hz * 16384) / ((16384 * 6) + 12808) = 294.9MHz

Further experimenting shows that HHI_MPLL_CNTL7[15] does not have any
effect on the rate of MPLL0 as seen my meson-clk-msr (regardless of
whether that bit is zero or one the rate is always the same according to
meson-clk-msr). Using HHI_MPLL_CNTL[25] on the other hand as SDM_EN
results in SDM being considered for the rate output by the hardware. The
rate - as seen by meson-clk-msr - matches with what we expect when
SDM_EN is enabled (fractional part is being considered, resulting in a
294.9MHz output) or disable (fractional part being ignored, resulting in
a 333.33MHz output).

Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Tested-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20211031135006.1508796-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 44 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index 1f9c056e684ce..e8e36ec70b27f 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -712,6 +712,35 @@ static struct clk_regmap gxbb_mpll_prediv = {
 };
 
 static struct clk_regmap gxbb_mpll0_div = {
+	.data = &(struct meson_clk_mpll_data){
+		.sdm = {
+			.reg_off = HHI_MPLL_CNTL7,
+			.shift   = 0,
+			.width   = 14,
+		},
+		.sdm_en = {
+			.reg_off = HHI_MPLL_CNTL,
+			.shift   = 25,
+			.width	 = 1,
+		},
+		.n2 = {
+			.reg_off = HHI_MPLL_CNTL7,
+			.shift   = 16,
+			.width   = 9,
+		},
+		.lock = &meson_clk_lock,
+	},
+	.hw.init = &(struct clk_init_data){
+		.name = "mpll0_div",
+		.ops = &meson_clk_mpll_ops,
+		.parent_hws = (const struct clk_hw *[]) {
+			&gxbb_mpll_prediv.hw
+		},
+		.num_parents = 1,
+	},
+};
+
+static struct clk_regmap gxl_mpll0_div = {
 	.data = &(struct meson_clk_mpll_data){
 		.sdm = {
 			.reg_off = HHI_MPLL_CNTL7,
@@ -748,7 +777,16 @@ static struct clk_regmap gxbb_mpll0 = {
 	.hw.init = &(struct clk_init_data){
 		.name = "mpll0",
 		.ops = &clk_regmap_gate_ops,
-		.parent_hws = (const struct clk_hw *[]) { &gxbb_mpll0_div.hw },
+		.parent_data = &(const struct clk_parent_data) {
+			/*
+			 * Note:
+			 * GXL and GXBB have different SDM_EN registers. We
+			 * fallback to the global naming string mechanism so
+			 * mpll0_div picks up the appropriate one.
+			 */
+			.name = "mpll0_div",
+			.index = -1,
+		},
 		.num_parents = 1,
 		.flags = CLK_SET_RATE_PARENT,
 	},
@@ -3036,7 +3074,7 @@ static struct clk_hw_onecell_data gxl_hw_onecell_data = {
 		[CLKID_VAPB_1]		    = &gxbb_vapb_1.hw,
 		[CLKID_VAPB_SEL]	    = &gxbb_vapb_sel.hw,
 		[CLKID_VAPB]		    = &gxbb_vapb.hw,
-		[CLKID_MPLL0_DIV]	    = &gxbb_mpll0_div.hw,
+		[CLKID_MPLL0_DIV]	    = &gxl_mpll0_div.hw,
 		[CLKID_MPLL1_DIV]	    = &gxbb_mpll1_div.hw,
 		[CLKID_MPLL2_DIV]	    = &gxbb_mpll2_div.hw,
 		[CLKID_MPLL_PREDIV]	    = &gxbb_mpll_prediv.hw,
@@ -3430,7 +3468,7 @@ static struct clk_regmap *const gxl_clk_regmaps[] = {
 	&gxbb_mpll0,
 	&gxbb_mpll1,
 	&gxbb_mpll2,
-	&gxbb_mpll0_div,
+	&gxl_mpll0_div,
 	&gxbb_mpll1_div,
 	&gxbb_mpll2_div,
 	&gxbb_cts_amclk_div,
-- 
2.34.1



