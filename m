Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C882E3A27
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387774AbgL1Nc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387821AbgL1Ncy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23A021D94;
        Mon, 28 Dec 2020 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162333;
        bh=D8y1OYje5ZD0UFPVm9vQcYw2OGV1Nbh+qBrtwTWUi8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SICY2KX7lgtlOkSxhBh4WkgLlChkyUeTZIZKzn0gflEshb57UHh5nO8LSm2L2qF6N
         tsLvn1Av90SMQO6/z/yBwjHHDi15/rvFWWwmQRgBgpNjE+iW0V75VLEQg7+B7qPCMJ
         QcDgDYoGzQaCwN133UiHKK8hHZESWYp78tGeOTnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 268/346] PM: ACPI: PCI: Drop acpi_pm_set_bridge_wakeup()
Date:   Mon, 28 Dec 2020 13:49:47 +0100
Message-Id: <20201228124932.728333196@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 7482c5cb90e5a7f9e9e12dd154d405e0219656e3 upstream.

The idea behind acpi_pm_set_bridge_wakeup() was to allow bridges to
be reference counted for wakeup enabling, because they may be enabled
to signal wakeup on behalf of their subordinate devices and that
may happen for multiple times in a row, whereas for the other devices
it only makes sense to enable wakeup signaling once.

However, this becomes problematic if the bridge itself is suspended,
because it is treated as a "regular" device in that case and the
reference counting doesn't work.

For instance, suppose that there are two devices below a bridge and
they both can signal wakeup.  Every time one of them is suspended,
wakeup signaling is enabled for the bridge, so when they both have
been suspended, the bridge's wakeup reference counter value is 2.

Say that the bridge is suspended subsequently and acpi_pci_wakeup()
is called for it.  Because the bridge can signal wakeup, that
function will invoke acpi_pm_set_device_wakeup() to configure it
and __acpi_pm_set_device_wakeup() will be called with the last
argument equal to 1.  This causes __acpi_device_wakeup_enable()
invoked by it to omit the reference counting, because the reference
counter of the target device (the bridge) is 2 at that time.

Now say that the bridge resumes and one of the device below it
resumes too, so the bridge's reference counter becomes 0 and
wakeup signaling is disabled for it, but there is still the other
suspended device which may need the bridge to signal wakeup on its
behalf and that is not going to work.

To address this scenario, use wakeup enable reference counting for
all devices, not just for bridges, so drop the last argument from
__acpi_device_wakeup_enable() and __acpi_pm_set_device_wakeup(),
which causes acpi_pm_set_device_wakeup() and
acpi_pm_set_bridge_wakeup() to become identical, so drop the latter
and use the former instead of it everywhere.

