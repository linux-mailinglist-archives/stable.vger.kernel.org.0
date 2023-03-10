Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D26B4875
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbjCJPCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbjCJPCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:02:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B890712DDD7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:55:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D16C8B82312
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E023C433D2;
        Fri, 10 Mar 2023 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460123;
        bh=EGXnPYYtfA0qrite3Q3VZN59thw4eEWSIsbvyx8F8Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz570Lywrl3EnIOep0blS7ZV0IBMzAv8XACAcQ4RHf+EpxYcjDxHwqOeYWtUAJchz
         l5Q8QVJFUcn49QIRBD39sedP16TAx5n4rnXAWuoBlFhP51dX6aTH3xp3TPOO7WO0WM
         VCuszNM+5RDo0rmbrThaIylXdP7WNkU39ybFseXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/529] clk: qcom: gcc-qcs404: disable gpll[04]_out_aux parents
Date:   Fri, 10 Mar 2023 14:36:14 +0100
Message-Id: <20230310133815.705234465@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 712c64caf31374de57aa193a9dff57172b2f6f82 ]

On the QCS404 platform the driver for the Global Clock Controller
doens't define gpll0_out_aux and gpll4_out_aux clocks, so it's not
possible to use them as parents. Remove entries for these clocks.

Note: backporting this patch to earlier kernels would also require a
previous patch which switches the gcc driver to use ARRAY_SIZE for
parent data arrays.

Fixes: 652f1813c113 ("clk: qcom: gcc: Add global clock controller driver for QCS404")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221226042154.2666748-6-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcs404.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcs404.c b/drivers/clk/qcom/gcc-qcs404.c
index 46d314d692505..4299fe8f19274 100644
--- a/drivers/clk/qcom/gcc-qcs404.c
+++ b/drivers/clk/qcom/gcc-qcs404.c
@@ -25,11 +25,9 @@ enum {
 	P_CORE_BI_PLL_TEST_SE,
 	P_DSI0_PHY_PLL_OUT_BYTECLK,
 	P_DSI0_PHY_PLL_OUT_DSICLK,
-	P_GPLL0_OUT_AUX,
 	P_GPLL0_OUT_MAIN,
 	P_GPLL1_OUT_MAIN,
 	P_GPLL3_OUT_MAIN,
-	P_GPLL4_OUT_AUX,
 	P_GPLL4_OUT_MAIN,
 	P_GPLL6_OUT_AUX,
 	P_HDMI_PHY_PLL_CLK,
@@ -109,28 +107,24 @@ static const char * const gcc_parent_names_4[] = {
 static const struct parent_map gcc_parent_map_5[] = {
 	{ P_XO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 1 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_5[] = {
 	"cxo",
 	"dsi0pll_byteclk_src",
-	"gpll0_out_aux",
 	"core_bi_pll_test_se",
 };
 
 static const struct parent_map gcc_parent_map_6[] = {
 	{ P_XO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 2 },
-	{ P_GPLL0_OUT_AUX, 3 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_6[] = {
 	"cxo",
 	"dsi0_phy_pll_out_byteclk",
-	"gpll0_out_aux",
 	"core_bi_pll_test_se",
 };
 
@@ -139,7 +133,6 @@ static const struct parent_map gcc_parent_map_7[] = {
 	{ P_GPLL0_OUT_MAIN, 1 },
 	{ P_GPLL3_OUT_MAIN, 2 },
 	{ P_GPLL6_OUT_AUX, 3 },
-	{ P_GPLL4_OUT_AUX, 4 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
@@ -148,7 +141,6 @@ static const char * const gcc_parent_names_7[] = {
 	"gpll0_out_main",
 	"gpll3_out_main",
 	"gpll6_out_aux",
-	"gpll4_out_aux",
 	"core_bi_pll_test_se",
 };
 
@@ -207,14 +199,12 @@ static const char * const gcc_parent_names_11[] = {
 static const struct parent_map gcc_parent_map_12[] = {
 	{ P_XO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_DSICLK, 1 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_12[] = {
 	"cxo",
 	"dsi0pll_pclk_src",
-	"gpll0_out_aux",
 	"core_bi_pll_test_se",
 };
 
@@ -237,40 +227,34 @@ static const char * const gcc_parent_names_13[] = {
 static const struct parent_map gcc_parent_map_14[] = {
 	{ P_XO, 0 },
 	{ P_GPLL0_OUT_MAIN, 1 },
-	{ P_GPLL4_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_14[] = {
 	"cxo",
 	"gpll0_out_main",
-	"gpll4_out_aux",
 	"core_bi_pll_test_se",
 };
 
 static const struct parent_map gcc_parent_map_15[] = {
 	{ P_XO, 0 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_15[] = {
 	"cxo",
-	"gpll0_out_aux",
 	"core_bi_pll_test_se",
 };
 
 static const struct parent_map gcc_parent_map_16[] = {
 	{ P_XO, 0 },
 	{ P_GPLL0_OUT_MAIN, 1 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_16[] = {
 	"cxo",
 	"gpll0_out_main",
-	"gpll0_out_aux",
 	"core_bi_pll_test_se",
 };
 
-- 
2.39.2



