Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBCA420C10
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhJDNCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233638AbhJDNBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6654761373;
        Mon,  4 Oct 2021 12:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352297;
        bh=nRMFoo3HxI4phZvJtWxIoMmTmeWDnMZOzkC1N3o7H+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EX0U0JZ/5GL75bCcXs4XVsglbXxqwtmDax1/rEc/bXgfoTjgbD16QBuiO488D8r98
         LItZcb8PecXEY7eELf8xLsCyX8fPWHhcipIXBVf35ph7G9zdtSsvsIglCX5xpIX+sC
         EkDO+mj/OxsLsyuMuWEKi1WLpt4VSpHKmagqEP68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.9 51/57] ARM: 9079/1: ftrace: Add MODULE_PLTS support
Date:   Mon,  4 Oct 2021 14:52:35 +0200
Message-Id: <20211004125030.562670629@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 79f32b221b18c15a98507b101ef4beb52444cc6f upstream

Teach ftrace_make_call() and ftrace_make_nop() about PLTs.
Teach PLT code about FTRACE and all its callbacks.
Otherwise the following might happen:

------------[ cut here ]------------
WARNING: CPU: 14 PID: 2265 at .../arch/arm/kernel/insn.c:14 __arm_gen_branch+0x83/0x8c()
...
Hardware name: LSI Axxia AXM55XX
[<c0314a49>] (unwind_backtrace) from [<c03115e9>] (show_stack+0x11/0x14)
[<c03115e9>] (show_stack) from [<c0519f51>] (dump_stack+0x81/0xa8)
[<c0519f51>] (dump_stack) from [<c032185d>] (warn_slowpath_common+0x69/0x90)
[<c032185d>] (warn_slowpath_common) from [<c03218f3>] (warn_slowpath_null+0x17/0x1c)
[<c03218f3>] (warn_slowpath_null) from [<c03143cf>] (__arm_gen_branch+0x83/0x8c)
[<c03143cf>] (__arm_gen_branch) from [<c0314337>] (ftrace_make_nop+0xf/0x24)
[<c0314337>] (ftrace_make_nop) from [<c038ebcb>] (ftrace_process_locs+0x27b/0x3e8)
[<c038ebcb>] (ftrace_process_locs) from [<c0378d79>] (load_module+0x11e9/0x1a44)
[<c0378d79>] (load_module) from [<c037974d>] (SyS_finit_module+0x59/0x84)
[<c037974d>] (SyS_finit_module) from [<c030e981>] (ret_fast_syscall+0x1/0x18)
---[ end trace e1b64ced7a89adcc ]---
------------[ cut here ]------------
WARNING: CPU: 14 PID: 2265 at .../kernel/trace/ftrace.c:1979 ftrace_bug+0x1b1/0x234()
...
Hardware name: LSI Axxia AXM55XX
[<c0314a49>] (unwind_backtrace) from [<c03115e9>] (show_stack+0x11/0x14)
[<c03115e9>] (show_stack) from [<c0519f51>] (dump_stack+0x81/0xa8)
[<c0519f51>] (dump_stack) from [<c032185d>] (warn_slowpath_common+0x69/0x90)
[<c032185d>] (warn_slowpath_common) from [<c03218f3>] (warn_slowpath_null+0x17/0x1c)
[<c03218f3>] (warn_slowpath_null) from [<c038e87d>] (ftrace_bug+0x1b1/0x234)
[<c038e87d>] (ftrace_bug) from [<c038ebd5>] (ftrace_process_locs+0x285/0x3e8)
[<c038ebd5>] (ftrace_process_locs) from [<c0378d79>] (load_module+0x11e9/0x1a44)
[<c0378d79>] (load_module) from [<c037974d>] (SyS_finit_module+0x59/0x84)
[<c037974d>] (SyS_finit_module) from [<c030e981>] (ret_fast_syscall+0x1/0x18)
---[ end trace e1b64ced7a89adcd ]---
ftrace failed to modify [<e9ef7006>] 0xe9ef7006
actual: 02:f0:3b:fa
ftrace record flags: 0
(0) expected tramp: c0314265

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/ftrace.h |    3 ++
 arch/arm/include/asm/module.h |    1 
 arch/arm/kernel/ftrace.c      |   45 +++++++++++++++++++++++++++++++++++-------
 arch/arm/kernel/module-plts.c |   44 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 82 insertions(+), 11 deletions(-)

