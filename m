Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EAA4F68F7
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbiDFSIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbiDFSHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE5E618CD0C;
        Wed,  6 Apr 2022 09:46:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C501512FC;
        Wed,  6 Apr 2022 09:46:15 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2334C3F73B;
        Wed,  6 Apr 2022 09:46:15 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 15/43] arm64: arch_timer: Add erratum handler for CPU-specific capability
Date:   Wed,  6 Apr 2022 17:45:18 +0100
Message-Id: <20220406164546.1888528-15-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 0064030c6fd4ca6cfab42de037b2a89445beeead upstream.

Should we ever have a workaround for an erratum that is detected using
a capability and affecting a particular CPU, it'd be nice to have
a way to probe them directly.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/arch_timer.h  |  1 +
 drivers/clocksource/arm_arch_timer.c | 28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 5cd964e90d11..1b0d7e994e0c 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -39,6 +39,7 @@ extern struct static_key_false arch_timer_read_ool_enabled;
 
 enum arch_timer_erratum_match_type {
 	ate_match_dt,
+	ate_match_local_cap_id,
 };
 
 struct arch_timer_erratum_workaround {
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 015b28e7f1f2..138dbfdfb413 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -162,6 +162,13 @@ bool arch_timer_check_dt_erratum(const struct arch_timer_erratum_workaround *wa,
 	return of_property_read_bool(np, wa->id);
 }
 
+static
+bool arch_timer_check_local_cap_erratum(const struct arch_timer_erratum_workaround *wa,
+					const void *arg)
+{
+	return this_cpu_has_cap((uintptr_t)wa->id);
+}
+
 static const struct arch_timer_erratum_workaround *
 arch_timer_iterate_errata(enum arch_timer_erratum_match_type type,
 			  ate_match_fn_t match_fn,
@@ -192,14 +199,16 @@ static void arch_timer_check_ool_workaround(enum arch_timer_erratum_match_type t
 {
 	const struct arch_timer_erratum_workaround *wa;
 	ate_match_fn_t match_fn = NULL;
-
-	if (static_branch_unlikely(&arch_timer_read_ool_enabled))
-		return;
+	bool local = false;
 
 	switch (type) {
 	case ate_match_dt:
 		match_fn = arch_timer_check_dt_erratum;
 		break;
+	case ate_match_local_cap_id:
+		match_fn = arch_timer_check_local_cap_erratum;
+		local = true;
+		break;
 	default:
 		WARN_ON(1);
 		return;
@@ -209,8 +218,17 @@ static void arch_timer_check_ool_workaround(enum arch_timer_erratum_match_type t
 	if (!wa)
 		return;
 
+	if (needs_unstable_timer_counter_workaround()) {
+		if (wa != timer_unstable_counter_workaround)
+			pr_warn("Can't enable workaround for %s (clashes with %s\n)",
+				wa->desc,
+				timer_unstable_counter_workaround->desc);
+		return;
+	}
+
 	arch_timer_enable_workaround(wa);
-	pr_info("Enabling global workaround for %s\n", wa->desc);
+	pr_info("Enabling %s workaround for %s\n",
+		local ? "local" : "global", wa->desc);
 }
 
 #else
@@ -470,6 +488,8 @@ static void __arch_timer_setup(unsigned type,
 			BUG();
 		}
 
+		arch_timer_check_ool_workaround(ate_match_local_cap_id, NULL);
+
 		erratum_workaround_set_sne(clk);
 	} else {
 		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;
-- 
2.30.2

