Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F114D33A5
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiCIQMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiCIQJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D3B218D;
        Wed,  9 Mar 2022 08:08:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C8EB8221D;
        Wed,  9 Mar 2022 16:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666CCC340E8;
        Wed,  9 Mar 2022 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842131;
        bh=k7IlrheiL20Nj+EcS7MdmaFH9E215/+V3yKYmdcANtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3bwhYzjzohqa45mhcw41XY9+6dApbmb5gKQ+lReU6SUebKuUy5emDO+xkHAt4Olq
         UWA7fwnEFHo4FFQPdg++sd4kfhN15o7F6IBhFbiWpont5xdLsXLE2d6mQ9SL9xCKHJ
         UNZbOI6J7ekpEgofmR1WDJZzgvRYpJh4tT5hTyZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.16 01/37] x86/speculation: Rename RETPOLINE_AMD to RETPOLINE_LFENCE
Date:   Wed,  9 Mar 2022 17:00:02 +0100
Message-Id: <20220309155859.131518217@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
References: <20220309155859.086952723@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

commit d45476d9832409371537013ebdd8dc1a7781f97a upstream.

The RETPOLINE_AMD name is unfortunate since it isn't necessarily
AMD only, in fact Hygon also uses it. Furthermore it will likely be
sufficient for some Intel processors. Therefore rename the thing to
RETPOLINE_LFENCE to better describe what it is.

Add the spectre_v2=retpoline,lfence option as an alias to
spectre_v2=retpoline,amd to preserve existing setups. However, the output
of /sys/devices/system/cpu/vulnerabilities/spectre_v2 will be changed.

  [ bp: Fix typos, massage. ]

Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h       |    2 +-
 arch/x86/include/asm/nospec-branch.h     |   12 ++++++------
 arch/x86/kernel/alternative.c            |    8 ++++----
 arch/x86/kernel/cpu/bugs.c               |   29 ++++++++++++++++++-----------
 arch/x86/lib/retpoline.S                 |    2 +-
 arch/x86/net/bpf_jit_comp.c              |    2 +-
 tools/arch/x86/include/asm/cpufeatures.h |    2 +-
 7 files changed, 32 insertions(+), 25 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -204,7 +204,7 @@
 /* FREE!                                ( 7*32+10) */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -84,7 +84,7 @@
 #ifdef CONFIG_RETPOLINE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(jmp __x86_indirect_thunk_\reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_AMD
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	jmp	*%\reg
 #endif
@@ -94,7 +94,7 @@
 #ifdef CONFIG_RETPOLINE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; call *%\reg), \
 		      __stringify(call __x86_indirect_thunk_\reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; call *%\reg), X86_FEATURE_RETPOLINE_AMD
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; call *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	call	*%\reg
 #endif
@@ -146,7 +146,7 @@ extern retpoline_thunk_t __x86_indirect_
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_AMD)
+	X86_FEATURE_RETPOLINE_LFENCE)
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 
@@ -176,7 +176,7 @@ extern retpoline_thunk_t __x86_indirect_
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_AMD)
+	X86_FEATURE_RETPOLINE_LFENCE)
 
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #endif
@@ -188,8 +188,8 @@ extern retpoline_thunk_t __x86_indirect_
 /* The Spectre V2 mitigation variants */
 enum spectre_v2_mitigation {
 	SPECTRE_V2_NONE,
-	SPECTRE_V2_RETPOLINE_GENERIC,
-	SPECTRE_V2_RETPOLINE_AMD,
+	SPECTRE_V2_RETPOLINE,
+	SPECTRE_V2_LFENCE,
 	SPECTRE_V2_IBRS_ENHANCED,
 };
 
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -389,7 +389,7 @@ static int emit_indirect(int op, int reg
  *
  *   CALL *%\reg
  *
- * It also tries to inline spectre_v2=retpoline,amd when size permits.
+ * It also tries to inline spectre_v2=retpoline,lfence when size permits.
  */
 static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 {
@@ -407,7 +407,7 @@ static int patch_retpoline(void *addr, s
 	BUG_ON(reg == 4);
 
 	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE) &&
-	    !cpu_feature_enabled(X86_FEATURE_RETPOLINE_AMD))
+	    !cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE))
 		return -1;
 
 	op = insn->opcode.bytes[0];
