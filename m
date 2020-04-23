Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233951B692E
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgDWXU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48550 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728201AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-0004bu-1I; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6iw-8R; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Steven Sistare" <steven.sistare@oracle.com>,
        "Pavel Tatashin" <pasha.tatashin@oracle.com>
Date:   Fri, 24 Apr 2020 00:04:47 +0100
Message-ID: <lsq.1587683028.710020660@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 060/245] x86/pti/efi: broken conversion from efi to
 kernel page table
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Tatashin <pasha.tatashin@oracle.com>

In entry_64.S we have code like this:

    /* Unconditionally use kernel CR3 for do_nmi() */
    /* %rax is saved above, so OK to clobber here */
    ALTERNATIVE "jmp 2f", "movq %cr3, %rax", X86_FEATURE_KAISER
    /* If PCID enabled, NOFLUSH now and NOFLUSH on return */
    ALTERNATIVE "", "bts $63, %rax", X86_FEATURE_PCID
    pushq   %rax
    /* mask off "user" bit of pgd address and 12 PCID bits: */
    andq    $(~(X86_CR3_PCID_ASID_MASK | KAISER_SHADOW_PGD_OFFSET)), %rax
    movq    %rax, %cr3
2:

    /* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
    call    do_nmi

With this instruction:
    andq    $(~(X86_CR3_PCID_ASID_MASK | KAISER_SHADOW_PGD_OFFSET)), %rax

We unconditionally switch from whatever our CR3 was to kernel page table.
But, in arch/x86/platform/efi/efi_64.c We temporarily set a different page
table, that does not have the kernel page table with 0x1000 offset from it.

Look in efi_thunk() and efi_thunk_set_virtual_address_map().

So, while CR3 points to the other page table, we get an NMI interrupt,
and clear 0x1000 from CR3, resulting in a bogus CR3 if the 0x1000 bit was
set.

The efi page table comes from realmode/rm/trampoline_64.S:

arch/x86/realmode/rm/trampoline_64.S

141 .bss
142 .balign PAGE_SIZE
143 GLOBAL(trampoline_pgd) .space PAGE_SIZE

Notice: alignment is PAGE_SIZE, so after applying KAISER_SHADOW_PGD_OFFSET
which equal to PAGE_SIZE, we can get a different page table.

But, even if we fix alignment, here the trampoline binary is later copied
into dynamically allocated memory in reserve_real_mode(), so we need to
fix that place as well.

Fixes: f9a1666f97b3 ("KAISER: Kernel Address Isolation")
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Adjust the Fixes field for 3.16]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/kaiser.h        | 10 ++++++++++
 arch/x86/realmode/init.c             |  4 +++-
 arch/x86/realmode/rm/trampoline_64.S |  3 ++-
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kaiser.h
+++ b/arch/x86/include/asm/kaiser.h
@@ -19,6 +19,16 @@
 
 #define KAISER_SHADOW_PGD_OFFSET 0x1000
 
+#ifdef CONFIG_PAGE_TABLE_ISOLATION
+/*
+ *  A page table address must have this alignment to stay the same when
+ *  KAISER_SHADOW_PGD_OFFSET mask is applied
+ */
+#define KAISER_KERNEL_PGD_ALIGNMENT (KAISER_SHADOW_PGD_OFFSET << 1)
+#else
+#define KAISER_KERNEL_PGD_ALIGNMENT PAGE_SIZE
+#endif
+
 #ifdef __ASSEMBLY__
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -4,6 +4,7 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 #include <asm/realmode.h>
+#include <asm/kaiser.h>
 
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
@@ -15,7 +16,8 @@ void __init reserve_real_mode(void)
 	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
 
 	/* Has to be under 1M so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	mem = memblock_find_in_range(0, 1 << 20, size,
+				     KAISER_KERNEL_PGD_ALIGNMENT);
 	if (!mem)
 		panic("Cannot allocate trampoline\n");
 
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -30,6 +30,7 @@
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
+#include <asm/kaiser.h>
 #include "realmode.h"
 
 	.text
@@ -139,7 +140,7 @@ tr_gdt:
 tr_gdt_end:
 
 	.bss
-	.balign	PAGE_SIZE
+	.balign	KAISER_KERNEL_PGD_ALIGNMENT
 GLOBAL(trampoline_pgd)		.space	PAGE_SIZE
 
 	.balign	8

