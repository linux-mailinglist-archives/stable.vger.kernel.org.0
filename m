Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41DF35C0B9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbhDLJPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240627AbhDLJKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39AF4613AF;
        Mon, 12 Apr 2021 09:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218360;
        bh=c5efIGUejmMRLYAWFjjNFTQg8Ptw+yEBIp3TSAEn1t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBA4cKGZKtR77aIb70CTX8TWKiduTJjeC0h4pivhwQIlMOCEsI6tPpP+8+faNHOgT
         eNzuRmN0OQ8jP3P8QIP9HtjocH75IYC9XwVnq7IAWj1bqolXgN38tqZ4gNPYl2vieA
         SVzSEFOPi2KMQVM/3UrdN6mj8bWQSv3yjHVst9pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 133/210] clk: qcom: camcc: Update the clock ops for the SC7180
Date:   Mon, 12 Apr 2021 10:40:38 +0200
Message-Id: <20210412084020.443228377@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit e5c359f70e4b5e7b6c2bf4b0ca2d2686d543a37b ]

Some of the RCGs could be always ON from the XO source and could be used
as the clock on signal for the GDSC to be operational. In the cases where
the GDSCs are parked at different source with the source clock disabled,
it could lead to the GDSC to be stuck at ON/OFF during gdsc disable/enable.
Thus park the RCGs at XO during clock disable and update the rcg_ops to
use the shared_ops.

Fixes: 15d09e830bbc ("clk: qcom: camcc: Add camera clock controller driver for SC7180")
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lore.kernel.org/r/1616809265-11912-1-git-send-email-tdas@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sc7180.c | 50 ++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/clk/qcom/camcc-sc7180.c b/drivers/clk/qcom/camcc-sc7180.c
index dbac5651ab85..9bcf2f8ed4de 100644
--- a/drivers/clk/qcom/camcc-sc7180.c
+++ b/drivers/clk/qcom/camcc-sc7180.c
@@ -304,7 +304,7 @@ static struct clk_rcg2 cam_cc_bps_clk_src = {
 		.name = "cam_cc_bps_clk_src",
 		.parent_data = cam_cc_parent_data_2,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -325,7 +325,7 @@ static struct clk_rcg2 cam_cc_cci_0_clk_src = {
 		.name = "cam_cc_cci_0_clk_src",
 		.parent_data = cam_cc_parent_data_5,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -339,7 +339,7 @@ static struct clk_rcg2 cam_cc_cci_1_clk_src = {
 		.name = "cam_cc_cci_1_clk_src",
 		.parent_data = cam_cc_parent_data_5,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -360,7 +360,7 @@ static struct clk_rcg2 cam_cc_cphy_rx_clk_src = {
 		.name = "cam_cc_cphy_rx_clk_src",
 		.parent_data = cam_cc_parent_data_3,
 		.num_parents = 6,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -379,7 +379,7 @@ static struct clk_rcg2 cam_cc_csi0phytimer_clk_src = {
 		.name = "cam_cc_csi0phytimer_clk_src",
 		.parent_data = cam_cc_parent_data_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -393,7 +393,7 @@ static struct clk_rcg2 cam_cc_csi1phytimer_clk_src = {
 		.name = "cam_cc_csi1phytimer_clk_src",
 		.parent_data = cam_cc_parent_data_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -407,7 +407,7 @@ static struct clk_rcg2 cam_cc_csi2phytimer_clk_src = {
 		.name = "cam_cc_csi2phytimer_clk_src",
 		.parent_data = cam_cc_parent_data_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -421,7 +421,7 @@ static struct clk_rcg2 cam_cc_csi3phytimer_clk_src = {
 		.name = "cam_cc_csi3phytimer_clk_src",
 		.parent_data = cam_cc_parent_data_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -443,7 +443,7 @@ static struct clk_rcg2 cam_cc_fast_ahb_clk_src = {
 		.name = "cam_cc_fast_ahb_clk_src",
 		.parent_data = cam_cc_parent_data_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -466,7 +466,7 @@ static struct clk_rcg2 cam_cc_icp_clk_src = {
 		.name = "cam_cc_icp_clk_src",
 		.parent_data = cam_cc_parent_data_2,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -488,7 +488,7 @@ static struct clk_rcg2 cam_cc_ife_0_clk_src = {
 		.name = "cam_cc_ife_0_clk_src",
 		.parent_data = cam_cc_parent_data_4,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -510,7 +510,7 @@ static struct clk_rcg2 cam_cc_ife_0_csid_clk_src = {
 		.name = "cam_cc_ife_0_csid_clk_src",
 		.parent_data = cam_cc_parent_data_3,
 		.num_parents = 6,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -524,7 +524,7 @@ static struct clk_rcg2 cam_cc_ife_1_clk_src = {
 		.name = "cam_cc_ife_1_clk_src",
 		.parent_data = cam_cc_parent_data_4,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -538,7 +538,7 @@ static struct clk_rcg2 cam_cc_ife_1_csid_clk_src = {
 		.name = "cam_cc_ife_1_csid_clk_src",
 		.parent_data = cam_cc_parent_data_3,
 		.num_parents = 6,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -553,7 +553,7 @@ static struct clk_rcg2 cam_cc_ife_lite_clk_src = {
 		.parent_data = cam_cc_parent_data_4,
 		.num_parents = 4,
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -567,7 +567,7 @@ static struct clk_rcg2 cam_cc_ife_lite_csid_clk_src = {
 		.name = "cam_cc_ife_lite_csid_clk_src",
 		.parent_data = cam_cc_parent_data_3,
 		.num_parents = 6,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -590,7 +590,7 @@ static struct clk_rcg2 cam_cc_ipe_0_clk_src = {
 		.name = "cam_cc_ipe_0_clk_src",
 		.parent_data = cam_cc_parent_data_2,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -613,7 +613,7 @@ static struct clk_rcg2 cam_cc_jpeg_clk_src = {
 		.name = "cam_cc_jpeg_clk_src",
 		.parent_data = cam_cc_parent_data_2,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -635,7 +635,7 @@ static struct clk_rcg2 cam_cc_lrme_clk_src = {
 		.name = "cam_cc_lrme_clk_src",
 		.parent_data = cam_cc_parent_data_6,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -656,7 +656,7 @@ static struct clk_rcg2 cam_cc_mclk0_clk_src = {
 		.name = "cam_cc_mclk0_clk_src",
 		.parent_data = cam_cc_parent_data_1,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -670,7 +670,7 @@ static struct clk_rcg2 cam_cc_mclk1_clk_src = {
 		.name = "cam_cc_mclk1_clk_src",
 		.parent_data = cam_cc_parent_data_1,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -684,7 +684,7 @@ static struct clk_rcg2 cam_cc_mclk2_clk_src = {
 		.name = "cam_cc_mclk2_clk_src",
 		.parent_data = cam_cc_parent_data_1,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -698,7 +698,7 @@ static struct clk_rcg2 cam_cc_mclk3_clk_src = {
 		.name = "cam_cc_mclk3_clk_src",
 		.parent_data = cam_cc_parent_data_1,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -712,7 +712,7 @@ static struct clk_rcg2 cam_cc_mclk4_clk_src = {
 		.name = "cam_cc_mclk4_clk_src",
 		.parent_data = cam_cc_parent_data_1,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -732,7 +732,7 @@ static struct clk_rcg2 cam_cc_slow_ahb_clk_src = {
 		.parent_data = cam_cc_parent_data_0,
 		.num_parents = 4,
 		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.30.2



