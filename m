Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4A439F5C6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 13:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhFHL5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 07:57:15 -0400
Received: from foss.arm.com ([217.140.110.172]:56880 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhFHL5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 07:57:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3172D6E;
        Tue,  8 Jun 2021 04:55:22 -0700 (PDT)
Received: from 010265703453.arm.com (unknown [10.57.6.115])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F29A93F73D;
        Tue,  8 Jun 2021 04:55:21 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     will@kernel.org, mark.rutland@arm.com
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH] perf/smmuv3: Don't trample existing events with global filter
Date:   Tue,  8 Jun 2021 12:55:12 +0100
Message-Id: <32c80c0e46237f49ad8da0c9f8864e13c4a803aa.1623153312.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With global filtering, we only allow an event to be scheduled if its
filter settings exactly match those of any existing events, therefore
it is pointless to reapply the filter in that case. Much worse, though,
is that in doing that we trample the event type of counter 0 if it's
already active, and never touch the appropriate PMEVTYPERn so the new
event is likely not counting the right thing either. Don't do that.

CC: stable@vger.kernel.org
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 drivers/perf/arm_smmuv3_pmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index ff6fab4bae30..863d9f702aa1 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -277,7 +277,7 @@ static int smmu_pmu_apply_event_filter(struct smmu_pmu *smmu_pmu,
 				       struct perf_event *event, int idx)
 {
 	u32 span, sid;
-	unsigned int num_ctrs = smmu_pmu->num_counters;
+	unsigned int cur_idx, num_ctrs = smmu_pmu->num_counters;
 	bool filter_en = !!get_filter_enable(event);
 
 	span = filter_en ? get_filter_span(event) :
@@ -285,17 +285,19 @@ static int smmu_pmu_apply_event_filter(struct smmu_pmu *smmu_pmu,
 	sid = filter_en ? get_filter_stream_id(event) :
 			   SMMU_PMCG_DEFAULT_FILTER_SID;
 
-	/* Support individual filter settings */
-	if (!smmu_pmu->global_filter) {
+	cur_idx = find_first_bit(smmu_pmu->used_counters, num_ctrs);
+	/*
+	 * Per-counter filtering, or scheduling the first globally-filtered
+	 * event into an empty PMU so idx == 0 and it works out equivalent.
+	 */
+	if (!smmu_pmu->global_filter || cur_idx == num_ctrs) {
 		smmu_pmu_set_event_filter(event, idx, span, sid);
 		return 0;
 	}
 
-	/* Requested settings same as current global settings*/
-	idx = find_first_bit(smmu_pmu->used_counters, num_ctrs);
-	if (idx == num_ctrs ||
-	    smmu_pmu_check_global_filter(smmu_pmu->events[idx], event)) {
-		smmu_pmu_set_event_filter(event, 0, span, sid);
+	/* Otherwise, must match whatever's currently scheduled */
+	if (smmu_pmu_check_global_filter(smmu_pmu->events[cur_idx], event)) {
+		smmu_pmu_set_evtyper(smmu_pmu, idx, get_event(event));
 		return 0;
 	}
 
-- 
2.25.1

