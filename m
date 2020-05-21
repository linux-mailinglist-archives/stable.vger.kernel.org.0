Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079B71DDB56
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgEUXyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:54:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:56823 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729651AbgEUXyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:54:07 -0400
IronPort-SDR: YAJQznibnDp5g1o1yUmYQBjbsx1a+O+QF/YN+zaC0LEyuuUYc1UXue3eLsQGT+BtfGdNV7m0zO
 hfyjl27dk2lg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:06 -0700
IronPort-SDR: 1HYgbrgbDP6Uf4ksd4EUqUbsM1s8ZMIwdx4hqjqvgq2KotmtWcu367ZXzIVaprIJJlwXbuZyno
 x5IYrJnsI0DA==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="283231504"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:06 -0700
Subject: [5.4-stable PATCH 2/7] mm/memremap_pages: Introduce
 memremap_compat_align()
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        vishal.l.verma@intel.com, hch@lst.de, linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 16:37:54 -0700
Message-ID: <159010427458.1062454.2604902759814389367.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 9ffc1d19fc4a6dfcfe06c91c2861ad6d44fdd92d upstream.

The "sub-section memory hotplug" facility allows memremap_pages() users
like libnvdimm to compensate for hardware platforms like x86 that have a
section size larger than their hardware memory mapping granularity.  The
compensation that sub-section support affords is being tolerant of
physical memory resources shifting by units smaller (64MiB on x86) than
the memory-hotplug section size (128 MiB). Where the platform
physical-memory mapping granularity is limited by the number and
capability of address-decode-registers in the memory controller.

While the sub-section support allows memremap_pages() to operate on
sub-section (2MiB) granularity, the Power architecture may still
require 16MiB alignment on "!radix_enabled()" platforms.

In order for libnvdimm to be able to detect and manage this per-arch
limitation, introduce memremap_compat_align() as a common minimum
alignment across all driver-facing memory-mapping interfaces, and let
Power override it to 16MiB in the "!radix_enabled()" case.

The assumption / requirement for 16MiB to be a viable
memremap_compat_align() value is that Power does not have platforms
where its equivalent of address-decode-registers never hardware remaps a
persistent memory resource on smaller than 16MiB boundaries. Note that I
tried my best to not add a new Kconfig symbol, but header include
entanglements defeated the #ifndef memremap_compat_align design pattern
and the need to export it defeats the __weak design pattern for arch
overrides.

Based on an initial patch by Aneesh.

Link: http://lore.kernel.org/r/CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/Kconfig      |    1 +
 arch/powerpc/mm/ioremap.c |   21 +++++++++++++++++++++
 drivers/nvdimm/pfn_devs.c |    2 +-
 include/linux/memremap.h  |    8 ++++++++
 include/linux/mmzone.h    |    1 +
 lib/Kconfig               |    3 +++
 mm/memremap.c             |   23 +++++++++++++++++++++++
 7 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2b1033f13210..a6b65bb6be47 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -126,6 +126,7 @@ config PPC
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_HUGEPD			if HUGETLB_PAGE
+	select ARCH_HAS_MEMREMAP_COMPAT_ALIGN
 	select ARCH_HAS_MMIOWB			if PPC64
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_PMEM_API
diff --git a/arch/powerpc/mm/ioremap.c b/arch/powerpc/mm/ioremap.c
index fc669643ce6a..b1a0aebe8c48 100644
--- a/arch/powerpc/mm/ioremap.c
+++ b/arch/powerpc/mm/ioremap.c
@@ -2,6 +2,7 @@
 
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/mmzone.h>
 #include <linux/vmalloc.h>
 #include <asm/io-workarounds.h>
 
@@ -97,3 +98,23 @@ void __iomem *do_ioremap(phys_addr_t pa, phys_addr_t offset, unsigned long size,
 
 	return NULL;
 }
