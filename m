Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373C46A09B5
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbjBWNJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbjBWNJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B29144AD
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A969B81A1D
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82BFC4339C;
        Thu, 23 Feb 2023 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157756;
        bh=Vvk/BPWyvdVIcXoy0Fg+7Jwb3eNts2VECN1e8TTLIbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLoIC0xiVo+bX9AVEY+k9vFf1ELrtjhXTaN1mRdrJAMInLOgQqUYpE/I1hn6CZDZ+
         /HXNcwKwGosOv5petLUJln4c+gtzp7Jd+HnMTvJjjZexCOC/aFfuTpNawjXLoXfYG0
         0VYU6eeBju4x8RR5nxDwQ4zByahXxRmS3TUJIcSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sachin Sant <sachinp@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/46] powerpc/64s/radix: Fix RWX mapping with relocated kernel
Date:   Thu, 23 Feb 2023 14:06:33 +0100
Message-Id: <20230223130432.788565821@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

[ Upstream commit 111bcb37385353f0510e5847d5abcd1c613dba23 ]

If a relocatable kernel is loaded at a non-zero address and told not to
relocate to zero (kdump or RELOCATABLE_TEST), the mapping of the
interrupt code at zero is left with RWX permissions.

That is a security weakness, and leads to a warning at boot if
CONFIG_DEBUG_WX is enabled:

  powerpc/mm: Found insecure W+X mapping at address 00000000056435bc/0xc000000000000000
  WARNING: CPU: 1 PID: 1 at arch/powerpc/mm/ptdump/ptdump.c:193 note_page+0x484/0x4c0
  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.2.0-rc1-00001-g8ae8e98aea82-dirty #175
  Hardware name: IBM pSeries (emulated by qemu) POWER9 (raw) 0x4e1202 0xf000005 of:SLOF,git-dd0dca hv:linux,kvm pSeries
  NIP:  c0000000004a1c34 LR: c0000000004a1c30 CTR: 0000000000000000
  REGS: c000000003503770 TRAP: 0700   Not tainted  (6.2.0-rc1-00001-g8ae8e98aea82-dirty)
  MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 24000220  XER: 00000000
  CFAR: c000000000545a58 IRQMASK: 0
  ...
  NIP note_page+0x484/0x4c0
  LR  note_page+0x480/0x4c0
  Call Trace:
    note_page+0x480/0x4c0 (unreliable)
    ptdump_pmd_entry+0xc8/0x100
    walk_pgd_range+0x618/0xab0
    walk_page_range_novma+0x74/0xc0
    ptdump_walk_pgd+0x98/0x170
    ptdump_check_wx+0x94/0x100
    mark_rodata_ro+0x30/0x70
    kernel_init+0x78/0x1a0
    ret_from_kernel_thread+0x5c/0x64

The fix has two parts. Firstly the pages from zero up to the end of
interrupts need to be marked read-only, so that they are left with R-X
permissions. Secondly the mapping logic needs to be taught to ensure
there is a page boundary at the end of the interrupt region, so that the
permission change only applies to the interrupt text, and not the region
following it.

Fixes: c55d7b5e6426 ("powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230110124753.1325426-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 5a2384ed17279..26245aaf12b8b 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -234,6 +234,14 @@ void radix__mark_rodata_ro(void)
 	end = (unsigned long)__end_rodata;
 
 	radix__change_memory_range(start, end, _PAGE_WRITE);
+
+	for (start = PAGE_OFFSET; start < (unsigned long)_stext; start += PAGE_SIZE) {
+		end = start + PAGE_SIZE;
+		if (overlaps_interrupt_vector_text(start, end))
+			radix__change_memory_range(start, end, _PAGE_WRITE);
+		else
+			break;
+	}
 }
 
 void radix__mark_initmem_nx(void)
@@ -268,6 +276,11 @@ static unsigned long next_boundary(unsigned long addr, unsigned long end)
 
 	// Relocatable kernel running at non-zero real address
 	if (stext_phys != 0) {
+		// The end of interrupts code at zero is a rodata boundary
+		unsigned long end_intr = __pa_symbol(__end_interrupts) - stext_phys;
+		if (addr < end_intr)
+			return end_intr;
+
 		// Start of relocated kernel text is a rodata boundary
 		if (addr < stext_phys)
 			return stext_phys;
-- 
2.39.0



