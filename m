Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDCDBA4A3
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404447AbfIVSum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404011AbfIVSuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2AEC21D71;
        Sun, 22 Sep 2019 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178237;
        bh=jUA7/qGpkPZLB6Bq0rXE8/podl03XvX8nzplVpOsin4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiTsPvOuQCiht6KKoMfyuPNauP4+UINzYaMVyUOPDT8R1EuQzGqaE0Dv1jFmvIiQB
         bidoWL1Og4a0nEbSyIiAyVinXcqQ6lef1CkqXEbFoRgQiyy1GgguVN+EEPc2nEjDl8
         fq+dTEJzhk/IZJak/8CpOYZCO2D5UNGlCzhJ1/lw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 033/185] cpuidle: teo: Allow tick to be stopped if PM QoS is used
Date:   Sun, 22 Sep 2019 14:46:51 -0400
Message-Id: <20190922184924.32534-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit cab09f3d2d2a0a6cb3dfb678660d67a2c3764f50 ]

The TEO goveror prevents the scheduler tick from being stopped (unless
stopped already) if there is a PM QoS latency constraint for the given
CPU and the target residency of the deepest idle state matching that
constraint is below the tick boundary.

However, that is problematic if CPUs with PM QoS latency constraints
are idle for long times, because it effectively causes the tick to
run on them all the time which is wasteful.  [It is also confusing
and questionable if they are full dynticks CPUs.]

To address that issue, modify the TEO governor to carry out the
entire search for the most suitable idle state (from the target
residency perspective) even if a latency constraint is present,
to allow it to determine the expected idle duration in all cases.

Also, when using the last several measured idle duration values
to refine the idle state selection, make it compare those values
with the current expected idle duration value (instead of
comparing them with the target residency of the idle state
selected so far) which should prevent the tick from being
retained when it makes sense to stop it sometimes (especially
in the presence of PM QoS latency constraints).

Fixes: b26bf6ab716f ("cpuidle: New timer events oriented governor for tickless systems")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/teo.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/cpuidle/governors/teo.c b/drivers/cpuidle/governors/teo.c
index 7d05efdbd3c66..12d9e6cecf1de 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -242,7 +242,7 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	struct teo_cpu *cpu_data = per_cpu_ptr(&teo_cpus, dev->cpu);
 	int latency_req = cpuidle_governor_latency_req(dev->cpu);
 	unsigned int duration_us, count;
-	int max_early_idx, idx, i;
+	int max_early_idx, constraint_idx, idx, i;
 	ktime_t delta_tick;
 
 	if (cpu_data->last_state >= 0) {
@@ -257,6 +257,7 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 
 	count = 0;
 	max_early_idx = -1;
+	constraint_idx = drv->state_count;
 	idx = -1;
 
 	for (i = 0; i < drv->state_count; i++) {
@@ -286,16 +287,8 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		if (s->target_residency > duration_us)
 			break;
 
-		if (s->exit_latency > latency_req) {
-			/*
-			 * If we break out of the loop for latency reasons, use
-			 * the target residency of the selected state as the
-			 * expected idle duration to avoid stopping the tick
-			 * as long as that target residency is low enough.
-			 */
-			duration_us = drv->states[idx].target_residency;
-			goto refine;
-		}
+		if (s->exit_latency > latency_req && constraint_idx > i)
+			constraint_idx = i;
 
 		idx = i;
 
@@ -321,7 +314,13 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		duration_us = drv->states[idx].target_residency;
 	}
 
-refine:
+	/*
+	 * If there is a latency constraint, it may be necessary to use a
+	 * shallower idle state than the one selected so far.
+	 */
+	if (constraint_idx < idx)
+		idx = constraint_idx;
+
 	if (idx < 0) {
 		idx = 0; /* No states enabled. Must use 0. */
 	} else if (idx > 0) {
@@ -331,13 +330,12 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 
 		/*
 		 * Count and sum the most recent idle duration values less than
-		 * the target residency of the state selected so far, find the
-		 * max.
+		 * the current expected idle duration value.
 		 */
 		for (i = 0; i < INTERVALS; i++) {
 			unsigned int val = cpu_data->intervals[i];
 
-			if (val >= drv->states[idx].target_residency)
+			if (val >= duration_us)
 				continue;
 
 			count++;
@@ -356,8 +354,10 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 			 * would be too shallow.
 			 */
 			if (!(tick_nohz_tick_stopped() && avg_us < TICK_USEC)) {
-				idx = teo_find_shallower_state(drv, dev, idx, avg_us);
 				duration_us = avg_us;
+				if (drv->states[idx].target_residency > avg_us)
+					idx = teo_find_shallower_state(drv, dev,
+								       idx, avg_us);
 			}
 		}
 	}
-- 
2.20.1

