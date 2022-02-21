Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8207B4BE971
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347051AbiBUJFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:05:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347237AbiBUJE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:04:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23D423BF3;
        Mon, 21 Feb 2022 00:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BCD1B80EA1;
        Mon, 21 Feb 2022 08:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF64C340E9;
        Mon, 21 Feb 2022 08:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433907;
        bh=SUkLbIBKElSDkcsMZrZ7IpuzZfQE2L7vqXayTHvgyqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wtRzAJbLDMpLr8svfdNgWnP5GxDiwwPX53qiCGeRRDNXsnH8q1rRY9f3sdo6pHOIM
         yI6ebVfD+kL4EuNO1II7wwmSzFn3MQ6FVtBQrdqywpBGgD9QHvUsinl/g+WJBoZMqA
         9D2YT9hmDa1Y3NNnAzq+arMcG58RzYdKwaCpyPcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Torsten Duwe <duwe@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.4 26/80] arm64: module/ftrace: intialize PLT at load time
Date:   Mon, 21 Feb 2022 09:49:06 +0100
Message-Id: <20220221084916.442944350@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit f1a54ae9af0da4d76239256ed640a93ab3aadac0 upstream.

Currently we lazily-initialize a module's ftrace PLT at runtime when we
install the first ftrace call. To do so we have to apply a number of
sanity checks, transiently mark the module text as RW, and perform an
IPI as part of handling Neoverse-N1 erratum #1542419.

We only expect the ftrace trampoline to point at ftrace_caller() (AKA
FTRACE_ADDR), so let's simplify all of this by intializing the PLT at
module load time, before the module loader marks the module RO and
performs the intial I-cache maintenance for the module.

Thus we can rely on the module having been correctly intialized, and can
simplify the runtime work necessary to install an ftrace call in a
module. This will also allow for the removal of module_disable_ro().

Tested by forcing ftrace_make_call() to use the module PLT, and then
loading up a module after setting up ftrace with:

| echo ":mod:<module-name>" > set_ftrace_filter;
| echo function > current_tracer;
| modprobe <module-name>

Since FTRACE_ADDR is only defined when CONFIG_DYNAMIC_FTRACE is
selected, we wrap its use along with most of module_init_ftrace_plt()
with ifdeffery rather than using IS_ENABLED().

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Torsten Duwe <duwe@suse.de>
Tested-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Tested-by: Torsten Duwe <duwe@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ftrace.c |   55 +++++++++++----------------------------------
 arch/arm64/kernel/module.c |   32 +++++++++++++++++---------
 2 files changed, 35 insertions(+), 52 deletions(-)

--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -73,10 +73,22 @@ int ftrace_make_call(struct dyn_ftrace *
 
 	if (offset < -SZ_128M || offset >= SZ_128M) {
 #ifdef CONFIG_ARM64_MODULE_PLTS
-		struct plt_entry trampoline, *dst;
 		struct module *mod;
 
 		/*
+		 * There is only one ftrace trampoline per module. For now,
+		 * this is not a problem since on arm64, all dynamic ftrace
+		 * invocations are routed via ftrace_caller(). This will need
+		 * to be revisited if support for multiple ftrace entry points
+		 * is added in the future, but for now, the pr_err() below
+		 * deals with a theoretical issue only.
+		 */
+		if (addr != FTRACE_ADDR) {
+			pr_err("ftrace: far branches to multiple entry points unsupported inside a single module\n");
+			return -EINVAL;
+		}
+
+		/*
 		 * On kernels that support module PLTs, the offset between the
 		 * branch instruction and its target may legally exceed the
 		 * range of an ordinary relative 'bl' opcode. In this case, we
@@ -93,46 +105,7 @@ int ftrace_make_call(struct dyn_ftrace *
 		if (WARN_ON(!mod))
 			return -EINVAL;
 
-		/*
-		 * There is only one ftrace trampoline per module. For now,
-		 * this is not a problem since on arm64, all dynamic ftrace
-		 * invocations are routed via ftrace_caller(). This will need
-		 * to be revisited if support for multiple ftrace entry points
-		 * is added in the future, but for now, the pr_err() below
-		 * deals with a theoretical issue only.
-		 *
-		 * Note that PLTs are place relative, and plt_entries_equal()
-		 * checks whether they point to the same target. Here, we need
-		 * to check if the actual opcodes are in fact identical,
-		 * regardless of the offset in memory so use memcmp() instead.
-		 */
-		dst = mod->arch.ftrace_trampoline;
-		trampoline = get_plt_entry(addr, dst);
-		if (memcmp(dst, &trampoline, sizeof(trampoline))) {
-			if (plt_entry_is_initialized(dst)) {
-				pr_err("ftrace: far branches to multiple entry points unsupported inside a single module\n");
-				return -EINVAL;
-			}
-
-			/* point the trampoline to our ftrace entry point */
-			module_disable_ro(mod);
-			*dst = trampoline;
-			module_enable_ro(mod, true);
-
-			/*
-			 * Ensure updated trampoline is visible to instruction
-			 * fetch before we patch in the branch. Although the
-			 * architecture doesn't require an IPI in this case,
-			 * Neoverse-N1 erratum #1542419 does require one
-			 * if the TLB maintenance in module_enable_ro() is
-			 * skipped due to rodata_enabled. It doesn't seem worth
-			 * it to make it conditional given that this is
-			 * certainly not a fast-path.
-			 */
-			flush_icache_range((unsigned long)&dst[0],
-					   (unsigned long)&dst[1]);
-		}
-		addr = (unsigned long)dst;
+		addr = (unsigned long)mod->arch.ftrace_trampoline;
 #else /* CONFIG_ARM64_MODULE_PLTS */
 		return -EINVAL;
 #endif /* CONFIG_ARM64_MODULE_PLTS */
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitops.h>
 #include <linux/elf.h>
+#include <linux/ftrace.h>
 #include <linux/gfp.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
@@ -485,24 +486,33 @@ static const Elf_Shdr *find_section(cons
 	return NULL;
 }
 
+static int module_init_ftrace_plt(const Elf_Ehdr *hdr,
+				  const Elf_Shdr *sechdrs,
+				  struct module *mod)
+{
+#if defined(CONFIG_ARM64_MODULE_PLTS) && defined(CONFIG_DYNAMIC_FTRACE)
+	const Elf_Shdr *s;
+	struct plt_entry *plt;
+
+	s = find_section(hdr, sechdrs, ".text.ftrace_trampoline");
+	if (!s)
+		return -ENOEXEC;
+
+	plt = (void *)s->sh_addr;
+	*plt = get_plt_entry(FTRACE_ADDR, plt);
+	mod->arch.ftrace_trampoline = plt;
+#endif
+	return 0;
+}
+
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
 	const Elf_Shdr *s;
-
 	s = find_section(hdr, sechdrs, ".altinstructions");
 	if (s)
 		apply_alternatives_module((void *)s->sh_addr, s->sh_size);
 
-#ifdef CONFIG_ARM64_MODULE_PLTS
-	if (IS_ENABLED(CONFIG_DYNAMIC_FTRACE)) {
-		s = find_section(hdr, sechdrs, ".text.ftrace_trampoline");
-		if (!s)
-			return -ENOEXEC;
-		me->arch.ftrace_trampoline = (void *)s->sh_addr;
-	}
-#endif
-
-	return 0;
+	return module_init_ftrace_plt(hdr, sechdrs, me);
 }


