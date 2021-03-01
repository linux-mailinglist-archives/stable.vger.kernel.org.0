Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F918328BEA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbhCASmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240180AbhCASgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:36:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D9D164E90;
        Mon,  1 Mar 2021 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620875;
        bh=JkWQT3/LvIZPt9XiNDGBoGlHvrIB192QLr8b9rLQjPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV/1WcTywQhdSU3UEcL/CQuiq8G/he5C7QadUnVhuXLvU9TiFdNX2M8pnn51aWzhW
         yRofYaIH5rqMufe/tWOlVV7YGFo8RMWnfgPKzwhIiXv4/Wtj6CPB0UloWu8yXwjWV+
         7XsZiR9Ya/URNz9HeiXrDYj7G2MtPUTHIR8u7A5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 312/775] regulator: qcom-rpmh-regulator: add pm8009-1 chip revision
Date:   Mon,  1 Mar 2021 17:08:00 +0100
Message-Id: <20210301161217.034081065@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 951384cabc5dfb09251d440dbc26058eba86f97e ]

PM8009 has special revision (P=1), which is to be used for sm8250
platform. The major difference is the S2 regulator which supplies 0.95 V
instead of 2.848V. Declare regulators data to be used for this chip
revision. The datasheet calls the chip just pm8009-1, so use the same
name.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 06369bcc15a1 ("regulator: qcom-rpmh: Add support for SM8150")
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20201231122348.637917-4-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 26 +++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index c395a8dda6f7c..98320e1d8bf66 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -732,6 +732,15 @@ static const struct rpmh_vreg_hw_data pmic5_hfsmps515 = {
 	.of_map_mode = rpmh_regulator_pmic4_smps_of_map_mode,
 };
 
+static const struct rpmh_vreg_hw_data pmic5_hfsmps515_1 = {
+	.regulator_type = VRM,
+	.ops = &rpmh_regulator_vrm_ops,
+	.voltage_range = REGULATOR_LINEAR_RANGE(900000, 0, 4, 16000),
+	.n_voltages = 5,
+	.pmic_mode_map = pmic_mode_map_pmic5_smps,
+	.of_map_mode = rpmh_regulator_pmic4_smps_of_map_mode,
+};
+
 static const struct rpmh_vreg_hw_data pmic5_bob = {
 	.regulator_type = VRM,
 	.ops = &rpmh_regulator_vrm_bypass_ops,
@@ -932,6 +941,19 @@ static const struct rpmh_vreg_init_data pm8009_vreg_data[] = {
 	{},
 };
 
+static const struct rpmh_vreg_init_data pm8009_1_vreg_data[] = {
+	RPMH_VREG("smps1",  "smp%s1",  &pmic5_hfsmps510, "vdd-s1"),
+	RPMH_VREG("smps2",  "smp%s2",  &pmic5_hfsmps515_1, "vdd-s2"),
+	RPMH_VREG("ldo1",   "ldo%s1",  &pmic5_nldo,      "vdd-l1"),
+	RPMH_VREG("ldo2",   "ldo%s2",  &pmic5_nldo,      "vdd-l2"),
+	RPMH_VREG("ldo3",   "ldo%s3",  &pmic5_nldo,      "vdd-l3"),
+	RPMH_VREG("ldo4",   "ldo%s4",  &pmic5_nldo,      "vdd-l4"),
+	RPMH_VREG("ldo5",   "ldo%s5",  &pmic5_pldo,      "vdd-l5-l6"),
+	RPMH_VREG("ldo6",   "ldo%s6",  &pmic5_pldo,      "vdd-l5-l6"),
+	RPMH_VREG("ldo7",   "ldo%s6",  &pmic5_pldo_lv,   "vdd-l7"),
+	{},
+};
+
 static const struct rpmh_vreg_init_data pm6150_vreg_data[] = {
 	RPMH_VREG("smps1",  "smp%s1",  &pmic5_ftsmps510, "vdd-s1"),
 	RPMH_VREG("smps2",  "smp%s2",  &pmic5_ftsmps510, "vdd-s2"),
@@ -1057,6 +1079,10 @@ static const struct of_device_id __maybe_unused rpmh_regulator_match_table[] = {
 		.compatible = "qcom,pm8009-rpmh-regulators",
 		.data = pm8009_vreg_data,
 	},
+	{
+		.compatible = "qcom,pm8009-1-rpmh-regulators",
+		.data = pm8009_1_vreg_data,
+	},
 	{
 		.compatible = "qcom,pm8150-rpmh-regulators",
 		.data = pm8150_vreg_data,
-- 
2.27.0



