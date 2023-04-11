Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48436DE64E
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 23:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjDKVRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 17:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjDKVRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 17:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B81440E4;
        Tue, 11 Apr 2023 14:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D2EA62C35;
        Tue, 11 Apr 2023 21:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A72C433D2;
        Tue, 11 Apr 2023 21:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681247849;
        bh=bQZEPHlQ4mwxUTcA7M0c7JjGT91srUSraIxBuqHbvQQ=;
        h=Date:To:From:Subject:From;
        b=c/jFPAodGpgNg63ZrbGFQSFX/0FfMIQtBSqUnL8nDHSSQ2VyFptbD2ze0oGMhmAz/
         Qrg4MfuvJgMkVKPfLhmLo6JlCv5yUraKfE9BxSW8h4uJU3dWtonbtObxfstz40DZhz
         PVvLCy9BqzTHvQgA2KVK14jBXNBxyTndNbG7yRm8=
Date:   Tue, 11 Apr 2023 14:17:28 -0700
To:     mm-commits@vger.kernel.org, tsahu@linux.ibm.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        joao.m.martins@oracle.com, dan.j.williams@intel.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices.patch added to mm-hotfixes-unstable branch
Message-Id: <20230411211729.90A72C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Date: Tue, 11 Apr 2023 19:52:13 +0530

commit 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory savings for
compound devmaps") added support for using optimized vmmemap for devdax
devices.  But how vmemmap mappings are created are architecture specific. 
For example, powerpc with hash translation doesn't have vmemmap mappings
in init_mm page table instead they are bolted table entries in the
hardware page table

vmemmap_populate_compound_pages() used by vmemmap optimization code is not
aware of these architecture-specific mapping.  Hence allow architecture to
opt for this feature.  I selected architectures supporting
HUGETLB_PAGE_OPTIMIZE_VMEMMAP option as also supporting this feature.

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

Link: https://lkml.kernel.org/r/20230411142214.64464-1-aneesh.kumar@linux.ibm.com
Fixes: 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory savings for compound devmaps")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Tarun Sahu <tsahu@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   16 ++++++++++++++++
 mm/page_alloc.c     |    9 ++++++---
 mm/sparse-vmemmap.c |    3 +--
 3 files changed, 23 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/include/linux/mm.h
@@ -3425,6 +3425,22 @@ void vmemmap_populate_print_last(void);
 void vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap);
 #endif
+
+#ifdef CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
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
 
--- a/mm/page_alloc.c~mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices
+++ a/mm/page_alloc.c
@@ -6905,10 +6905,13 @@ static void __ref __init_zone_device_pag
  * of an altmap. See vmemmap_populate_compound_pages().
  */
 static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+					      struct dev_pagemap *pgmap,
 					      unsigned long nr_pages)
 {
-	return is_power_of_2(sizeof(struct page)) &&
-		!altmap ? 2 * (PAGE_SIZE / sizeof(struct page)) : nr_pages;
+	if (vmemmap_can_optimize(altmap, pgmap))
+		return 2 * (PAGE_SIZE / sizeof(struct page));
+	else
+		return nr_pages;
 }
 
 static void __ref memmap_init_compound(struct page *head,
@@ -6973,7 +6976,7 @@ void __ref memmap_init_zone_device(struc
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pfns_per_compound));
+				     compound_nr_pages(altmap, pgmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
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

