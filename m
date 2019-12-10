Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB93311994F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfLJVp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbfLJVc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:32:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 769A2207FF;
        Tue, 10 Dec 2019 21:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013578;
        bh=4kXjjOFfrXdAo6YkWOkkrF2W8LEiP/qW5gwyvKK11O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5rZvDQP3cs401Axo/IPLKIbXf7XFetjjRBiQw9EXzY1H5hNHsVzHSDGQiC+6vWb3
         BuFNPhWu6tHOltLIqJYvU9P56DbgMtzm8HbxcOU8/3p9z4+ToxmR+V76f/U58k373o
         7IaMimYuLaD+X8Piq8+27w3eJGXicIqXQTX8O0uQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yizhuo <yzhai003@ucr.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 030/177] regulator: max8907: Fix the usage of uninitialized variable in max8907_regulator_probe()
Date:   Tue, 10 Dec 2019 16:29:54 -0500
Message-Id: <20191210213221.11921-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yizhuo <yzhai003@ucr.edu>

[ Upstream commit 472b39c3d1bba0616eb0e9a8fa3ad0f56927c7d7 ]

Inside function max8907_regulator_probe(), variable val could
be uninitialized if regmap_read() fails. However, val is used
later in the if statement to decide the content written to
"pmic", which is potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
Link: https://lore.kernel.org/r/20191003175813.16415-1-yzhai003@ucr.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max8907-regulator.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 860400d2cd859..a8f2f07239fb9 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -299,7 +299,10 @@ static int max8907_regulator_probe(struct platform_device *pdev)
 	memcpy(pmic->desc, max8907_regulators, sizeof(pmic->desc));
 
 	/* Backwards compatibility with MAX8907B; SD1 uses different voltages */
-	regmap_read(max8907->regmap_gen, MAX8907_REG_II2RR, &val);
+	ret = regmap_read(max8907->regmap_gen, MAX8907_REG_II2RR, &val);
+	if (ret)
+		return ret;
+
 	if ((val & MAX8907_II2RR_VERSION_MASK) ==
 	    MAX8907_II2RR_VERSION_REV_B) {
 		pmic->desc[MAX8907_SD1].min_uV = 637500;
@@ -336,14 +339,20 @@ static int max8907_regulator_probe(struct platform_device *pdev)
 		}
 
 		if (pmic->desc[i].ops == &max8907_ldo_ops) {
-			regmap_read(config.regmap, pmic->desc[i].enable_reg,
+			ret = regmap_read(config.regmap, pmic->desc[i].enable_reg,
 				    &val);
+			if (ret)
+				return ret;
+
 			if ((val & MAX8907_MASK_LDO_SEQ) !=
 			    MAX8907_MASK_LDO_SEQ)
 				pmic->desc[i].ops = &max8907_ldo_hwctl_ops;
 		} else if (pmic->desc[i].ops == &max8907_out5v_ops) {
-			regmap_read(config.regmap, pmic->desc[i].enable_reg,
+			ret = regmap_read(config.regmap, pmic->desc[i].enable_reg,
 				    &val);
+			if (ret)
+				return ret;
+
 			if ((val & (MAX8907_MASK_OUT5V_VINEN |
 						MAX8907_MASK_OUT5V_ENSRC)) !=
 			    MAX8907_MASK_OUT5V_ENSRC)
-- 
2.20.1

