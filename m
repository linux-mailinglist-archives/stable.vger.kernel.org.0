Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78B16A0A03
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjBWNM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjBWNM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:12:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C1657089
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F8061707
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ED2C433D2;
        Thu, 23 Feb 2023 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157906;
        bh=/IJVFuwJ+G1RXNs+h+WJlikb8W9ISDdwMOwuPkXl+Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qvr7Osob3TBM/P2Js5pL8ZNHOUzD67n/Y8X0SjjCMlc4fRyTcPsT7hJmAXX3b5byJ
         3BfCvYYDlkBZNwQOVQTCJR0tH5CdJz/XqNuAVcET6pd6zSVQEAAV2fx9raoT3JbkDl
         GpdIpqC+pE7JomFlYEo0mQzLl62iWc6SAl9/rOlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/36] powerpc/64s/radix: Fix crash with unaligned relocated kernel
Date:   Thu, 23 Feb 2023 14:06:55 +0100
Message-Id: <20230223130429.963495386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 98d0219e043e09013e883eacde3b93e0b2bf944d ]

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
Stable-dep-of: 111bcb373853 ("powerpc/64s/radix: Fix RWX mapping with relocated kernel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 52e27fd995da7..b848f9e9f6335 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -260,6 +260,17 @@ print_mapping(unsigned long start, unsigned long end, unsigned long size, bool e
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
-- 
2.39.0



