Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329DC1F438E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbgFIRyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733086AbgFIRyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0AA320801;
        Tue,  9 Jun 2020 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725264;
        bh=f+8D/Ne//89piy8TFZmlemtTQKewWDLM3HEqhNsGpig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCAnRjm7NRCv6cVGH+8+MzoZmOUDkRCsCwAEnENJV9HMNeNz0OQw272G41PwZbN0S
         +vco09oznt1y7iJ8D7wVdJjhopJrU7W2L05MBps5HKAgIL3UUBy37wJoS9vodtIAGt
         9W25YwSSuAwJC5hshRh0Ol6Vu+0pX+jFdrTFQuc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 5.6 36/41] x86/cpu: Add table argument to cpu_matches()
Date:   Tue,  9 Jun 2020 19:45:38 +0200
Message-Id: <20200609174115.494862120@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
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
 arch/x86/kernel/cpu/common.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1075,9 +1075,9 @@ static const __initconst struct x86_cpu_
 	{}
 };
 
-static bool __init cpu_matches(unsigned long which)
+static bool __init cpu_matches(const struct x86_cpu_id *table, unsigned long which)
 {
-	const struct x86_cpu_id *m = x86_match_cpu(cpu_vuln_whitelist);
+	const struct x86_cpu_id *m = x86_match_cpu(table);
 
 	return m && !!(m->driver_data & which);
 }
@@ -1097,31 +1097,34 @@ static void __init cpu_set_bug_bits(stru
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
 
-	if (!cpu_matches(NO_SPECTRE_V2))
+	if (!cpu_matches(cpu_vuln_whitelist, NO_SPECTRE_V2))
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
@@ -1139,7 +1142,7 @@ static void __init cpu_set_bug_bits(stru
 	     (ia32_cap & ARCH_CAP_TSX_CTRL_MSR)))
 		setup_force_cpu_bug(X86_BUG_TAA);
 
-	if (cpu_matches(NO_MELTDOWN))
+	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
 	/* Rogue Data Cache Load? No! */
@@ -1148,7 +1151,7 @@ static void __init cpu_set_bug_bits(stru
 
 	setup_force_cpu_bug(X86_BUG_CPU_MELTDOWN);
 
-	if (cpu_matches(NO_L1TF))
+	if (cpu_matches(cpu_vuln_whitelist, NO_L1TF))
 		return;
 
 	setup_force_cpu_bug(X86_BUG_L1TF);


