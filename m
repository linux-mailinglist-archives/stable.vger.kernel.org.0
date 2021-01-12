Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C685E2F2FAF
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbhALM56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390378AbhALM55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9118D2336F;
        Tue, 12 Jan 2021 12:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456215;
        bh=hAoEpwiqPbCT37bbbZ28O2XW8nnm1SUk0LhseHv/JkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScVPWdSUIi9QCGX/UYkLTeFSOCgyGBQAASNJ+ewcaTX8/3V6Vyt+aAgJigQhf0cNA
         1/tJKaBqaEf7ldhPnRTLzfVZlcWCXMf+UskifEbVIXTObaBCwslrcGYbzeFZxpUCTN
         vjUJkQPv2gh0bmXs4+kEAx7L5c1P2aN78A1YTAGF57ISteEe0gC+fe6LjY+m186z/A
         /q6BnQeR1e91qnUOVuydaOgN1IKyMuiFJINPsLgRMKKOi0vGoQyQ8HJSZx/o9DvCrr
         TBpyrhwgaHIBifkbsBrv36S3bay6GV+YA05ZWK7PkQdgU3ieOfFPo6Gp8bWNp+ankb
         mmsP3B4yavmUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-power@fi.rohmeurope.com
Subject: [PATCH AUTOSEL 5.4 07/28] regulator: bd718x7: Add enable times
Date:   Tue, 12 Jan 2021 07:56:23 -0500
Message-Id: <20210112125645.70739-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
index bdab46a5c4617..6c431456d2983 100644
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
  * BUCK1/2/3/4
  * BUCK1RAMPRATE[1:0] BUCK1 DVS ramp rate setting
@@ -495,6 +525,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK1_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck1_set_hw_dvs_levels,
 		},
@@ -519,6 +550,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK2_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck2_set_hw_dvs_levels,
 		},
@@ -547,6 +579,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.linear_range_selectors = bd71847_buck3_volt_range_sel,
 			.enable_reg = BD718XX_REG_1ST_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -574,6 +607,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_range_mask = BD71847_BUCK4_RANGE_MASK,
 			.linear_range_selectors = bd71847_buck4_volt_range_sel,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -596,6 +630,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_3RD_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_3RD_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -620,6 +655,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_4TH_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_4TH_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71847_BUCK6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -646,6 +682,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.linear_range_selectors = bd718xx_ldo1_volt_range_sel,
 			.enable_reg = BD718XX_REG_LDO1_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -668,6 +705,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.n_voltages = ARRAY_SIZE(ldo_2_volts),
 			.enable_reg = BD718XX_REG_LDO2_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -691,6 +729,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_LDO3_MASK,
 			.enable_reg = BD718XX_REG_LDO3_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -714,6 +753,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_LDO4_MASK,
 			.enable_reg = BD718XX_REG_LDO4_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -740,6 +780,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.linear_range_selectors = bd71847_ldo5_volt_range_sel,
 			.enable_reg = BD718XX_REG_LDO5_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -765,6 +806,7 @@ static const struct bd718xx_regulator_data bd71847_regulators[] = {
 			.vsel_mask = BD718XX_LDO6_MASK,
 			.enable_reg = BD718XX_REG_LDO6_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71847_LDO6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -791,6 +833,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK1_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck1_set_hw_dvs_levels,
 		},
@@ -815,6 +858,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD718XX_REG_BUCK2_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck2_set_hw_dvs_levels,
 		},
@@ -839,6 +883,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD71837_REG_BUCK3_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck3_set_hw_dvs_levels,
 		},
@@ -863,6 +908,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = DVS_BUCK_RUN_MASK,
 			.enable_reg = BD71837_REG_BUCK4_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 			.of_parse_cb = buck4_set_hw_dvs_levels,
 		},
@@ -891,6 +937,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.linear_range_selectors = bd71837_buck5_volt_range_sel,
 			.enable_reg = BD718XX_REG_1ST_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -915,6 +962,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD71837_BUCK6_MASK,
 			.enable_reg = BD718XX_REG_2ND_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -937,6 +985,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_3RD_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_3RD_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK7_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -961,6 +1010,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_4TH_NODVS_BUCK_MASK,
 			.enable_reg = BD718XX_REG_4TH_NODVS_BUCK_CTRL,
 			.enable_mask = BD718XX_BUCK_EN,
+			.enable_time = BD71837_BUCK8_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -987,6 +1037,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.linear_range_selectors = bd718xx_ldo1_volt_range_sel,
 			.enable_reg = BD718XX_REG_LDO1_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO1_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1009,6 +1060,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.n_voltages = ARRAY_SIZE(ldo_2_volts),
 			.enable_reg = BD718XX_REG_LDO2_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO2_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1032,6 +1084,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_LDO3_MASK,
 			.enable_reg = BD718XX_REG_LDO3_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO3_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1055,6 +1108,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_LDO4_MASK,
 			.enable_reg = BD718XX_REG_LDO4_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO4_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1080,6 +1134,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD71837_LDO5_MASK,
 			.enable_reg = BD718XX_REG_LDO5_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO5_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1107,6 +1162,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD718XX_LDO6_MASK,
 			.enable_reg = BD718XX_REG_LDO6_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO6_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
@@ -1132,6 +1188,7 @@ static const struct bd718xx_regulator_data bd71837_regulators[] = {
 			.vsel_mask = BD71837_LDO7_MASK,
 			.enable_reg = BD71837_REG_LDO7_VOLT,
 			.enable_mask = BD718XX_LDO_EN,
+			.enable_time = BD71837_LDO7_STARTUP_TIME,
 			.owner = THIS_MODULE,
 		},
 		.init = {
-- 
2.27.0

