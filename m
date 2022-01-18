Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE467491DC7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349058AbiARDm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353562AbiARDCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:02:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C291C034005;
        Mon, 17 Jan 2022 18:47:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E3961318;
        Tue, 18 Jan 2022 02:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC1FC36AE3;
        Tue, 18 Jan 2022 02:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474048;
        bh=M4UE480JwyzeOBq6t7B72Ees1unLdZDrfoZ7S9bjVYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahaKN5Hfp4SsjMZZ5PIboX1HD3QAh55H8a9lIJKqoes6nlcvKZK8B/iJzP+mNR411
         3uvAfolePRmBjDuKrzh7OzlxUkWf2LnEpuRfBcbXJmnZjqMxQ70DSRk/7FRsMOOTvh
         izbPDBG/gyrpa4KxIQep/y29UPQlFFag79OPyrYGrfjVsxP4DUx3aRffWUTy9G07Er
         dKmfF15tzYRLfthnBU+JP6U2pxbp3/pBbZ7ttuTQHwTlgUoLKLY/I2ChrLTT9xSt/S
         pwXmjJkm90FAA5YxURVdAq6boJmhAClH6raln0UKa0F0pTRnl8N7JCoeflteLUEM/X
         CL7jtlBNlXOfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        mika.westerberg@linux.intel.com, linus.walleij@linaro.org,
        brgl@bgdev.pl, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/59] gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use
Date:   Mon, 17 Jan 2022 21:46:12 -0500
Message-Id: <20220118024701.1952911-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index b018909a4e46c..47cdc1f89e3fb 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -904,10 +904,17 @@ int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
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

