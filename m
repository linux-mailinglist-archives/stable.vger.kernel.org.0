Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2DF2D8702
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 15:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439019AbgLLN6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 08:58:32 -0500
Received: from aposti.net ([89.234.176.197]:47928 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437600AbgLLN62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 08:58:28 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     od@zcrc.me, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] clk: ingenic: Fix divider calculation with div tables
Date:   Sat, 12 Dec 2020 13:57:33 +0000
Message-Id: <20201212135733.38050-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The previous code assumed that a higher hardware value always resulted
in a bigger divider, which is correct for the regular clocks, but is
an invalid assumption when a divider table is provided for the clock.

Perfect example of this is the PLL0_HALF clock, which applies a /2
divider with the hardware value 0, and a /1 divider otherwise.

Fixes: a9fa2893fcc6 ("clk: ingenic: Add support for divider tables")
Cc: <stable@vger.kernel.org> # 5.2
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/clk/ingenic/cgu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/ingenic/cgu.c b/drivers/clk/ingenic/cgu.c
index dac6edc670cc..c8e9cb6c8e39 100644
--- a/drivers/clk/ingenic/cgu.c
+++ b/drivers/clk/ingenic/cgu.c
@@ -392,15 +392,21 @@ static unsigned int
 ingenic_clk_calc_hw_div(const struct ingenic_cgu_clk_info *clk_info,
 			unsigned int div)
 {
-	unsigned int i;
+	unsigned int i, best_i = 0, best = (unsigned int)-1;
 
 	for (i = 0; i < (1 << clk_info->div.bits)
 				&& clk_info->div.div_table[i]; i++) {
-		if (clk_info->div.div_table[i] >= div)
-			return i;
+		if (clk_info->div.div_table[i] >= div &&
+		    clk_info->div.div_table[i] < best) {
+			best = clk_info->div.div_table[i];
+			best_i = i;
+
+			if (div == best)
+				break;
+		}
 	}
 
-	return i - 1;
+	return best_i;
 }
 
 static unsigned
-- 
2.29.2

