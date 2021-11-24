Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD3F45C618
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349689AbhKXOFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349136AbhKXOAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9277B61A70;
        Wed, 24 Nov 2021 13:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759370;
        bh=+abqP3JUQ/4UlZGTlA23Oa68uQ9ueohFTj7z7M+57H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSJCPnT9svTepEZ+MD2i+R9k+sVo+eVQF5QPJEyJCOdx2c31SLnUleN/XrQNch3x6
         i3iiBsmqetMLR8T637lzG2pl7eltLhRdjJf6lhEqUpG3JvQasi8weG5/xBEyKxzcry
         3Dk9w4OsjTTtjpTGsrj/l7E+DccTMK11AkxBiDGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 218/279] s390/boot: simplify and fix kernel memory layout setup
Date:   Wed, 24 Nov 2021 12:58:25 +0100
Message-Id: <20211124115726.277416764@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 9a39abb7c9aab50eec4ac4421e9ee7f3de013d24 upstream.

Initial KASAN shadow memory range was picked to preserve original kernel
modules area position. With protected execution support, which might
impose addressing limitation on vmalloc area and hence affect modules
area position, current fixed KASAN shadow memory range is only making
kernel memory layout setup more complex. So move it to the very end of
available virtual space and simplify calculations.

At the same time return to previous kernel address space split. In
particular commit 0c4f2623b957 ("s390: setup kernel memory layout
early") introduced precise identity map size calculation and keeping
vmemmap left most starting from a fresh region table entry. This didn't
take into account additional mapping region requirement for potential
DCSS mapping above available physical memory. So go back to virtual
space split between 1:1 mapping & vmemmap array once vmalloc area size
is subtracted.

Cc: stable@vger.kernel.org
Fixes: 0c4f2623b957 ("s390: setup kernel memory layout early")
Reported-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig        |    2 -
 arch/s390/boot/startup.c |   88 ++++++++++++++++-------------------------------
 2 files changed, 32 insertions(+), 58 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -47,7 +47,7 @@ config ARCH_SUPPORTS_UPROBES
 config KASAN_SHADOW_OFFSET
 	hex
 	depends on KASAN
-	default 0x18000000000000
+	default 0x1C000000000000
 
 config S390
 	def_bool y
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -148,82 +148,56 @@ static void setup_ident_map_size(unsigne
 
 static void setup_kernel_memory_layout(void)
 {
-	bool vmalloc_size_verified = false;
-	unsigned long vmemmap_off;
-	unsigned long vspace_left;
+	unsigned long vmemmap_start;
 	unsigned long rte_size;
 	unsigned long pages;
-	unsigned long vmax;
 
 	pages = ident_map_size / PAGE_SIZE;
 	/* vmemmap contains a multiple of PAGES_PER_SECTION struct pages */
 	vmemmap_size = SECTION_ALIGN_UP(pages) * sizeof(struct page);
 
 	/* choose kernel address space layout: 4 or 3 levels. */
-	vmemmap_off = round_up(ident_map_size, _REGION3_SIZE);
+	vmemmap_start = round_up(ident_map_size, _REGION3_SIZE);
 	if (IS_ENABLED(CONFIG_KASAN) ||
 	    vmalloc_size > _REGION2_SIZE ||
-	    vmemmap_off + vmemmap_size + vmalloc_size + MODULES_LEN > _REGION2_SIZE)
-		vmax = _REGION1_SIZE;
-	else
-		vmax = _REGION2_SIZE;
-
-	/* keep vmemmap_off aligned to a top level region table entry */
-	rte_size = vmax == _REGION1_SIZE ? _REGION2_SIZE : _REGION3_SIZE;
-	MODULES_END = vmax;
-	if (is_prot_virt_host()) {
-		/*
-		 * forcing modules and vmalloc area under the ultravisor
-		 * secure storage limit, so that any vmalloc allocation
-		 * we do could be used to back secure guest storage.
-		 */
-		adjust_to_uv_max(&MODULES_END);
-	}
-
-#ifdef CONFIG_KASAN
-	if (MODULES_END < vmax) {
-		/* force vmalloc and modules below kasan shadow */
-		MODULES_END = min(MODULES_END, KASAN_SHADOW_START);
+	    vmemmap_start + vmemmap_size + vmalloc_size + MODULES_LEN >
+		    _REGION2_SIZE) {
+		MODULES_END = _REGION1_SIZE;
+		rte_size = _REGION2_SIZE;
 	} else {
-		/*
-		 * leave vmalloc and modules above kasan shadow but make
-		 * sure they don't overlap with it
-		 */
-		vmalloc_size = min(vmalloc_size, vmax - KASAN_SHADOW_END - MODULES_LEN);
-		vmalloc_size_verified = true;
-		vspace_left = KASAN_SHADOW_START;
+		MODULES_END = _REGION2_SIZE;
+		rte_size = _REGION3_SIZE;
 	}
+	/*
+	 * forcing modules and vmalloc area under the ultravisor
+	 * secure storage limit, so that any vmalloc allocation
+	 * we do could be used to back secure guest storage.
+	 */
+	adjust_to_uv_max(&MODULES_END);
+#ifdef CONFIG_KASAN
+	/* force vmalloc and modules below kasan shadow */
+	MODULES_END = min(MODULES_END, KASAN_SHADOW_START);
 #endif
 	MODULES_VADDR = MODULES_END - MODULES_LEN;
 	VMALLOC_END = MODULES_VADDR;
 
-	if (vmalloc_size_verified) {
-		VMALLOC_START = VMALLOC_END - vmalloc_size;
-	} else {
-		vmemmap_off = round_up(ident_map_size, rte_size);
-
-		if (vmemmap_off + vmemmap_size > VMALLOC_END ||
-		    vmalloc_size > VMALLOC_END - vmemmap_off - vmemmap_size) {
-			/*
-			 * allow vmalloc area to occupy up to 1/2 of
-			 * the rest virtual space left.
-			 */
-			vmalloc_size = min(vmalloc_size, VMALLOC_END / 2);
-		}
-		VMALLOC_START = VMALLOC_END - vmalloc_size;
-		vspace_left = VMALLOC_START;
-	}
+	/* allow vmalloc area to occupy up to about 1/2 of the rest virtual space left */
+	vmalloc_size = min(vmalloc_size, round_down(VMALLOC_END / 2, _REGION3_SIZE));
+	VMALLOC_START = VMALLOC_END - vmalloc_size;
 
-	pages = vspace_left / (PAGE_SIZE + sizeof(struct page));
+	/* split remaining virtual space between 1:1 mapping & vmemmap array */
+	pages = VMALLOC_START / (PAGE_SIZE + sizeof(struct page));
 	pages = SECTION_ALIGN_UP(pages);
-	vmemmap_off = round_up(vspace_left - pages * sizeof(struct page), rte_size);
-	/* keep vmemmap left most starting from a fresh region table entry */
-	vmemmap_off = min(vmemmap_off, round_up(ident_map_size, rte_size));
-	/* take care that identity map is lower then vmemmap */
-	ident_map_size = min(ident_map_size, vmemmap_off);
+	/* keep vmemmap_start aligned to a top level region table entry */
+	vmemmap_start = round_down(VMALLOC_START - pages * sizeof(struct page), rte_size);
+	/* vmemmap_start is the future VMEM_MAX_PHYS, make sure it is within MAX_PHYSMEM */
+	vmemmap_start = min(vmemmap_start, 1UL << MAX_PHYSMEM_BITS);
+	/* make sure identity map doesn't overlay with vmemmap */
+	ident_map_size = min(ident_map_size, vmemmap_start);
 	vmemmap_size = SECTION_ALIGN_UP(ident_map_size / PAGE_SIZE) * sizeof(struct page);
-	VMALLOC_START = max(vmemmap_off + vmemmap_size, VMALLOC_START);
-	vmemmap = (struct page *)vmemmap_off;
+	/* make sure vmemmap doesn't overlay with vmalloc area */
+	VMALLOC_START = max(vmemmap_start + vmemmap_size, VMALLOC_START);
+	vmemmap = (struct page *)vmemmap_start;
 }
 
 /*


