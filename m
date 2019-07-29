Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B61795B7
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389858AbfG2TpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389919AbfG2TpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9807720C01;
        Mon, 29 Jul 2019 19:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429514;
        bh=Ml5UOaSIBw1Wer1huX4h9ayi/eFxGI2ZPPvNhhqjKLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FJciu0gZlrFz4eT0Y+E7hNavyYLBkFuThg5lIhzTVd7JFm5WH/xPMGb6S0XWXyxt
         RLfKH+fAyug6UWeDQ0Zpu6XnCTUeaae004nEdwq+x1BC5tqdFhklTbu78DskCPp2po
         ZbHFXZGtXXCNg+DWfDR7PSd5dk/Gv2wpxhm/Jvow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.2 001/215] regulator: 88pm800: fix warning same module names
Date:   Mon, 29 Jul 2019 21:19:57 +0200
Message-Id: <20190729190740.157816607@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit 6f10419187d0d5fe395e2a2f2a64370961bf02a3 upstream.

When building with CONFIG_MFD_88PM800 and CONFIG_REGULATOR_88PM800
enabled as loadable modules, we see the following warning:

warning: same module names found:
  drivers/regulator/88pm800.ko
  drivers/mfd/88pm800.ko

Rework so that the file is named 88pm800-regulator.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/88pm800-regulator.c |  286 ++++++++++++++++++++++++++++++++++
 drivers/regulator/88pm800.c           |  286 ----------------------------------
 drivers/regulator/Makefile            |    2 
 3 files changed, 287 insertions(+), 287 deletions(-)

