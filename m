Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5793C51A4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346717AbhGLHmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346139AbhGLHj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 887576140E;
        Mon, 12 Jul 2021 07:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075257;
        bh=97xWCKm1cWOUzHDUb76+8cT61PYGxAthIYwiFHbQK3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnYEOYvdKJ8WNgYqCJD8+49e/dzfVGEFhy1HhTTNuLo6dflHIGeX6k8m9LdTm7Pnv
         PXVCjbOWnwlDanRCfHiiekeW3prTDSlDX5PT9S5/zmoR4L9wIq6NqbXJw/zuM7iuGs
         yGhkJ/ujcxowuzfOLjA+9EyIu2okjun6al/lHCLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.13 114/800] perf/x86/intel: Fix fixed counter check warning for some Alder Lake
Date:   Mon, 12 Jul 2021 08:02:17 +0200
Message-Id: <20210712060929.017274802@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit ee72a94ea4a6d8fa304a506859cd07ecdc0cf5c4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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


