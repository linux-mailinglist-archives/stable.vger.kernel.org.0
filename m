Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7560E406C52
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhIJMi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234386AbhIJMhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 374B161206;
        Fri, 10 Sep 2021 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277349;
        bh=LRlzWnO+lbSox1yLVo8gzaZucTtgcS1uo23GKB3qyJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUcbi8ZVs111PV1pT8kv56IIpQxxhwuYZhhybfBJXVsWiZfVJW8It1IooADLpA5f6
         6+HnmDjrXY9Vo+WNJnSHFNnQAmlYfDZiO5f9q9/bxznK4prJhfGLCi9kA7RlhdUMPF
         p4ZrMl3d1Nlv+NvQYusagY5xc4zktGByy1zaFAvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Monakov <amonakov@ispras.ru>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 29/37] x86/events/amd/iommu: Fix invalid Perf result due to IOMMU PMC power-gating
Date:   Fri, 10 Sep 2021 14:30:32 +0200
Message-Id: <20210910122918.126528184@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit e10de314287c2c14b0e6f0e3e961975ce2f4a83d upstream.

On certain AMD platforms, when the IOMMU performance counter source
(csource) field is zero, power-gating for the counter is enabled, which
prevents write access and returns zero for read access.

This can cause invalid perf result especially when event multiplexing
is needed (i.e. more number of events than available counters) since
the current logic keeps track of the previously read counter value,
and subsequently re-program the counter to continue counting the event.
With power-gating enabled, we cannot gurantee successful re-programming
of the counter.

Workaround this issue by :

1. Modifying the ordering of setting/reading counters and enabing/
   disabling csources to only access the counter when the csource
   is set to non-zero.

2. Since AMD IOMMU PMU does not support interrupt mode, the logic
   can be simplified to always start counting with value zero,
   and accumulate the counter value when stopping without the need
   to keep track and reprogram the counter with the previously read
   counter value.

This has been tested on systems with and without power-gating.

Fixes: 994d6608efe4 ("iommu/amd: Remove performance counter pre-initialization test")
Suggested-by: Alexander Monakov <amonakov@ispras.ru>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210504065236.4415-1-suravee.suthikulpanit@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/iommu.c |   47 ++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

--- a/arch/x86/events/amd/iommu.c
+++ b/arch/x86/events/amd/iommu.c
@@ -18,8 +18,6 @@
 #include "../perf_event.h"
 #include "iommu.h"
 
-#define COUNTER_SHIFT		16
-
 /* iommu pmu conf masks */
 #define GET_CSOURCE(x)     ((x)->conf & 0xFFULL)
 #define GET_DEVID(x)       (((x)->conf >> 8)  & 0xFFFFULL)
@@ -285,22 +283,31 @@ static void perf_iommu_start(struct perf
 	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
 	hwc->state = 0;
 
+	/*
+	 * To account for power-gating, which prevents write to
+	 * the counter, we need to enable the counter
+	 * before setting up counter register.
+	 */
+	perf_iommu_enable_event(event);
+
 	if (flags & PERF_EF_RELOAD) {
-		u64 prev_raw_count = local64_read(&hwc->prev_count);
+		u64 count = 0;
 		struct amd_iommu *iommu = perf_event_2_iommu(event);
 
+		/*
+		 * Since the IOMMU PMU only support counting mode,
+		 * the counter always start with value zero.
+		 */
 		amd_iommu_pc_set_reg(iommu, hwc->iommu_bank, hwc->iommu_cntr,
-				     IOMMU_PC_COUNTER_REG, &prev_raw_count);
+				     IOMMU_PC_COUNTER_REG, &count);
 	}
 
-	perf_iommu_enable_event(event);
 	perf_event_update_userpage(event);
-
 }
 
 static void perf_iommu_read(struct perf_event *event)
 {
-	u64 count, prev, delta;
+	u64 count;
 	struct hw_perf_event *hwc = &event->hw;
 	struct amd_iommu *iommu = perf_event_2_iommu(event);
 
@@ -311,14 +318,11 @@ static void perf_iommu_read(struct perf_
 	/* IOMMU pc counter register is only 48 bits */
 	count &= GENMASK_ULL(47, 0);
 
-	prev = local64_read(&hwc->prev_count);
-	if (local64_cmpxchg(&hwc->prev_count, prev, count) != prev)
-		return;
-
-	/* Handle 48-bit counter overflow */
-	delta = (count << COUNTER_SHIFT) - (prev << COUNTER_SHIFT);
-	delta >>= COUNTER_SHIFT;
-	local64_add(delta, &event->count);
+	/*
+	 * Since the counter always start with value zero,
+	 * simply just accumulate the count for the event.
+	 */
+	local64_add(count, &event->count);
 }
 
 static void perf_iommu_stop(struct perf_event *event, int flags)
@@ -328,15 +332,16 @@ static void perf_iommu_stop(struct perf_
 	if (hwc->state & PERF_HES_UPTODATE)
 		return;
 
+	/*
+	 * To account for power-gating, in which reading the counter would
+	 * return zero, we need to read the register before disabling.
+	 */
+	perf_iommu_read(event);
+	hwc->state |= PERF_HES_UPTODATE;
+
 	perf_iommu_disable_event(event);
 	WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
 	hwc->state |= PERF_HES_STOPPED;
-
-	if (hwc->state & PERF_HES_UPTODATE)
-		return;
-
-	perf_iommu_read(event);
-	hwc->state |= PERF_HES_UPTODATE;
 }
 
 static int perf_iommu_add(struct perf_event *event, int flags)


