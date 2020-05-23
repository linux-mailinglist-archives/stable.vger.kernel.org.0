Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593111DF61A
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbgEWIr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 04:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387471AbgEWIr4 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 23 May 2020 04:47:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6352C206C3;
        Sat, 23 May 2020 08:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590223674;
        bh=N7WWC7BKkqlxBjmuRyoorLSIV5TfIRMHb1YMBKHuaFM=;
        h=Subject:To:From:Date:From;
        b=h+6Hsig27jabCfbD8xX0kgF5BcEtrPdVEKBPdD1k/7tKKjJ6zFYWup8LNftGvqQXo
         qjjMldSzyhgMWWVX4WUKvjVGCf8qeyx/FTY6/esPqc6BhFpomNLIslO7FRBE3xCQ+v
         9UFc+gCgPccQdDcg71SA9YyEPRpXhdJxwdE1kSB4=
Subject: patch "iio: adc: stm32-adc: fix a wrong error message when probing" added to staging-testing
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 May 2020 10:46:48 +0200
Message-ID: <159022360835246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32-adc: fix a wrong error message when probing

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 10134ec3f8cefa6a40fe84987f1795e9e0da9715 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Tue, 12 May 2020 15:27:05 +0200
Subject: iio: adc: stm32-adc: fix a wrong error message when probing
 interrupts

A wrong error message is printed out currently, like on STM32MP15:
- stm32-adc-core 48003000.adc: IRQ index 2 not found.

This is seen since commit 7723f4c5ecdb ("driver core: platform: Add an
error message to platform_get_irq*()").
The STM32 ADC core driver wrongly requests up to 3 interrupt lines. It
should request only the necessary IRQs, based on the compatible:
- stm32f4/h7 ADCs share a common interrupt
- stm32mp1, has one interrupt line per ADC.
So add the number of required interrupts to the compatible data.

Fixes: d58c67d1d851 ("iio: adc: stm32-adc: add support for STM32MP1")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-adc-core.c | 34 +++++++++++++-------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 2df88d2b880a..0e2068ec068b 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -65,12 +65,14 @@ struct stm32_adc_priv;
  * @clk_sel:	clock selection routine
  * @max_clk_rate_hz: maximum analog clock rate (Hz, from datasheet)
  * @has_syscfg: SYSCFG capability flags
+ * @num_irqs:	number of interrupt lines
  */
 struct stm32_adc_priv_cfg {
 	const struct stm32_adc_common_regs *regs;
 	int (*clk_sel)(struct platform_device *, struct stm32_adc_priv *);
 	u32 max_clk_rate_hz;
 	unsigned int has_syscfg;
+	unsigned int num_irqs;
 };
 
 /**
@@ -375,21 +377,15 @@ static int stm32_adc_irq_probe(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	unsigned int i;
 
-	for (i = 0; i < STM32_ADC_MAX_ADCS; i++) {
+	/*
+	 * Interrupt(s) must be provided, depending on the compatible:
+	 * - stm32f4/h7 shares a common interrupt line.
+	 * - stm32mp1, has one line per ADC
+	 */
+	for (i = 0; i < priv->cfg->num_irqs; i++) {
 		priv->irq[i] = platform_get_irq(pdev, i);
-		if (priv->irq[i] < 0) {
-			/*
-			 * At least one interrupt must be provided, make others
-			 * optional:
-			 * - stm32f4/h7 shares a common interrupt.
-			 * - stm32mp1, has one line per ADC (either for ADC1,
-			 *   ADC2 or both).
-			 */
-			if (i && priv->irq[i] == -ENXIO)
-				continue;
-
+		if (priv->irq[i] < 0)
 			return priv->irq[i];
-		}
 	}
 
 	priv->domain = irq_domain_add_simple(np, STM32_ADC_MAX_ADCS, 0,
@@ -400,9 +396,7 @@ static int stm32_adc_irq_probe(struct platform_device *pdev,
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < STM32_ADC_MAX_ADCS; i++) {
-		if (priv->irq[i] < 0)
-			continue;
+	for (i = 0; i < priv->cfg->num_irqs; i++) {
 		irq_set_chained_handler(priv->irq[i], stm32_adc_irq_handler);
 		irq_set_handler_data(priv->irq[i], priv);
 	}
@@ -420,11 +414,8 @@ static void stm32_adc_irq_remove(struct platform_device *pdev,
 		irq_dispose_mapping(irq_find_mapping(priv->domain, hwirq));
 	irq_domain_remove(priv->domain);
 
-	for (i = 0; i < STM32_ADC_MAX_ADCS; i++) {
-		if (priv->irq[i] < 0)
-			continue;
+	for (i = 0; i < priv->cfg->num_irqs; i++)
 		irq_set_chained_handler(priv->irq[i], NULL);
-	}
 }
 
 static int stm32_adc_core_switches_supply_en(struct stm32_adc_priv *priv,
@@ -817,6 +808,7 @@ static const struct stm32_adc_priv_cfg stm32f4_adc_priv_cfg = {
 	.regs = &stm32f4_adc_common_regs,
 	.clk_sel = stm32f4_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
+	.num_irqs = 1,
 };
 
 static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
@@ -824,6 +816,7 @@ static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
 	.clk_sel = stm32h7_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER,
+	.num_irqs = 1,
 };
 
 static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
@@ -831,6 +824,7 @@ static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
 	.clk_sel = stm32h7_adc_clk_sel,
 	.max_clk_rate_hz = 40000000,
 	.has_syscfg = HAS_VBOOSTER | HAS_ANASWVDD,
+	.num_irqs = 2,
 };
 
 static const struct of_device_id stm32_adc_of_match[] = {
-- 
2.26.2


