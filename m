Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475D54418C5
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhKAJvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234788AbhKAJtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:49:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 234ED6124D;
        Mon,  1 Nov 2021 09:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759108;
        bh=3kpXCsn6ZY/dtNru9H4Ega8JvaVx+u4Q8fjD4LGN1ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpIWEuSzOEf+UjLHT1MWhO7NDjMr5gijGVgmXZnVc/TiBUWrXo7E3hSANL0hDRe4s
         1Phiep6ZptMvHXCSDEpw9QdBM+eQUvwFUySPfmkDoXK3aL/fDN7Ah6vFUtI7AwCAIF
         sj+wEuTKsRPZ25GiyAwVKGNwn+KgDg4FrZhizNY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.14 119/125] riscv: Do not re-populate shadow memory with kasan_populate_early_shadow
Date:   Mon,  1 Nov 2021 10:18:12 +0100
Message-Id: <20211101082555.560628157@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexandre.ghiti@canonical.com>

commit cf11d01135ea1ff7fddb612033e3cb5cde279ff2 upstream.

When calling this function, all the shadow memory is already populated
with kasan_early_shadow_pte which has PAGE_KERNEL protection.
kasan_populate_early_shadow write-protects the mapping of the range
of addresses passed in argument in zero_pte_populate, which actually
write-protects all the shadow memory mapping since kasan_early_shadow_pte
is used for all the shadow memory at this point. And then when using
memblock API to populate the shadow memory, the first write access to the
kernel stack triggers a trap. This becomes visible with the next commit
that contains a fix for asan-stack.

We already manually populate all the shadow memory in kasan_early_init
and we write-protect kasan_early_shadow_pte at the end of kasan_init
which makes the calls to kasan_populate_early_shadow superfluous so
we can remove them.

Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Fixes: e178d670f251 ("riscv/kasan: add KASAN_VMALLOC support")
Fixes: 8ad8b72721d0 ("riscv: Add KASAN support")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/kasan_init.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -172,21 +172,10 @@ void __init kasan_init(void)
 	phys_addr_t p_start, p_end;
 	u64 i;
 
-	/*
-	 * Populate all kernel virtual address space with kasan_early_shadow_page
-	 * except for the linear mapping and the modules/kernel/BPF mapping.
-	 */
-	kasan_populate_early_shadow((void *)KASAN_SHADOW_START,
-				    (void *)kasan_mem_to_shadow((void *)
-								VMEMMAP_END));
 	if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
 		kasan_shallow_populate(
 			(void *)kasan_mem_to_shadow((void *)VMALLOC_START),
 			(void *)kasan_mem_to_shadow((void *)VMALLOC_END));
-	else
-		kasan_populate_early_shadow(
-			(void *)kasan_mem_to_shadow((void *)VMALLOC_START),
-			(void *)kasan_mem_to_shadow((void *)VMALLOC_END));
 
 	/* Populate the linear mapping */
 	for_each_mem_range(i, &p_start, &p_end) {


