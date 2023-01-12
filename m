Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964E7667554
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbjALOUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbjALOTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00935D8BC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:11:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E5D662030
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5DAC433D2;
        Thu, 12 Jan 2023 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532695;
        bh=ZdvXnwWhF+izO8OYUPLj7DT8s+Ka6uVaC6gNMe1UG8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S34LaGb7npeUp7o6h/F8aI/cWzDDa3wYyvjKoF3Du+VSBJlsn0S6JBWYS85FiFCle
         FtsFt/W7ON0w17CNNUDcLFKNVWqO67Kc5PtHj+bP9FozynWOtYZrS45YbSugiIkRWK
         7YgxEGQBmQZ5uvj6Rpq6g67a6h5zQqCWjs8iJkC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephen Boyd <sboyd@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/783] clk: socfpga: use clk_hw_register for a5/c5
Date:   Thu, 12 Jan 2023 14:49:23 +0100
Message-Id: <20230112135535.851604298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 2c2b9c6067170de2a63e7e3d9f5bb205b870de7c ]

As recommended by Stephen Boyd, convert the cyclone5/arria5 clock driver
to use the clk_hw registration method.

Suggested-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210302214151.1333447-1-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 0b8ba891ad4d ("clk: socfpga: Fix memory leak in socfpga_gate_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-gate.c   | 11 +++++++----
 drivers/clk/socfpga/clk-periph.c |  8 ++++----
 drivers/clk/socfpga/clk-pll.c    | 18 +++++++++++-------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/socfpga/clk-gate.c b/drivers/clk/socfpga/clk-gate.c
index cf94a12459ea..1ec9678d8cd3 100644
--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -174,13 +174,14 @@ void __init socfpga_gate_init(struct device_node *node)
 	u32 div_reg[3];
 	u32 clk_phase[2];
 	u32 fixed_div;
-	struct clk *clk;
+	struct clk_hw *hw_clk;
 	struct socfpga_gate_clk *socfpga_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
 	struct clk_init_data init;
 	struct clk_ops *ops;
 	int rc;
+	int err;
 
 	socfpga_clk = kzalloc(sizeof(*socfpga_clk), GFP_KERNEL);
 	if (WARN_ON(!socfpga_clk))
@@ -238,12 +239,14 @@ void __init socfpga_gate_init(struct device_node *node)
 	init.parent_names = parent_name;
 	socfpga_clk->hw.hw.init = &init;
 
-	clk = clk_register(NULL, &socfpga_clk->hw.hw);
-	if (WARN_ON(IS_ERR(clk))) {
+	hw_clk = &socfpga_clk->hw.hw;
+
+	err = clk_hw_register(NULL, hw_clk);
+	if (err) {
 		kfree(socfpga_clk);
 		return;
 	}
-	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	rc = of_clk_add_provider(node, of_clk_src_simple_get, hw_clk);
 	if (WARN_ON(rc))
 		return;
 }
diff --git a/drivers/clk/socfpga/clk-periph.c b/drivers/clk/socfpga/clk-periph.c
index 5e0c4b45f77f..43707e2d7248 100644
--- a/drivers/clk/socfpga/clk-periph.c
+++ b/drivers/clk/socfpga/clk-periph.c
@@ -51,7 +51,7 @@ static __init void __socfpga_periph_init(struct device_node *node,
 	const struct clk_ops *ops)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_hw *hw_clk;
 	struct socfpga_periph_clk *periph_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
@@ -94,13 +94,13 @@ static __init void __socfpga_periph_init(struct device_node *node,
 	init.parent_names = parent_name;
 
 	periph_clk->hw.hw.init = &init;
+	hw_clk = &periph_clk->hw.hw;
 
-	clk = clk_register(NULL, &periph_clk->hw.hw);
-	if (WARN_ON(IS_ERR(clk))) {
+	if (clk_hw_register(NULL, hw_clk)) {
 		kfree(periph_clk);
 		return;
 	}
-	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	rc = of_clk_add_provider(node, of_clk_src_simple_get, hw_clk);
 }
 
 void __init socfpga_periph_init(struct device_node *node)
diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index 3cf99df7d005..dcb573d44034 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -70,16 +70,18 @@ static const struct clk_ops clk_pll_ops = {
 	.get_parent = clk_pll_get_parent,
 };
 
-static __init struct clk *__socfpga_pll_init(struct device_node *node,
+static __init struct clk_hw *__socfpga_pll_init(struct device_node *node,
 	const struct clk_ops *ops)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_hw *hw_clk;
 	struct socfpga_pll *pll_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
 	struct clk_init_data init;
 	struct device_node *clkmgr_np;
+	int rc;
+	int err;
 
 	of_property_read_u32(node, "reg", &reg);
 
@@ -105,13 +107,15 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 
 	pll_clk->hw.bit_idx = SOCFPGA_PLL_EXT_ENA;
 
-	clk = clk_register(NULL, &pll_clk->hw.hw);
-	if (WARN_ON(IS_ERR(clk))) {
+	hw_clk = &pll_clk->hw.hw;
+
+	err = clk_hw_register(NULL, hw_clk);
+	if (err) {
 		kfree(pll_clk);
-		return NULL;
+		return ERR_PTR(err);
 	}
-	of_clk_add_provider(node, of_clk_src_simple_get, clk);
-	return clk;
+	rc = of_clk_add_provider(node, of_clk_src_simple_get, hw_clk);
+	return hw_clk;
 }
 
 void __init socfpga_pll_init(struct device_node *node)
-- 
2.35.1



