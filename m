Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FCF5B7808
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiIMRcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiIMRcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:32:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AD29BB43;
        Tue, 13 Sep 2022 09:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FC93B80F2B;
        Tue, 13 Sep 2022 14:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCC4C433C1;
        Tue, 13 Sep 2022 14:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079181;
        bh=5q44jIGX0gHxaxWoX9GdQLZNrJKpBHzXHGwNB0CLKKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dP0fQCBWZzvjvF/8ram6tyF9/nKiklYzASgcq8rJnAwXQAdaXBwIsq6J/uNNu9yrW
         qv3XxwesCjtAKLVNSfm3A+Oepa6at3Qf/EhUL1l3I3HNELmwu5R+qkw6eUUKDiboVf
         z9sVNDFmJ2OEceSQEugMFMoKPiZXQ0u2TFrtoQgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/108] Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops"
Date:   Tue, 13 Sep 2022 16:06:06 +0200
Message-Id: <20220913140355.156508103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
index c5f7a9f9c6c0e..13332f89e034b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -203,9 +203,6 @@ static bool clk_core_rate_is_protected(struct clk_core *core)
 	return core->protect_count;
 }
 
-static int clk_core_prepare_enable(struct clk_core *core);
-static void clk_core_disable_unprepare(struct clk_core *core);
-
 static bool clk_core_is_prepared(struct clk_core *core)
 {
 	bool ret = false;
@@ -218,11 +215,7 @@ static bool clk_core_is_prepared(struct clk_core *core)
 		return core->prepare_count;
 
 	if (!clk_pm_runtime_get(core)) {
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_prepare_enable(core->parent);
 		ret = core->ops->is_prepared(core->hw);
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_disable_unprepare(core->parent);
 		clk_pm_runtime_put(core);
 	}
 
@@ -258,13 +251,7 @@ static bool clk_core_is_enabled(struct clk_core *core)
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
 	if (core->rpm_enabled)
 		pm_runtime_put(core->dev);
@@ -837,9 +824,6 @@ int clk_rate_exclusive_get(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_rate_exclusive_get);
 
-static int clk_core_enable_lock(struct clk_core *core);
-static void clk_core_disable_lock(struct clk_core *core);
-
 static void clk_core_unprepare(struct clk_core *core)
 {
 	lockdep_assert_held(&prepare_lock);
@@ -863,9 +847,6 @@ static void clk_core_unprepare(struct clk_core *core)
 
 	WARN(core->enable_count > 0, "Unpreparing enabled %s\n", core->name);
 
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_enable_lock(core->parent);
-
 	trace_clk_unprepare(core);
 
 	if (core->ops->unprepare)
@@ -874,9 +855,6 @@ static void clk_core_unprepare(struct clk_core *core)
 	clk_pm_runtime_put(core);
 
 	trace_clk_unprepare_complete(core);
-
-	if (core->flags & CLK_OPS_PARENT_ENABLE)
-		clk_core_disable_lock(core->parent);
 	clk_core_unprepare(core->parent);
 }
 
@@ -925,9 +903,6 @@ static int clk_core_prepare(struct clk_core *core)
 		if (ret)
 			goto runtime_put;
 
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_enable_lock(core->parent);
-
 		trace_clk_prepare(core);
 
 		if (core->ops->prepare)
@@ -935,9 +910,6 @@ static int clk_core_prepare(struct clk_core *core)
 
 		trace_clk_prepare_complete(core);
 
-		if (core->flags & CLK_OPS_PARENT_ENABLE)
-			clk_core_disable_lock(core->parent);
-
 		if (ret)
 			goto unprepare;
 	}
-- 
2.35.1



