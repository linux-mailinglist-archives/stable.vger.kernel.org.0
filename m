Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067856DB656
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 00:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjDGWNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 18:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDGWNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 18:13:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CC619A7;
        Fri,  7 Apr 2023 15:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE1CC65003;
        Fri,  7 Apr 2023 22:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D9AC433EF;
        Fri,  7 Apr 2023 22:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680905615;
        bh=ajSz8hZFBAeipLeWBNh5PmBUtovCfoFfBZ9GhpJFiJs=;
        h=Date:To:From:Subject:From;
        b=BpKjiNtvR4M6BD8YoPR/0aXeMMxE0/uQ5y45FZ41r84VZsMOMVpdzc8UpjctIY2OD
         od6aetuL7ajZHy09oVbpESAk9dJZY1zrY9lFaYh7omUXGtJZexPigy7dOCnX1vYZ/w
         UJkEPKkDQTnxdeqXpa3WPR6yvebfNd9ngIMY7Vnw=
Date:   Fri, 07 Apr 2023 15:13:34 -0700
To:     mm-commits@vger.kernel.org, tsahu@linux.ibm.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        joao.m.martins@oracle.com, jane.chu@oracle.com,
        dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices.patch added to mm-hotfixes-unstable branch
Message-Id: <20230407221335.38D9AC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmemmap/devdax: fix kernel crash when probing devdax devices
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/vmemmap/devdax: fix kernel crash when probing devdax devices
Date: Fri, 7 Apr 2023 17:53:53 +0530

commit c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound
pages") added support for using optimized vmmemap for devdax devices.  But
how vmemmap mappings are created are architecture specific.  For example,
powerpc with hash translation doesn't have vmemmap mappings in init_mm
page table instead they are bolted table entries in the hardware page
table

vmemmap_populate_compound_pages() used by vmemmap optimization code is not
aware of these architecture-specific mapping.  Hence allow architecture to
opt for this feature.  I selected architectures supporting
HUGETLB_PAGE_OPTIMIZE_VMEMMAP option as also supporting this feature.  I
added vmemmap_can_optimize() even though page_vmemmap_nr(pgmap) > 1 check
should filter architecture not supporting this.  IMHO that brings clarity
to the code where we are populating vmemmap.

This patch fixes the below crash on ppc64.

BUG: Unable to handle kernel data access on write at 0xc00c000100400038
Faulting instruction address: 0xc000000001269d90
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in:
CPU: 7 PID: 1 Comm: swapper/0 Not tainted 6.3.0-rc5-150500.34-default+ #2 5c90a668b6bbd142599890245c2fb5de19d7d28a
Hardware name: IBM,9009-42G POWER9 (raw) 0x4e0202 0xf000005 of:IBM,FW950.40 (VL950_099) hv:phyp pSeries
NIP:  c000000001269d90 LR: c0000000004c57d4 CTR: 0000000000000000
REGS: c000000003632c30 TRAP: 0300   Not tainted  (6.3.0-rc5-150500.34-default+)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24842228  XER: 00000000
CFAR: c0000000004c57d0 DAR: c00c000100400038 DSISR: 42000000 IRQMASK: 0
....
NIP [c000000001269d90] __init_single_page.isra.74+0x14/0x4c
LR [c0000000004c57d4] __init_zone_device_page+0x44/0xd0
Call Trace:
[c000000003632ed0] [c000000003632f60] 0xc000000003632f60 (unreliable)
[c000000003632f10] [c0000000004c5ca0] memmap_init_zone_device+0x170/0x250
[c000000003632fe0] [c0000000005575f8] memremap_pages+0x2c8/0x7f0
[c0000000036330c0] [c000000000557b5c] devm_memremap_pages+0x3c/0xa0
[c000000003633100] [c000000000d458a8] dev_dax_probe+0x108/0x3e0
[c0000000036331a0] [c000000000d41430] dax_bus_probe+0xb0/0x140
[c0000000036331d0] [c000000000cef27c] really_probe+0x19c/0x520
[c000000003633260] [c000000000cef6b4] __driver_probe_device+0xb4/0x230
[c0000000036332e0] [c000000000cef888] driver_probe_device+0x58/0x120
[c000000003633320] [c000000000cefa6c] __device_attach_driver+0x11c/0x1e0
[c0000000036333a0] [c000000000cebc58] bus_for_each_drv+0xa8/0x130
[c000000003633400] [c000000000ceefcc] __device_attach+0x15c/0x250
[c0000000036334a0] [c000000000ced458] bus_probe_device+0x108/0x110
[c0000000036334f0] [c000000000ce92dc] device_add+0x7fc/0xa10
[c0000000036335b0] [c000000000d447c8] devm_create_dev_dax+0x1d8/0x530
[c000000003633640] [c000000000d46b60] __dax_pmem_probe+0x200/0x270
[c0000000036337b0] [c000000000d46bf0] dax_pmem_probe+0x20/0x70
[c0000000036337d0] [c000000000d2279c] nvdimm_bus_probe+0xac/0x2b0
[c000000003633860] [c000000000cef27c] really_probe+0x19c/0x520
[c0000000036338f0] [c000000000cef6b4] __driver_probe_device+0xb4/0x230
[c000000003633970] [c000000000cef888] driver_probe_device+0x58/0x120
[c0000000036339b0] [c000000000cefd08] __driver_attach+0x1d8/0x240
[c000000003633a30] [c000000000cebb04] bus_for_each_dev+0xb4/0x130
[c000000003633a90] [c000000000cee564] driver_attach+0x34/0x50
[c000000003633ab0] [c000000000ced878] bus_add_driver+0x218/0x300
[c000000003633b40] [c000000000cf1144] driver_register+0xa4/0x1b0
[c000000003633bb0] [c000000000d21a0c] __nd_driver_register+0x5c/0x100
[c000000003633c10] [c00000000206a2e8] dax_pmem_init+0x34/0x48
[c000000003633c30] [c0000000000132d0] do_one_initcall+0x60/0x320
[c000000003633d00] [c0000000020051b0] kernel_init_freeable+0x360/0x400
[c000000003633de0] [c000000000013764] kernel_init+0x34/0x1d0
[c000000003633e50] [c00000000000de14] ret_from_kernel_thread+0x5c/0x64

