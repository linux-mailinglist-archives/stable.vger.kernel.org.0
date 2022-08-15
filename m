Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D901594B56
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352052AbiHPAOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357425AbiHPANe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:13:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BC4CD51A;
        Mon, 15 Aug 2022 13:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B575D61057;
        Mon, 15 Aug 2022 20:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA0C433C1;
        Mon, 15 Aug 2022 20:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595414;
        bh=EIFqnLnUM23Nz1J6+mXn0fbS1tnry5gPG/oOFxiGxUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txAVAFKhgzKkaIy0JND9D4xSMuZgwfHuT8P+nK5NxphYwQIL6av1P+UnB/AY4Pb6u
         8bDu/mhljj9dg/ToyHnAtyelvhfX9FHweeSsmV8j0ntOomGtPFoDIyoX9yOuxc45+S
         PFfsDlimVHkohn0maM4PWVjpTjBnWnZlgnpvo+tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0755/1157] clk: qcom: ipq8074: fix NSS core PLL-s
Date:   Mon, 15 Aug 2022 20:01:51 +0200
Message-Id: <20220815180509.711110862@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit ca41ec1b30434636c56c5600b24a8d964d359d9c ]

Like in IPQ6018 the NSS related Alpha PLL-s require initial configuration
to work.

So, obtain the regmap that is required for the Alpha PLL configuration
and thus utilize the qcom_cc_really_probe() as we already have the regmap.
Then utilize the Alpha PLL configs from the downstream QCA 5.4 based
kernel to configure them.

This fixes the UBI32 and NSS crypto PLL-s failing to get enabled by the
kernel.

Fixes: b8e7e519625f ("clk: qcom: ipq8074: add remaining PLL’s")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220515210048.483898-1-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 39 +++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index 541016db3c4b..1a5141da7e23 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -4371,6 +4371,33 @@ static struct clk_branch gcc_pcie0_axi_s_bridge_clk = {
 	},
 };
 
+static const struct alpha_pll_config ubi32_pll_config = {
+	.l = 0x4e,
+	.config_ctl_val = 0x200d4aa8,
+	.config_ctl_hi_val = 0x3c2,
+	.main_output_mask = BIT(0),
+	.aux_output_mask = BIT(1),
+	.pre_div_val = 0x0,
+	.pre_div_mask = BIT(12),
+	.post_div_val = 0x0,
+	.post_div_mask = GENMASK(9, 8),
+};
+
+static const struct alpha_pll_config nss_crypto_pll_config = {
+	.l = 0x3e,
+	.alpha = 0x0,
+	.alpha_hi = 0x80,
+	.config_ctl_val = 0x4001055b,
+	.main_output_mask = BIT(0),
+	.pre_div_val = 0x0,
+	.pre_div_mask = GENMASK(14, 12),
+	.post_div_val = 0x1 << 8,
+	.post_div_mask = GENMASK(11, 8),
+	.vco_mask = GENMASK(21, 20),
+	.vco_val = 0x0,
+	.alpha_en_mask = BIT(24),
+};
+
 static struct clk_hw *gcc_ipq8074_hws[] = {
 	&gpll0_out_main_div2.hw,
 	&gpll6_out_main_div2.hw,
@@ -4772,7 +4799,17 @@ static const struct qcom_cc_desc gcc_ipq8074_desc = {
 
 static int gcc_ipq8074_probe(struct platform_device *pdev)
 {
-	return qcom_cc_probe(pdev, &gcc_ipq8074_desc);
+	struct regmap *regmap;
+
+	regmap = qcom_cc_map(pdev, &gcc_ipq8074_desc);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	clk_alpha_pll_configure(&ubi32_pll_main, regmap, &ubi32_pll_config);
+	clk_alpha_pll_configure(&nss_crypto_pll_main, regmap,
+				&nss_crypto_pll_config);
+
+	return qcom_cc_really_probe(pdev, &gcc_ipq8074_desc, regmap);
 }
 
 static struct platform_driver gcc_ipq8074_driver = {
-- 
2.35.1



