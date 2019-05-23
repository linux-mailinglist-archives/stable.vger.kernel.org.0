Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C9A287C2
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390583AbfEWTWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:32952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390578AbfEWTWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59AC3206BA;
        Thu, 23 May 2019 19:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639373;
        bh=PBtTUBAOYf3seKE7fedPr1UQ96MftwcjzEdHhxafmvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad7z8kjl89sYSD86X8f1Gk6siyWOaGttZb2SvMjM5hZ2S4sh7Fq3xkgl/KIPRQTRV
         Gjbie5lqddRVWhMenb0Vy3/Tcm3O4fC0ZgiC2t6KAeB2rz52urKnEMuvdCMVAXXywG
         I+ZlA00XchyPkYye4e5qiJdbYJZEH4uyH7Yul+pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@linux-mips.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.0 073/139] MIPS: perf: Fix build with CONFIG_CPU_BMIPS5000 enabled
Date:   Thu, 23 May 2019 21:06:01 +0200
Message-Id: <20190523181730.299366832@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 1b1f01b653b408ebe58fec78c566d1075d285c64 upstream.

arch/mips/kernel/perf_event_mipsxx.c: In function 'mipsxx_pmu_enable_event':
arch/mips/kernel/perf_event_mipsxx.c:326:21: error: unused variable 'event' [-Werror=unused-variable]
  struct perf_event *event = container_of(evt, struct perf_event, hw);
                     ^~~~~

Fix this by making use of IS_ENABLED() to simplify the code and avoid
unnecessary ifdefery.

Fixes: 84002c88599d ("MIPS: perf: Fix perf with MT counting other threads")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@linux-mips.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/perf_event_mipsxx.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -64,17 +64,11 @@ struct mips_perf_event {
 	#define CNTR_EVEN	0x55555555
 	#define CNTR_ODD	0xaaaaaaaa
 	#define CNTR_ALL	0xffffffff
-#ifdef CONFIG_MIPS_MT_SMP
 	enum {
 		T  = 0,
 		V  = 1,
 		P  = 2,
 	} range;
-#else
-	#define T
-	#define V
-	#define P
-#endif
 };
 
 static struct mips_perf_event raw_event;
@@ -325,9 +319,7 @@ static void mipsxx_pmu_enable_event(stru
 {
 	struct perf_event *event = container_of(evt, struct perf_event, hw);
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-#ifdef CONFIG_MIPS_MT_SMP
 	unsigned int range = evt->event_base >> 24;
-#endif /* CONFIG_MIPS_MT_SMP */
 
 	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
 
@@ -336,21 +328,15 @@ static void mipsxx_pmu_enable_event(stru
 		/* Make sure interrupt enabled. */
 		MIPS_PERFCTRL_IE;
 
-#ifdef CONFIG_CPU_BMIPS5000
-	{
+	if (IS_ENABLED(CONFIG_CPU_BMIPS5000)) {
 		/* enable the counter for the calling thread */
 		cpuc->saved_ctrl[idx] |=
 			(1 << (12 + vpe_id())) | BRCM_PERFCTRL_TC;
-	}
-#else
-#ifdef CONFIG_MIPS_MT_SMP
-	if (range > V) {
+	} else if (IS_ENABLED(CONFIG_MIPS_MT_SMP) && range > V) {
 		/* The counter is processor wide. Set it up to count all TCs. */
 		pr_debug("Enabling perf counter for all TCs\n");
 		cpuc->saved_ctrl[idx] |= M_TC_EN_ALL;
-	} else
-#endif /* CONFIG_MIPS_MT_SMP */
-	{
+	} else {
 		unsigned int cpu, ctrl;
 
 		/*
@@ -365,7 +351,6 @@ static void mipsxx_pmu_enable_event(stru
 		cpuc->saved_ctrl[idx] |= ctrl;
 		pr_debug("Enabling perf counter for CPU%d\n", cpu);
 	}
-#endif /* CONFIG_CPU_BMIPS5000 */
 	/*
 	 * We do not actually let the counter run. Leave it until start().
 	 */


