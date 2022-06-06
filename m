Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844C253E8A4
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbiFFO54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbiFFO5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:57:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DCF2FE60E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B015D614AE
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 14:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC02C385A9;
        Mon,  6 Jun 2022 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654527473;
        bh=PrLmd0mDNAF5d/1E9yhbr4g1DPpNrxaD3FmrI9EQWTo=;
        h=Subject:To:Cc:From:Date:From;
        b=NWwDRJUHESXIrMcgSDX9Lctg1kavau5tN2QAbzZyUlBwJ8jQ2WUXme7AVHBx+iwPJ
         HpE7Rj13QgEMfLrXw3thCC6P7k8orpK11hlBTh3wwN9tqB4m86DYe0AKlKV3M3s0VI
         D4fDhWOiSTu9/hQfOzXoPUtF0Dny3hDBIFnkMNDY=
Subject: FAILED: patch "[PATCH] powerpc/ftrace: Remove ftrace init tramp once kernel init is" failed to apply to 5.4-stable tree
To:     naveen.n.rao@linux.vnet.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 16:57:35 +0200
Message-ID: <165452745533229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From 84ade0a6655bee803d176525ef457175cbf4df22 Mon Sep 17 00:00:00 2001
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Date: Mon, 16 May 2022 12:44:22 +0530
Subject: [PATCH] powerpc/ftrace: Remove ftrace init tramp once kernel init is
 complete

Stop using the ftrace trampoline for init section once kernel init is
complete.

Fixes: 67361cf8071286 ("powerpc/ftrace: Handle large kernel configs")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220516071422.463738-1-naveen.n.rao@linux.vnet.ibm.com

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index b56166b7ea68..3cee7115441b 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -86,7 +86,7 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 #endif /* CONFIG_PPC64_ELF_ABI_V1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
-#ifdef CONFIG_PPC64
+#if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
 #include <asm/paca.h>
 
 static inline void this_cpu_disable_ftrace(void)
@@ -110,11 +110,13 @@ static inline u8 this_cpu_get_ftrace_enabled(void)
 	return get_paca()->ftrace_enabled;
 }
 
+void ftrace_free_init_tramp(void);
 #else /* CONFIG_PPC64 */
 static inline void this_cpu_disable_ftrace(void) { }
 static inline void this_cpu_enable_ftrace(void) { }
 static inline void this_cpu_set_ftrace_enabled(u8 ftrace_enabled) { }
 static inline u8 this_cpu_get_ftrace_enabled(void) { return 1; }
+static inline void ftrace_free_init_tramp(void) { }
 #endif /* CONFIG_PPC64 */
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index 2807136a1c19..2a893e06e4f1 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -257,9 +257,7 @@ static int setup_mcount_compiler_tramp(unsigned long tramp)
 
 	/* Is this a known long jump tramp? */
 	for (i = 0; i < NUM_FTRACE_TRAMPS; i++)
-		if (!ftrace_tramps[i])
-			break;
-		else if (ftrace_tramps[i] == tramp)
+		if (ftrace_tramps[i] == tramp)
 			return 0;
 
 	/* New trampoline -- read where this goes */
@@ -710,6 +708,17 @@ void arch_ftrace_update_code(int command)
 
 extern unsigned int ftrace_tramp_text[], ftrace_tramp_init[];
 
+void ftrace_free_init_tramp(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_FTRACE_TRAMPS && ftrace_tramps[i]; i++)
+		if (ftrace_tramps[i] == (unsigned long)ftrace_tramp_init) {
+			ftrace_tramps[i] = 0;
+			return;
+		}
+}
+
 int __init ftrace_dyn_arch_init(void)
 {
 	int i;
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 177fae5ea0d1..09b7b5e7bb9a 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -22,6 +22,7 @@
 #include <asm/kasan.h>
 #include <asm/svm.h>
 #include <asm/mmzone.h>
+#include <asm/ftrace.h>
 #include <asm/code-patching.h>
 
 #include <mm/mmu_decl.h>
@@ -314,6 +315,7 @@ void free_initmem(void)
 	mark_initmem_nx();
 	static_branch_enable(&init_mem_is_free);
 	free_initmem_default(POISON_FREE_INITMEM);
+	ftrace_free_init_tramp();
 }
 
 /*

