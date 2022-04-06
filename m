Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A5C4F693B
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbiDFSIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbiDFSHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25A6B1890E3;
        Wed,  6 Apr 2022 09:46:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C9AE1516;
        Wed,  6 Apr 2022 09:46:14 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5ED713F73B;
        Wed,  6 Apr 2022 09:46:13 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 13/43] clocksource/drivers/arm_arch_timer: Introduce generic errata handling infrastructure
Date:   Wed,  6 Apr 2022 17:45:16 +0100
Message-Id: <20220406164546.1888528-13-james.morse@arm.com>
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

From: Ding Tianhong <dingtianhong@huawei.com>

commit 16d10ef29f25aba923779234bb93a451b14d20e6 upstream.

Currently we have code inline in the arch timer probe path to cater for
Freescale erratum A-008585, complete with ifdeffery. This is a little
ugly, and will get worse as we try to add more errata handling.

This patch refactors the handling of Freescale erratum A-008585. Now the
erratum is described in a generic arch_timer_erratum_workaround
structure, and the probe path can iterate over these to detect errata
and enable workarounds.

This will simplify the addition and maintenance of code handling
Hisilicon erratum 161010101.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
[Mark: split patch, correct Kconfig, reword commit message]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/arch_timer.h  | 38 ++++--------
 drivers/clocksource/Kconfig          |  4 ++
 drivers/clocksource/arm_arch_timer.c | 90 +++++++++++++++++++---------
 3 files changed, 79 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index eaa5bbe3fa87..b4b34004a21e 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -29,41 +29,29 @@
 
 #include <clocksource/arm_arch_timer.h>
 
-#if IS_ENABLED(CONFIG_FSL_ERRATUM_A008585)
+#if IS_ENABLED(CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND)
 extern struct static_key_false arch_timer_read_ool_enabled;
-#define needs_fsl_a008585_workaround() \
+#define needs_unstable_timer_counter_workaround() \
 	static_branch_unlikely(&arch_timer_read_ool_enabled)
 #else
-#define needs_fsl_a008585_workaround()  false
+#define needs_unstable_timer_counter_workaround()  false
 #endif
 
-u32 __fsl_a008585_read_cntp_tval_el0(void);
-u32 __fsl_a008585_read_cntv_tval_el0(void);
-u64 __fsl_a008585_read_cntvct_el0(void);
 
