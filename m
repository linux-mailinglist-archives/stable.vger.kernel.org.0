Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB784449D8
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhKCU74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhKCU7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:59:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B45C061714;
        Wed,  3 Nov 2021 13:57:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b13so3637902plg.2;
        Wed, 03 Nov 2021 13:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ya576HbrLRTHJlpTTIn6uvE/Uu8BbIxAE7uNusHPtZU=;
        b=GruWqGzzHk/Yvr7D9ohJLA0u1ec7y9ucn1s9iVksyVGHHTT8WQAj776YZCSjmBN94T
         1zcq6asBxhNhKKScoM8+csLfLxYykCbGBqZ3pgLmAifYR4/2XLjbW49DjYdYQW+Rj59m
         zM3feFsVQoVDrHFicXrEDDObyOy+/+TgbpJf63RvcS5uWcQXq0fLeEJ52rb0YF56bPXP
         v7dtlUJw85/GN88lS0xWNDwrtSOi8bJv9UuUx+L+228oHRbaRwUdqMjzMxWFvLJFzepw
         8uNhj4II96+I+PaKPy2R95ecNwi/UJO7NFBHnmv9B4SuYrEEGjMlX/ZiOuqgZnr8C+BK
         aGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ya576HbrLRTHJlpTTIn6uvE/Uu8BbIxAE7uNusHPtZU=;
        b=ECABWH2P/uC9p3gnIDFT9x6meptnPEEXZF1itK+0NmAhBOvAGyig2wYVk/GwGF2ba1
         mpyvOcNl5Rr/Lawr62O/n44Dy+upJHNK4jGo4W5plPqW/0F0QivrOPZ1Fa3jtR4vo1Xb
         WEwQ0RGsXgAG77DumurYOOdBjge9hBrUkAyu44ROjKtnyDgXe4IKC7XNjU4fvZjHdqeJ
         9oQ9NnQfiPK8G7IFBzZZOUDV1I+ZWUVzwHF5WB6fiPwAtnocFawKr7x0FYkQf68Oesrz
         aE3h5nKBPbSYsnY5W1jIY/YorXraTene2P2zexhlbENAwGROYOfQQusgQUJupSnETYEw
         Y5zw==
X-Gm-Message-State: AOAM530oiUchiZhEZwk2TL5cXZss3k04DC8msa2rtCIXgudtN4EIoUQU
        jHCv8Oyy2u8qeOqTrhX7+uNTCm869JI=
X-Google-Smtp-Source: ABdhPJwZ5vl3X49rGJIYkPToKOxssTP8uxhUU7meD/3RrukCf9RWTxlUIjhZeIkiZhctGzfCRFpWOw==
X-Received: by 2002:a17:902:bd94:b0:13f:f96c:aa22 with SMTP id q20-20020a170902bd9400b0013ff96caa22mr41030782pls.43.1635973034087;
        Wed, 03 Nov 2021 13:57:14 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b18sm2554859pjo.31.2021.11.03.13.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:57:13 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Stefan Agner <stefan@agner.ch>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-snps-arc@lists.infradead.org (open list:SYNOPSYS ARC ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-mips@linux-mips.org (open list:MIPS),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC (32-BIT AND
        64-BIT)),
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES),
        linux-mm@kvack.org (open list:ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR)
Subject: [PATCH stable 4.14 2/2] arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed
Date:   Wed,  3 Nov 2021 13:57:04 -0700
Message-Id: <20211103205704.374734-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211103205704.374734-1-f.fainelli@gmail.com>
References: <20211103205704.374734-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit cef397038167ac15d085914493d6c86385773709 ]

