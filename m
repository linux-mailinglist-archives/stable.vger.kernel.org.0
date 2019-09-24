Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F35BCE4B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410740AbfIXQuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410737AbfIXQuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:50:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E13021971;
        Tue, 24 Sep 2019 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343820;
        bh=on4MoXKLcBAAwcvGInINaSXEOabjhNW79FFPggjuvbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tq/EDnF1JlwB2Tn44kFt278wZ0Ms0v0jwxpU0pE0bDDn4F4NlixKOkVsTteLUW1PK
         70zTvlCgx17z2YczDI9Jdyugw7aHXnGTAbBDUjEUAXt4IhSN/ba0TzEk5Q8bSwcWpW
         YxsWOpUJIgf5wfkw93eEeZsRw8TR2N+ZAy+kQeDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 44/50] clk: at91: select parent if main oscillator or bypass is enabled
Date:   Tue, 24 Sep 2019 12:48:41 -0400
Message-Id: <20190924164847.27780-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
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
index c813c27f2e58c..2f97a843d6d6b 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -27,6 +27,10 @@
 
 #define MOR_KEY_MASK		(0xff << 16)
 
+#define clk_main_parent_select(s)	(((s) & \
+					(AT91_PMC_MOSCEN | \
+					AT91_PMC_OSCBYPASS)) ? 1 : 0)
+
 struct clk_main_osc {
 	struct clk_hw hw;
 	struct regmap *regmap;
@@ -119,7 +123,7 @@ static int clk_main_osc_is_prepared(struct clk_hw *hw)
 
 	regmap_read(regmap, AT91_PMC_SR, &status);
 
-	return (status & AT91_PMC_MOSCS) && (tmp & AT91_PMC_MOSCEN);
+	return (status & AT91_PMC_MOSCS) && clk_main_parent_select(tmp);
 }
 
 static const struct clk_ops main_osc_ops = {
@@ -530,7 +534,7 @@ static u8 clk_sam9x5_main_get_parent(struct clk_hw *hw)
 
 	regmap_read(clkmain->regmap, AT91_CKGR_MOR, &status);
 
-	return status & AT91_PMC_MOSCEN ? 1 : 0;
+	return clk_main_parent_select(status);
 }
 
 static const struct clk_ops sam9x5_main_ops = {
@@ -572,7 +576,7 @@ at91_clk_register_sam9x5_main(struct regmap *regmap,
 	clkmain->hw.init = &init;
 	clkmain->regmap = regmap;
 	regmap_read(clkmain->regmap, AT91_CKGR_MOR, &status);
-	clkmain->parent = status & AT91_PMC_MOSCEN ? 1 : 0;
+	clkmain->parent = clk_main_parent_select(status);
 
 	hw = &clkmain->hw;
 	ret = clk_hw_register(NULL, &clkmain->hw);
-- 
2.20.1

