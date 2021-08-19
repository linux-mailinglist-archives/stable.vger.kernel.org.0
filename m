Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B9A3F1D21
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbhHSPoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240118AbhHSPon (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 11:44:43 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3328C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 08:44:06 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i28so13956934lfl.2
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 08:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T9paPDGfTpVw3uYEbqc7Bet1pVGV4S1sipYf2IwXY7I=;
        b=es6xPb5bhZRQcyASpWCmXBTZMioOx+xMa7MYOWC1BDJeYh0bxLDYvXOD7Q4HTrP53E
         P1BBM+2sUphiynr8ul6xVhLeuHh5vp0RLU0ZkvEoSwO+Zf4vojCTb9ahY+sF1ukyITBM
         OerZ+Svg6nC9LX0AFoL/wGNeRulX0qhQhP/G9L1Q/JRhN0Mzd0a3NvJCvcCaZRc+THN7
         9DEMvQFM4idjNtd1PJn1CcpLLCBJNiQ6EDuEBomuTHMCz/QCvp1bzsURGzoKkEb5yal8
         xCPpCDac0goreahGl++rpJ3MBn/kz8BfgiPc3fcDIFd445jiakcvfZ7bpZDHfhAUsa/j
         7cyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T9paPDGfTpVw3uYEbqc7Bet1pVGV4S1sipYf2IwXY7I=;
        b=mQgq/nB3PcOXfyH0rtK9JEZ6r+nCn09MmHYq9GXymX5hJgCZXaXemglegoNMkiOGfD
         9Hc9kWwD7YO0FLaQ4lh4NX40IW++uKrXl75Pb21MFKEVi1iZ/DH6pJ36GRigF1ax9tB7
         bINRk3QTOciKrXlpKSy2Y6DjrAth+OSRcpyvLsc0sjxvgxOGlwpCfotWK2Nlrb2l+eZM
         bOY26r/n8GJcEN07BBtqbFY7BSJfiemw57K/Qvkz4ZzwLIWYSVdf+dXnp+NN5ZbTMMoP
         iY506oOmGlvPqC7pweIovKbqRFJt9U/MNdNwnB8LIgpjNNNFlXsIqLO9Awp6xx+iFiFQ
         OQ5Q==
X-Gm-Message-State: AOAM530wmzJy6CCB/i/VnKxDOiBxe2XrsP1kfYl/WrNdYieofyQ6Z0N4
        7PYvPkplZVqQ3VQFoc+kkqGecFa2RKTJkg==
X-Google-Smtp-Source: ABdhPJzaKNa0RvqrUI0zpdaJzHQbMqTNaO9U2ouMQy6+ClSXy1UDLLXHgRSDexDfTHfvqw4bYm7qqg==
X-Received: by 2002:a05:6512:e83:: with SMTP id bi3mr1338219lfb.10.1629387844987;
        Thu, 19 Aug 2021 08:44:04 -0700 (PDT)
Received: from fedora.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id a7sm132946ljd.85.2021.08.19.08.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 08:44:04 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     lee.jones@linaro.org, linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        David Heidelberg <david@ixit.cz>, stable@vger.kernel.org
Subject: [PATCH] mfd: qcom-pm8xxx: Switch to nested IRQ handler
Date:   Thu, 19 Aug 2021 17:44:00 +0200
Message-Id: <20210819154400.51932-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After facing problems when using the chained interrupt for handling
the PM8xxx IRQs we solve the issue by simply requesting the IRQ
from the producer (in this case the TLMM) as any other IRQ, and
nesting any consumer IRQs.

Recently the driver is hanging during probe:
[    1.646990] ssbi 500000.qcom,ssbi: SSBI controller type: 'pmic-arbiter'
[    1.650901] pm8xxx_probe: PMIC revision 1: E3
[    1.655078] pm8xxx_probe: PMIC revision 2: 00
(...)
it just hangs after this.

I am unable to bisect down to what is causing this hang, but the
patch fixes the problem.

After this patch the DragonBoard APQ8060 boots to prompt without
problems.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: David Heidelberg <david@ixit.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/qcom-pm8xxx.c | 60 ++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/qcom-pm8xxx.c b/drivers/mfd/qcom-pm8xxx.c
index acd172ddcbd6..223aed53aad8 100644
--- a/drivers/mfd/qcom-pm8xxx.c
+++ b/drivers/mfd/qcom-pm8xxx.c
@@ -65,7 +65,7 @@
 struct pm_irq_data {
 	int num_irqs;
 	struct irq_chip *irq_chip;
-	void (*irq_handler)(struct irq_desc *desc);
+	irqreturn_t (*irq_handler)(int irq, void *data);
 };
 
 struct pm_irq_chip {
@@ -140,7 +140,7 @@ static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
 		if (bits & (1 << i)) {
 			pmirq = block * 8 + i;
 			irq = irq_find_mapping(chip->irqdomain, pmirq);
-			generic_handle_irq(irq);
+			handle_nested_irq(irq);
 		}
 	}
 	return 0;
@@ -170,19 +170,16 @@ static int pm8xxx_irq_master_handler(struct pm_irq_chip *chip, int master)
 	return ret;
 }
 
