Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B95C35402A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbhDEJQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240659AbhDEJQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9F2761394;
        Mon,  5 Apr 2021 09:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614162;
        bh=tjAx589bEBE8kYkGljzJjJZgmpAQkko+RWmcPds6/R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5zEVdHYzGnfw0i6kXya0n9lKMLfddw9rB3jdiBUs+PUbHqoxhchNjE4iCxpTK37V
         /6nHNEYdwJXaOUy2LBL0zyVMzlRZydoA2TNXwlQVbrkq5TUYLI+9kB1dZBtzd7Awym
         RTgCV5RiCfc4U7vFVdl0WASeBftxMjx8hksMQuFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 070/152] ACPI: scan: Fix _STA getting called on devices with unmet dependencies
Date:   Mon,  5 Apr 2021 10:53:39 +0200
Message-Id: <20210405085036.546779290@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 3e759425cc3cf9a43392309819d34c65a3644c59 upstream.

Commit 71da201f38df ("ACPI: scan: Defer enumeration of devices with
_DEP lists") dropped the following 2 lines from acpi_init_device_object():

	/* Assume there are unmet deps until acpi_device_dep_initialize() runs */
	device->dep_unmet = 1;

Leaving the initial value of dep_unmet at the 0 from the kzalloc(). This
causes the acpi_bus_get_status() call in acpi_add_single_object() to
actually call _STA, even though there maybe unmet deps, leading to errors
like these:

[    0.123579] ACPI Error: No handler for Region [ECRM] (00000000ba9edc4c)
               [GenericSerialBus] (20170831/evregion-166)
[    0.123601] ACPI Error: Region GenericSerialBus (ID=9) has no handler
               (20170831/exfldio-299)
[    0.123618] ACPI Error: Method parse/execution failed
               \_SB.I2C1.BAT1._STA, AE_NOT_EXIST (20170831/psparse-550)

Fix this by re-adding the dep_unmet = 1 initialization to
acpi_init_device_object() and modifying acpi_bus_check_add() to make sure
that dep_unmet always gets setup there, overriding the initial 1 value.

This re-fixes the issue initially fixed by
commit 63347db0affa ("ACPI / scan: Use acpi_bus_get_status() to initialize
ACPI_TYPE_DEVICE devs"), which introduced the removed
"device->dep_unmet = 1;" statement.

This issue was noticed; and the fix tested on a Dell Venue 10 Pro 5055.

Fixes: 71da201f38df ("ACPI: scan: Defer enumeration of devices with _DEP lists")
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: 5.11+ <stable@vger.kernel.org> # 5.11+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/scan.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1669,6 +1669,8 @@ void acpi_init_device_object(struct acpi
 	device_initialize(&device->dev);
 	dev_set_uevent_suppress(&device->dev, true);
 	acpi_init_coherency(device);
+	/* Assume there are unmet deps to start with. */
+	device->dep_unmet = 1;
 }
 
 void acpi_device_add_finalize(struct acpi_device *device)
@@ -1934,6 +1936,8 @@ static void acpi_scan_dep_init(struct ac
 {
 	struct acpi_dep_data *dep;
 
+	adev->dep_unmet = 0;
+
 	mutex_lock(&acpi_dep_list_lock);
 
 	list_for_each_entry(dep, &acpi_dep_list, node) {
@@ -1981,7 +1985,13 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_CTRL_DEPTH;
 
 	acpi_scan_init_hotplug(device);
-	if (!check_dep)
+	/*
+	 * If check_dep is true at this point, the device has no dependencies,
+	 * or the creation of the device object would have been postponed above.
+	 */
+	if (check_dep)
+		device->dep_unmet = 0;
+	else
 		acpi_scan_dep_init(device);
 
 out:


