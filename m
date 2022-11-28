Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C764663B043
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiK1Rt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbiK1Rrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED74B1573B;
        Mon, 28 Nov 2022 09:42:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 753AA612D2;
        Mon, 28 Nov 2022 17:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59F8C433C1;
        Mon, 28 Nov 2022 17:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657366;
        bh=0md2/4sAZzfuKOdzfIRWS4BQR9w9wkpuvQ0oCut7UuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1jIQ7LZW2o5yVmD5rozfB1Holqp0/ebATDq5DHtnfZTWE2QbUsKf/kg8eKwyzcbB
         OcDoL7gmcx7m/OoqNdLfCXLJg5o5F0/Br4LqQd3Y/Wi05MHvvg0DRn/5B3tJUIaJkI
         9AJjjoMdhjBw0qHwsjlpS6b2UBgn9MyZoE2mw8YrZcsk5AgxC47hVqIs5O9vsGdSDU
         baCgT/Syk03HLaamKGZfIdNQ/QVSXTqz/zBZZez6TYVg33h5e9nGlSTtxumPoIYx3m
         9bhCfyH/IyJZtPVOqDLOsgw7iABgouTDZHaKQFKMR3ELKfz6SKGmCElFuBLfDYfH8E
         Tb/++WaLFithw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        will@kernel.org, wangkefeng.wang@huawei.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 04/12] ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation
Date:   Mon, 28 Nov 2022 12:42:27 -0500
Message-Id: <20221128174235.1442841-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174235.1442841-1-sashal@kernel.org>
References: <20221128174235.1442841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giulio Benetti <giulio.benetti@benettiengineering.com>

[ Upstream commit 340a982825f76f1cff0daa605970fe47321b5ee7 ]

Actually in no-MMU SoCs(i.e. i.MXRT) ZERO_PAGE(vaddr) expands to
```
virt_to_page(0)
```
that in order expands to:
```
pfn_to_page(virt_to_pfn(0))
```
and then virt_to_pfn(0) to:
```
        ((((unsigned long)(0) - PAGE_OFFSET) >> PAGE_SHIFT) +
         PHYS_PFN_OFFSET)
```
where PAGE_OFFSET and PHYS_PFN_OFFSET are the DRAM offset(0x80000000) and
PAGE_SHIFT is 12. This way we obtain 16MB(0x01000000) summed to the base of
DRAM(0x80000000).
When ZERO_PAGE(0) is then used, for example in bio_add_page(), the page
gets an address that is out of DRAM bounds.
So instead of using fake virtual page 0 let's allocate a dedicated
zero_page during paging_init() and assign it to a global 'struct page *
empty_zero_page' the same way mmu.c does and it's the same approach used
in m68k with commit dc068f462179 as discussed here[0]. Then let's move
ZERO_PAGE() definition to the top of pgtable.h to be in common between
mmu.c and nommu.c.

[0]: https://lore.kernel.org/linux-m68k/2a462b23-5b8e-bbf4-ec7d-778434a3b9d7@google.com/T/#m1266ceb63
ad140743174d6b3070364d3c9a5179b

Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/pgtable-nommu.h |  6 ------
 arch/arm/include/asm/pgtable.h       | 16 +++++++++-------
 arch/arm/mm/nommu.c                  | 19 +++++++++++++++++++
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-nommu.h b/arch/arm/include/asm/pgtable-nommu.h
index a0d726a47c8a..e7ca798513c1 100644
--- a/arch/arm/include/asm/pgtable-nommu.h
+++ b/arch/arm/include/asm/pgtable-nommu.h
@@ -54,12 +54,6 @@
 
 typedef pte_t *pte_addr_t;
 
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-#define ZERO_PAGE(vaddr)	(virt_to_page(0))
-
 /*
  * Mark the prot value as uncacheable and unbufferable.
  */
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index a757401129f9..fdc3bc07061f 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -13,6 +13,15 @@
 #include <linux/const.h>
 #include <asm/proc-fns.h>
 
+#ifndef __ASSEMBLY__
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern struct page *empty_zero_page;
+#define ZERO_PAGE(vaddr)	(empty_zero_page)
+#endif
+
 #ifndef CONFIG_MMU
 
 #include <asm-generic/4level-fixup.h>
@@ -166,13 +175,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 #define __S111  __PAGE_SHARED_EXEC
 
 #ifndef __ASSEMBLY__
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-extern struct page *empty_zero_page;
-#define ZERO_PAGE(vaddr)	(empty_zero_page)
-
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index 7d67c70bbded..e803fd16248b 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -25,6 +25,13 @@
 
 unsigned long vectors_base;
 
+/*
+ * empty_zero_page is a special page that is used for
+ * zero-initialized data and COW.
+ */
+struct page *empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
+
 #ifdef CONFIG_ARM_MPU
 struct mpu_rgn_info mpu_rgn_info;
 #endif
@@ -147,9 +154,21 @@ void __init adjust_lowmem_bounds(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
+	void *zero_page;
+
 	early_trap_init((void *)vectors_base);
 	mpu_setup();
+
+	/* allocate the zero page. */
+	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	if (!zero_page)
+		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
+		      __func__, PAGE_SIZE, PAGE_SIZE);
+
 	bootmem_init();
+
+	empty_zero_page = virt_to_page(zero_page);
+	flush_dcache_page(empty_zero_page);
 }
 
 /*
-- 
2.35.1