+
+#ifdef CONFIG_ZONE_DEVICE
+/*
+ * Override the generic version in mm/memremap.c.
+ *
+ * With hash translation, the direct-map range is mapped with just one
+ * page size selected by htab_init_page_sizes(). Consult
+ * mmu_psize_defs[] to determine the minimum page size alignment.
+*/
+unsigned long memremap_compat_align(void)
+{
+	unsigned int shift = mmu_psize_defs[mmu_linear_psize].shift;
+
+	if (radix_enabled())
+		return SUBSECTION_SIZE;
+	return max(SUBSECTION_SIZE, 1UL << shift);
+
+}
+EXPORT_SYMBOL_GPL(memremap_compat_align);
+#endif
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 60d81fae06ee..aa144c8a4ee6 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -752,7 +752,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	start = nsio->res.start;
 	size = resource_size(&nsio->res);
 	npfns = PHYS_PFN(size - SZ_8K);
-	align = max(nd_pfn->align, (1UL << SUBSECTION_SHIFT));
+	align = max(nd_pfn->align, SUBSECTION_SIZE);
 	end_trunc = start + size - ALIGN_DOWN(start + size, align);
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
 		/*
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 6fefb09af7c3..8af1cbd8f293 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -132,6 +132,7 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
+unsigned long memremap_compat_align(void);
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
@@ -165,6 +166,12 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 		unsigned long nr_pfns)
 {
 }
+
+/* when memremap_pages() is disabled all archs can remap a single page */
+static inline unsigned long memremap_compat_align(void)
+{
+	return PAGE_SIZE;
+}
 #endif /* CONFIG_ZONE_DEVICE */
 
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
@@ -172,4 +179,5 @@ static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
 	if (pgmap)
 		percpu_ref_put(pgmap->ref);
 }
+
 #endif /* _LINUX_MEMREMAP_H_ */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8b5f758942a2..c4d17aff7f5f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1157,6 +1157,7 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
 #define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
 
 #define SUBSECTION_SHIFT 21
+#define SUBSECTION_SIZE (1UL << SUBSECTION_SHIFT)
 
 #define PFN_SUBSECTION_SHIFT (SUBSECTION_SHIFT - PAGE_SHIFT)
 #define PAGES_PER_SUBSECTION (1UL << PFN_SUBSECTION_SHIFT)
diff --git a/lib/Kconfig b/lib/Kconfig
index 3321d04dfa5a..7e779a868a8b 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -605,6 +605,9 @@ config ARCH_NO_SG_CHAIN
 config ARCH_HAS_PMEM_API
 	bool
 
+config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
+	bool
+
 # use memcpy to implement user copies for nommu architectures
 config UACCESS_MEMCPY
 	bool
diff --git a/mm/memremap.c b/mm/memremap.c
index c51c6bd2fe34..1053fe72e114 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/pfn_t.h>
 #include <linux/swap.h>
+#include <linux/mmzone.h>
 #include <linux/swapops.h>
 #include <linux/types.h>
 #include <linux/wait_bit.h>
@@ -14,6 +15,28 @@
 
 static DEFINE_XARRAY(pgmap_array);
 
+/*
+ * The memremap() and memremap_pages() interfaces are alternately used
+ * to map persistent memory namespaces. These interfaces place different
+ * constraints on the alignment and size of the mapping (namespace).
+ * memremap() can map individual PAGE_SIZE pages. memremap_pages() can
+ * only map subsections (2MB), and at least one architecture (PowerPC)
+ * the minimum mapping granularity of memremap_pages() is 16MB.
+ *
+ * The role of memremap_compat_align() is to communicate the minimum
+ * arch supported alignment of a namespace such that it can freely
+ * switch modes without violating the arch constraint. Namely, do not
+ * allow a namespace to be PAGE_SIZE aligned since that namespace may be
+ * reconfigured into a mode that requires SUBSECTION_SIZE alignment.
+ */
+#ifndef CONFIG_ARCH_HAS_MEMREMAP_COMPAT_ALIGN
+unsigned long memremap_compat_align(void)
+{
+	return SUBSECTION_SIZE;
+}
+EXPORT_SYMBOL_GPL(memremap_compat_align);
+#endif
+
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
 EXPORT_SYMBOL(devmap_managed_key);

