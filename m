Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D9419D54D
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 12:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgDCKwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 06:52:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45536 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390474AbgDCKwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 06:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585911165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5NLHWAihP8eW/m69CJGGciyPRDVjDNEWxz3B2il954=;
        b=enG5PG6shc0G/JidX4KrJ9QdSnXIOtHOcePkio4JsRI+atuSxx8GRYXnagmbwQaj2VTmpt
        H674XAvcFBsvfr3AXsDiBBBziW0NQTTxro9tU+6wpq5/UD6lzupC1DW0UCMOLiVq1m0BMy
        xxPptqfTO90L96qsTu62buvmTtGXOD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-Fu1C1p5TNVKAUdeun9FrOQ-1; Fri, 03 Apr 2020 06:52:44 -0400
X-MC-Unique: Fu1C1p5TNVKAUdeun9FrOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A7CD1B18BD5;
        Fri,  3 Apr 2020 10:52:42 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-115-123.ams2.redhat.com [10.36.115.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2574BEA6C;
        Fri,  3 Apr 2020 10:52:39 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "5 . 4+" <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()
Date:   Fri,  3 Apr 2020 12:52:35 +0200
Message-Id: <20200403105235.105187-2-hdegoede@redhat.com>
In-Reply-To: <20200403105235.105187-1-hdegoede@redhat.com>
References: <20200403105235.105187-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Power Management Events (PMEs) the INT0002 driver listens for get
signalled by the Power Management Controller (PMC) using the same IRQ
as used for the ACPI SCI.

Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
waking up the system") the SCI triggering, without there being a wakeup
cause recognized by the ACPI sleep code, will no longer wakeup the system=
.

This breaks PMEs / wakeups signalled to the INT0002 driver, the system
never leaves the s2idle_loop() now.

Use acpi_register_wakeup_handler() to register a function which checks
the GPE0a_STS register for a PME and trigger a wakeup when a PME has
been signalled.

With this new mechanism the pm_wakeup_hard_event() call is no longer
necessary, so remove it and also remove the matching device_init_wakeup()
calls.

Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking=
 up the system")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Adjust for the wakeup-handler registration function being renamed to
  acpi_register_wakeup_handler()
---
 drivers/platform/x86/intel_int0002_vgpio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platfor=
m/x86/intel_int0002_vgpio.c
index f14e2c5f9da5..9da19168b4f6 100644
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
+	acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);
 	return 0;
 }
=20
 static int int0002_remove(struct platform_device *pdev)
 {
-	device_init_wakeup(&pdev->dev, false);
+	acpi_unregister_wakeup_handler(int0002_check_wake, NULL);
 	return 0;
 }
=20
--=20
2.26.0

