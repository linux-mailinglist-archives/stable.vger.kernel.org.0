Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7565FC87
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfGDRdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 13:33:04 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:46839 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfGDRdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 13:33:04 -0400
X-Originating-IP: 195.189.32.242
Received: from pc.localdomain (unknown [195.189.32.242])
        (Authenticated sender: contact@artur-rojek.eu)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 938E8240004;
        Thu,  4 Jul 2019 17:32:56 +0000 (UTC)
From:   Artur Rojek <contact@artur-rojek.eu>
To:     Jonathan Cameron <jic23@kernel.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>
Subject: [PATCH v2] IIO: Ingenic JZ47xx: Set clock divider on probe
Date:   Thu,  4 Jul 2019 19:36:56 +0200
Message-Id: <20190704173656.6617-1-contact@artur-rojek.eu>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maarten ter Huurne <maarten@treewalker.org>

The SADC component can run at up to 8 MHz on JZ4725B, but is fed
a 12 MHz input clock (EXT). Divide it by two to get 6 MHz, then
set up another divider to match, to produce a 10us clock.

If the clock dividers are left on their power-on defaults (a divider
of 1), the SADC mostly works, but will occasionally produce erroneous
readings. This led to button presses being detected out of nowhere on
the RS90 every few minutes. With this change, no ghost button presses
were logged in almost a day worth of testing.

The ADCLK register for configuring clock dividers doesn't exist on
JZ4740, so avoid writing it there.

A function has been introduced rather than a flag because there is a lot
of variation between the ADCLK registers on JZ47xx SoCs, both in
the internal layout of the register and in the frequency range
supported by the SADC. So this solution should make it easier
to add support for other JZ47xx SoCs later.

Fixes: 1a78daea107d ("iio: adc: probe should set clock divider")
Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
Signed-off-by: Artur Rojek <contact@artur-rojek.eu>
---

 Changes:

 v2: Add the fixes tag.

 drivers/iio/adc/ingenic-adc.c | 54 +++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/iio/adc/ingenic-adc.c b/drivers/iio/adc/ingenic-adc.c
index 92b1d5037ac9..e234970b7150 100644
--- a/drivers/iio/adc/ingenic-adc.c
+++ b/drivers/iio/adc/ingenic-adc.c
@@ -11,6 +11,7 @@
 #include <linux/iio/iio.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
@@ -22,8 +23,11 @@
 #define JZ_ADC_REG_ADTCH		0x18
 #define JZ_ADC_REG_ADBDAT		0x1c
 #define JZ_ADC_REG_ADSDAT		0x20
+#define JZ_ADC_REG_ADCLK		0x28
 
 #define JZ_ADC_REG_CFG_BAT_MD		BIT(4)
+#define JZ_ADC_REG_ADCLK_CLKDIV_LSB	0
+#define JZ_ADC_REG_ADCLK_CLKDIV10US_LSB	16
 
 #define JZ_ADC_AUX_VREF				3300
 #define JZ_ADC_AUX_VREF_BITS			12
@@ -34,6 +38,8 @@
 #define JZ4740_ADC_BATTERY_HIGH_VREF		(7500 * 0.986)
 #define JZ4740_ADC_BATTERY_HIGH_VREF_BITS	12
 
+struct ingenic_adc;
+
 struct ingenic_adc_soc_data {
 	unsigned int battery_high_vref;
 	unsigned int battery_high_vref_bits;
@@ -41,6 +47,7 @@ struct ingenic_adc_soc_data {
 	size_t battery_raw_avail_size;
 	const int *battery_scale_avail;
 	size_t battery_scale_avail_size;
+	int (*init_clk_div)(struct device *dev, struct ingenic_adc *adc);
 };
 
 struct ingenic_adc {
@@ -151,6 +158,42 @@ static const int jz4740_adc_battery_scale_avail[] = {
 	JZ_ADC_BATTERY_LOW_VREF, JZ_ADC_BATTERY_LOW_VREF_BITS,
 };
 
+static int jz4725b_adc_init_clk_div(struct device *dev, struct ingenic_adc *adc)
+{
+	struct clk *parent_clk;
+	unsigned long parent_rate, rate;
+	unsigned int div_main, div_10us;
+
+	parent_clk = clk_get_parent(adc->clk);
+	if (!parent_clk) {
+		dev_err(dev, "ADC clock has no parent\n");
+		return -ENODEV;
+	}
+	parent_rate = clk_get_rate(parent_clk);
+
+	/*
+	 * The JZ4725B ADC works at 500 kHz to 8 MHz.
+	 * We pick the highest rate possible.
+	 * In practice we typically get 6 MHz, half of the 12 MHz EXT clock.
+	 */
+	div_main = DIV_ROUND_UP(parent_rate, 8000000);
+	div_main = clamp(div_main, 1u, 64u);
+	rate = parent_rate / div_main;
+	if (rate < 500000 || rate > 8000000) {
+		dev_err(dev, "No valid divider for ADC main clock\n");
+		return -EINVAL;
+	}
+
+	/* We also need a divider that produces a 10us clock. */
+	div_10us = DIV_ROUND_UP(rate, 100000);
+
+	writel(((div_10us - 1) << JZ_ADC_REG_ADCLK_CLKDIV10US_LSB) |
+	       (div_main - 1) << JZ_ADC_REG_ADCLK_CLKDIV_LSB,
+	       adc->base + JZ_ADC_REG_ADCLK);
+
+	return 0;
+}
+
 static const struct ingenic_adc_soc_data jz4725b_adc_soc_data = {
 	.battery_high_vref = JZ4725B_ADC_BATTERY_HIGH_VREF,
 	.battery_high_vref_bits = JZ4725B_ADC_BATTERY_HIGH_VREF_BITS,
@@ -158,6 +201,7 @@ static const struct ingenic_adc_soc_data jz4725b_adc_soc_data = {
 	.battery_raw_avail_size = ARRAY_SIZE(jz4725b_adc_battery_raw_avail),
 	.battery_scale_avail = jz4725b_adc_battery_scale_avail,
 	.battery_scale_avail_size = ARRAY_SIZE(jz4725b_adc_battery_scale_avail),
+	.init_clk_div = jz4725b_adc_init_clk_div,
 };
 
 static const struct ingenic_adc_soc_data jz4740_adc_soc_data = {
@@ -167,6 +211,7 @@ static const struct ingenic_adc_soc_data jz4740_adc_soc_data = {
 	.battery_raw_avail_size = ARRAY_SIZE(jz4740_adc_battery_raw_avail),
 	.battery_scale_avail = jz4740_adc_battery_scale_avail,
 	.battery_scale_avail_size = ARRAY_SIZE(jz4740_adc_battery_scale_avail),
+	.init_clk_div = NULL, /* no ADCLK register on JZ4740 */
 };
 
 static int ingenic_adc_read_avail(struct iio_dev *iio_dev,
@@ -317,6 +362,15 @@ static int ingenic_adc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Set clock dividers. */
+	if (soc_data->init_clk_div) {
+		ret = soc_data->init_clk_div(dev, adc);
+		if (ret) {
+			clk_disable_unprepare(adc->clk);
+			return ret;
+		}
+	}
+
 	/* Put hardware in a known passive state. */
 	writeb(0x00, adc->base + JZ_ADC_REG_ENABLE);
 	writeb(0xff, adc->base + JZ_ADC_REG_CTRL);
-- 
2.22.0

