Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D3A2CD807
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbgLCNhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436561AbgLCNaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:23 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 28/39] intel_idle: Fix intel_idle() vs tracing
Date:   Thu,  3 Dec 2020 08:28:22 -0500
Message-Id: <20201203132834.930999-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 6e1d2bc675bd57640f5658a4a657ae488db4c204 ]

cpuidle->enter() callbacks should not call into tracing because RCU
has already been disabled. Instead of doing the broadcast thing
itself, simply advertise to the cpuidle core that those states stop
the timer.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lkml.kernel.org/r/20201123143510.GR3021@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index d09b807e1c3a1..cc6d1b12388e1 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -122,26 +122,9 @@ static __cpuidle int intel_idle(struct cpuidle_device *dev,
 	struct cpuidle_state *state = &drv->states[index];
 	unsigned long eax = flg2MWAIT(state->flags);
 	unsigned long ecx = 1; /* break on interrupt flag */
-	bool tick;
-
-	if (!static_cpu_has(X86_FEATURE_ARAT)) {
-		/*
-		 * Switch over to one-shot tick broadcast if the target C-state
-		 * is deeper than C1.
-		 */
-		if ((eax >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) {
-			tick = true;
-			tick_broadcast_enter();
-		} else {
-			tick = false;
-		}
-	}
 
 	mwait_idle_with_hints(eax, ecx);
 
-	if (!static_cpu_has(X86_FEATURE_ARAT) && tick)
-		tick_broadcast_exit();
-
 	return index;
 }
 
@@ -1223,6 +1206,20 @@ static bool __init intel_idle_acpi_cst_extract(void)
 	return false;
 }
 
+static bool __init intel_idle_state_needs_timer_stop(struct cpuidle_state *state)
+{
+	unsigned long eax = flg2MWAIT(state->flags);
+
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return false;
+
+	/*
+	 * Switch over to one-shot tick broadcast if the target C-state
+	 * is deeper than C1.
+	 */
+	return !!((eax >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK);
+}
+
 static void __init intel_idle_init_cstates_acpi(struct cpuidle_driver *drv)
 {
 	int cstate, limit = min_t(int, CPUIDLE_STATE_MAX, acpi_state_table.count);
@@ -1265,6 +1262,9 @@ static void __init intel_idle_init_cstates_acpi(struct cpuidle_driver *drv)
 		if (disabled_states_mask & BIT(cstate))
 			state->flags |= CPUIDLE_FLAG_OFF;
 
+		if (intel_idle_state_needs_timer_stop(state))
+			state->flags |= CPUIDLE_FLAG_TIMER_STOP;
+
 		state->enter = intel_idle;
 		state->enter_s2idle = intel_idle_s2idle;
 	}
@@ -1503,6 +1503,9 @@ static void __init intel_idle_init_cstates_icpu(struct cpuidle_driver *drv)
 		     !(cpuidle_state_table[cstate].flags & CPUIDLE_FLAG_ALWAYS_ENABLE)))
 			drv->states[drv->state_count].flags |= CPUIDLE_FLAG_OFF;
 
+		if (intel_idle_state_needs_timer_stop(&drv->states[drv->state_count]))
+			drv->states[drv->state_count].flags |= CPUIDLE_FLAG_TIMER_STOP;
+
 		drv->state_count++;
 	}
 
-- 
2.27.0

