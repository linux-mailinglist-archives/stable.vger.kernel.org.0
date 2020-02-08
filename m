Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9860215661C
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgBHScD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34650 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727949AbgBHS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:49 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003jT-NK; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CW1-6o; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Dmitry Safonov" <0x7f454c46@gmail.com>,
        "Francesco Ruggeri" <fruggeri@arista.com>
Date:   Sat, 08 Feb 2020 18:21:07 +0000
Message-ID: <lsq.1581185941.37930925@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 128/148] ACPI: OSL: only free map once in osl.c
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

From: Francesco Ruggeri <fruggeri@arista.com>

commit 833a426cc471b6088011b3d67f1dc4e147614647 upstream.

acpi_os_map_cleanup checks map->refcount outside of acpi_ioremap_lock
before freeing the map. This creates a race condition the can result
in the map being freed more than once.
A panic can be caused by running

for ((i=0; i<10; i++))
do
        for ((j=0; j<100000; j++))
        do
                cat /sys/firmware/acpi/tables/data/BERT >/dev/null
        done &
done

This patch makes sure that only the process that drops the reference
to 0 does the freeing.

Fixes: b7c1fadd6c2e ("ACPI: Do not use krefs under a mutex in osl.c")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/osl.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -416,24 +416,27 @@ acpi_os_map_memory(acpi_physical_address
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
-static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
+/* Must be called with mutex_lock(&acpi_ioremap_lock) */
+static unsigned long acpi_os_drop_map_ref(struct acpi_ioremap *map)
 {
-	if (!--map->refcount)
+	unsigned long refcount = --map->refcount;
+
+	if (!refcount)
 		list_del_rcu(&map->list);
+	return refcount;
 }
 
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
-	if (!map->refcount) {
-		synchronize_rcu_expedited();
-		acpi_unmap(map->phys, map->virt);
-		kfree(map);
-	}
+	synchronize_rcu_expedited();
+	acpi_unmap(map->phys, map->virt);
+	kfree(map);
 }
 
 void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
+	unsigned long refcount;
 
 	if (!acpi_gbl_permanent_mmap) {
 		__acpi_unmap_table(virt, size);
@@ -447,10 +450,11 @@ void __ref acpi_os_unmap_iomem(void __io
 		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	refcount = acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	acpi_os_map_cleanup(map);
+	if (!refcount)
+		acpi_os_map_cleanup(map);
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
 
@@ -491,6 +495,7 @@ void acpi_os_unmap_generic_address(struc
 {
 	u64 addr;
 	struct acpi_ioremap *map;
+	unsigned long refcount;
 
 	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return;
@@ -506,10 +511,11 @@ void acpi_os_unmap_generic_address(struc
 		mutex_unlock(&acpi_ioremap_lock);
 		return;
 	}
-	acpi_os_drop_map_ref(map);
+	refcount = acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	acpi_os_map_cleanup(map);
+	if (!refcount)
+		acpi_os_map_cleanup(map);
 }
 EXPORT_SYMBOL(acpi_os_unmap_generic_address);
 

