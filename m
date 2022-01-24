Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBEB498A2B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245668AbiAXTBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:01:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55670 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345141AbiAXS7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:59:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8E4760917;
        Mon, 24 Jan 2022 18:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794FEC340E5;
        Mon, 24 Jan 2022 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050791;
        bh=mt14UD5wwUsEVPzv/slcZn+yEj+oYq8IMyN2ZD3IgCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSGK7A+MOyaEkY1WRjDmCEqPOopGSAmXxHfdiHfS68eVcfkMps1OljmyXjKjUgHDa
         wykEzlM1LmVwRCPtGUwv5Z4I0QGHHDm11G5w8FG6sjZv6b9LDWyZ+9WbZRsQ5J/Crg
         jvOH0ridKvYC5cRZFac/gDdmyxSajOwzVHHPm4+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 080/157] gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use
Date:   Mon, 24 Jan 2022 19:42:50 +0100
Message-Id: <20220124183935.323620286@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 986248f7011aa..c479280590e42 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -675,10 +675,17 @@ int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
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