@@ -438,9 +438,9 @@ static int patch_retpoline(void *addr, s
 	}
 
 	/*
-	 * For RETPOLINE_AMD: prepend the indirect CALL/JMP with an LFENCE.
+	 * For RETPOLINE_LFENCE: prepend the indirect CALL/JMP with an LFENCE.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_AMD)) {
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		bytes[i++] = 0x0f;
 		bytes[i++] = 0xae;
 		bytes[i++] = 0xe8; /* LFENCE */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -664,7 +664,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_FORCE,
 	SPECTRE_V2_CMD_RETPOLINE,
 	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
-	SPECTRE_V2_CMD_RETPOLINE_AMD,
+	SPECTRE_V2_CMD_RETPOLINE_LFENCE,
 };
 
 enum spectre_v2_user_cmd {
@@ -824,8 +824,8 @@ set_mode:
 
 static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
-	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
-	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
+	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
+	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
 	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
 };
 
@@ -837,7 +837,8 @@ static const struct {
 	{ "off",		SPECTRE_V2_CMD_NONE,		  false },
 	{ "on",			SPECTRE_V2_CMD_FORCE,		  true  },
 	{ "retpoline",		SPECTRE_V2_CMD_RETPOLINE,	  false },
-	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_AMD,	  false },
+	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
+	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
 	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
 };
@@ -875,13 +876,19 @@ static enum spectre_v2_mitigation_cmd __
 	}
 
 	if ((cmd == SPECTRE_V2_CMD_RETPOLINE ||
-	     cmd == SPECTRE_V2_CMD_RETPOLINE_AMD ||
+	     cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE ||
 	     cmd == SPECTRE_V2_CMD_RETPOLINE_GENERIC) &&
 	    !IS_ENABLED(CONFIG_RETPOLINE)) {
 		pr_err("%s selected but not compiled in. Switching to AUTO select\n", mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
+	if ((cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE) &&
+	    !boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
+		pr_err("%s selected, but CPU doesn't have a serializing LFENCE. Switching to AUTO select\n", mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
 	spec_v2_print_cond(mitigation_options[i].option,
 			   mitigation_options[i].secure);
 	return cmd;
@@ -916,9 +923,9 @@ static void __init spectre_v2_select_mit
 		if (IS_ENABLED(CONFIG_RETPOLINE))
 			goto retpoline_auto;
 		break;
-	case SPECTRE_V2_CMD_RETPOLINE_AMD:
+	case SPECTRE_V2_CMD_RETPOLINE_LFENCE:
 		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_amd;
+			goto retpoline_lfence;
 		break;
 	case SPECTRE_V2_CMD_RETPOLINE_GENERIC:
 		if (IS_ENABLED(CONFIG_RETPOLINE))
@@ -935,17 +942,17 @@ static void __init spectre_v2_select_mit
 retpoline_auto:
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
-	retpoline_amd:
+	retpoline_lfence:
 		if (!boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
 			pr_err("Spectre mitigation: LFENCE not serializing, switching to generic retpoline\n");
 			goto retpoline_generic;
 		}
-		mode = SPECTRE_V2_RETPOLINE_AMD;
-		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_AMD);
+		mode = SPECTRE_V2_LFENCE;
+		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_LFENCE);
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
 	} else {
 	retpoline_generic:
-		mode = SPECTRE_V2_RETPOLINE_GENERIC;
+		mode = SPECTRE_V2_RETPOLINE;
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
 	}
 
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -34,7 +34,7 @@ SYM_INNER_LABEL(__x86_indirect_thunk_\re
 
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_AMD
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 
 .endm
 
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -394,7 +394,7 @@ static void emit_indirect_jump(u8 **ppro
 	u8 *prog = *pprog;
 
 #ifdef CONFIG_RETPOLINE
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_AMD)) {
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -204,7 +204,7 @@
 /* FREE!                                ( 7*32+10) */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCEs for Spectre variant 2 */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */


