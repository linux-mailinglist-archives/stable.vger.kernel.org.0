Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86A1414EB4
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbhIVREi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbhIVRE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:04:26 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289A9C061760;
        Wed, 22 Sep 2021 10:02:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so2794421pjb.4;
        Wed, 22 Sep 2021 10:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=knw8EOYFiroirhuQGxEq+gTuK2fL65BldUtmqeBQkzI=;
        b=N7x5IfdIrft8v0MvXcTwMbv5HoDnZlq2S4ze9xGKhi2ClWoWbSpmVWAfPxZH1Ja/Vt
         Gian4Gn5MoayKYCdGQdhV3Az3yjs0n78qzBX5Ftc+AvkI2b2qenrZM+lGpdayS43axgp
         /c4biW8ON1fY8dTLSLRB8vGIlYsu/SoYfMQqHkok2+W95XphtVdtg7eT8r5sXBGqipzx
         WoTzV6v1moITJ20AVkxiM4hPDuD8Zd5NJa8I+BhuWPJcF3aBJo3EtoHQLB63BDARpw7t
         q2PjzCX2Dcj3QrbPstSS/iHQWUX+8afP0j6qf5QMDBEkV82nutIhmCzQ47KPKoe65HL/
         t33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=knw8EOYFiroirhuQGxEq+gTuK2fL65BldUtmqeBQkzI=;
        b=Lw+n/DmWTIi+bX2QA8sxW2Zq3tK+HkB8hdbSDfdEttL2yHQC+ppVgUVtyK6ZYpPGlW
         PMHIGh8UAWYSgC1+I3f2gldAATgEp+YbJ6fpQKD67n1qgx+TDuii7kYvYLYHNzGbErEC
         igSYmVQ1bp+LXMIwzvsZ3JkvEXCzI1V1VxMytUSoxoHrejQR3r8xteCDCQMBrkQpDBIN
         4a0biLxqyX1FJhe4MucUdOY7b0tTHEHgYJAIot2AB9cX0d1xftpOTVm9g/hN7QjxMxfP
         5QdMFmyCsTR4GvLH7jnEeL7giUQWZVWY3b2GRh33tfXgvlsCyygiHhvLbMutvyUVB9lx
         yDmA==
X-Gm-Message-State: AOAM532+ooZNjzSkjlS8NxOL62Ia11W9uODuM/eMDSE5D88fh4DpHYrA
        RQpfXY/5o8VEGuviJHgkHj+R4aG/x/0=
X-Google-Smtp-Source: ABdhPJyQ/Z2M0XSXUwu6Tt+iAajPiw2Ix0PAxyqZpboTdXImBcE/+i9I7CSRP0hUc2rc59UeiB+q1w==
X-Received: by 2002:a17:90a:c982:: with SMTP id w2mr90240pjt.30.1632330175257;
        Wed, 22 Sep 2021 10:02:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x128sm3061885pfd.203.2021.09.22.10.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:02:54 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.9 v2 3/4] ARM: 9079/1: ftrace: Add MODULE_PLTS support
Date:   Wed, 22 Sep 2021 10:02:45 -0700
Message-Id: <20210922170246.190499-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170246.190499-1-f.fainelli@gmail.com>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
MIME-Version: 1.0
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
---
 arch/arm/include/asm/ftrace.h |  3 +++
 arch/arm/include/asm/module.h |  1 +
 arch/arm/kernel/ftrace.c      | 45 +++++++++++++++++++++++++++++------
 arch/arm/kernel/module-plts.c | 44 ++++++++++++++++++++++++++++++----
 4 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 22b73112b75f..1c30be0f5dd0 100644
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
diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 2e9872a22359..3cfbe8181224 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -29,6 +29,7 @@ struct plt_entries {
 
 struct mod_plt_sec {
 	struct elf32_shdr	*plt;
+	struct plt_entries	*plt_ent;
 	int			plt_count;
 };
 
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index a95bc0a02fd8..b1cf37fec354 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -95,9 +95,10 @@ int ftrace_arch_code_modify_post_process(void)
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
@@ -136,14 +137,14 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
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
@@ -156,9 +157,21 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
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
@@ -166,12 +179,29 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
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
diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index f272711c411f..6804a145be11 100644
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
@@ -182,8 +216,8 @@ static unsigned int count_plts(const Elf32_Sym *syms, Elf32_Addr base,
 int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			      char *secstrings, struct module *mod)
 {
-	unsigned long core_plts = 0;
-	unsigned long init_plts = 0;
+	unsigned long core_plts = ARRAY_SIZE(fixed_plts);
+	unsigned long init_plts = ARRAY_SIZE(fixed_plts);
 	Elf32_Shdr *s, *sechdrs_end = sechdrs + ehdr->e_shnum;
 	Elf32_Sym *syms = NULL;
 
@@ -238,6 +272,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	mod->arch.core.plt->sh_size = round_up(core_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.core.plt_count = 0;
+	mod->arch.core.plt_ent = NULL;
 
 	mod->arch.init.plt->sh_type = SHT_NOBITS;
 	mod->arch.init.plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
@@ -245,6 +280,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	mod->arch.init.plt->sh_size = round_up(init_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.init.plt_count = 0;
+	mod->arch.init.plt_ent = NULL;
 
 	pr_debug("%s: plt=%x, init.plt=%x\n", __func__,
 		 mod->arch.core.plt->sh_size, mod->arch.init.plt->sh_size);
-- 
2.25.1

