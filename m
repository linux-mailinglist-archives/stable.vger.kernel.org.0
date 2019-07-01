Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CB75C60F
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 01:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfGAXwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 19:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbfGAXwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 19:52:11 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982792173E;
        Mon,  1 Jul 2019 23:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562025130;
        bh=mQmnSdDhg+7btgpzjUHY56XQBTBAQKBSn46s0s4NUeE=;
        h=Date:From:To:Subject:From;
        b=P1aw3zamzXslx7CQxklRHGtKBRQN2XUl/BM0+eA704pDc9jbsjpTp5c3RiuPheMIm
         5xJGqXxqkf5I3DCrLCxuX4qSLxVOPseJfqkzkj6UELD0WL5vnDrTlGFkD3OccjLphL
         DRkgH/jV3JMghvAqk1wDl2LlybDuw5bIokY9orv0=
Date:   Mon, 01 Jul 2019 16:52:10 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address.patch
 added to -mm tree
Message-ID: <20190701235210.dBLziqMb3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/nvdimm: add is_ioremap_addr and use that to check ioremap address
has been added to the -mm tree.  Its filename is
     mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-nvdimm-add-is_ioremap_addr-and-use-that-to-check-ioremap-address.patch
mm-move-map_sync-to-asm-generic-mman-commonh.patch
mm-mmap-move-common-defines-to-mman-commonh.patch