Stefan Agner reported a bug when using zsram on 32-bit Arm machines
with RAM above the 4GB address boundary:

  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  pgd = a27bd01c
  [00000000] *pgd=236a0003, *pmd=1ffa64003
  Internal error: Oops: 207 [#1] SMP ARM
  Modules linked in: mdio_bcm_unimac(+) brcmfmac cfg80211 brcmutil raspberrypi_hwmon hci_uart crc32_arm_ce bcm2711_thermal phy_generic genet
  CPU: 0 PID: 123 Comm: mkfs.ext4 Not tainted 5.9.6 #1
  Hardware name: BCM2711
  PC is at zs_map_object+0x94/0x338
  LR is at zram_bvec_rw.constprop.0+0x330/0xa64
  pc : [<c0602b38>]    lr : [<c0bda6a0>]    psr: 60000013
  sp : e376bbe0  ip : 00000000  fp : c1e2921c
  r10: 00000002  r9 : c1dda730  r8 : 00000000
  r7 : e8ff7a00  r6 : 00000000  r5 : 02f9ffa0  r4 : e3710000
  r3 : 000fdffe  r2 : c1e0ce80  r1 : ebf979a0  r0 : 00000000
  Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
  Control: 30c5383d  Table: 235c2a80  DAC: fffffffd
  Process mkfs.ext4 (pid: 123, stack limit = 0x495a22e6)
  Stack: (0xe376bbe0 to 0xe376c000)

As it turns out, zsram needs to know the maximum memory size, which
is defined in MAX_PHYSMEM_BITS when CONFIG_SPARSEMEM is set, or in
MAX_POSSIBLE_PHYSMEM_BITS on the x86 architecture.

The same problem will be hit on all 32-bit architectures that have a
physical address space larger than 4GB and happen to not enable sparsemem
and include asm/sparsemem.h from asm/pgtable.h.

After the initial discussion, I suggested just always defining
MAX_POSSIBLE_PHYSMEM_BITS whenever CONFIG_PHYS_ADDR_T_64BIT is
set, or provoking a build error otherwise. This addresses all
configurations that can currently have this runtime bug, but
leaves all other configurations unchanged.

I looked up the possible number of bits in source code and
datasheets, here is what I found:

 - on ARC, CONFIG_ARC_HAS_PAE40 controls whether 32 or 40 bits are used
 - on ARM, CONFIG_LPAE enables 40 bit addressing, without it we never
   support more than 32 bits, even though supersections in theory allow
   up to 40 bits as well.
 - on MIPS, some MIPS32r1 or later chips support 36 bits, and MIPS32r5
   XPA supports up to 60 bits in theory, but 40 bits are more than
   anyone will ever ship
 - On PowerPC, there are three different implementations of 36 bit
   addressing, but 32-bit is used without CONFIG_PTE_64BIT
 - On RISC-V, the normal page table format can support 34 bit
   addressing. There is no highmem support on RISC-V, so anything
   above 2GB is unused, but it might be useful to eventually support
   CONFIG_ZRAM for high pages.

Fixes: 61989a80fb3a ("staging: zsmalloc: zsmalloc memory allocation library")
Fixes: 02390b87a945 ("mm/zsmalloc: Prepare to variable MAX_PHYSMEM_BITS")
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Reviewed-by: Stefan Agner <stefan@agner.ch>
Tested-by: Stefan Agner <stefan@agner.ch>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Link: https://lore.kernel.org/linux-mm/bdfa44bf1c570b05d6c70898e2bbb0acf234ecdf.1604762181.git.stefan@agner.ch/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[florian: patch arch/powerpc/include/asm/pte-common.h for 4.14.y
removed arch/riscv/include/asm/pgtable.h which does not exist]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arc/include/asm/pgtable.h        |  2 ++
 arch/arm/include/asm/pgtable-2level.h |  2 ++
 arch/arm/include/asm/pgtable-3level.h |  2 ++
 arch/mips/include/asm/pgtable-32.h    |  3 +++
 arch/powerpc/include/asm/pte-common.h |  2 ++
 include/asm-generic/pgtable.h         | 13 +++++++++++++
 6 files changed, 24 insertions(+)

diff --git a/arch/arc/include/asm/pgtable.h b/arch/arc/include/asm/pgtable.h
index 77676e18da69..a31ae69da639 100644
--- a/arch/arc/include/asm/pgtable.h
+++ b/arch/arc/include/asm/pgtable.h
@@ -138,8 +138,10 @@
 
 #ifdef CONFIG_ARC_HAS_PAE40
 #define PTE_BITS_NON_RWX_IN_PD1	(0xff00000000 | PAGE_MASK | _PAGE_CACHEABLE)
+#define MAX_POSSIBLE_PHYSMEM_BITS 40
 #else
 #define PTE_BITS_NON_RWX_IN_PD1	(PAGE_MASK | _PAGE_CACHEABLE)
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
 #endif
 
 /**************************************************************************
diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index 92fd2c8a9af0..6154902bed83 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -78,6 +78,8 @@
 #define PTE_HWTABLE_OFF		(PTE_HWTABLE_PTRS * sizeof(pte_t))
 #define PTE_HWTABLE_SIZE	(PTRS_PER_PTE * sizeof(u32))
 
+#define MAX_POSSIBLE_PHYSMEM_BITS	32
+
 /*
  * PMD_SHIFT determines the size of the area a second-level page table can map
  * PGDIR_SHIFT determines what a third-level page table entry can map
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 2a029bceaf2f..35807e611b6e 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -37,6 +37,8 @@
 #define PTE_HWTABLE_OFF		(0)
 #define PTE_HWTABLE_SIZE	(PTRS_PER_PTE * sizeof(u64))
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 40
+
 /*
  * PGDIR_SHIFT determines the size a top-level page table entry can map.
  */
diff --git a/arch/mips/include/asm/pgtable-32.h b/arch/mips/include/asm/pgtable-32.h
index 74afe8c76bdd..215fb48f644b 100644
--- a/arch/mips/include/asm/pgtable-32.h
+++ b/arch/mips/include/asm/pgtable-32.h
@@ -111,6 +111,7 @@ static inline void pmd_clear(pmd_t *pmdp)
 
 #if defined(CONFIG_XPA)
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 40
 #define pte_pfn(x)		(((unsigned long)((x).pte_high >> _PFN_SHIFT)) | (unsigned long)((x).pte_low << _PAGE_PRESENT_SHIFT))
 static inline pte_t
 pfn_pte(unsigned long pfn, pgprot_t prot)
@@ -126,6 +127,7 @@ pfn_pte(unsigned long pfn, pgprot_t prot)
 
 #elif defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 36
 #define pte_pfn(x)		((unsigned long)((x).pte_high >> 6))
 
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
@@ -140,6 +142,7 @@ static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 
 #else
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
 #ifdef CONFIG_CPU_VR41XX
 #define pte_pfn(x)		((unsigned long)((x).pte >> (PAGE_SHIFT + 2)))
 #define pfn_pte(pfn, prot)	__pte(((pfn) << (PAGE_SHIFT + 2)) | pgprot_val(prot))
diff --git a/arch/powerpc/include/asm/pte-common.h b/arch/powerpc/include/asm/pte-common.h
index ce142ef99ba7..18ebe9a4728e 100644
--- a/arch/powerpc/include/asm/pte-common.h
+++ b/arch/powerpc/include/asm/pte-common.h
@@ -102,8 +102,10 @@ static inline bool pte_user(pte_t pte)
  */
 #if defined(CONFIG_PPC32) && defined(CONFIG_PTE_64BIT)
 #define PTE_RPN_MASK	(~((1ULL<<PTE_RPN_SHIFT)-1))
+#define MAX_POSSIBLE_PHYSMEM_BITS 36
 #else
 #define PTE_RPN_MASK	(~((1UL<<PTE_RPN_SHIFT)-1))
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
 #endif
 
 /* _PAGE_CHG_MASK masks of bits that are to be preserved across
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index cdee19314061..dd65e925f7cf 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1069,6 +1069,19 @@ static inline bool arch_has_pfn_modify_check(void)
 
 #endif /* !__ASSEMBLY__ */
 
+#if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+/*
+ * ZSMALLOC needs to know the highest PFN on 32-bit architectures
+ * with physical address space extension, but falls back to
+ * BITS_PER_LONG otherwise.
+ */
+#error Missing MAX_POSSIBLE_PHYSMEM_BITS definition
+#else
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
+#endif
+#endif
+
 #ifndef has_transparent_hugepage
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define has_transparent_hugepage() 1
-- 
2.25.1

