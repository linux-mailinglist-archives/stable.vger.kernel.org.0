Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9796B3C4BD9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhGLHAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239452AbhGLG6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 803FD610CA;
        Mon, 12 Jul 2021 06:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072936;
        bh=7mIAPfZFWlrtSMP2nEPWi0DYh6syXH1MzLV13mn0kAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaQrTqaTvsoWbjB1GpoJKgaYwZnlUhS1uMu+BWXaNw0xcuTR6dYs9rcv019+OHTAT
         VlW7bjHFRVJxyrL8Fzq1eiwBhnaPaemQovkar2CiQ9GHUJwd0NTkHD19qv5KGgPWHT
         UGqSk/FD2gwUZfW2FNmGswxOHheek/UFeC8SfnLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.12 069/700] perf/smmuv3: Dont trample existing events with global filter
Date:   Mon, 12 Jul 2021 08:02:32 +0200
Message-Id: <20210712060934.463166294@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 4c1daba15c209b99d192f147fea3dade30f72ed2 upstream.

With global filtering, we only allow an event to be scheduled if its
filter settings exactly match those of any existing events, therefore
it is pointless to reapply the filter in that case. Much worse, though,
is that in doing that we trample the event type of counter 0 if it's
already active, and never touch the appropriate PMEVTYPERn so the new
event is likely not counting the right thing either. Don't do that.

CC: stable@vger.kernel.org
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/32c80c0e46237f49ad8da0c9f8864e13c4a803aa.1623153312.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/perf/arm_smmuv3_pmu.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -277,7 +277,7 @@ static int smmu_pmu_apply_event_filter(s
 				       struct perf_event *event, int idx)
 {
 	u32 span, sid;
-	unsigned int num_ctrs = smmu_pmu->num_counters;
+	unsigned int cur_idx, num_ctrs = smmu_pmu->num_counters;
 	bool filter_en = !!get_filter_enable(event);
 
 	span = filter_en ? get_filter_span(event) :
@@ -285,17 +285,19 @@ static int smmu_pmu_apply_event_filter(s
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
 


