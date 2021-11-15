Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210C5451364
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348218AbhKOTu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:50:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245723AbhKOTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9495C63290;
        Mon, 15 Nov 2021 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001611;
        bh=rYISSHylT6l75n8KJIDPA+XngjT7hhBZ+8YlmeCOofc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dlv18tnFOZ6CEMEm+TusznYzwZqRI5T1NIsirj4owDHJfYNTvrjf637nsGFWDYySK
         CnafPUGto96fCP9QqXmtYIkontaQ6osYGHrgaXrMQFijiuHOH0r6RiEJ/23hYBaUD/
         TFqQX4NZcjNzzbjn5k0tQS84qAAxX+TwqNWWVO2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/917] ACPI: scan: Release PM resources blocked by unused objects
Date:   Mon, 15 Nov 2021 17:55:50 +0100
Message-Id: <20211115165437.437740138@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c10383e8ddf4810b9a5c1595404c2724d925a0a6 ]

On some systems the ACPI namespace contains device objects that are
not used in certain configurations of the system.  If they start off
in the D0 power state configuration, they will stay in it until the
system reboots, because of the lack of any mechanism possibly causing
their configuration to change.  If that happens, they may prevent
some power resources from being turned off or generally they may
prevent the platform from getting into the deepest low-power states
thus causing some energy to be wasted.

Address this issue by changing the configuration of unused ACPI
device objects to the D3cold power state one after carrying out
the ACPI-based enumeration of devices.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214091
Link: https://lore.kernel.org/linux-acpi/20211007205126.11769-1-mario.limonciello@amd.com/
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c     | 25 +++++++++++++++++++++++++
 drivers/acpi/internal.h |  1 +
 drivers/acpi/scan.c     |  6 ++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 7a33a6d985f89..1cfafa254e3d4 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -340,3 +340,28 @@ void acpi_device_notify_remove(struct device *dev)
 
 	acpi_unbind_one(dev);
 }
+
+int acpi_dev_turn_off_if_unused(struct device *dev, void *not_used)
+{
+	struct acpi_device *adev = to_acpi_device(dev);
+
+	/*
+	 * Skip device objects with device IDs, because they may be in use even
+	 * if they are not companions of any physical device objects.
+	 */
+	if (adev->pnp.type.hardware_id)
+		return 0;
+
+	mutex_lock(&adev->physical_node_lock);
+
+	/*
+	 * Device objects without device IDs are not in use if they have no
+	 * corresponding physical device objects.
+	 */
+	if (list_empty(&adev->physical_node_list))
+		acpi_device_set_power(adev, ACPI_STATE_D3_COLD);
+
+	mutex_unlock(&adev->physical_node_lock);
+
+	return 0;
+}
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index d91b560e88674..8fbdc172864b0 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -117,6 +117,7 @@ bool acpi_device_is_battery(struct acpi_device *adev);
 bool acpi_device_is_first_physical_node(struct acpi_device *adev,
 					const struct device *dev);
 int acpi_bus_register_early_device(int type);
+int acpi_dev_turn_off_if_unused(struct device *dev, void *not_used);
 
 /* --------------------------------------------------------------------------
                      Device Matching and Notification
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5b54c80b9d32a..770b82483d74d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2559,6 +2559,12 @@ int __init acpi_scan_init(void)
 		}
 	}
 
+	/*
+	 * Make sure that power management resources are not blocked by ACPI
+	 * device objects with no users.
+	 */
+	bus_for_each_dev(&acpi_bus_type, NULL, NULL, acpi_dev_turn_off_if_unused);
+
 	acpi_turn_off_unused_power_resources();
 
 	acpi_scan_initialized = true;
-- 
2.33.0



