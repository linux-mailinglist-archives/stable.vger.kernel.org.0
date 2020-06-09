Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5380F1F4321
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732699AbgFIRuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732690AbgFIRuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F02CC20774;
        Tue,  9 Jun 2020 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725031;
        bh=ptMIwntJnMGbrD0v5s0o+uuIc2+29HxsaQvIIRbjF1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZiG4/UxjQkE1bfvdHBifW0sJAF950TfPaX6hbqDQVBQG6SjVdN4QIS8J57PcVsKU
         hm0Emqf4VhnMyRBl4/JyuAld67AUaYQGehnZTRIf4V5WPu3TkJBI6dunsH/l/qxfQb
         IHuspCD6r8wl+dcktn8SzEUWtNrQheheX8y4bQVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 4.14 41/46] x86/cpu: Add table argument to cpu_matches()
Date:   Tue,  9 Jun 2020 19:44:57 +0200
Message-Id: <20200609174030.541493657@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Gross <mgross@linux.intel.com>

commit 93920f61c2ad7edb01e63323832585796af75fc9 upstream

To make cpu_matches() reusable for other matching tables, have it take a
pointer to a x86_cpu_id table as an argument.

 [ bp: Flip arguments order. ]

Signed-off-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -964,9 +964,9 @@ static const __initconst struct x86_cpu_
 	{}
 };
 
-static bool __init cpu_matches(unsigned long which)
+static bool __init cpu_matches(const struct x86_cpu_id *table, unsigned long which)
 {
-	const struct x86_cpu_id *m = x86_match_cpu(cpu_vuln_whitelist);
+	const struct x86_cpu_id *m = x86_match_cpu(table);
 
 	return m && !!(m->driver_data & which);
 }
@@ -986,29 +986,32 @@ static void __init cpu_set_bug_bits(stru
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
@@ -1026,7 +1029,7 @@ static void __init cpu_set_bug_bits(stru
 	     (ia32_cap & ARCH_CAP_TSX_CTRL_MSR)))
 		setup_force_cpu_bug(X86_BUG_TAA);
 
-	if (cpu_matches(NO_MELTDOWN))
+	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
 	/* Rogue Data Cache Load? No! */
@@ -1035,7 +1038,7 @@ static void __init cpu_set_bug_bits(stru
 
 	setup_force_cpu_bug(X86_BUG_CPU_MELTDOWN);
 
-	if (cpu_matches(NO_L1TF))
+	if (cpu_matches(cpu_vuln_whitelist, NO_L1TF))
 		return;
 
 	setup_force_cpu_bug(X86_BUG_L1TF);


