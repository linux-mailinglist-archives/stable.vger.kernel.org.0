Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6283F4A4233
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359267AbiAaLLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359809AbiAaLH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BCAC061367;
        Mon, 31 Jan 2022 03:04:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75AEAB82A4D;
        Mon, 31 Jan 2022 11:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7307C340EE;
        Mon, 31 Jan 2022 11:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627096;
        bh=CteQb1qQvAZdJIx0midhc1gCQV+tj85w1m+T+Aatu+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIEWYeDyM5pBhipxG+nr8Ki716q6ZPTCh2MCrCJu6/DmC/5bKF4/CBpRu6FSycKHU
         7vcwTItPg0AU+olW5PH9zt0UmMQWiyqn8R8SZKk2+nS0ZDpTgjKzvIJHzSX0Gm1sOx
         pKD9QaGMIyGVnZjKkftYLfsP1VQBs+NOmXzRKKGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 040/100] powerpc/32s: Fix kasan_init_region() for KASAN
Date:   Mon, 31 Jan 2022 11:56:01 +0100
Message-Id: <20220131105221.789775518@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit d37823c3528e5e0705fc7746bcbc2afffb619259 upstream.

It has been reported some configuration where the kernel doesn't
boot with KASAN enabled.

This is due to wrong BAT allocation for the KASAN area:

	---[ Data Block Address Translation ]---
	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw      m
	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw      m
	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw      m
	3: 0xf8000000-0xf9ffffff 0x2a000000        32M Kernel rw      m
	4: 0xfa000000-0xfdffffff 0x2c000000        64M Kernel rw      m

A BAT must have both virtual and physical addresses alignment matching
the size of the BAT. This is not the case for BAT 4 above.

Fix kasan_init_region() by using block_size() function that is in
book3s32/mmu.c. To be able to reuse it here, make it non static and
change its name to bat_block_size() in order to avoid name conflict
with block_size() defined in <linux/blkdev.h>

Also reuse find_free_bat() to avoid an error message from setbat()
when no BAT is available.

And allocate memory outside of linear memory mapping to avoid
wasting that precious space.

With this change we get correct alignment for BATs and KASAN shadow
memory is allocated outside the linear memory space.

	---[ Data Block Address Translation ]---
	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw
	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw
	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw
	3: 0xf8000000-0xfbffffff 0x7c000000        64M Kernel rw
	4: 0xfc000000-0xfdffffff 0x7a000000        32M Kernel rw

Fixes: 7974c4732642 ("powerpc/32s: Implement dedicated kasan_init_region()")
Cc: stable@vger.kernel.org
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/7a50ef902494d1325227d47d33dada01e52e5518.1641818726.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h |    2 
 arch/powerpc/mm/book3s32/mmu.c                |   10 ++--
 arch/powerpc/mm/kasan/book3s_32.c             |   57 +++++++++++++-------------
 3 files changed, 37 insertions(+), 32 deletions(-)

--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -102,6 +102,8 @@ extern s32 patch__hash_page_B, patch__ha
 extern s32 patch__flush_hash_A0, patch__flush_hash_A1, patch__flush_hash_A2;
 extern s32 patch__flush_hash_B;
 
+int __init find_free_bat(void);
+unsigned int bat_block_size(unsigned long base, unsigned long top);
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -72,7 +72,7 @@ unsigned long p_block_mapped(phys_addr_t
 	return 0;
 }
 
-static int find_free_bat(void)
+int __init find_free_bat(void)
 {
 	int b;
 	int n = mmu_has_feature(MMU_FTR_USE_HIGH_BATS) ? 8 : 4;
@@ -96,7 +96,7 @@ static int find_free_bat(void)
  * - block size has to be a power of two. This is calculated by finding the
  *   highest bit set to 1.
  */
-static unsigned int block_size(unsigned long base, unsigned long top)
+unsigned int bat_block_size(unsigned long base, unsigned long top)
 {
 	unsigned int max_size = SZ_256M;
 	unsigned int base_shift = (ffs(base) - 1) & 31;
@@ -141,7 +141,7 @@ static unsigned long __init __mmu_mapin_
 	int idx;
 
 	while ((idx = find_free_bat()) != -1 && base != top) {
-		unsigned int size = block_size(base, top);
+		unsigned int size = bat_block_size(base, top);
 
 		if (size < 128 << 10)
 			break;
@@ -206,12 +206,12 @@ void mmu_mark_initmem_nx(void)
 	unsigned long size;
 
 	for (i = 0; i < nb - 1 && base < top;) {
-		size = block_size(base, top);
+		size = bat_block_size(base, top);
 		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
 		base += size;
 	}
 	if (base < top) {
-		size = block_size(base, top);
+		size = bat_block_size(base, top);
 		if ((top - base) > size) {
 			size <<= 1;
 			if (strict_kernel_rwx_enabled() && base + size > border)
--- a/arch/powerpc/mm/kasan/book3s_32.c
+++ b/arch/powerpc/mm/kasan/book3s_32.c
@@ -10,48 +10,51 @@ int __init kasan_init_region(void *start
 {
 	unsigned long k_start = (unsigned long)kasan_mem_to_shadow(start);
 	unsigned long k_end = (unsigned long)kasan_mem_to_shadow(start + size);
-	unsigned long k_cur = k_start;
-	int k_size = k_end - k_start;
-	int k_size_base = 1 << (ffs(k_size) - 1);
+	unsigned long k_nobat = k_start;
+	unsigned long k_cur;
+	phys_addr_t phys;
 	int ret;
-	void *block;
 
-	block = memblock_alloc(k_size, k_size_base);
+	while (k_nobat < k_end) {
+		unsigned int k_size = bat_block_size(k_nobat, k_end);
+		int idx = find_free_bat();
+
+		if (idx == -1)
+			break;
+		if (k_size < SZ_128K)
+			break;
+		phys = memblock_phys_alloc_range(k_size, k_size, 0,
+						 MEMBLOCK_ALLOC_ANYWHERE);
+		if (!phys)
+			break;
 
-	if (block && k_size_base >= SZ_128K && k_start == ALIGN(k_start, k_size_base)) {
-		int shift = ffs(k_size - k_size_base);
-		int k_size_more = shift ? 1 << (shift - 1) : 0;
-
-		setbat(-1, k_start, __pa(block), k_size_base, PAGE_KERNEL);
-		if (k_size_more >= SZ_128K)
-			setbat(-1, k_start + k_size_base, __pa(block) + k_size_base,
-			       k_size_more, PAGE_KERNEL);
-		if (v_block_mapped(k_start))
-			k_cur = k_start + k_size_base;
-		if (v_block_mapped(k_start + k_size_base))
-			k_cur = k_start + k_size_base + k_size_more;
-
-		update_bats();
+		setbat(idx, k_nobat, phys, k_size, PAGE_KERNEL);
+		k_nobat += k_size;
 	}
+	if (k_nobat != k_start)
+		update_bats();
 
-	if (!block)
-		block = memblock_alloc(k_size, PAGE_SIZE);
-	if (!block)
-		return -ENOMEM;
+	if (k_nobat < k_end) {
+		phys = memblock_phys_alloc_range(k_end - k_nobat, PAGE_SIZE, 0,
+						 MEMBLOCK_ALLOC_ANYWHERE);
+		if (!phys)
+			return -ENOMEM;
+	}
 
 	ret = kasan_init_shadow_page_tables(k_start, k_end);
 	if (ret)
 		return ret;
 
-	kasan_update_early_region(k_start, k_cur, __pte(0));
+	kasan_update_early_region(k_start, k_nobat, __pte(0));
 
-	for (; k_cur < k_end; k_cur += PAGE_SIZE) {
+	for (k_cur = k_nobat; k_cur < k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_off_k(k_cur);
-		void *va = block + k_cur - k_start;
-		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
+		pte_t pte = pfn_pte(PHYS_PFN(phys + k_cur - k_nobat), PAGE_KERNEL);
 
 		__set_pte_at(&init_mm, k_cur, pte_offset_kernel(pmd, k_cur), pte, 0);
 	}
 	flush_tlb_kernel_range(k_start, k_end);
+	memset(kasan_mem_to_shadow(start), 0, k_end - k_start);
+
 	return 0;
 }