-static void pm8xxx_irq_handler(struct irq_desc *desc)
+static irqreturn_t pm8xxx_irq_handler(int irq, void *data)
 {
-	struct pm_irq_chip *chip = irq_desc_get_handler_data(desc);
-	struct irq_chip *irq_chip = irq_desc_get_chip(desc);
+	struct pm_irq_chip *chip = data;
 	unsigned int root;
 	int	i, ret, masters = 0;
 
-	chained_irq_enter(irq_chip, desc);
-
 	ret = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_ROOT, &root);
 	if (ret) {
 		pr_err("Can't read root status ret=%d\n", ret);
-		return;
+		return IRQ_NONE;
 	}
 
 	/* on pm8xxx series masters start from bit 1 of the root */
@@ -193,7 +190,7 @@ static void pm8xxx_irq_handler(struct irq_desc *desc)
 		if (masters & (1 << i))
 			pm8xxx_irq_master_handler(chip, i);
 
-	chained_irq_exit(irq_chip, desc);
+	return IRQ_HANDLED;
 }
 
 static void pm8821_irq_block_handler(struct pm_irq_chip *chip,
@@ -217,7 +214,7 @@ static void pm8821_irq_block_handler(struct pm_irq_chip *chip,
 		if (bits & BIT(i)) {
 			pmirq = block * 8 + i;
 			irq = irq_find_mapping(chip->irqdomain, pmirq);
-			generic_handle_irq(irq);
+			handle_nested_irq(irq);
 		}
 	}
 }
@@ -232,19 +229,17 @@ static inline void pm8821_irq_master_handler(struct pm_irq_chip *chip,
 			pm8821_irq_block_handler(chip, master, block);
 }
 
-static void pm8821_irq_handler(struct irq_desc *desc)
+static irqreturn_t pm8821_irq_handler(int irq, void *data)
 {
-	struct pm_irq_chip *chip = irq_desc_get_handler_data(desc);
-	struct irq_chip *irq_chip = irq_desc_get_chip(desc);
+	struct pm_irq_chip *chip = data;
 	unsigned int master;
 	int ret;
 
-	chained_irq_enter(irq_chip, desc);
 	ret = regmap_read(chip->regmap,
 			  PM8821_SSBI_REG_ADDR_IRQ_MASTER0, &master);
 	if (ret) {
 		pr_err("Failed to read master 0 ret=%d\n", ret);
-		goto done;
+		return IRQ_NONE;
 	}
 
 	/* bits 1 through 7 marks the first 7 blocks in master 0 */
@@ -253,19 +248,18 @@ static void pm8821_irq_handler(struct irq_desc *desc)
 
 	/* bit 0 marks if master 1 contains any bits */
 	if (!(master & BIT(0)))
-		goto done;
+		return IRQ_HANDLED;
 
 	ret = regmap_read(chip->regmap,
 			  PM8821_SSBI_REG_ADDR_IRQ_MASTER1, &master);
 	if (ret) {
 		pr_err("Failed to read master 1 ret=%d\n", ret);
-		goto done;
+		return IRQ_NONE;
 	}
 
 	pm8821_irq_master_handler(chip, 1, master);
 
-done:
-	chained_irq_exit(irq_chip, desc);
+	return IRQ_HANDLED;
 }
 
 static void pm8xxx_irq_mask_ack(struct irq_data *d)
