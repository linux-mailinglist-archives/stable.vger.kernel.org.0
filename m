Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC00492487
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 12:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiARLR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 06:17:58 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35030 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239325AbiARLR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 06:17:56 -0500
Date:   Tue, 18 Jan 2022 11:17:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1642504675;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ugOifnkRHKs7csK+YuOLGEMBdLfyeUlU+6wdJZ8CJJc=;
        b=Te7ZWeiTzU9616pkV+aLgKV2CKWNdTpTqTvEJ8XzndQmVL2Y4s8uagqmPUFQJ3IFMXEMXb
        nb6vmAxybLlZaq7+A1MRMUx7xKe8v8RwNd/jEp24bGNqB2EfJkMbUSauAst0h5QaGCMtxd
        0SY9Qs8/ZgTIVADJlvDGxP5tEp3OMnbkBXY+GAzem9dFgN4Qi04zwHEoS3O7F/n7nybjYo
        3HMDHr/d9uqZCBEkmn99QuZ1n+oHH9O7sAQ2tROu2cYfVT4qdMqBiYdcPy8nx/wjumaZIn
        nxI29qQPwK5Hey9MdtenSxqVcm8WDOPbXGwuuADDP+4cETxrJO6CAdjXUkW/LA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1642504675;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ugOifnkRHKs7csK+YuOLGEMBdLfyeUlU+6wdJZ8CJJc=;
        b=QUzw7XxV2rUR2w+Xqq+yyJfECQDg5tGhRPEj8cMIIxs6F8F2hQ7M1si4YI6eT9Xy9dYesI
        Waa7tKdTHY9GNzCg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Add a quirk for the calculation of
 the number of counters on Alder Lake
Cc:     "Damjan Marion (damarion)" <damarion@cisco.com>,
        Chan Edison <edison_chan_gz@hotmail.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1641925238-149288-1-git-send-email-kan.liang@linux.intel.com>
References: <1641925238-149288-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <164250467421.16921.17147767149511874705.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     7fa981cad216e9f64f49e22112f610c0bfed91bc
Gitweb:        https://git.kernel.org/tip/7fa981cad216e9f64f49e22112f610c0bfed91bc
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Tue, 11 Jan 2022 10:20:38 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 18 Jan 2022 12:09:47 +01:00

perf/x86/intel: Add a quirk for the calculation of the number of counters on Alder Lake

For some Alder Lake machine with all E-cores disabled in a BIOS, the
below warning may be triggered.

[ 2.010766] hw perf events fixed 5 > max(4), clipping!

Current perf code relies on the CPUID leaf 0xA and leaf 7.EDX[15] to
calculate the number of the counters and follow the below assumption.

For a hybrid configuration, the leaf 7.EDX[15] (X86_FEATURE_HYBRID_CPU)
is set. The leaf 0xA only enumerate the common counters. Linux perf has
to manually add the extra GP counters and fixed counters for P-cores.
For a non-hybrid configuration, the X86_FEATURE_HYBRID_CPU should not
be set. The leaf 0xA enumerates all counters.

However, that's not the case when all E-cores are disabled in a BIOS.
Although there are only P-cores in the system, the leaf 7.EDX[15]
(X86_FEATURE_HYBRID_CPU) is still set. But the leaf 0xA is updated
to enumerate all counters of P-cores. The inconsistency triggers the
warning.

Several software ways were considered to handle the inconsistency.
- Drop the leaf 0xA and leaf 7.EDX[15] CPUID enumeration support.
  Hardcode the number of counters. This solution may be a problem for
  virtualization. A hypervisor cannot control the number of counters
  in a Linux guest via changing the guest CPUID enumeration anymore.
- Find another CPUID bit that is also updated with E-cores disabled.
  There may be a problem in the virtualization environment too. Because
  a hypervisor may disable the feature/CPUID bit.
- The P-cores have a maximum of 8 GP counters and 4 fixed counters on
  ADL. The maximum number can be used to detect the case.
  This solution is implemented in this patch.

Fixes: ee72a94ea4a6 ("perf/x86/intel: Fix fixed counter check warning for some Alder Lake")
Reported-by: Damjan Marion (damarion) <damarion@cisco.com>
Reported-by: Chan Edison <edison_chan_gz@hotmail.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Damjan Marion (damarion) <damarion@cisco.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1641925238-149288-1-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index fd9f908..d5f940c 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6236,6 +6236,19 @@ __init int intel_pmu_init(void)
 			pmu->num_counters = x86_pmu.num_counters;
 			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
 		}
+
+		/*
+		 * Quirk: For some Alder Lake machine, when all E-cores are disabled in
+		 * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
+		 * the X86_FEATURE_HYBRID_CPU is still set. The above codes will
+		 * mistakenly add extra counters for P-cores. Correct the number of
+		 * counters here.
+		 */
+		if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
+			pmu->num_counters = x86_pmu.num_counters;
+			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
+		}
+
 		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
 		pmu->unconstrained = (struct event_constraint)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
