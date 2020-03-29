Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939A51970D1
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 00:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgC2Wed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 18:34:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:37231 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728913AbgC2Wed (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 18:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585521272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3+ZOHsYN5eO6apwqHDZCTtdl6HvugNVY/bn8g6JeuAk=;
        b=XkqBLo7B3eryxSkOrJTqaixmIAq3qH/EnLEjeSAMVdEwYDA34y41Q6pgEg5K4nlfv2Iei5
        UqNg+d0V7BoVWRyH8dF6YfxMzyEg0GaEygzy4w0IOaNJxjlDvAcXhDhi94r37WEhF2GWnK
        oQ2QKWBlk6Rbq1hGfRZWYf+9UZ9KCMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-zHoEi5pCNXyMGY86fbqrog-1; Sun, 29 Mar 2020 18:34:28 -0400
X-MC-Unique: zHoEi5pCNXyMGY86fbqrog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41D091005516;
        Sun, 29 Mar 2020 22:34:27 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-12.ams2.redhat.com [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 891CB5DA66;
        Sun, 29 Mar 2020 22:34:25 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "5 . 4+" <stable@vger.kernel.org>
Subject: [PATCH 5.6 regression fix 2/2] platform/x86: intel_int0002_vgpio: Use acpi_s2idle_register_wake_callback
Date:   Mon, 30 Mar 2020 00:34:19 +0200
Message-Id: <20200329223419.122796-3-hdegoede@redhat.com>
In-Reply-To: <20200329223419.122796-1-hdegoede@redhat.com>
References: <20200329223419.122796-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Power Management Events (PMEs) the INT0002 driver listens for get
signalled by the Power Management Controller (PMC) using the same IRQ
as used for the ACPI SCI.

Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
waking up the system") the SCI triggering without there being a wakeup
cause recognized by the ACPI sleep code will no longer wakeup the system.

This breaks PMEs / wakeups signalled to the INT0002 driver, the system
never leaves the s2idle_loop() now.

Use acpi_s2idle_register_wake_callback to register a function which
checks the GPE0a_STS register for a PME and trigger a wakeup when a
PME has been signalled.

With this new mechanism the pm_wakeup_hard_event() call is no longer
necessary, so remove it and also remove the matching device_init_wakeup()
calls.

Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking=
 up the system")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel_int0002_vgpio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platfor=
m/x86/intel_int0002_vgpio.c
index f14e2c5f9da5..3c70694188fe 100644
--- a/drivers/platform/x86/intel_int0002_vgpio.c
+++ b/drivers/platform/x86/intel_int0002_vgpio.c
@@ -122,11 +122,17 @@ static irqreturn_t int0002_irq(int irq, void *data)
 	generic_handle_irq(irq_find_mapping(chip->irq.domain,
 					    GPE0A_PME_B0_VIRT_GPIO_PIN));
=20
-	pm_wakeup_hard_event(chip->parent);
-
 	return IRQ_HANDLED;
 }
=20
+static bool int0002_check_wake(void *data)
+{
+	u32 gpe_sts_reg;
+
+	gpe_sts_reg =3D inl(GPE0A_STS_PORT);
+	return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
+}
+
 static struct irq_chip int0002_byt_irqchip =3D {
 	.name			=3D DRV_NAME,
 	.irq_ack		=3D int0002_irq_ack,
@@ -220,13 +226,13 @@ static int int0002_probe(struct platform_device *pd=
ev)
 		return ret;
 	}
=20
-	device_init_wakeup(dev, true);
+	acpi_s2idle_register_wake_callback(irq, int0002_check_wake, NULL);
 	return 0;
 }
=20
 static int int0002_remove(struct platform_device *pdev)
 {
-	device_init_wakeup(&pdev->dev, false);
+	acpi_s2idle_unregister_wake_callback(int0002_check_wake, NULL);
 	return 0;
 }
=20
--=20
2.26.0

