Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7181C3B285F
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 09:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhFXHMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 03:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhFXHMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 03:12:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268A7C061574;
        Thu, 24 Jun 2021 00:09:49 -0700 (PDT)
Date:   Thu, 24 Jun 2021 07:09:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624518587;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xq66hQ/hq3dEQLN/tgxY4N+ZT3Tr+nmJ2/ZlvBWRrQI=;
        b=XE0i1CdNhIJz0/AXrTo4Ta2x3njcsT46rLKh76peYCMd9aMhfb4SHBFk1lNbHlM38gkcFL
        G7YnBOKESlwT9jZMAFqhSQSM19rpK2y9YRHqyLWcnZEmahLj6c46ySKcKhKAlLufwXEp07
        2pdwDnYCwBWNw9sV4YKuyL+CveJaDVtOlBPemfgO2+CGzbAmPlYrLwaPTQ0qtCFbJs+tPz
        v695DS0+3Fly6qoHuvqFhHFrb+AAMDm3ZJMPDTF60alm+TztS+7TbQSeN+VLzVzpNUwG/g
        jK7U+8vDLv2SWlQlad2ex9F1dNp+m/OCMP+laQ1iMAW7flioBSuxDBzgVccvaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624518587;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xq66hQ/hq3dEQLN/tgxY4N+ZT3Tr+nmJ2/ZlvBWRrQI=;
        b=7vtpHEK17AaC9HA0K/CjqYQUz0ljaZn6Yb8bEAKcDrYfoJG38qJMfrKqgKqdifRFr4b/7Y
        2NbpnHMAb8LgiLAw==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel: Fix fixed counter check warning for
 some Alder Lake
Cc:     Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1624029174-122219-2-git-send-email-kan.liang@linux.intel.com>
References: <1624029174-122219-2-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <162451858710.395.18369691558342592680.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     ee72a94ea4a6d8fa304a506859cd07ecdc0cf5c4
Gitweb:        https://git.kernel.org/tip/ee72a94ea4a6d8fa304a506859cd07ecdc0cf5c4
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Fri, 18 Jun 2021 08:12:52 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 23 Jun 2021 18:30:53 +02:00

perf/x86/intel: Fix fixed counter check warning for some Alder Lake

For some Alder Lake machine, the below fixed counter check warning may be
triggered.

[    2.010766] hw perf events fixed 5 > max(4), clipping!

Current perf unconditionally increases the number of the GP counters and
the fixed counters for a big core PMU on an Alder Lake system, because
the number enumerated in the CPUID only reflects the common counters.
The big core may has more counters. However, Alder Lake may have an
alternative configuration. With that configuration,
the X86_FEATURE_HYBRID_CPU is not set. The number of the GP counters and
fixed counters enumerated in the CPUID is accurate. Perf mistakenly
increases the number of counters. The warning is triggered.

Directly use the enumerated value on the system with the alternative
configuration.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Reported-by: Jin Yao <yao.jin@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1624029174-122219-2-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c |  9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2521d03..d39991b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6157,8 +6157,13 @@ __init int intel_pmu_init(void)
 		pmu = &x86_pmu.hybrid_pmu[X86_HYBRID_PMU_CORE_IDX];
 		pmu->name = "cpu_core";
 		pmu->cpu_type = hybrid_big;
-		pmu->num_counters = x86_pmu.num_counters + 2;
-		pmu->num_counters_fixed = x86_pmu.num_counters_fixed + 1;
+		if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
+			pmu->num_counters = x86_pmu.num_counters + 2;
+			pmu->num_counters_fixed = x86_pmu.num_counters_fixed + 1;
+		} else {
+			pmu->num_counters = x86_pmu.num_counters;
+			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
+		}
 		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
 		pmu->unconstrained = (struct event_constraint)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
