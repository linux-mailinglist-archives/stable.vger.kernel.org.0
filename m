Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6DD4F32EF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbiDEI1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239437AbiDEIUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FA6939AB;
        Tue,  5 Apr 2022 01:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0905EB81BB1;
        Tue,  5 Apr 2022 08:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0C8C385A0;
        Tue,  5 Apr 2022 08:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146399;
        bh=8cgWBohA+cj8EE+ROj+0XncNUlSbVJD2OmXepjRx8js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tEAwUxW4ybCYZ7lAGzVq4B+ztx/Q8uYzfZWyO4Ij2OVNAUMe0Cuis3XQSsvwbSD6
         yeFWfhNmvfGOiwPCszFtuMJz95OURHeHIl0aWZqYwvXlogJYoKtQ+f7B0hExYUvlyt
         cKJK+zWWn4SEW0VS/19GXtFfo5V2uzoqbrN0oNeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emil Renner Berthing <kernel@esmil.dk>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0749/1126] clk: starfive: jh7100: Handle audio_div clock properly
Date:   Tue,  5 Apr 2022 09:24:56 +0200
Message-Id: <20220405070429.568609689@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Emil Renner Berthing <kernel@esmil.dk>

[ Upstream commit 73bfc8d745a98744088cb30517399222674455b1 ]

It turns out the audio_div clock is a fractional divider where the
lowest byte of the ctrl register is the integer part of the divider and
the 2nd byte is the number of 100th added to the divider.

The children of this clock is used by the audio peripherals for their
sample rate clock, so round to the closest possible rate rather than
always rounding down like regular dividers.

Fixes: 4210be668a09 ("clk: starfive: Add JH7100 clock generator driver")
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Link: https://lore.kernel.org/r/20220126173953.1016706-3-kernel@esmil.dk
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7100.c | 68 +++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7100.c b/drivers/clk/starfive/clk-starfive-jh7100.c
index db6a4dc203af..4b59338b5d7d 100644
--- a/drivers/clk/starfive/clk-starfive-jh7100.c
+++ b/drivers/clk/starfive/clk-starfive-jh7100.c
@@ -32,6 +32,13 @@
 #define JH7100_CLK_MUX_MASK	GENMASK(27, 24)
 #define JH7100_CLK_MUX_SHIFT	24
 #define JH7100_CLK_DIV_MASK	GENMASK(23, 0)
+#define JH7100_CLK_FRAC_MASK	GENMASK(15, 8)
+#define JH7100_CLK_FRAC_SHIFT	8
+#define JH7100_CLK_INT_MASK	GENMASK(7, 0)
+
+/* fractional divider min/max */
+#define JH7100_CLK_FRAC_MIN	100UL
+#define JH7100_CLK_FRAC_MAX	25599UL
 
 /* clock data */
 #define JH7100_GATE(_idx, _name, _flags, _parent) [_idx] = {		\
@@ -55,6 +62,13 @@
 	.parents = { [0] = _parent },					\
 }
 
+#define JH7100_FDIV(_idx, _name, _parent) [_idx] = {			\
+	.name = _name,							\
+	.flags = 0,							\
+	.max = JH7100_CLK_FRAC_MAX,					\
+	.parents = { [0] = _parent },					\
+}
+
 #define JH7100__MUX(_idx, _name, _nparents, ...) [_idx] = {		\
 	.name = _name,							\
 	.flags = 0,							\
