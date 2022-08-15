Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A185594267
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349894AbiHOVs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350306AbiHOVri (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:47:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979D76050F;
        Mon, 15 Aug 2022 12:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0978EB8107A;
        Mon, 15 Aug 2022 19:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6C9C433C1;
        Mon, 15 Aug 2022 19:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591910;
        bh=z2ppMhTPiC/F2H1GoH0DGMhpTjqq0uo0VJ7PpbIH8zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9oe+aTf7yjoposCPbzNekzFYYb1goza5bmqWIUrVZXWRr4bzyQV8nXJ6aUIajrwg
         J0UauQW8RzO1HM5+GFdl3ICAtV7yH1TaDbe6LB032WoP/dAcTHua3TWMU6pokmXPle
         KZ83C4+wvsJPTPTPFtW5ewIOOEN/yKwWnwPjM1x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0703/1095] clk: qcom: gcc-msm8939: Point MM peripherals to system_mm_noc clock
Date:   Mon, 15 Aug 2022 20:01:42 +0200
Message-Id: <20220815180458.445954519@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 05eed0990927aa9634682fec58660e30f7b7ae30 ]

Qcom docs indciate the following peripherals operating from System NOC
MM not from System NOC clocks.

- MDP
- VFE
- JPEGe
- Venus

Switch over the relevant parent pointers.

Fixes: 1664014e4679 ("clk: qcom: gcc-msm8939: Add MSM8939 Generic Clock Controller")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220504163835.40130-5-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8939.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8939.c b/drivers/clk/qcom/gcc-msm8939.c
index 12bab9067ea8..c7377ec0f423 100644
--- a/drivers/clk/qcom/gcc-msm8939.c
+++ b/drivers/clk/qcom/gcc-msm8939.c
@@ -2453,7 +2453,7 @@ static struct clk_branch gcc_camss_jpeg_axi_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_camss_jpeg_axi_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -2657,7 +2657,7 @@ static struct clk_branch gcc_camss_vfe_axi_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_camss_vfe_axi_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -2813,7 +2813,7 @@ static struct clk_branch gcc_mdss_axi_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mdss_axi_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -3205,7 +3205,7 @@ static struct clk_branch gcc_mdp_tbu_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mdp_tbu_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -3223,7 +3223,7 @@ static struct clk_branch gcc_venus_tbu_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_venus_tbu_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -3241,7 +3241,7 @@ static struct clk_branch gcc_vfe_tbu_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_vfe_tbu_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -3259,7 +3259,7 @@ static struct clk_branch gcc_jpeg_tbu_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_jpeg_tbu_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -3496,7 +3496,7 @@ static struct clk_branch gcc_venus0_axi_clk = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_venus0_axi_clk",
 			.parent_data = &(const struct clk_parent_data){
-				.hw = &system_noc_bfdcd_clk_src.clkr.hw,
+				.hw = &system_mm_noc_bfdcd_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
-- 
2.35.1



