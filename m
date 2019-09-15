Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71049B317D
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 20:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfIOSxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 14:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfIOSxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Sep 2019 14:53:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25D6B18C8933;
        Sun, 15 Sep 2019 18:53:46 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-29.ams2.redhat.com [10.36.116.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C3785C1D6;
        Sun, 15 Sep 2019 18:53:43 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jonathan Cameron <jic23@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Chen-Yu Tsai <wens@csie.org>, linux-iio@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] iio: adc: axp288: Override TS pin bias current for some models
Date:   Sun, 15 Sep 2019 20:53:42 +0200
Message-Id: <20190915185342.235354-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Sun, 15 Sep 2019 18:53:46 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling") we
preserve the bias current set by the firmware at boot.  This fixes issues
we were seeing on various models, but it seems our old hardcoded 80ųA bias
current was working around a firmware bug on at least one model laptop.

In order to both have our cake and eat it, this commit adds a dmi based
list of models where we need to override the firmware set bias current and
adds the one model we now know needs this to it: The Lenovo Ideapad 100S
(11 inch version).

Cc: stable@vger.kernel.org
Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203829
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/iio/adc/axp288_adc.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index 31d51bcc5f2c..85d08e68b34f 100644
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

