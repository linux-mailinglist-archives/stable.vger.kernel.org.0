Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483576AE8AB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjCGRS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCGRSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:18:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2CE9385C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD30B819A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934C4C433D2;
        Tue,  7 Mar 2023 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209223;
        bh=S2Ja300QGTOErBuiTNojxjZrLn3DgQEMRUIelYKT3VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYKqsJJZeXuwCO8rZstwcQoSDke2+bg97P6xp8h4SDiu3SufX0OO3i6wWoxMehHGT
         AEmsZ+90Gur0TYC2AByotPkv+BOhXIU/6bs0XNfnKSw6n70+gamQLI2Squa3Y3pfZe
         MKUBqJ0+ajBmfeaocYsO9+sMfBoRZf1GFJWGZ7TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0122/1001] perf/x86/intel/ds: Fix the conversion from TSC to perf time
Date:   Tue,  7 Mar 2023 17:48:14 +0100
Message-Id: <20230307170027.375506152@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 89e97eb8cec0f1af5ebf2380308913256ca7915a ]

The time order is incorrect when the TSC in a PEBS record is used.

 $perf record -e cycles:upp dd if=/dev/zero of=/dev/null
  count=10000
 $ perf script --show-task-events
       perf-exec     0     0.000000: PERF_RECORD_COMM: perf-exec:915/915
              dd   915   106.479872: PERF_RECORD_COMM exec: dd:915/915
              dd   915   106.483270: PERF_RECORD_EXIT(915:915):(914:914)
              dd   915   106.512429:          1 cycles:upp:
 ffffffff96c011b7 [unknown] ([unknown])
 ... ...

The perf time is from sched_clock_cpu(). The current PEBS code
unconditionally convert the TSC to native_sched_clock(). There is a
shift between the two clocks. If the TSC is stable, the shift is
consistent, __sched_clock_offset. If the TSC is unstable, the shift has
to be calculated at runtime.

This patch doesn't support the conversion when the TSC is unstable. The
TSC unstable case is a corner case and very unlikely to happen. If it
happens, the TSC in a PEBS record will be dropped and fall back to
perf_event_clock().

Fixes: 47a3aeb39e8d ("perf/x86/intel/pebs: Fix PEBS timestamps overwritten")
Reported-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/CAM9d7cgWDVAq8-11RbJ2uGfwkKD6fA-OMwOKDrNUrU_=8MgEjg@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 88e58b6ee73c0..91b214231e03c 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2,12 +2,14 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/sched/clock.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/perf_event.h>
 #include <asm/tlbflush.h>
 #include <asm/insn.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "../perf_event.h"
 
@@ -1519,6 +1521,27 @@ static u64 get_data_src(struct perf_event *event, u64 aux)
 	return val;
 }
 
+static void setup_pebs_time(struct perf_event *event,
+			    struct perf_sample_data *data,
+			    u64 tsc)
+{
+	/* Converting to a user-defined clock is not supported yet. */
+	if (event->attr.use_clockid != 0)
+		return;
+
+	/*
+	 * Doesn't support the conversion when the TSC is unstable.
+	 * The TSC unstable case is a corner case and very unlikely to
+	 * happen. If it happens, the TSC in a PEBS record will be
+	 * dropped and fall back to perf_event_clock().
+	 */
+	if (!using_native_sched_clock() || !sched_clock_stable())
+		return;
+
+	data->time = native_sched_clock_from_tsc(tsc) + __sched_clock_offset;
+	data->sample_flags |= PERF_SAMPLE_TIME;
+}
+
 #define PERF_SAMPLE_ADDR_TYPE	(PERF_SAMPLE_ADDR |		\
 				 PERF_SAMPLE_PHYS_ADDR |	\
 				 PERF_SAMPLE_DATA_PAGE_SIZE)
@@ -1668,11 +1691,8 @@ static void setup_pebs_fixed_sample_data(struct perf_event *event,
 	 *
 	 * We can only do this for the default trace clock.
 	 */
-	if (x86_pmu.intel_cap.pebs_format >= 3 &&
-		event->attr.use_clockid == 0) {
-		data->time = native_sched_clock_from_tsc(pebs->tsc);
-		data->sample_flags |= PERF_SAMPLE_TIME;
-	}
+	if (x86_pmu.intel_cap.pebs_format >= 3)
+		setup_pebs_time(event, data, pebs->tsc);
 
 	if (has_branch_stack(event)) {
 		data->br_stack = &cpuc->lbr_stack;
@@ -1735,10 +1755,7 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 	perf_sample_data_init(data, 0, event->hw.last_period);
 	data->period = event->hw.last_period;
 
-	if (event->attr.use_clockid == 0) {
-		data->time = native_sched_clock_from_tsc(basic->tsc);
-		data->sample_flags |= PERF_SAMPLE_TIME;
-	}
+	setup_pebs_time(event, data, basic->tsc);
 
 	/*
 	 * We must however always use iregs for the unwinder to stay sane; the
-- 
2.39.2



