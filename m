Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E14A1F284
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfEOLLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729088AbfEOLLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52DC321726;
        Wed, 15 May 2019 11:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918692;
        bh=LnkZbPbNRWSWIPTAD+qz0Ztz586ln251+5OhDu+Xg64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+YDjOrWmG+KcrjEpuSIdrC0Zoms9QYro7BlJ0hvWsQDz+07Wlr6pvCw4quwhu4Vm
         nfkAHSeW7LOxWoiDtr9htSERdfwXoCW18TLNQspZW0rWeasU4jY3dojKbcPEhPBG9v
         4m8RDH3E97+lXcUNwdJYJCiXGUsFv5e05s40sMTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Borislav Petkov <bp@suse.de>, Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 229/266] x86/speculation: Consolidate CPU whitelists
Date:   Wed, 15 May 2019 12:55:36 +0200
Message-Id: <20190515090730.749271442@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 36ad35131adacc29b328b9c8b6277a8bf0d6fd5d upstream.

The CPU vulnerability whitelists have some overlap and there are more
whitelists coming along.

Use the driver_data field in the x86_cpu_id struct to denote the
whitelisted vulnerabilities and combine all whitelists into one.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |  103 ++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 48 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -847,60 +847,68 @@ static void identify_cpu_without_cpuid(s
 #endif
 }
 
-static const __initconst struct x86_cpu_id cpu_no_speculation[] = {
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_SALTWELL,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_SALTWELL_TABLET,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_BONNELL_MID,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_SALTWELL_MID,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_BONNELL,	X86_FEATURE_ANY },
-	{ X86_VENDOR_CENTAUR,	5 },
-	{ X86_VENDOR_INTEL,	5 },
-	{ X86_VENDOR_NSC,	5 },
-	{ X86_VENDOR_ANY,	4 },
-	{}
-};
+#define NO_SPECULATION	BIT(0)
+#define NO_MELTDOWN	BIT(1)
+#define NO_SSB		BIT(2)
+#define NO_L1TF		BIT(3)
+
+#define VULNWL(_vendor, _family, _model, _whitelist)	\
+	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
+
+#define VULNWL_INTEL(model, whitelist)		\
+	VULNWL(INTEL, 6, INTEL_FAM6_##model, whitelist)
+
+#define VULNWL_AMD(family, whitelist)		\
+	VULNWL(AMD, family, X86_MODEL_ANY, whitelist)
+
+static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
+	VULNWL(ANY,	4, X86_MODEL_ANY,	NO_SPECULATION),
+	VULNWL(CENTAUR,	5, X86_MODEL_ANY,	NO_SPECULATION),
+	VULNWL(INTEL,	5, X86_MODEL_ANY,	NO_SPECULATION),
+	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
+
+	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION),
+	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION),
+	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION),
+	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
+	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
+
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF),
+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF),
+
+	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
+
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_L1TF),
+
+	VULNWL_AMD(0x0f,		NO_MELTDOWN | NO_SSB | NO_L1TF),
+	VULNWL_AMD(0x10,		NO_MELTDOWN | NO_SSB | NO_L1TF),
+	VULNWL_AMD(0x11,		NO_MELTDOWN | NO_SSB | NO_L1TF),
+	VULNWL_AMD(0x12,		NO_MELTDOWN | NO_SSB | NO_L1TF),
 
-static const __initconst struct x86_cpu_id cpu_no_meltdown[] = {
-	{ X86_VENDOR_AMD },
+	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF),
 	{}
 };
 
-/* Only list CPUs which speculate but are non susceptible to SSB */
-static const __initconst struct x86_cpu_id cpu_no_spec_store_bypass[] = {
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_X	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_MID	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_CORE_YONAH		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
-	{ X86_VENDOR_AMD,	0x12,					},
-	{ X86_VENDOR_AMD,	0x11,					},
-	{ X86_VENDOR_AMD,	0x10,					},
-	{ X86_VENDOR_AMD,	0xf,					},
-	{}
-};
+static bool __init cpu_matches(unsigned long which)
+{
+	const struct x86_cpu_id *m = x86_match_cpu(cpu_vuln_whitelist);
 
-static const __initconst struct x86_cpu_id cpu_no_l1tf[] = {
-	/* in addition to cpu_no_speculation */
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_X	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_MID	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT_MID	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GOLDMONT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GOLDMONT_X	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GOLDMONT_PLUS	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
-	{}
-};
+	return m && !!(m->driver_data & which);
+}
 
 static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 {
 	u64 ia32_cap = 0;
 
-	if (x86_match_cpu(cpu_no_speculation))
+	if (cpu_matches(NO_SPECULATION))
 		return;
 
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
@@ -909,15 +917,14 @@ static void __init cpu_set_bug_bits(stru
 	if (cpu_has(c, X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, ia32_cap);
 
-	if (!x86_match_cpu(cpu_no_spec_store_bypass) &&
-	   !(ia32_cap & ARCH_CAP_SSB_NO) &&
+	if (!cpu_matches(NO_SSB) && !(ia32_cap & ARCH_CAP_SSB_NO) &&
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
 
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 
-	if (x86_match_cpu(cpu_no_meltdown))
+	if (cpu_matches(NO_MELTDOWN))
 		return;
 
 	/* Rogue Data Cache Load? No! */
@@ -926,7 +933,7 @@ static void __init cpu_set_bug_bits(stru
 
 	setup_force_cpu_bug(X86_BUG_CPU_MELTDOWN);
 
-	if (x86_match_cpu(cpu_no_l1tf))
+	if (cpu_matches(NO_L1TF))
 		return;
 
 	setup_force_cpu_bug(X86_BUG_L1TF);


