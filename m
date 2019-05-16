Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8136720BBD
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEPP6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42362 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbfEPP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:41 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0006zQ-7d; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Ob-BZ; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        bp@suse.de, "Thomas Gleixner" <tglx@linutronix.de>,
        konrad.wilk@oracle.com,
        "Dominik Brodowski" <linux@dominikbrodowski.net>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.174232137@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 28/86] x86/speculation: Simplify the CPU bug
 detection logic
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 8ecc4979b1bd9c94168e6fc92960033b7a951336 upstream.

Only CPUs which speculate can speculate. Therefore, it seems prudent
to test for cpu_no_speculation first and only then determine whether
a specific speculating CPU is susceptible to store bypass speculation.
This is underlined by all CPUs currently listed in cpu_no_speculation
were present in cpu_no_spec_store_bypass as well.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@suse.de
Cc: konrad.wilk@oracle.com
Link: https://lkml.kernel.org/r/20180522090539.GA24668@light.dominikbrodowski.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/common.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -825,12 +825,8 @@ static const __initconst struct x86_cpu_
 	{}
 };
 
+/* Only list CPUs which speculate but are non susceptible to SSB */
 static const __initconst struct x86_cpu_id cpu_no_spec_store_bypass[] = {
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_PINEVIEW	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_LINCROFT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_PENWELL		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_CLOVERVIEW	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_CEDARVIEW	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT1	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT2	},
@@ -838,14 +834,10 @@ static const __initconst struct x86_cpu_
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_CORE_YONAH		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
-	{ X86_VENDOR_CENTAUR,	5,					},
-	{ X86_VENDOR_INTEL,	5,					},
-	{ X86_VENDOR_NSC,	5,					},
 	{ X86_VENDOR_AMD,	0x12,					},
 	{ X86_VENDOR_AMD,	0x11,					},
 	{ X86_VENDOR_AMD,	0x10,					},
 	{ X86_VENDOR_AMD,	0xf,					},
-	{ X86_VENDOR_ANY,	4,					},
 	{}
 };
 
@@ -868,6 +860,12 @@ static void __init cpu_set_bug_bits(stru
 {
 	u64 ia32_cap = 0;
 
+	if (x86_match_cpu(cpu_no_speculation))
+		return;
+
+	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
+	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
+
 	if (cpu_has(c, X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, ia32_cap);
 
@@ -876,12 +874,6 @@ static void __init cpu_set_bug_bits(stru
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
 
-	if (x86_match_cpu(cpu_no_speculation))
-		return;
-
-	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
-	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
-
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 

