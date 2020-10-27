Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50B329BFA1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815673AbgJ0RED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793603AbgJ0PHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51A3F206E5;
        Tue, 27 Oct 2020 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811244;
        bh=ZA4gR0f7hku3bhQn7pematasi46a6JZ5/96TZT+UQ1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMd1BKq1n2iBGBHjo7FVRqEdSZ4rORUgNIhoxuzdHhGv1+TNA51qbI7jkNxGT5fS5
         haLrKn+sYzk4I5K4FdCPvCueSOoUQWHXppMebsIkckEoCoadokZKxyqxRht6z4f0/8
         TITsM0Pihlx8MO229jhWpbsvR18lo0dYTfam60/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 425/633] clk: meson: axg-audio: separate axg and g12a regmap tables
Date:   Tue, 27 Oct 2020 14:52:48 +0100
Message-Id: <20201027135542.655798281@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit cdabb1ffc7c2349b8930f752df1edcafc1d37cc1 ]

There are more differences than what we initially thought.
Let's keeps things clear and separate the axg and g12a regmap tables of the
audio clock controller.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200729154359.1983085-3-jbrunet@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/axg-audio.c | 135 ++++++++++++++++++++++++++++++++--
 1 file changed, 127 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/meson/axg-audio.c b/drivers/clk/meson/axg-audio.c
index 53715e36326c6..9918cb375de30 100644
--- a/drivers/clk/meson/axg-audio.c
+++ b/drivers/clk/meson/axg-audio.c
@@ -1209,13 +1209,132 @@ static struct clk_hw_onecell_data sm1_audio_hw_onecell_data = {
 };
 
 
-/* Convenience table to populate regmap in .probe()
- * Note that this table is shared between both AXG and G12A,
- * with spdifout_b clocks being exclusive to G12A. Since those
- * clocks are not declared within the AXG onecell table, we do not
- * feel the need to have separate AXG/G12A regmap tables.
- */
+/* Convenience table to populate regmap in .probe(). */
 static struct clk_regmap *const axg_clk_regmaps[] = {
+	&ddr_arb,
+	&pdm,
+	&tdmin_a,
+	&tdmin_b,
+	&tdmin_c,
+	&tdmin_lb,
+	&tdmout_a,
+	&tdmout_b,
+	&tdmout_c,
+	&frddr_a,
+	&frddr_b,
+	&frddr_c,
+	&toddr_a,
+	&toddr_b,
+	&toddr_c,
+	&loopback,
+	&spdifin,
+	&spdifout,
+	&resample,
+	&power_detect,
+	&mst_a_mclk_sel,
+	&mst_b_mclk_sel,
+	&mst_c_mclk_sel,
+	&mst_d_mclk_sel,
+	&mst_e_mclk_sel,
+	&mst_f_mclk_sel,
+	&mst_a_mclk_div,
+	&mst_b_mclk_div,
+	&mst_c_mclk_div,
+	&mst_d_mclk_div,
+	&mst_e_mclk_div,
+	&mst_f_mclk_div,
+	&mst_a_mclk,
+	&mst_b_mclk,
+	&mst_c_mclk,
+	&mst_d_mclk,
+	&mst_e_mclk,
+	&mst_f_mclk,
+	&spdifout_clk_sel,
+	&spdifout_clk_div,
+	&spdifout_clk,
+	&spdifin_clk_sel,
+	&spdifin_clk_div,
+	&spdifin_clk,
+	&pdm_dclk_sel,
+	&pdm_dclk_div,
+	&pdm_dclk,
+	&pdm_sysclk_sel,
+	&pdm_sysclk_div,
+	&pdm_sysclk,
+	&mst_a_sclk_pre_en,
+	&mst_b_sclk_pre_en,
+	&mst_c_sclk_pre_en,
+	&mst_d_sclk_pre_en,
+	&mst_e_sclk_pre_en,
+	&mst_f_sclk_pre_en,
+	&mst_a_sclk_div,
+	&mst_b_sclk_div,
+	&mst_c_sclk_div,
+	&mst_d_sclk_div,
+	&mst_e_sclk_div,
+	&mst_f_sclk_div,
+	&mst_a_sclk_post_en,
+	&mst_b_sclk_post_en,
+	&mst_c_sclk_post_en,
+	&mst_d_sclk_post_en,
+	&mst_e_sclk_post_en,
+	&mst_f_sclk_post_en,
+	&mst_a_sclk,
+	&mst_b_sclk,
+	&mst_c_sclk,
+	&mst_d_sclk,
+	&mst_e_sclk,
+	&mst_f_sclk,
+	&mst_a_lrclk_div,
+	&mst_b_lrclk_div,
+	&mst_c_lrclk_div,
+	&mst_d_lrclk_div,
+	&mst_e_lrclk_div,
+	&mst_f_lrclk_div,
+	&mst_a_lrclk,
+	&mst_b_lrclk,
+	&mst_c_lrclk,
+	&mst_d_lrclk,
+	&mst_e_lrclk,
+	&mst_f_lrclk,
+	&tdmin_a_sclk_sel,
+	&tdmin_b_sclk_sel,
+	&tdmin_c_sclk_sel,
+	&tdmin_lb_sclk_sel,
+	&tdmout_a_sclk_sel,
+	&tdmout_b_sclk_sel,
+	&tdmout_c_sclk_sel,
+	&tdmin_a_sclk_pre_en,
+	&tdmin_b_sclk_pre_en,
+	&tdmin_c_sclk_pre_en,
+	&tdmin_lb_sclk_pre_en,
+	&tdmout_a_sclk_pre_en,
+	&tdmout_b_sclk_pre_en,
+	&tdmout_c_sclk_pre_en,
+	&tdmin_a_sclk_post_en,
+	&tdmin_b_sclk_post_en,
+	&tdmin_c_sclk_post_en,
+	&tdmin_lb_sclk_post_en,
+	&tdmout_a_sclk_post_en,
+	&tdmout_b_sclk_post_en,
+	&tdmout_c_sclk_post_en,
+	&tdmin_a_sclk,
+	&tdmin_b_sclk,
+	&tdmin_c_sclk,
+	&tdmin_lb_sclk,
+	&tdmout_a_sclk,
+	&tdmout_b_sclk,
+	&tdmout_c_sclk,
+	&tdmin_a_lrclk,
+	&tdmin_b_lrclk,
+	&tdmin_c_lrclk,
+	&tdmin_lb_lrclk,
+	&tdmout_a_lrclk,
+	&tdmout_b_lrclk,
+	&tdmout_c_lrclk,
+};
+
+static struct clk_regmap *const g12a_clk_regmaps[] = {
 	&ddr_arb,
 	&pdm,
 	&tdmin_a,
@@ -1713,8 +1832,8 @@ static const struct audioclk_data axg_audioclk_data = {
 };
 
 static const struct audioclk_data g12a_audioclk_data = {
-	.regmap_clks = axg_clk_regmaps,
-	.regmap_clk_num = ARRAY_SIZE(axg_clk_regmaps),
+	.regmap_clks = g12a_clk_regmaps,
+	.regmap_clk_num = ARRAY_SIZE(g12a_clk_regmaps),
 	.hw_onecell_data = &g12a_audio_hw_onecell_data,
 	.reset_offset = AUDIO_SW_RESET,
 	.reset_num = 26,
-- 
2.25.1



