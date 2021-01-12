Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213FE2F2F96
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389508AbhALM5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389438AbhALM5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAA0723127;
        Tue, 12 Jan 2021 12:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456152;
        bh=0npvyNKld9rewmWbSPArt3TwCww7ij8c2XUKC/KBGy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dvs5G/Avi4zqwK6xCmiYwPJsaCVwWYgHOQPVu9+Jujwro7QjV0RonmSdE5TK/Nuvx
         o5BFC2eHjV4OG3Ou+INx+ovN4LZAH5uQip9683xNKxfEtz2s+xRYNaEIsMPJm25+ou
         Qj7HPV571Y4jp+bBQQu1MRQ+B6h6FdhN6ps4tQBgWqaqJoAAcKeqPgl7LFuSZi+U3q
         H4S/4oDu5svvk/ALitpCfdPYc6iE/9Cv5mnG3TXiizQDahFhpXpUb0vNxv9iizoIXs
         ghYjSlfNbtRw9CyrizV2glwD5vnwTO0gMuOnyU5Q1UsXJ5thxUPC/tQLXNsyjrokzJ
         lU4m3FkkkpQaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-power@fi.rohmeurope.com
Subject: [PATCH AUTOSEL 5.10 13/51] regulator: bd718x7: Add enable times
Date:   Tue, 12 Jan 2021 07:54:55 -0500
Message-Id: <20210112125534.70280-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit 3b66e4a8e58a85af3212c7117d7a29c9ef6679a2 ]

Use the typical startup times from the data sheet so boards get a
reasonable default. Not setting any enable time can lead to board hangs
when e.g. clocks are enabled too soon afterwards.

This fixes gpu power domain resume on the Librem 5.

[Moved #defines into driver, seems to be general agreement and avoids any
cross tree issues -- broonie]

Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/41fb2ed19f584f138336344e2297ae7301f72b75.1608316658.git.agx@sigxcpu.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd718x7-regulator.c | 57 +++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/regulator/bd718x7-regulator.c b/drivers/regulator/bd718x7-regulator.c
index 0774467994fbe..3333b8905f1b7 100644
--- a/drivers/regulator/bd718x7-regulator.c
+++ b/drivers/regulator/bd718x7-regulator.c
@@ -15,6 +15,36 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/slab.h>
 
+/* Typical regulator startup times as per data sheet in uS */
+#define BD71847_BUCK1_STARTUP_TIME 144
+#define BD71847_BUCK2_STARTUP_TIME 162
+#define BD71847_BUCK3_STARTUP_TIME 162
+#define BD71847_BUCK4_STARTUP_TIME 240
+#define BD71847_BUCK5_STARTUP_TIME 270
+#define BD71847_BUCK6_STARTUP_TIME 200
+#define BD71847_LDO1_STARTUP_TIME  440
+#define BD71847_LDO2_STARTUP_TIME  370
+#define BD71847_LDO3_STARTUP_TIME  310
+#define BD71847_LDO4_STARTUP_TIME  400
+#define BD71847_LDO5_STARTUP_TIME  530
+#define BD71847_LDO6_STARTUP_TIME  400
+
+#define BD71837_BUCK1_STARTUP_TIME 160
+#define BD71837_BUCK2_STARTUP_TIME 180
+#define BD71837_BUCK3_STARTUP_TIME 180
+#define BD71837_BUCK4_STARTUP_TIME 180
+#define BD71837_BUCK5_STARTUP_TIME 160
+#define BD71837_BUCK6_STARTUP_TIME 240
+#define BD71837_BUCK7_STARTUP_TIME 220
+#define BD71837_BUCK8_STARTUP_TIME 200
+#define BD71837_LDO1_STARTUP_TIME  440
+#define BD71837_LDO2_STARTUP_TIME  370
+#define BD71837_LDO3_STARTUP_TIME  310
+#define BD71837_LDO4_STARTUP_TIME  400
+#define BD71837_LDO5_STARTUP_TIME  310
+#define BD71837_LDO6_STARTUP_TIME  400
+#define BD71837_LDO7_STARTUP_TIME  530
+
 /*
  * BD718(37/47/50) have two "enable control modes". ON/OFF can either be
  * controlled by software - or by PMIC internal HW state machine. Whether
@@ -613,6 +643,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK1_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck_set_hw_dvs_levels,
 		},
@@ -646,6 +677,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK2_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck_set_hw_dvs_levels,
 		},
@@ -680,6 +712,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.linear_range_selectors = bd71847_buck3_volt_range_sel,
 			.enable_reg = BD718XX_REG_1ST_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -706,6 +739,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_range_mask = BD71847_BUCK4_RANGE_MASK,
 			.linear_range_selectors = bd71847_buck4_volt_range_sel,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -727,6 +761,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_3RD_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_3RD_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -750,6 +785,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_4TH_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_4TH_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -775,6 +811,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.linear_range_selectors = bd718xx_ldo1_volt_range_sel,
 			.enable_reg = BD718XX_REG_LDO1_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -796,6 +833,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.n_voltages = ARRAY_SIZE(ldo_2_volts),
 			.enable_reg = BD718XX_REG_LDO2_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -818,6 +856,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_LDO3_MASK,
 			.enable_reg = BD718XX_REG_LDO3_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -840,6 +879,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_LDO4_MASK,
 			.enable_reg = BD718XX_REG_LDO4_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -865,6 +905,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.linear_range_selectors = bd71847_ldo5_volt_range_sel,
 			.enable_reg = BD718XX_REG_LDO5_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -889,6 +930,7 @@ static struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_LDO6_MASK,
 			.enable_reg = BD718XX_REG_LDO6_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -942,6 +984,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK1_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck_set_hw_dvs_levels,
 		},
@@ -975,6 +1018,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK2_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck_set_hw_dvs_levels,
 		},
@@ -1005,6 +1049,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD71837_REG_BUCK3_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck_set_hw_dvs_levels,
 		},
@@ -1033,6 +1078,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD71837_REG_BUCK4_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck_set_hw_dvs_levels,
 		},
@@ -1065,6 +1111,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.linear_range_selectors = bd71837_buck5_volt_range_sel,
 			.enable_reg = BD718XX_REG_1ST_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1088,6 +1135,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD71837_BUCK6_MASK,
 			.enable_reg = BD718XX_REG_2ND_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1109,6 +1157,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_3RD_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_3RD_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK7_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1132,6 +1181,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_4TH_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_4TH_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK8_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1157,6 +1207,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.linear_range_selectors = bd718xx_ldo1_volt_range_sel,
 			.enable_reg = BD718XX_REG_LDO1_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1178,6 +1229,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.n_voltages = ARRAY_SIZE(ldo_2_volts),
 			.enable_reg = BD718XX_REG_LDO2_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1200,6 +1252,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_LDO3_MASK,
 			.enable_reg = BD718XX_REG_LDO3_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1222,6 +1275,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_LDO4_MASK,
 			.enable_reg = BD718XX_REG_LDO4_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1246,6 +1300,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD71837_LDO5_MASK,
 			.enable_reg = BD718XX_REG_LDO5_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1272,6 +1327,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_LDO6_MASK,
 			.enable_reg = BD718XX_REG_LDO6_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1296,6 +1352,7 @@ static struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD71837_LDO7_MASK,
 			.enable_reg = BD71837_REG_LDO7_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO7_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
-- 
2.27.0

