Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA63BE6876
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731832AbfJ0VVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731824AbfJ0VVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD5F2070B;
        Sun, 27 Oct 2019 21:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211259;
        bh=6ONrbi08EMB0YRBly9ROiwhZSMlJi2W3Bul2pRmULnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8Hfgyi10967sczCuVKzabxmSZaPXZn5hVXKbpQ/dnJptprZ/j0bo5BBfOF28xpCE
         Y17YkJIQqXN5+XUhs86jZiZ5zzm5kX1iOGbcXcV6CvY8vB2b2H/OwYuGxnrotYSEp3
         POP4ixNImzaPp3AGGekyverXlt88ZVteNqNl9L44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Bin Meng <bmeng.cn@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 044/197] riscv: Fix memblock reservation for device tree blob
Date:   Sun, 27 Oct 2019 21:59:22 +0100
Message-Id: <20191027203354.086177321@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Albert Ou <aou@eecs.berkeley.edu>

[ Upstream commit 922b0375fc93fb1a20c5617e37c389c26bbccb70 ]

This fixes an error with how the FDT blob is reserved in memblock.
An incorrect physical address calculation exposed the FDT header to
unintended corruption, which typically manifested with of_fdt_raw_init()
faulting during late boot after fdt_totalsize() returned a wrong value.
Systems with smaller physical memory sizes more frequently trigger this
issue, as the kernel is more likely to allocate from the DMA32 zone
where bbl places the DTB after the kernel image.

Commit 671f9a3e2e24 ("RISC-V: Setup initial page tables in two stages")
changed the mapping of the DTB to reside in the fixmap area.
Consequently, early_init_fdt_reserve_self() cannot be used anymore in
setup_bootmem() since it relies on __pa() to derive a physical address,
which does not work with dtb_early_va that is no longer a valid kernel
logical address.

The reserved[0x1] region shows the effect of the pointer underflow
resulting from the __pa(initial_boot_params) offset subtraction:

[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x000000001fe00000 reserved size = 0x0000000000a2e514
[    0.000000]  memory.cnt  = 0x1
[    0.000000]  memory[0x0]     [0x0000000080200000-0x000000009fffffff], 0x000000001fe00000 bytes flags: 0x0
[    0.000000]  reserved.cnt  = 0x2
[    0.000000]  reserved[0x0]   [0x0000000080200000-0x0000000080c2dfeb], 0x0000000000a2dfec bytes flags: 0x0
[    0.000000]  reserved[0x1]   [0xfffffff080100000-0xfffffff080100527], 0x0000000000000528 bytes flags: 0x0

With the fix applied:

[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x000000001fe00000 reserved size = 0x0000000000a2e514
[    0.000000]  memory.cnt  = 0x1
[    0.000000]  memory[0x0]     [0x0000000080200000-0x000000009fffffff], 0x000000001fe00000 bytes flags: 0x0
[    0.000000]  reserved.cnt  = 0x2
[    0.000000]  reserved[0x0]   [0x0000000080200000-0x0000000080c2dfeb], 0x0000000000a2dfec bytes flags: 0x0
[    0.000000]  reserved[0x1]   [0x0000000080e00000-0x0000000080e00527], 0x0000000000000528 bytes flags: 0x0

Fixes: 671f9a3e2e24 ("RISC-V: Setup initial page tables in two stages")
Signed-off-by: Albert Ou <aou@eecs.berkeley.edu>
Tested-by: Bin Meng <bmeng.cn@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 42bf939693d34..ed9cd9944d4f9 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -11,6 +11,7 @@
 #include <linux/swap.h>
 #include <linux/sizes.h>
 #include <linux/of_fdt.h>
+#include <linux/libfdt.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
@@ -82,6 +83,8 @@ static void __init setup_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+static phys_addr_t dtb_early_pa __initdata;
+
 void __init setup_bootmem(void)
 {
 	struct memblock_region *reg;
@@ -117,7 +120,12 @@ void __init setup_bootmem(void)
 	setup_initrd();
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-	early_init_fdt_reserve_self();
+	/*
+	 * Avoid using early_init_fdt_reserve_self() since __pa() does
+	 * not work for DTB pointers that are fixmap addresses
+	 */
+	memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
+
 	early_init_fdt_scan_reserved_mem();
 	memblock_allow_resize();
 	memblock_dump_all();
@@ -393,6 +401,8 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 
 	/* Save pointer to DTB for early FDT parsing */
 	dtb_early_va = (void *)fix_to_virt(FIX_FDT) + (dtb_pa & ~PAGE_MASK);
+	/* Save physical address for memblock reservation */
+	dtb_early_pa = dtb_pa;
 }
 
 static void __init setup_vm_final(void)
-- 
2.20.1



