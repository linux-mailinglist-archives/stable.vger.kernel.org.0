Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2681497E5E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbiAXL5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiAXL5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:57:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CCCC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 03:57:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFCF6B80EFE
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA258C340E4;
        Mon, 24 Jan 2022 11:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643025459;
        bh=NSvFAIOVwbyD1CMtRvdGhWvB1PtiTHjrBciR/eBIexA=;
        h=Subject:To:Cc:From:Date:From;
        b=rkJ4OrM3j5j5kwgaGKWyhAhIpdguyXgSrx1Qmks8UGEaGQM+SfNZAYbKikw7pDvSD
         DWDV5eheHqgZvppHoNzw0s5SnHehr8M75NZbHiE1C1O66TIuH7YQsRswC4gE8DreIG
         Rc+XSFlEZrlmfyhITQ2r6/ufkgxk5PbjH3rVpO1M=
Subject: FAILED: patch "[PATCH] arm64/bpf: Remove 128MB limit for BPF JIT programs" failed to apply to 5.4-stable tree
To:     russell.king@oracle.com, alan.maguire@oracle.com,
        ard.biesheuvel@linaro.org, daniel@iogearbox.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:57:36 +0100
Message-ID: <1643025456171217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b89ddf4cca43f1269093942cf5c4e457fd45c335 Mon Sep 17 00:00:00 2001
From: Russell King <russell.king@oracle.com>
Date: Fri, 5 Nov 2021 16:50:45 +0000
Subject: [PATCH] arm64/bpf: Remove 128MB limit for BPF JIT programs

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

diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index 8b300dd28def..72b0e71cc3de 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -33,15 +33,6 @@ do {							\
 	(b)->data = (tmp).data;				\
 } while (0)
 
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
 bool ex_handler_bpf(const struct exception_table_entry *ex,
 		    struct pt_regs *regs);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 1b9a1e242612..0af70d9abede 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -44,11 +44,8 @@
 #define _PAGE_OFFSET(va)	(-(UL(1) << (va)))
 #define PAGE_OFFSET		(_PAGE_OFFSET(VA_BITS))
 #define KIMAGE_VADDR		(MODULES_END)
-#define BPF_JIT_REGION_START	(_PAGE_END(VA_BITS_MIN))
-#define BPF_JIT_REGION_SIZE	(SZ_128M)
-#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(BPF_JIT_REGION_END)
+#define MODULES_VADDR		(_PAGE_END(VA_BITS_MIN))
 #define MODULES_VSIZE		(SZ_128M)
 #define VMEMMAP_START		(-(UL(1) << (VA_BITS - VMEMMAP_SHIFT)))
 #define VMEMMAP_END		(VMEMMAP_START + VMEMMAP_SIZE)
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 7b21213a570f..e8986e6067a9 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -994,7 +994,7 @@ static struct break_hook bug_break_hook = {
 static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
-		in_bpf_jit(regs) ? "BPF JIT" : "Kernel text patching",
+		"Kernel text patching",
 		(void *)instruction_pointer(regs));
 
 	/* We cannot handle this */
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 1c403536c9bb..9bc4066c5bf3 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -41,8 +41,6 @@ static struct addr_marker address_markers[] = {
 	{ 0 /* KASAN_SHADOW_START */,	"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ BPF_JIT_REGION_START,		"BPF start" },
-	{ BPF_JIT_REGION_END,		"BPF end" },
 	{ MODULES_VADDR,		"Modules start" },
 	{ MODULES_END,			"Modules end" },
 	{ VMALLOC_START,		"vmalloc() area" },
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 3a8a7140a9bf..86c9dc0681cc 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1141,15 +1141,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
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

