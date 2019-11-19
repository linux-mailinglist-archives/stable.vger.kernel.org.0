Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439AA101767
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfKSFoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729643AbfKSFoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:44:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE2721939;
        Tue, 19 Nov 2019 05:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142258;
        bh=m62rd/VoPELFkpVvDzmIaxu9iWdd2W3F7jVlw2VCWX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svw4yGrUTBUw0D7NbHSJiKZ5s1MEpH9qkwAXlJevuy3/MscDSyl3lW/8e/FHiOUPi
         /RF6pc+DzYX9NE+HfoWQ35KOGayt8zbAozACnKyZmgCEqyYm6YyXzhzFzvZZwmN7Pr
         gPYqfAdkMu1i/BmJ9aHa/VZIit36I/fuTdNnIxyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling 257 <youling257@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org
Subject: [PATCH 4.14 020/239] i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is present
Date:   Tue, 19 Nov 2019 06:17:00 +0100
Message-Id: <20191119051301.594479546@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 7574c0db2e68c4d0bae9d415a683bdd8b2a761e9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/i2c-core-acpi.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -43,6 +43,7 @@ struct i2c_acpi_lookup {
 	int index;
 	u32 speed;
 	u32 min_speed;
+	u32 force_speed;
 };
 
 static int i2c_acpi_fill_info(struct acpi_resource *ares, void *data)
@@ -240,6 +241,19 @@ i2c_acpi_match_device(const struct acpi_
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
@@ -258,6 +272,9 @@ static acpi_status i2c_acpi_lookup_speed
 	if (lookup->speed <= lookup->min_speed)
 		lookup->min_speed = lookup->speed;
 
+	if (acpi_match_device_ids(adev, i2c_acpi_force_400khz_device_ids) == 0)
+		lookup->force_speed = 400000;
+
 	return AE_OK;
 }
 
@@ -295,7 +312,16 @@ u32 i2c_acpi_find_bus_speed(struct devic
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
 


