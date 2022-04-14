Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007C250128D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbiDNOGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347226AbiDNN6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:58:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B7BB82E2;
        Thu, 14 Apr 2022 06:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F18BAB828F4;
        Thu, 14 Apr 2022 13:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA6FC385A1;
        Thu, 14 Apr 2022 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944151;
        bh=Sv+F4xpukFX5bchEpbGf4cv7MHzubjsajgK9G5MTDlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKXtLbmliTgO2EAehKBoG6e9Gpto8zTkIYwXv03o9+98JUUYykdPJfH+f61vXWhfH
         jDeG4F6Gr7LpoYN26/XHnWaxWqCoaqrlbntcHpiodg8YLXqXMU4KXxWDBPrLglv593
         1r8Zx0gygVC8x3QazxxrILhWRpgaFP1poGO9BCuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 412/475] clk: Enforce that disjoints limits are invalid
Date:   Thu, 14 Apr 2022 15:13:17 +0200
Message-Id: <20220414110906.594974640@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 10c46f2ea914202482d19cf80dcc9c321c9ff59b ]

If we were to have two users of the same clock, doing something like:

clk_set_rate_range(user1, 1000, 2000);
clk_set_rate_range(user2, 3000, 4000);

The second call would fail with -EINVAL, preventing from getting in a
situation where we end up with impossible limits.

However, this is never explicitly checked against and enforced, and
works by relying on an undocumented behaviour of clk_set_rate().

Indeed, on the first clk_set_rate_range will make sure the current clock
rate is within the new range, so it will be between 1000 and 2000Hz. On
the second clk_set_rate_range(), it will consider (rightfully), that our
current clock is outside of the 3000-4000Hz range, and will call
clk_core_set_rate_nolock() to set it to 3000Hz.

clk_core_set_rate_nolock() will then call clk_calc_new_rates() that will
eventually check that our rate 3000Hz rate is outside the min 3000Hz max
2000Hz range, will bail out, the error will propagate and we'll
eventually return -EINVAL.

This solely relies on the fact that clk_calc_new_rates(), and in
particular clk_core_determine_round_nolock(), won't modify the new rate
allowing the error to be reported. That assumption won't be true for all
drivers, and most importantly we'll break that assumption in a later
patch.

It can also be argued that we shouldn't even reach the point where we're
calling clk_core_set_rate_nolock().

Let's make an explicit check for disjoints range before we're doing
anything.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220225143534.405820-4-maxime@cerno.tech
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ccb26a513b29..13332f89e034 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -637,6 +637,24 @@ static void clk_core_get_boundaries(struct clk_core *core,
 		*max_rate = min(*max_rate, clk_user->max_rate);
 }
 
+static bool clk_core_check_boundaries(struct clk_core *core,
+				      unsigned long min_rate,
+				      unsigned long max_rate)
+{
+	struct clk *user;
+
+	lockdep_assert_held(&prepare_lock);
+
+	if (min_rate > core->max_rate || max_rate < core->min_rate)
+		return false;
+
+	hlist_for_each_entry(user, &core->clks, clks_node)
+		if (min_rate > user->max_rate || max_rate < user->min_rate)
+			return false;
+
+	return true;
+}
+
 void clk_hw_set_rate_range(struct clk_hw *hw, unsigned long min_rate,
 			   unsigned long max_rate)
 {
@@ -2306,6 +2324,11 @@ int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max)
 	clk->min_rate = min;
 	clk->max_rate = max;
 
+	if (!clk_core_check_boundaries(clk->core, min, max)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	rate = clk_core_get_rate_nolock(clk->core);
 	if (rate < min || rate > max) {
 		/*
@@ -2334,6 +2357,7 @@ int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max)
 		}
 	}
 
+out:
 	if (clk->exclusive_count)
 		clk_core_rate_protect(clk->core);
 
-- 
2.35.1



