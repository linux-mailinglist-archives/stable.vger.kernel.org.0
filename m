Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0D645C23A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345491AbhKXN0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:26:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348222AbhKXNYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:24:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A27356101C;
        Wed, 24 Nov 2021 12:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758129;
        bh=XIcguQ8ZK0ATkQctHBU/0ovs4gPIVdvHjp5x3RAgWJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dnxz7rZGjG99QP2l3VDDpGo80uhRAkRmBalZB1yZ9mXHngRvqzh5046IRpHsEU85
         B0MpcC/FDElmTbqlQgzRYdYHT5lN2thOKcuUvzI0AdLBIAaed0wU3sYKmgORqMajUW
         SCULVFtu2rpdRizJp3If1LipRW2by/LeMJPu78fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/100] clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk
Date:   Wed, 24 Nov 2021 12:57:54 +0100
Message-Id: <20211124115656.109224384@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 05cf3ec00d460b50088d421fb878a0f83f57e262 ]

The gcc_aggre1_pnoc_ahb_clk is crucial for the proper MSM8996/APQ8096
functioning. If it gets disabled, several subsytems will stop working
(including eMMC/SDCC and USB). There are no in-kernel users of this
clock, so it is much simpler to remove from the kernel.

The clock was first removed in the commit 9e60de1cf270 ("clk: qcom:
Remove gcc_aggre1_pnoc_ahb_clk from msm8996") by Stephen Boyd, but got
added back in the commit b567752144e3 ("clk: qcom: Add some missing gcc
clks for msm8996") by Rajendra Nayak.

Let's remove it again in hope that nobody adds it back.

Reported-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc: Rajendra Nayak <rnayak@codeaurora.org>
Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
Fixes: b567752144e3 ("clk: qcom: Add some missing gcc clks for msm8996")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211104011155.2209654-1-dmitry.baryshkov@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8996.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8996.c b/drivers/clk/qcom/gcc-msm8996.c
index d004cdaa0e39a..c1e1148f0261d 100644
--- a/drivers/clk/qcom/gcc-msm8996.c
+++ b/drivers/clk/qcom/gcc-msm8996.c
@@ -2937,20 +2937,6 @@ static struct clk_branch gcc_smmu_aggre0_ahb_clk = {
 	},
 };
 
-static struct clk_branch gcc_aggre1_pnoc_ahb_clk = {
-	.halt_reg = 0x82014,
-	.clkr = {
-		.enable_reg = 0x82014,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "gcc_aggre1_pnoc_ahb_clk",
-			.parent_names = (const char *[]){ "periph_noc_clk_src" },
-			.num_parents = 1,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_aggre2_ufs_axi_clk = {
 	.halt_reg = 0x83014,
 	.clkr = {
@@ -3453,7 +3439,6 @@ static struct clk_regmap *gcc_msm8996_clocks[] = {
 	[GCC_AGGRE0_CNOC_AHB_CLK] = &gcc_aggre0_cnoc_ahb_clk.clkr,
 	[GCC_SMMU_AGGRE0_AXI_CLK] = &gcc_smmu_aggre0_axi_clk.clkr,
 	[GCC_SMMU_AGGRE0_AHB_CLK] = &gcc_smmu_aggre0_ahb_clk.clkr,
-	[GCC_AGGRE1_PNOC_AHB_CLK] = &gcc_aggre1_pnoc_ahb_clk.clkr,
 	[GCC_AGGRE2_UFS_AXI_CLK] = &gcc_aggre2_ufs_axi_clk.clkr,
 	[GCC_AGGRE2_USB3_AXI_CLK] = &gcc_aggre2_usb3_axi_clk.clkr,
 	[GCC_QSPI_AHB_CLK] = &gcc_qspi_ahb_clk.clkr,
-- 
2.33.0



