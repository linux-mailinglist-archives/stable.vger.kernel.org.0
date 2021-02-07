Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1DA312778
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 22:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhBGVHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 16:07:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:60576 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGVHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 16:07:18 -0500
Date:   Sun, 7 Feb 2021 22:06:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612731996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=5dANY9EDzidvAnqhTvIwSv5WP1m+YnI8TZLSfWZcH0A=;
        b=e7SksAPbmpsu/nX5uzZdPofUZw4ly1vT+ul3Vkd2/bGzbB/GgdFJprgH9sdj0uMFc45vE8
        bDXYIfY+vyYEw7/vnU/A63SZmlJI8OpmeLZHQDl+PB3niwYReYIMHrEoVPU0mLqlFAHwbw
        MSsulgoQtC0pDkiyGuY+WZ3KK+TnqZQLETeq4ugY3ehBlzn+qfki3ixzvis15DOmzKOtbh
        x+S5D6Xmz4IFA/N+V93U0rk1p/PLV1Jl1b2zcmUu+GbO7Gr4G5NfoKAVkIhymCtpW9j1L/
        0AoUtXX9IhzsdWdnkA45L2eUP02lc50laFXitvjmP8vTLjtN2slomhErZQ41+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612731996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=5dANY9EDzidvAnqhTvIwSv5WP1m+YnI8TZLSfWZcH0A=;
        b=UBkjQYzGnaq6Lp3Mk8VUHMus4EThGYxN7FTYJiKj05rPWKVVp4TkHfXXVMYVW0Zgr3dBVz
        sJet51NybKL/3WDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     stable@vger.kernel.org
Cc:     rafael.j.wysocki@intel.com, stephen.berman@gmx.net
Subject: [PATCH] ACPI: thermal: Do not call acpi_thermal_check() directly
Message-ID: <20210207210634.iaufnwzlibmpabos@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 81b704d3e4674e09781d331df73d76675d5ad8cb

Applies to 4.4-stable tree

----------->8---------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Thu, 14 Jan 2021 19:34:22 +0100
Subject: [PATCH] ACPI: thermal: Do not call acpi_thermal_check() directly

Calling acpi_thermal_check() from acpi_thermal_notify() directly
is problematic if _TMP triggers Notify () on the thermal zone for
which it has been evaluated (which happens on some systems), because
it causes a new acpi_thermal_notify() invocation to be queued up
every time and if that takes place too often, an indefinite number of
pending work items may accumulate in kacpi_notify_wq over time.

Besides, it is not really useful to queue up a new invocation of
acpi_thermal_check() if one of them is pending already.

For these reasons, rework acpi_thermal_notify() to queue up a thermal
check instead of calling acpi_thermal_check() directly and only allow
one thermal check to be pending at a time.  Moreover, only allow one
acpi_thermal_check_fn() instance at a time to run
thermal_zone_device_update() for one thermal zone and make it return
early if it sees other instances running for the same thermal zone.

While at it, fold acpi_thermal_check() into acpi_thermal_check_fn(),
as it is only called from there after the other changes made here.

[This issue appears to have been exposed by commit 6d25be5782e4
 ("sched/core, workqueues: Distangle worker accounting from rq
 lock"), but it is unclear why it was not visible earlier.]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208877
Reported-by: Stephen Berman <stephen.berman@gmx.net>
Diagnosed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Stephen Berman <stephen.berman@gmx.net>
Cc: All applicable <stable@vger.kernel.org>
[bigeasy: Backported to v4.4.y, use atomic_t instead of refcount_t]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/acpi/thermal.c | 54 +++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 82707f9824cae..b4826335ad0b3 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -188,6 +188,8 @@ struct acpi_thermal {
 	int tz_enabled;
 	int kelvin_offset;
 	struct work_struct thermal_check_work;
+	struct mutex thermal_check_lock;
+	atomic_t thermal_check_count;
 };
 
 /* --------------------------------------------------------------------------
@@ -513,16 +515,6 @@ static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 	return 0;
 }
 
-static void acpi_thermal_check(void *data)
-{
-	struct acpi_thermal *tz = data;
-
-	if (!tz->tz_enabled)
-		return;
-
-	thermal_zone_device_update(tz->thermal_zone);
-}
-
 /* sys I/F for generic thermal sysfs support */
 
 static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
@@ -556,6 +548,8 @@ static int thermal_get_mode(struct thermal_zone_device *thermal,
 	return 0;
 }
 
+static void acpi_thermal_check_fn(struct work_struct *work);
+
 static int thermal_set_mode(struct thermal_zone_device *thermal,
 				enum thermal_device_mode mode)
 {
@@ -581,7 +575,7 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			"%s kernel ACPI thermal control\n",
 			tz->tz_enabled ? "Enable" : "Disable"));
-		acpi_thermal_check(tz);
+		acpi_thermal_check_fn(&tz->thermal_check_work);
 	}
 	return 0;
 }
