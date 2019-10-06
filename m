Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679D3CD466
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfJFRZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbfJFRZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:25:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75DB62077B;
        Sun,  6 Oct 2019 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382717;
        bh=OuQyraHRTcW5Pfr4GQOsgbTEdxokYCLV74EwXmY0TbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mipStDvmyASkYZ78ZW9aLixGHrPzt7bIADz7kpY/J3xO1du4/l/vE0VF2434eS22H
         F/GgD1rf4OidtN083unqI4KJI3+TpWu9iKW+5qGj4l/ZUfXhtDy1D49bJPD4gc4tko
         BLDNnMztGP6vpbuzDvBVxcUSv4rWmW856ln1J598=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Nie <jun.nie@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/68] clk: zx296718: Dont reference clk_init_data after registration
Date:   Sun,  6 Oct 2019 19:20:50 +0200
Message-Id: <20191006171115.125948320@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 354dd508c5169..8dfb8523b79db 100644
--- a/drivers/clk/zte/clk-zx296718.c
+++ b/drivers/clk/zte/clk-zx296718.c
@@ -567,6 +567,7 @@ static int __init top_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -576,11 +577,10 @@ static int __init top_clocks_init(struct device_node *np)
 
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
@@ -588,11 +588,10 @@ static int __init top_clocks_init(struct device_node *np)
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
@@ -601,11 +600,10 @@ static int __init top_clocks_init(struct device_node *np)
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
@@ -614,11 +612,10 @@ static int __init top_clocks_init(struct device_node *np)
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
@@ -627,11 +624,10 @@ static int __init top_clocks_init(struct device_node *np)
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
@@ -757,6 +753,7 @@ static int __init lsp0_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -770,11 +767,10 @@ static int __init lsp0_clocks_init(struct device_node *np)
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
@@ -783,11 +779,10 @@ static int __init lsp0_clocks_init(struct device_node *np)
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
@@ -796,11 +791,10 @@ static int __init lsp0_clocks_init(struct device_node *np)
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
@@ -865,6 +859,7 @@ static int __init lsp1_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -878,11 +873,10 @@ static int __init lsp1_clocks_init(struct device_node *np)
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
@@ -891,11 +885,10 @@ static int __init lsp1_clocks_init(struct device_node *np)
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
@@ -904,11 +897,10 @@ static int __init lsp1_clocks_init(struct device_node *np)
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
@@ -982,6 +974,7 @@ static int __init audio_clocks_init(struct device_node *np)
 {
 	void __iomem *reg_base;
 	int i, ret;
+	const char *name;
 
 	reg_base = of_iomap(np, 0);
 	if (!reg_base) {
@@ -995,11 +988,10 @@ static int __init audio_clocks_init(struct device_node *np)
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
@@ -1008,11 +1000,10 @@ static int __init audio_clocks_init(struct device_node *np)
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
@@ -1021,11 +1012,10 @@ static int __init audio_clocks_init(struct device_node *np)
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
@@ -1034,11 +1024,10 @@ static int __init audio_clocks_init(struct device_node *np)
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



