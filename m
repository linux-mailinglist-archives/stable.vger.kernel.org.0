Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1737BCDE3
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410250AbfIXQrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729230AbfIXQrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:47:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A73B21D6C;
        Tue, 24 Sep 2019 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343622;
        bh=vw8QC3vuvRyhhmM7FsufE5EY78S4mly+jhmZczP11nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLp4lJhWRHW07vopYWLnSx8oUmJmB6wReH8Uxs/i5gVreLqprlokktpbPlFJ5nMW+
         Dde47oTWF6RrjFfiF8+VuP2+5KaTz58Ldva60d6Rl3/EmOPkX+3jAJmgQGEjCF12/u
         MWjWrGg0I+BUqOzaVT5xqyJMISzpKtZWQIhG5mvI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <sboyd@kernel.org>, Jun Nie <jun.nie@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 31/70] clk: zx296718: Don't reference clk_init_data after registration
Date:   Tue, 24 Sep 2019 12:45:10 -0400
Message-Id: <20190924164549.27058-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164549.27058-1-sashal@kernel.org>
References: <20190924164549.27058-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 1a4549c150e27dbc3aea762e879a88209df6d1a5 ]

A future patch is going to change semantics of clk_register() so that
clk_hw::init is guaranteed to be NULL after a clk is registered. Avoid
referencing this member here so that we don't run into NULL pointer
exceptions.

Cc: Jun Nie <jun.nie@linaro.org>
Cc: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190815160020.183334-3-sboyd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zte/clk-zx296718.c | 109 +++++++++++++++------------------
 1 file changed, 49 insertions(+), 60 deletions(-)

