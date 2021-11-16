Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C991452F88
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhKPK5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhKPK5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 05:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DFFD61BE3;
        Tue, 16 Nov 2021 10:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637060088;
        bh=iF6xBi8UOPUFeQCK8m3e5lJkCdqiTeB/ZS+hHGoueCc=;
        h=Subject:To:Cc:From:Date:From;
        b=N91Lpm/6sfbKgKOBzAIRg+wGYuI+XjNH+CGM8jhUlNMDh1Gb2bzUVw/KdxaemftjR
         6HkN0IOrbsL45AjG1VErMo9ypVC2wtiKAIi9fpnTJlbI1tIzl9BGRwpgp78FFNDXbS
         K1WvUOcAu+86OEU0Ct95HpM8tz7a3VMHDyt3orzE=
Subject: FAILED: patch "[PATCH] x86/sev: Make the #VC exception stacks part of the default" failed to apply to 5.15-stable tree
To:     bp@suse.de, brijesh.singh@amd.com, thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Nov 2021 11:54:46 +0100
Message-ID: <1637060086211132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 541ac97186d9ea88491961a46284de3603c914fd Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Fri, 1 Oct 2021 21:41:20 +0200
Subject: [PATCH] x86/sev: Make the #VC exception stacks part of the default
 stacks storage

The size of the exception stacks was increased by the commit in Fixes,
resulting in stack sizes greater than a page in size. The #VC exception
handling was only mapping the first (bottom) page, resulting in an
SEV-ES guest failing to boot.

Make the #VC exception stacks part of the default exception stacks
storage and allocate them with a CONFIG_AMD_MEM_ENCRYPT=y .config. Map
them only when a SEV-ES guest has been detected.

Rip out the custom VC stacks mapping and storage code.

 [ bp: Steal and adapt Tom's commit message. ]

Fixes: 7fae4c24a2b8 ("x86: Increase exception stack sizes")
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Brijesh Singh <brijesh.singh@amd.com>
Link: https://lkml.kernel.org/r/YVt1IMjIs7pIZTRR@zn.tnic

diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 3d52b094850a..dd5ea1bdf04c 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -10,6 +10,12 @@
 
 #ifdef CONFIG_X86_64
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+#define VC_EXCEPTION_STKSZ	EXCEPTION_STKSZ
+#else
+#define VC_EXCEPTION_STKSZ	0
+#endif
+
 /* Macro to enforce the same ordering and stack sizes */
 #define ESTACKS_MEMBERS(guardsize, optional_stack_size)		\
 	char	DF_stack_guard[guardsize];			\
@@ -28,7 +34,7 @@
 
 /* The exception stacks' physical storage. No guard pages required */
 struct exception_stacks {
-	ESTACKS_MEMBERS(0, 0)
+	ESTACKS_MEMBERS(0, VC_EXCEPTION_STKSZ)
 };
 
 /* The effective cpu entry area mapping with guard pages. */
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 53a6837d354b..4d0d1c2b65e1 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -46,16 +46,6 @@ static struct ghcb __initdata *boot_ghcb;
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
 
-	/* Physical storage for the per-CPU IST stack of the #VC handler */
-	char ist_stack[EXCEPTION_STKSZ] __aligned(PAGE_SIZE);
-
-	/*
-	 * Physical storage for the per-CPU fall-back stack of the #VC handler.
-	 * The fall-back stack is used when it is not safe to switch back to the
-	 * interrupted stack in the #VC entry code.
-	 */
-	char fallback_stack[EXCEPTION_STKSZ] __aligned(PAGE_SIZE);
-
 	/*
 	 * Reserve one page per CPU as backup storage for the unencrypted GHCB.
 	 * It is needed when an NMI happens while the #VC handler uses the real
@@ -99,27 +89,6 @@ DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
-static void __init setup_vc_stacks(int cpu)
-{
-	struct sev_es_runtime_data *data;
-	struct cpu_entry_area *cea;
-	unsigned long vaddr;
-	phys_addr_t pa;
-
-	data = per_cpu(runtime_data, cpu);
-	cea  = get_cpu_entry_area(cpu);
-
-	/* Map #VC IST stack */
-	vaddr = CEA_ESTACK_BOT(&cea->estacks, VC);
-	pa    = __pa(data->ist_stack);
-	cea_set_pte((void *)vaddr, pa, PAGE_KERNEL);
-
-	/* Map VC fall-back stack */
-	vaddr = CEA_ESTACK_BOT(&cea->estacks, VC2);
-	pa    = __pa(data->fallback_stack);
-	cea_set_pte((void *)vaddr, pa, PAGE_KERNEL);
-}
-
 static __always_inline bool on_vc_stack(struct pt_regs *regs)
 {
 	unsigned long sp = regs->sp;
@@ -787,7 +756,6 @@ void __init sev_es_init_vc_handling(void)
 	for_each_possible_cpu(cpu) {
 		alloc_runtime_data(cpu);
 		init_ghcb(cpu);
-		setup_vc_stacks(cpu);
 	}
 
 	sev_es_setup_play_dead();
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index f5e1e60c9095..6c2f1b76a0b6 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -110,6 +110,13 @@ static void __init percpu_setup_exception_stacks(unsigned int cpu)
 	cea_map_stack(NMI);
 	cea_map_stack(DB);
 	cea_map_stack(MCE);
+
+	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
+		if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
+			cea_map_stack(VC);
+			cea_map_stack(VC2);
+		}
+	}
 }
 #else
 static inline void percpu_setup_exception_stacks(unsigned int cpu)

