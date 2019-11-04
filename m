Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF539EEC45
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbfKDVzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388143AbfKDVz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:55:29 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80CE52053B;
        Mon,  4 Nov 2019 21:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904528;
        bh=hPBs8wEL15WhpBtdpduXLOmv9HsrP8W5sGpi4Xp2Jtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcwJaLAHWut4GLt02KwYVF4tyz9B8XovRgOcMOxngibP4m2S1Cq5YeOst09EgbLDl
         EsOd7ZxRcmjnawf01TqmsKynh49yRjenGGeeQ4Y75U2NOEBzObLdEc4qz1B8lYfSqC
         Cwlq6JtK4PGgjXM6sx3Tz5h8BvXJRKGjYsJDs4/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Jerry Hoemann <jerry.hoemann@hpe.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 50/95] perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp
Date:   Mon,  4 Nov 2019 22:44:48 +0100
Message-Id: <20191104212104.021638843@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit df4d29732fdad43a51284f826bec3e6ded177540 ]

It turns out that the NMI latency workaround from commit:

  6d3edaae16c6 ("x86/perf/amd: Resolve NMI latency issues for active PMCs")

ends up being too conservative and results in the perf NMI handler claiming
NMIs too easily on AMD hardware when the NMI watchdog is active.

This has an impact, for example, on the hpwdt (HPE watchdog timer) module.
This module can produce an NMI that is used to reset the system. It
registers an NMI handler for the NMI_UNKNOWN type and relies on the fact
that nothing has claimed an NMI so that its handler will be invoked when
the watchdog device produces an NMI. After the referenced commit, the
hpwdt module is unable to process its generated NMI if the NMI watchdog is
active, because the current NMI latency mitigation results in the NMI
being claimed by the perf NMI handler.

Update the AMD perf NMI latency mitigation workaround to, instead, use a
window of time. Whenever a PMC is handled in the perf NMI handler, set a
timestamp which will act as a perf NMI window. Any NMIs arriving within
that window will be claimed by perf. Anything outside that window will
not be claimed by perf. The value for the NMI window is set to 100 msecs.
This is a conservative value that easily covers any NMI latency in the
hardware. While this still results in a window in which the hpwdt module
will not receive its NMI, the window is now much, much smaller.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 6d3edaae16c6 ("x86/perf/amd: Resolve NMI latency issues for active PMCs")
Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 27ade3cb6482c..defb536aebce2 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -4,12 +4,14 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <asm/apicdef.h>
 #include <asm/nmi.h>
 
 #include "../perf_event.h"
 
-static DEFINE_PER_CPU(unsigned int, perf_nmi_counter);
+static DEFINE_PER_CPU(unsigned long, perf_nmi_tstamp);
+static unsigned long perf_nmi_window;
 
 static __initconst const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -640,11 +642,12 @@ static void amd_pmu_disable_event(struct perf_event *event)
  * handler when multiple PMCs are active or PMC overflow while handling some
  * other source of an NMI.
  *
- * Attempt to mitigate this by using the number of active PMCs to determine
- * whether to return NMI_HANDLED if the perf NMI handler did not handle/reset
- * any PMCs. The per-CPU perf_nmi_counter variable is set to a minimum of the
- * number of active PMCs or 2. The value of 2 is used in case an NMI does not
- * arrive at the LAPIC in time to be collapsed into an already pending NMI.
+ * Attempt to mitigate this by creating an NMI window in which un-handled NMIs
+ * received during this window will be claimed. This prevents extending the
+ * window past when it is possible that latent NMIs should be received. The
+ * per-CPU perf_nmi_tstamp will be set to the window end time whenever perf has
+ * handled a counter. When an un-handled NMI is received, it will be claimed
+ * only if arriving within that window.
  */
 static int amd_pmu_handle_irq(struct pt_regs *regs)
 {
@@ -662,21 +665,19 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	handled = x86_pmu_handle_irq(regs);
 
 	/*
-	 * If a counter was handled, record the number of possible remaining
-	 * NMIs that can occur.
+	 * If a counter was handled, record a timestamp such that un-handled
+	 * NMIs will be claimed if arriving within that window.
 	 */
 	if (handled) {
-		this_cpu_write(perf_nmi_counter,
-			       min_t(unsigned int, 2, active));
+		this_cpu_write(perf_nmi_tstamp,
+			       jiffies + perf_nmi_window);
 
 		return handled;
 	}
 
-	if (!this_cpu_read(perf_nmi_counter))
+	if (time_after(jiffies, this_cpu_read(perf_nmi_tstamp)))
 		return NMI_DONE;
 
-	this_cpu_dec(perf_nmi_counter);
-
 	return NMI_HANDLED;
 }
 
@@ -908,6 +909,9 @@ static int __init amd_core_pmu_init(void)
 	if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
 		return 0;
 
+	/* Avoid calulating the value each time in the NMI handler */
+	perf_nmi_window = msecs_to_jiffies(100);
+
 	switch (boot_cpu_data.x86) {
 	case 0x15:
 		pr_cont("Fam15h ");
-- 
2.20.1