Fixes: 1ba51a7c1496 ("ACPI / PCI / PM: Rework acpi_pci_propagate_wakeup()")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: 4.14+ <stable@vger.kernel.org> # 4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |   41 ++++++++++++-----------------------------
 drivers/pci/pci-acpi.c   |    4 ++--
 include/acpi/acpi_bus.h  |    5 -----
 3 files changed, 14 insertions(+), 36 deletions(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -702,7 +702,7 @@ static void acpi_pm_notify_work_func(str
 static DEFINE_MUTEX(acpi_wakeup_lock);
 
 static int __acpi_device_wakeup_enable(struct acpi_device *adev,
-				       u32 target_state, int max_count)
+				       u32 target_state)
 {
 	struct acpi_device_wakeup *wakeup = &adev->wakeup;
 	acpi_status status;
@@ -710,9 +710,10 @@ static int __acpi_device_wakeup_enable(s
 
 	mutex_lock(&acpi_wakeup_lock);
 
-	if (wakeup->enable_count >= max_count)
+	if (wakeup->enable_count >= INT_MAX) {
+		acpi_handle_info(adev->handle, "Wakeup enable count out of bounds!\n");
 		goto out;
-
+	}
 	if (wakeup->enable_count > 0)
 		goto inc;
 
@@ -749,7 +750,7 @@ out:
  */
 static int acpi_device_wakeup_enable(struct acpi_device *adev, u32 target_state)
 {
-	return __acpi_device_wakeup_enable(adev, target_state, 1);
+	return __acpi_device_wakeup_enable(adev, target_state);
 }
 
 /**
@@ -779,8 +780,12 @@ out:
 	mutex_unlock(&acpi_wakeup_lock);
 }
 
-static int __acpi_pm_set_device_wakeup(struct device *dev, bool enable,
-				       int max_count)
+/**
+ * acpi_pm_set_device_wakeup - Enable/disable remote wakeup for given device.
+ * @dev: Device to enable/disable to generate wakeup events.
+ * @enable: Whether to enable or disable the wakeup functionality.
+ */
+int acpi_pm_set_device_wakeup(struct device *dev, bool enable)
 {
 	struct acpi_device *adev;
 	int error;
@@ -800,37 +805,15 @@ static int __acpi_pm_set_device_wakeup(s
 		return 0;
 	}
 
-	error = __acpi_device_wakeup_enable(adev, acpi_target_system_state(),
-					    max_count);
+	error = __acpi_device_wakeup_enable(adev, acpi_target_system_state());
 	if (!error)
 		dev_dbg(dev, "Wakeup enabled by ACPI\n");
 
 	return error;
 }
-
-/**
- * acpi_pm_set_device_wakeup - Enable/disable remote wakeup for given device.
- * @dev: Device to enable/disable to generate wakeup events.
- * @enable: Whether to enable or disable the wakeup functionality.
- */
-int acpi_pm_set_device_wakeup(struct device *dev, bool enable)
-{
-	return __acpi_pm_set_device_wakeup(dev, enable, 1);
-}
 EXPORT_SYMBOL_GPL(acpi_pm_set_device_wakeup);
 
 /**
- * acpi_pm_set_bridge_wakeup - Enable/disable remote wakeup for given bridge.
- * @dev: Bridge device to enable/disable to generate wakeup events.
- * @enable: Whether to enable or disable the wakeup functionality.
- */
-int acpi_pm_set_bridge_wakeup(struct device *dev, bool enable)
-{
-	return __acpi_pm_set_device_wakeup(dev, enable, INT_MAX);
-}
-EXPORT_SYMBOL_GPL(acpi_pm_set_bridge_wakeup);
-
-/**
  * acpi_dev_pm_low_power - Put ACPI device into a low-power state.
  * @dev: Device to put into a low-power state.
  * @adev: ACPI device node corresponding to @dev.
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -587,7 +587,7 @@ static int acpi_pci_propagate_wakeup(str
 {
 	while (bus->parent) {
 		if (acpi_pm_device_can_wakeup(&bus->self->dev))
-			return acpi_pm_set_bridge_wakeup(&bus->self->dev, enable);
+			return acpi_pm_set_device_wakeup(&bus->self->dev, enable);
 
 		bus = bus->parent;
 	}
@@ -595,7 +595,7 @@ static int acpi_pci_propagate_wakeup(str
 	/* We have reached the root bus. */
 	if (bus->bridge) {
 		if (acpi_pm_device_can_wakeup(bus->bridge))
-			return acpi_pm_set_bridge_wakeup(bus->bridge, enable);
+			return acpi_pm_set_device_wakeup(bus->bridge, enable);
 	}
 	return 0;
 }
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -622,7 +622,6 @@ acpi_status acpi_remove_pm_notifier(stru
 bool acpi_pm_device_can_wakeup(struct device *dev);
 int acpi_pm_device_sleep_state(struct device *, int *, int);
 int acpi_pm_set_device_wakeup(struct device *dev, bool enable);
-int acpi_pm_set_bridge_wakeup(struct device *dev, bool enable);
 #else
 static inline void acpi_pm_wakeup_event(struct device *dev)
 {
@@ -653,10 +652,6 @@ static inline int acpi_pm_set_device_wak
 {
 	return -ENODEV;
 }
-static inline int acpi_pm_set_bridge_wakeup(struct device *dev, bool enable)
-{
-	return -ENODEV;
-}
 #endif
 
 #ifdef CONFIG_ACPI_SLEEP


