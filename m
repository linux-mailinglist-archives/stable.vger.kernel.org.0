Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7BA3BBEE8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhGEPbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231811AbhGEPa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D53A961261;
        Mon,  5 Jul 2021 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498901;
        bh=AfFsESWn+uQ1cTXGHjXePS7rBBycVHTcdjrIC+TbAHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlbCZ/8u9rYJl4vf/7HX0V6ilCBjmTJtBJrKYMW3aZUN93+eUZYEgpZMAROmrUKVN
         izcllZIMI6zhLqUuLxCNsPndUR+8HNj+adozEsudICR/gLSaqeQsvCjCqTcbrj323H
         TaIeCLkm3WUL5amwK9GeouaoZEcSp1fW72SWJDqnpeWZfBWzaWq3mIXFSDvA+c3EtE
         o2O5dGBUg6BP02OUzld9W8dPVBTXQLOBaYoEuYfVlCFGBGk6YtT9JmDiL3y5kPjoor
         0cM3QPwsv54gf+CoimAikj+etO0dTcU8WppMyVx2I6GnjBCh6IfiWbnniKdiOqVXD3
         nV7cmMSvHcvoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 04/59] ACPI: scan: Rearrange dep_unmet initialization
Date:   Mon,  5 Jul 2021 11:27:20 -0400
Message-Id: <20210705152815.1520546-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 6d27975851b134be8d2a170437210c9719e524aa ]

The dep_unmet field in struct acpi_device is used to store the
number of unresolved _DEP dependencies (that is, operation region
dependencies for which there are no drivers present) for the ACPI
device object represented by it.

That field is initialized to 1 for all ACPI device objects in
acpi_add_single_object(), via acpi_init_device_object(), so as to
avoid evaluating _STA prematurely for battery device objects in
acpi_scan_init_status(), and it is "fixed up" in acpi_bus_check_add()
after the acpi_add_single_object() called by it has returned.

This is not particularly straightforward and causes dep_unmet to
remain 1 for device objects without dependencies created by invoking
acpi_add_single_object() directly, outside acpi_bus_check_add().

For this reason, rearrange acpi_add_single_object() to initialize
dep_unmet completely before calling acpi_scan_init_status(), which
requires passing one extra bool argument to it, and update all of
its callers accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 60 +++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index e10d38ac7cf2..438df8da6d12 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1671,8 +1671,20 @@ void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
 	device_initialize(&device->dev);
 	dev_set_uevent_suppress(&device->dev, true);
 	acpi_init_coherency(device);
-	/* Assume there are unmet deps to start with. */
-	device->dep_unmet = 1;
+}
+
+static void acpi_scan_dep_init(struct acpi_device *adev)
+{
+	struct acpi_dep_data *dep;
+
+	mutex_lock(&acpi_dep_list_lock);
+
+	list_for_each_entry(dep, &acpi_dep_list, node) {
+		if (dep->consumer == adev->handle)
+			adev->dep_unmet++;
+	}
+
+	mutex_unlock(&acpi_dep_list_lock);
 }
 
 void acpi_device_add_finalize(struct acpi_device *device)
@@ -1688,7 +1700,7 @@ static void acpi_scan_init_status(struct acpi_device *adev)
 }
 
 static int acpi_add_single_object(struct acpi_device **child,
-				  acpi_handle handle, int type)
+				  acpi_handle handle, int type, bool dep_init)
 {
 	struct acpi_device *device;
 	int result;
@@ -1703,8 +1715,12 @@ static int acpi_add_single_object(struct acpi_device **child,
 	 * acpi_bus_get_status() and use its quirk handling.  Note that
 	 * this must be done before the get power-/wakeup_dev-flags calls.
 	 */
-	if (type == ACPI_BUS_TYPE_DEVICE || type == ACPI_BUS_TYPE_PROCESSOR)
+	if (type == ACPI_BUS_TYPE_DEVICE || type == ACPI_BUS_TYPE_PROCESSOR) {
+		if (dep_init)
+			acpi_scan_dep_init(device);
+
 		acpi_scan_init_status(device);
+	}
 
 	acpi_bus_get_power_flags(device);
 	acpi_bus_get_wakeup_device_flags(device);
@@ -1886,22 +1902,6 @@ static u32 acpi_scan_check_dep(acpi_handle handle, bool check_dep)
 	return count;
 }
 
-static void acpi_scan_dep_init(struct acpi_device *adev)
-{
-	struct acpi_dep_data *dep;
-
-	adev->dep_unmet = 0;
-
-	mutex_lock(&acpi_dep_list_lock);
-
-	list_for_each_entry(dep, &acpi_dep_list, node) {
-		if (dep->consumer == adev->handle)
-			adev->dep_unmet++;
-	}
-
-	mutex_unlock(&acpi_dep_list_lock);
-}
-
 static bool acpi_bus_scan_second_pass;
 
 static acpi_status acpi_bus_check_add(acpi_handle handle, bool check_dep,
@@ -1949,19 +1949,15 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, bool check_dep,
 		return AE_OK;
 	}
 
-	acpi_add_single_object(&device, handle, type);
-	if (!device)
-		return AE_CTRL_DEPTH;
-
-	acpi_scan_init_hotplug(device);
 	/*
 	 * If check_dep is true at this point, the device has no dependencies,
 	 * or the creation of the device object would have been postponed above.
 	 */
-	if (check_dep)
-		device->dep_unmet = 0;
-	else
-		acpi_scan_dep_init(device);
+	acpi_add_single_object(&device, handle, type, !check_dep);
+	if (!device)
+		return AE_CTRL_DEPTH;
+
+	acpi_scan_init_hotplug(device);
 
 out:
 	if (!*adev_p)
@@ -2223,7 +2219,7 @@ int acpi_bus_register_early_device(int type)
 	struct acpi_device *device = NULL;
 	int result;
 
-	result = acpi_add_single_object(&device, NULL, type);
+	result = acpi_add_single_object(&device, NULL, type, false);
 	if (result)
 		return result;
 
@@ -2243,7 +2239,7 @@ static int acpi_bus_scan_fixed(void)
 		struct acpi_device *device = NULL;
 
 		result = acpi_add_single_object(&device, NULL,
-						ACPI_BUS_TYPE_POWER_BUTTON);
+						ACPI_BUS_TYPE_POWER_BUTTON, false);
 		if (result)
 			return result;
 
@@ -2259,7 +2255,7 @@ static int acpi_bus_scan_fixed(void)
 		struct acpi_device *device = NULL;
 
 		result = acpi_add_single_object(&device, NULL,
-						ACPI_BUS_TYPE_SLEEP_BUTTON);
+						ACPI_BUS_TYPE_SLEEP_BUTTON, false);
 		if (result)
 			return result;
 
-- 
2.30.2

