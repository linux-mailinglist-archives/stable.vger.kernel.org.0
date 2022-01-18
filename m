Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F47D491A1B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiARC6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbiARCoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:44:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 622B6B81235;
        Tue, 18 Jan 2022 02:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDACC36AF3;
        Tue, 18 Jan 2022 02:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473857;
        bh=oxD4SZxbk/IfGdi8uub6L4h5OJsot3+ZJKCvxuH8tI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvZlvwQ9t6mxZmdX+La1COxn62bORErXpbgfrpKlgMxdmpvkrIDatVHjzUYi5XycR
         EYWDMj6Wgrt/DmTi8lFi861hhuiFwFR2wFNGdlrNtpkt1nTAKeIV1v6s+06xTZwqRm
         xCdEtlGUyBc3/V9f71wyUf6kKu7NYM1EISyth27E+NRvJsZjot3PONspAONikU6Sf5
         U6j5jPww2t9N1UE4DPgrnu4ULUqgSxzmo+t6uCVkBogRQ01ylZE+wcWIwtJhuZSjYU
         b0Bn/Lb3XC170h4CGPKCI14Q9YBPMIAbO56/Qat+m+HiLhW90sLPYNrAG9VFrMfzrQ
         ypprgNhOyLc3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, lgirdwood@gmail.com,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 109/116] regulator: qcom_smd: Align probe function with rpmh-regulator
Date:   Mon, 17 Jan 2022 21:40:00 -0500
Message-Id: <20220118024007.1950576-109-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 14e2976fbabdacb01335d7f91eeebbc89c67ddb1 ]

The RPMh regulator driver is much newer and gets more attention, which in
consequence makes it do a few things better. Update qcom_smd-regulator's
probe function to mimic what rpmh-regulator does to address a couple of
issues:

- Probe defer now works correctly, before it used to, well,
  kinda just die.. This fixes reliable probing on (at least) PM8994,
  because Linux apparently cannot deal with supply map dependencies yet..

- Regulator data is now matched more sanely: regulator data is matched
  against each individual regulator node name and throwing an -EINVAL if
  data is missing, instead of just assuming everything is fine and
  iterating over all subsequent array members.

- status = "disabled" will now work for disabling individual regulators in
  DT. Previously it didn't seem to do much if anything at all.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20211230023442.1123424-1-konrad.dybcio@somainline.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_smd-regulator.c | 100 +++++++++++++++++--------
 1 file changed, 70 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/qcom_smd-regulator.c b/drivers/regulator/qcom_smd-regulator.c
index bb944ee5fe3b1..03e146e98abd5 100644
--- a/drivers/regulator/qcom_smd-regulator.c
+++ b/drivers/regulator/qcom_smd-regulator.c
@@ -9,6 +9,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/soc/qcom/smd-rpm.h>
 
 struct qcom_rpm_reg {
@@ -1107,52 +1108,91 @@ static const struct of_device_id rpm_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, rpm_of_match);
 
-static int rpm_reg_probe(struct platform_device *pdev)
+/**
+ * rpm_regulator_init_vreg() - initialize all attributes of a qcom_smd-regulator
+ * @vreg:		Pointer to the individual qcom_smd-regulator resource
+ * @dev:		Pointer to the top level qcom_smd-regulator PMIC device
+ * @node:		Pointer to the individual qcom_smd-regulator resource
+ *			device node
+ * @rpm:		Pointer to the rpm bus node
+ * @pmic_rpm_data:	Pointer to a null-terminated array of qcom_smd-regulator
+ *			resources defined for the top level PMIC device
+ *
+ * Return: 0 on success, errno on failure
+ */
+static int rpm_regulator_init_vreg(struct qcom_rpm_reg *vreg, struct device *dev,
+				   struct device_node *node, struct qcom_smd_rpm *rpm,
+				   const struct rpm_regulator_data *pmic_rpm_data)
 {
-	const struct rpm_regulator_data *reg;
-	const struct of_device_id *match;
-	struct regulator_config config = { };
+	struct regulator_config config = {};
+	const struct rpm_regulator_data *rpm_data;
 	struct regulator_dev *rdev;
+	int ret;
+
+	for (rpm_data = pmic_rpm_data; rpm_data->name; rpm_data++)
+		if (of_node_name_eq(node, rpm_data->name))
+			break;
+
+	if (!rpm_data->name) {
+		dev_err(dev, "Unknown regulator %pOFn\n", node);
+		return -EINVAL;
+	}
+
+	vreg->dev	= dev;
+	vreg->rpm	= rpm;
+	vreg->type	= rpm_data->type;
+	vreg->id	= rpm_data->id;
+
+	memcpy(&vreg->desc, rpm_data->desc, sizeof(vreg->desc));
+	vreg->desc.name = rpm_data->name;
+	vreg->desc.supply_name = rpm_data->supply;
+	vreg->desc.owner = THIS_MODULE;
+	vreg->desc.type = REGULATOR_VOLTAGE;
+	vreg->desc.of_match = rpm_data->name;
+
+	config.dev		= dev;
+	config.of_node		= node;
+	config.driver_data	= vreg;
+
+	rdev = devm_regulator_register(dev, &vreg->desc, &config);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(dev, "%pOFn: devm_regulator_register() failed, ret=%d\n", node, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int rpm_reg_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct rpm_regulator_data *vreg_data;
+	struct device_node *node;
 	struct qcom_rpm_reg *vreg;
 	struct qcom_smd_rpm *rpm;
+	int ret;
 
 	rpm = dev_get_drvdata(pdev->dev.parent);
 	if (!rpm) {
-		dev_err(&pdev->dev, "unable to retrieve handle to rpm\n");
+		dev_err(&pdev->dev, "Unable to retrieve handle to rpm\n");
 		return -ENODEV;
 	}
 
-	match = of_match_device(rpm_of_match, &pdev->dev);
-	if (!match) {
-		dev_err(&pdev->dev, "failed to match device\n");
+	vreg_data = of_device_get_match_data(dev);
+	if (!vreg_data)
 		return -ENODEV;
-	}
 
-	for (reg = match->data; reg->name; reg++) {
+	for_each_available_child_of_node(dev->of_node, node) {
 		vreg = devm_kzalloc(&pdev->dev, sizeof(*vreg), GFP_KERNEL);
 		if (!vreg)
 			return -ENOMEM;
 
-		vreg->dev = &pdev->dev;
-		vreg->type = reg->type;
-		vreg->id = reg->id;
-		vreg->rpm = rpm;
-
-		memcpy(&vreg->desc, reg->desc, sizeof(vreg->desc));
-
-		vreg->desc.id = -1;
-		vreg->desc.owner = THIS_MODULE;
-		vreg->desc.type = REGULATOR_VOLTAGE;
-		vreg->desc.name = reg->name;
-		vreg->desc.supply_name = reg->supply;
-		vreg->desc.of_match = reg->name;
-
-		config.dev = &pdev->dev;
-		config.driver_data = vreg;
-		rdev = devm_regulator_register(&pdev->dev, &vreg->desc, &config);
-		if (IS_ERR(rdev)) {
-			dev_err(&pdev->dev, "failed to register %s\n", reg->name);
-			return PTR_ERR(rdev);
+		ret = rpm_regulator_init_vreg(vreg, dev, node, rpm, vreg_data);
+
+		if (ret < 0) {
+			of_node_put(node);
+			return ret;
 		}
 	}
 
-- 
2.34.1