@@ -950,6 +944,12 @@ static void acpi_thermal_unregister_thermal_zone(struct acpi_thermal *tz)
                                  Driver Interface
    -------------------------------------------------------------------------- */
 
+static void acpi_queue_thermal_check(struct acpi_thermal *tz)
+{
+	if (!work_pending(&tz->thermal_check_work))
+		queue_work(acpi_thermal_pm_queue, &tz->thermal_check_work);
+}
+
 static void acpi_thermal_notify(struct acpi_device *device, u32 event)
 {
 	struct acpi_thermal *tz = acpi_driver_data(device);
@@ -960,17 +960,17 @@ static void acpi_thermal_notify(struct acpi_device *device, u32 event)
 
 	switch (event) {
 	case ACPI_THERMAL_NOTIFY_TEMPERATURE:
-		acpi_thermal_check(tz);
+		acpi_queue_thermal_check(tz);
 		break;
 	case ACPI_THERMAL_NOTIFY_THRESHOLDS:
 		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_THRESHOLDS);
-		acpi_thermal_check(tz);
+		acpi_queue_thermal_check(tz);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 		break;
 	case ACPI_THERMAL_NOTIFY_DEVICES:
 		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_DEVICES);
-		acpi_thermal_check(tz);
+		acpi_queue_thermal_check(tz);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 		break;
@@ -1070,7 +1070,27 @@ static void acpi_thermal_check_fn(struct work_struct *work)
 {
 	struct acpi_thermal *tz = container_of(work, struct acpi_thermal,
 					       thermal_check_work);
-	acpi_thermal_check(tz);
+
+	if (!tz->tz_enabled)
+		return;
+	/*
+	 * In general, it is not sufficient to check the pending bit, because
+	 * subsequent instances of this function may be queued after one of them
+	 * has started running (e.g. if _TMP sleeps).  Avoid bailing out if just
+	 * one of them is running, though, because it may have done the actual
+	 * check some time ago, so allow at least one of them to block on the
+	 * mutex while another one is running the update.
+	 */
+	if (!atomic_add_unless(&tz->thermal_check_count, -1, 1))
+		return;
+
+	mutex_lock(&tz->thermal_check_lock);
+
+	thermal_zone_device_update(tz->thermal_zone);
+
+	atomic_inc(&tz->thermal_check_count);
+
+	mutex_unlock(&tz->thermal_check_lock);
 }
 
 static int acpi_thermal_add(struct acpi_device *device)
@@ -1102,6 +1122,8 @@ static int acpi_thermal_add(struct acpi_device *device)
 	if (result)
 		goto free_memory;
 
+	atomic_set(&tz->thermal_check_count, 3);
+	mutex_init(&tz->thermal_check_lock);
 	INIT_WORK(&tz->thermal_check_work, acpi_thermal_check_fn);
 
 	pr_info(PREFIX "%s [%s] (%ld C)\n", acpi_device_name(device),
@@ -1167,7 +1189,7 @@ static int acpi_thermal_resume(struct device *dev)
 		tz->state.active |= tz->trips.active[i].flags.enabled;
 	}
 
-	queue_work(acpi_thermal_pm_queue, &tz->thermal_check_work);
+	acpi_queue_thermal_check(tz);
 
 	return AE_OK;
 }
-- 
2.30.0

