Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822244510EB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243250AbhKOS43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243231AbhKOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E28632A5;
        Mon, 15 Nov 2021 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999853;
        bh=ZhVxJQaCIDAb/vIDczFoYwveB4qAWLQcwjfawo4QLec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVgJszzzRCcAQxRq8gEnKJmXidJoLYVIIH65C5DaHg5VkawkHxmL8jWSGzvU07qoL
         qRc79a8CLJxvk4msNd/CHWueOZprdjBzI2RdMZJzzKdU4HzZaBBC39Ymtb6alx8haU
         bYL/0paw8DWpyUH3giJzCwJb+u2pfI2Y8SQSjCGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 447/849] ACPI: PM: Fix sharing of wakeup power resources
Date:   Mon, 15 Nov 2021 17:58:50 +0100
Message-Id: <20211115165435.410472676@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit a2d7b2e004af6b09f21ac3d10f8f4456c16a8ddf ]

If an ACPI wakeup power resource is shared between multiple devices,
it may not be managed correctly.

Suppose, for example, that two devices, A and B, share a wakeup power
resource P whose wakeup_enabled flag is 0 initially.  Next, suppose
that wakeup power is enabled for A and B, in this order, and disabled
for B.  When wakeup power is enabled for A, P will be turned on and
its wakeup_enabled flag will be set.  Next, when wakeup power is
enabled for B, P will not be touched, because its wakeup_enabled flag
is set.  Now, when wakeup power is disabled for B, P will be turned
off which is incorrect, because A will still need P in order to signal
wakeup.

Moreover, if wakeup power is enabled for A and then disabled for B,
the latter will cause P to be turned off incorrectly (it will be still
needed by A), because acpi_disable_wakeup_device_power() is allowed
to manipulate power resources when the wakeup.prepare_count counter
of the given device is 0.

While the first issue could be addressed by changing the
wakeup_enabled power resource flag into a counter, addressing the
second one requires modifying acpi_disable_wakeup_device_power() to
do nothing when the target device's wakeup.prepare_count reference
counter is zero and that would cause the new counter to be redundant.
Namely, if acpi_disable_wakeup_device_power() is modified as per the
above, every change of the new counter following a wakeup.prepare_count
change would be reflected by the analogous change of the main reference
counter of the given power resource.

Accordingly, modify acpi_disable_wakeup_device_power() to do nothing
when the target device's wakeup.prepare_count reference counter is
zero and drop the power resource wakeup_enabled flag altogether.

While at it, ensure that all of the power resources that can be
turned off will be turned off when disabling device wakeup due to
a power resource manipulation error, to prevent energy from being
wasted.

Fixes: b5d667eb392e ("ACPI / PM: Take unusual configurations of power resources into account")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 69 +++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index dfe760bd7157f..e1f9a45587857 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -53,7 +53,6 @@ struct acpi_power_resource {
 	u32 order;
 	unsigned int ref_count;
 	u8 state;
-	bool wakeup_enabled;
 	struct mutex resource_lock;
 	struct list_head dependents;
 };
@@ -701,7 +700,6 @@ int acpi_device_sleep_wake(struct acpi_device *dev,
  */
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int sleep_state)
 {
-	struct acpi_power_resource_entry *entry;
 	int err = 0;
 
 	if (!dev || !dev->wakeup.flags.valid)
@@ -712,26 +710,13 @@ int acpi_enable_wakeup_device_power(struct acpi_device *dev, int sleep_state)
 	if (dev->wakeup.prepare_count++)
 		goto out;
 
-	list_for_each_entry(entry, &dev->wakeup.resources, node) {
-		struct acpi_power_resource *resource = entry->resource;
-
-		mutex_lock(&resource->resource_lock);
-
-		if (!resource->wakeup_enabled) {
-			err = acpi_power_on_unlocked(resource);
-			if (!err)
-				resource->wakeup_enabled = true;
-		}
-
-		mutex_unlock(&resource->resource_lock);
-
-		if (err) {
-			dev_err(&dev->dev,
-				"Cannot turn wakeup power resources on\n");
-			dev->wakeup.flags.valid = 0;
-			goto out;
-		}
+	err = acpi_power_on_list(&dev->wakeup.resources);
+	if (err) {
+		dev_err(&dev->dev, "Cannot turn on wakeup power resources\n");
+		dev->wakeup.flags.valid = 0;
+		goto out;
 	}
+
 	/*
 	 * Passing 3 as the third argument below means the device may be
 	 * put into arbitrary power state afterward.
@@ -761,39 +746,33 @@ int acpi_disable_wakeup_device_power(struct acpi_device *dev)
 
 	mutex_lock(&acpi_device_lock);
 
-	if (--dev->wakeup.prepare_count > 0)
+	if (dev->wakeup.prepare_count > 1) {
+		dev->wakeup.prepare_count--;
 		goto out;
+	}
 
-	/*
-	 * Executing the code below even if prepare_count is already zero when
-	 * the function is called may be useful, for example for initialisation.
-	 */
-	if (dev->wakeup.prepare_count < 0)
-		dev->wakeup.prepare_count = 0;
+	/* Do nothing if wakeup power has not been enabled for this device. */
+	if (!dev->wakeup.prepare_count)
+		goto out;
 
 	err = acpi_device_sleep_wake(dev, 0, 0, 0);
 	if (err)
 		goto out;
 
+	/*
+	 * All of the power resources in the list need to be turned off even if
+	 * there are errors.
+	 */
 	list_for_each_entry(entry, &dev->wakeup.resources, node) {
-		struct acpi_power_resource *resource = entry->resource;
-
-		mutex_lock(&resource->resource_lock);
-
-		if (resource->wakeup_enabled) {
-			err = acpi_power_off_unlocked(resource);
-			if (!err)
-				resource->wakeup_enabled = false;
-		}
-
-		mutex_unlock(&resource->resource_lock);
+		int ret;
 
-		if (err) {
-			dev_err(&dev->dev,
-				"Cannot turn wakeup power resources off\n");
-			dev->wakeup.flags.valid = 0;
-			break;
-		}
+		ret = acpi_power_off(entry->resource);
+		if (ret && !err)
+			err = ret;
+	}
+	if (err) {
+		dev_err(&dev->dev, "Cannot turn off wakeup power resources\n");
+		dev->wakeup.flags.valid = 0;
 	}
 
  out:
-- 
2.33.0



