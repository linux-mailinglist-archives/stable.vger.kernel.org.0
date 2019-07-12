Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57141675F4
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 22:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfGLUgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 16:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfGLUgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 16:36:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CBE9217D4;
        Fri, 12 Jul 2019 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562963791;
        bh=B66gEl3ogCzn0OtTHmwtFnNnLMEKnZRvrt03dnRbErc=;
        h=Date:From:To:Subject:From;
        b=PrY69uB3phOo8T0RORSw4Y2fEZcC+XxRbx+N8oS5vXBOEYwx5vIZy70lqUgV/D9N2
         hukwPCWBtVyKfeYs/8Keo4lxD3KaDyXLZY0QinpGGmyAsNch8BaBMxU8AFm+B28QEU
         QZfrX/vUFkdtNAFHRkV2lTztuDFSxw+V2EHwKl18=
Date:   Fri, 12 Jul 2019 13:36:31 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address.patch
 removed from -mm tree
Message-ID: <20190712203631.1Wr2Hqlim%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/nvdimm: add is_ioremap_addr and use that to check ioremap address
has been removed from the -mm tree.  Its filename was
     mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/nvdimm: add is_ioremap_addr and use that to check ioremap address

Architectures like powerpc use different address range to map ioremap and
vmalloc range.  The memunmap() check used by the nvdimm layer was wrongly
using is_vmalloc_addr() to check for ioremap range which fails for ppc64. 
This result in ppc64 not freeing the ioremap mapping.  The side effect of
this is an unbind failure during module unload with papr_scm nvdimm driver

Link: http://lkml.kernel.org/r/20190701134038.14165-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |   14 ++++++++++++++
 include/linux/mm.h                 |    5 +++++
 kernel/iomem.c                     |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/pgtable.h~mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -140,6 +140,20 @@ static inline void pte_frag_set(mm_conte
 }
 #endif
 
+#ifdef CONFIG_PPC64
+#define is_ioremap_addr is_ioremap_addr
+static inline bool is_ioremap_addr(const void *x)
+{
+#ifdef CONFIG_MMU
+	unsigned long addr = (unsigned long)x;
+
+	return addr >= IOREMAP_BASE && addr < IOREMAP_END;
+#else
+	return false;
+#endif
+}
+#endif /* CONFIG_PPC64 */
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
--- a/include/linux/mm.h~mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address
+++ a/include/linux/mm.h
@@ -633,6 +633,11 @@ static inline bool is_vmalloc_addr(const
 	return false;
 #endif
 }
+
+#ifndef is_ioremap_addr
+#define is_ioremap_addr(x) is_vmalloc_addr(x)
+#endif
+
 #ifdef CONFIG_MMU
 extern int is_vmalloc_or_module_addr(const void *x);
 #else
--- a/kernel/iomem.c~mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address
+++ a/kernel/iomem.c
@@ -121,7 +121,7 @@ EXPORT_SYMBOL(memremap);
 
 void memunmap(void *addr)
 {
-	if (is_vmalloc_addr(addr))
+	if (is_ioremap_addr(addr))
 		iounmap((void __iomem *) addr);
 }
 EXPORT_SYMBOL(memunmap);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-move-map_sync-to-asm-generic-mman-commonh.patch
mm-mmap-move-common-defines-to-mman-commonh.patch

