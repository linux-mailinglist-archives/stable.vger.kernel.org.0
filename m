Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21F82014EB
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391292AbgFSQPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391027AbgFSPDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:03:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4EFA206DB;
        Fri, 19 Jun 2020 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579015;
        bh=ujyQJqUvgdZO7Pb1fTZntoKYQuPFQt9RaNQCCADeNPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znFphclSTC/RnsigomHrMzKCZAGYcG9FGJcfuba+CSqh4UwHxxjGZBhggYpLeSXAs
         Os46JRKzggCuk2Vmh4lsgOekdQzd01O8vFGqmmQPkxRSx7NLr8igAimzRotbLFQzdn
         t3PGEnxOoQB6YO0Ykjt9BFFksIMUhqyf/hbHVOx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 243/267] pinctrl: samsung: Correct setting of eint wakeup mask on s5pv210
Date:   Fri, 19 Jun 2020 16:33:48 +0200
Message-Id: <20200619141700.350958958@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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
@@ -350,6 +352,47 @@ static int exynos_wkup_irq_set_wake(stru
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
@@ -368,8 +411,9 @@ static const struct exynos_irq_chip s5pv
 	.eint_mask = EXYNOS_WKUP_EMASK_OFFSET,
 	.eint_pend = EXYNOS_WKUP_EPEND_OFFSET,
 	.eint_wake_mask_value = EXYNOS_EINT_WAKEUP_MASK_DISABLED,
-	/* Only difference with exynos4210_wkup_irq_chip: */
+	/* Only differences with exynos4210_wkup_irq_chip: */
 	.eint_wake_mask_reg = S5PV210_EINT_WAKEUP_MASK,
+	.set_eint_wakeup_mask = s5pv210_pinctrl_set_eint_wakeup_mask,
 };
 
 static const struct exynos_irq_chip exynos4210_wkup_irq_chip __initconst = {
@@ -388,6 +432,7 @@ static const struct exynos_irq_chip exyn
 	.eint_pend = EXYNOS_WKUP_EPEND_OFFSET,
 	.eint_wake_mask_value = EXYNOS_EINT_WAKEUP_MASK_DISABLED,
 	.eint_wake_mask_reg = EXYNOS_EINT_WAKEUP_MASK,
+	.set_eint_wakeup_mask = exynos_pinctrl_set_eint_wakeup_mask,
 };
 
 static const struct exynos_irq_chip exynos7_wkup_irq_chip __initconst = {
@@ -406,6 +451,7 @@ static const struct exynos_irq_chip exyn
 	.eint_pend = EXYNOS7_WKUP_EPEND_OFFSET,
 	.eint_wake_mask_value = EXYNOS_EINT_WAKEUP_MASK_DISABLED,
 	.eint_wake_mask_reg = EXYNOS5433_EINT_WAKEUP_MASK,
+	.set_eint_wakeup_mask = exynos_pinctrl_set_eint_wakeup_mask,
 };
 
 /* list of external wakeup controllers supported */
@@ -582,27 +628,6 @@ int exynos_eint_wkup_init(struct samsung
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
@@ -634,8 +659,8 @@ void exynos_pinctrl_suspend(struct samsu
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


