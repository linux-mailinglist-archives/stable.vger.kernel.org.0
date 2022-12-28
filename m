Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18D8657C50
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiL1PbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiL1PbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:31:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ED915F1B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8274DB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88BEC433D2;
        Wed, 28 Dec 2022 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241469;
        bh=pflqptXIswItlr5+JwuUkH37rwc7vDGlWVLQV8q1BOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNz211UXI1xiOowh0g9+nqIwCL7kl7kq5wzewuH8GSPB5Y16eTKn6v7hmHYjODpDI
         HIXHKMH5XjPI9oPxTNv6v0eLQmJD7eKl7yTuLAHWG8S4lqtDk1KD1esYp0XxNCig/8
         7GM+zzUb2ZQVsEl7cdE1D5WhfwnVcIghLuLVidCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0287/1073] clk: qcom: gcc-ipq806x: use parent_data for the last remaining entry
Date:   Wed, 28 Dec 2022 15:31:15 +0100
Message-Id: <20221228144335.813079812@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 55307e522cc7a4dddc3d231ca5cb7e68e9668f66 ]

Use parent_data for the last remaining entry (pll4). This clock is
provided by the lcc device.

Fixes: cb02866f9a74 ("clk: qcom: gcc-ipq806x: convert parent_names to parent_data")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220927113826.246241-3-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq806x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq806x.c b/drivers/clk/qcom/gcc-ipq806x.c
index 718de17a1e60..6447f3e81b55 100644
--- a/drivers/clk/qcom/gcc-ipq806x.c
+++ b/drivers/clk/qcom/gcc-ipq806x.c
@@ -79,7 +79,9 @@ static struct clk_regmap pll4_vote = {
 	.enable_mask = BIT(4),
 	.hw.init = &(struct clk_init_data){
 		.name = "pll4_vote",
-		.parent_names = (const char *[]){ "pll4" },
+		.parent_data = &(const struct clk_parent_data){
+			.fw_name = "pll4", .name = "pll4",
+		},
 		.num_parents = 1,
 		.ops = &clk_pll_vote_ops,
 	},
-- 
2.35.1



