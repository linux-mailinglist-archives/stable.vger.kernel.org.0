Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB9666CA65
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbjAPRDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbjAPRCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:02:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC27239BBF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99800B80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56FEC433D2;
        Mon, 16 Jan 2023 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887457;
        bh=arPXALtq5QnJ0rH90o5w1+pqIl20KHfLrfJNTDqKf70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCHcaz+AgibsDt26/yvuDL6rCddhQ2zO9oRN+/mClCnPS9FuOebEjGgu1M0SXp7cx
         Aokx0YboJtkj/gmMn/b9LtNZr967AwbROq2NyhR4KUsSDBKdwHI21c2utXjCZQgx7c
         NccoDI/CW6DbbJoHYHge1Vu10AuqmIPKIEYqo6qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephen Boyd <sboyd@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/521] clk: socfpga: use clk_hw_register for a5/c5
Date:   Mon, 16 Jan 2023 16:46:58 +0100
Message-Id: <20230116154854.212684538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-gate.c   | 11 +++++++----
 drivers/clk/socfpga/clk-periph.c |  8 ++++----
 drivers/clk/socfpga/clk-pll.c    | 18 +++++++++++-------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/socfpga/clk-gate.c b/drivers/clk/socfpga/clk-gate.c
index 14918896811d..139b009eda82 100644
--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -183,12 +183,13 @@ static void __init __socfpga_gate_init(struct device_node *node,
 	u32 div_reg[3];
 	u32 clk_phase[2];
 	u32 fixed_div;
-	struct clk *clk;
+	struct clk_hw *hw_clk;
 	struct socfpga_gate_clk *socfpga_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
 	struct clk_init_data init;
 	int rc;
+	int err;
 
 	socfpga_clk = kzalloc(sizeof(*socfpga_clk), GFP_KERNEL);
 	if (WARN_ON(!socfpga_clk))
@@ -237,12 +238,14 @@ static void __init __socfpga_gate_init(struct device_node *node,
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
index 52c883ea7706..912c3059cbe4 100644
--- a/drivers/clk/socfpga/clk-periph.c
+++ b/drivers/clk/socfpga/clk-periph.c
@@ -61,7 +61,7 @@ static __init void __socfpga_periph_init(struct device_node *node,
 	const struct clk_ops *ops)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_hw *hw_clk;
 	struct socfpga_periph_clk *periph_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
@@ -104,13 +104,13 @@ static __init void __socfpga_periph_init(struct device_node *node,
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
index 973c4713d085..7bde8ca45d4b 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -80,16 +80,18 @@ static struct clk_ops clk_pll_ops = {
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
 
@@ -117,13 +119,15 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 	clk_pll_ops.enable = clk_gate_ops.enable;
 	clk_pll_ops.disable = clk_gate_ops.disable;
 
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



