Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE49205CF1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388553AbgFWUHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388559AbgFWUHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 326D82064B;
        Tue, 23 Jun 2020 20:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942821;
        bh=E6tm+Uns50vXo6G4ObnzENvS7BHKYYKWH9yIUBmFdKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2N4QveRoW4s3Qrk+pGbPZraM7phxt6+VutbdsQphcv0pF3oyQpPXhLfsWpNq6baf
         +FaNrNk4Rdo0iR/bkRanmYL6oPrSAgkc1byeO/W/kKlC4EFQp92v4aKbDDgcRTaYT4
         /TRjnT/yRT3dydJzsL0LqHY2xMnA53dAAHUH4lJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 149/477] clk: meson: meson8b: Fix the polarity of the RESET_N lines
Date:   Tue, 23 Jun 2020 21:52:26 +0200
Message-Id: <20200623195414.643815847@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ac4a883acd2ac..ecd78cdca8ce3 100644
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



