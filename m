Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BA5572496
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbiGLTGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbiGLTFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:05:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38C6E192B;
        Tue, 12 Jul 2022 11:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C2FB81B95;
        Tue, 12 Jul 2022 18:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A012C3411E;
        Tue, 12 Jul 2022 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651856;
        bh=o64EA64cUmF1Ay4fLmJzes9gerwCvGRLek4oR5qbdYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VO/b3NBIisFPIFnOrQUh8drLMOCuXRNz3MAcL1zAWBWFoy8dzrCXBRz4xWDiRypaa
         SVcujcjErpIF4Z1QOUSxomJe4kz+MWyxfhkjuNCHanG8rTYaUh34Cf/OotEiPD8iZw
         Im0v6cocRw8AM0smUHnufy2Yg5uTLH5qBpaUSeak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 50/78] x86/bugs: Report Intel retbleed vulnerability
Date:   Tue, 12 Jul 2022 20:39:20 +0200
Message-Id: <20220712183240.917116196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 6ad0ad2bf8a67e27d1f9d006a1dabb0e1c360cc3 upstream.

Skylake suffers from RSB underflow speculation issues; report this
vulnerability and it's mitigation (spectre_v2=ibrs).

  [jpoimboe: cleanups, eibrs]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/kernel/cpu/bugs.c       |   39 +++++++++++++++++++++++++++++++++------
 arch/x86/kernel/cpu/common.c     |   24 ++++++++++++------------
 3 files changed, 46 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -91,6 +91,7 @@
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
 #define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
 #define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_RSBA			BIT(2)	/* RET may use alternative branch predictors */
 #define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	BIT(3)	/* Skip L1D flush on vmentry */
 #define ARCH_CAP_SSB_NO			BIT(4)	/*
 						 * Not susceptible to Speculative Store Bypass
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -783,12 +783,17 @@ static int __init nospectre_v1_cmdline(c
 }
 early_param("nospectre_v1", nospectre_v1_cmdline);
 
+static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
+	SPECTRE_V2_NONE;
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "RETBleed: " fmt
 
 enum retbleed_mitigation {
 	RETBLEED_MITIGATION_NONE,
 	RETBLEED_MITIGATION_UNRET,
+	RETBLEED_MITIGATION_IBRS,
+	RETBLEED_MITIGATION_EIBRS,
 };
 
 enum retbleed_mitigation_cmd {
@@ -800,6 +805,8 @@ enum retbleed_mitigation_cmd {
 const char * const retbleed_strings[] = {
 	[RETBLEED_MITIGATION_NONE]	= "Vulnerable",
 	[RETBLEED_MITIGATION_UNRET]	= "Mitigation: untrained return thunk",
+	[RETBLEED_MITIGATION_IBRS]	= "Mitigation: IBRS",
+	[RETBLEED_MITIGATION_EIBRS]	= "Mitigation: Enhanced IBRS",
 };
 
 static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
@@ -842,6 +849,7 @@ early_param("retbleed", retbleed_parse_c
 
 #define RETBLEED_UNTRAIN_MSG "WARNING: BTB untrained return thunk mitigation is only effective on AMD/Hygon!\n"
 #define RETBLEED_COMPILER_MSG "WARNING: kernel not compiled with RETPOLINE or -mfunction-return capable compiler!\n"
+#define RETBLEED_INTEL_MSG "WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed attacks, data leaks possible!\n"
 
 static void __init retbleed_select_mitigation(void)
 {
@@ -858,12 +866,15 @@ static void __init retbleed_select_mitig
 
 	case RETBLEED_CMD_AUTO:
 	default:
-		if (!boot_cpu_has_bug(X86_BUG_RETBLEED))
-			break;
-
 		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
 			retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+
+		/*
+		 * The Intel mitigation (IBRS) was already selected in
+		 * spectre_v2_select_mitigation().
+		 */
+
 		break;
 	}
 
@@ -893,15 +904,31 @@ static void __init retbleed_select_mitig
 		break;
 	}
 
+	/*
+	 * Let IBRS trump all on Intel without affecting the effects of the
+	 * retbleed= cmdline option.
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+		switch (spectre_v2_enabled) {
+		case SPECTRE_V2_IBRS:
+			retbleed_mitigation = RETBLEED_MITIGATION_IBRS;
+			break;
+		case SPECTRE_V2_EIBRS:
+		case SPECTRE_V2_EIBRS_RETPOLINE:
+		case SPECTRE_V2_EIBRS_LFENCE:
+			retbleed_mitigation = RETBLEED_MITIGATION_EIBRS;
+			break;
+		default:
+			pr_err(RETBLEED_INTEL_MSG);
+		}
+	}
+
 	pr_info("%s\n", retbleed_strings[retbleed_mitigation]);
 }
 
 #undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V2 : " fmt
 
-static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
-	SPECTRE_V2_NONE;
-
 static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1127,24 +1127,24 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(BROADWELL_G,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
-						BIT(7) | BIT(0xB),              MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
+						BIT(7) | BIT(0xB),              MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO),
-	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
@@ -1254,7 +1254,7 @@ static void __init cpu_set_bug_bits(stru
 	    !arch_cap_mmio_immune(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
 
-	if (cpu_matches(cpu_vuln_blacklist, RETBLEED))
+	if ((cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA)))
 		setup_force_cpu_bug(X86_BUG_RETBLEED);
 
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))


