Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC47491A57
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346233AbiARC72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349086AbiARCrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:47:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B6EC06176F;
        Mon, 17 Jan 2022 18:39:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 193C66118D;
        Tue, 18 Jan 2022 02:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C57CC36AEF;
        Tue, 18 Jan 2022 02:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473547;
        bh=WrmovBE7B/LPgIOvuDDD6clEs9gOydREBb19a2g3R1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGYXKD16+VIaS/uvwJwFgygJfLoDWT9cbPoEQr3j/pRRuR43o/b+a8PfdAW1tsSY3
         1MaSUcvAjMbK+Xhb5MNp/BZcjt+ccday8Mep7Anq62eg2jsPrxAfzd05gOz1/6udl3
         r9YyBDNPutaEdiCpgSFkTU30zrqzUW7U4Wx+CwaZfK8m78ztR9bVsYEKqAJVRfqIqb
         M0Rr6cSrncSaRCb6jI6XrIsQ/hX+uPT6wMJPJdP14N2ITQMiG2HLtKOIWj95jwOeVJ
         a75kFutRtrhfMZd2cHcpC79ybaO/+iWdXfDfZ42Iq3EpiSbed84y+5exH2enGeMZg4
         bJHUaG4eCAACQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andy@kernel.org
Subject: [PATCH AUTOSEL 5.15 160/188] mfd: intel_soc_pmic: Use CPU-id check instead of _HRV check to differentiate variants
Date:   Mon, 17 Jan 2022 21:31:24 -0500
Message-Id: <20220118023152.1948105-160-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5b78223f55a0f516a1639dbe11cd4324d4aaee20 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_core.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
index ddd64f9e3341e..47cb7f00dfcfc 100644
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
-- 
2.34.1

