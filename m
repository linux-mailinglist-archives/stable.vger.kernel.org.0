Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A521033B9BC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhCOOGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233435AbhCOOBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5341D64F00;
        Mon, 15 Mar 2021 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816882;
        bh=dR9rYQsjpEZ/klirYxHXOXI9qRuEczWuLtNHXHmXuz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skNFXUjmD519pdZr1WsNpUKJLJtM7iqXKEXTsRkTlDzDwTw+IQTcQ2D6tQC40MwQF
         iV/+njsMnHdouYJ4Spbn19odOhTbUbDM0YGme7kFY1xA5XqfrKtB0OWde5g+8NbCeZ
         ELMGWQ+3e8THzkxiVtVs5vMT207XLCeThFqi31Q0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Patrick Daly <pdaly@codeaurora.org>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH 5.11 181/306] arm64: mte: Map hotplugged memory as Normal Tagged
Date:   Mon, 15 Mar 2021 14:54:04 +0100
Message-Id: <20210315135513.739011866@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Catalin Marinas <catalin.marinas@arm.com>

commit d15dfd31384ba3cb93150e5f87661a76fa419f74 upstream.

In a system supporting MTE, the linear map must allow reading/writing
allocation tags by setting the memory type as Normal Tagged. Currently,
this is only handled for memory present at boot. Hotplugged memory uses
Normal non-Tagged memory.

Introduce pgprot_mhp() for hotplugged memory and use it in
add_memory_resource(). The arm64 code maps pgprot_mhp() to
pgprot_tagged().

Note that ZONE_DEVICE memory should not be mapped as Tagged and
therefore setting the memory type in arch_add_memory() is not feasible.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 0178dc761368 ("arm64: mte: Use Normal Tagged attributes for the linear map")
Reported-by: Patrick Daly <pdaly@codeaurora.org>
Tested-by: Patrick Daly <pdaly@codeaurora.org>
Link: https://lore.kernel.org/r/1614745263-27827-1-git-send-email-pdaly@codeaurora.org
Cc: <stable@vger.kernel.org> # 5.10.x
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20210309122601.5543-1-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable-prot.h |    1 -
 arch/arm64/include/asm/pgtable.h      |    3 +++
 arch/arm64/mm/mmu.c                   |    3 ++-
 include/linux/pgtable.h               |    4 ++++
 mm/memory_hotplug.c                   |    2 +-
 5 files changed, 10 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -66,7 +66,6 @@ extern bool arm64_use_ng_mappings;
 #define _PAGE_DEFAULT		(_PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
 
 #define PAGE_KERNEL		__pgprot(PROT_NORMAL)
-#define PAGE_KERNEL_TAGGED	__pgprot(PROT_NORMAL_TAGGED)
 #define PAGE_KERNEL_RO		__pgprot((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY)
 #define PAGE_KERNEL_ROX		__pgprot((PROT_NORMAL & ~(PTE_WRITE | PTE_PXN)) | PTE_RDONLY)
 #define PAGE_KERNEL_EXEC	__pgprot(PROT_NORMAL & ~PTE_PXN)
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -486,6 +486,9 @@ static inline pmd_t pmd_mkdevmap(pmd_t p
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
 #define pgprot_device(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
+#define pgprot_tagged(prot) \
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_TAGGED))
+#define pgprot_mhp	pgprot_tagged
 /*
  * DMA allocations for non-coherent devices use what the Arm architecture calls
  * "Normal non-cacheable" memory, which permits speculation, unaligned accesses
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -512,7 +512,8 @@ static void __init map_mem(pgd_t *pgdp)
 		 * if MTE is present. Otherwise, it has the same attributes as
 		 * PAGE_KERNEL.
 		 */
-		__map_memblock(pgdp, start, end, PAGE_KERNEL_TAGGED, flags);
+		__map_memblock(pgdp, start, end, pgprot_tagged(PAGE_KERNEL),
+			       flags);
 	}
 
 	/*
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -912,6 +912,10 @@ static inline void ptep_modify_prot_comm
 #define pgprot_device pgprot_noncached
 #endif
 
+#ifndef pgprot_mhp
+#define pgprot_mhp(prot)	(prot)
+#endif
+
 #ifdef CONFIG_MMU
 #ifndef pgprot_modify
 #define pgprot_modify pgprot_modify
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1019,7 +1019,7 @@ static int online_memory_block(struct me
  */
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
-	struct mhp_params params = { .pgprot = PAGE_KERNEL };
+	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	u64 start, size;
 	bool new_node = false;
 	int ret;


