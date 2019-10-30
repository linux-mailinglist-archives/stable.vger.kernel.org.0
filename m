Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBCEE9F86
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfJ3Ptk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbfJ3Ptj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:49:39 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 586D520856;
        Wed, 30 Oct 2019 15:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450577;
        bh=2gC/bJ0oby1GNZ3ISJrOD1/bvxN8Jty6VARn0EC+Dr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVfwZLxF22quka7qj9OTJ6epaKZrutuzs78yQzCtp/YKzG3dmzR84x7YeWPtkVFzb
         +Wb1qqHA6uqklKum083Z51UrS650UcvAWcZIH70j7z33IITNNAAPpi8nJAFZbVFyK0
         F+jtS9qh8ivbq2YqayayOiYAhpwlTXLT0TNMKMG0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 04/81] regulator: da9062: fix suspend_enable/disable preparation
Date:   Wed, 30 Oct 2019 11:48:10 -0400
Message-Id: <20191030154928.9432-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit a72865f057820ea9f57597915da4b651d65eb92f ]

Currently the suspend reg_field maps to the pmic voltage selection bits
and is used during suspend_enabe/disable() and during get_mode(). This
seems to be wrong for both use cases.

Use case one (suspend_enabe/disable):
Those callbacks are used to mark a regulator device as enabled/disabled
during suspend. Marking the regulator enabled during suspend is done by
the LDOx_CONF/BUCKx_CONF bit within the LDOx_CONT/BUCKx_CONT registers.
Setting this bit tells the DA9062 PMIC state machine to keep the
regulator on in POWERDOWN mode and switch to suspend voltage.

Use case two (get_mode):
The get_mode callback is used to retrieve the active mode state. Since
the regulator-setting-A is used for the active state and
regulator-setting-B for the suspend state there is no need to check
which regulator setting is active.

Fixes: 4068e5182ada ("regulator: da9062: DA9062 regulator driver")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Link: https://lore.kernel.org/r/20190917124246.11732-2-m.felsch@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9062-regulator.c | 118 +++++++++++----------------
 1 file changed, 47 insertions(+), 71 deletions(-)

diff --git a/drivers/regulator/da9062-regulator.c b/drivers/regulator/da9062-regulator.c
index 2ffc64622451e..9b2ca472f70c5 100644
--- a/drivers/regulator/da9062-regulator.c
+++ b/drivers/regulator/da9062-regulator.c
@@ -136,7 +136,6 @@ static int da9062_buck_set_mode(struct regulator_dev *rdev, unsigned mode)
 static unsigned da9062_buck_get_mode(struct regulator_dev *rdev)
 {
 	struct da9062_regulator *regl = rdev_get_drvdata(rdev);
-	struct regmap_field *field;
 	unsigned int val, mode = 0;
 	int ret;
 
@@ -158,18 +157,7 @@ static unsigned da9062_buck_get_mode(struct regulator_dev *rdev)
 		return REGULATOR_MODE_NORMAL;
 	}
 
-	/* Detect current regulator state */
-	ret = regmap_field_read(regl->suspend, &val);
-	if (ret < 0)
-		return 0;
-
-	/* Read regulator mode from proper register, depending on state */
-	if (val)
-		field = regl->suspend_sleep;
-	else
-		field = regl->sleep;
-
-	ret = regmap_field_read(field, &val);
+	ret = regmap_field_read(regl->sleep, &val);
 	if (ret < 0)
 		return 0;
 
