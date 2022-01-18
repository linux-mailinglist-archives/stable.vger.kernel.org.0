Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C05E4914E9
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245194AbiARCZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:25:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40196 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244686AbiARCXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8037B60C8B;
        Tue, 18 Jan 2022 02:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D555FC36AE3;
        Tue, 18 Jan 2022 02:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472613;
        bh=jq5nSyDGNO8hpQ1IHIdwhL+JRSQlm2E4xpGYFSvtRJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4P1zoBkUcouFXCLwwCJZYFaR1nHkfFbd/RhTz7UXfFw9yF8Y/caHmG2q3FjsFUmS
         je1dWuW+Wh1KzOsvA9gIXpXbveaBZmKjY825ldy99IcLMIucTrnpSHwU9k+GtBTEzo
         6Ek9ZfLtIuw6UCH+tq5KESPJes2JxqBExI9mGKVMXdoujEwG/cxZkBnFHUG6tnoEo/
         6M/7XqKOur5z4V6H0sp370fiU62zZdzUmo1eRr0XgBA5bmsCnZV/zO+jRSLIPeESCb
         le4v+BNaoYsBtWY8+Pi3S/tQkv5ulU18dIgurA0y0F25pnZ8Ue+W7DMalWp5HavCIw
         KuDBi6oPfe9UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        mika.westerberg@linux.intel.com, linus.walleij@linaro.org,
        brgl@bgdev.pl, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 071/217] gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use
Date:   Mon, 17 Jan 2022 21:17:14 -0500
Message-Id: <20220118021940.1942199-71-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 985e8589c58ba..feb8157d2d672 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1056,10 +1056,17 @@ int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int ind
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