--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -14,6 +14,9 @@ struct dyn_arch_ftrace {
 #ifdef CONFIG_OLD_MCOUNT
 	bool	old_mcount;
 #endif
+#ifdef CONFIG_ARM_MODULE_PLTS
+	struct module *mod;
+#endif
 };
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -29,6 +29,7 @@ struct plt_entries {
 
 struct mod_plt_sec {
 	struct elf32_shdr	*plt;
+	struct plt_entries	*plt_ent;
 	int			plt_count;
 };
 
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -95,9 +95,10 @@ int ftrace_arch_code_modify_post_process
 	return 0;
 }
 
-static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
+					 bool warn)
 {
-	return arm_gen_branch_link(pc, addr, true);
+	return arm_gen_branch_link(pc, addr, warn);
 }
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
@@ -136,14 +137,14 @@ int ftrace_update_ftrace_func(ftrace_fun
 	int ret;
 
 	pc = (unsigned long)&ftrace_call;
-	new = ftrace_call_replace(pc, (unsigned long)func);
+	new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 	ret = ftrace_modify_code(pc, 0, new, false);
 
 #ifdef CONFIG_OLD_MCOUNT
 	if (!ret) {
 		pc = (unsigned long)&ftrace_call_old;
-		new = ftrace_call_replace(pc, (unsigned long)func);
+		new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 		ret = ftrace_modify_code(pc, 0, new, false);
 	}
@@ -156,9 +157,21 @@ int ftrace_make_call(struct dyn_ftrace *
 {
 	unsigned long new, old;
 	unsigned long ip = rec->ip;
+	unsigned long aaddr = adjust_address(rec, addr);
+	struct module *mod = NULL;
+
+#ifdef CONFIG_ARM_MODULE_PLTS
+	mod = rec->arch.mod;
+#endif
 
 	old = ftrace_nop_replace(rec);
-	new = ftrace_call_replace(ip, adjust_address(rec, addr));
+	new = ftrace_call_replace(ip, aaddr, !mod);
+#ifdef CONFIG_ARM_MODULE_PLTS
+	if (!new && mod) {
+		aaddr = get_module_plt(mod, ip, aaddr);
+		new = ftrace_call_replace(ip, aaddr, true);
+	}
+#endif
 
 	return ftrace_modify_code(rec->ip, old, new, true);
 }
@@ -166,12 +179,29 @@ int ftrace_make_call(struct dyn_ftrace *
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
+	unsigned long aaddr = adjust_address(rec, addr);
 	unsigned long ip = rec->ip;
 	unsigned long old;
 	unsigned long new;
 	int ret;
 
-	old = ftrace_call_replace(ip, adjust_address(rec, addr));
+#ifdef CONFIG_ARM_MODULE_PLTS
+	/* mod is only supplied during module loading */
+	if (!mod)
+		mod = rec->arch.mod;
+	else
+		rec->arch.mod = mod;
+#endif
+
+	old = ftrace_call_replace(ip, aaddr,
+				  !IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || !mod);
+#ifdef CONFIG_ARM_MODULE_PLTS
+	if (!old && mod) {
+		aaddr = get_module_plt(mod, ip, aaddr);
+		old = ftrace_call_replace(ip, aaddr, true);
+	}
+#endif
+
 	new = ftrace_nop_replace(rec);
 	ret = ftrace_modify_code(ip, old, new, true);
 
@@ -179,7 +209,8 @@ int ftrace_make_nop(struct module *mod,
 	if (ret == -EINVAL && addr == MCOUNT_ADDR) {
 		rec->arch.old_mcount = true;
 
-		old = ftrace_call_replace(ip, adjust_address(rec, addr));
+		old = ftrace_call_replace(ip, adjust_address(rec, addr),
+					  !IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || !mod);
 		new = ftrace_nop_replace(rec);
 		ret = ftrace_modify_code(ip, old, new, true);
 	}
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/elf.h>
+#include <linux/ftrace.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sort.h>
@@ -22,19 +23,52 @@
 						    (PLT_ENT_STRIDE - 8))
 #endif
 
+static const u32 fixed_plts[] = {
+#ifdef CONFIG_FUNCTION_TRACER
+	FTRACE_ADDR,
+	MCOUNT_ADDR,
+#endif
+};
+
 static bool in_init(const struct module *mod, unsigned long loc)
 {
 	return loc - (u32)mod->init_layout.base < mod->init_layout.size;
 }
 
+static void prealloc_fixed(struct mod_plt_sec *pltsec, struct plt_entries *plt)
+{
+	int i;
+
+	if (!ARRAY_SIZE(fixed_plts) || pltsec->plt_count)
+		return;
+	pltsec->plt_count = ARRAY_SIZE(fixed_plts);
+
+	for (i = 0; i < ARRAY_SIZE(plt->ldr); ++i)
+		plt->ldr[i] = PLT_ENT_LDR;
+
+	BUILD_BUG_ON(sizeof(fixed_plts) > sizeof(plt->lit));
+	memcpy(plt->lit, fixed_plts, sizeof(fixed_plts));
+}
+
 u32 get_module_plt(struct module *mod, unsigned long loc, Elf32_Addr val)
 {
 	struct mod_plt_sec *pltsec = !in_init(mod, loc) ? &mod->arch.core :
 							  &mod->arch.init;
+	struct plt_entries *plt;
+	int idx;
+
+	/* cache the address, ELF header is available only during module load */
+	if (!pltsec->plt_ent)
+		pltsec->plt_ent = (struct plt_entries *)pltsec->plt->sh_addr;
+	plt = pltsec->plt_ent;
 
-	struct plt_entries *plt = (struct plt_entries *)pltsec->plt->sh_addr;
-	int idx = 0;
+	prealloc_fixed(pltsec, plt);
+
+	for (idx = 0; idx < ARRAY_SIZE(fixed_plts); ++idx)
+		if (plt->lit[idx] == val)
+			return (u32)&plt->ldr[idx];
 
+	idx = 0;
 	/*
 	 * Look for an existing entry pointing to 'val'. Given that the
 	 * relocations are sorted, this will be the last entry we allocated.
@@ -182,8 +216,8 @@ static unsigned int count_plts(const Elf
 int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			      char *secstrings, struct module *mod)
 {
-	unsigned long core_plts = 0;
-	unsigned long init_plts = 0;
+	unsigned long core_plts = ARRAY_SIZE(fixed_plts);
+	unsigned long init_plts = ARRAY_SIZE(fixed_plts);
 	Elf32_Shdr *s, *sechdrs_end = sechdrs + ehdr->e_shnum;
 	Elf32_Sym *syms = NULL;
 
@@ -238,6 +272,7 @@ int module_frob_arch_sections(Elf_Ehdr *
 	mod->arch.core.plt->sh_size = round_up(core_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.core.plt_count = 0;
+	mod->arch.core.plt_ent = NULL;
 
 	mod->arch.init.plt->sh_type = SHT_NOBITS;
 	mod->arch.init.plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
@@ -245,6 +280,7 @@ int module_frob_arch_sections(Elf_Ehdr *
 	mod->arch.init.plt->sh_size = round_up(init_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.init.plt_count = 0;
+	mod->arch.init.plt_ent = NULL;
 
 	pr_debug("%s: plt=%x, init.plt=%x\n", __func__,
 		 mod->arch.core.plt->sh_size, mod->arch.init.plt->sh_size);


