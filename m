Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E3E3288C9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhCARoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236998AbhCARki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:40:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ABB5650B9;
        Mon,  1 Mar 2021 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617779;
        bh=HOFOUVMN9S0WAOKUV4Cx+4bYLi8mRPsnnY6TOfm5BcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1qC3LJlscuaS1FEhPrbsm4wPAVhBj7XmzOwRyPZLHbM75adxHVkXGm5XDq4v3rEX
         2wTI3MguOpPhDxaQSRCa+NoVP5SDz1cgj+gkuBYLjafaJiaxbdM047hdXGV9NqAS9/
         NuGzHGHaGNYOmi7o3zKknRL0K+PBEtXbMTtjovzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Chen <ryan_chen@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/340] clk: aspeed: Fix APLL calculate formula from ast2600-A2
Date:   Mon,  1 Mar 2021 17:12:16 +0100
Message-Id: <20210301161057.761637549@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 7015974f24b43..84ca38450d021 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -17,7 +17,8 @@
 
 #define ASPEED_G6_NUM_CLKS		67
 
-#define ASPEED_G6_SILICON_REV		0x004
+#define ASPEED_G6_SILICON_REV		0x014
+#define CHIP_REVISION_ID			GENMASK(23, 16)
 
 #define ASPEED_G6_RESET_CTRL		0x040
 #define ASPEED_G6_RESET_CTRL2		0x050
@@ -189,18 +190,34 @@ static struct clk_hw *ast2600_calc_pll(const char *name, u32 val)
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



