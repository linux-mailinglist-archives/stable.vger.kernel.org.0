Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91D063AF29
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbiK1Rjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbiK1Riv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:38:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A52727DFD;
        Mon, 28 Nov 2022 09:38:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6141B80E9B;
        Mon, 28 Nov 2022 17:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB34C433D7;
        Mon, 28 Nov 2022 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657109;
        bh=LqFfe6BE1LfqlHshHgc/IkPHpUp5+x+vk3h92xdd9l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkR5ET6UOix4nwxFc9ZObE9CWyEiy0PWI3aKI9cQMEr9YP0P3bJm7emeiy17ZAjJw
         dMXb7Pg0skIeNVYExd2mLzWPu4rMFLiwfpy+Ii/hOpbFncXpJAHyoaR16uUEWfgOVv
         UzVe+IL3ocpfmF3SGixfWVjKd2BIpsAGq99pfLSh3sAQsx2LlnbwAaJxq4rvOpnISz
         dsHFxPNsXSqxQKZKWWP0G9BYo2eAi5Qm5/1IiihjBKwSOdTG+qh+E/t1TF8Nck5IOy
         8WXLjlYlWmRiNnRpQ4Klolf8QorBCok+oU0IGK6wq4ZhyzLJiXCHjfCFJbjc6DGufh
         lYke5x/V8LIMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        wangkefeng.wang@huawei.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 15/39] ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation
Date:   Mon, 28 Nov 2022 12:35:55 -0500
Message-Id: <20221128173642.1441232-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
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
index d16aba48fa0a..090011394477 100644
--- a/arch/arm/include/asm/pgtable-nommu.h
+++ b/arch/arm/include/asm/pgtable-nommu.h
@@ -44,12 +44,6 @@
 
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
index 78a532068fec..ef48a55e9af8 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -10,6 +10,15 @@
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
 
 #include <asm-generic/pgtable-nopud.h>
@@ -139,13 +148,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
  */
 
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
index c42debaded95..c1494a4dee25 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -26,6 +26,13 @@
 
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
@@ -148,9 +155,21 @@ void __init adjust_lowmem_bounds(void)
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

