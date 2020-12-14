Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0BB2D9F4B
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440340AbgLNS33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502297AbgLNRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 075/105] intel_idle: Build fix
Date:   Mon, 14 Dec 2020 18:28:49 +0100
Message-Id: <20201214172558.877489118@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4d916140bf28ff027997144ea1bb4299e1536f87 ]

Because CONFIG_ soup.

Fixes: 6e1d2bc675bd ("intel_idle: Fix intel_idle() vs tracing")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201130115402.GO3040@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index cc6d1b12388e1..3a1617a3e5bf7 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1136,6 +1136,20 @@ static bool __init intel_idle_max_cstate_reached(int cstate)
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
 #ifdef CONFIG_ACPI_PROCESSOR_CSTATE
 #include <acpi/processor.h>
 
@@ -1206,20 +1220,6 @@ static bool __init intel_idle_acpi_cst_extract(void)
 	return false;
 }
 
-static bool __init intel_idle_state_needs_timer_stop(struct cpuidle_state *state)
-{
-	unsigned long eax = flg2MWAIT(state->flags);
-
-	if (boot_cpu_has(X86_FEATURE_ARAT))
-		return false;
-
-	/*
-	 * Switch over to one-shot tick broadcast if the target C-state
-	 * is deeper than C1.
-	 */
-	return !!((eax >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK);
-}
-
 static void __init intel_idle_init_cstates_acpi(struct cpuidle_driver *drv)
 {
 	int cstate, limit = min_t(int, CPUIDLE_STATE_MAX, acpi_state_table.count);
-- 
2.27.0



