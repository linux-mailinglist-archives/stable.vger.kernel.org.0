Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20952111E33
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbfLCW4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbfLCW4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABA8C2053B;
        Tue,  3 Dec 2019 22:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413798;
        bh=iWz+xQsYxy64C4DLxGQ1cBWmn/n02k3AjJMBZLWgd68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUjiaV25zopfMcz0oXvpuGjyHWaFhBDCtltkyMNlqe5OA905AKijuaYPtnEBI4Hws
         Pj99aiZ35QZEA4EnwahaTxzs3nKVZAJ1EIRR+/1bp5sH2byzDSIKn2Ode8gqJxob5Y
         K8gzJ9ddC82FamSaq2A0QSSGyZnejPxIvOvK5ePg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 267/321] clk: at91: generated: set audio_pll_allowed in at91_clk_register_generated()
Date:   Tue,  3 Dec 2019 23:35:33 +0100
Message-Id: <20191203223441.016118835@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit c1e4580a1d0ff510d56268c1fc7fcfeec366fe70 upstream.

Set gck->audio_pll_allowed in at91_clk_register_generated. This makes it
easier to do it from code that is not parsing device tree.

Also, this fixes an issue where the resulting clk_hw can be dereferenced
before being tested for error.

Fixes: 1a1a36d72e3d ("clk: at91: clk-generated: make gclk determine audio_pll rate")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/at91/clk-generated.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -284,7 +284,7 @@ static void clk_generated_startup(struct
 static struct clk_hw * __init
 at91_clk_register_generated(struct regmap *regmap, spinlock_t *lock,
 			    const char *name, const char **parent_names,
-			    u8 num_parents, u8 id,
+			    u8 num_parents, u8 id, bool pll_audio,
 			    const struct clk_range *range)
 {
 	struct clk_generated *gck;
@@ -308,6 +308,7 @@ at91_clk_register_generated(struct regma
 	gck->regmap = regmap;
 	gck->lock = lock;
 	gck->range = *range;
+	gck->audio_pll_allowed = pll_audio;
 
 	clk_generated_startup(gck);
 	hw = &gck->hw;
@@ -333,7 +334,6 @@ static void __init of_sama5d2_clk_genera
 	struct device_node *gcknp;
 	struct clk_range range = CLK_RANGE(0, 0);
 	struct regmap *regmap;
-	struct clk_generated *gck;
 
 	num_parents = of_clk_get_parent_count(np);
 	if (num_parents == 0 || num_parents > GENERATED_SOURCE_MAX)
@@ -350,6 +350,8 @@ static void __init of_sama5d2_clk_genera
 		return;
 
 	for_each_child_of_node(np, gcknp) {
+		bool pll_audio = false;
+
 		if (of_property_read_u32(gcknp, "reg", &id))
 			continue;
 
@@ -362,24 +364,14 @@ static void __init of_sama5d2_clk_genera
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
 


