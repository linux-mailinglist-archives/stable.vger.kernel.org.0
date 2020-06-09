Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E221F44E3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388482AbgFISJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:09:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41354 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388158AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pP-M7; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-006VxZ-8X; Tue, 09 Jun 2020 19:05:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Mark Gross" <mgross@linux.intel.com>,
        "Borislav Petkov" <bp@suse.de>
Date:   Tue, 09 Jun 2020 19:04:47 +0100
Message-ID: <lsq.1591725832.74544440@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 56/61] x86/cpu: Add 'table' argument to cpu_matches()
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Gross <mgross@linux.intel.com>

commit 93920f61c2ad7edb01e63323832585796af75fc9 upstream.

To make cpu_matches() reusable for other matching tables, have it take a
pointer to a x86_cpu_id table as an argument.

 [ bp: Flip arguments order. ]

Signed-off-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/common.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -872,9 +872,9 @@ static const __initconst struct x86_cpu_
 	{}
 };
 
-static bool __init cpu_matches(unsigned long which)
+static bool __init cpu_matches(const struct x86_cpu_id *table, unsigned long which)
 {
-	const struct x86_cpu_id *m = x86_match_cpu(cpu_vuln_whitelist);
+	const struct x86_cpu_id *m = x86_match_cpu(table);
 
 	return m && !!(m->driver_data & which);
 }
@@ -894,29 +894,32 @@ static void __init cpu_set_bug_bits(stru
 	u64 ia32_cap = x86_read_arch_cap_msr();
 
 	/* Set ITLB_MULTIHIT bug if cpu is not in the whitelist and not mitigated */
-	if (!cpu_matches(NO_ITLB_MULTIHIT) && !(ia32_cap & ARCH_CAP_PSCHANGE_MC_NO))
+	if (!cpu_matches(cpu_vuln_whitelist, NO_ITLB_MULTIHIT) &&
+	    !(ia32_cap & ARCH_CAP_PSCHANGE_MC_NO))
 		setup_force_cpu_bug(X86_BUG_ITLB_MULTIHIT);
 
-	if (cpu_matches(NO_SPECULATION))
+	if (cpu_matches(cpu_vuln_whitelist, NO_SPECULATION))
 		return;
 
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
 
-	if (!cpu_matches(NO_SSB) && !(ia32_cap & ARCH_CAP_SSB_NO) &&
+	if (!cpu_matches(cpu_vuln_whitelist, NO_SSB) &&
+	    !(ia32_cap & ARCH_CAP_SSB_NO) &&
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
 
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 
-	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO)) {
+	if (!cpu_matches(cpu_vuln_whitelist, NO_MDS) &&
+	    !(ia32_cap & ARCH_CAP_MDS_NO)) {
 		setup_force_cpu_bug(X86_BUG_MDS);
-		if (cpu_matches(MSBDS_ONLY))
+		if (cpu_matches(cpu_vuln_whitelist, MSBDS_ONLY))
 			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
 	}
 
-	if (!cpu_matches(NO_SWAPGS))
+	if (!cpu_matches(cpu_vuln_whitelist, NO_SWAPGS))
 		setup_force_cpu_bug(X86_BUG_SWAPGS);
 
 	/*
@@ -934,7 +937,7 @@ static void __init cpu_set_bug_bits(stru
 	     (ia32_cap & ARCH_CAP_TSX_CTRL_MSR)))
 		setup_force_cpu_bug(X86_BUG_TAA);
 
-	if (cpu_matches(NO_MELTDOWN))
+	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
 	/* Rogue Data Cache Load? No! */
@@ -943,7 +946,7 @@ static void __init cpu_set_bug_bits(stru
 
 	setup_force_cpu_bug(X86_BUG_CPU_MELTDOWN);
 
-	if (cpu_matches(NO_L1TF))
+	if (cpu_matches(cpu_vuln_whitelist, NO_L1TF))
 		return;
 
 	setup_force_cpu_bug(X86_BUG_L1TF);

