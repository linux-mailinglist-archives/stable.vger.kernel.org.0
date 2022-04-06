Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045724F68BF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240072AbiDFSIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240428AbiDFSHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 136A718B7A0;
        Wed,  6 Apr 2022 09:46:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA27023A;
        Wed,  6 Apr 2022 09:46:14 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4184F3F73B;
        Wed,  6 Apr 2022 09:46:14 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 14/43] arm64: arch_timer: Add infrastructure for multiple erratum detection methods
Date:   Wed,  6 Apr 2022 17:45:17 +0100
Message-Id: <20220406164546.1888528-14-james.morse@arm.com>
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

commit 651bb2e9dca6e6dbad3fba5f6e6086a23575b8b5 upstream.

We're currently stuck with DT when it comes to handling errata, which
is pretty restrictive. In order to make things more flexible, let's
introduce an infrastructure that could support alternative discovery
methods. No change in functionality.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[ morse: Removed the changes to HiSilicon erratum 161010101, which isn't
  present in v4.9 ]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/arch_timer.h  |  7 ++-
 drivers/clocksource/arm_arch_timer.c | 81 ++++++++++++++++++++++++----
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index b4b34004a21e..5cd964e90d11 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -37,9 +37,14 @@ extern struct static_key_false arch_timer_read_ool_enabled;
 #define needs_unstable_timer_counter_workaround()  false
 #endif
 
+enum arch_timer_erratum_match_type {
+	ate_match_dt,
+};
 
 struct arch_timer_erratum_workaround {
-	const char *id;		/* Indicate the Erratum ID */
+	enum arch_timer_erratum_match_type match_type;
+	const void *id;
+	const char *desc;
 	u32 (*read_cntp_tval_el0)(void);
 	u32 (*read_cntv_tval_el0)(void);
 	u64 (*read_cntvct_el0)(void);
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 4b268ef9cc78..015b28e7f1f2 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -140,13 +140,81 @@ EXPORT_SYMBOL_GPL(arch_timer_read_ool_enabled);
 static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 #ifdef CONFIG_FSL_ERRATUM_A008585
 	{
+		.match_type = ate_match_dt,
 		.id = "fsl,erratum-a008585",
+		.desc = "Freescale erratum a005858",
 		.read_cntp_tval_el0 = fsl_a008585_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = fsl_a008585_read_cntv_tval_el0,
 		.read_cntvct_el0 = fsl_a008585_read_cntvct_el0,
 	},
 #endif
 };
+
+typedef bool (*ate_match_fn_t)(const struct arch_timer_erratum_workaround *,
+			       const void *);
+
+static
+bool arch_timer_check_dt_erratum(const struct arch_timer_erratum_workaround *wa,
+				 const void *arg)
+{
+	const struct device_node *np = arg;
+
+	return of_property_read_bool(np, wa->id);
+}
+
+static const struct arch_timer_erratum_workaround *
+arch_timer_iterate_errata(enum arch_timer_erratum_match_type type,
+			  ate_match_fn_t match_fn,
+			  void *arg)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ool_workarounds); i++) {
+		if (ool_workarounds[i].match_type != type)
+			continue;
+
+		if (match_fn(&ool_workarounds[i], arg))
+			return &ool_workarounds[i];
+	}
+
+	return NULL;
+}
+
+static
+void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa)
+{
+	timer_unstable_counter_workaround = wa;
+	static_branch_enable(&arch_timer_read_ool_enabled);
+}
+
+static void arch_timer_check_ool_workaround(enum arch_timer_erratum_match_type type,
+					    void *arg)
+{
+	const struct arch_timer_erratum_workaround *wa;
+	ate_match_fn_t match_fn = NULL;
+
+	if (static_branch_unlikely(&arch_timer_read_ool_enabled))
+		return;
+
+	switch (type) {
+	case ate_match_dt:
+		match_fn = arch_timer_check_dt_erratum;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	wa = arch_timer_iterate_errata(type, match_fn, arg);
+	if (!wa)
+		return;
+
+	arch_timer_enable_workaround(wa);
+	pr_info("Enabling global workaround for %s\n", wa->desc);
+}
+
+#else
+#define arch_timer_check_ool_workaround(t,a)		do { } while(0)
 #endif /* CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND */
 
 static __always_inline
@@ -919,17 +987,8 @@ static int __init arch_timer_of_init(struct device_node *np)
 
 	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
 
-#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
-	for (i = 0; i < ARRAY_SIZE(ool_workarounds); i++) {
-		if (of_property_read_bool(np, ool_workarounds[i].id)) {
-			timer_unstable_counter_workaround = &ool_workarounds[i];
-			static_branch_enable(&arch_timer_read_ool_enabled);
-			pr_info("arch_timer: Enabling workaround for %s\n",
-				timer_unstable_counter_workaround->id);
-			break;
-		}
-	}
-#endif
+	/* Check for globally applicable workarounds */
+	arch_timer_check_ool_workaround(ate_match_dt, np);
 
 	/*
 	 * If we cannot rely on firmware initializing the timer registers then
-- 
2.30.2

