Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A4D1B0A2C
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgDTMpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728767AbgDTMpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE8F022272;
        Mon, 20 Apr 2020 12:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386731;
        bh=CHT7tP3ObfYRnhJ7czCRU4bQMZ6ppu8oRHs2gtbocQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukMMKBX2B+hYJCAiHnM4CK21YTsqfzeopl91Wu7aQt5o5YjK+9ar0nZjojAUKpunw
         2wRALptdd96rN31YLVC01UMMLXbrAXjNhfJsTD5HERRoKqAVb3jJLgS1p0D96i4ZEx
         p7P4UCtZWtgOa/T/J59TO9MPrK7iow5K7BCyyjEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.6 61/71] i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND flag on BYT and CHT
Date:   Mon, 20 Apr 2020 14:39:15 +0200
Message-Id: <20200420121521.201168075@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit d79294d0de12ddd1420110813626d691f440b86f upstream.

We already set DPM_FLAG_SMART_PREPARE, so we completely skip all
callbacks (other then prepare) where possible, quoting from
dw_i2c_plat_prepare():

        /*
         * If the ACPI companion device object is present for this device, it
         * may be accessed during suspend and resume of other devices via I2C
         * operation regions, so tell the PM core and middle layers to avoid
         * skipping system suspend/resume callbacks for it in that case.
         */
        return !has_acpi_companion(dev);

Also setting the DPM_FLAG_SMART_SUSPEND will cause acpi_subsys_suspend()
to leave the controller runtime-suspended even if dw_i2c_plat_prepare()
returned 0.

Leaving the controller runtime-suspended normally, when the I2C controller
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
[   93.275993] WARNING: CPU: 0 PID: 412 at drivers/i2c/busses/i2c-designware-master.c:429 i2c_dw_xfer+0x239/0x280
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
Fixes: b30f2f65568f ("i2c: designware: Set IRQF_NO_SUSPEND flag for all BYT and CHT controllers")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-designware-platdrv.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -371,10 +371,16 @@ static int dw_i2c_plat_probe(struct plat
 	adap->dev.of_node = pdev->dev.of_node;
 	adap->nr = -1;
 
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
 
 	/* The code below assumes runtime PM to be disabled. */
 	WARN_ON(pm_runtime_enabled(&pdev->dev));


