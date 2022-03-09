Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F59F4D326C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbiCIQE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiCIQEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:04:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B58DF3D;
        Wed,  9 Mar 2022 08:02:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 854BCB82191;
        Wed,  9 Mar 2022 16:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54FBC36AE2;
        Wed,  9 Mar 2022 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841753;
        bh=yHBwrv2aWD/9H1DZRrYgDaAP2sk5Lz5EFwkKNbq0IRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfLYjJRw+mXamfWC+1x3DuA7jkb5zFZG316pxOBtAT/8kPqQLZRbKhUystTaC3OfG
         a3XeixNZ9ullJwNCpXZt1ODZWWyk92kzlaJJ59f3Z+5cfx+PCdL3dhtMRhsNUHiTIf
         mqMPiJf8awIXbs7SpR8xrmr7ssUUVeo+X2ZmYz+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 03/18] x86/speculation: Rename RETPOLINE_AMD to RETPOLINE_LFENCE
Date:   Wed,  9 Mar 2022 16:59:33 +0100
Message-Id: <20220309155856.194973771@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.090281301@linuxfoundation.org>
References: <20220309155856.090281301@linuxfoundation.org>
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
[fllinden@amazon.com: backported to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h       |    2 +-
 arch/x86/include/asm/nospec-branch.h     |   12 ++++++------
 arch/x86/kernel/cpu/bugs.c               |   29 ++++++++++++++++++-----------
 tools/arch/x86/include/asm/cpufeatures.h |    2 +-
 4 files changed, 26 insertions(+), 19 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -203,7 +203,7 @@
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -119,7 +119,7 @@
 	ANNOTATE_NOSPEC_ALTERNATIVE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *\reg),	\
 		__stringify(RETPOLINE_JMP \reg), X86_FEATURE_RETPOLINE,	\
-		__stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *\reg), X86_FEATURE_RETPOLINE_AMD
+		__stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	jmp	*\reg
 #endif
@@ -130,7 +130,7 @@
 	ANNOTATE_NOSPEC_ALTERNATIVE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; call *\reg),	\
 		__stringify(RETPOLINE_CALL \reg), X86_FEATURE_RETPOLINE,\
-		__stringify(lfence; ANNOTATE_RETPOLINE_SAFE; call *\reg), X86_FEATURE_RETPOLINE_AMD
+		__stringify(lfence; ANNOTATE_RETPOLINE_SAFE; call *\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	call	*\reg
 #endif
@@ -181,7 +181,7 @@
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_AMD)
+	X86_FEATURE_RETPOLINE_LFENCE)
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 
 #else /* CONFIG_X86_32 */
@@ -211,7 +211,7 @@
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_AMD)
+	X86_FEATURE_RETPOLINE_LFENCE)
 
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #endif
@@ -223,8 +223,8 @@
 /* The Spectre V2 mitigation variants */
 enum spectre_v2_mitigation {
 	SPECTRE_V2_NONE,
-	SPECTRE_V2_RETPOLINE_GENERIC,
-	SPECTRE_V2_RETPOLINE_AMD,
+	SPECTRE_V2_RETPOLINE,
+	SPECTRE_V2_LFENCE,
 	SPECTRE_V2_IBRS_ENHANCED,
 };
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -621,7 +621,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_FORCE,
 	SPECTRE_V2_CMD_RETPOLINE,
 	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
-	SPECTRE_V2_CMD_RETPOLINE_AMD,
+	SPECTRE_V2_CMD_RETPOLINE_LFENCE,
 };
 
 enum spectre_v2_user_cmd {
@@ -781,8 +781,8 @@ set_mode:
 
 static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
-	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
-	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
+	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
+	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
 	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
 };
 
@@ -794,7 +794,8 @@ static const struct {
 	{ "off",		SPECTRE_V2_CMD_NONE,		  false },
 	{ "on",			SPECTRE_V2_CMD_FORCE,		  true  },
 	{ "retpoline",		SPECTRE_V2_CMD_RETPOLINE,	  false },
-	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_AMD,	  false },
+	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
+	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
 	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
 };
@@ -832,13 +833,19 @@ static enum spectre_v2_mitigation_cmd __
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
@@ -873,9 +880,9 @@ static void __init spectre_v2_select_mit
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
@@ -891,17 +898,17 @@ static void __init spectre_v2_select_mit
 
 retpoline_auto:
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
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
 
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -203,7 +203,7 @@
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCEs for Spectre variant 2 */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */


