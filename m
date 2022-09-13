Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E5B5B77BA
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiIMRU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiIMRUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:20:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8BC98751;
        Tue, 13 Sep 2022 09:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DC39614AC;
        Tue, 13 Sep 2022 14:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95564C433D6;
        Tue, 13 Sep 2022 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079440;
        bh=Nn3NzBaLXCqk2lY74BYrmbT2Hb8IDW52XsaI+OQO+8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCoWU42+TDvivWQS8u6ZUpD8Qzt/o2thVNlyCY4Zs3X77nBB21VyqGRLB+iyHx8io
         iaNSabtmIh+QYB9/AvZxWPGTm1jyrLgq8bzoogovUpd2DyceYDMuJW/x7/9D4PgMIO
         YgR3L2tKcKXnb4cHGmh3OCrtzLdkkx0EDsZJoOro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/79] Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops"
Date:   Tue, 13 Sep 2022 16:06:45 +0200
Message-Id: <20220913140350.207594033@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit abb5f3f4b1f5f0ad50eb067a00051d3587dec9fb ]

This reverts commit 35b0fac808b95eea1212f8860baf6ad25b88b087. Alexander
reports that it causes boot failures on i.MX8M Plus based boards
(specifically imx8mp-tqma8mpql-mba8mpxl.dts).

Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: Chen-Yu Tsai <wenst@chromium.org>
Fixes: 35b0fac808b9 ("clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops")
Link: https://lore.kernel.org/r/12115951.O9o76ZdvQC@steina-w
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20220831175326.2523912-1-sboyd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4021c7c10c8d9..32606d1094fe4 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -196,9 +196,6 @@ static bool clk_core_rate_is_protected(struct clk_core *core)
 	return core->protect_count;
 }
 
-static int clk_core_prepare_enable(struct clk_core *core);
-static void clk_core_disable_unprepare(struct clk_core *core);
-
 static bool clk_core_is_prepared(struct clk_core *core)
 {
 	bool ret = false;
@@ -211,11 +208,7 @@ static bool clk_core_is_prepared(struct clk_core *core)
 		return core->prepare_count;
 
 	if (!clk_pm_runtime_get(core)) {
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_prepare_enable(core->parent);
 		ret = core->ops->is_prepared(core->hw);
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_disable_unprepare(core->parent);
 		clk_pm_runtime_put(core);
 	}
 
@@ -251,13 +244,7 @@ static bool clk_core_is_enabled(struct clk_core *core)
 		}
 	}
 
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_prepare_enable(core->parent);
-
 	ret = core->ops->is_enabled(core->hw);
-
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_disable_unprepare(core->parent);
 done:
 	if (core->dev)
 		pm_runtime_put(core->dev);
@@ -717,9 +704,6 @@ int clk_rate_exclusive_get(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_rate_exclusive_get);
 
-static int clk_core_enable_lock(struct clk_core *core);
-static void clk_core_disable_lock(struct clk_core *core);
-
 static void clk_core_unprepare(struct clk_core *core)
 {
 	lockdep_assert_held(&prepare_lock);
@@ -743,9 +727,6 @@ static void clk_core_unprepare(struct clk_core *core)
 
 	WARN(core->enable_count > 0, "Unpreparing enabled %s\n", core->name);
 
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_enable_lock(core->parent);
-
 	trace_clk_unprepare(core);
 
 	if (core->ops->unprepare)
@@ -754,9 +735,6 @@ static void clk_core_unprepare(struct clk_core *core)
 	clk_pm_runtime_put(core);
 
 	trace_clk_unprepare_complete(core);
-
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_disable_lock(core->parent);
 	clk_core_unprepare(core->parent);
 }
 
@@ -805,9 +783,6 @@ static int clk_core_prepare(struct clk_core *core)
 		if (ret)
 			goto runtime_put;
 
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_enable_lock(core->parent);
-
 		trace_clk_prepare(core);
 
 		if (core->ops->prepare)
@@ -815,9 +790,6 @@ static int clk_core_prepare(struct clk_core *core)
 
 		trace_clk_prepare_complete(core);
 
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_disable_lock(core->parent);
-
 		if (ret)
 			goto unprepare;
 	}
-- 
2.35.1



