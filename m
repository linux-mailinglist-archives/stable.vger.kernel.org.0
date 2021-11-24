Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F0C45C309
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349852AbhKXNfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349885AbhKXNdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:33:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294CA6187F;
        Wed, 24 Nov 2021 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758406;
        bh=uFf7nlGiy+8P8YwlGzHSY4jxhpTlWoBFly97a3TP54U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWh6Y8j6tHMyka/qQCs2/4SUivQK4AR0SkQodG3kuO9sM9xpHtrF4kgcp66MlqjvC
         MjGQ7wN9fuZUdU6hDTFVc/nFEmxnn3NwUGWEHxw1hNpLalAHkamQaM41o9hBYKOT1q
         5GZIZF7hkTI1DVjoQqERcMS41fBO6CpGKaQ5on/g=
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
Subject: [PATCH 5.10 059/154] clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk
Date:   Wed, 24 Nov 2021 12:57:35 +0100
Message-Id: <20211124115704.237060882@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index 3c3a7ff045621..9b1674b28d45d 100644
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
@@ -3474,7 +3460,6 @@ static struct clk_regmap *gcc_msm8996_clocks[] = {
 	[GCC_AGGRE0_CNOC_AHB_CLK] = &gcc_aggre0_cnoc_ahb_clk.clkr,
 	[GCC_SMMU_AGGRE0_AXI_CLK] = &gcc_smmu_aggre0_axi_clk.clkr,
 	[GCC_SMMU_AGGRE0_AHB_CLK] = &gcc_smmu_aggre0_ahb_clk.clkr,
-	[GCC_AGGRE1_PNOC_AHB_CLK] = &gcc_aggre1_pnoc_ahb_clk.clkr,
 	[GCC_AGGRE2_UFS_AXI_CLK] = &gcc_aggre2_ufs_axi_clk.clkr,
 	[GCC_AGGRE2_USB3_AXI_CLK] = &gcc_aggre2_usb3_axi_clk.clkr,
 	[GCC_QSPI_AHB_CLK] = &gcc_qspi_ahb_clk.clkr,
-- 
2.33.0



