Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0C1FDB69
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgFRBL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbgFRBL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D0321D7B;
        Thu, 18 Jun 2020 01:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442685;
        bh=ugz/FRCBTs2WMkvKZaWcLiNIAiqR8i+sTXBhORd1pbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDJfJdRZfM1lgezqVWMsRWAQlQW+Fnn+fQT60acegepX6IM3LyzzkWarjnnGsSSDR
         4YXYYvzmbW52zAnZanlyv/GN2udR44JdE32yKE5s1w7ynmygcidIh/VPBjKG3oJkBJ
         pFDigaTdSox+XnKPW1UgovpeV4bneXzw2RxeFdnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-amlogic@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 152/388] clk: meson: meson8b: Fix the polarity of the RESET_N lines
Date:   Wed, 17 Jun 2020 21:04:09 -0400
Message-Id: <20200618010805.600873-152-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 0d3051c790ed2ef6bd91b92b07220313f06b95b3 ]

CLKC_RESET_VID_DIVIDER_CNTL_RESET_N_POST and
CLKC_RESET_VID_DIVIDER_CNTL_RESET_N_PRE are active low. This means:
- asserting them requires setting the register value to 0
- de-asserting them requires setting the register value to 1

Set the register value accordingly for these two reset lines by setting
the inverted the register value compared to all other reset lines.

Fixes: 189621726bc2f6 ("clk: meson: meson8b: register the built-in reset controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200417184127.1319871-3-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/meson8b.c | 79 ++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/clk/meson/meson8b.c b/drivers/clk/meson/meson8b.c
index ac4a883acd2a..ecd78cdca8ce 100644
--- a/drivers/clk/meson/meson8b.c
+++ b/drivers/clk/meson/meson8b.c
@@ -3506,54 +3506,87 @@ static struct clk_regmap *const meson8b_clk_regmaps[] = {
 static const struct meson8b_clk_reset_line {
 	u32 reg;
 	u8 bit_idx;
+	bool active_low;
 } meson8b_clk_reset_bits[] = {
 	[CLKC_RESET_L2_CACHE_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 30
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 30,
+		.active_low = false,
 	},
 	[CLKC_RESET_AXI_64_TO_128_BRIDGE_A5_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 29
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 29,
+		.active_low = false,
 	},
 	[CLKC_RESET_SCU_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 28
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 28,
+		.active_low = false,
 	},
 	[CLKC_RESET_CPU3_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 27
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 27,
+		.active_low = false,
 	},
 	[CLKC_RESET_CPU2_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 26
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 26,
+		.active_low = false,
 	},
 	[CLKC_RESET_CPU1_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 25
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 25,
+		.active_low = false,
 	},
 	[CLKC_RESET_CPU0_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 24
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 24,
+		.active_low = false,
 	},
 	[CLKC_RESET_A5_GLOBAL_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 18
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 18,
+		.active_low = false,
 	},
 	[CLKC_RESET_A5_AXI_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 17
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 17,
+		.active_low = false,
 	},
 	[CLKC_RESET_A5_ABP_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL0, .bit_idx = 16
+		.reg = HHI_SYS_CPU_CLK_CNTL0,
+		.bit_idx = 16,
+		.active_low = false,
 	},
 	[CLKC_RESET_AXI_64_TO_128_BRIDGE_MMC_SOFT_RESET] = {
-		.reg = HHI_SYS_CPU_CLK_CNTL1, .bit_idx = 30
+		.reg = HHI_SYS_CPU_CLK_CNTL1,
+		.bit_idx = 30,
+		.active_low = false,
 	},
 	[CLKC_RESET_VID_CLK_CNTL_SOFT_RESET] = {
-		.reg = HHI_VID_CLK_CNTL, .bit_idx = 15
+		.reg = HHI_VID_CLK_CNTL,
+		.bit_idx = 15,
+		.active_low = false,
 	},
 	[CLKC_RESET_VID_DIVIDER_CNTL_SOFT_RESET_POST] = {
-		.reg = HHI_VID_DIVIDER_CNTL, .bit_idx = 7
+		.reg = HHI_VID_DIVIDER_CNTL,
+		.bit_idx = 7,
+		.active_low = false,
 	},
 	[CLKC_RESET_VID_DIVIDER_CNTL_SOFT_RESET_PRE] = {
-		.reg = HHI_VID_DIVIDER_CNTL, .bit_idx = 3
+		.reg = HHI_VID_DIVIDER_CNTL,
+		.bit_idx = 3,
+		.active_low = false,
 	},
 	[CLKC_RESET_VID_DIVIDER_CNTL_RESET_N_POST] = {
-		.reg = HHI_VID_DIVIDER_CNTL, .bit_idx = 1
+		.reg = HHI_VID_DIVIDER_CNTL,
+		.bit_idx = 1,
+		.active_low = true,
 	},
 	[CLKC_RESET_VID_DIVIDER_CNTL_RESET_N_PRE] = {
-		.reg = HHI_VID_DIVIDER_CNTL, .bit_idx = 0
+		.reg = HHI_VID_DIVIDER_CNTL,
+		.bit_idx = 0,
+		.active_low = true,
 	},
 };
 
@@ -3562,22 +3595,22 @@ static int meson8b_clk_reset_update(struct reset_controller_dev *rcdev,
 {
 	struct meson8b_clk_reset *meson8b_clk_reset =
 		container_of(rcdev, struct meson8b_clk_reset, reset);
-	unsigned long flags;
 	const struct meson8b_clk_reset_line *reset;
+	unsigned int value = 0;
+	unsigned long flags;
 
 	if (id >= ARRAY_SIZE(meson8b_clk_reset_bits))
 		return -EINVAL;
 
 	reset = &meson8b_clk_reset_bits[id];
 
+	if (assert != reset->active_low)
+		value = BIT(reset->bit_idx);
+
 	spin_lock_irqsave(&meson_clk_lock, flags);
 
-	if (assert)
-		regmap_update_bits(meson8b_clk_reset->regmap, reset->reg,
-				   BIT(reset->bit_idx), BIT(reset->bit_idx));
-	else
-		regmap_update_bits(meson8b_clk_reset->regmap, reset->reg,
-				   BIT(reset->bit_idx), 0);
+	regmap_update_bits(meson8b_clk_reset->regmap, reset->reg,
+			   BIT(reset->bit_idx), value);
 
 	spin_unlock_irqrestore(&meson_clk_lock, flags);
 
-- 
2.25.1

