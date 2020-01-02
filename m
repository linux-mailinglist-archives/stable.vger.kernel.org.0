Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3AD12EF1A
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgABWnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728341AbgABWeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:34:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD3320866;
        Thu,  2 Jan 2020 22:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004463;
        bh=Y6oTPyUWl/LYXYiiXw8VnlrTivTKYu9uWlex9b/y5nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGOuBZZla0WedbfUfZ+Qi0VwrLRnJHxu9NBqze0R63sFWAA191nLaoBAN7/pR5x3T
         hl5QQFGTDj3Sgy3hrpIOT2lR4sASWwF4F9Q/JtlxftyNj+XL0iceq/xiR8N8qZ2sVU
         MSP3tiAEBVm2/GlDWahhZt2Xo4MmlUQuyV9iV56k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yizhuo <yzhai003@ucr.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 018/137] regulator: max8907: Fix the usage of uninitialized variable in max8907_regulator_probe()
Date:   Thu,  2 Jan 2020 23:06:31 +0100
Message-Id: <20200102220549.118412336@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5e941db5ccaf..c7e70cfb581f 100644
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



