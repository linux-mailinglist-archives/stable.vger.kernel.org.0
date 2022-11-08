Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9B621496
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiKHOCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiKHOCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:02:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D2E68689
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:02:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E516B816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C49BC433D7;
        Tue,  8 Nov 2022 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916169;
        bh=4f+pJjDppDQ/b2KjyXC+Px7FM7f230MtRT4I3oK4bOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djHpL7y5coM+zOVc0IoDwBiZPU+iMYSVygyeWyl6Jd2gfPloM3ACz9iPaSG8T5TEV
         AXvKssyHkb8rUxqNDVrzqGWy3OUvOXaV0j8huJaqaHXKb3AZRwbzusk0og/dzwwCYb
         yaSvXzYMjvS6FfRjab+F1dvBDM71CbTtxnIlhwTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Taniya Das <quic_tdas@quicinc.com>,
        Satya Priya <quic_c_skakit@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/144] clk: qcom: Update the force mem core bit for GPU clocks
Date:   Tue,  8 Nov 2022 14:39:21 +0100
Message-Id: <20221108133348.835187045@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit ffa20aa581cf5377fc397b0d0ff9d67ea823629b ]

There are few GPU clocks which are powering up the memories
and thus enable the FORCE_MEM_PERIPH always for these clocks
to force the periph_on signal to remain active during halt
state of the clock.

Fixes: a3cc092196ef ("clk: qcom: Add Global Clock controller (GCC) driver for SC7280")
Fixes: 3e0f01d6c7e7 ("clk: qcom: Add graphics clock controller driver for SC7280")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Satya Priya <quic_c_skakit@quicinc.com>
Link: https://lore.kernel.org/r/1666159535-6447-1-git-send-email-quic_c_skakit@quicinc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7280.c   | 1 +
 drivers/clk/qcom/gpucc-sc7280.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sc7280.c b/drivers/clk/qcom/gcc-sc7280.c
index ce7c5ba2b9b7..d10efbf260b7 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -3571,6 +3571,7 @@ static int gcc_sc7280_probe(struct platform_device *pdev)
 	regmap_update_bits(regmap, 0x28004, BIT(0), BIT(0));
 	regmap_update_bits(regmap, 0x28014, BIT(0), BIT(0));
 	regmap_update_bits(regmap, 0x71004, BIT(0), BIT(0));
+	regmap_update_bits(regmap, 0x7100C, BIT(13), BIT(13));
 
 	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
 			ARRAY_SIZE(gcc_dfs_clocks));
diff --git a/drivers/clk/qcom/gpucc-sc7280.c b/drivers/clk/qcom/gpucc-sc7280.c
index 9a832f2bcf49..1490cd45a654 100644
--- a/drivers/clk/qcom/gpucc-sc7280.c
+++ b/drivers/clk/qcom/gpucc-sc7280.c
@@ -463,6 +463,7 @@ static int gpu_cc_sc7280_probe(struct platform_device *pdev)
 	 */
 	regmap_update_bits(regmap, 0x1170, BIT(0), BIT(0));
 	regmap_update_bits(regmap, 0x1098, BIT(0), BIT(0));
+	regmap_update_bits(regmap, 0x1098, BIT(13), BIT(13));
 
 	return qcom_cc_really_probe(pdev, &gpu_cc_sc7280_desc, regmap);
 }
-- 
2.35.1



