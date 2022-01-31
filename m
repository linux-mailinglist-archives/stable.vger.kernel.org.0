Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FA34A4353
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359182AbiAaLU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37112 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376399AbiAaLRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:17:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B94E8B82A4C;
        Mon, 31 Jan 2022 11:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62B7C340E8;
        Mon, 31 Jan 2022 11:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627839;
        bh=+wr5H8fwHIn1wDZLmYPIqd6zjvcF/dsGTEGAYDT40hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQCXBjLFOotJ/yZ5S/BUiO+xc97HPAg4MxWx+COM7eEcpM+dnuK/KgY0nQlI7KOQE
         WNIVZXsx9CbdoYkOQ8/KfBkJuEaGGB0pfZrLA/QG2ncQKB1wgMQs+S6I/yCJHbn5s5
         SwwbpaD9cbR2nITdso8toS07witAAsXo/po51B0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Damjan Marion (damarion)" <damarion@cisco.com>,
        Chan Edison <edison_chan_gz@hotmail.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.16 041/200] perf/x86/intel: Add a quirk for the calculation of the number of counters on Alder Lake
Date:   Mon, 31 Jan 2022 11:55:04 +0100
Message-Id: <20220131105234.941863329@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 7fa981cad216e9f64f49e22112f610c0bfed91bc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6242,6 +6242,19 @@ __init int intel_pmu_init(void)
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