--- /dev/null
+++ b/drivers/regulator/88pm800-regulator.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Regulators driver for Marvell 88PM800
+ *
+ * Copyright (C) 2012 Marvell International Ltd.
+ * Joseph(Yossi) Hanin <yhanin@marvell.com>
+ * Yi Zhang <yizhang@marvell.com>
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/88pm80x.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
+
+/* LDO1 with DVC[0..3] */
+#define PM800_LDO1_VOUT		(0x08) /* VOUT1 */
+#define PM800_LDO1_VOUT_2	(0x09)
+#define PM800_LDO1_VOUT_3	(0x0A)
+#define PM800_LDO2_VOUT		(0x0B)
+#define PM800_LDO3_VOUT		(0x0C)
+#define PM800_LDO4_VOUT		(0x0D)
+#define PM800_LDO5_VOUT		(0x0E)
+#define PM800_LDO6_VOUT		(0x0F)
+#define PM800_LDO7_VOUT		(0x10)
+#define PM800_LDO8_VOUT		(0x11)
+#define PM800_LDO9_VOUT		(0x12)
+#define PM800_LDO10_VOUT	(0x13)
+#define PM800_LDO11_VOUT	(0x14)
+#define PM800_LDO12_VOUT	(0x15)
+#define PM800_LDO13_VOUT	(0x16)
+#define PM800_LDO14_VOUT	(0x17)
+#define PM800_LDO15_VOUT	(0x18)
+#define PM800_LDO16_VOUT	(0x19)
+#define PM800_LDO17_VOUT	(0x1A)
+#define PM800_LDO18_VOUT	(0x1B)
+#define PM800_LDO19_VOUT	(0x1C)
+
+/* BUCK1 with DVC[0..3] */
+#define PM800_BUCK1		(0x3C)
+#define PM800_BUCK1_1		(0x3D)
+#define PM800_BUCK1_2		(0x3E)
+#define PM800_BUCK1_3		(0x3F)
+#define PM800_BUCK2		(0x40)
+#define PM800_BUCK3		(0x41)
+#define PM800_BUCK4		(0x42)
+#define PM800_BUCK4_1		(0x43)
+#define PM800_BUCK4_2		(0x44)
+#define PM800_BUCK4_3		(0x45)
+#define PM800_BUCK5		(0x46)
+
+#define PM800_BUCK_ENA		(0x50)
+#define PM800_LDO_ENA1_1	(0x51)
+#define PM800_LDO_ENA1_2	(0x52)
+#define PM800_LDO_ENA1_3	(0x53)
+
+#define PM800_LDO_ENA2_1	(0x56)
+#define PM800_LDO_ENA2_2	(0x57)
+#define PM800_LDO_ENA2_3	(0x58)
+
+#define PM800_BUCK1_MISC1	(0x78)
+#define PM800_BUCK3_MISC1	(0x7E)
+#define PM800_BUCK4_MISC1	(0x81)
+#define PM800_BUCK5_MISC1	(0x84)
+
+struct pm800_regulator_info {
+	struct regulator_desc desc;
+	int max_ua;
+};
+
+/*
+ * vreg - the buck regs string.
+ * ereg - the string for the enable register.
+ * ebit - the bit number in the enable register.
+ * amax - the current
+ * Buck has 2 kinds of voltage steps. It is easy to find voltage by ranges,
+ * not the constant voltage table.
+ * n_volt - Number of available selectors
+ */
+#define PM800_BUCK(match, vreg, ereg, ebit, amax, volt_ranges, n_volt)	\
+{									\
+	.desc	= {							\
+		.name			= #vreg,			\
+		.of_match		= of_match_ptr(#match),		\
+		.regulators_node	= of_match_ptr("regulators"),	\
+		.ops			= &pm800_volt_range_ops,	\
+		.type			= REGULATOR_VOLTAGE,		\
+		.id			= PM800_ID_##vreg,		\
+		.owner			= THIS_MODULE,			\
+		.n_voltages		= n_volt,			\
+		.linear_ranges		= volt_ranges,			\
+		.n_linear_ranges	= ARRAY_SIZE(volt_ranges),	\
+		.vsel_reg		= PM800_##vreg,			\
+		.vsel_mask		= 0x7f,				\
+		.enable_reg		= PM800_##ereg,			\
+		.enable_mask		= 1 << (ebit),			\
+	},								\
+	.max_ua	= (amax),						\
+}
+
+/*
+ * vreg - the LDO regs string
+ * ereg -  the string for the enable register.
+ * ebit - the bit number in the enable register.
+ * amax - the current
+ * volt_table - the LDO voltage table
+ * For all the LDOes, there are too many ranges. Using volt_table will be
+ * simpler and faster.
+ */
+#define PM800_LDO(match, vreg, ereg, ebit, amax, ldo_volt_table)	\
+{									\
+	.desc	= {							\
+		.name			= #vreg,			\
+		.of_match		= of_match_ptr(#match),		\
+		.regulators_node	= of_match_ptr("regulators"),	\
+		.ops			= &pm800_volt_table_ops,	\
+		.type			= REGULATOR_VOLTAGE,		\
+		.id			= PM800_ID_##vreg,		\
+		.owner			= THIS_MODULE,			\
+		.n_voltages		= ARRAY_SIZE(ldo_volt_table),	\
+		.vsel_reg		= PM800_##vreg##_VOUT,		\
+		.vsel_mask		= 0xf,				\
+		.enable_reg		= PM800_##ereg,			\
+		.enable_mask		= 1 << (ebit),			\
+		.volt_table		= ldo_volt_table,		\
+	},								\
+	.max_ua	= (amax),						\
+}
+
+/* Ranges are sorted in ascending order. */
+static const struct regulator_linear_range buck1_volt_range[] = {
+	REGULATOR_LINEAR_RANGE(600000, 0, 0x4f, 12500),
+	REGULATOR_LINEAR_RANGE(1600000, 0x50, 0x54, 50000),
+};
+
+/* BUCK 2~5 have same ranges. */
+static const struct regulator_linear_range buck2_5_volt_range[] = {
+	REGULATOR_LINEAR_RANGE(600000, 0, 0x4f, 12500),
+	REGULATOR_LINEAR_RANGE(1600000, 0x50, 0x72, 50000),
+};
+
+static const unsigned int ldo1_volt_table[] = {
+	600000,  650000,  700000,  750000,  800000,  850000,  900000,  950000,
+	1000000, 1050000, 1100000, 1150000, 1200000, 1300000, 1400000, 1500000,
+};
+
+static const unsigned int ldo2_volt_table[] = {
+	1700000, 1800000, 1900000, 2000000, 2100000, 2500000, 2700000, 2800000,
+};
+
+/* LDO 3~17 have same voltage table. */
+static const unsigned int ldo3_17_volt_table[] = {
+	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
+	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
+};
+
+/* LDO 18~19 have same voltage table. */
+static const unsigned int ldo18_19_volt_table[] = {
+	1700000, 1800000, 1900000, 2500000, 2800000, 2900000, 3100000, 3300000,
+};
+
+static int pm800_get_current_limit(struct regulator_dev *rdev)
+{
+	struct pm800_regulator_info *info = rdev_get_drvdata(rdev);
+
+	return info->max_ua;
+}
+
+static const struct regulator_ops pm800_volt_range_ops = {
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.get_current_limit	= pm800_get_current_limit,
+};
+
+static const struct regulator_ops pm800_volt_table_ops = {
+	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage		= regulator_map_voltage_iterate,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.get_current_limit	= pm800_get_current_limit,
+};
+
+/* The array is indexed by id(PM800_ID_XXX) */
+static struct pm800_regulator_info pm800_regulator_info[] = {
+	PM800_BUCK(buck1, BUCK1, BUCK_ENA, 0, 3000000, buck1_volt_range, 0x55),
+	PM800_BUCK(buck2, BUCK2, BUCK_ENA, 1, 1200000, buck2_5_volt_range, 0x73),
+	PM800_BUCK(buck3, BUCK3, BUCK_ENA, 2, 1200000, buck2_5_volt_range, 0x73),
+	PM800_BUCK(buck4, BUCK4, BUCK_ENA, 3, 1200000, buck2_5_volt_range, 0x73),
+	PM800_BUCK(buck5, BUCK5, BUCK_ENA, 4, 1200000, buck2_5_volt_range, 0x73),
+
+	PM800_LDO(ldo1, LDO1, LDO_ENA1_1, 0, 200000, ldo1_volt_table),
+	PM800_LDO(ldo2, LDO2, LDO_ENA1_1, 1, 10000, ldo2_volt_table),
+	PM800_LDO(ldo3, LDO3, LDO_ENA1_1, 2, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo4, LDO4, LDO_ENA1_1, 3, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo5, LDO5, LDO_ENA1_1, 4, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo6, LDO6, LDO_ENA1_1, 5, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo7, LDO7, LDO_ENA1_1, 6, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo8, LDO8, LDO_ENA1_1, 7, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo9, LDO9, LDO_ENA1_2, 0, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo10, LDO10, LDO_ENA1_2, 1, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo11, LDO11, LDO_ENA1_2, 2, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo12, LDO12, LDO_ENA1_2, 3, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo13, LDO13, LDO_ENA1_2, 4, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo14, LDO14, LDO_ENA1_2, 5, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo15, LDO15, LDO_ENA1_2, 6, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo16, LDO16, LDO_ENA1_2, 7, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo17, LDO17, LDO_ENA1_3, 0, 300000, ldo3_17_volt_table),
+	PM800_LDO(ldo18, LDO18, LDO_ENA1_3, 1, 200000, ldo18_19_volt_table),
+	PM800_LDO(ldo19, LDO19, LDO_ENA1_3, 2, 200000, ldo18_19_volt_table),
+};
+
+static int pm800_regulator_probe(struct platform_device *pdev)
+{
+	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
+	struct pm80x_platform_data *pdata = dev_get_platdata(pdev->dev.parent);
+	struct regulator_config config = { };
+	struct regulator_init_data *init_data;
+	int i, ret;
+
+	if (pdata && pdata->num_regulators) {
+		unsigned int count = 0;
+
+		/* Check whether num_regulator is valid. */
+		for (i = 0; i < ARRAY_SIZE(pdata->regulators); i++) {
+			if (pdata->regulators[i])
+				count++;
+		}
+		if (count != pdata->num_regulators)
+			return -EINVAL;
+	}
+
+	config.dev = chip->dev;
+	config.regmap = chip->subchip->regmap_power;
+	for (i = 0; i < PM800_ID_RG_MAX; i++) {
+		struct regulator_dev *regulator;
+
+		if (pdata && pdata->num_regulators) {
+			init_data = pdata->regulators[i];
+			if (!init_data)
+				continue;
+
+			config.init_data = init_data;
+		}
+
+		config.driver_data = &pm800_regulator_info[i];
+
+		regulator = devm_regulator_register(&pdev->dev,
+				&pm800_regulator_info[i].desc, &config);
+		if (IS_ERR(regulator)) {
+			ret = PTR_ERR(regulator);
+			dev_err(&pdev->dev, "Failed to register %s\n",
+					pm800_regulator_info[i].desc.name);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct platform_driver pm800_regulator_driver = {
+	.driver		= {
+		.name	= "88pm80x-regulator",
+	},
+	.probe		= pm800_regulator_probe,
+};
+
+module_platform_driver(pm800_regulator_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joseph(Yossi) Hanin <yhanin@marvell.com>");
+MODULE_DESCRIPTION("Regulator Driver for Marvell 88PM800 PMIC");
+MODULE_ALIAS("platform:88pm800-regulator");
--- a/drivers/regulator/88pm800.c
+++ /dev/null
@@ -1,286 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Regulators driver for Marvell 88PM800
- *
- * Copyright (C) 2012 Marvell International Ltd.
- * Joseph(Yossi) Hanin <yhanin@marvell.com>
- * Yi Zhang <yizhang@marvell.com>
- */
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/regmap.h>
-#include <linux/regulator/driver.h>
-#include <linux/regulator/machine.h>
-#include <linux/mfd/88pm80x.h>
-#include <linux/delay.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/regulator/of_regulator.h>
-
-/* LDO1 with DVC[0..3] */
-#define PM800_LDO1_VOUT		(0x08) /* VOUT1 */
-#define PM800_LDO1_VOUT_2	(0x09)
-#define PM800_LDO1_VOUT_3	(0x0A)
-#define PM800_LDO2_VOUT		(0x0B)
-#define PM800_LDO3_VOUT		(0x0C)
-#define PM800_LDO4_VOUT		(0x0D)
-#define PM800_LDO5_VOUT		(0x0E)
-#define PM800_LDO6_VOUT		(0x0F)
-#define PM800_LDO7_VOUT		(0x10)
-#define PM800_LDO8_VOUT		(0x11)
-#define PM800_LDO9_VOUT		(0x12)
-#define PM800_LDO10_VOUT	(0x13)
-#define PM800_LDO11_VOUT	(0x14)
-#define PM800_LDO12_VOUT	(0x15)
-#define PM800_LDO13_VOUT	(0x16)
-#define PM800_LDO14_VOUT	(0x17)
-#define PM800_LDO15_VOUT	(0x18)
-#define PM800_LDO16_VOUT	(0x19)
-#define PM800_LDO17_VOUT	(0x1A)
-#define PM800_LDO18_VOUT	(0x1B)
-#define PM800_LDO19_VOUT	(0x1C)
-
-/* BUCK1 with DVC[0..3] */
-#define PM800_BUCK1		(0x3C)
-#define PM800_BUCK1_1		(0x3D)
-#define PM800_BUCK1_2		(0x3E)
-#define PM800_BUCK1_3		(0x3F)
-#define PM800_BUCK2		(0x40)
-#define PM800_BUCK3		(0x41)
-#define PM800_BUCK4		(0x42)
-#define PM800_BUCK4_1		(0x43)
-#define PM800_BUCK4_2		(0x44)
-#define PM800_BUCK4_3		(0x45)
-#define PM800_BUCK5		(0x46)
-
-#define PM800_BUCK_ENA		(0x50)
-#define PM800_LDO_ENA1_1	(0x51)
-#define PM800_LDO_ENA1_2	(0x52)
-#define PM800_LDO_ENA1_3	(0x53)
-
-#define PM800_LDO_ENA2_1	(0x56)
-#define PM800_LDO_ENA2_2	(0x57)
-#define PM800_LDO_ENA2_3	(0x58)
-
-#define PM800_BUCK1_MISC1	(0x78)
-#define PM800_BUCK3_MISC1	(0x7E)
-#define PM800_BUCK4_MISC1	(0x81)
-#define PM800_BUCK5_MISC1	(0x84)
-
-struct pm800_regulator_info {
-	struct regulator_desc desc;
-	int max_ua;
-};
-
-/*
- * vreg - the buck regs string.
- * ereg - the string for the enable register.
- * ebit - the bit number in the enable register.
- * amax - the current
- * Buck has 2 kinds of voltage steps. It is easy to find voltage by ranges,
- * not the constant voltage table.
- * n_volt - Number of available selectors
- */
-#define PM800_BUCK(match, vreg, ereg, ebit, amax, volt_ranges, n_volt)	\
-{									\
-	.desc	= {							\
-		.name			= #vreg,			\
-		.of_match		= of_match_ptr(#match),		\
-		.regulators_node	= of_match_ptr("regulators"),	\
-		.ops			= &pm800_volt_range_ops,	\
-		.type			= REGULATOR_VOLTAGE,		\
-		.id			= PM800_ID_##vreg,		\
-		.owner			= THIS_MODULE,			\
-		.n_voltages		= n_volt,			\
-		.linear_ranges		= volt_ranges,			\
-		.n_linear_ranges	= ARRAY_SIZE(volt_ranges),	\
-		.vsel_reg		= PM800_##vreg,			\
-		.vsel_mask		= 0x7f,				\
-		.enable_reg		= PM800_##ereg,			\
-		.enable_mask		= 1 << (ebit),			\
-	},								\
-	.max_ua	= (amax),						\
-}
-
-/*
- * vreg - the LDO regs string
- * ereg -  the string for the enable register.
- * ebit - the bit number in the enable register.
- * amax - the current
- * volt_table - the LDO voltage table
- * For all the LDOes, there are too many ranges. Using volt_table will be
- * simpler and faster.
- */
-#define PM800_LDO(match, vreg, ereg, ebit, amax, ldo_volt_table)	\
-{									\
-	.desc	= {							\
-		.name			= #vreg,			\
-		.of_match		= of_match_ptr(#match),		\
-		.regulators_node	= of_match_ptr("regulators"),	\
-		.ops			= &pm800_volt_table_ops,	\
-		.type			= REGULATOR_VOLTAGE,		\
-		.id			= PM800_ID_##vreg,		\
-		.owner			= THIS_MODULE,			\
-		.n_voltages		= ARRAY_SIZE(ldo_volt_table),	\
-		.vsel_reg		= PM800_##vreg##_VOUT,		\
-		.vsel_mask		= 0xf,				\
-		.enable_reg		= PM800_##ereg,			\
-		.enable_mask		= 1 << (ebit),			\
-		.volt_table		= ldo_volt_table,		\
-	},								\
-	.max_ua	= (amax),						\
-}
-
-/* Ranges are sorted in ascending order. */
-static const struct regulator_linear_range buck1_volt_range[] = {
-	REGULATOR_LINEAR_RANGE(600000, 0, 0x4f, 12500),
-	REGULATOR_LINEAR_RANGE(1600000, 0x50, 0x54, 50000),
-};
-
-/* BUCK 2~5 have same ranges. */
-static const struct regulator_linear_range buck2_5_volt_range[] = {
-	REGULATOR_LINEAR_RANGE(600000, 0, 0x4f, 12500),
-	REGULATOR_LINEAR_RANGE(1600000, 0x50, 0x72, 50000),
-};
-
-static const unsigned int ldo1_volt_table[] = {
-	600000,  650000,  700000,  750000,  800000,  850000,  900000,  950000,
-	1000000, 1050000, 1100000, 1150000, 1200000, 1300000, 1400000, 1500000,
-};
-
-static const unsigned int ldo2_volt_table[] = {
-	1700000, 1800000, 1900000, 2000000, 2100000, 2500000, 2700000, 2800000,
-};
-
-/* LDO 3~17 have same voltage table. */
-static const unsigned int ldo3_17_volt_table[] = {
-	1200000, 1250000, 1700000, 1800000, 1850000, 1900000, 2500000, 2600000,
-	2700000, 2750000, 2800000, 2850000, 2900000, 3000000, 3100000, 3300000,
-};
-
-/* LDO 18~19 have same voltage table. */
-static const unsigned int ldo18_19_volt_table[] = {
-	1700000, 1800000, 1900000, 2500000, 2800000, 2900000, 3100000, 3300000,
-};
-
-static int pm800_get_current_limit(struct regulator_dev *rdev)
-{
-	struct pm800_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return info->max_ua;
-}
-
-static const struct regulator_ops pm800_volt_range_ops = {
-	.list_voltage		= regulator_list_voltage_linear_range,
-	.map_voltage		= regulator_map_voltage_linear_range,
-	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
-	.enable			= regulator_enable_regmap,
-	.disable		= regulator_disable_regmap,
-	.is_enabled		= regulator_is_enabled_regmap,
-	.get_current_limit	= pm800_get_current_limit,
-};
-
-static const struct regulator_ops pm800_volt_table_ops = {
-	.list_voltage		= regulator_list_voltage_table,
-	.map_voltage		= regulator_map_voltage_iterate,
-	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
-	.enable			= regulator_enable_regmap,
-	.disable		= regulator_disable_regmap,
-	.is_enabled		= regulator_is_enabled_regmap,
-	.get_current_limit	= pm800_get_current_limit,
-};
-
-/* The array is indexed by id(PM800_ID_XXX) */
-static struct pm800_regulator_info pm800_regulator_info[] = {
-	PM800_BUCK(buck1, BUCK1, BUCK_ENA, 0, 3000000, buck1_volt_range, 0x55),
-	PM800_BUCK(buck2, BUCK2, BUCK_ENA, 1, 1200000, buck2_5_volt_range, 0x73),
-	PM800_BUCK(buck3, BUCK3, BUCK_ENA, 2, 1200000, buck2_5_volt_range, 0x73),
-	PM800_BUCK(buck4, BUCK4, BUCK_ENA, 3, 1200000, buck2_5_volt_range, 0x73),
-	PM800_BUCK(buck5, BUCK5, BUCK_ENA, 4, 1200000, buck2_5_volt_range, 0x73),
-
-	PM800_LDO(ldo1, LDO1, LDO_ENA1_1, 0, 200000, ldo1_volt_table),
-	PM800_LDO(ldo2, LDO2, LDO_ENA1_1, 1, 10000, ldo2_volt_table),
-	PM800_LDO(ldo3, LDO3, LDO_ENA1_1, 2, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo4, LDO4, LDO_ENA1_1, 3, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo5, LDO5, LDO_ENA1_1, 4, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo6, LDO6, LDO_ENA1_1, 5, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo7, LDO7, LDO_ENA1_1, 6, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo8, LDO8, LDO_ENA1_1, 7, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo9, LDO9, LDO_ENA1_2, 0, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo10, LDO10, LDO_ENA1_2, 1, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo11, LDO11, LDO_ENA1_2, 2, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo12, LDO12, LDO_ENA1_2, 3, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo13, LDO13, LDO_ENA1_2, 4, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo14, LDO14, LDO_ENA1_2, 5, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo15, LDO15, LDO_ENA1_2, 6, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo16, LDO16, LDO_ENA1_2, 7, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo17, LDO17, LDO_ENA1_3, 0, 300000, ldo3_17_volt_table),
-	PM800_LDO(ldo18, LDO18, LDO_ENA1_3, 1, 200000, ldo18_19_volt_table),
-	PM800_LDO(ldo19, LDO19, LDO_ENA1_3, 2, 200000, ldo18_19_volt_table),
-};
-
-static int pm800_regulator_probe(struct platform_device *pdev)
-{
-	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm80x_platform_data *pdata = dev_get_platdata(pdev->dev.parent);
-	struct regulator_config config = { };
-	struct regulator_init_data *init_data;
-	int i, ret;
-
-	if (pdata && pdata->num_regulators) {
-		unsigned int count = 0;
-
-		/* Check whether num_regulator is valid. */
-		for (i = 0; i < ARRAY_SIZE(pdata->regulators); i++) {
-			if (pdata->regulators[i])
-				count++;
-		}
-		if (count != pdata->num_regulators)
-			return -EINVAL;
-	}
-
-	config.dev = chip->dev;
-	config.regmap = chip->subchip->regmap_power;
-	for (i = 0; i < PM800_ID_RG_MAX; i++) {
-		struct regulator_dev *regulator;
-
-		if (pdata && pdata->num_regulators) {
-			init_data = pdata->regulators[i];
-			if (!init_data)
-				continue;
-
-			config.init_data = init_data;
-		}
-
-		config.driver_data = &pm800_regulator_info[i];
-
-		regulator = devm_regulator_register(&pdev->dev,
-				&pm800_regulator_info[i].desc, &config);
-		if (IS_ERR(regulator)) {
-			ret = PTR_ERR(regulator);
-			dev_err(&pdev->dev, "Failed to register %s\n",
-					pm800_regulator_info[i].desc.name);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
-static struct platform_driver pm800_regulator_driver = {
-	.driver		= {
-		.name	= "88pm80x-regulator",
-	},
-	.probe		= pm800_regulator_probe,
-};
-
-module_platform_driver(pm800_regulator_driver);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Joseph(Yossi) Hanin <yhanin@marvell.com>");
-MODULE_DESCRIPTION("Regulator Driver for Marvell 88PM800 PMIC");
-MODULE_ALIAS("platform:88pm800-regulator");
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER)
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_88PG86X) += 88pg86x.o
-obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
+obj-$(CONFIG_REGULATOR_88PM800) += 88pm800-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_CPCAP) += cpcap-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o