Link: https://lkml.kernel.org/r/20230407122353.12018-1-aneesh.kumar@linux.ibm.com
Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Tarun Sahu <tsahu@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig     |    1 +
 arch/loongarch/Kconfig |    1 +
 arch/s390/Kconfig      |    1 +
 arch/x86/Kconfig       |    1 +
 drivers/dax/device.c   |    3 ++-
 include/linux/mm.h     |   16 ++++++++++++++++
 mm/Kconfig             |    3 +++
 mm/sparse-vmemmap.c    |    3 +--
 8 files changed, 26 insertions(+), 3 deletions(-)

--- a/arch/arm64/Kconfig~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/arch/arm64/Kconfig
@@ -102,6 +102,7 @@ config ARM64
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
+	select ARCH_WANT_OPTIMIZE_VMEMMAP
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARM_AMBA
--- a/arch/loongarch/Kconfig~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/arch/loongarch/Kconfig
@@ -56,6 +56,7 @@ config LOONGARCH
 	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
+	select ARCH_WANT_OPTIMIZE_VMEMMAP
 	select BUILDTIME_TABLE_SORT
 	select COMMON_CLK
 	select CPU_PM
--- a/arch/s390/Kconfig~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/arch/s390/Kconfig
@@ -127,6 +127,7 @@ config S390
 	select ARCH_WANT_DEFAULT_BPF_JIT
 	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select ARCH_WANT_OPTIMIZE_VMEMMAP
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS2
 	select DMA_OPS if PCI
--- a/arch/x86/Kconfig~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/arch/x86/Kconfig
@@ -127,6 +127,7 @@ config X86
 	select ARCH_WANT_HUGE_PMD_SHARE
 	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP	if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
+	select ARCH_WANT_OPTIMIZE_VMEMMAP	if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select BUILDTIME_TABLE_SORT
--- a/drivers/dax/device.c~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/drivers/dax/device.c
@@ -448,7 +448,8 @@ int dev_dax_probe(struct dev_dax *dev_da
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
-	if (dev_dax->align > PAGE_SIZE)
+	if (dev_dax->align > PAGE_SIZE &&
+	    IS_ENABLED(CONFIG_ARCH_WANT_OPTIMIZE_VMEMMAP))
 		pgmap->vmemmap_shift =
 			order_base_2(dev_dax->align >> PAGE_SHIFT);
 	addr = devm_memremap_pages(dev, pgmap);
--- a/include/linux/mm.h~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/include/linux/mm.h
@@ -3425,6 +3425,22 @@ void vmemmap_populate_print_last(void);
 void vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap);
 #endif
+
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_VMEMMAP
+static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
+					   struct dev_pagemap *pgmap)
+{
+	return is_power_of_2(sizeof(struct page)) &&
+		pgmap && (pgmap_vmemmap_nr(pgmap) > 1) && !altmap;
+}
+#else
+static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
+					   struct dev_pagemap *pgmap)
+{
+	return false;
+}
+#endif
+
 void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
 				  unsigned long nr_pages);
 
--- a/mm/Kconfig~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/mm/Kconfig
@@ -480,6 +480,9 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config ARCH_WANT_OPTIMIZE_VMEMMAP
+	bool
+
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
--- a/mm/sparse-vmemmap.c~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/mm/sparse-vmemmap.c
@@ -458,8 +458,7 @@ struct page * __meminit __populate_secti
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (is_power_of_2(sizeof(struct page)) &&
-	    pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
+	if (vmemmap_can_optimize(altmap, pgmap))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices.patch

