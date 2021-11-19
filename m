Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0374575CA
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbhKSRmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237000AbhKSRmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CF960D42;
        Fri, 19 Nov 2021 17:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343549;
        bh=dLXqvsdeFZhQbKqUMBtESRgXIXM3EeR+cShjyKVU3+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egL0oBZngAMs2aNP9WF7arQ67gDLeSFI2CHD2013220avH+H5gmrsRbiZfEiKSTHO
         dRFGsoC2mP+R8mWeTRAtw0k8cisc8D6nY6Z0whlGg7uD/wKG8rMswXFTe4QzNHKvRW
         bhiF/JiMeti33/EMSAz7egL+EKldinOs7lCL3EAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kyle D. Pelton" <kyle.d.pelton@intel.com>,
        Saranya Gopal <saranya.gopal@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.14 15/15] Revert "ACPI: scan: Release PM resources blocked by unused objects"
Date:   Fri, 19 Nov 2021 18:38:48 +0100
Message-Id: <20211119171444.204995916@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
References: <20211119171443.724340448@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 3b2b49e6dfdcf423506a771bf44cee842596351a upstream.

Revert commit c10383e8ddf4 ("ACPI: scan: Release PM resources blocked
by unused objects"), because it causes boot issues to appear on some
platforms.

Reported-by: Kyle D. Pelton <kyle.d.pelton@intel.com>
Reported-by: Saranya Gopal <saranya.gopal@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/glue.c     |   25 -------------------------
 drivers/acpi/internal.h |    1 -
 drivers/acpi/scan.c     |    6 ------
 3 files changed, 32 deletions(-)

--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -363,28 +363,3 @@ int acpi_platform_notify(struct device *
 	}
 	return 0;
 }
-
-int acpi_dev_turn_off_if_unused(struct device *dev, void *not_used)
-{
-	struct acpi_device *adev = to_acpi_device(dev);
-
-	/*
-	 * Skip device objects with device IDs, because they may be in use even
-	 * if they are not companions of any physical device objects.
-	 */
-	if (adev->pnp.type.hardware_id)
-		return 0;
-
-	mutex_lock(&adev->physical_node_lock);
-
-	/*
-	 * Device objects without device IDs are not in use if they have no
-	 * corresponding physical device objects.
-	 */
-	if (list_empty(&adev->physical_node_list))
-		acpi_device_set_power(adev, ACPI_STATE_D3_COLD);
-
-	mutex_unlock(&adev->physical_node_lock);
-
-	return 0;
-}
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -117,7 +117,6 @@ bool acpi_device_is_battery(struct acpi_
 bool acpi_device_is_first_physical_node(struct acpi_device *adev,
 					const struct device *dev);
 int acpi_bus_register_early_device(int type);
-int acpi_dev_turn_off_if_unused(struct device *dev, void *not_used);
 
 /* --------------------------------------------------------------------------
                      Device Matching and Notification
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2560,12 +2560,6 @@ int __init acpi_scan_init(void)
 		}
 	}
 
-	/*
-	 * Make sure that power management resources are not blocked by ACPI
-	 * device objects with no users.
-	 */
-	bus_for_each_dev(&acpi_bus_type, NULL, NULL, acpi_dev_turn_off_if_unused);
-
 	acpi_turn_off_unused_power_resources();
 
 	acpi_scan_initialized = true;


