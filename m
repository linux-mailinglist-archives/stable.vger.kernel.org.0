Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C702499185
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343666AbiAXUL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:11:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34928 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354635AbiAXUIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:08:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 569A261471;
        Mon, 24 Jan 2022 20:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36088C341D2;
        Mon, 24 Jan 2022 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054892;
        bh=CEkzwEYn6hpZRkF6t02OQp0xNq32zDm4ic8dJORavy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fhe+KBWH4Jp9Nd+zzeB2c2pvVE4x2/AbNTrLZyS4efUv5aoscZdM+HT9EyQegYb+r
         9XevHUr0ogJkgNKNT4SCjFmv7Fa/CsFnJ6PNqhF4FZO/9a0MXceVasgB0boZXKq5nm
         ismb3/O2rdJnu9F+SeU3f32G15fdiclxe1lpzpso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Russell King <russell.king@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 5.10 505/563] arm64/bpf: Remove 128MB limit for BPF JIT programs
Date:   Mon, 24 Jan 2022 19:44:30 +0100
Message-Id: <20220124184041.939992577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <russell.king@oracle.com>

commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.

Commit 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module
memory") restricts BPF JIT program allocation to a 128MB region to ensure
BPF programs are still in branching range of each other. However this
restriction should not apply to the aarch64 JIT, since BPF_JMP | BPF_CALL
are implemented as a 64-bit move into a register and then a BLR instruction -
which has the effect of being able to call anything without proximity
limitation.

The practical reason to relax this restriction on JIT memory is that 128MB of
JIT memory can be quickly exhausted, especially where PAGE_SIZE is 64KB - one
page is needed per program. In cases where seccomp filters are applied to
multiple VMs on VM launch - such filters are classic BPF but converted to
BPF - this can severely limit the number of VMs that can be launched. In a
world where we support BPF JIT always on, turning off the JIT isn't always an
option either.

Fixes: 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module memory")
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <russell.king@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/1636131046-5982-2-git-send-email-alan.maguire@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/extable.h |    9 ---------
 arch/arm64/include/asm/memory.h  |    5 +----
 arch/arm64/kernel/traps.c        |    2 +-
 arch/arm64/mm/ptdump.c           |    2 --
 arch/arm64/net/bpf_jit_comp.c    |    7 ++-----
 5 files changed, 4 insertions(+), 21 deletions(-)

--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -22,15 +22,6 @@ struct exception_table_entry
 
 #define ARCH_HAS_RELATIVE_EXTABLE
 
-static inline bool in_bpf_jit(struct pt_regs *regs)
-{
-	if (!IS_ENABLED(CONFIG_BPF_JIT))
-		return false;
-
-	return regs->pc >= BPF_JIT_REGION_START &&
-	       regs->pc < BPF_JIT_REGION_END;
-}
-
 #ifdef CONFIG_BPF_JIT
 int arm64_bpf_fixup_exception(const struct exception_table_entry *ex,
 			      struct pt_regs *regs);
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -44,11 +44,8 @@
 #define _PAGE_OFFSET(va)	(-(UL(1) << (va)))
 #define PAGE_OFFSET		(_PAGE_OFFSET(VA_BITS))
 #define KIMAGE_VADDR		(MODULES_END)
-#define BPF_JIT_REGION_START	(KASAN_SHADOW_END)
-#define BPF_JIT_REGION_SIZE	(SZ_128M)
-#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(BPF_JIT_REGION_END)
+#define MODULES_VADDR		(_PAGE_END(VA_BITS_MIN))
 #define MODULES_VSIZE		(SZ_128M)
 #define VMEMMAP_START		(-VMEMMAP_SIZE - SZ_2M)
 #define VMEMMAP_END		(VMEMMAP_START + VMEMMAP_SIZE)
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -923,7 +923,7 @@ static struct break_hook bug_break_hook
 static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
-		in_bpf_jit(regs) ? "BPF JIT" : "Kernel text patching",
+		"Kernel text patching",
 		(void *)instruction_pointer(regs));
 
 	/* We cannot handle this */
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -41,8 +41,6 @@ static struct addr_marker address_marker
 	{ 0 /* KASAN_SHADOW_START */,	"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ BPF_JIT_REGION_START,		"BPF start" },
-	{ BPF_JIT_REGION_END,		"BPF end" },
 	{ MODULES_VADDR,		"Modules start" },
 	{ MODULES_END,			"Modules end" },
 	{ VMALLOC_START,		"vmalloc() area" },
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1136,15 +1136,12 @@ out:
 
 u64 bpf_jit_alloc_exec_limit(void)
 {
-	return BPF_JIT_REGION_SIZE;
+	return VMALLOC_END - VMALLOC_START;
 }
 
 void *bpf_jit_alloc_exec(unsigned long size)
 {
-	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	return vmalloc(size);
 }
 
 void bpf_jit_free_exec(void *addr)