@@ -516,15 +510,16 @@ MODULE_DEVICE_TABLE(of, pm8xxx_id_table);
 static int pm8xxx_probe(struct platform_device *pdev)
 {
 	const struct pm_irq_data *data;
+	struct device *dev = &pdev->dev;
 	struct regmap *regmap;
 	int irq, rc;
 	unsigned int val;
 	u32 rev;
 	struct pm_irq_chip *chip;
 
-	data = of_device_get_match_data(&pdev->dev);
+	data = of_device_get_match_data(dev);
 	if (!data) {
-		dev_err(&pdev->dev, "No matching driver data found\n");
+		dev_err(dev, "No matching driver data found\n");
 		return -EINVAL;
 	}
 
@@ -532,7 +527,7 @@ static int pm8xxx_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	regmap = devm_regmap_init(&pdev->dev, NULL, pdev->dev.parent,
+	regmap = devm_regmap_init(dev, NULL, pdev->dev.parent,
 				  &ssbi_regmap_config);
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
@@ -556,8 +551,7 @@ static int pm8xxx_probe(struct platform_device *pdev)
 	pr_info("PMIC revision 2: %02X\n", val);
 	rev |= val << BITS_PER_BYTE;
 
-	chip = devm_kzalloc(&pdev->dev,
-			    struct_size(chip, config, data->num_irqs),
+	chip = devm_kzalloc(dev, struct_size(chip, config, data->num_irqs),
 			    GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
@@ -569,21 +563,25 @@ static int pm8xxx_probe(struct platform_device *pdev)
 	chip->pm_irq_data = data;
 	spin_lock_init(&chip->pm_irq_lock);
 
-	chip->irqdomain = irq_domain_add_linear(pdev->dev.of_node,
+	chip->irqdomain = irq_domain_add_linear(dev->of_node,
 						data->num_irqs,
 						&pm8xxx_irq_domain_ops,
 						chip);
 	if (!chip->irqdomain)
 		return -ENODEV;
 
-	irq_set_chained_handler_and_data(irq, data->irq_handler, chip);
+	rc = devm_request_irq(dev, irq, data->irq_handler,
+			      IRQF_SHARED, KBUILD_MODNAME, chip);
+	if (rc) {
+		dev_err(dev, "failed to request IRQ\n");
+		return rc;
+	}
+
 	irq_set_irq_wake(irq, 1);
 
-	rc = of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
-	if (rc) {
-		irq_set_chained_handler_and_data(irq, NULL, NULL);
+	rc = of_platform_populate(pdev->dev.of_node, NULL, NULL, dev);
+	if (rc)
 		irq_domain_remove(chip->irqdomain);
-	}
 
 	return rc;
 }
@@ -596,11 +594,9 @@ static int pm8xxx_remove_child(struct device *dev, void *unused)
 
 static int pm8xxx_remove(struct platform_device *pdev)
 {
-	int irq = platform_get_irq(pdev, 0);
 	struct pm_irq_chip *chip = platform_get_drvdata(pdev);
 
 	device_for_each_child(&pdev->dev, NULL, pm8xxx_remove_child);
-	irq_set_chained_handler_and_data(irq, NULL, NULL);
 	irq_domain_remove(chip->irqdomain);
 
 	return 0;
-- 
2.31.1

