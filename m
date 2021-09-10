Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E055406B63
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhIJM3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:29:47 -0400
Received: from foss.arm.com ([217.140.110.172]:56226 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhIJM3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:29:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A6E36D;
        Fri, 10 Sep 2021 05:28:35 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 083773F5A1;
        Fri, 10 Sep 2021 05:28:30 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Will Deacon <will@kernel.org>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        Jia He <justin.he@arm.com>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH] Revert "ACPI: Add memory semantics to acpi_os_map_memory()"
Date:   Fri, 10 Sep 2021 20:28:20 +0800
Message-Id: <20210910122820.26886-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 437b38c51162f8b87beb28a833c4d5dc85fa864e.

After this commit, a boot panic is alway hit on an Ampere EMAG server
with call trace as follows:
 Internal error: synchronous external abort: 96000410 [#1] SMP
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0+ #462
 Hardware name: MiTAC RAPTOR EV-883832-X3-0001/RAPTOR, BIOS 0.14 02/22/2019
 pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[...snip...]
 Call trace:
  acpi_ex_system_memory_space_handler+0x26c/0x2c8
  acpi_ev_address_space_dispatch+0x228/0x2c4
  acpi_ex_access_region+0x114/0x268
  acpi_ex_field_datum_io+0x128/0x1b8
  acpi_ex_extract_from_field+0x14c/0x2ac
  acpi_ex_read_data_from_field+0x190/0x1b8
  acpi_ex_resolve_node_to_value+0x1ec/0x288
  acpi_ex_resolve_to_value+0x250/0x274
  acpi_ds_evaluate_name_path+0xac/0x124
  acpi_ds_exec_end_op+0x90/0x410
  acpi_ps_parse_loop+0x4ac/0x5d8
  acpi_ps_parse_aml+0xe0/0x2c8
  acpi_ps_execute_method+0x19c/0x1ac
  acpi_ns_evaluate+0x1f8/0x26c
  acpi_ns_init_one_device+0x104/0x140
  acpi_ns_walk_namespace+0x158/0x1d0
  acpi_ns_initialize_devices+0x194/0x218
  acpi_initialize_objects+0x48/0x50
  acpi_init+0xe0/0x498

From the debugging, we're mapping something which is *not* described by
the EFI memory map, but *does* want PROT_NORMAL_NC.

Hence just revert it before everything is clear.

Fixes: 437b38c51162 ("ACPI: Add memory semantics to acpi_os_map_memory()")
Cc: stable@vger.kernel.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/include/asm/acpi.h |  3 ---
 arch/arm64/kernel/acpi.c      | 19 +++----------------
 drivers/acpi/osl.c            | 23 +++++++----------------
 include/acpi/acpi_io.h        |  8 --------
 4 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 7535dc7cc5aa..bd68e1b7f29f 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -50,9 +50,6 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
 void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size);
 #define acpi_os_ioremap acpi_os_ioremap
 
-void __iomem *acpi_os_memmap(acpi_physical_address phys, acpi_size size);
-#define acpi_os_memmap acpi_os_memmap
-
 typedef u64 phys_cpuid_t;
 #define PHYS_CPUID_INVALID INVALID_HWID
 
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 1c9c2f7a1c04..f3851724fe35 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -273,8 +273,7 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
 	return __pgprot(PROT_DEVICE_nGnRnE);
 }
 
