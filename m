Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1614F04C2
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244392AbiDBQP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 12:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357819AbiDBQPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 12:15:54 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0421BE0F8;
        Sat,  2 Apr 2022 09:13:57 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4KW2Cm3Wbzz9sSX;
        Sat,  2 Apr 2022 18:13:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uGOm-OX4ahYj; Sat,  2 Apr 2022 18:13:56 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4KW2Cm2WMwz9sSQ;
        Sat,  2 Apr 2022 18:13:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 42F8E8B76D;
        Sat,  2 Apr 2022 18:13:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 2GrwgdPFsQWp; Sat,  2 Apr 2022 18:13:56 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.137])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E50368B768;
        Sat,  2 Apr 2022 18:13:55 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 232GDkxx008659
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 2 Apr 2022 18:13:46 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 232GDjBW008657;
        Sat, 2 Apr 2022 18:13:45 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Chen Jingwen <chenjingwen6@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] [Rebased for 5.4] powerpc/kasan: Fix early region not updated correctly
Date:   Sat,  2 Apr 2022 18:13:31 +0200
Message-Id: <fc39c36ea92e03ed5eb218ddbe83b34361034d9d.1648915982.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1648916010; l=3434; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=Hq5fiOviUcMicNmDDK52z8tOXSe3kJkV1ZNLLWvxmjM=; b=MGfzrBP4AIGBuQCs9lA5I89BspUHZyTRwCnfjoJQivd4GjsGTB0UOEEEcO92OKqAlE9YrYd+PrR/ 5+l+2RPNDunazBsAqQx9uOftbbbERbPTGWey61v/+18CQmsfaboZ
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jingwen <chenjingwen6@huawei.com>

This is backport for 5.4

Upstream commit 5647a94a26e352beed61788b46e035d9d12664cd

The shadow's page table is not updated when PTE_RPN_SHIFT is 24
and PAGE_SHIFT is 12. It not only causes false positives but
also false negative as shown the following text.

Fix it by bringing the logic of kasan_early_shadow_page_entry here.

1. False Positive:
==================================================================
BUG: KASAN: vmalloc-out-of-bounds in pcpu_alloc+0x508/0xa50
Write of size 16 at addr f57f3be0 by task swapper/0/1

CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-12267-gdebe436e77c7 #1
Call Trace:
[c80d1c20] [c07fe7b8] dump_stack_lvl+0x4c/0x6c (unreliable)
[c80d1c40] [c02ff668] print_address_description.constprop.0+0x88/0x300
[c80d1c70] [c02ff45c] kasan_report+0x1ec/0x200
[c80d1cb0] [c0300b20] kasan_check_range+0x160/0x2f0
[c80d1cc0] [c03018a4] memset+0x34/0x90
[c80d1ce0] [c0280108] pcpu_alloc+0x508/0xa50
[c80d1d40] [c02fd7bc] __kmem_cache_create+0xfc/0x570
[c80d1d70] [c0283d64] kmem_cache_create_usercopy+0x274/0x3e0
[c80d1db0] [c2036580] init_sd+0xc4/0x1d0
[c80d1de0] [c00044a0] do_one_initcall+0xc0/0x33c
[c80d1eb0] [c2001624] kernel_init_freeable+0x2c8/0x384
[c80d1ef0] [c0004b14] kernel_init+0x24/0x170
[c80d1f10] [c001b26c] ret_from_kernel_thread+0x5c/0x64

Memory state around the buggy address:
 f57f3a80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 f57f3b00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>f57f3b80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                                               ^
 f57f3c00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 f57f3c80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================

2. False Negative (with KASAN tests):
==================================================================
Before fix:
    ok 45 - kmalloc_double_kzfree
    # vmalloc_oob: EXPECTATION FAILED at lib/test_kasan.c:1039
    KASAN failure expected in "((volatile char *)area)[3100]", but none occurred
    not ok 46 - vmalloc_oob
    not ok 1 - kasan

==================================================================
After fix:
    ok 1 - kasan

Fixes: cbd18991e24fe ("powerpc/mm: Fix an Oops in kasan_mmu_init()")
Cc: stable@vger.kernel.org # 5.4.x
Signed-off-by: Chen Jingwen <chenjingwen6@huawei.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211229035226.59159-1-chenjingwen6@huawei.com
[chleroy: Backport for 5.4]
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/mm/kasan/kasan_init_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/kasan/kasan_init_32.c b/arch/powerpc/mm/kasan/kasan_init_32.c
index 1cfe57b51d7e..3f78007a7282 100644
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -121,7 +121,7 @@ static void __init kasan_remap_early_shadow_ro(void)
 		pmd_t *pmd = pmd_offset(pud_offset(pgd_offset_k(k_cur), k_cur), k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 
-		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
+		if (pte_page(*ptep) != virt_to_page(lm_alias(kasan_early_shadow_page)))
 			continue;
 
 		__set_pte_at(&init_mm, k_cur, ptep, pfn_pte(PHYS_PFN(pa), prot), 0);
-- 
2.35.1

