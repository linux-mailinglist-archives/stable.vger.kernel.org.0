Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA542267A6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388113AbgGTQN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388103AbgGTQNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C3932064B;
        Mon, 20 Jul 2020 16:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261603;
        bh=QEBksOxYrFSGu/kQ4u6K0V0deKs46fQ8vBFg3d3KN7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUxZmN6ooFgq0ctHu5ayAoKOweP1l7t3TyAFZ1lf3CHt6nuoozTlFKtI2ayIgQSet
         iPLVuJCsustzErZSrSNjxaEpbXNRKMSLq9fTpUs8uLv8tYzUrPXiR0VqL9XBBSTISw
         DP7VZPot36mgZN+7BDx1RveXSspPUvjxyyPO2wg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.7 145/244] clk: qcom: gcc: Add support for a new frequency for SC7180
Date:   Mon, 20 Jul 2020 17:36:56 +0200
Message-Id: <20200720152832.747988002@linuxfoundation.org>
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

From: Taniya Das <tdas@codeaurora.org>

commit 1b70061f5939ff1cacd728821b4f378cb0fb7961 upstream.

There is a requirement to support 51.2MHz from GPLL6 for qup clocks,
thus update the frequency table and parent data/map to use the GPLL6
source PLL.

Fixes: 17269568f7267 ("clk: qcom: Add Global Clock controller (GCC) driver for SC7180")
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lkml.kernel.org/r/1589709861-27580-2-git-send-email-tdas@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/gcc-sc7180.c |   73 +++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

--- a/drivers/clk/qcom/gcc-sc7180.c
+++ b/drivers/clk/qcom/gcc-sc7180.c
@@ -390,6 +390,7 @@ static const struct freq_tbl ftbl_gcc_qu
 	F(29491200, P_GPLL0_OUT_EVEN, 1, 1536, 15625),
 	F(32000000, P_GPLL0_OUT_EVEN, 1, 8, 75),
 	F(48000000, P_GPLL0_OUT_EVEN, 1, 4, 25),
+	F(51200000, P_GPLL6_OUT_MAIN, 7.5, 0, 0),
 	F(64000000, P_GPLL0_OUT_EVEN, 1, 16, 75),
 	F(75000000, P_GPLL0_OUT_EVEN, 4, 0, 0),
 	F(80000000, P_GPLL0_OUT_EVEN, 1, 4, 15),
@@ -405,8 +406,8 @@ static const struct freq_tbl ftbl_gcc_qu
 
 static struct clk_init_data gcc_qupv3_wrap0_s0_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s0_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -414,15 +415,15 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s
 	.cmd_rcgr = 0x17034,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap0_s0_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap0_s1_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s1_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -430,15 +431,15 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s
 	.cmd_rcgr = 0x17164,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap0_s1_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap0_s2_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s2_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -446,15 +447,15 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s
 	.cmd_rcgr = 0x17294,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap0_s2_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap0_s3_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s3_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -462,15 +463,15 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s
 	.cmd_rcgr = 0x173c4,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap0_s3_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap0_s4_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s4_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -478,15 +479,15 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s
 	.cmd_rcgr = 0x174f4,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap0_s4_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap0_s5_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s5_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -494,15 +495,15 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s
 	.cmd_rcgr = 0x17624,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap0_s5_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap1_s0_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s0_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -510,15 +511,15 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s
 	.cmd_rcgr = 0x18018,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap1_s0_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap1_s1_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s1_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -526,15 +527,15 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s
 	.cmd_rcgr = 0x18148,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap1_s1_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap1_s2_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s2_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -542,15 +543,15 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s
 	.cmd_rcgr = 0x18278,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap1_s2_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap1_s3_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s3_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -558,15 +559,15 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s
 	.cmd_rcgr = 0x183a8,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap1_s3_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap1_s4_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s4_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -574,15 +575,15 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s
 	.cmd_rcgr = 0x184d8,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap1_s4_clk_src_init,
 };
 
 static struct clk_init_data gcc_qupv3_wrap1_s5_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s5_clk_src",
-	.parent_data = gcc_parent_data_0,
-	.num_parents = 4,
+	.parent_data = gcc_parent_data_1,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -590,7 +591,7 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s
 	.cmd_rcgr = 0x18608,
 	.mnd_width = 16,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
+	.parent_map = gcc_parent_map_1,
 	.freq_tbl = ftbl_gcc_qupv3_wrap0_s0_clk_src,
 	.clkr.hw.init = &gcc_qupv3_wrap1_s5_clk_src_init,
 };


