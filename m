Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA48D422CEA
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhJEPt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 11:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235894AbhJEPt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 11:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF6261264;
        Tue,  5 Oct 2021 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633448858;
        bh=uV0NtEsiiZSpSgLEDo/mQ5fg+WxGat8oboADXJEeid4=;
        h=Subject:To:From:Date:From;
        b=LJ4mg3AGUBlWHafeQKO24kAMUhZFoFWNvRECqg9mTwPCFNQJt88JdxLT588UT3izh
         7b6TW0mbGyz7T2IPIgaZO6YDBO84PGO0lTn1vJyqGIo6suSp6WcAM+FVXC7HrgmjYr
         cxTZjIXAXPfYz6xGA8qYzI6S4PQCEs/kOzxRfAVA=
Subject: patch "drivers: bus: simple-pm-bus: Add support for probing simple bus only" added to driver-core-linus
To:     saravanak@google.com, damien.lemoal@wdc.com,
        geert+renesas@glider.be, gregkh@linuxfoundation.org,
        robh+dt@kernel.org, stable@vger.kernel.org, ulf.hansson@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 17:47:35 +0200
Message-ID: <163344885510231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers: bus: simple-pm-bus: Add support for probing simple bus only

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 98e96cf80045a383fcc47c58dd4e87b3ae587b3e Mon Sep 17 00:00:00 2001
From: Saravana Kannan <saravanak@google.com>
Date: Tue, 28 Sep 2021 17:07:33 -0700
Subject: drivers: bus: simple-pm-bus: Add support for probing simple bus only
 devices

fw_devlink could end up creating device links for bus only devices.
However, bus only devices don't get probed and can block probe() or
sync_state() [1] call backs of other devices. To avoid this, probe these
devices using the simple-pm-bus driver.

However, there are instances of devices that are not simple buses (they get
probed by their specific drivers) that also list the "simple-bus" (or other
bus only compatible strings) in their compatible property to automatically
populate their child devices. We still want these devices to get probed by
their specific drivers. So, we make sure this driver only probes devices
that are only buses.

[1] - https://lore.kernel.org/lkml/CAPDyKFo9Bxremkb1dDrr4OcXSpE0keVze94Cm=zrkOVxHHxBmQ@mail.gmail.com/

Fixes: c442a0d18744 ("driver core: Set fw_devlink to "permissive" behavior by default")
Cc: stable <stable@vger.kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Tested-by: Saravana Kannan <saravanak@google.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210929000735.585237-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/simple-pm-bus.c | 42 ++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/simple-pm-bus.c b/drivers/bus/simple-pm-bus.c
index 01a3d0cd08ed..6b8d6257ed8a 100644
--- a/drivers/bus/simple-pm-bus.c
+++ b/drivers/bus/simple-pm-bus.c
@@ -13,11 +13,36 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
-
 static int simple_pm_bus_probe(struct platform_device *pdev)
 {
-	const struct of_dev_auxdata *lookup = dev_get_platdata(&pdev->dev);
-	struct device_node *np = pdev->dev.of_node;
+	const struct device *dev = &pdev->dev;
+	const struct of_dev_auxdata *lookup = dev_get_platdata(dev);
+	struct device_node *np = dev->of_node;
+	const struct of_device_id *match;
+
+	/*
+	 * Allow user to use driver_override to bind this driver to a
+	 * transparent bus device which has a different compatible string
+	 * that's not listed in simple_pm_bus_of_match. We don't want to do any
+	 * of the simple-pm-bus tasks for these devices, so return early.
+	 */
+	if (pdev->driver_override)
+		return 0;
+
+	match = of_match_device(dev->driver->of_match_table, dev);
+	/*
+	 * These are transparent bus devices (not simple-pm-bus matches) that
+	 * have their child nodes populated automatically.  So, don't need to
+	 * do anything more. We only match with the device if this driver is
+	 * the most specific match because we don't want to incorrectly bind to
+	 * a device that has a more specific driver.
+	 */
+	if (match && match->data) {
+		if (of_property_match_string(np, "compatible", match->compatible) == 0)
+			return 0;
+		else
+			return -ENODEV;
+	}
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
@@ -31,14 +56,25 @@ static int simple_pm_bus_probe(struct platform_device *pdev)
 
 static int simple_pm_bus_remove(struct platform_device *pdev)
 {
+	const void *data = of_device_get_match_data(&pdev->dev);
+
+	if (pdev->driver_override || data)
+		return 0;
+
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
 
+#define ONLY_BUS	((void *) 1) /* Match if the device is only a bus. */
+
 static const struct of_device_id simple_pm_bus_of_match[] = {
 	{ .compatible = "simple-pm-bus", },
+	{ .compatible = "simple-bus",	.data = ONLY_BUS },
+	{ .compatible = "simple-mfd",	.data = ONLY_BUS },
+	{ .compatible = "isa",		.data = ONLY_BUS },
+	{ .compatible = "arm,amba-bus",	.data = ONLY_BUS },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, simple_pm_bus_of_match);
-- 
2.33.0


