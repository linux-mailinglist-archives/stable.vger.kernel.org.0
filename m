Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE904F3EA2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382639AbiDEMQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbiDEKdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:33:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA52EDEBAA;
        Tue,  5 Apr 2022 03:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9378DB81C98;
        Tue,  5 Apr 2022 10:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9118C385A2;
        Tue,  5 Apr 2022 10:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153943;
        bh=3U84Y6ErdSAebcdArryxPmDUd40rXwenPtklL9WgMI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fc5G3hyvWqiqbDJ6Tvblb63Vyzci7vz7iWqRenzpjW6cggPKVvP08qVOjIBKM8DeE
         iPDTnV91cqbRPLtb5N8FvS1BhRPWo8I9J3p+S2LwTJxjCW3A/iTnhBZGgx35Y06nPc
         /AM69zLhjL9rWws+aJO4bhJZH0Z4Ctk2rriZ16C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/599] clk: qcom: clk-rcg2: Update logic to calculate D value for RCG
Date:   Tue,  5 Apr 2022 09:31:36 +0200
Message-Id: <20220405070310.794436943@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit 58922910add18583d5273c2edcdb9fd7bf4eca02 ]

The display pixel clock has a requirement on certain newer platforms to
support M/N as (2/3) and the final D value calculated results in
underflow errors.
As the current implementation does not check for D value is within
the accepted range for a given M & N value. Update the logic to
calculate the final D value based on the range.

Fixes: 99cbd064b059f ("clk: qcom: Support display RCG clocks")
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220227175536.3131-1-tdas@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 59a5a0f261f3..ec2746fd00da 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -264,7 +264,7 @@ static int clk_rcg2_determine_floor_rate(struct clk_hw *hw,
 
 static int __clk_rcg2_configure(struct clk_rcg2 *rcg, const struct freq_tbl *f)
 {
-	u32 cfg, mask;
+	u32 cfg, mask, d_val, not2d_val, n_minus_m;
 	struct clk_hw *hw = &rcg->clkr.hw;
 	int ret, index = qcom_find_src_index(hw, rcg->parent_map, f->src);
 
@@ -283,8 +283,17 @@ static int __clk_rcg2_configure(struct clk_rcg2 *rcg, const struct freq_tbl *f)
 		if (ret)
 			return ret;
 
+		/* Calculate 2d value */
+		d_val = f->n;
+
+		n_minus_m = f->n - f->m;
+		n_minus_m *= 2;
+
+		d_val = clamp_t(u32, d_val, f->m, n_minus_m);
+		not2d_val = ~d_val & mask;
+
 		ret = regmap_update_bits(rcg->clkr.regmap,
-				RCG_D_OFFSET(rcg), mask, ~f->n);
+				RCG_D_OFFSET(rcg), mask, not2d_val);
 		if (ret)
 			return ret;
 	}
-- 
2.34.1



