Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D6368D5D9
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjBGLm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjBGLmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:42:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F3F3928E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 03:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C16761350
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BF1C433EF;
        Tue,  7 Feb 2023 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675770137;
        bh=H2Y44mzxHcUzk2oeyxsZX+BVJlW+N+ViX6rJgfMP1Z4=;
        h=Subject:To:Cc:From:Date:From;
        b=JA/IiWhncbJSl2EtR9FHW8g/r70xlL+5SN2Ai6LSJwLGYvH4WdwZ+jFcfWtXU2T6r
         ILvQJJzPnnppDidYBOvABrw0FAtEqPieauHmQcWXK18MSqm75KHaBMLG9Fh5KVgOUH
         EYo28k2kVgmN2jnFYmL+1eaSuNb76JNt35rZN3fo=
Subject: FAILED: patch "[PATCH] powerpc/64s/radix: Fix crash with unaligned relocated kernel" failed to apply to 5.10-stable tree
To:     mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 12:42:12 +0100
Message-ID: <167577013210129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

98d0219e043e ("powerpc/64s/radix: Fix crash with unaligned relocated kernel")
b150a4d12b91 ("powerpc/vmlinux.lds: Add an explicit symbol for the SRWX boundary")
331771e836e6 ("powerpc/vmlinux.lds: Ensure STRICT_ALIGN_SIZE is at least page aligned")
2a0fb3c155c9 ("powerpc/32: Set an IBAT covering up to _einittext during init")
c4a22611bf6c ("powerpc/603: Use SPRN_SDR1 to store the pgdir phys address")
035b19a15a98 ("powerpc/32s: Always map kernel text and rodata with BATs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 98d0219e043e09013e883eacde3b93e0b2bf944d Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Tue, 10 Jan 2023 23:47:52 +1100
Subject: [PATCH] powerpc/64s/radix: Fix crash with unaligned relocated kernel

If a relocatable kernel is loaded at an address that is not 2MB aligned
and told not to relocate to zero, the kernel can crash due to
mark_rodata_ro() incorrectly changing some read-write data to read-only.

Scenarios where the misalignment can occur are when the kernel is
loaded by kdump or using the RELOCATABLE_TEST config option.

Example crash with the kernel loaded at 5MB:

  Run /sbin/init as init process
  BUG: Unable to handle kernel data access on write at 0xc000000000452000
  Faulting instruction address: 0xc0000000005b6730
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
  CPU: 1 PID: 1 Comm: init Not tainted 6.2.0-rc1-00011-g349188be4841 #166
  Hardware name: IBM pSeries (emulated by qemu) POWER9 (raw) 0x4e1202 0xf000005 of:SLOF,git-5b4c5a hv:linux,kvm pSeries
  NIP:  c0000000005b6730 LR: c000000000ae9ab8 CTR: 0000000000000380
  REGS: c000000004503250 TRAP: 0300   Not tainted  (6.2.0-rc1-00011-g349188be4841)
  MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 44288480  XER: 00000000
  CFAR: c0000000005b66ec DAR: c000000000452000 DSISR: 0a000000 IRQMASK: 0
  ...
  NIP memset+0x68/0x104
  LR  zero_user_segments.constprop.0+0xa8/0xf0
  Call Trace:
    ext4_mpage_readpages+0x7f8/0x830
    ext4_readahead+0x48/0x60
    read_pages+0xb8/0x380
    page_cache_ra_unbounded+0x19c/0x250
    filemap_fault+0x58c/0xae0
    __do_fault+0x60/0x100
    __handle_mm_fault+0x1230/0x1a40
    handle_mm_fault+0x120/0x300
    ___do_page_fault+0x20c/0xa80
    do_page_fault+0x30/0xc0
    data_access_common_virt+0x210/0x220

This happens because mark_rodata_ro() tries to change permissions on the
range _stext..__end_rodata, but _stext sits in the middle of the 2MB
page from 4MB to 6MB:

  radix-mmu: Mapped 0x0000000000000000-0x0000000000200000 with 2.00 MiB pages (exec)
  radix-mmu: Mapped 0x0000000000200000-0x0000000000400000 with 2.00 MiB pages
  radix-mmu: Mapped 0x0000000000400000-0x0000000002400000 with 2.00 MiB pages (exec)

The logic that changes the permissions assumes the linear mapping was
split correctly at boot, so it marks the entire 2MB page read-only. That
leads to the write fault above.

To fix it, the boot time mapping logic needs to consider that if the
kernel is running at a non-zero address then _stext is a boundary where
it must split the mapping.

That leads to the mapping being split correctly, allowing the rodata
permission change to take happen correctly, with no spillover:

  radix-mmu: Mapped 0x0000000000000000-0x0000000000200000 with 2.00 MiB pages (exec)
  radix-mmu: Mapped 0x0000000000200000-0x0000000000400000 with 2.00 MiB pages
  radix-mmu: Mapped 0x0000000000400000-0x0000000000500000 with 64.0 KiB pages
  radix-mmu: Mapped 0x0000000000500000-0x0000000000600000 with 64.0 KiB pages (exec)
  radix-mmu: Mapped 0x0000000000600000-0x0000000002400000 with 2.00 MiB pages (exec)

If the kernel is loaded at a 2MB aligned address, the mapping continues
to use 2MB pages as before:

  radix-mmu: Mapped 0x0000000000000000-0x0000000000200000 with 2.00 MiB pages (exec)
  radix-mmu: Mapped 0x0000000000200000-0x0000000000400000 with 2.00 MiB pages
  radix-mmu: Mapped 0x0000000000400000-0x0000000002c00000 with 2.00 MiB pages (exec)
  radix-mmu: Mapped 0x0000000002c00000-0x0000000100000000 with 2.00 MiB pages

Fixes: c55d7b5e6426 ("powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230110124753.1325426-1-mpe@ellerman.id.au

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cac727b01799..5a2384ed1727 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -262,6 +262,17 @@ print_mapping(unsigned long start, unsigned long end, unsigned long size, bool e
 static unsigned long next_boundary(unsigned long addr, unsigned long end)
 {
 #ifdef CONFIG_STRICT_KERNEL_RWX
+	unsigned long stext_phys;
+
+	stext_phys = __pa_symbol(_stext);
+
+	// Relocatable kernel running at non-zero real address
+	if (stext_phys != 0) {
+		// Start of relocated kernel text is a rodata boundary
+		if (addr < stext_phys)
+			return stext_phys;
+	}
+
 	if (addr < __pa_symbol(__srwx_boundary))
 		return __pa_symbol(__srwx_boundary);
 #endif

