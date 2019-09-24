Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54462BCD5C
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409947AbfIXQpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409946AbfIXQpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:45:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A20720872;
        Tue, 24 Sep 2019 16:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343514;
        bh=BlKSi1Xq4EuPHJSs1tQuJ38g3c84qR75o+FZ4x/DhnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dm0GCZo1a1do93xajId6+ilzW1NVHbJm6rmU+KEtaLHuol4Xrauez8zKzABxaaEBs
         KVGj4iEhh4PoCvvQ0nmkCmWT3x/F4oBa5x1zMGk27GzQjGIi9l82RY38yQXSQi25yi
         cNhoiDS5+e9GURGK5RrPqJHaumZAqHQJSGbRrXvY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 76/87] clk: at91: select parent if main oscillator or bypass is enabled
Date:   Tue, 24 Sep 2019 12:41:32 -0400
Message-Id: <20190924164144.25591-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 69a6bcde7fd3fe6f3268ce26f31d9d9378384c98 ]

Selecting the right parent for the main clock is done using only
main oscillator enabled bit.
In case we have this oscillator bypassed by an external signal (no driving
on the XOUT line), we still use external clock, but with BYPASS bit set.
So, in this case we must select the same parent as before.
Create a macro that will select the right parent considering both bits from
the MOR register.
Use this macro when looking for the right parent.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lkml.kernel.org/r/1568042692-11784-2-git-send-email-eugen.hristev@microchip.com
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index f607ee702c838..311cea0c3ae2b 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -21,6 +21,10 @@
 
 #define MOR_KEY_MASK		(0xff << 16)
 
+#define clk_main_parent_select(s)	(((s) & \
+					(AT91_PMC_MOSCEN | \
+					AT91_PMC_OSCBYPASS)) ? 1 : 0)
+
 struct clk_main_osc {
 	struct clk_hw hw;
 	struct regmap *regmap;
@@ -113,7 +117,7 @@ static int clk_main_osc_is_prepared(struct clk_hw *hw)
 
 	regmap_read(regmap, AT91_PMC_SR, &status);
 
-	return (status & AT91_PMC_MOSCS) && (tmp & AT91_PMC_MOSCEN);
+	return (status & AT91_PMC_MOSCS) && clk_main_parent_select(tmp);
 }
 
 static const struct clk_ops main_osc_ops = {
@@ -450,7 +454,7 @@ static u8 clk_sam9x5_main_get_parent(struct clk_hw *hw)
 
 	regmap_read(clkmain->regmap, AT91_CKGR_MOR, &status);
 
-	return status & AT91_PMC_MOSCEN ? 1 : 0;
+	return clk_main_parent_select(status);
 }
 
 static const struct clk_ops sam9x5_main_ops = {
@@ -492,7 +496,7 @@ at91_clk_register_sam9x5_main(struct regmap *regmap,
 	clkmain->hw.init = &init;
 	clkmain->regmap = regmap;
 	regmap_read(clkmain->regmap, AT91_CKGR_MOR, &status);
-	clkmain->parent = status & AT91_PMC_MOSCEN ? 1 : 0;
+	clkmain->parent = clk_main_parent_select(status);
 
 	hw = &clkmain->hw;
 	ret = clk_hw_register(NULL, &clkmain->hw);
-- 
2.20.1

