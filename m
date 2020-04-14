Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6841A7D30
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgDNNUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:20:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730822AbgDNNUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 09:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586870400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3HuLilv69rC7THF45aYrV+6luk1YKd/SKbIHAdtaS/I=;
        b=AGOLidOw8oZG07I1ovKXRkxtUjCJAyU7CBEsvBSjnS+ehXHGD0XjGn3VPwJxaLxTZSl7sE
        CiAD6SnPVmje0Wx3XutxLR3tiGBjMH5RIJxS8nyoTIv9yGMi33BZG+V3BWAPsNWPv2Jl9x
        uQap0qkxvRTBptKWmQtArSuZ8BhsPUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-s7QuTE3nMBK2FMGTYY2epg-1; Tue, 14 Apr 2020 09:19:58 -0400
X-MC-Unique: s7QuTE3nMBK2FMGTYY2epg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E38B51B2C98A;
        Tue, 14 Apr 2020 13:19:56 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-114-21.ams2.redhat.com [10.36.114.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DA489F9A4;
        Tue, 14 Apr 2020 13:19:55 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        "5 . 3+" <stable@vger.kernel.org>
Subject: [PATCH v2] platform/x86: intel_int0002_vgpio: Only bind to the INT0002 dev when using s2idle
Date:   Tue, 14 Apr 2020 15:19:53 +0200
Message-Id: <20200414131953.131533-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement
irq_set_wake on Bay Trail") stopped passing irq_set_wake requests on to
the parents IRQ because this was breaking suspend (causing immediate
wakeups) on an Asus E202SA.

This workaround for this issue is mostly fine, on most Cherry Trail
devices where we need the INT0002 device for wakeups by e.g. USB kbds,
the parent IRQ is shared with the ACPI SCI and that is marked as wakeup
anyways.

But not on all devices, specifically on a Medion Akoya E1239T there is
no SCI at all, and because the irq_set_wake request is not passed on to
the parent IRQ, wake up by the builtin USB kbd does not work here.

So the workaround for the Asus E202SA immediate wake problem is causing
problems elsewhere; and in hindsight it is not the correct fix,
the Asus E202SA uses Airmont CPU cores, but this does not mean it is a
Cherry Trail based device, Brasswell uses Airmont CPU cores too and this
actually is a Braswell device.

Most (all?) Braswell devices use classic S3 mode suspend rather then
s2idle suspend and in this case directly dealing with PME events as
the INT0002 driver does likely is not the best idea, so that this is
causing issues is not surprising.

Replace the workaround of not passing irq_set_wake requests on to the
parents IRQ, by not binding to the INT0002 device when s2idle is not used=
.
This fixes USB kbd wakeups not working on some Cherry Trail devices,
while still avoiding mucking with the wakeup flags on the Asus E202SA
(and other Brasswell devices).

Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement i=
rq_set_wake on Bay Trail")
Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Rebase on top of 5.7-rc1
---
 drivers/platform/x86/intel_int0002_vgpio.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platfor=
m/x86/intel_int0002_vgpio.c
index 289c6655d425..30806046b664 100644
--- a/drivers/platform/x86/intel_int0002_vgpio.c
+++ b/drivers/platform/x86/intel_int0002_vgpio.c
@@ -143,21 +143,9 @@ static struct irq_chip int0002_byt_irqchip =3D {
 	.irq_set_wake		=3D int0002_irq_set_wake,
 };
=20
-static struct irq_chip int0002_cht_irqchip =3D {
-	.name			=3D DRV_NAME,
-	.irq_ack		=3D int0002_irq_ack,
-	.irq_mask		=3D int0002_irq_mask,
-	.irq_unmask		=3D int0002_irq_unmask,
-	/*
-	 * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
-	 * and we don't want to mess with the ACPI SCI irq settings.
-	 */
-	.flags			=3D IRQCHIP_SKIP_SET_WAKE,
-};
-
 static const struct x86_cpu_id int0002_cpu_ids[] =3D {
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	&int0002_byt_irqchip),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&int0002_cht_irqchip),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&int0002_byt_irqchip),
 	{}
 };
=20
@@ -181,6 +169,10 @@ static int int0002_probe(struct platform_device *pde=
v)
 	if (!cpu_id)
 		return -ENODEV;
=20
+	/* We only need to directly deal with PMEs when using s2idle */
+	if (!pm_suspend_default_s2idle())
+		return -ENODEV;
+
 	irq =3D platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
--=20
2.26.0

