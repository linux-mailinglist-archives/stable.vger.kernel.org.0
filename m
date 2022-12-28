Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4388657C52
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbiL1Pb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiL1PbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:31:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C91215F1B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E34FE6155A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA7C433EF;
        Wed, 28 Dec 2022 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241477;
        bh=Fo44WJ7OXFGSEe/SuBPMouoCYCjUaUsBgm+pGQrkSEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XK1Ugbkj2X1sWxRszSPrhYO1fRajbv2KvSbIU2A+lNU+f31zSUhr+gbdrtd5uUgxY
         z9a1SBz6cxIE4RiXfF+Glw5BF5Ghu9LK3JTXvQBr40lzdttEN719useV3YTSwAQZVa
         6Dh7kcJpi8yfAmqKuOOKcJdR9AVXEN5FVSHcQmsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0288/1073] clk: qcom: dispcc-sm6350: Add CLK_OPS_PARENT_ENABLE to pixel&byte src
Date:   Wed, 28 Dec 2022 15:31:16 +0100
Message-Id: <20221228144335.839878737@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 92039e8c080c63748f8e133e7cfad33a75daefb6 ]

Add the CLK_OPS_PARENT_ENABLE flag to pixel and byte clk srcs to
ensure set_rate can succeed.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Fixes: 837519775f1d ("clk: qcom: Add display clock controller driver for  SM6350")
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221010155546.73884-1-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm6350.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm6350.c b/drivers/clk/qcom/dispcc-sm6350.c
index 0c3c2e26ede9..ea6f54ed846e 100644
--- a/drivers/clk/qcom/dispcc-sm6350.c
+++ b/drivers/clk/qcom/dispcc-sm6350.c
@@ -306,7 +306,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk0_clk_src = {
 		.name = "disp_cc_mdss_pclk0_clk_src",
 		.parent_data = disp_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_5),
-		.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE,
+		.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
@@ -385,7 +385,7 @@ static struct clk_branch disp_cc_mdss_byte0_clk = {
 				&disp_cc_mdss_byte0_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE,
+			.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE | CLK_OPS_PARENT_ENABLE,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.35.1



