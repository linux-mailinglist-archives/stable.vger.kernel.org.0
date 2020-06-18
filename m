Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAA61FE4B4
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbgFRCUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgFRBTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA45F21D79;
        Thu, 18 Jun 2020 01:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443142;
        bh=P2jbJjxLRXB01Y0XRWzTB55HTTcQubhBALt0qZ/Wd8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXYzdP7AqUB58nQih0OC4C9401qCFz2JAiJW+z7V8ITvDEpRnmKmJBckMo3W7DHAE
         5Iq6L0wUH2wyVMWu0RZVKE5IitM/OG6IoK/5JvGQpUFIwiWY+xBnQTDMlKi4F9oP7A
         M2bkYq85w71oIB+ONAPTV7vHQod++cqaMSgEZCcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-amlogic@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 112/266] clk: meson: meson8b: Don't rely on u-boot to init all GP_PLL registers
Date:   Wed, 17 Jun 2020 21:13:57 -0400
Message-Id: <20200618011631.604574-112-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit a29ae8600d50ece1856b062a39ed296b8b952259 ]

Not all u-boot versions initialize the HHI_GP_PLL_CNTL[2-5] registers.
In that case all HHI_GPLL_PLL_CNTL[1-5] registers are 0x0 and when
booting Linux the PLL fails to lock.
The initialization sequence from u-boot is:
- put the PLL into reset
- write 0x59C88000 to HHI_GP_PLL_CNTL2
- write 0xCA463823 to HHI_GP_PLL_CNTL3
- write 0x0286A027 to HHI_GP_PLL_CNTL4
- write 0x00003000 to HHI_GP_PLL_CNTL5
- set M, N, OD and the enable bit
- take the PLL out of reset
- check if it has locked
- disable the PLL

In Linux we already initialize M, N, OD, the enable and the reset bits.
Also the HHI_GP_PLL_CNTL[2-5] registers with these magic values (the
exact meaning is unknown) so the PLL can lock when the vendor u-boot did
not initialize these registers yet.

Fixes: b882964b376f21 ("clk: meson: meson8b: add support for the GP_PLL clock on Meson8m2")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200501215717.735393-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/meson8b.c | 9 +++++++++
 drivers/clk/meson/meson8b.h | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/clk/meson/meson8b.c b/drivers/clk/meson/meson8b.c
index 4f9b79ed79d7..082178a0f41a 100644
--- a/drivers/clk/meson/meson8b.c
+++ b/drivers/clk/meson/meson8b.c
@@ -1910,6 +1910,13 @@ static struct clk_regmap meson8b_mali = {
 	},
 };
 
+static const struct reg_sequence meson8m2_gp_pll_init_regs[] = {
+	{ .reg = HHI_GP_PLL_CNTL2,	.def = 0x59c88000 },
+	{ .reg = HHI_GP_PLL_CNTL3,	.def = 0xca463823 },
+	{ .reg = HHI_GP_PLL_CNTL4,	.def = 0x0286a027 },
+	{ .reg = HHI_GP_PLL_CNTL5,	.def = 0x00003000 },
+};
+
 static const struct pll_params_table meson8m2_gp_pll_params_table[] = {
 	PLL_PARAMS(182, 3),
 	{ /* sentinel */ },
@@ -1943,6 +1950,8 @@ static struct clk_regmap meson8m2_gp_pll_dco = {
 			.width   = 1,
 		},
 		.table = meson8m2_gp_pll_params_table,
+		.init_regs = meson8m2_gp_pll_init_regs,
+		.init_count = ARRAY_SIZE(meson8m2_gp_pll_init_regs),
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "gp_pll_dco",
diff --git a/drivers/clk/meson/meson8b.h b/drivers/clk/meson/meson8b.h
index c889fbeec30f..c91fb07fcb65 100644
--- a/drivers/clk/meson/meson8b.h
+++ b/drivers/clk/meson/meson8b.h
@@ -20,6 +20,10 @@
  * [0] http://dn.odroid.com/S805/Datasheet/S805_Datasheet%20V0.8%2020150126.pdf
  */
 #define HHI_GP_PLL_CNTL			0x40  /* 0x10 offset in data sheet */
+#define HHI_GP_PLL_CNTL2		0x44  /* 0x11 offset in data sheet */
+#define HHI_GP_PLL_CNTL3		0x48  /* 0x12 offset in data sheet */
+#define HHI_GP_PLL_CNTL4		0x4C  /* 0x13 offset in data sheet */
+#define HHI_GP_PLL_CNTL5		0x50  /* 0x14 offset in data sheet */
 #define HHI_VIID_CLK_DIV		0x128 /* 0x4a offset in data sheet */
 #define HHI_VIID_CLK_CNTL		0x12c /* 0x4b offset in data sheet */
 #define HHI_GCLK_MPEG0			0x140 /* 0x50 offset in data sheet */
-- 
2.25.1

