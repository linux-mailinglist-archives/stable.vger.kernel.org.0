Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E45798C2
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfG2Ten (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388281AbfG2Tem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E0E92070B;
        Mon, 29 Jul 2019 19:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428882;
        bh=XO+6JP4T9omkolO039O/6hZFh57nRKGvyiVIMiYPqpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/hiwckXqNYQhii+RRJZuRazem/PcnJIZ3tbrNXzfQ5LKB+qeGiI/k48fnfnb4vXX
         kTcIpi00l/KcWc7MFx/Dpar7VbVsx2GLM4sYB69t5L+JKxuZLob/rixjViK4bLDSGd
         1fJmXASwhg1+N0El/vfZsqUjR5baERndBG7LLcs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 215/293] perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_llc_id
Date:   Mon, 29 Jul 2019 21:21:46 +0200
Message-Id: <20190729190840.965994077@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 812af433038f984fd951224e8239b09188e36a13 ]

Current logic iterates over CPUID Fn8000001d leafs (Cache Properties)
to detect the last level cache, and derive the last-level cache ID.
However, this information is already available in the cpu_llc_id.
Therefore, make use of it instead.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Link: http://lkml.kernel.org/r/1524864877-111962-3-git-send-email-suravee.suthikulpanit@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 3a9ab16d9c2b..baa7e36073f9 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/perf_event.h>
 #include <asm/msr.h>
+#include <asm/smp.h>
 
 #define NUM_COUNTERS_NB		4
 #define NUM_COUNTERS_L2		4
@@ -414,26 +415,8 @@ static int amd_uncore_cpu_starting(unsigned int cpu)
 	}
 
 	if (amd_uncore_llc) {
-		unsigned int apicid = cpu_data(cpu).apicid;
-		unsigned int nshared, subleaf, prev_eax = 0;
-
 		uncore = *per_cpu_ptr(amd_uncore_llc, cpu);
-		/*
-		 * Iterate over Cache Topology Definition leaves until no
-		 * more cache descriptions are available.
-		 */
-		for (subleaf = 0; subleaf < 5; subleaf++) {
-			cpuid_count(0x8000001d, subleaf, &eax, &ebx, &ecx, &edx);
-
-			/* EAX[0:4] gives type of cache */
-			if (!(eax & 0x1f))
-				break;
-
-			prev_eax = eax;
-		}
-		nshared = ((prev_eax >> 14) & 0xfff) + 1;
-
-		uncore->id = apicid - (apicid % nshared);
+		uncore->id = per_cpu(cpu_llc_id, cpu);
 
 		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_llc);
 		*per_cpu_ptr(amd_uncore_llc, cpu) = uncore;
-- 
2.20.1



