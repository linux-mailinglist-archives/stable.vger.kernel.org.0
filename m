Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A2E4F6AB6
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiDFUBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbiDFUAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:00:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7AD26F23D;
        Wed,  6 Apr 2022 11:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D4BFB8252B;
        Wed,  6 Apr 2022 18:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D6DC385A1;
        Wed,  6 Apr 2022 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269631;
        bh=TmtFHpzi96JGPweioQRkEhgwGppePS7U0Q7YQwfl/SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiwguteeAMpGucc/ye2PJJKjSsQscqV1YpvEzq87AWsZJvPrJtfPpa6utoygmvL05
         b/EHPYuhWsFzBnVaPPHItx+a6m9smu1vwsh9+cIaAt1MS36GkHLK0t1I7CNViiy4lU
         ttXUiXCGePD77NbWnOuSGsP2LQz9yd4U0h2uiodk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Tianhong <dingtianhong@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 13/43] clocksource/drivers/arm_arch_timer: Introduce generic errata handling infrastructure
Date:   Wed,  6 Apr 2022 20:26:22 +0200
Message-Id: <20220406182437.070605313@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/arch_timer.h  |   40 +++++----------
 drivers/clocksource/Kconfig          |    4 +
 drivers/clocksource/arm_arch_timer.c |   90 ++++++++++++++++++++++++-----------
 3 files changed, 80 insertions(+), 54 deletions(-)

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
-
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
+
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
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -96,27 +96,58 @@ early_param("clocksource.arm_arch_timer.
  */
 
 #ifdef CONFIG_FSL_ERRATUM_A008585
-DEFINE_STATIC_KEY_FALSE(arch_timer_read_ool_enabled);
-EXPORT_SYMBOL_GPL(arch_timer_read_ool_enabled);
-
-static int fsl_a008585_enable = -1;
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
@@ -267,8 +298,8 @@ static __always_inline void set_next_eve
 	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 }
 
-#ifdef CONFIG_FSL_ERRATUM_A008585
-static __always_inline void fsl_a008585_set_next_event(const int access,
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
+static __always_inline void erratum_set_next_event_generic(const int access,
 		unsigned long evt, struct clock_event_device *clk)
 {
 	unsigned long ctrl;
@@ -286,20 +317,20 @@ static __always_inline void fsl_a008585_
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
@@ -329,16 +360,16 @@ static int arch_timer_set_next_event_phy
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
 
@@ -371,7 +402,7 @@ static void __arch_timer_setup(unsigned
 			BUG();
 		}
 
-		fsl_a008585_set_sne(clk);
+		erratum_workaround_set_sne(clk);
 	} else {
 		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;
 		clk->name = "arch_mem_timer";
@@ -600,7 +631,7 @@ static void __init arch_counter_register
 
 		clocksource_counter.archdata.vdso_direct = true;
 
-#ifdef CONFIG_FSL_ERRATUM_A008585
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
 		/*
 		 * Don't use the vdso fastpath if errata require using
 		 * the out-of-line counter accessor.
@@ -888,12 +919,15 @@ static int __init arch_timer_of_init(str
 
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
 


