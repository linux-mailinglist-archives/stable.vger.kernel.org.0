Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494BA1565E7
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgBHS3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34770 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727966AbgBHS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:49 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003jW-OG; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CW6-9k; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vamshi K Sthambamkadi" <vamshi.k.sthambamkadi@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date:   Sat, 08 Feb 2020 18:21:08 +0000
Message-ID: <lsq.1581185941.716147760@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 129/148] ACPI: bus: Fix NULL pointer check in
 acpi_bus_get_private_data()
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

commit 627ead724eff33673597216f5020b72118827de4 upstream.

kmemleak reported backtrace:
    [<bbee0454>] kmem_cache_alloc_trace+0x128/0x260
    [<6677f215>] i2c_acpi_install_space_handler+0x4b/0xe0
    [<1180f4fc>] i2c_register_adapter+0x186/0x400
    [<6083baf7>] i2c_add_adapter+0x4e/0x70
    [<a3ddf966>] intel_gmbus_setup+0x1a2/0x2c0 [i915]
    [<84cb69ae>] i915_driver_probe+0x8d8/0x13a0 [i915]
    [<81911d4b>] i915_pci_probe+0x48/0x160 [i915]
    [<4b159af1>] pci_device_probe+0xdc/0x160
    [<b3c64704>] really_probe+0x1ee/0x450
    [<bc029f5a>] driver_probe_device+0x142/0x1b0
    [<d8829d20>] device_driver_attach+0x49/0x50
    [<de71f045>] __driver_attach+0xc9/0x150
    [<df33ac83>] bus_for_each_dev+0x56/0xa0
    [<80089bba>] driver_attach+0x19/0x20
    [<cc73f583>] bus_add_driver+0x177/0x220
    [<7b29d8c7>] driver_register+0x56/0xf0

In i2c_acpi_remove_space_handler(), a leak occurs whenever the
"data" parameter is initialized to 0 before being passed to
acpi_bus_get_private_data().

This is because the NULL pointer check in acpi_bus_get_private_data()
(condition->if(!*data)) returns EINVAL and, in consequence, memory is
never freed in i2c_acpi_remove_space_handler().

Fix the NULL pointer check in acpi_bus_get_private_data() to follow
the analogous check in acpi_get_data_full().

Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
[ rjw: Subject & changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -154,7 +154,7 @@ int acpi_bus_get_private_data(acpi_handl
 {
 	acpi_status status;
 
-	if (!*data)
+	if (!data)
 		return -EINVAL;
 
 	status = acpi_get_data(handle, acpi_bus_private_data_handler, data);

