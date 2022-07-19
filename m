Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7539579D72
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241957AbiGSMvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241586AbiGSMuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:50:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211388FD75;
        Tue, 19 Jul 2022 05:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A6C617D6;
        Tue, 19 Jul 2022 12:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265D3C341C6;
        Tue, 19 Jul 2022 12:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233199;
        bh=8EB3mZIPTJPEgtKe/x6D9UDXwwwtQ9arLPzarEMA6fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FqVRDo9D60CQtvfuY4ti+ovVbeufYHGzsjo1CQLIeHOG4ui8VCqkqM4msRjyl9Lx
         1Web0OJKw/5PX0mb0Hk2BU1AEjKfNj1iO6b1pge+ir41VcHcrSdBEfmo5n3hEAk9CY
         Fmm/JIE4bH804WwEw3sUTFBIY8l4p7ngWGjaT3+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 041/231] ARM: 9210/1: Mark the FDT_FIXED sections as shareable
Date:   Tue, 19 Jul 2022 13:52:06 +0200
Message-Id: <20220719114717.716559534@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 598f0a99fa8a35be44b27106b43ddc66417af3b1 ]

commit 7a1be318f579 ("ARM: 9012/1: move device tree mapping out of linear
region") use FDT_FIXED_BASE to map the whole FDT_FIXED_SIZE memory area
which contains fdt. But it only reserves the exact physical memory that
fdt occupied. Unfortunately, this mapping is non-shareable. An illegal or
speculative read access can bring the RAM content from non-fdt zone into
cache, PIPT makes it to be hit by subsequently read access through
shareable mapping(such as linear mapping), and the cache consistency
between cores is lost due to non-shareable property.

|<---------FDT_FIXED_SIZE------>|
|                               |
 -------------------------------
| <non-fdt> | <fdt> | <non-fdt> |
 -------------------------------

1. CoreA read <non-fdt> through MT_ROM mapping, the old data is loaded
   into the cache.
2. CoreB write <non-fdt> to update data through linear mapping. CoreA
   received the notification to invalid the corresponding cachelines, but
   the property non-shareable makes it to be ignored.
3. CoreA read <non-fdt> through linear mapping, cache hit, the old data
   is read.

To eliminate this risk, add a new memory type MT_MEMORY_RO. Compared to
MT_ROM, it is shareable and non-executable.

Here's an example:
  list_del corruption. prev->next should be c0ecbf74, but was c08410dc
  kernel BUG at lib/list_debug.c:53!
  ... ...
  PC is at __list_del_entry_valid+0x58/0x98
  LR is at __list_del_entry_valid+0x58/0x98
  psr: 60000093
  sp : c0ecbf30  ip : 00000000  fp : 00000001
  r10: c08410d0  r9 : 00000001  r8 : c0825e0c
  r7 : 20000013  r6 : c08410d0  r5 : c0ecbf74  r4 : c0ecbf74
  r3 : c0825d08  r2 : 00000000  r1 : df7ce6f4  r0 : 00000044
  ... ...
  Stack: (0xc0ecbf30 to 0xc0ecc000)
  bf20:                                     c0ecbf74 c0164fd0 c0ecbf70 c0165170
  bf40: c0eca000 c0840c00 c0840c00 c0824500 c0825e0c c0189bbc c088f404 60000013
  bf60: 60000013 c0e85100 000004ec 00000000 c0ebcdc0 c0ecbf74 c0ecbf74 c0825d08
  ... ...                                           <  next     prev  >
  (__list_del_entry_valid) from (__list_del_entry+0xc/0x20)
  (__list_del_entry) from (finish_swait+0x60/0x7c)
  (finish_swait) from (rcu_gp_kthread+0x560/0xa20)
  (rcu_gp_kthread) from (kthread+0x14c/0x15c)
  (kthread) from (ret_from_fork+0x14/0x24)

The faulty list node to be deleted is a local variable, its address is
c0ecbf74. The dumped stack shows that 'prev' = c0ecbf74, but its value
before lib/list_debug.c:53 is c08410dc. A large amount of printing results
in swapping out the cacheline containing the old data(MT_ROM mapping is
read only, so the cacheline cannot be dirty), and the subsequent dump
operation obtains new data from the DDR.

Fixes: 7a1be318f579 ("ARM: 9012/1: move device tree mapping out of linear region")
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/mach/map.h |  1 +
 arch/arm/mm/mmu.c               | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index 92282558caf7..2b8970d8e5a2 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -27,6 +27,7 @@ enum {
 	MT_HIGH_VECTORS,
 	MT_MEMORY_RWX,
 	MT_MEMORY_RW,
+	MT_MEMORY_RO,
 	MT_ROM,
 	MT_MEMORY_RWX_NONCACHED,
 	MT_MEMORY_RW_DTCM,
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 5e2be37a198e..cd17e324aa51 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -296,6 +296,13 @@ static struct mem_type mem_types[] __ro_after_init = {
 		.prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE,
 		.domain    = DOMAIN_KERNEL,
 	},
+	[MT_MEMORY_RO] = {
+		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
+			     L_PTE_XN | L_PTE_RDONLY,
+		.prot_l1   = PMD_TYPE_TABLE,
+		.prot_sect = PMD_TYPE_SECT,
+		.domain    = DOMAIN_KERNEL,
+	},
 	[MT_ROM] = {
 		.prot_sect = PMD_TYPE_SECT,
 		.domain    = DOMAIN_KERNEL,
@@ -489,6 +496,7 @@ static void __init build_mem_type_table(void)
 
 			/* Also setup NX memory mapping */
 			mem_types[MT_MEMORY_RW].prot_sect |= PMD_SECT_XN;
+			mem_types[MT_MEMORY_RO].prot_sect |= PMD_SECT_XN;
 		}
 		if (cpu_arch >= CPU_ARCH_ARMv7 && (cr & CR_TRE)) {
 			/*
@@ -568,6 +576,7 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_ROM].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_MINICLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
+		mem_types[MT_MEMORY_RO].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 #endif
 
 		/*
@@ -587,6 +596,8 @@ static void __init build_mem_type_table(void)
 			mem_types[MT_MEMORY_RWX].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY_RW].prot_sect |= PMD_SECT_S;
 			mem_types[MT_MEMORY_RW].prot_pte |= L_PTE_SHARED;
+			mem_types[MT_MEMORY_RO].prot_sect |= PMD_SECT_S;
+			mem_types[MT_MEMORY_RO].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY_DMA_READY].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY_RWX_NONCACHED].prot_sect |= PMD_SECT_S;
 			mem_types[MT_MEMORY_RWX_NONCACHED].prot_pte |= L_PTE_SHARED;
@@ -647,6 +658,8 @@ static void __init build_mem_type_table(void)
 	mem_types[MT_MEMORY_RWX].prot_pte |= kern_pgprot;
 	mem_types[MT_MEMORY_RW].prot_sect |= ecc_mask | cp->pmd;
 	mem_types[MT_MEMORY_RW].prot_pte |= kern_pgprot;
+	mem_types[MT_MEMORY_RO].prot_sect |= ecc_mask | cp->pmd;
+	mem_types[MT_MEMORY_RO].prot_pte |= kern_pgprot;
 	mem_types[MT_MEMORY_DMA_READY].prot_pte |= kern_pgprot;
 	mem_types[MT_MEMORY_RWX_NONCACHED].prot_sect |= ecc_mask;
 	mem_types[MT_ROM].prot_sect |= cp->pmd;
@@ -1360,7 +1373,7 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
 		map.pfn = __phys_to_pfn(__atags_pointer & SECTION_MASK);
 		map.virtual = FDT_FIXED_BASE;
 		map.length = FDT_FIXED_SIZE;
-		map.type = MT_ROM;
+		map.type = MT_MEMORY_RO;
 		create_mapping(&map);
 	}
 
-- 
2.35.1



