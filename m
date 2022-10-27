Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEED6103C1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbiJ0VDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiJ0VDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:03:00 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399F541D21;
        Thu, 27 Oct 2022 13:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904116; x=1698440116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IFP17l3p2vXpRhyrCNJyVeYoanzUemr1XcTJhAIt5X8=;
  b=CfDGunjtCS7wzwamDjx7ZMiQvxNsmipUt93TJ/2KC0E7EzVFPxhO6iel
   cZKLQtmCWzqvgkuby6hTR1uQzNtAGsJzbq8zEZk7uLvuZxDNkZTBdZT8f
   kmMw1M/mB+83E/gORspQnb/gbqG8MPqXdygPyStSwUn+BtkXI3dSBZaHF
   0=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="260700264"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:55:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id EE19F61323;
        Thu, 27 Oct 2022 20:55:12 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:55:12 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.223) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:55:12 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 16/34] x86/bugs: Report Intel retbleed vulnerability
Date:   Thu, 27 Oct 2022 13:55:02 -0700
Message-ID: <20221027205502.17426-4-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205502.17426-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205502.17426-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D08UWC002.ant.amazon.com (10.43.162.168) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
[ bp: Adjust to different processor family names ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/bugs.c       | 42 ++++++++++++++++++++++++++------
 arch/x86/kernel/cpu/common.c     | 24 +++++++++---------
 3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c090d8e8fbb3..f5341b4de46a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -73,6 +73,7 @@
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
 #define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
 #define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_RSBA			BIT(2)	/* RET may use alternative branch predictors */
 #define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	BIT(3)	/* Skip L1D flush on vmentry */
 #define ARCH_CAP_SSB_NO			BIT(4)	/*
 						 * Not susceptible to Speculative Store Bypass
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 3ed67d5f1a04..01604ea478b0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -743,11 +743,16 @@ static int __init nospectre_v1_cmdline(char *str)
 }
 early_param("nospectre_v1", nospectre_v1_cmdline);
 
+static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
+	SPECTRE_V2_NONE;
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "RETBleed: " fmt
 
 enum retbleed_mitigation {
-	RETBLEED_MITIGATION_NONE
+	RETBLEED_MITIGATION_NONE,
+	RETBLEED_MITIGATION_IBRS,
+	RETBLEED_MITIGATION_EIBRS,
 };
 
 enum retbleed_mitigation_cmd {
@@ -756,7 +761,9 @@ enum retbleed_mitigation_cmd {
 };
 
 const char * const retbleed_strings[] = {
-	[RETBLEED_MITIGATION_NONE]	= "Vulnerable"
+	[RETBLEED_MITIGATION_NONE]	= "Vulnerable",
+	[RETBLEED_MITIGATION_IBRS]	= "Mitigation: IBRS",
+	[RETBLEED_MITIGATION_EIBRS]	= "Mitigation: Enhanced IBRS",
 };
 
 static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
@@ -780,6 +787,8 @@ static int __init retbleed_parse_cmdline(char *str)
 }
 early_param("retbleed", retbleed_parse_cmdline);
 
+#define RETBLEED_INTEL_MSG "WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed attacks, data leaks possible!\n"
+
 static void __init retbleed_select_mitigation(void)
 {
 	if (!boot_cpu_has_bug(X86_BUG_RETBLEED) || cpu_mitigations_off())
@@ -791,8 +800,11 @@ static void __init retbleed_select_mitigation(void)
 
 	case RETBLEED_CMD_AUTO:
 	default:
-		if (!boot_cpu_has_bug(X86_BUG_RETBLEED))
-			break;
+		/*
+		 * The Intel mitigation (IBRS) was already selected in
+		 * spectre_v2_select_mitigation().
+		 */
+
 		break;
 	}
 
@@ -801,15 +813,31 @@ static void __init retbleed_select_mitigation(void)
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b6fa5fdc3e17..c7202647daeb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -999,24 +999,24 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(BROADWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
-						BIT(7) | BIT(0xB),              MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
+						BIT(7) | BIT(0xB),              MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
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
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
@@ -1129,7 +1129,7 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
-	if (cpu_matches(cpu_vuln_blacklist, RETBLEED))
+	if ((cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA)))
 		setup_force_cpu_bug(X86_BUG_RETBLEED);
 
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
-- 
2.17.1

