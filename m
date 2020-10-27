Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984C129B4A6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790293AbgJ0PEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790282AbgJ0PES (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:04:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75465223B0;
        Tue, 27 Oct 2020 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811058;
        bh=z0Sc5DJ0d7/w3VkrVjgSRyzKrnLxogP9SGYX/ymxJTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZprguWcr8I2N6EBvcJiMSQNvXtTpbGIxj51HCZ/L3ocLAr+Y9wn4L+QSM+m5ZYKKB
         Fm8q8AkNZqjeUgLq44si91V79tsOIUSRNO0lMJOk7WzZx1tG9/5bw01MrvFB9hG0Ld
         MKmwevPVLaRBKEzzG3anwhVk5ig1uzIXeMCozURI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 359/633] powerpc/pseries/svm: Allocate SWIOTLB buffer anywhere in memory
Date:   Tue, 27 Oct 2020 14:51:42 +0100
Message-Id: <20201027135539.530564003@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thiago Jung Bauermann <bauerman@linux.ibm.com>

[ Upstream commit eae9eec476d13fad9af6da1f44a054ee02b7b161 ]

POWER secure guests (i.e., guests which use the Protected Execution
Facility) need to use SWIOTLB to be able to do I/O with the
hypervisor, but they don't need the SWIOTLB memory to be in low
addresses since the hypervisor doesn't have any addressing limitation.

This solves a SWIOTLB initialization problem we are seeing in secure
guests with 128 GB of RAM: they are configured with 4 GB of
crashkernel reserved memory, which leaves no space for SWIOTLB in low
addresses.

To do this, we use mostly the same code as swiotlb_init(), but
allocate the buffer using memblock_alloc() instead of
memblock_alloc_low().

Fixes: 2efbc58f157a ("powerpc/pseries/svm: Force SWIOTLB for secure guests")
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200818221126.391073-1-bauerman@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/svm.h       |  4 ++++
 arch/powerpc/mm/mem.c                |  6 +++++-
 arch/powerpc/platforms/pseries/svm.c | 26 ++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/svm.h b/arch/powerpc/include/asm/svm.h
index 85580b30aba48..7546402d796af 100644
--- a/arch/powerpc/include/asm/svm.h
+++ b/arch/powerpc/include/asm/svm.h
@@ -15,6 +15,8 @@ static inline bool is_secure_guest(void)
 	return mfmsr() & MSR_S;
 }
 
+void __init svm_swiotlb_init(void);
+
 void dtl_cache_ctor(void *addr);
 #define get_dtl_cache_ctor()	(is_secure_guest() ? dtl_cache_ctor : NULL)
 
@@ -25,6 +27,8 @@ static inline bool is_secure_guest(void)
 	return false;
 }
 
+static inline void svm_swiotlb_init(void) {}
+
 #define get_dtl_cache_ctor() NULL
 
 #endif /* CONFIG_PPC_SVM */
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index c2c11eb8dcfca..0f21bcb16405a 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -50,6 +50,7 @@
 #include <asm/swiotlb.h>
 #include <asm/rtas.h>
 #include <asm/kasan.h>
+#include <asm/svm.h>
 
 #include <mm/mmu_decl.h>
 
@@ -290,7 +291,10 @@ void __init mem_init(void)
 	 * back to to-down.
 	 */
 	memblock_set_bottom_up(true);
-	swiotlb_init(0);
+	if (is_secure_guest())
+		svm_swiotlb_init();
+	else
+		swiotlb_init(0);
 #endif
 
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
diff --git a/arch/powerpc/platforms/pseries/svm.c b/arch/powerpc/platforms/pseries/svm.c
index 40c0637203d5b..81085eb8f2255 100644
--- a/arch/powerpc/platforms/pseries/svm.c
+++ b/arch/powerpc/platforms/pseries/svm.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/memblock.h>
 #include <asm/machdep.h>
 #include <asm/svm.h>
 #include <asm/swiotlb.h>
@@ -34,6 +35,31 @@ static int __init init_svm(void)
 }
 machine_early_initcall(pseries, init_svm);
 
+/*
+ * Initialize SWIOTLB. Essentially the same as swiotlb_init(), except that it
+ * can allocate the buffer anywhere in memory. Since the hypervisor doesn't have
+ * any addressing limitation, we don't need to allocate it in low addresses.
+ */
+void __init svm_swiotlb_init(void)
+{
+	unsigned char *vstart;
+	unsigned long bytes, io_tlb_nslabs;
+
+	io_tlb_nslabs = (swiotlb_size_or_default() >> IO_TLB_SHIFT);
+	io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+
+	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+
+	vstart = memblock_alloc(PAGE_ALIGN(bytes), PAGE_SIZE);
+	if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, false))
+		return;
+
+	if (io_tlb_start)
+		memblock_free_early(io_tlb_start,
+				    PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+	panic("SVM: Cannot allocate SWIOTLB buffer");
+}
+
 int set_memory_encrypted(unsigned long addr, int numpages)
 {
 	if (!PAGE_ALIGNED(addr))
-- 
2.25.1



