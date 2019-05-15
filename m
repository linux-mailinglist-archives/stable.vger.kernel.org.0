Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D201ED99
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfEOLLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729088AbfEOLLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA04B20843;
        Wed, 15 May 2019 11:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918698;
        bh=o4axuyy1NAMWqo7oV48Zjm+ukK6x6IRbm+fKo0kgn04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXRiZsfx/kWyB4Z3/eLvHQWBnSUTU1lgSSZVr3yVDuOF+kuUXHCgBZZkCzBMqzi3G
         ML5FcTiNBylSWJK5rrK3Ff/qm/8V9zVYq6E3981xIsGQOz/Uh2PKyrP/n6B5mf1Uyv
         0j8JEPHedz17GGhikO5XXusPn+KCn0Wii8o+fnXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 231/266] x86/speculation/mds: Add BUG_MSBDS_ONLY
Date:   Wed, 15 May 2019 12:55:38 +0200
Message-Id: <20190515090730.817858081@linuxfoundation.org>
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

commit e261f209c3666e842fd645a1e31f001c3a26def9 upstream.

This bug bit is set on CPUs which are only affected by Microarchitectural
Store Buffer Data Sampling (MSBDS) and not by any other MDS variant.

This is important because the Store Buffers are partitioned between
Hyper-Threads so cross thread forwarding is not possible. But if a thread
enters or exits a sleep state the store buffer is repartitioned which can
expose data from one thread to the other. This transition can be mitigated.

That means that for CPUs which are only affected by MSBDS SMT can be
enabled, if the CPU is not affected by other SMT sensitive vulnerabilities,
e.g. L1TF. The XEON PHI variants fall into that category. Also the
Silvermont/Airmont ATOMs, but for them it's not really relevant as they do
not support SMT, but mark them for completeness sake.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 4.4: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/common.c       |   20 ++++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -337,5 +337,6 @@
 #define X86_BUG_SPEC_STORE_BYPASS X86_BUG(17) /* CPU is affected by speculative store bypass attack */
 #define X86_BUG_L1TF		X86_BUG(18) /* CPU is affected by L1 Terminal Fault */
 #define X86_BUG_MDS		X86_BUG(19) /* CPU is affected by Microarchitectural data sampling */
+#define X86_BUG_MSBDS_ONLY	X86_BUG(20) /* CPU is only affected by the  MSDBS variant of BUG_MDS */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -852,6 +852,7 @@ static void identify_cpu_without_cpuid(s
 #define NO_SSB		BIT(2)
 #define NO_L1TF		BIT(3)
 #define NO_MDS		BIT(4)
+#define MSBDS_ONLY	BIT(5)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -875,16 +876,16 @@ static const __initconst struct x86_cpu_
 	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
 	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
 
-	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF),
-	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF),
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY),
 
 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
 
-	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF),
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY),
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF),
@@ -928,8 +929,11 @@ static void __init cpu_set_bug_bits(stru
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 
-	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO))
+	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO)) {
 		setup_force_cpu_bug(X86_BUG_MDS);
+		if (cpu_matches(MSBDS_ONLY))
+			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
+	}
 
 	if (cpu_matches(NO_MELTDOWN))
 		return;


