Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BBA5FCF6D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJMASJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJMARe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:17:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1971504A9;
        Wed, 12 Oct 2022 17:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EAE8B81C48;
        Thu, 13 Oct 2022 00:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFD0C433C1;
        Thu, 13 Oct 2022 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620207;
        bh=Cs778EV16yW6rgUzQmQbbcwO76N19BWUWRroMVbo2DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXifm+q6OJQcS2d4qPiNIXGxwuuoMtFIR/FYb1xPLMTyBygwk3rNl875BEkZfi9xe
         kmMzeXT+k6BIHJJRXyxZS0hWTk+vWKYzO7gpsP/Tr7gOwXiuItZGMUwiRfsX6PrA4f
         aNH21mNEr9WZLHLhDA/obd/yWPjqDhtUSdHbbAkykAIKvUyJcJPJ50cCPrAKkAKElV
         xXenH4OgSwtjf70EncfuDqK9ubUnvSdb3Qr9NIkFb+TH5GpG2cqOdoobmDR291PxJW
         Sjgj1WLMkml/rJFLI/gzENSkn1wJzwAR3NlrHZJ/WjK/GIzTXryPFh2Memh2xW0w4z
         +1pMTGrrdUEiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        sboyd@kernel.org, linux-riscv@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 20/67] clk: microchip: mpfs: add MSS pll's set & round rate
Date:   Wed, 12 Oct 2022 20:15:01 -0400
Message-Id: <20221013001554.1892206-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 14016e4aafc5f157c10fb1a386fa3b3bd9c30e9a ]

The MSS pll is not a fixed frequency clock, so add set() & round_rate()
support.
Control is limited to a 7 bit output divider as other devices on the
FPGA occupy the other three outputs of the PLL & prevent changing
the multiplier.

Reviewed-by: Daire McNamara <daire.mcnamara@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220909123123.2699583-9-conor.dooley@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/microchip/clk-mpfs.c | 54 ++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/clk/microchip/clk-mpfs.c b/drivers/clk/microchip/clk-mpfs.c
index b6b89413e090..cb4ec4749279 100644
--- a/drivers/clk/microchip/clk-mpfs.c
+++ b/drivers/clk/microchip/clk-mpfs.c
@@ -126,8 +126,62 @@ static unsigned long mpfs_clk_msspll_recalc_rate(struct clk_hw *hw, unsigned lon
 	return prate * mult / (ref_div * MSSPLL_FIXED_DIV * postdiv);
 }
 
+static long mpfs_clk_msspll_round_rate(struct clk_hw *hw, unsigned long rate, unsigned long *prate)
+{
+	struct mpfs_msspll_hw_clock *msspll_hw = to_mpfs_msspll_clk(hw);
+	void __iomem *mult_addr = msspll_hw->base + msspll_hw->reg_offset;
+	void __iomem *ref_div_addr = msspll_hw->base + REG_MSSPLL_REF_CR;
+	u32 mult, ref_div;
+	unsigned long rate_before_ctrl;
+
+	mult = readl_relaxed(mult_addr) >> MSSPLL_FBDIV_SHIFT;
+	mult &= clk_div_mask(MSSPLL_FBDIV_WIDTH);
+	ref_div = readl_relaxed(ref_div_addr) >> MSSPLL_REFDIV_SHIFT;
+	ref_div &= clk_div_mask(MSSPLL_REFDIV_WIDTH);
+
+	rate_before_ctrl = rate * (ref_div * MSSPLL_FIXED_DIV) / mult;
+
+	return divider_round_rate(hw, rate_before_ctrl, prate, NULL, MSSPLL_POSTDIV_WIDTH,
+				  msspll_hw->flags);
+}
+
+static int mpfs_clk_msspll_set_rate(struct clk_hw *hw, unsigned long rate, unsigned long prate)
+{
+	struct mpfs_msspll_hw_clock *msspll_hw = to_mpfs_msspll_clk(hw);
+	void __iomem *mult_addr = msspll_hw->base + msspll_hw->reg_offset;
+	void __iomem *ref_div_addr = msspll_hw->base + REG_MSSPLL_REF_CR;
+	void __iomem *postdiv_addr = msspll_hw->base + REG_MSSPLL_POSTDIV_CR;
+	u32 mult, ref_div, postdiv;
+	int divider_setting;
+	unsigned long rate_before_ctrl, flags;
+
+	mult = readl_relaxed(mult_addr) >> MSSPLL_FBDIV_SHIFT;
+	mult &= clk_div_mask(MSSPLL_FBDIV_WIDTH);
+	ref_div = readl_relaxed(ref_div_addr) >> MSSPLL_REFDIV_SHIFT;
+	ref_div &= clk_div_mask(MSSPLL_REFDIV_WIDTH);
+
+	rate_before_ctrl = rate * (ref_div * MSSPLL_FIXED_DIV) / mult;
+	divider_setting = divider_get_val(rate_before_ctrl, prate, NULL, MSSPLL_POSTDIV_WIDTH,
+					  msspll_hw->flags);
+
+	if (divider_setting < 0)
+		return divider_setting;
+
+	spin_lock_irqsave(&mpfs_clk_lock, flags);
+
+	postdiv = readl_relaxed(postdiv_addr);
+	postdiv &= ~(clk_div_mask(MSSPLL_POSTDIV_WIDTH) << MSSPLL_POSTDIV_SHIFT);
+	writel_relaxed(postdiv, postdiv_addr);
+
+	spin_unlock_irqrestore(&mpfs_clk_lock, flags);
+
+	return 0;
+}
+
 static const struct clk_ops mpfs_clk_msspll_ops = {
 	.recalc_rate = mpfs_clk_msspll_recalc_rate,
+	.round_rate = mpfs_clk_msspll_round_rate,
+	.set_rate = mpfs_clk_msspll_set_rate,
 };
 
 #define CLK_PLL(_id, _name, _parent, _shift, _width, _flags, _offset) {			\
-- 
2.35.1

