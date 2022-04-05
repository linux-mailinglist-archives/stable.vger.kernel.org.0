Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CE54F2BFA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbiDEIyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiDEIci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D00D8D688;
        Tue,  5 Apr 2022 01:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A8CD60FFC;
        Tue,  5 Apr 2022 08:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B84C385A1;
        Tue,  5 Apr 2022 08:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147118;
        bh=Ytr58gnACPtIgX8wj6A+Rgu50Y/LfhHdm8jAbP6A5yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHBnmKL/AySjloMP3Y4tECs50M9+efQFOXPGXndCiYCGmjr3AC9MjDIhGcHLXsFJU
         XdT9CJ6O1HK0F2fMPQ42pw0LvJpZnrRP81uqMgWXir+tyBlPJyd0QBN+1+fLFmijDV
         7x9T96BPSh24QOcUrHIl1OAwLOf1y95VkvEQi5ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jingwen <chenjingwen6@huawei.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.17 0960/1126] powerpc/kasan: Fix early region not updated correctly
Date:   Tue,  5 Apr 2022 09:28:27 +0200
Message-Id: <20220405070435.684837161@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jingwen <chenjingwen6@huawei.com>

commit dd75080aa8409ce10d50fb58981c6b59bf8707d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/kasan/kasan_init_32.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -83,13 +83,12 @@ void __init
 kasan_update_early_region(unsigned long k_start, unsigned long k_end, pte_t pte)
 {
 	unsigned long k_cur;
-	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
 	for (k_cur = k_start; k_cur != k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_off_k(k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 
-		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
+		if (pte_page(*ptep) != virt_to_page(lm_alias(kasan_early_shadow_page)))
 			continue;
 
 		__set_pte_at(&init_mm, k_cur, ptep, pte, 0);