diff --git a/drivers/clk/zte/clk-zx296718.c b/drivers/clk/zte/clk-zx296718.c
index fd6c347bec6a7..dd7045bc48c15 100644
--- a/drivers/clk/zte/clk-zx296718.c
+++ b/drivers/clk/zte/clk-zx296718.c
@@ -564,6 +564,7 @@ static int __init top_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -573,11 +574,10 @@ static int __init top_clocks_init(struct device_node *np)
 
 	for (i = 0; i < ARRAY_SIZE(zx296718_pll_clk); i++) {
 		zx296718_pll_clk[i].reg_base += (uintptr_t)reg_base;
+		name = zx296718_pll_clk[i].hw.init->name;
 		ret = clk_hw_register(NULL, &zx296718_pll_clk[i].hw);
-		if (ret) {
-			pr_warn("top clk %s init error!\n",
-				zx296718_pll_clk[i].hw.init->name);
-		}
+		if (ret)
+			pr_warn("top clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(top_ffactor_clk); i++) {
@@ -585,11 +585,10 @@ static int __init top_clocks_init(struct device_node *np)
 			top_hw_onecell_data.hws[top_ffactor_clk[i].id] =
 					&top_ffactor_clk[i].factor.hw;
 
+		name = top_ffactor_clk[i].factor.hw.init->name;
 		ret = clk_hw_register(NULL, &top_ffactor_clk[i].factor.hw);
-		if (ret) {
-			pr_warn("top clk %s init error!\n",
-				top_ffactor_clk[i].factor.hw.init->name);
-		}
+		if (ret)
+			pr_warn("top clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(top_mux_clk); i++) {
@@ -598,11 +597,10 @@ static int __init top_clocks_init(struct device_node *np)
 					&top_mux_clk[i].mux.hw;
 
 		top_mux_clk[i].mux.reg += (uintptr_t)reg_base;
+		name = top_mux_clk[i].mux.hw.init->name;
 		ret = clk_hw_register(NULL, &top_mux_clk[i].mux.hw);
-		if (ret) {
-			pr_warn("top clk %s init error!\n",
-				top_mux_clk[i].mux.hw.init->name);
-		}
+		if (ret)
+			pr_warn("top clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(top_gate_clk); i++) {
@@ -611,11 +609,10 @@ static int __init top_clocks_init(struct device_node *np)
 					&top_gate_clk[i].gate.hw;
 
 		top_gate_clk[i].gate.reg += (uintptr_t)reg_base;
+		name = top_gate_clk[i].gate.hw.init->name;
 		ret = clk_hw_register(NULL, &top_gate_clk[i].gate.hw);
-		if (ret) {
-			pr_warn("top clk %s init error!\n",
-				top_gate_clk[i].gate.hw.init->name);
-		}
+		if (ret)
+			pr_warn("top clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(top_div_clk); i++) {
@@ -624,11 +621,10 @@ static int __init top_clocks_init(struct device_node *np)
 					&top_div_clk[i].div.hw;
 
 		top_div_clk[i].div.reg += (uintptr_t)reg_base;
+		name = top_div_clk[i].div.hw.init->name;
 		ret = clk_hw_register(NULL, &top_div_clk[i].div.hw);
-		if (ret) {
-			pr_warn("top clk %s init error!\n",
-				top_div_clk[i].div.hw.init->name);
-		}
+		if (ret)
+			pr_warn("top clk %s init error!\n", name);
 	}
 
 	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get,
@@ -754,6 +750,7 @@ static int __init lsp0_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -767,11 +764,10 @@ static int __init lsp0_clocks_init(struct device_node *np)
 					&lsp0_mux_clk[i].mux.hw;
 
 		lsp0_mux_clk[i].mux.reg += (uintptr_t)reg_base;
+		name = lsp0_mux_clk[i].mux.hw.init->name;
 		ret = clk_hw_register(NULL, &lsp0_mux_clk[i].mux.hw);
-		if (ret) {
-			pr_warn("lsp0 clk %s init error!\n",
-				lsp0_mux_clk[i].mux.hw.init->name);
-		}
+		if (ret)
+			pr_warn("lsp0 clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lsp0_gate_clk); i++) {
@@ -780,11 +776,10 @@ static int __init lsp0_clocks_init(struct device_node *np)
 					&lsp0_gate_clk[i].gate.hw;
 
 		lsp0_gate_clk[i].gate.reg += (uintptr_t)reg_base;
+		name = lsp0_gate_clk[i].gate.hw.init->name;
 		ret = clk_hw_register(NULL, &lsp0_gate_clk[i].gate.hw);
-		if (ret) {
-			pr_warn("lsp0 clk %s init error!\n",
-				lsp0_gate_clk[i].gate.hw.init->name);
-		}
+		if (ret)
+			pr_warn("lsp0 clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lsp0_div_clk); i++) {
@@ -793,11 +788,10 @@ static int __init lsp0_clocks_init(struct device_node *np)
 					&lsp0_div_clk[i].div.hw;
 
 		lsp0_div_clk[i].div.reg += (uintptr_t)reg_base;
+		name = lsp0_div_clk[i].div.hw.init->name;
 		ret = clk_hw_register(NULL, &lsp0_div_clk[i].div.hw);
-		if (ret) {
-			pr_warn("lsp0 clk %s init error!\n",
-				lsp0_div_clk[i].div.hw.init->name);
-		}
+		if (ret)
+			pr_warn("lsp0 clk %s init error!\n", name);
 	}
 
 	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get,
@@ -862,6 +856,7 @@ static int __init lsp1_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -875,11 +870,10 @@ static int __init lsp1_clocks_init(struct device_node *np)
 					&lsp0_mux_clk[i].mux.hw;
 
 		lsp1_mux_clk[i].mux.reg += (uintptr_t)reg_base;
+		name = lsp1_mux_clk[i].mux.hw.init->name;
 		ret = clk_hw_register(NULL, &lsp1_mux_clk[i].mux.hw);
-		if (ret) {
-			pr_warn("lsp1 clk %s init error!\n",
-				lsp1_mux_clk[i].mux.hw.init->name);
-		}
+		if (ret)
+			pr_warn("lsp1 clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lsp1_gate_clk); i++) {
@@ -888,11 +882,10 @@ static int __init lsp1_clocks_init(struct device_node *np)
 					&lsp1_gate_clk[i].gate.hw;
 
 		lsp1_gate_clk[i].gate.reg += (uintptr_t)reg_base;
+		name = lsp1_gate_clk[i].gate.hw.init->name;
 		ret = clk_hw_register(NULL, &lsp1_gate_clk[i].gate.hw);
-		if (ret) {
-			pr_warn("lsp1 clk %s init error!\n",
-				lsp1_gate_clk[i].gate.hw.init->name);
-		}
+		if (ret)
+			pr_warn("lsp1 clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lsp1_div_clk); i++) {
@@ -901,11 +894,10 @@ static int __init lsp1_clocks_init(struct device_node *np)
 					&lsp1_div_clk[i].div.hw;
 
 		lsp1_div_clk[i].div.reg += (uintptr_t)reg_base;
+		name = lsp1_div_clk[i].div.hw.init->name;
 		ret = clk_hw_register(NULL, &lsp1_div_clk[i].div.hw);
-		if (ret) {
-			pr_warn("lsp1 clk %s init error!\n",
-				lsp1_div_clk[i].div.hw.init->name);
-		}
+		if (ret)
+			pr_warn("lsp1 clk %s init error!\n", name);
 	}
 
 	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get,
@@ -979,6 +971,7 @@ static int __init audio_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -992,11 +985,10 @@ static int __init audio_clocks_init(struct device_node *np)
 					&audio_mux_clk[i].mux.hw;
 
 		audio_mux_clk[i].mux.reg += (uintptr_t)reg_base;
+		name = audio_mux_clk[i].mux.hw.init->name;
 		ret = clk_hw_register(NULL, &audio_mux_clk[i].mux.hw);
-		if (ret) {
-			pr_warn("audio clk %s init error!\n",
-				audio_mux_clk[i].mux.hw.init->name);
-		}
+		if (ret)
+			pr_warn("audio clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(audio_adiv_clk); i++) {
@@ -1005,11 +997,10 @@ static int __init audio_clocks_init(struct device_node *np)
 					&audio_adiv_clk[i].hw;
 
 		audio_adiv_clk[i].reg_base += (uintptr_t)reg_base;
+		name = audio_adiv_clk[i].hw.init->name;
 		ret = clk_hw_register(NULL, &audio_adiv_clk[i].hw);
-		if (ret) {
-			pr_warn("audio clk %s init error!\n",
-				audio_adiv_clk[i].hw.init->name);
-		}
+		if (ret)
+			pr_warn("audio clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(audio_div_clk); i++) {
@@ -1018,11 +1009,10 @@ static int __init audio_clocks_init(struct device_node *np)
 					&audio_div_clk[i].div.hw;
 
 		audio_div_clk[i].div.reg += (uintptr_t)reg_base;
+		name = audio_div_clk[i].div.hw.init->name;
 		ret = clk_hw_register(NULL, &audio_div_clk[i].div.hw);
-		if (ret) {
-			pr_warn("audio clk %s init error!\n",
-				audio_div_clk[i].div.hw.init->name);
-		}
+		if (ret)
+			pr_warn("audio clk %s init error!\n", name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(audio_gate_clk); i++) {
@@ -1031,11 +1021,10 @@ static int __init audio_clocks_init(struct device_node *np)
 					&audio_gate_clk[i].gate.hw;
 
 		audio_gate_clk[i].gate.reg += (uintptr_t)reg_base;
+		name = audio_gate_clk[i].gate.hw.init->name;
 		ret = clk_hw_register(NULL, &audio_gate_clk[i].gate.hw);
-		if (ret) {
-			pr_warn("audio clk %s init error!\n",
-				audio_gate_clk[i].gate.hw.init->name);
-		}
+		if (ret)
+			pr_warn("audio clk %s init error!\n", name);
 	}
 
 	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get,
-- 
2.20.1

