Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04857F284
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404880AbfHBJrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405716AbfHBJrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:47:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F8720B7C;
        Fri,  2 Aug 2019 09:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739266;
        bh=fE9gGFqLUYNcZs02+L4GYrACGd/PvDwOY0Rqx2oGWv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaezNV+cK4/dFJsOy40Eu1eyB1wp3CjPI2y4rj/BICRPDCzl+bj8BvZkQKOlZ61cK
         YrwPdP4nlGUw7QxCEz42GqG83+VoMpat8X411g5Z/ndqFKh/tfAsRRgIvVi9u4zbnm
         NQMtNTX32p/VnghTb3BCaoTbWJJGm5O/khGFPzWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Subject: [PATCH 4.9 153/223] perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_llc_id
Date:   Fri,  2 Aug 2019 11:36:18 +0200
Message-Id: <20190802092248.323135956@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/events/amd/uncore.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 10f023799f11..c16c99bc2a10 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/perf_event.h>
 #include <asm/msr.h>
+#include <asm/smp.h>
 
 #define NUM_COUNTERS_NB		4
 #define NUM_COUNTERS_L2		4
@@ -377,26 +378,8 @@ static int amd_uncore_cpu_starting(unsigned int cpu)
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



