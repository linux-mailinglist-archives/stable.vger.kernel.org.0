Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F57FF143
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfKPQK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbfKPPsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:47 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5F220891;
        Sat, 16 Nov 2019 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919326;
        bh=rh03igqzqmJ/spz57UkA4AWPIpnxHGzKIwHeAdn90AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxAlSTNrYFfP1ONT7cbn4x4kYoZNbyh0KlGoR9V3wnK7JJE8KsGWOO55xMh3mzWKD
         SZxAyr/90TNtpRG+Jxmo8b8rV0y6SJdhnxtd3yIIe2QsBCXQEnu0DGTj1jVrBrA3VA
         gPccRkwISCoTuiLxZY20/YiHI1P0/mmom0vwnsjQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 069/150] mfd: intel_soc_pmic_bxtwc: Chain power button IRQs as well
Date:   Sat, 16 Nov 2019 10:46:07 -0500
Message-Id: <20191116154729.9573-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9f8ddee1dab836ca758ca8fc555ab5a3aaa5d3fd ]

Power button IRQ actually has a second level of interrupts to
distinguish between UI and POWER buttons. Moreover, current
implementation looks awkward in approach to handle second level IRQs by
first level related IRQ chip.

To address above issues, split power button IRQ to be chained as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_bxtwc.c | 41 ++++++++++++++++++++++--------
 include/linux/mfd/intel_soc_pmic.h |  1 +
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index 15bc052704a6d..9ca1f8c015de9 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -31,8 +31,8 @@
 
 /* Interrupt Status Registers */
 #define BXTWC_IRQLVL1		0x4E02
-#define BXTWC_PWRBTNIRQ		0x4E03
 
+#define BXTWC_PWRBTNIRQ		0x4E03
 #define BXTWC_THRM0IRQ		0x4E04
 #define BXTWC_THRM1IRQ		0x4E05
 #define BXTWC_THRM2IRQ		0x4E06
@@ -47,10 +47,9 @@
 
 /* Interrupt MASK Registers */
 #define BXTWC_MIRQLVL1		0x4E0E
-#define BXTWC_MPWRTNIRQ		0x4E0F
-
 #define BXTWC_MIRQLVL1_MCHGR	BIT(5)
 
+#define BXTWC_MPWRBTNIRQ	0x4E0F
 #define BXTWC_MTHRM0IRQ		0x4E12
 #define BXTWC_MTHRM1IRQ		0x4E13
 #define BXTWC_MTHRM2IRQ		0x4E14
@@ -66,9 +65,7 @@
 /* Whiskey Cove PMIC share same ACPI ID between different platforms */
 #define BROXTON_PMIC_WC_HRV	4
 
-/* Manage in two IRQ chips since mask registers are not consecutive */
 enum bxtwc_irqs {
-	/* Level 1 */
 	BXTWC_PWRBTN_LVL1_IRQ = 0,
 	BXTWC_TMU_LVL1_IRQ,
 	BXTWC_THRM_LVL1_IRQ,
@@ -77,9 +74,11 @@ enum bxtwc_irqs {
 	BXTWC_CHGR_LVL1_IRQ,
 	BXTWC_GPIO_LVL1_IRQ,
 	BXTWC_CRIT_LVL1_IRQ,
+};
 
-	/* Level 2 */
-	BXTWC_PWRBTN_IRQ,
+enum bxtwc_irqs_pwrbtn {
+	BXTWC_PWRBTN_IRQ = 0,
+	BXTWC_UIBTN_IRQ,
 };
 
 enum bxtwc_irqs_bcu {
@@ -113,7 +112,10 @@ static const struct regmap_irq bxtwc_regmap_irqs[] = {
 	REGMAP_IRQ_REG(BXTWC_CHGR_LVL1_IRQ, 0, BIT(5)),
 	REGMAP_IRQ_REG(BXTWC_GPIO_LVL1_IRQ, 0, BIT(6)),
 	REGMAP_IRQ_REG(BXTWC_CRIT_LVL1_IRQ, 0, BIT(7)),
-	REGMAP_IRQ_REG(BXTWC_PWRBTN_IRQ, 1, 0x03),
+};
+
+static const struct regmap_irq bxtwc_regmap_irqs_pwrbtn[] = {
+	REGMAP_IRQ_REG(BXTWC_PWRBTN_IRQ, 0, 0x01),
 };
 
 static const struct regmap_irq bxtwc_regmap_irqs_bcu[] = {
@@ -125,7 +127,7 @@ static const struct regmap_irq bxtwc_regmap_irqs_adc[] = {
 };
 
 static const struct regmap_irq bxtwc_regmap_irqs_chgr[] = {
-	REGMAP_IRQ_REG(BXTWC_USBC_IRQ, 0, BIT(5)),
+	REGMAP_IRQ_REG(BXTWC_USBC_IRQ, 0, 0x20),
 	REGMAP_IRQ_REG(BXTWC_CHGR0_IRQ, 0, 0x1f),
 	REGMAP_IRQ_REG(BXTWC_CHGR1_IRQ, 1, 0x1f),
 };
@@ -144,7 +146,16 @@ static struct regmap_irq_chip bxtwc_regmap_irq_chip = {
 	.mask_base = BXTWC_MIRQLVL1,
 	.irqs = bxtwc_regmap_irqs,
 	.num_irqs = ARRAY_SIZE(bxtwc_regmap_irqs),
-	.num_regs = 2,
+	.num_regs = 1,
+};
+
+static struct regmap_irq_chip bxtwc_regmap_irq_chip_pwrbtn = {
+	.name = "bxtwc_irq_chip_pwrbtn",
+	.status_base = BXTWC_PWRBTNIRQ,
+	.mask_base = BXTWC_MPWRBTNIRQ,
+	.irqs = bxtwc_regmap_irqs_pwrbtn,
+	.num_irqs = ARRAY_SIZE(bxtwc_regmap_irqs_pwrbtn),
+	.num_regs = 1,
 };
 
 static struct regmap_irq_chip bxtwc_regmap_irq_chip_tmu = {
@@ -472,6 +483,16 @@ static int bxtwc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
+					 BXTWC_PWRBTN_LVL1_IRQ,
+					 IRQF_ONESHOT,
+					 &bxtwc_regmap_irq_chip_pwrbtn,
+					 &pmic->irq_chip_data_pwrbtn);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to add PWRBTN IRQ chip\n");
+		return ret;
+	}
+
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
 					 BXTWC_TMU_LVL1_IRQ,
 					 IRQF_ONESHOT,
diff --git a/include/linux/mfd/intel_soc_pmic.h b/include/linux/mfd/intel_soc_pmic.h
index 5aacdb017a9f6..806a4f095312b 100644
--- a/include/linux/mfd/intel_soc_pmic.h
+++ b/include/linux/mfd/intel_soc_pmic.h
@@ -25,6 +25,7 @@ struct intel_soc_pmic {
 	int irq;
 	struct regmap *regmap;
 	struct regmap_irq_chip_data *irq_chip_data;
+	struct regmap_irq_chip_data *irq_chip_data_pwrbtn;
 	struct regmap_irq_chip_data *irq_chip_data_tmu;
 	struct regmap_irq_chip_data *irq_chip_data_bcu;
 	struct regmap_irq_chip_data *irq_chip_data_adc;
-- 
2.20.1

