Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9610E82D
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfLBKEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:04:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46699 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfLBKEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:04:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so39934569wrl.13
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sHiG2NnNDoK8S4KpbBXz2iGAVpRQXWcAfC+CtzhYGHc=;
        b=u4Xa/h8hEnYiRzqh7/6FkLRwCeyu0R4ZVqr47DL35nqS1oGdiZq9CwpkP25kjVPuY4
         jTZV87ZdRR5xGQhlHhXndxMzAP7wnbudfLggnffK9fqV50g7b0tp5pqShj/QCir8hiGp
         sjjT/Qik61HO+GpMkGAdvlzI9Jv8JITBtRYRCXJhTRfyTCW8euq1Y4SDFvpb7BjjEeIb
         23jSBtZGJo3jxUQBfIHGgeL/C+/V2SyJ6byyTOAzWCVTSfAlHhdC6VXj/6YnsCaTyX8A
         FFnoNThGan7BDkrACOHJSZBc8lnOML8KZBoD8NgjqZ5GVQB1NVT9ov6zRmtPT1y0gMuk
         lKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sHiG2NnNDoK8S4KpbBXz2iGAVpRQXWcAfC+CtzhYGHc=;
        b=tywPa2YIpReebn+IUnBVh23Om+kTYeeC7J3PJnrodpYdUIE8R/DQN9GU2P0dhJGK3r
         5rQHKDNN3QwoNEyGo4iRO14V9LyGMtW3aPBZuXM3lVUXEiQKEK4imFZCxZj4ZDyvFBbO
         9oDgxY6petwO4nt0Ly8P+7lWM80eRuB/Ip607aRiGtWRx7dFOeENustcOYfyftDt/IlC
         QUk0/wp5CXmyEPZ7hWYfLwRiPdlPGEdzMk7rPsAYezdyAHa21LZpo9pQRdsx+cNpQUt7
         prZmcAZ1+b6ZUw/wmues+HfK0dl+S/4jB/EchIbw7zWNBBvoMTaEJCnF6LNdVkBzGWe/
         eO8Q==
X-Gm-Message-State: APjAAAW3vKumL0KNSEsAE5I1IBdM+oqbT+6R6N/kpqr5jTb+of3qAYxG
        8Ps4CJSSg5KnUkVjFs1q7XdWiwsc3+4=
X-Google-Smtp-Source: APXvYqzZkYQENyhxccCk3adzFW5HMITJWZG63wf2X0YFCHHpP/u/b/wc+ReUN0wKQ2Nkv9PMOoQqjQ==
X-Received: by 2002:a5d:6b47:: with SMTP id x7mr12327249wrw.277.1575281045056;
        Mon, 02 Dec 2019 02:04:05 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:04:04 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 14/14] clk: at91: generated: set audio_pll_allowed in at91_clk_register_generated()
Date:   Mon,  2 Dec 2019 10:03:12 +0000
Message-Id: <20191202100312.1397-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c1e4580a1d0ff510d56268c1fc7fcfeec366fe70 ]

Set gck->audio_pll_allowed in at91_clk_register_generated. This makes it
easier to do it from code that is not parsing device tree.

Also, this fixes an issue where the resulting clk_hw can be dereferenced
before being tested for error.

Fixes: 1a1a36d72e3d ("clk: at91: clk-generated: make gclk determine audio_pll rate")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/at91/clk-generated.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index 113152425a95..ea23002be4de 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -284,7 +284,7 @@ static void clk_generated_startup(struct clk_generated *gck)
 static struct clk_hw * __init
 at91_clk_register_generated(struct regmap *regmap, spinlock_t *lock,
 			    const char *name, const char **parent_names,
-			    u8 num_parents, u8 id,
+			    u8 num_parents, u8 id, bool pll_audio,
 			    const struct clk_range *range)
 {
 	struct clk_generated *gck;
@@ -308,6 +308,7 @@ at91_clk_register_generated(struct regmap *regmap, spinlock_t *lock,
 	gck->regmap = regmap;
 	gck->lock = lock;
 	gck->range = *range;
+	gck->audio_pll_allowed = pll_audio;
 
 	clk_generated_startup(gck);
 	hw = &gck->hw;
@@ -333,7 +334,6 @@ static void __init of_sama5d2_clk_generated_setup(struct device_node *np)
 	struct device_node *gcknp;
 	struct clk_range range = CLK_RANGE(0, 0);
 	struct regmap *regmap;
-	struct clk_generated *gck;
 
 	num_parents = of_clk_get_parent_count(np);
 	if (num_parents == 0 || num_parents > GENERATED_SOURCE_MAX)
@@ -350,6 +350,8 @@ static void __init of_sama5d2_clk_generated_setup(struct device_node *np)
 		return;
 
 	for_each_child_of_node(np, gcknp) {
+		bool pll_audio = false;
+
 		if (of_property_read_u32(gcknp, "reg", &id))
 			continue;
 
@@ -362,24 +364,14 @@ static void __init of_sama5d2_clk_generated_setup(struct device_node *np)
 		of_at91_get_clk_range(gcknp, "atmel,clk-output-range",
 				      &range);
 
+		if (of_device_is_compatible(np, "atmel,sama5d2-clk-generated") &&
+		    (id == GCK_ID_I2S0 || id == GCK_ID_I2S1 ||
+		     id == GCK_ID_CLASSD))
+			pll_audio = true;
+
 		hw = at91_clk_register_generated(regmap, &pmc_pcr_lock, name,
 						  parent_names, num_parents,
-						  id, &range);
-
-		gck = to_clk_generated(hw);
-
-		if (of_device_is_compatible(np,
-					    "atmel,sama5d2-clk-generated")) {
-			if (gck->id == GCK_ID_SSC0 || gck->id == GCK_ID_SSC1 ||
-			    gck->id == GCK_ID_I2S0 || gck->id == GCK_ID_I2S1 ||
-			    gck->id == GCK_ID_CLASSD)
-				gck->audio_pll_allowed = true;
-			else
-				gck->audio_pll_allowed = false;
-		} else {
-			gck->audio_pll_allowed = false;
-		}
-
+						  id, pll_audio, &range);
 		if (IS_ERR(hw))
 			continue;
 
-- 
2.24.0

