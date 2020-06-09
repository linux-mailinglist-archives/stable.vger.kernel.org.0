Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAD11F4441
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgFIRxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732997AbgFIRxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F7A20801;
        Tue,  9 Jun 2020 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725185;
        bh=JBF1QBhhLgT43+0O28fNaRCb8qfuY9Ah9BnHcGY+DlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GK6FugCHj1FpDkI3S6xxPPUjLOhYPLKI128/tL+zyEIktfbCwSmhFQa2O1yDaGHry
         xTM+48+nT7r6VWpWwKLO3lQeF5fCWhWU6klL9KP4E/p2Cm1qQwfzo+71LvVVSSkOnF
         AYTIaTfWmZEJHec4Y7h8uGZBME1P+StPaCMQrBXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 19/34] iio: adc: stm32-adc: fix a wrong error message when probing interrupts
Date:   Tue,  9 Jun 2020 19:45:15 +0200
Message-Id: <20200609174055.029698781@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

commit 10134ec3f8cefa6a40fe84987f1795e9e0da9715 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-adc-core.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

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
@@ -372,21 +374,15 @@ static int stm32_adc_irq_probe(struct pl
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
@@ -397,9 +393,7 @@ static int stm32_adc_irq_probe(struct pl
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < STM32_ADC_MAX_ADCS; i++) {
-		if (priv->irq[i] < 0)
-			continue;
+	for (i = 0; i < priv->cfg->num_irqs; i++) {
 		irq_set_chained_handler(priv->irq[i], stm32_adc_irq_handler);
 		irq_set_handler_data(priv->irq[i], priv);
 	}
@@ -417,11 +411,8 @@ static void stm32_adc_irq_remove(struct
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
@@ -803,6 +794,7 @@ static const struct stm32_adc_priv_cfg s
 	.regs = &stm32f4_adc_common_regs,
 	.clk_sel = stm32f4_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
+	.num_irqs = 1,
 };
 
 static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
@@ -810,6 +802,7 @@ static const struct stm32_adc_priv_cfg s
 	.clk_sel = stm32h7_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER,
+	.num_irqs = 1,
 };
 
 static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
@@ -817,6 +810,7 @@ static const struct stm32_adc_priv_cfg s
 	.clk_sel = stm32h7_adc_clk_sel,
 	.max_clk_rate_hz = 40000000,
 	.has_syscfg = HAS_VBOOSTER | HAS_ANASWVDD,
+	.num_irqs = 2,
 };
 
 static const struct of_device_id stm32_adc_of_match[] = {


