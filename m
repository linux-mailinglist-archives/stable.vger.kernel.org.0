Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499BA5B724C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiIMOwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbiIMOvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:51:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D343872863;
        Tue, 13 Sep 2022 07:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 510E2B80F1A;
        Tue, 13 Sep 2022 14:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABED5C433D7;
        Tue, 13 Sep 2022 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079179;
        bh=10d/q8SNSvzXv8Z8bJl0RD3ga6GIIhQtlqHiU94Pk90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Otj/dHnsxF0r6hZSbmWHu9R+29NfyCzI1cDMXTXjXP3G8fLzl5BeVAm7JZ3L0bkI4
         7FT1aaFONJgzoFZCj37ox0OTXaEXIM0yALgIPTgVF/3TArzebLj8VRsU6w47NZTP3A
         F1sQblu/BXCtI2ho41WrmpqtUpG48nY4kQxiGW0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/108] clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops
Date:   Tue, 13 Sep 2022 16:06:05 +0200
Message-Id: <20220913140355.111103461@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
index 13332f89e034b..c5f7a9f9c6c0e 100644
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
@@ -824,6 +837,9 @@ int clk_rate_exclusive_get(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_rate_exclusive_get);
 
+static int clk_core_enable_lock(struct clk_core *core);
+static void clk_core_disable_lock(struct clk_core *core);
+
 static void clk_core_unprepare(struct clk_core *core)
 {
 	lockdep_assert_held(&prepare_lock);
@@ -847,6 +863,9 @@ static void clk_core_unprepare(struct clk_core *core)
 
 	WARN(core->enable_count > 0, "Unpreparing enabled %s\n", core->name);
 
+	if (core->flags & CLK_OPS_PARENT_ENABLE)
+		clk_core_enable_lock(core->parent);
+
 	trace_clk_unprepare(core);
 
 	if (core->ops->unprepare)
@@ -855,6 +874,9 @@ static void clk_core_unprepare(struct clk_core *core)
 	clk_pm_runtime_put(core);
 
 	trace_clk_unprepare_complete(core);
+
+	if (core->flags & CLK_OPS_PARENT_ENABLE)
+		clk_core_disable_lock(core->parent);
 	clk_core_unprepare(core->parent);
 }
 
@@ -903,6 +925,9 @@ static int clk_core_prepare(struct clk_core *core)
 		if (ret)
 			goto runtime_put;
 
+		if (core->flags & CLK_OPS_PARENT_ENABLE)
+			clk_core_enable_lock(core->parent);
+
 		trace_clk_prepare(core);
 
 		if (core->ops->prepare)
@@ -910,6 +935,9 @@ static int clk_core_prepare(struct clk_core *core)
 
 		trace_clk_prepare_complete(core);
 
+		if (core->flags & CLK_OPS_PARENT_ENABLE)
+			clk_core_disable_lock(core->parent);
+
 		if (ret)
 			goto unprepare;
 	}
-- 
2.35.1



