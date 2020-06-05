Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE51EF9F0
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFEOGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:06:32 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:47318 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgFEOGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 10:06:32 -0400
Received: from 89-64-83-87.dynamic.chello.pl (89.64.83.87) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.415)
 id cde6d4786e60f564; Fri, 5 Jun 2020 16:06:29 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     rafael.j.wysocki@intel.com, stable@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Ira Weiny <ira.weiny@intel.com>,
        James Morse <james.morse@arm.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: [RFT][PATCH] ACPI: OSL: Use rwlock instead of RCU for memory management
Date:   Fri, 05 Jun 2020 16:06:28 +0200
Message-ID: <2643462.teTRrieJB7@kreacher>
In-Reply-To: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: [PATCH] ACPI: OSL: Use rwlock instead of RCU for memory management

The ACPI OS layer uses RCU to protect the list of ACPI memory
mappings from being walked while it is updated.  Among other
situations, that list can be walked in non-NMI interrupt context,
so using a sleeping lock to protect it is not an option.

However, performance issues related to the RCU usage in there
appear, as described by Dan Williams:

"Recently a performance problem was reported for a process invoking
a non-trival ASL program. The method call in this case ends up
repetitively triggering a call path like:

    acpi_ex_store
    acpi_ex_store_object_to_node
    acpi_ex_write_data_to_field
    acpi_ex_insert_into_field
    acpi_ex_write_with_update_rule
    acpi_ex_field_datum_io
    acpi_ex_access_region
    acpi_ev_address_space_dispatch
    acpi_ex_system_memory_space_handler
    acpi_os_map_cleanup.part.14
    _synchronize_rcu_expedited.constprop.89
    schedule

The end result of frequent synchronize_rcu_expedited() invocation is
tiny sub-millisecond spurts of execution where the scheduler freely
migrates this apparently sleepy task. The overhead of frequent
scheduler invocation multiplies the execution time by a factor
of 2-3X."

In order to avoid these issues, replace the RCU in the ACPI OS
layer by an rwlock.

That rwlock should not be frequently contended, so the performance
impact of it is not expected to be significant.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Hi Dan,

This is a possible fix for the ACPI OSL RCU-related performance issues, but
can you please arrange for the testing of it on the affected systems?

Cheers!

---
 drivers/acpi/osl.c |   50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/acpi/osl.c
===================================================================
--- linux-pm.orig/drivers/acpi/osl.c
+++ linux-pm/drivers/acpi/osl.c
@@ -81,8 +81,8 @@ struct acpi_ioremap {
 };
 
 static LIST_HEAD(acpi_ioremaps);
+static DEFINE_RWLOCK(acpi_ioremaps_list_lock);
 static DEFINE_MUTEX(acpi_ioremap_lock);
-#define acpi_ioremap_lock_held() lock_is_held(&acpi_ioremap_lock.dep_map)
 
 static void __init acpi_request_region (struct acpi_generic_address *gas,
 	unsigned int length, char *desc)
@@ -214,13 +214,13 @@ acpi_physical_address __init acpi_os_get
 	return pa;
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+/* Must be called with 'acpi_ioremap_lock' or 'acpi_ioremaps_list_lock' held. */
 static struct acpi_ioremap *
 acpi_map_lookup(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
+	list_for_each_entry(map, &acpi_ioremaps, list)
 		if (map->phys <= phys &&
 		    phys + size <= map->phys + map->size)
 			return map;
@@ -228,7 +228,7 @@ acpi_map_lookup(acpi_physical_address ph
 	return NULL;
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+/* Must be called with 'acpi_ioremap_lock' or 'acpi_ioremaps_list_lock' held. */
 static void __iomem *
 acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
 {
@@ -257,13 +257,13 @@ void __iomem *acpi_os_get_iomem(acpi_phy
 }
 EXPORT_SYMBOL_GPL(acpi_os_get_iomem);
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+/* Must be called with 'acpi_ioremap_lock' or 'acpi_ioremaps_list_lock' held. */
 static struct acpi_ioremap *
 acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
+	list_for_each_entry(map, &acpi_ioremaps, list)
 		if (map->virt <= virt &&
 		    virt + size <= map->virt + map->size)
 			return map;
@@ -360,7 +360,11 @@ void __iomem __ref
 	map->size = pg_sz;
 	map->refcount = 1;
 
-	list_add_tail_rcu(&map->list, &acpi_ioremaps);
+	write_lock_irq(&acpi_ioremaps_list_lock);
+
+	list_add_tail(&map->list, &acpi_ioremaps);
+
+	write_unlock_irq(&acpi_ioremaps_list_lock);
 
 out:
 	mutex_unlock(&acpi_ioremap_lock);
@@ -379,14 +383,18 @@ static unsigned long acpi_os_drop_map_re
 {
 	unsigned long refcount = --map->refcount;
 
-	if (!refcount)
-		list_del_rcu(&map->list);
+	if (!refcount) {
+		write_lock_irq(&acpi_ioremaps_list_lock);
+
+		list_del(&map->list);
+
+		write_unlock_irq(&acpi_ioremaps_list_lock);
+	}
 	return refcount;
 }
 
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
-	synchronize_rcu_expedited();
 	acpi_unmap(map->phys, map->virt);
 	kfree(map);
 }
@@ -704,18 +712,23 @@ acpi_status
 acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 {
 	void __iomem *virt_addr;
+	unsigned long flags;
 	unsigned int size = width / 8;
 	bool unmap = false;
 	u64 dummy;
 	int error;
 
-	rcu_read_lock();
+	read_lock_irqsave(&acpi_ioremaps_list_lock, flags);
+
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	if (!virt_addr) {
-		rcu_read_unlock();
+
+		read_unlock_irqrestore(&acpi_ioremaps_list_lock, flags);
+
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
+
 		unmap = true;
 	}
 
@@ -728,7 +741,7 @@ acpi_os_read_memory(acpi_physical_addres
 	if (unmap)
 		iounmap(virt_addr);
 	else
-		rcu_read_unlock();
+		read_unlock_irqrestore(&acpi_ioremaps_list_lock, flags);
 
 	return AE_OK;
 }
@@ -737,16 +750,21 @@ acpi_status
 acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 {
 	void __iomem *virt_addr;
+	unsigned long flags;
 	unsigned int size = width / 8;
 	bool unmap = false;
 
-	rcu_read_lock();
+	read_lock_irqsave(&acpi_ioremaps_list_lock, flags);
+
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	if (!virt_addr) {
-		rcu_read_unlock();
+
+		read_unlock_irqrestore(&acpi_ioremaps_list_lock, flags);
+
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
+
 		unmap = true;
 	}
 
@@ -770,7 +788,7 @@ acpi_os_write_memory(acpi_physical_addre
 	if (unmap)
 		iounmap(virt_addr);
 	else
-		rcu_read_unlock();
+		read_unlock_irqrestore(&acpi_ioremaps_list_lock, flags);
 
 	return AE_OK;
 }



