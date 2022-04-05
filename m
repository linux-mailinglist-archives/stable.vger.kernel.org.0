Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCC84F32FA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbiDEIe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbiDEIUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68AA939A7;
        Tue,  5 Apr 2022 01:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E102B81BAC;
        Tue,  5 Apr 2022 08:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2428C385A1;
        Tue,  5 Apr 2022 08:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146397;
        bh=k2E3ZEIeZsl/3Wg7OEWzS+F8ELAOmyjo1IPyJCH3edU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7hhs7L7j3C5RRUf8zwQe3p7TyDnbHXOIHX/a0SJvkgBNC2tnPhfvyNnfYznQ9d56
         KAPRvBwfuda4bCsIj5HELKh9PI28FjTQYhWGTBZIMmmHUtY6YEXyRMHrBZ1NeMEhia
         w59Jt76bVAcFKgGMXNxe5GtOi37dB8u45HKz4c5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emil Renner Berthing <kernel@esmil.dk>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0748/1126] clk: starfive: jh7100: Dont round divisor up twice
Date:   Tue,  5 Apr 2022 09:24:55 +0200
Message-Id: <20220405070429.538925033@linuxfoundation.org>
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

[ Upstream commit 40dda3532f903107a063cd6ec1f15e10dd0eccc5 ]

The problem is best illustrated by an example. Suppose a consumer wants
a 4MHz clock rate from a divider with a 10MHz parent. It would then
call

  clk_round_rate(clk, 4000000)

which would call into our determine_rate() callback that correctly
rounds up and finds that a divisor of 3 gives the highest possible
frequency below the requested 4MHz and returns 10000000 / 3 = 3333333Hz.

However the consumer would then call

  clk_set_rate(clk, 3333333)

but since 3333333 doesn't divide 10000000 evenly our set_rate() callback
would again round the divisor up and set it to 4 which results in an
unnecessarily low rate of 2.5MHz.

Fix it by using DIV_ROUND_CLOSEST in the set_rate() callback.

Fixes: 4210be668a09 ("clk: starfive: Add JH7100 clock generator driver")
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Link: https://lore.kernel.org/r/20220126173953.1016706-2-kernel@esmil.dk
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7100.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7100.c b/drivers/clk/starfive/clk-starfive-jh7100.c
index 25d31afa0f87..db6a4dc203af 100644
--- a/drivers/clk/starfive/clk-starfive-jh7100.c
+++ b/drivers/clk/starfive/clk-starfive-jh7100.c
@@ -399,22 +399,13 @@ static unsigned long jh7100_clk_recalc_rate(struct clk_hw *hw,
 	return div ? parent_rate / div : 0;
 }
 
-static unsigned long jh7100_clk_bestdiv(struct jh7100_clk *clk,
-					unsigned long rate, unsigned long parent)
-{
-	unsigned long max = clk->max_div;
-	unsigned long div = DIV_ROUND_UP(parent, rate);
-
-	return min(div, max);
-}
-
 static int jh7100_clk_determine_rate(struct clk_hw *hw,
 				     struct clk_rate_request *req)
 {
 	struct jh7100_clk *clk = jh7100_clk_from(hw);
 	unsigned long parent = req->best_parent_rate;
 	unsigned long rate = clamp(req->rate, req->min_rate, req->max_rate);
-	unsigned long div = jh7100_clk_bestdiv(clk, rate, parent);
+	unsigned long div = min_t(unsigned long, DIV_ROUND_UP(parent, rate), clk->max_div);
 	unsigned long result = parent / div;
 
 	/*
@@ -442,7 +433,8 @@ static int jh7100_clk_set_rate(struct clk_hw *hw,
 			       unsigned long parent_rate)
 {
 	struct jh7100_clk *clk = jh7100_clk_from(hw);
-	unsigned long div = jh7100_clk_bestdiv(clk, rate, parent_rate);
+	unsigned long div = clamp(DIV_ROUND_CLOSEST(parent_rate, rate),
+				  1UL, (unsigned long)clk->max_div);
 
 	jh7100_clk_reg_rmw(clk, JH7100_CLK_DIV_MASK, div);
 	return 0;
-- 
2.34.1



