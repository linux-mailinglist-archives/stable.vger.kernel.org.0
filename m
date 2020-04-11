Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D9E1A515F
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgDKMR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgDKMR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A412137B;
        Sat, 11 Apr 2020 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607448;
        bh=42PQLC+0/YnbJz5vlF0xzSva+GES0qEzk294mCEwS9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIMByxrC8nti0Y3CMkN4g4X7v6Q6iLD9dyPrpIbPbTlEFV1MKTGRSs2Gt4jM/6p9J
         75HNgSNq/iydu9WLDPRp0y1teuY/Gyv+bU7MqbGlN4XndaORvit3Q76d7qDliTeLiz
         KZfrksB1lr7aeH+TZpGWHW8jBnx9vZy5xs663E+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 23/41] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()
Date:   Sat, 11 Apr 2020 14:09:32 +0200
Message-Id: <20200411115505.707389647@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 767191db8220db29f78c031f4d27375173c336d5 upstream.

The Power Management Events (PMEs) the INT0002 driver listens for get
signalled by the Power Management Controller (PMC) using the same IRQ
as used for the ACPI SCI.

Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
waking up the system") the SCI triggering, without there being a wakeup
cause recognized by the ACPI sleep code, will no longer wakeup the system.

This breaks PMEs / wakeups signalled to the INT0002 driver, the system
never leaves the s2idle_loop() now.

Use acpi_register_wakeup_handler() to register a function which checks
the GPE0a_STS register for a PME and trigger a wakeup when a PME has
been signalled.

Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel_int0002_vgpio.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/platform/x86/intel_int0002_vgpio.c
+++ b/drivers/platform/x86/intel_int0002_vgpio.c
@@ -127,6 +127,14 @@ static irqreturn_t int0002_irq(int irq,
 	return IRQ_HANDLED;
 }
 
+static bool int0002_check_wake(void *data)
+{
+	u32 gpe_sts_reg;
+
+	gpe_sts_reg = inl(GPE0A_STS_PORT);
+	return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
+}
+
 static struct irq_chip int0002_byt_irqchip = {
 	.name			= DRV_NAME,
 	.irq_ack		= int0002_irq_ack,
@@ -220,6 +228,7 @@ static int int0002_probe(struct platform
 
 	gpiochip_set_chained_irqchip(chip, irq_chip, irq, NULL);
 
+	acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);
 	device_init_wakeup(dev, true);
 	return 0;
 }
@@ -227,6 +236,7 @@ static int int0002_probe(struct platform
 static int int0002_remove(struct platform_device *pdev)
 {
 	device_init_wakeup(&pdev->dev, false);
+	acpi_unregister_wakeup_handler(int0002_check_wake, NULL);
 	return 0;
 }
 


