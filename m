Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDBF627EA4
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbiKNMt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237319AbiKNMt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:49:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ECAC33
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:49:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CAA7B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94932C433D6;
        Mon, 14 Nov 2022 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430194;
        bh=s2u1xacqmp7otcAN4GN4aRpzID5Qx/vmpHoWmu/UtkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLUXRPfHoGZ1E6zzsBWsf3d08hGdi1IyDNsF6Xr9qHJgbB6NCnlsYaxl4HvZxclJ6
         9v7iTbuIlwWImGUollGUEme0Fo5dbTYwBPTXx8Dr0hmuxgWh/lunbNRi+I2+8b8+rL
         WvYWpNPlBXLZeyJpPg/luA9rE6Xx8zVqlLoOJDs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
        Evgenii Shatokhin <e.shatokhin@yadro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/95] riscv: fix reserved memory setup
Date:   Mon, 14 Nov 2022 13:45:48 +0100
Message-Id: <20221114124444.768431777@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 50e63dd8ed92045eb70a72d7ec725488320fb68b ]

Currently, RISC-V sets up reserved memory using the "early" copy of the
device tree. As a result, when trying to get a reserved memory region
using of_reserved_mem_lookup(), the pointer to reserved memory regions
is using the early, pre-virtual-memory address which causes a kernel
panic when trying to use the buffer's name:

 Unable to handle kernel paging request at virtual address 00000000401c31ac
 Oops [#1]
 Modules linked in:
 CPU: 0 PID: 0 Comm: swapper Not tainted 6.0.0-rc1-00001-g0d9d6953d834 #1
 Hardware name: Microchip PolarFire-SoC Icicle Kit (DT)
 epc : string+0x4a/0xea
  ra : vsnprintf+0x1e4/0x336
 epc : ffffffff80335ea0 ra : ffffffff80338936 sp : ffffffff81203be0
  gp : ffffffff812e0a98 tp : ffffffff8120de40 t0 : 0000000000000000
  t1 : ffffffff81203e28 t2 : 7265736572203a46 s0 : ffffffff81203c20
  s1 : ffffffff81203e28 a0 : ffffffff81203d22 a1 : 0000000000000000
  a2 : ffffffff81203d08 a3 : 0000000081203d21 a4 : ffffffffffffffff
  a5 : 00000000401c31ac a6 : ffff0a00ffffff04 a7 : ffffffffffffffff
  s2 : ffffffff81203d08 s3 : ffffffff81203d00 s4 : 0000000000000008
  s5 : ffffffff000000ff s6 : 0000000000ffffff s7 : 00000000ffffff00
  s8 : ffffffff80d9821a s9 : ffffffff81203d22 s10: 0000000000000002
  s11: ffffffff80d9821c t3 : ffffffff812f3617 t4 : ffffffff812f3617
  t5 : ffffffff812f3618 t6 : ffffffff81203d08
 status: 0000000200000100 badaddr: 00000000401c31ac cause: 000000000000000d
 [<ffffffff80338936>] vsnprintf+0x1e4/0x336
 [<ffffffff80055ae2>] vprintk_store+0xf6/0x344
 [<ffffffff80055d86>] vprintk_emit+0x56/0x192
 [<ffffffff80055ed8>] vprintk_default+0x16/0x1e
 [<ffffffff800563d2>] vprintk+0x72/0x80
 [<ffffffff806813b2>] _printk+0x36/0x50
 [<ffffffff8068af48>] print_reserved_mem+0x1c/0x24
 [<ffffffff808057ec>] paging_init+0x528/0x5bc
 [<ffffffff808031ae>] setup_arch+0xd0/0x592
 [<ffffffff8080070e>] start_kernel+0x82/0x73c

early_init_fdt_scan_reserved_mem() takes no arguments as it operates on
initial_boot_params, which is populated by early_init_dt_verify(). On
RISC-V, early_init_dt_verify() is called twice. Once, directly, in
setup_arch() if CONFIG_BUILTIN_DTB is not enabled and once indirectly,
very early in the boot process, by parse_dtb() when it calls
early_init_dt_scan_nodes().

This first call uses dtb_early_va to set initial_boot_params, which is
not usable later in the boot process when
early_init_fdt_scan_reserved_mem() is called. On arm64 for example, the
corresponding call to early_init_dt_scan_nodes() uses fixmap addresses
and doesn't suffer the same fate.

Move early_init_fdt_scan_reserved_mem() further along the boot sequence,
after the direct call to early_init_dt_verify() in setup_arch() so that
the names use the correct virtual memory addresses. The above supposed
that CONFIG_BUILTIN_DTB was not set, but should work equally in the case
where it is - unflatted_and_copy_device_tree() also updates
initial_boot_params.

Reported-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Reported-by: Evgenii Shatokhin <e.shatokhin@yadro.com>
Link: https://lore.kernel.org/linux-riscv/f8e67f82-103d-156c-deb0-d6d6e2756f5e@microchip.com/
Fixes: 922b0375fc93 ("riscv: Fix memblock reservation for device tree blob")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Evgenii Shatokhin <e.shatokhin@yadro.com>
Link: https://lore.kernel.org/r/20221107151524.3941467-1-conor.dooley@microchip.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 1 +
 arch/riscv/mm/init.c      | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 57e1ab036edf..8e78a8ab6a34 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -96,6 +96,7 @@ void __init setup_arch(char **cmdline_p)
 	else
 		pr_err("No DTB found in kernel mappings\n");
 #endif
+	early_init_fdt_scan_reserved_mem();
 	misc_mem_init();
 
 #ifdef CONFIG_SWIOTLB
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index b6ab6a18dc1a..6c2f38aac544 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -208,7 +208,6 @@ void __init setup_bootmem(void)
 	 */
 	memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
 
-	early_init_fdt_scan_reserved_mem();
 	dma_contiguous_reserve(dma32_phys_limit);
 	memblock_allow_resize();
 	memblock_dump_all();
-- 
2.35.1



