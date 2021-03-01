Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96458328DB6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241298AbhCATQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235221AbhCATJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:09:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95BAC65056;
        Mon,  1 Mar 2021 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619274;
        bh=SOMY2cf7ehxVdu/OpMFzygPChKujMvoZ5qG0kZLw4qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XG/5qZY+3i7RcMixd7p15ovoZHNNjSr8PdyjiVcIOMN3wbD15Gt1JqfQj3i/M8BF4
         CPlJCRoH/6josbQ+W9GFN/YIYcgCILjWPzd5jNQcB1s4YqxVvQL6rsO2FlehJv2Il3
         Atw/WF1Xun9yt07cz1Fuj8iXdT6bCJUli/Ejo/7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Chen <ryan_chen@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/663] clk: aspeed: Fix APLL calculate formula from ast2600-A2
Date:   Mon,  1 Mar 2021 17:10:13 +0100
Message-Id: <20210301161159.906734969@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Chen <ryan_chen@aspeedtech.com>

[ Upstream commit 6286ce1e3ece54799f12775f8ce2a1cba9cbcfc5 ]

Starting from A2, the A-PLL calculation has changed. Use the
existing formula for A0/A1 and the new formula for A2 onwards.

Fixes: d3d04f6c330a ("clk: Add support for AST2600 SoC")
Signed-off-by: Ryan Chen <ryan_chen@aspeedtech.com>
Link: https://lore.kernel.org/r/20210119061715.6043-1-ryan_chen@aspeedtech.com
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-ast2600.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/clk-ast2600.c b/drivers/clk/clk-ast2600.c
index 177368cac6dd6..a55b37fc2c8bd 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -17,7 +17,8 @@
 
 #define ASPEED_G6_NUM_CLKS		71
 
-#define ASPEED_G6_SILICON_REV		0x004
+#define ASPEED_G6_SILICON_REV		0x014
+#define CHIP_REVISION_ID			GENMASK(23, 16)
 
 #define ASPEED_G6_RESET_CTRL		0x040
 #define ASPEED_G6_RESET_CTRL2		0x050
@@ -190,18 +191,34 @@ static struct clk_hw *ast2600_calc_pll(const char *name, u32 val)
 static struct clk_hw *ast2600_calc_apll(const char *name, u32 val)
 {
 	unsigned int mult, div;
+	u32 chip_id = readl(scu_g6_base + ASPEED_G6_SILICON_REV);
 
-	if (val & BIT(20)) {
-		/* Pass through mode */
-		mult = div = 1;
+	if (((chip_id & CHIP_REVISION_ID) >> 16) >= 2) {
+		if (val & BIT(24)) {
+			/* Pass through mode */
+			mult = div = 1;
+		} else {
+			/* F = 25Mhz * [(m + 1) / (n + 1)] / (p + 1) */
+			u32 m = val & 0x1fff;
+			u32 n = (val >> 13) & 0x3f;
+			u32 p = (val >> 19) & 0xf;
+
+			mult = (m + 1);
+			div = (n + 1) * (p + 1);
+		}
 	} else {
-		/* F = 25Mhz * (2-od) * [(m + 2) / (n + 1)] */
-		u32 m = (val >> 5) & 0x3f;
-		u32 od = (val >> 4) & 0x1;
-		u32 n = val & 0xf;
+		if (val & BIT(20)) {
+			/* Pass through mode */
+			mult = div = 1;
+		} else {
+			/* F = 25Mhz * (2-od) * [(m + 2) / (n + 1)] */
+			u32 m = (val >> 5) & 0x3f;
+			u32 od = (val >> 4) & 0x1;
+			u32 n = val & 0xf;
 
-		mult = (2 - od) * (m + 2);
-		div = n + 1;
+			mult = (2 - od) * (m + 2);
+			div = n + 1;
+		}
 	}
 	return clk_hw_register_fixed_factor(NULL, name, "clkin", 0,
 			mult, div);
-- 
2.27.0



