Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A86F7F285
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405048AbfHBJrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405716AbfHBJro (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:47:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B618820880;
        Fri,  2 Aug 2019 09:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739264;
        bh=+WUMdsBTBGurwTRfQbddsebWWDW3fHpFQ8g9jEtC8wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8ga7047pUwMMcWgVaSsqZayHAhlbqkijzFw0gdU+lkOT5izywcpch4hCWBrRafmJ
         /vG/RemtVhapwHt95KOyRHskEJx1x9tcN/eSCEp97IkjIh70ZlKg1gYqLE43MtpJe9
         fRJQMMF4ZChcoAB0SxWzr+/y7VmvU12Kt+7eIhgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 152/223] perf/x86/amd/uncore: Get correct number of cores sharing last level cache
Date:   Fri,  2 Aug 2019 11:36:17 +0200
Message-Id: <20190802092248.283719085@linuxfoundation.org>
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

In Family 17h, the number of cores sharing a cache level is obtained
from the Cache Properties CPUID leaf (0x8000001d) by passing in the
cache level in ECX. In prior families, a cache level of 2 was used to
determine this information.

To get the right information, irrespective of Family, iterate over
the cache levels using CPUID 0x8000001d. The last level cache is the
last value to return a non-zero value in EAX.

Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/5ab569025b39cdfaeca55b571d78c0fc800bdb69.1497452002.git.Janakarajan.Natarajan@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/events/amd/uncore.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 094973313037..10f023799f11 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -378,11 +378,24 @@ static int amd_uncore_cpu_starting(unsigned int cpu)
 
 	if (amd_uncore_llc) {
 		unsigned int apicid = cpu_data(cpu).apicid;
-		unsigned int nshared;
+		unsigned int nshared, subleaf, prev_eax = 0;
 
 		uncore = *per_cpu_ptr(amd_uncore_llc, cpu);
-		cpuid_count(0x8000001d, 2, &eax, &ebx, &ecx, &edx);
-		nshared = ((eax >> 14) & 0xfff) + 1;
+		/*
+		 * Iterate over Cache Topology Definition leaves until no
+		 * more cache descriptions are available.
+		 */
+		for (subleaf = 0; subleaf < 5; subleaf++) {
+			cpuid_count(0x8000001d, subleaf, &eax, &ebx, &ecx, &edx);
+
+			/* EAX[0:4] gives type of cache */
+			if (!(eax & 0x1f))
+				break;
+
+			prev_eax = eax;
+		}
+		nshared = ((prev_eax >> 14) & 0xfff) + 1;
+
 		uncore->id = apicid - (apicid % nshared);
 
 		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_llc);
-- 
2.20.1



