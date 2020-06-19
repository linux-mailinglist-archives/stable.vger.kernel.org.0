Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B2E201094
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404591AbgFSPbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393647AbgFSPbj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C162166E;
        Fri, 19 Jun 2020 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580698;
        bh=PfzJCVDK9V9rMaGp3ZQwzgzgVUD0NoaOUgkrbzkxG9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWyqPydTiY2TD10gMqiO+d6WZYeE0Ehg4CkJ8lUPazsPak3REMZPklHChtahHUx4l
         RToPCbKSpr5y1BcDt5woyFK4Ro0r4L/PgoQsT+DvrZSWCHNBKQMQypTi5d6LmH5PvO
         jVZQfFIZgntY3k1lDbDXAMTdzhRS5KHXJ1rrG870=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.7 318/376] pinctrl: samsung: Correct setting of eint wakeup mask on s5pv210
Date:   Fri, 19 Jun 2020 16:33:56 +0200
Message-Id: <20200619141725.384183554@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

commit b577a279914085c6b657c33e9f39ef56d96a3302 upstream.

Commit a8be2af0218c ("pinctrl: samsung: Write external wakeup interrupt
mask") started writing the eint wakeup mask from the pinctrl driver.
Unfortunately, it made the assumption that the private retention data
was always a regmap while in the case of s5pv210 it is a raw pointer
to the clock base (as the eint wakeup mask not in the PMU as with newer
Exynos platforms).

Fixes: a8be2af0218c ("pinctrl: samsung: Write external wakeup interrupt mask")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/samsung/pinctrl-exynos.c |   73 ++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 24 deletions(-)

--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -40,6 +40,8 @@ struct exynos_irq_chip {
 	u32 eint_pend;
 	u32 eint_wake_mask_value;
 	u32 eint_wake_mask_reg;
+	void (*set_eint_wakeup_mask)(struct samsung_pinctrl_drv_data *drvdata,
+				     struct exynos_irq_chip *irq_chip);
 };
 
 static inline struct exynos_irq_chip *to_exynos_irq_chip(struct irq_chip *chip)
@@ -342,6 +344,47 @@ static int exynos_wkup_irq_set_wake(stru
 	return 0;
 }
 
+static void
+exynos_pinctrl_set_eint_wakeup_mask(struct samsung_pinctrl_drv_data *drvdata,
+				    struct exynos_irq_chip *irq_chip)
+{
+	struct regmap *pmu_regs;
+
+	if (!drvdata->retention_ctrl || !drvdata->retention_ctrl->priv) {
+		dev_warn(drvdata->dev,
+			 "No retention data configured bank with external wakeup interrupt. Wake-up mask will not be set.\n");
+		return;
+	}
+
+	pmu_regs = drvdata->retention_ctrl->priv;
+	dev_info(drvdata->dev,
+		 "Setting external wakeup interrupt mask: 0x%x\n",
+		 irq_chip->eint_wake_mask_value);
+
+	regmap_write(pmu_regs, irq_chip->eint_wake_mask_reg,
+		     irq_chip->eint_wake_mask_value);
+}
+
+static void
+s5pv210_pinctrl_set_eint_wakeup_mask(struct samsung_pinctrl_drv_data *drvdata,
+				    struct exynos_irq_chip *irq_chip)
+
+{
+	void __iomem *clk_base;
+
+	if (!drvdata->retention_ctrl || !drvdata->retention_ctrl->priv) {
+		dev_warn(drvdata->dev,
+			 "No retention data configured bank with external wakeup interrupt. Wake-up mask will not be set.\n");
+		return;
+	}
+
+
+	clk_base = (void __iomem *) drvdata->retention_ctrl->priv;
+
+	__raw_writel(irq_chip->eint_wake_mask_value,
+		     clk_base + irq_chip->eint_wake_mask_reg);
+}
+
 /*
  * irq_chip for wakeup interrupts
  */
@@ -360,8 +403,9 @@ static const struct exynos_irq_chip s5pv
 	.eint_mask = EXYNOS_WKUP_EMASK_OFFSET,
 	.eint_pend = EXYNOS_WKUP_EPEND_OFFSET,
 	.eint_wake_mask_value = EXYNOS_EINT_WAKEUP_MASK_DISABLED,
-	/* Only difference with exynos4210_wkup_irq_chip: */
+	/* Only differences with exynos4210_wkup_irq_chip: */
 	.eint_wake_mask_reg = S5PV210_EINT_WAKEUP_MASK,
+	.set_eint_wakeup_mask = s5pv210_pinctrl_set_eint_wakeup_mask,
 };
 
 static const struct exynos_irq_chip exynos4210_wkup_irq_chip __initconst = {
@@ -380,6 +424,7 @@ static const struct exynos_irq_chip exyn
 	.eint_pend = EXYNOS_WKUP_EPEND_OFFSET,
 	.eint_wake_mask_value = EXYNOS_EINT_WAKEUP_MASK_DISABLED,
 	.eint_wake_mask_reg = EXYNOS_EINT_WAKEUP_MASK,
+	.set_eint_wakeup_mask = exynos_pinctrl_set_eint_wakeup_mask,
 };
 
 static const struct exynos_irq_chip exynos7_wkup_irq_chip __initconst = {
@@ -398,6 +443,7 @@ static const struct exynos_irq_chip exyn
 	.eint_pend = EXYNOS7_WKUP_EPEND_OFFSET,
 	.eint_wake_mask_value = EXYNOS_EINT_WAKEUP_MASK_DISABLED,
 	.eint_wake_mask_reg = EXYNOS5433_EINT_WAKEUP_MASK,
+	.set_eint_wakeup_mask = exynos_pinctrl_set_eint_wakeup_mask,
 };
 
 /* list of external wakeup controllers supported */
@@ -574,27 +620,6 @@ int exynos_eint_wkup_init(struct samsung
 	return 0;
 }
 
-static void
-exynos_pinctrl_set_eint_wakeup_mask(struct samsung_pinctrl_drv_data *drvdata,
-				    struct exynos_irq_chip *irq_chip)
-{
-	struct regmap *pmu_regs;
-
-	if (!drvdata->retention_ctrl || !drvdata->retention_ctrl->priv) {
-		dev_warn(drvdata->dev,
-			 "No retention data configured bank with external wakeup interrupt. Wake-up mask will not be set.\n");
-		return;
-	}
-
-	pmu_regs = drvdata->retention_ctrl->priv;
-	dev_info(drvdata->dev,
-		 "Setting external wakeup interrupt mask: 0x%x\n",
-		 irq_chip->eint_wake_mask_value);
-
-	regmap_write(pmu_regs, irq_chip->eint_wake_mask_reg,
-		     irq_chip->eint_wake_mask_value);
-}
-
 static void exynos_pinctrl_suspend_bank(
 				struct samsung_pinctrl_drv_data *drvdata,
 				struct samsung_pin_bank *bank)
@@ -626,8 +651,8 @@ void exynos_pinctrl_suspend(struct samsu
 		else if (bank->eint_type == EINT_TYPE_WKUP) {
 			if (!irq_chip) {
 				irq_chip = bank->irq_chip;
-				exynos_pinctrl_set_eint_wakeup_mask(drvdata,
-								    irq_chip);
+				irq_chip->set_eint_wakeup_mask(drvdata,
+							       irq_chip);
 			} else if (bank->irq_chip != irq_chip) {
 				dev_warn(drvdata->dev,
 					 "More than one external wakeup interrupt chip configured (bank: %s). This is not supported by hardware nor by driver.\n",


