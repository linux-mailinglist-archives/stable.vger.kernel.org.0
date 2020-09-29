Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8253227C9D4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbgI2MOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730099AbgI2Lh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 569A523B1B;
        Tue, 29 Sep 2020 11:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379221;
        bh=bGntpSaWDi7OAEf+yW0hQi9/JrZZmZPq0dcyzwjq8Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqdu4RGTOEJAoGlNCNgHfC0E+K0yHZSQ9Ca/YFAz1N2h16zxcxvMXX0UBwI5wShJ0
         JvK9z4BNL/I4bO3ARQKD9YnTnUHcWhMjLRlF4wORoPCfX4drMudFBmJ/ssJJ0UByBf
         2U97k4jlYshxxeZ6a7VpfboK3pkxW3W2DUAO3aCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Torsten Duwe <duwe@suse.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/388] arm64: insn: consistently handle exit text
Date:   Tue, 29 Sep 2020 12:56:38 +0200
Message-Id: <20200929110013.738378565@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit ca2ef4ffabbef25644e02a98b0f48869f8be0375 ]

A kernel built with KASAN && FTRACE_WITH_REGS && !MODULES, produces a
boot-time splat in the bowels of ftrace:

| [    0.000000] ftrace: allocating 32281 entries in 127 pages
| [    0.000000] ------------[ cut here ]------------
| [    0.000000] WARNING: CPU: 0 PID: 0 at kernel/trace/ftrace.c:2019 ftrace_bug+0x27c/0x328
| [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.4.0-rc3-00008-g7f08ae53a7e3 #13
| [    0.000000] Hardware name: linux,dummy-virt (DT)
| [    0.000000] pstate: 60000085 (nZCv daIf -PAN -UAO)
| [    0.000000] pc : ftrace_bug+0x27c/0x328
| [    0.000000] lr : ftrace_init+0x640/0x6cc
| [    0.000000] sp : ffffa000120e7e00
| [    0.000000] x29: ffffa000120e7e00 x28: ffff00006ac01b10
| [    0.000000] x27: ffff00006ac898c0 x26: dfffa00000000000
| [    0.000000] x25: ffffa000120ef290 x24: ffffa0001216df40
| [    0.000000] x23: 000000000000018d x22: ffffa0001244c700
| [    0.000000] x21: ffffa00011bf393c x20: ffff00006ac898c0
| [    0.000000] x19: 00000000ffffffff x18: 0000000000001584
| [    0.000000] x17: 0000000000001540 x16: 0000000000000007
| [    0.000000] x15: 0000000000000000 x14: ffffa00010432770
| [    0.000000] x13: ffff940002483519 x12: 1ffff40002483518
| [    0.000000] x11: 1ffff40002483518 x10: ffff940002483518
| [    0.000000] x9 : dfffa00000000000 x8 : 0000000000000001
| [    0.000000] x7 : ffff940002483519 x6 : ffffa0001241a8c0
| [    0.000000] x5 : ffff940002483519 x4 : ffff940002483519
| [    0.000000] x3 : ffffa00011780870 x2 : 0000000000000001
| [    0.000000] x1 : 1fffe0000d591318 x0 : 0000000000000000
| [    0.000000] Call trace:
| [    0.000000]  ftrace_bug+0x27c/0x328
| [    0.000000]  ftrace_init+0x640/0x6cc
| [    0.000000]  start_kernel+0x27c/0x654
| [    0.000000] random: get_random_bytes called from print_oops_end_marker+0x30/0x60 with crng_init=0
| [    0.000000] ---[ end trace 0000000000000000 ]---
| [    0.000000] ftrace faulted on writing
| [    0.000000] [<ffffa00011bf393c>] _GLOBAL__sub_D_65535_0___tracepoint_initcall_level+0x4/0x28
| [    0.000000] Initializing ftrace call sites
| [    0.000000] ftrace record flags: 0
| [    0.000000]  (0)
| [    0.000000]  expected tramp: ffffa000100b3344

This is due to an unfortunate combination of several factors.

Building with KASAN results in the compiler generating anonymous
functions to register/unregister global variables against the shadow
memory. These functions are placed in .text.startup/.text.exit, and
given mangled names like _GLOBAL__sub_{I,D}_65535_0_$OTHER_SYMBOL. The
kernel linker script places these in .init.text and .exit.text
respectively, which are both discarded at runtime as part of initmem.

Building with FTRACE_WITH_REGS uses -fpatchable-function-entry=2, which
also instruments KASAN's anonymous functions. When these are discarded
with the rest of initmem, ftrace removes dangling references to these
call sites.

Building without MODULES implicitly disables STRICT_MODULE_RWX, and
causes arm64's patch_map() function to treat any !core_kernel_text()
symbol as something that can be modified in-place. As core_kernel_text()
is only true for .text and .init.text, with the latter depending on
system_state < SYSTEM_RUNNING, we'll treat .exit.text as something that
can be patched in-place. However, .exit.text is mapped read-only.

Hence in this configuration the ftrace init code blows up while trying
to patch one of the functions generated by KASAN.

We could try to filter out the call sites in .exit.text rather than
initializing them, but this would be inconsistent with how we handle
.init.text, and requires hooking into core bits of ftrace. The behaviour
of patch_map() is also inconsistent today, so instead let's clean that
up and have it consistently handle .exit.text.

This patch teaches patch_map() to handle .exit.text at init time,
preventing the boot-time splat above. The flow of patch_map() is
reworked to make the logic clearer and minimize redundant
conditionality.

Fixes: 3b23e4991fb66f6d ("arm64: implement ftrace with regs")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Torsten Duwe <duwe@suse.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/insn.c          | 22 ++++++++++++++++++----
 arch/arm64/kernel/vmlinux.lds.S   |  3 +++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 788ae971f11c1..25a73aab438f9 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -15,6 +15,7 @@ extern char __hyp_text_start[], __hyp_text_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
+extern char __exittext_begin[], __exittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index a612da533ea20..53bcf5386907f 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -21,6 +21,7 @@
 #include <asm/fixmap.h>
 #include <asm/insn.h>
 #include <asm/kprobes.h>
+#include <asm/sections.h>
 
 #define AARCH64_INSN_SF_BIT	BIT(31)
 #define AARCH64_INSN_N_BIT	BIT(22)
@@ -78,16 +79,29 @@ bool aarch64_insn_is_branch_imm(u32 insn)
 
 static DEFINE_RAW_SPINLOCK(patch_lock);
 
+static bool is_exit_text(unsigned long addr)
+{
+	/* discarded with init text/data */
+	return system_state < SYSTEM_RUNNING &&
+		addr >= (unsigned long)__exittext_begin &&
+		addr < (unsigned long)__exittext_end;
+}
+
+static bool is_image_text(unsigned long addr)
+{
+	return core_kernel_text(addr) || is_exit_text(addr);
+}
+
 static void __kprobes *patch_map(void *addr, int fixmap)
 {
 	unsigned long uintaddr = (uintptr_t) addr;
-	bool module = !core_kernel_text(uintaddr);
+	bool image = is_image_text(uintaddr);
 	struct page *page;
 
-	if (module && IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
-		page = vmalloc_to_page(addr);
-	else if (!module)
+	if (image)
 		page = phys_to_page(__pa_symbol(addr));
+	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
+		page = vmalloc_to_page(addr);
 	else
 		return addr;
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 4f77de8ce1384..0bab37b1acbe9 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -170,9 +170,12 @@ SECTIONS
 	__inittext_begin = .;
 
 	INIT_TEXT_SECTION(8)
+
+	__exittext_begin = .;
 	.exit.text : {
 		ARM_EXIT_KEEP(EXIT_TEXT)
 	}
+	__exittext_end = .;
 
 	. = ALIGN(4);
 	.altinstructions : {
-- 
2.25.1



