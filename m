Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7157215F22F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392482AbgBNSHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbgBNPy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0F8B222C4;
        Fri, 14 Feb 2020 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695668;
        bh=CVfVA6v89yNedy4aQtUH/s74q22YyBh8hOOT8Sme+v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZOkG9aKTnt0LTypyrpCz65/JAPQFti0huxbPWrZyifiJ3Grropt2Rr55nM/2dK5M
         WM/y8etsLG56hxSriZCBJdMrwHIHuuO7dHiOBXmfkmpwFVBXNzoeor34Ygc0kQX0Ru
         nCVuddO9SX41WcrNtJByAARFmz9jV/s1WIW0UGKk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 257/542] clk: qcom: Add missing msm8998 gcc_bimc_gfx_clk
Date:   Fri, 14 Feb 2020 10:44:09 -0500
Message-Id: <20200214154854.6746-257-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit db2c7c0a04b11753f5741d00b784b5380ddeee72 ]

gcc_bimc_gfx_clk is a required clock for booting the GPU and GPU SMMU.

Fixes: 4807c71cc688 (arm64: dts: Add msm8998 SoC and MTP board support)
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lkml.kernel.org/r/20191217164913.4783-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8998.c               | 14 ++++++++++++++
 include/dt-bindings/clock/qcom,gcc-msm8998.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8998.c b/drivers/clk/qcom/gcc-msm8998.c
index cf31b5d03270f..df1d7056436cd 100644
--- a/drivers/clk/qcom/gcc-msm8998.c
+++ b/drivers/clk/qcom/gcc-msm8998.c
@@ -1996,6 +1996,19 @@ static struct clk_branch gcc_gp3_clk = {
 	},
 };
 
+static struct clk_branch gcc_bimc_gfx_clk = {
+	.halt_reg = 0x46040,
+	.halt_check = BRANCH_HALT,
+	.clkr = {
+		.enable_reg = 0x46040,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_bimc_gfx_clk",
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_gpu_bimc_gfx_clk = {
 	.halt_reg = 0x71010,
 	.halt_check = BRANCH_HALT,
@@ -2810,6 +2823,7 @@ static struct clk_regmap *gcc_msm8998_clocks[] = {
 	[GCC_GP1_CLK] = &gcc_gp1_clk.clkr,
 	[GCC_GP2_CLK] = &gcc_gp2_clk.clkr,
 	[GCC_GP3_CLK] = &gcc_gp3_clk.clkr,
+	[GCC_BIMC_GFX_CLK] = &gcc_bimc_gfx_clk.clkr,
 	[GCC_GPU_BIMC_GFX_CLK] = &gcc_gpu_bimc_gfx_clk.clkr,
 	[GCC_GPU_BIMC_GFX_SRC_CLK] = &gcc_gpu_bimc_gfx_src_clk.clkr,
 	[GCC_GPU_CFG_AHB_CLK] = &gcc_gpu_cfg_ahb_clk.clkr,
diff --git a/include/dt-bindings/clock/qcom,gcc-msm8998.h b/include/dt-bindings/clock/qcom,gcc-msm8998.h
index de1d8a1f59665..63e02dc32a0bb 100644
--- a/include/dt-bindings/clock/qcom,gcc-msm8998.h
+++ b/include/dt-bindings/clock/qcom,gcc-msm8998.h
@@ -182,6 +182,7 @@
 #define GCC_MSS_GPLL0_DIV_CLK_SRC				173
 #define GCC_MSS_SNOC_AXI_CLK					174
 #define GCC_MSS_MNOC_BIMC_AXI_CLK				175
+#define GCC_BIMC_GFX_CLK					176
 
 #define PCIE_0_GDSC						0
 #define UFS_GDSC						1
-- 
2.20.1