-static void __iomem *__acpi_os_ioremap(acpi_physical_address phys,
-				       acpi_size size, bool memory)
+void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 {
 	efi_memory_desc_t *md, *region = NULL;
 	pgprot_t prot;
@@ -300,11 +299,9 @@ static void __iomem *__acpi_os_ioremap(acpi_physical_address phys,
 	 * It is fine for AML to remap regions that are not represented in the
 	 * EFI memory map at all, as it only describes normal memory, and MMIO
 	 * regions that require a virtual mapping to make them accessible to
-	 * the EFI runtime services. Determine the region default
-	 * attributes by checking the requested memory semantics.
+	 * the EFI runtime services.
 	 */
-	prot = memory ? __pgprot(PROT_NORMAL_NC) :
-			__pgprot(PROT_DEVICE_nGnRnE);
+	prot = __pgprot(PROT_DEVICE_nGnRnE);
 	if (region) {
 		switch (region->type) {
 		case EFI_LOADER_CODE:
@@ -364,16 +361,6 @@ static void __iomem *__acpi_os_ioremap(acpi_physical_address phys,
 	return __ioremap(phys, size, prot);
 }
 
-void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
-{
-	return __acpi_os_ioremap(phys, size, false);
-}
-
-void __iomem *acpi_os_memmap(acpi_physical_address phys, acpi_size size)
-{
-	return __acpi_os_ioremap(phys, size, true);
-}
-
 /*
  * Claim Synchronous External Aborts as a firmware first notification.
  *
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index a43f1521efe6..45c5c0e45e33 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -284,8 +284,7 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 #define should_use_kmap(pfn)   page_is_ram(pfn)
 #endif
 
-static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz,
-			      bool memory)
+static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz)
 {
 	unsigned long pfn;
 
@@ -295,8 +294,7 @@ static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz,
 			return NULL;
 		return (void __iomem __force *)kmap(pfn_to_page(pfn));
 	} else
-		return memory ? acpi_os_memmap(pg_off, pg_sz) :
-				acpi_os_ioremap(pg_off, pg_sz);
+		return acpi_os_ioremap(pg_off, pg_sz);
 }
 
 static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
@@ -311,10 +309,9 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
 }
 
 /**
- * __acpi_os_map_iomem - Get a virtual address for a given physical address range.
+ * acpi_os_map_iomem - Get a virtual address for a given physical address range.
  * @phys: Start of the physical address range to map.
  * @size: Size of the physical address range to map.
- * @memory: true if remapping memory, false if IO
  *
  * Look up the given physical address range in the list of existing ACPI memory
  * mappings.  If found, get a reference to it and return a pointer to it (its
@@ -324,8 +321,8 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
  * During early init (when acpi_permanent_mmap has not been set yet) this
  * routine simply calls __acpi_map_table() to get the job done.
  */
-static void __iomem __ref
-*__acpi_os_map_iomem(acpi_physical_address phys, acpi_size size, bool memory)
+void __iomem __ref
+*acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
 	void __iomem *virt;
@@ -356,7 +353,7 @@ static void __iomem __ref
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
-	virt = acpi_map(phys, size, memory);
+	virt = acpi_map(phys, size);
 	if (!virt) {
 		mutex_unlock(&acpi_ioremap_lock);
 		kfree(map);
@@ -375,17 +372,11 @@ static void __iomem __ref
 	mutex_unlock(&acpi_ioremap_lock);
 	return map->virt + (phys - map->phys);
 }
-
-void __iomem *__ref
-acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
-{
-	return __acpi_os_map_iomem(phys, size, false);
-}
 EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
 
 void *__ref acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 {
-	return (void *)__acpi_os_map_iomem(phys, size, true);
+	return (void *)acpi_os_map_iomem(phys, size);
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
diff --git a/include/acpi/acpi_io.h b/include/acpi/acpi_io.h
index a0212e67d6f4..027faa8883aa 100644
--- a/include/acpi/acpi_io.h
+++ b/include/acpi/acpi_io.h
@@ -14,14 +14,6 @@ static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
 }
 #endif
 
-#ifndef acpi_os_memmap
-static inline void __iomem *acpi_os_memmap(acpi_physical_address phys,
-					    acpi_size size)
-{
-	return ioremap_cache(phys, size);
-}
-#endif
-
 extern bool acpi_permanent_mmap;
 
 void __iomem __ref
-- 
2.17.1