@@ -208,21 +196,9 @@ static int da9062_ldo_set_mode(struct regulator_dev *rdev, unsigned mode)
 static unsigned da9062_ldo_get_mode(struct regulator_dev *rdev)
 {
 	struct da9062_regulator *regl = rdev_get_drvdata(rdev);
-	struct regmap_field *field;
 	int ret, val;
 
-	/* Detect current regulator state */
-	ret = regmap_field_read(regl->suspend, &val);
-	if (ret < 0)
-		return 0;
-
-	/* Read regulator mode from proper register, depending on state */
-	if (val)
-		field = regl->suspend_sleep;
-	else
-		field = regl->sleep;
-
-	ret = regmap_field_read(field, &val);
+	ret = regmap_field_read(regl->sleep, &val);
 	if (ret < 0)
 		return 0;
 
@@ -408,10 +384,10 @@ static const struct da9062_regulator_info local_da9061_regulator_info[] = {
 			__builtin_ffs((int)DA9062AA_BUCK1_MODE_MASK) - 1,
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_BUCK1_MODE_MASK)) - 1),
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VBUCK1_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_BUCK1_CONT,
+			__builtin_ffs((int)DA9062AA_BUCK1_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VBUCK1_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_BUCK1_CONF_MASK) - 1),
 	},
 	{
 		.desc.id = DA9061_ID_BUCK2,
@@ -444,10 +420,10 @@ static const struct da9062_regulator_info local_da9061_regulator_info[] = {
 			__builtin_ffs((int)DA9062AA_BUCK3_MODE_MASK) - 1,
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_BUCK3_MODE_MASK)) - 1),
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VBUCK3_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_BUCK3_CONT,
+			__builtin_ffs((int)DA9062AA_BUCK3_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VBUCK3_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_BUCK3_CONF_MASK) - 1),
 	},
 	{
 		.desc.id = DA9061_ID_BUCK3,
@@ -480,10 +456,10 @@ static const struct da9062_regulator_info local_da9061_regulator_info[] = {
 			__builtin_ffs((int)DA9062AA_BUCK4_MODE_MASK) - 1,
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_BUCK4_MODE_MASK)) - 1),
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VBUCK4_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_BUCK4_CONT,
+			__builtin_ffs((int)DA9062AA_BUCK4_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VBUCK4_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_BUCK4_CONF_MASK) - 1),
 	},
 	{
 		.desc.id = DA9061_ID_LDO1,
@@ -509,10 +485,10 @@ static const struct da9062_regulator_info local_da9061_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO1_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO1_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO1_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO1_CONT,
+			__builtin_ffs((int)DA9062AA_LDO1_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO1_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO1_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO1_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
@@ -542,10 +518,10 @@ static const struct da9062_regulator_info local_da9061_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO2_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO2_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO2_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO2_CONT,
+			__builtin_ffs((int)DA9062AA_LDO2_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO2_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO2_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO2_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
@@ -575,10 +551,10 @@ static const struct da9062_regulator_info local_da9061_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO3_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO3_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO3_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO3_CONT,
+			__builtin_ffs((int)DA9062AA_LDO3_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO3_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO3_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO3_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
@@ -608,10 +584,10 @@ static const struct da9062_regulator_info local_da9061_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO4_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO4_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO4_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO4_CONT,
+			__builtin_ffs((int)DA9062AA_LDO4_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO4_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO4_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO4_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
@@ -652,10 +628,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			__builtin_ffs((int)DA9062AA_BUCK1_MODE_MASK) - 1,
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_BUCK1_MODE_MASK)) - 1),
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VBUCK1_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_BUCK1_CONT,
+			__builtin_ffs((int)DA9062AA_BUCK1_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VBUCK1_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_BUCK1_CONF_MASK) - 1),
 	},
 	{
 		.desc.id = DA9062_ID_BUCK2,
@@ -688,10 +664,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			__builtin_ffs((int)DA9062AA_BUCK2_MODE_MASK) - 1,
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_BUCK2_MODE_MASK)) - 1),
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VBUCK2_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_BUCK2_CONT,
+			__builtin_ffs((int)DA9062AA_BUCK2_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VBUCK2_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_BUCK2_CONF_MASK) - 1),
 	},
 	{
 		.desc.id = DA9062_ID_BUCK3,
@@ -724,10 +700,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			__builtin_ffs((int)DA9062AA_BUCK3_MODE_MASK) - 1,
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_BUCK3_MODE_MASK)) - 1),
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VBUCK3_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_BUCK3_CONT,
+			__builtin_ffs((int)DA9062AA_BUCK3_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VBUCK3_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_BUCK3_CONF_MASK) - 1),
 	},
 	{
 		.desc.id = DA9062_ID_BUCK4,
@@ -760,10 +736,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			__builtin_ffs((int)DA9062AA_BUCK4_MODE_MASK) - 1,
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_BUCK4_MODE_MASK)) - 1),
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VBUCK4_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_BUCK4_CONT,
+			__builtin_ffs((int)DA9062AA_BUCK4_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VBUCK4_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_BUCK4_CONF_MASK) - 1),
 	},
 	{
 		.desc.id = DA9062_ID_LDO1,
@@ -789,10 +765,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO1_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO1_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO1_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO1_CONT,
+			__builtin_ffs((int)DA9062AA_LDO1_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO1_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO1_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO1_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
@@ -822,10 +798,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO2_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO2_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO2_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO2_CONT,
+			__builtin_ffs((int)DA9062AA_LDO2_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO2_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO2_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO2_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
@@ -855,10 +831,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO3_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO3_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO3_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO3_CONT,
+			__builtin_ffs((int)DA9062AA_LDO3_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO3_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO3_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO3_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
@@ -888,10 +864,10 @@ static const struct da9062_regulator_info local_da9062_regulator_info[] = {
 			sizeof(unsigned int) * 8 -
 			__builtin_clz((DA9062AA_LDO4_SL_B_MASK)) - 1),
 		.suspend_vsel_reg = DA9062AA_VLDO4_B,
-		.suspend = REG_FIELD(DA9062AA_DVC_1,
-			__builtin_ffs((int)DA9062AA_VLDO4_SEL_MASK) - 1,
+		.suspend = REG_FIELD(DA9062AA_LDO4_CONT,
+			__builtin_ffs((int)DA9062AA_LDO4_CONF_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-			__builtin_clz((DA9062AA_VLDO4_SEL_MASK)) - 1),
+			__builtin_clz(DA9062AA_LDO4_CONF_MASK) - 1),
 		.oc_event = REG_FIELD(DA9062AA_STATUS_D,
 			__builtin_ffs((int)DA9062AA_LDO4_ILIM_MASK) - 1,
 			sizeof(unsigned int) * 8 -
-- 
2.20.1

