Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235431A1357
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDGSLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 14:11:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53632 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbgDGSLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 14:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586283083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tuL8jd0KtgUQDBTiliOb/iyftwg57mLjnYugyIVReUI=;
        b=GCSAAIyyaaVwtEvSg8KI3ptSFNFRYBXaNJUm7X7BmaKbjVq2mS4FXyC38L2zA1Q61Llkc3
        lszhBZ4g6f3Rx6IHq8ivFaPtaU/4mldutlTkm4ilyulBUubP60+us/8QPa06e8eFRNetA9
        Vdp3QHiDIbP5EtUM8O7EzqAqzbTZzdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-0TUKg2RqP36k0y_mReO5rQ-1; Tue, 07 Apr 2020 14:11:21 -0400
X-MC-Unique: 0TUKg2RqP36k0y_mReO5rQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3779B1005510;
        Tue,  7 Apr 2020 18:11:20 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-63.ams2.redhat.com [10.36.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FCED5DDA5;
        Tue,  7 Apr 2020 18:11:17 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND flag on BYT and CHT
Date:   Tue,  7 Apr 2020 20:11:16 +0200
Message-Id: <20200407181116.61066-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We already set DPM_FLAG_SMART_PREPARE, so we completely skip all
callbacks (other then prepare) where possible, quoting from
dw_i2c_plat_prepare():

        /*
         * If the ACPI companion device object is present for this device=
, it
         * may be accessed during suspend and resume of other devices via=
 I2C
         * operation regions, so tell the PM core and middle layers to av=
oid
         * skipping system suspend/resume callbacks for it in that case.
         */
        return !has_acpi_companion(dev);

Also setting the DPM_FLAG_SMART_SUSPEND will cause acpi_subsys_suspend()
to leave the controller runtime-suspended even if dw_i2c_plat_prepare()
returned 0.

Leaving the controller runtime-suspended normally, when the I2C controlle=
r
is suspended during the suspend_late phase, is not an issue because
the pm_runtime_get_sync() done by i2c_dw_xfer() will (runtime-)resume it.

But for dw I2C controllers on Bay- and Cherry-Trail devices acpi_lpss.c
leaves the controller alive until the suspend_noirq phase, because it may
be used by the _PS3 ACPI methods of PCI devices and PCI devices are left
powered on until the suspend_noirq phase.

Between the suspend_late and resume_early phases runtime-pm is disabled.
So for any ACPI I2C OPRegion accesses done after the suspend_late phase,
the pm_runtime_get_sync() done by i2c_dw_xfer() is a no-op and the
controller is left runtime-suspended.

i2c_dw_xfer() has a check to catch this condition (rather then waiting
for the I2C transfer to timeout because the controller is suspended).
acpi_subsys_suspend() leaving the controller runtime-suspended in
combination with an ACPI I2C OPRegion access done after the suspend_late
phase triggers this check, leading to the following error being logged
on a Bay Trail based Lenovo Thinkpad 8 tablet:

[   93.275882] i2c_designware 80860F41:00: Transfer while suspended
[   93.275993] WARNING: CPU: 0 PID: 412 at drivers/i2c/busses/i2c-designw=
are-master.c:429 i2c_dw_xfer+0x239/0x280
...
[   93.276252] Workqueue: kacpi_notify acpi_os_execute_deferred
[   93.276267] RIP: 0010:i2c_dw_xfer+0x239/0x280
...
[   93.276340] Call Trace:
[   93.276366]  __i2c_transfer+0x121/0x520
[   93.276379]  i2c_transfer+0x4c/0x100
[   93.276392]  i2c_acpi_space_handler+0x219/0x510
[   93.276408]  ? up+0x40/0x60
[   93.276419]  ? i2c_acpi_notify+0x130/0x130
[   93.276433]  acpi_ev_address_space_dispatch+0x1e1/0x252
...

So since on BYT and CHT platforms we want ACPI I2c OPRegion accesses
to work until the suspend_noirq phase, we need the controller to be
runtime-resumed during the suspend phase if it is runtime-suspended
suspended at that time. This means that we must not set the
DPM_FLAG_SMART_SUSPEND on these platforms.

On BYT and CHT we already have a special ACCESS_NO_IRQ_SUSPEND flag
to make sure the controller stays functional until the suspend_noirq
phase. This commit makes the driver not set the DPM_FLAG_SMART_SUSPEND
flag when that flag is set.

Cc: stable@vger.kernel.org
Fixes: b30f2f65568f ("i2c: designware: Set IRQF_NO_SUSPEND flag for all B=
YT and CHT controllers")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/bu=
sses/i2c-designware-platdrv.c
index 3b7d58c2fe85..15b4b965b443 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -371,10 +371,16 @@ static int dw_i2c_plat_probe(struct platform_device=
 *pdev)
 	adap->dev.of_node =3D pdev->dev.of_node;
 	adap->nr =3D -1;
=20
-	dev_pm_set_driver_flags(&pdev->dev,
-				DPM_FLAG_SMART_PREPARE |
-				DPM_FLAG_SMART_SUSPEND |
-				DPM_FLAG_LEAVE_SUSPENDED);
+	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
+		dev_pm_set_driver_flags(&pdev->dev,
+					DPM_FLAG_SMART_PREPARE |
+					DPM_FLAG_LEAVE_SUSPENDED);
+	} else {
+		dev_pm_set_driver_flags(&pdev->dev,
+					DPM_FLAG_SMART_PREPARE |
+					DPM_FLAG_SMART_SUSPEND |
+					DPM_FLAG_LEAVE_SUSPENDED);
+	}
=20
 	/* The code below assumes runtime PM to be disabled. */
 	WARN_ON(pm_runtime_enabled(&pdev->dev));
--=20
2.26.0

