Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BEAD9FE1
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389407AbfJPWFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438289AbfJPV6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:52 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A0321A49;
        Wed, 16 Oct 2019 21:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263131;
        bh=XetBPANB7qMSie4eeolBAhW/CmuTR4aFTc+RdDPIpL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDgbxe9k4I/tPlRtCIHKQAXfLuUbVQp8JQG9c+bTDFFpZRmeXTjLOYc+EUx1XS7AB
         wizPVqx40H90laPqyeBsnoLYufDLAGTXZWFjowdktMXCZtduTTr6qB6pDO3VMzmwXt
         Nhhh8Cys5qUfSCpeS/qFT3yyz+qxxjueKcktBDTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 054/112] iio: adc: axp288: Override TS pin bias current for some models
Date:   Wed, 16 Oct 2019 14:50:46 -0700
Message-Id: <20191016214858.785104463@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 972917419a0ba25afbf69d5d8c9fa644d676f887 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/axp288_adc.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

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
@@ -177,10 +183,36 @@ static int axp288_adc_read_raw(struct ii
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


