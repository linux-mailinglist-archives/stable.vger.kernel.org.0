Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEF35AE9E4
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbiIFNfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240122AbiIFNeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:34:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB39E7757D;
        Tue,  6 Sep 2022 06:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3301161512;
        Tue,  6 Sep 2022 13:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E779C433D6;
        Tue,  6 Sep 2022 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471206;
        bh=83qqt59/EoIM9KBwWL3sDawlNWTFxNDLDFaakOT0B5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsFFO3VvQ4jFHmtHMSb63XNIuyagnaeOo0S5WfKjwqBvt44woiiIfVKz7U8tIr2JG
         +zyeclf+PQEyTP6krmOYMW5b3CMTs3sLAB/lPPn/CCtFKmkFXklxNPfKN5ksrlp2K9
         vKwraN2161w4NHsA2gK1Uj/UmPG/N1OZYX8454s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/80] clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops
Date:   Tue,  6 Sep 2022 15:30:31 +0200
Message-Id: <20220906132818.398908085@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 35b0fac808b95eea1212f8860baf6ad25b88b087 ]

In the previous commits that added CLK_OPS_PARENT_ENABLE, support for
this flag was only added to rate change operations (rate setting and
reparent) and disabling unused subtree. It was not added to the
clock gate related operations. Any hardware driver that needs it for
these operations will either see bogus results, or worse, hang.

This has been seen on MT8192 and MT8195, where the imp_ii2_* clk
drivers set this, but dumping debugfs clk_summary would cause it
to hang.

Fixes: fc8726a2c021 ("clk: core: support clocks which requires parents enable (part 2)")
Fixes: a4b3518d146f ("clk: core: support clocks which requires parents enable (part 1)")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20220822081424.1310926-2-wenst@chromium.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2e56cc0a3bce6..4f20d5318183f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -203,6 +203,9 @@ static bool clk_core_rate_is_protected(struct clk_core *core)
 	return core->protect_count;
 }
 
+static int clk_core_prepare_enable(struct clk_core *core);
+static void clk_core_disable_unprepare(struct clk_core *core);
+
 static bool clk_core_is_prepared(struct clk_core *core)
 {
 	bool ret = false;
@@ -215,7 +218,11 @@ static bool clk_core_is_prepared(struct clk_core *core)
 		return core->prepare_count;
 
 	if (!clk_pm_runtime_get(core)) {
+		if (core->flags & CLK_OPS_PARENT_ENABLE)
+			clk_core_prepare_enable(core->parent);
 		ret = core->ops->is_prepared(core->hw);
+		if (core->flags & CLK_OPS_PARENT_ENABLE)
+			clk_core_disable_unprepare(core->parent);
 		clk_pm_runtime_put(core);
 	}
 
@@ -251,7 +258,13 @@ static bool clk_core_is_enabled(struct clk_core *core)
 		}
 	}
 
+	if (core->flags & CLK_OPS_PARENT_ENABLE)
+		clk_core_prepare_enable(core->parent);
+
 	ret = core->ops->is_enabled(core->hw);
+
+	if (core->flags & CLK_OPS_PARENT_ENABLE)
+		clk_core_disable_unprepare(core->parent);
 done:
 	if (core->rpm_enabled)
 		pm_runtime_put(core->dev);
@@ -818,6 +831,9 @@ int clk_rate_exclusive_get(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_rate_exclusive_get);
 
+static int clk_core_enable_lock(struct clk_core *core);
+static void clk_core_disable_lock(struct clk_core *core);
+
 static void clk_core_unprepare(struct clk_core *core)
 {
 	lockdep_assert_held(&prepare_lock);
@@ -841,6 +857,9 @@ static void clk_core_unprepare(struct clk_core *core)
 
 	WARN(core->enable_count > 0, "Unpreparing enabled %s\n", core->name);
 
+	if (core->flags & CLK_OPS_PARENT_ENABLE)
+		clk_core_enable_lock(core->parent);
+
 	trace_clk_unprepare(core);
 
 	if (core->ops->unprepare)
@@ -849,6 +868,9 @@ static void clk_core_unprepare(struct clk_core *core)
 	clk_pm_runtime_put(core);
 
 	trace_clk_unprepare_complete(core);
+
+	if (core->flags & CLK_OPS_PARENT_ENABLE)
+		clk_core_disable_lock(core->parent);
 	clk_core_unprepare(core->parent);
 }
 
@@ -897,6 +919,9 @@ static int clk_core_prepare(struct clk_core *core)
 		if (ret)
 			goto runtime_put;
 
+		if (core->flags & CLK_OPS_PARENT_ENABLE)
+			clk_core_enable_lock(core->parent);
+
 		trace_clk_prepare(core);
 
 		if (core->ops->prepare)
@@ -904,6 +929,9 @@ static int clk_core_prepare(struct clk_core *core)
 
 		trace_clk_prepare_complete(core);
 
+		if (core->flags & CLK_OPS_PARENT_ENABLE)
+			clk_core_disable_lock(core->parent);
+
 		if (ret)
 			goto unprepare;
 	}
-- 
2.35.1



