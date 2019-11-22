Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63AC1078D0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfKVTt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:49:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfKVTt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8536E2072E;
        Fri, 22 Nov 2019 19:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452166;
        bh=Ap9UGEDtCOa0CqpkdtyJj6I7eplB2kQVc4nQABh6S4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPyvn72WNqjC6CsHbpg8rjqJIduByU9pnTQsGeePrI91TwpW7OnUfyWHusutXmC3z
         wBPzmDf8OPEwSS6mRZiQoVAGtakjJqvZLWtOxMEMXMd+mRricbTphDJZJsFM/EPDpV
         YUsYHvHe3X3sm59EFm4IuguFwGyNO76gGGqPvTeE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        youling 257 <youling257@gmail.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/25] i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is present
Date:   Fri, 22 Nov 2019 14:48:55 -0500
Message-Id: <20191122194859.24508-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194859.24508-1-sashal@kernel.org>
References: <20191122194859.24508-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7574c0db2e68c4d0bae9d415a683bdd8b2a761e9 ]

Many cheap devices use Silead touchscreen controllers. Testing has shown
repeatedly that these touchscreen controllers work fine at 400KHz, but for
unknown reasons do not work properly at 100KHz. This has been seen on
both ARM and x86 devices using totally different i2c controllers.

On some devices the ACPI tables list another device at the same I2C-bus
as only being capable of 100KHz, testing has shown that these other
devices work fine at 400KHz (as can be expected of any recent I2C hw).

This commit makes i2c_acpi_find_bus_speed() always return 400KHz if a
Silead touchscreen controller is present, fixing the touchscreen not
working on devices which ACPI tables' wrongly list another device on the
same bus as only being capable of 100KHz.

Specifically this fixes the touchscreen on the Jumper EZpad 6 m4 not
working.

Reported-by: youling 257 <youling257@gmail.com>
Tested-by: youling 257 <youling257@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[wsa: rewording warning a little]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 32affd3fa8bd1..559c3b1284d73 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -43,6 +43,7 @@ struct i2c_acpi_lookup {
 	int index;
 	u32 speed;
 	u32 min_speed;
+	u32 force_speed;
 };
 
 static int i2c_acpi_fill_info(struct acpi_resource *ares, void *data)
@@ -240,6 +241,19 @@ i2c_acpi_match_device(const struct acpi_device_id *matches,
 	return acpi_match_device(matches, &client->dev);
 }
 
+static const struct acpi_device_id i2c_acpi_force_400khz_device_ids[] = {
+	/*
+	 * These Silead touchscreen controllers only work at 400KHz, for
+	 * some reason they do not work at 100KHz. On some devices the ACPI
+	 * tables list another device at their bus as only being capable
+	 * of 100KHz, testing has shown that these other devices work fine
+	 * at 400KHz (as can be expected of any recent i2c hw) so we force
+	 * the speed of the bus to 400 KHz if a Silead device is present.
+	 */
+	{ "MSSL1680", 0 },
+	{}
+};
+
 static acpi_status i2c_acpi_lookup_speed(acpi_handle handle, u32 level,
 					   void *data, void **return_value)
 {
@@ -258,6 +272,9 @@ static acpi_status i2c_acpi_lookup_speed(acpi_handle handle, u32 level,
 	if (lookup->speed <= lookup->min_speed)
 		lookup->min_speed = lookup->speed;
 
+	if (acpi_match_device_ids(adev, i2c_acpi_force_400khz_device_ids) == 0)
+		lookup->force_speed = 400000;
+
 	return AE_OK;
 }
 
@@ -295,7 +312,16 @@ u32 i2c_acpi_find_bus_speed(struct device *dev)
 		return 0;
 	}
 
-	return lookup.min_speed != UINT_MAX ? lookup.min_speed : 0;
+	if (lookup.force_speed) {
+		if (lookup.force_speed != lookup.min_speed)
+			dev_warn(dev, FW_BUG "DSDT uses known not-working I2C bus speed %d, forcing it to %d\n",
+				 lookup.min_speed, lookup.force_speed);
+		return lookup.force_speed;
+	} else if (lookup.min_speed != UINT_MAX) {
+		return lookup.min_speed;
+	} else {
+		return 0;
+	}
 }
 EXPORT_SYMBOL_GPL(i2c_acpi_find_bus_speed);
 
-- 
2.20.1

