Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE884D325E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiCIQCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiCIQB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:01:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C634A17225B;
        Wed,  9 Mar 2022 08:00:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 624C161687;
        Wed,  9 Mar 2022 16:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F12BC340FB;
        Wed,  9 Mar 2022 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841657;
        bh=9xSbW6RIMMhTdHAqKKPczN6O01gAoWr/nHWbJelAumw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+zAM5MRtE6sR3eqsFsw1vadfdDbXEhfpXOVsFlHxZC/pz+L2DtoqIFnxlDrw5bT/
         UpXlqnLPWTOHTta/HMOiarUWF3TWMBOH4Ssu4DBPQzqG4/U0Ps4bIGXuaynsRtzfkK
         OtrLXDCFBMjbJVMiEOifTkq/Ka3R1XPhFVXymPg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Borislav Petkov <bp@suse.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        srinivas.eeda@oracle.com, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 02/24] x86/retpoline: Make CONFIG_RETPOLINE depend on compiler support
Date:   Wed,  9 Mar 2022 16:59:15 +0100
Message-Id: <20220309155856.369868546@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 4cd24de3a0980bf3100c9dcb08ef65ca7c31af48 upstream.

Since retpoline capable compilers are widely available, make
CONFIG_RETPOLINE hard depend on the compiler capability.

Break the build when CONFIG_RETPOLINE is enabled and the compiler does not
support it. Emit an error message in that case:

 "arch/x86/Makefile:226: *** You are building kernel with non-retpoline
  compiler, please update your compiler..  Stop."

[dwmw: Fail the build with non-retpoline compiler]

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: <srinivas.eeda@oracle.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/cca0cb20-f9e2-4094-840b-fb0f8810cd34@default
[bwh: Backported to 4.9:
 - Drop change to objtool options
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig                     |    4 ----
 arch/x86/Makefile                    |    5 +++--
 arch/x86/include/asm/nospec-branch.h |   10 ++++++----
 arch/x86/kernel/cpu/bugs.c           |    2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -418,10 +418,6 @@ config RETPOLINE
 	  branches. Requires a compiler with -mindirect-branch=thunk-extern
 	  support for full protection. The kernel may run slower.
 
-	  Without compiler support, at least indirect branches in assembler
-	  code are eliminated. Since this includes the syscall entry path,
-	  it is not entirely pointless.
-
 if X86_32
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -221,9 +221,10 @@ ifdef CONFIG_RETPOLINE
     RETPOLINE_CFLAGS_CLANG := -mretpoline-external-thunk
 
     RETPOLINE_CFLAGS += $(call cc-option,$(RETPOLINE_CFLAGS_GCC),$(call cc-option,$(RETPOLINE_CFLAGS_CLANG)))
-    ifneq ($(RETPOLINE_CFLAGS),)
-        KBUILD_CFLAGS += $(RETPOLINE_CFLAGS) -DRETPOLINE
+    ifeq ($(RETPOLINE_CFLAGS),)
+      $(error You are building kernel with non-retpoline compiler, please update your compiler.)
     endif
+    KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
 endif
 
 archscripts: scripts_basic
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -164,11 +164,12 @@
 	_ASM_PTR " 999b\n\t"					\
 	".popsection\n\t"
 
-#if defined(CONFIG_X86_64) && defined(RETPOLINE)
+#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_X86_64
 
 /*
- * Since the inline asm uses the %V modifier which is only in newer GCC,
- * the 64-bit one is dependent on RETPOLINE not CONFIG_RETPOLINE.
+ * Inline asm uses the %V modifier which is only in newer GCC
+ * which is ensured when CONFIG_RETPOLINE is defined.
  */
 # define CALL_NOSPEC						\
 	ANNOTATE_NOSPEC_ALTERNATIVE				\
@@ -183,7 +184,7 @@
 	X86_FEATURE_RETPOLINE_AMD)
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 
-#elif defined(CONFIG_X86_32) && defined(CONFIG_RETPOLINE)
+#else /* CONFIG_X86_32 */
 /*
  * For i386 we use the original ret-equivalent retpoline, because
  * otherwise we'll run out of registers. We don't care about CET
@@ -213,6 +214,7 @@
 	X86_FEATURE_RETPOLINE_AMD)
 
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
+#endif
 #else /* No retpoline for C / inline asm */
 # define CALL_NOSPEC "call *%[thunk_target]\n"
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -812,7 +812,7 @@ static void __init spec_v2_print_cond(co
 
 static inline bool retp_compiler(void)
 {
-	return __is_defined(RETPOLINE);
+	return __is_defined(CONFIG_RETPOLINE);
 }
 
 static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)