@@ -225,7 +239,7 @@ static const struct {
 	JH7100__MUX(JH7100_CLK_USBPHY_25M, "usbphy_25m", 2,
 		    JH7100_CLK_OSC_SYS,
 		    JH7100_CLK_USBPHY_PLLDIV25M),
-	JH7100__DIV(JH7100_CLK_AUDIO_DIV, "audio_div", 131072, JH7100_CLK_AUDIO_ROOT),
+	JH7100_FDIV(JH7100_CLK_AUDIO_DIV, "audio_div", JH7100_CLK_AUDIO_ROOT),
 	JH7100_GATE(JH7100_CLK_AUDIO_SRC, "audio_src", 0, JH7100_CLK_AUDIO_DIV),
 	JH7100_GATE(JH7100_CLK_AUDIO_12288, "audio_12288", 0, JH7100_CLK_OSC_AUD),
 	JH7100_GDIV(JH7100_CLK_VIN_SRC, "vin_src", 0, 4, JH7100_CLK_VIN_ROOT),
@@ -440,6 +454,49 @@ static int jh7100_clk_set_rate(struct clk_hw *hw,
 	return 0;
 }
 
+static unsigned long jh7100_clk_frac_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct jh7100_clk *clk = jh7100_clk_from(hw);
+	u32 reg = jh7100_clk_reg_get(clk);
+	unsigned long div100 = 100 * (reg & JH7100_CLK_INT_MASK) +
+			       ((reg & JH7100_CLK_FRAC_MASK) >> JH7100_CLK_FRAC_SHIFT);
+
+	return (div100 >= JH7100_CLK_FRAC_MIN) ? 100 * parent_rate / div100 : 0;
+}
+
+static int jh7100_clk_frac_determine_rate(struct clk_hw *hw,
+					  struct clk_rate_request *req)
+{
+	unsigned long parent100 = 100 * req->best_parent_rate;
+	unsigned long rate = clamp(req->rate, req->min_rate, req->max_rate);
+	unsigned long div100 = clamp(DIV_ROUND_CLOSEST(parent100, rate),
+				     JH7100_CLK_FRAC_MIN, JH7100_CLK_FRAC_MAX);
+	unsigned long result = parent100 / div100;
+
+	/* clamp the result as in jh7100_clk_determine_rate() above */
+	if (result > req->max_rate && div100 < JH7100_CLK_FRAC_MAX)
+		result = parent100 / (div100 + 1);
+	if (result < req->min_rate && div100 > JH7100_CLK_FRAC_MIN)
+		result = parent100 / (div100 - 1);
+
+	req->rate = result;
+	return 0;
+}
+
+static int jh7100_clk_frac_set_rate(struct clk_hw *hw,
+				    unsigned long rate,
+				    unsigned long parent_rate)
+{
+	struct jh7100_clk *clk = jh7100_clk_from(hw);
+	unsigned long div100 = clamp(DIV_ROUND_CLOSEST(100 * parent_rate, rate),
+				     JH7100_CLK_FRAC_MIN, JH7100_CLK_FRAC_MAX);
+	u32 value = ((div100 % 100) << JH7100_CLK_FRAC_SHIFT) | (div100 / 100);
+
+	jh7100_clk_reg_rmw(clk, JH7100_CLK_DIV_MASK, value);
+	return 0;
+}
+
 static u8 jh7100_clk_get_parent(struct clk_hw *hw)
 {
 	struct jh7100_clk *clk = jh7100_clk_from(hw);
@@ -526,6 +583,13 @@ static const struct clk_ops jh7100_clk_div_ops = {
 	.debug_init = jh7100_clk_debug_init,
 };
 
+static const struct clk_ops jh7100_clk_fdiv_ops = {
+	.recalc_rate = jh7100_clk_frac_recalc_rate,
+	.determine_rate = jh7100_clk_frac_determine_rate,
+	.set_rate = jh7100_clk_frac_set_rate,
+	.debug_init = jh7100_clk_debug_init,
+};
+
 static const struct clk_ops jh7100_clk_gdiv_ops = {
 	.enable = jh7100_clk_enable,
 	.disable = jh7100_clk_disable,
@@ -564,6 +628,8 @@ static const struct clk_ops *__init jh7100_clk_ops(u32 max)
 	if (max & JH7100_CLK_DIV_MASK) {
 		if (max & JH7100_CLK_ENABLE)
 			return &jh7100_clk_gdiv_ops;
+		if (max == JH7100_CLK_FRAC_MAX)
+			return &jh7100_clk_fdiv_ops;
 		return &jh7100_clk_div_ops;
 	}
 
-- 
2.34.1



