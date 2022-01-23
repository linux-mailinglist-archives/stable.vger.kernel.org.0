Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3D44972B6
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 16:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiAWPrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 10:47:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33396 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiAWPrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 10:47:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7783CB80DC1
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 15:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F02C36AE7;
        Sun, 23 Jan 2022 15:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642952849;
        bh=kTGZVLiHVxP5bYA6B3BZkfGklijJwmHQ74Kl3qFgIqc=;
        h=Subject:To:Cc:From:Date:From;
        b=1yNu4NQGccwFAEfvhJWQrK9jv+Se2e5wNnckcMgSk4AXdoEBHA8aL5W2+SQcWbhBh
         eyZM7azTwAObntCzFgaqTSLkbgc2MMJZOEdWXTZ6B6y3q3kKJcagV7NDpzx1oSE9VZ
         f4XmDng5SHTBdoCYWCqrAVSg8EaV7lFOllcOKnPw=
Subject: FAILED: patch "[PATCH] mfd: intel_soc_pmic: Use CPU-id check instead of _HRV check" failed to apply to 5.10-stable tree
To:     hdegoede@redhat.com, andy.shevchenko@gmail.com, kitakar@gmail.com,
        lee.jones@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 16:47:26 +0100
Message-ID: <1642952846141223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b78223f55a0f516a1639dbe11cd4324d4aaee20 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 6 Dec 2021 18:48:06 +0100
Subject: [PATCH] mfd: intel_soc_pmic: Use CPU-id check instead of _HRV check
 to differentiate variants

The Intel Crystal Cove PMIC has 2 different variants, one for use with
Bay Trail (BYT) SoCs and one for use with Cherry Trail (CHT) SoCs.

So far we have been using an ACPI _HRV check to differentiate between
the 2, but at least on the Microsoft Surface 3, which is a CHT device,
the wrong _HRV value is reported by ACPI.

So instead switch to a CPU-ID check which prevents us from relying on
the possibly wrong ACPI _HRV value.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reported-by: Tsuchiya Yuto <kitakar@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211206174806.197772-2-hdegoede@redhat.com

diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
index ddd64f9e3341..47cb7f00dfcf 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel_soc_pmic_core.c
@@ -14,15 +14,12 @@
 #include <linux/module.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/intel_soc_pmic.h>
+#include <linux/platform_data/x86/soc.h>
 #include <linux/pwm.h>
 #include <linux/regmap.h>
 
 #include "intel_soc_pmic_core.h"
 
-/* Crystal Cove PMIC shares same ACPI ID between different platforms */
-#define BYT_CRC_HRV		2
-#define CHT_CRC_HRV		3
-
 /* PWM consumed by the Intel GFX */
 static struct pwm_lookup crc_pwm_lookup[] = {
 	PWM_LOOKUP("crystal_cove_pwm", 0, "0000:00:02.0", "pwm_pmic_backlight", 0, PWM_POLARITY_NORMAL),
@@ -34,31 +31,12 @@ static int intel_soc_pmic_i2c_probe(struct i2c_client *i2c,
 	struct device *dev = &i2c->dev;
 	struct intel_soc_pmic_config *config;
 	struct intel_soc_pmic *pmic;
-	unsigned long long hrv;
-	acpi_status status;
 	int ret;
 
-	/*
-	 * There are 2 different Crystal Cove PMICs a Bay Trail and Cherry
-	 * Trail version, use _HRV to differentiate between the 2.
-	 */
-	status = acpi_evaluate_integer(ACPI_HANDLE(dev), "_HRV", NULL, &hrv);
-	if (ACPI_FAILURE(status)) {
-		dev_err(dev, "Failed to get PMIC hardware revision\n");
-		return -ENODEV;
-	}
-
-	switch (hrv) {
-	case BYT_CRC_HRV:
+	if (soc_intel_is_byt())
 		config = &intel_soc_pmic_config_byt_crc;
-		break;
-	case CHT_CRC_HRV:
+	else
 		config = &intel_soc_pmic_config_cht_crc;
-		break;
-	default:
-		dev_warn(dev, "Unknown hardware rev %llu, assuming BYT\n", hrv);
-		config = &intel_soc_pmic_config_byt_crc;
-	}
 
 	pmic = devm_kzalloc(dev, sizeof(*pmic), GFP_KERNEL);
 	if (!pmic)

