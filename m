Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BE420184B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbgFSOf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733232AbgFSOfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:35:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D332070A;
        Fri, 19 Jun 2020 14:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577352;
        bh=ayLni4/P+01ZYl2fLDC19mdOJ6KXxyXKGb7V2wxH+Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfznyuc7gZWH7ugceu/U+MWzJWgqxxbOEibTFa2L2X9Hw1cU27XE9h+UW7KEWVkTq
         GYj+w73W1YPVAb/NC7+2BwhgEFRjBYx50eJIq8v9TMfRYG8FPwSxptcCVoXO/zdWHe
         DzQpWrjUk8D3LS4paqypYRXZReaHe1hlgH3OkvC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        youling257@gmail.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 017/101] ACPI: PM: Avoid using power resources if there are none for D0
Date:   Fri, 19 Jun 2020 16:32:06 +0200
Message-Id: <20200619141614.900911019@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 956ad9d98b73f59e442cc119c98ba1e04e94fe6d upstream.

As recently reported, some platforms provide a list of power
resources for device power state D3hot, through the _PR3 object,
but they do not provide a list of power resources for device power
state D0.

Among other things, this causes acpi_device_get_power() to return
D3hot as the current state of the device in question if all of the
D3hot power resources are "on", because it sees the power_resources
flag set and calls acpi_power_get_inferred_state() which finds that
D3hot is the shallowest power state with all of the associated power
resources turned "on", so that's what it returns.  Moreover, that
value takes precedence over the acpi_dev_pm_explicit_get() return
value, because it means a deeper power state.  The device may very
well be in D0 physically at that point, however.

Moreover, the presence of _PR3 without _PR0 for a given device
means that only one D3-level power state can be supported by it.
Namely, because there are no power resources to turn "off" when
transitioning the device from D0 into D3cold (which should be
supported since _PR3 is present), the evaluation of _PS3 should
be sufficient to put it straight into D3cold, but this means that
the effect of turning "on" the _PR3 power resources is unclear,
so it is better to avoid doing that altogether.  Consequently,
there is no practical way do distinguish D3cold from D3hot for
the device in question and the power states of it can be labeled
so that D3hot is the deepest supported one (and Linux assumes
that putting a device into D3hot via ACPI may cause power to be
removed from it anyway, for legacy reasons).

To work around the problem described above modify the ACPI
enumeration of devices so that power resources are only used
for device power management if the list of D0 power resources
is not empty and make it mart D3cold as supported only if that
is the case and the D3hot list of power resources is not empty
too.

Fixes: ef85bdbec444 ("ACPI / scan: Consolidate extraction of power resources lists")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=205057
Link: https://lore.kernel.org/linux-acpi/20200603194659.185757-1-hdegoede@redhat.com/
Reported-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: youling257@gmail.com
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |    2 +-
 drivers/acpi/scan.c      |   28 +++++++++++++++++++---------
 2 files changed, 20 insertions(+), 10 deletions(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -170,7 +170,7 @@ int acpi_device_set_power(struct acpi_de
 		 * possibly drop references to the power resources in use.
 		 */
 		state = ACPI_STATE_D3_HOT;
-		/* If _PR3 is not available, use D3hot as the target state. */
+		/* If D3cold is not supported, use D3hot as the target state. */
 		if (!device->power.states[ACPI_STATE_D3_COLD].flags.valid)
 			target_state = state;
 	} else if (!device->power.states[state].flags.valid) {
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -907,12 +907,9 @@ static void acpi_bus_init_power_state(st
 
 		if (buffer.length && package
 		    && package->type == ACPI_TYPE_PACKAGE
-		    && package->package.count) {
-			int err = acpi_extract_power_resources(package, 0,
-							       &ps->resources);
-			if (!err)
-				device->power.flags.power_resources = 1;
-		}
+		    && package->package.count)
+			acpi_extract_power_resources(package, 0, &ps->resources);
+
 		ACPI_FREE(buffer.pointer);
 	}
 
@@ -959,14 +956,27 @@ static void acpi_bus_get_power_flags(str
 		acpi_bus_init_power_state(device, i);
 
 	INIT_LIST_HEAD(&device->power.states[ACPI_STATE_D3_COLD].resources);
-	if (!list_empty(&device->power.states[ACPI_STATE_D3_HOT].resources))
-		device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
 
-	/* Set defaults for D0 and D3hot states (always valid) */
+	/* Set the defaults for D0 and D3hot (always supported). */
 	device->power.states[ACPI_STATE_D0].flags.valid = 1;
 	device->power.states[ACPI_STATE_D0].power = 100;
 	device->power.states[ACPI_STATE_D3_HOT].flags.valid = 1;
 
+	/*
+	 * Use power resources only if the D0 list of them is populated, because
+	 * some platforms may provide _PR3 only to indicate D3cold support and
+	 * in those cases the power resources list returned by it may be bogus.
+	 */
+	if (!list_empty(&device->power.states[ACPI_STATE_D0].resources)) {
+		device->power.flags.power_resources = 1;
+		/*
+		 * D3cold is supported if the D3hot list of power resources is
+		 * not empty.
+		 */
+		if (!list_empty(&device->power.states[ACPI_STATE_D3_HOT].resources))
+			device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
+	}
+
 	if (acpi_bus_init_power(device))
 		device->flags.power_manageable = 0;
 }


