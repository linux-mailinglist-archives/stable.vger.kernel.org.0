Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCEA8DBC2
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfHNRCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbfHNRCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:02:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74FE1216F4;
        Wed, 14 Aug 2019 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802165;
        bh=BkcDTATYIDNP1lgjr3cK6wsrDP7zg9Rqhww//Ivq318=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSh6yMWNKJchV0Hmgaoxe+Atx9OcSNTVZPW2peBqzr5RfNaFyl/9dLRp9BFOxbczA
         z3BNTusUQ30UIH2GEd53gpb8vJcvDxByGudpNV1pBkAkeoZRpjirzPENFkADIEdUA3
         Yt2XUFazh6vZQM/69hr8o7PmlYkCVrIqqJEYkjfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>,
        Artur Rojek <contact@artur-rojek.eu>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.2 002/144] IIO: Ingenic JZ47xx: Set clock divider on probe
Date:   Wed, 14 Aug 2019 18:59:18 +0200
Message-Id: <20190814165759.574557059@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maarten ter Huurne <maarten@treewalker.org>

commit 5a304e1a4ea000177cf25f5ecf26e786dda25b98 upstream.

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
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ingenic-adc.c |   54 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

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
@@ -151,6 +158,42 @@ static const int jz4740_adc_battery_scal
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
@@ -158,6 +201,7 @@ static const struct ingenic_adc_soc_data
 	.battery_raw_avail_size = ARRAY_SIZE(jz4725b_adc_battery_raw_avail),
 	.battery_scale_avail = jz4725b_adc_battery_scale_avail,
 	.battery_scale_avail_size = ARRAY_SIZE(jz4725b_adc_battery_scale_avail),
+	.init_clk_div = jz4725b_adc_init_clk_div,
 };
 
 static const struct ingenic_adc_soc_data jz4740_adc_soc_data = {
@@ -167,6 +211,7 @@ static const struct ingenic_adc_soc_data
 	.battery_raw_avail_size = ARRAY_SIZE(jz4740_adc_battery_raw_avail),
 	.battery_scale_avail = jz4740_adc_battery_scale_avail,
 	.battery_scale_avail_size = ARRAY_SIZE(jz4740_adc_battery_scale_avail),
+	.init_clk_div = NULL, /* no ADCLK register on JZ4740 */
 };
 
 static int ingenic_adc_read_avail(struct iio_dev *iio_dev,
@@ -317,6 +362,15 @@ static int ingenic_adc_probe(struct plat
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


