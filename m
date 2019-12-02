Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B565310E8EF
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfLBKb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35775 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbfLBKb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so11476307wro.2
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sHiG2NnNDoK8S4KpbBXz2iGAVpRQXWcAfC+CtzhYGHc=;
        b=qwgg7SpE0CxpHU52JDXD7aDWpVQDyvgCuH++pa1kweEa86elQzOPHc+dJUjYh8Yx4q
         dfs26w0hNQ0MzXCUA5AZr0OMJHSKbSBrgI3cSaXLnYC8K8OR9sf2/QkB+4P/nfSY9I4a
         06FBb92X1UhfBB8eNOe0ezW/hp2VXWfoT7pXubR1CjLooNInVE3OErMHe41LpayUlIdY
         j8Bbc+GqS/lSNBq9Yx5KrqwOxSoJeA4UKV7z+cM7QxeLpRVpbwndpUg0oULYozD1cdlG
         m8ggrhLSQ2MvqyJk4AmnuQvdtQw+1yo/1kiWCmiPlUM8Dj9f+7OcMEAWTq7hXaV2IWdX
         Mwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sHiG2NnNDoK8S4KpbBXz2iGAVpRQXWcAfC+CtzhYGHc=;
        b=AP3KA+18HuNJ70VaFRLNi0+nVljRFQmEHka7PRqRjtWQbBCnmC/Mv3uFpNn5z6w+D6
         ewGDU7QONy3UvnICgGq8lHlhdBIxdXpYX/qiHMYc1zqrmVcNf/SkH8fRLKoIqrFGv5Qz
         pa5P5cdahaYosawCAXYneLX7ZQOSVAQ7hfx3Jy8r6vEHjxR/rPdEI0TfET9wemME/TtK
         YVdiHoOXgdHSLfFpU9R9F+5olQXYVtc5pSmOVAFsXXus7FVDsU9YkgYFU7F5u1APBAWT
         q8BcaKuveLomGsvicSuuCa0+k0ldH+iSijF/goSU+FuJpghjtojIKEKD6tYhYHSk/6+/
         owqg==
X-Gm-Message-State: APjAAAXBrW1L2yrU6N6J4NW+uCj2TzOwnmFGURx9UQTDF461hM/r/plE
        BhXqBH19ZJQvxTawLizPVsqRnyooXP4=
X-Google-Smtp-Source: APXvYqyKD8VlvLM3++PRLaweeFI9TTs6TyC404dd3jK0hucKZf1l8KpkIhUd6vgar3F9ADjVBVdXtQ==
X-Received: by 2002:a05:6000:1047:: with SMTP id c7mr15718917wrx.341.1575282686728;
        Mon, 02 Dec 2019 02:31:26 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:26 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 15/15] clk: at91: generated: set audio_pll_allowed in at91_clk_register_generated()
Date:   Mon,  2 Dec 2019 10:30:50 +0000
Message-Id: <20191202103050.2668-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
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

