Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77CD311472
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhBEWGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232877AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 917E96509C;
        Fri,  5 Feb 2021 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534439;
        bh=+PyZEGb6aMwGauSh5wIsr1t1iVCRnCmyuCc50lu5u8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bB8BoygV/mC89O9I1bCwR08LQlzBD/jlwWIobunqvGgw1dFKzJk/3AnYNtORwAlIF
         uXV45bS6Q1p6HwuynN5/m+TfbaRgHAK/9kiRYA81z7YJBEo2AiMUPpMO02vbyAhFQ8
         sUWm1CPs1plMSsxLHOdTgtvFzf0r1RGnLRNhULq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Berman <stephen.berman@gmx.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4.19 03/17] ACPI: thermal: Do not call acpi_thermal_check() directly
Date:   Fri,  5 Feb 2021 15:07:57 +0100
Message-Id: <20210205140649.954666531@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 81b704d3e4674e09781d331df73d76675d5ad8cb upstream.

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
[bigeasy: Backported to v5.4.y]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/thermal.c |   55 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 17 deletions(-)

--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -188,6 +188,8 @@ struct acpi_thermal {
 	int tz_enabled;
 	int kelvin_offset;
 	struct work_struct thermal_check_work;
+	struct mutex thermal_check_lock;
+	refcount_t thermal_check_count;
 };
 
 /* --------------------------------------------------------------------------
@@ -513,17 +515,6 @@ static int acpi_thermal_get_trip_points(
 	return 0;
 }
 
-static void acpi_thermal_check(void *data)
-{
-	struct acpi_thermal *tz = data;
-
-	if (!tz->tz_enabled)
-		return;
-
-	thermal_zone_device_update(tz->thermal_zone,
-				   THERMAL_EVENT_UNSPECIFIED);
-}
-
 /* sys I/F for generic thermal sysfs support */
 
 static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
@@ -557,6 +548,8 @@ static int thermal_get_mode(struct therm
 	return 0;
 }
 
+static void acpi_thermal_check_fn(struct work_struct *work);
+
 static int thermal_set_mode(struct thermal_zone_device *thermal,
 				enum thermal_device_mode mode)
 {
@@ -582,7 +575,7 @@ static int thermal_set_mode(struct therm
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			"%s kernel ACPI thermal control\n",
 			tz->tz_enabled ? "Enable" : "Disable"));
-		acpi_thermal_check(tz);
+		acpi_thermal_check_fn(&tz->thermal_check_work);
 	}
 	return 0;
 }
@@ -951,6 +944,12 @@ static void acpi_thermal_unregister_ther
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
@@ -961,17 +960,17 @@ static void acpi_thermal_notify(struct a
 
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
@@ -1071,7 +1070,27 @@ static void acpi_thermal_check_fn(struct
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
+	if (!refcount_dec_not_one(&tz->thermal_check_count))
+		return;
+
+	mutex_lock(&tz->thermal_check_lock);
+
+	thermal_zone_device_update(tz->thermal_zone, THERMAL_EVENT_UNSPECIFIED);
+
+	refcount_inc(&tz->thermal_check_count);
+
+	mutex_unlock(&tz->thermal_check_lock);
 }
 
 static int acpi_thermal_add(struct acpi_device *device)
@@ -1103,6 +1122,8 @@ static int acpi_thermal_add(struct acpi_
 	if (result)
 		goto free_memory;
 
+	refcount_set(&tz->thermal_check_count, 3);
+	mutex_init(&tz->thermal_check_lock);
 	INIT_WORK(&tz->thermal_check_work, acpi_thermal_check_fn);
 
 	pr_info(PREFIX "%s [%s] (%ld C)\n", acpi_device_name(device),
@@ -1168,7 +1189,7 @@ static int acpi_thermal_resume(struct de
 		tz->state.active |= tz->trips.active[i].flags.enabled;
 	}
 
-	queue_work(acpi_thermal_pm_queue, &tz->thermal_check_work);
+	acpi_queue_thermal_check(tz);
 
 	return AE_OK;
 }


