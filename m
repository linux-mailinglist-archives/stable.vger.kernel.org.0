Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08647457606
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbhKSRoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237383AbhKSRnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0ACC61279;
        Fri, 19 Nov 2021 17:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343629;
        bh=p/VEF9CdIPgG5NC6emvyur/xGdj1rvEly4YrcM8CVkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwATDcuj6Zz1+RLz2cZSogCgy+35AmeG6blVJY2Y4P0eKqNxDQqkP/hFc4L0Yp/VR
         LuSTD3xfhhUF8h25EQOgGKspyN9ARREojs1e9jaYCAMf79ZffqzxDusCFDpP6P63F0
         qTW/PUVuXuDvitGoI/wo3f5fHrbIIGXZ0c01sk5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kyle D. Pelton" <kyle.d.pelton@intel.com>,
        Saranya Gopal <saranya.gopal@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 20/20] Revert "ACPI: scan: Release PM resources blocked by unused objects"
Date:   Fri, 19 Nov 2021 18:39:38 +0100
Message-Id: <20211119171445.308946411@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
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
@@ -340,28 +340,3 @@ void acpi_device_notify_remove(struct de
 
 	acpi_unbind_one(dev);
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
@@ -2559,12 +2559,6 @@ int __init acpi_scan_init(void)
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


