Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10A4D2626
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbfJJJUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 406CB20B7C;
        Thu, 10 Oct 2019 09:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699238;
        bh=0PZpW4xXcJi2ccwPkr2+fqxIptzXtulINnC9vU4ZqkQ=;
        h=Subject:To:From:Date:From;
        b=uaGUOAYT1ZmlNxuehImVkT1Y1jmHoqyrkBd04SnclElDFMJ3jRmaoPfysS4kmtH0v
         gk+eQQ4NEggaoRC2/k9X7/2LBPdUZxBoUIzLWX1LH1iNJV7wmYmqMZ83Did8grsLAD
         DRW0x1MtyASRu34zUW6ON6Lt1QY8MXFcI+wT8fMw=
Subject: patch "iio: adc: axp288: Override TS pin bias current for some models" added to staging-linus
To:     hdegoede@redhat.com, Jonathan.Cameron@huawei.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:07 +0200
Message-ID: <157069920725216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: axp288: Override TS pin bias current for some models

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 972917419a0ba25afbf69d5d8c9fa644d676f887 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 15 Sep 2019 20:53:42 +0200
Subject: iio: adc: axp288: Override TS pin bias current for some models
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling") we
preserve the bias current set by the firmware at boot.  This fixes issues
we were seeing on various models, but it seems our old hardcoded 80ųA bias
current was working around a firmware bug on at least one model laptop.

In order to both have our cake and eat it, this commit adds a dmi based
list of models where we need to override the firmware set bias current and
adds the one model we now know needs this to it: The Lenovo Ideapad 100S
(11 inch version).

Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203829
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/axp288_adc.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index adc9cf7a075d..8ea2aed6d6f5 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -7,6 +7,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
@@ -25,6 +26,11 @@
 #define AXP288_ADC_EN_MASK				0xF0
 #define AXP288_ADC_TS_ENABLE				0x01
 
+#define AXP288_ADC_TS_BIAS_MASK				GENMASK(5, 4)
+#define AXP288_ADC_TS_BIAS_20UA				(0 << 4)
+#define AXP288_ADC_TS_BIAS_40UA				(1 << 4)
+#define AXP288_ADC_TS_BIAS_60UA				(2 << 4)
+#define AXP288_ADC_TS_BIAS_80UA				(3 << 4)
 #define AXP288_ADC_TS_CURRENT_ON_OFF_MASK		GENMASK(1, 0)
 #define AXP288_ADC_TS_CURRENT_OFF			(0 << 0)
 #define AXP288_ADC_TS_CURRENT_ON_WHEN_CHARGING		(1 << 0)
@@ -177,10 +183,36 @@ static int axp288_adc_read_raw(struct iio_dev *indio_dev,
 	return ret;
 }
 
+/*
+ * We rely on the machine's firmware to correctly setup the TS pin bias current
+ * at boot. This lists systems with broken fw where we need to set it ourselves.
+ */
+static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
+	{
+		/* Lenovo Ideapad 100S (11 inch) */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad 100S-11IBY"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
+	{}
+};
+
 static int axp288_adc_initialize(struct axp288_adc_info *info)
 {
+	const struct dmi_system_id *bias_override;
 	int ret, adc_enable_val;
 
+	bias_override = dmi_first_match(axp288_adc_ts_bias_override);
+	if (bias_override) {
+		ret = regmap_update_bits(info->regmap, AXP288_ADC_TS_PIN_CTRL,
+					 AXP288_ADC_TS_BIAS_MASK,
+					 (uintptr_t)bias_override->driver_data);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Determine if the TS pin is enabled and set the TS current-source
 	 * accordingly.
-- 
2.23.0