-/*
- * The number of retries is an arbitrary value well beyond the highest number
- * of iterations the loop has been observed to take.
- */
-#define __fsl_a008585_read_reg(reg) ({			\
-	u64 _old, _new;					\
-	int _retries = 200;				\
-							\
-	do {						\
-		_old = read_sysreg(reg);		\
-		_new = read_sysreg(reg);		\
-		_retries--;				\
-	} while (unlikely(_old != _new) && _retries);	\
-							\
-	WARN_ON_ONCE(!_retries);			\
-	_new;						\
-})
+struct arch_timer_erratum_workaround {
+	const char *id;		/* Indicate the Erratum ID */
+	u32 (*read_cntp_tval_el0)(void);
+	u32 (*read_cntv_tval_el0)(void);
+	u64 (*read_cntvct_el0)(void);
+};
+
+extern const struct arch_timer_erratum_workaround *timer_unstable_counter_workaround;
 
 #define arch_timer_reg_read_stable(reg) 		\
 ({							\
 	u64 _val;					\
-	if (needs_fsl_a008585_workaround())		\
-		_val = __fsl_a008585_read_##reg();	\
+	if (needs_unstable_timer_counter_workaround())		\
+		_val = timer_unstable_counter_workaround->read_##reg();\
 	else						\
 		_val = read_sysreg(reg);		\
 	_val;						\
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index e2c6e43cf8ca..3d748eac1a68 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -305,10 +305,14 @@ config ARM_ARCH_TIMER_EVTSTREAM
 	  This must be disabled for hardware validation purposes to detect any
 	  hardware anomalies of missing events.
 
+config ARM_ARCH_TIMER_OOL_WORKAROUND
+	bool
+
 config FSL_ERRATUM_A008585
 	bool "Workaround for Freescale/NXP Erratum A-008585"
 	default y
 	depends on ARM_ARCH_TIMER && ARM64
+	select ARM_ARCH_TIMER_OOL_WORKAROUND
 	help
 	  This option enables a workaround for Freescale/NXP Erratum
 	  A-008585 ("ARM generic timer may contain an erroneous
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index c2a5e8252cd7..4b268ef9cc78 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -96,27 +96,58 @@ early_param("clocksource.arm_arch_timer.evtstrm", early_evtstrm_cfg);
  */
 
 #ifdef CONFIG_FSL_ERRATUM_A008585
-DEFINE_STATIC_KEY_FALSE(arch_timer_read_ool_enabled);
-EXPORT_SYMBOL_GPL(arch_timer_read_ool_enabled);
+/*
+ * The number of retries is an arbitrary value well beyond the highest number
+ * of iterations the loop has been observed to take.
+ */
+#define __fsl_a008585_read_reg(reg) ({			\
+	u64 _old, _new;					\
+	int _retries = 200;				\
+							\
+	do {						\
+		_old = read_sysreg(reg);		\
+		_new = read_sysreg(reg);		\
+		_retries--;				\
+	} while (unlikely(_old != _new) && _retries);	\
+							\
+	WARN_ON_ONCE(!_retries);			\
+	_new;						\
+})
 
-static int fsl_a008585_enable = -1;
-
-u32 __fsl_a008585_read_cntp_tval_el0(void)
+static u32 notrace fsl_a008585_read_cntp_tval_el0(void)
 {
 	return __fsl_a008585_read_reg(cntp_tval_el0);
 }
 
-u32 __fsl_a008585_read_cntv_tval_el0(void)
+static u32 notrace fsl_a008585_read_cntv_tval_el0(void)
 {
 	return __fsl_a008585_read_reg(cntv_tval_el0);
 }
 
-u64 __fsl_a008585_read_cntvct_el0(void)
+static u64 notrace fsl_a008585_read_cntvct_el0(void)
 {
 	return __fsl_a008585_read_reg(cntvct_el0);
 }
-EXPORT_SYMBOL(__fsl_a008585_read_cntvct_el0);
-#endif /* CONFIG_FSL_ERRATUM_A008585 */
+#endif
+
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
+const struct arch_timer_erratum_workaround *timer_unstable_counter_workaround = NULL;
+EXPORT_SYMBOL_GPL(timer_unstable_counter_workaround);
+
+DEFINE_STATIC_KEY_FALSE(arch_timer_read_ool_enabled);
+EXPORT_SYMBOL_GPL(arch_timer_read_ool_enabled);
+
+static const struct arch_timer_erratum_workaround ool_workarounds[] = {
+#ifdef CONFIG_FSL_ERRATUM_A008585
+	{
+		.id = "fsl,erratum-a008585",
+		.read_cntp_tval_el0 = fsl_a008585_read_cntp_tval_el0,
+		.read_cntv_tval_el0 = fsl_a008585_read_cntv_tval_el0,
+		.read_cntvct_el0 = fsl_a008585_read_cntvct_el0,
+	},
+#endif
+};
+#endif /* CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND */
 
 static __always_inline
 void arch_timer_reg_write(int access, enum arch_timer_reg reg, u32 val,
@@ -267,8 +298,8 @@ static __always_inline void set_next_event(const int access, unsigned long evt,
 	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 }
 
-#ifdef CONFIG_FSL_ERRATUM_A008585
-static __always_inline void fsl_a008585_set_next_event(const int access,
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
+static __always_inline void erratum_set_next_event_generic(const int access,
 		unsigned long evt, struct clock_event_device *clk)
 {
 	unsigned long ctrl;
@@ -286,20 +317,20 @@ static __always_inline void fsl_a008585_set_next_event(const int access,
 	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 }
 
-static int fsl_a008585_set_next_event_virt(unsigned long evt,
+static int erratum_set_next_event_virt(unsigned long evt,
 					   struct clock_event_device *clk)
 {
-	fsl_a008585_set_next_event(ARCH_TIMER_VIRT_ACCESS, evt, clk);
+	erratum_set_next_event_generic(ARCH_TIMER_VIRT_ACCESS, evt, clk);
 	return 0;
 }
 
-static int fsl_a008585_set_next_event_phys(unsigned long evt,
+static int erratum_set_next_event_phys(unsigned long evt,
 					   struct clock_event_device *clk)
 {
-	fsl_a008585_set_next_event(ARCH_TIMER_PHYS_ACCESS, evt, clk);
+	erratum_set_next_event_generic(ARCH_TIMER_PHYS_ACCESS, evt, clk);
 	return 0;
 }
-#endif /* CONFIG_FSL_ERRATUM_A008585 */
+#endif /* CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND */
 
 static int arch_timer_set_next_event_virt(unsigned long evt,
 					  struct clock_event_device *clk)
@@ -329,16 +360,16 @@ static int arch_timer_set_next_event_phys_mem(unsigned long evt,
 	return 0;
 }
 
-static void fsl_a008585_set_sne(struct clock_event_device *clk)
+static void erratum_workaround_set_sne(struct clock_event_device *clk)
 {
-#ifdef CONFIG_FSL_ERRATUM_A008585
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
 	if (!static_branch_unlikely(&arch_timer_read_ool_enabled))
 		return;
 
 	if (arch_timer_uses_ppi == VIRT_PPI)
-		clk->set_next_event = fsl_a008585_set_next_event_virt;
+		clk->set_next_event = erratum_set_next_event_virt;
 	else
-		clk->set_next_event = fsl_a008585_set_next_event_phys;
+		clk->set_next_event = erratum_set_next_event_phys;
 #endif
 }
 
@@ -371,7 +402,7 @@ static void __arch_timer_setup(unsigned type,
 			BUG();
 		}
 
-		fsl_a008585_set_sne(clk);
+		erratum_workaround_set_sne(clk);
 	} else {
 		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;
 		clk->name = "arch_mem_timer";
@@ -600,7 +631,7 @@ static void __init arch_counter_register(unsigned type)
 
 		clocksource_counter.archdata.vdso_direct = true;
 
-#ifdef CONFIG_FSL_ERRATUM_A008585
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
 		/*
 		 * Don't use the vdso fastpath if errata require using
 		 * the out-of-line counter accessor.
@@ -888,12 +919,15 @@ static int __init arch_timer_of_init(struct device_node *np)
 
 	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
 
-#ifdef CONFIG_FSL_ERRATUM_A008585
-	if (fsl_a008585_enable < 0)
-		fsl_a008585_enable = of_property_read_bool(np, "fsl,erratum-a008585");
-	if (fsl_a008585_enable) {
-		static_branch_enable(&arch_timer_read_ool_enabled);
-		pr_info("Enabling workaround for FSL erratum A-008585\n");
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
+	for (i = 0; i < ARRAY_SIZE(ool_workarounds); i++) {
+		if (of_property_read_bool(np, ool_workarounds[i].id)) {
+			timer_unstable_counter_workaround = &ool_workarounds[i];
+			static_branch_enable(&arch_timer_read_ool_enabled);
+			pr_info("arch_timer: Enabling workaround for %s\n",
+				timer_unstable_counter_workaround->id);
+			break;
+		}
 	}
 #endif
 
-- 
2.30.2

