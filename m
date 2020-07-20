Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FA1226766
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731188AbgGTQLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387787AbgGTQLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:11:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F6320684;
        Mon, 20 Jul 2020 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261480;
        bh=jGU+jkNnnj/kn9S/wd1betA8iMZQHV6GRZuejkRpqMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHMX1FcqSl1yM6y1Dszj7TtOzNYTWIIgUAIze4zC1b1vGXIry1E9TMeRpOxUNYZGO
         M3nqxy7GIlWbO81VjBGdble/NcCToKSkTOEJX77mSDMwddAKtDzo8jjEbvmw0zSyqy
         F/qo7YDV/jsiH/BtaDeDrHtgmK12Y6WXY0fXKMUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.7 131/244] clk: qcom: Add missing msm8998 ufs_unipro_core_clk_src
Date:   Mon, 20 Jul 2020 17:36:42 +0200
Message-Id: <20200720152832.074521884@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

commit b1e8d713e6b2d59ee3a7b57c0dab88a19ec0cf33 upstream.

ufs_unipro_core_clk_src is required to allow UFS to clock scale for power
savings.

Fixes: b5f5f525c547 ("clk: qcom: Add MSM8998 Global Clock Control (GCC) driver")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lkml.kernel.org/r/20200528142205.44003-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/gcc-msm8998.c               |   27 +++++++++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-msm8998.h |    1 +
 2 files changed, 28 insertions(+)

--- a/drivers/clk/qcom/gcc-msm8998.c
+++ b/drivers/clk/qcom/gcc-msm8998.c
@@ -1110,6 +1110,27 @@ static struct clk_rcg2 ufs_axi_clk_src =
 	},
 };
 
+static const struct freq_tbl ftbl_ufs_unipro_core_clk_src[] = {
+	F(37500000, P_GPLL0_OUT_MAIN, 16, 0, 0),
+	F(75000000, P_GPLL0_OUT_MAIN, 8, 0, 0),
+	F(150000000, P_GPLL0_OUT_MAIN, 4, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 ufs_unipro_core_clk_src = {
+	.cmd_rcgr = 0x76028,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_parent_map_0,
+	.freq_tbl = ftbl_ufs_unipro_core_clk_src,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "ufs_unipro_core_clk_src",
+		.parent_names = gcc_parent_names_0,
+		.num_parents = 4,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_usb30_master_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL0_OUT_MAIN, 10, 0, 0),
@@ -2549,6 +2570,11 @@ static struct clk_branch gcc_ufs_unipro_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_ufs_unipro_core_clk",
+			.parent_names = (const char *[]){
+				"ufs_unipro_core_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2904,6 +2930,7 @@ static struct clk_regmap *gcc_msm8998_cl
 	[SDCC4_APPS_CLK_SRC] = &sdcc4_apps_clk_src.clkr,
 	[TSIF_REF_CLK_SRC] = &tsif_ref_clk_src.clkr,
 	[UFS_AXI_CLK_SRC] = &ufs_axi_clk_src.clkr,
+	[UFS_UNIPRO_CORE_CLK_SRC] = &ufs_unipro_core_clk_src.clkr,
 	[USB30_MASTER_CLK_SRC] = &usb30_master_clk_src.clkr,
 	[USB30_MOCK_UTMI_CLK_SRC] = &usb30_mock_utmi_clk_src.clkr,
 	[USB3_PHY_AUX_CLK_SRC] = &usb3_phy_aux_clk_src.clkr,
--- a/include/dt-bindings/clock/qcom,gcc-msm8998.h
+++ b/include/dt-bindings/clock/qcom,gcc-msm8998.h
@@ -183,6 +183,7 @@
 #define GCC_MSS_SNOC_AXI_CLK					174
 #define GCC_MSS_MNOC_BIMC_AXI_CLK				175
 #define GCC_BIMC_GFX_CLK					176
+#define UFS_UNIPRO_CORE_CLK_SRC					177
 
 #define PCIE_0_GDSC						0
 #define UFS_GDSC						1


