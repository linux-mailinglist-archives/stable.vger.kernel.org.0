Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78946491A23
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348935AbiARC6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348305AbiARCpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:45:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DB0B6130D;
        Tue, 18 Jan 2022 02:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83291C36AF2;
        Tue, 18 Jan 2022 02:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473909;
        bh=m9BuTBZpIugcPF288rm1rumd82hWsPg0dVWh+nu1Mow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7fdj7IGZ4OLxJ/ZSHwvO2beFW15LHSEuIoFty3tRoRzvgKAgfFsY2MBDmYXL62dw
         FzvoIaiNb8793SCgyvtlJe5NshNX6b2Ntj0O+cheCFc8D+aZv+DlCco1Apn0QttVVj
         31WK01xupzLoK++RWGNoQ6oC8dJx8cjZ8GhlUy0GzYAqlomtMDGaIbq9afHi+SvV6D
         YHsRPo2J0gFH+3QMTFXuRUcvD4GH106oaLSPwXo1WYIcmIGGGN/IK1YqyZh+ATOVD5
         HNxjQTFQvcS4jSBt3eMsE+96qHA7ldgTUCALseBVwKZ3Q3R348XaACiPcjq47IV4Tg
         NWv1b6dfQ08Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        mika.westerberg@linux.intel.com, linus.walleij@linaro.org,
        brgl@bgdev.pl, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/73] gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use
Date:   Mon, 17 Jan 2022 21:43:36 -0500
Message-Id: <20220118024432.1952028-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bdfd6ab8fdccd8b138837efff66f4a1911496378 ]

If the IRQ is already in use, then acpi_dev_gpio_irq_get_by() really
should not change the type underneath the current owner.

I specifically hit an issue with this an a Chuwi Hi8 Super (CWI509) Bay
Trail tablet, when the Boot OS selection in the BIOS is set to Android.
In this case _STA for a MAX17047 ACPI I2C device wrongly returns 0xf and
the _CRS resources for this device include a GpioInt pointing to a GPIO
already in use by an _AEI handler, with a different type then specified
in the _CRS for the MAX17047 device. Leading to the acpi_dev_gpio_irq_get()
call done by the i2c-core-acpi.c code changing the type breaking the
_AEI handler.

Now this clearly is a bug in the DSDT of this tablet (in Android mode),
but in general calling irq_set_irq_type() on an IRQ which already is
in use seems like a bad idea.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index e3ddc99c105d4..13c6eee481da7 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -953,10 +953,17 @@ int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
 			irq_flags = acpi_dev_get_irq_type(info.triggering,
 							  info.polarity);
 
-			/* Set type if specified and different than the current one */
-			if (irq_flags != IRQ_TYPE_NONE &&
-			    irq_flags != irq_get_trigger_type(irq))
-				irq_set_irq_type(irq, irq_flags);
+			/*
+			 * If the IRQ is not already in use then set type
+			 * if specified and different than the current one.
+			 */
+			if (can_request_irq(irq, irq_flags)) {
+				if (irq_flags != IRQ_TYPE_NONE &&
+				    irq_flags != irq_get_trigger_type(irq))
+					irq_set_irq_type(irq, irq_flags);
+			} else {
+				dev_dbg(&adev->dev, "IRQ %d already in use\n", irq);
+			}
 
 			return irq;
 		}
-- 
2.34.1

