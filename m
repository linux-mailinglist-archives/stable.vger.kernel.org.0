Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EEF669573
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 12:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbjAML12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 06:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240334AbjAML06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 06:26:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB597A230;
        Fri, 13 Jan 2023 03:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF7846131A;
        Fri, 13 Jan 2023 11:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE8BC433D2;
        Fri, 13 Jan 2023 11:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673608620;
        bh=+jXgR1m6OX0WIdQRy4Gs3afhMXRPN4hqJNuT5glPHW0=;
        h=From:To:Cc:Subject:Date:From;
        b=q9r0YIU0mI3vCSVUdZRH4THwSEHbNjdj4YNohTYtdA7QCmx0l61dRo2XvJra9tcaK
         EIGaGJhshbWNjqICVh46n8uMYm1USimc0eHCxSzt+lPEfS85wfrWvr477fhdrkhJjv
         jkuezE0/QKvQoGYmgavbyQMZgrKgDxtwUgiEkrpyBU0j3S82j/Qshf6GE+rvgINEth
         HN42oBff/ifKPWE8nUQt04qpcfrdrkEyxZ1BAwOLXYBi8ni9J6bNGZ9inxG3npeJTd
         dtu6XawtLG+v7mQbqSe7tmrL5BbbribjB8hZWTo5pi7AU2uLra9fvzr3bRbbmr9nU4
         +nie9qwcNdb4Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pGI3N-001UQP-ST;
        Fri, 13 Jan 2023 11:16:57 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Thomas Gleixner <tglx@linotronix.de>, stable@vger.kernel.org,
        Yogesh Lal <quic_ylal@quicinc.com>
Subject: [PATCH] clocksource/drivers/arm_arch_timer: Update sched_clock when non-boot CPUs need counter workaround
Date:   Fri, 13 Jan 2023 11:16:48 +0000
Message-Id: <20230113111648.1977473-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, mark.rutland@arm.com, will@kernel.org, daniel.lezcano@kernel.org, tglx@linotronix.de, stable@vger.kernel.org, quic_ylal@quicinc.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When booting on a CPU that has a countertum on the counter read,
we use the arch_counter_get_cnt{v,p}ct_stable() backend which
applies the workaround.

However, we don't do the same thing when an affected CPU is
a secondary CPU, and we're stuck with the standard sched_clock()
backend that knows nothing about the workaround.

Fix it by always indirecting sched_clock(), making arch_timer_read_counter
a function instead of a function pointer. In turn, we update the
pointer (now private to the driver code) when detecting a new
workaround.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@kernel.org>
Cc: Thomas Gleixner <tglx@linotronix.de>
Cc: stable@vger.kernel.org
Reported-by: Yogesh Lal <quic_ylal@quicinc.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use arch_timer_read_counter to access stable counters")
Link: https://lore.kernel.org/r/ca4679a0-7f29-65f4-54b9-c575248192f1@quicinc.com
---
 drivers/clocksource/arm_arch_timer.c | 56 +++++++++++++++++-----------
 include/clocksource/arm_arch_timer.h |  2 +-
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index e09d4427f604..5272db86bef5 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -217,7 +217,12 @@ static notrace u64 arch_counter_get_cntvct(void)
  * to exist on arm64. arm doesn't use this before DT is probed so even
  * if we don't have the cp15 accessors we won't have a problem.
  */
-u64 (*arch_timer_read_counter)(void) __ro_after_init = arch_counter_get_cntvct;
+static u64 (*__arch_timer_read_counter)(void) __ro_after_init = arch_counter_get_cntvct;
+
+u64 arch_timer_read_counter(void)
+{
+	return __arch_timer_read_counter();
+}
 EXPORT_SYMBOL_GPL(arch_timer_read_counter);
 
 static u64 arch_counter_read(struct clocksource *cs)
@@ -230,6 +235,28 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
 	return arch_timer_read_counter();
 }
 
+static bool arch_timer_counter_has_wa(void);
+
+static u64 (*arch_counter_get_read_fn(void))(void)
+{
+	u64 (*rd)(void);
+
+	if ((IS_ENABLED(CONFIG_ARM64) && !is_hyp_mode_available()) ||
+	    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
+		if (arch_timer_counter_has_wa())
+			rd = arch_counter_get_cntvct_stable;
+		else
+			rd = arch_counter_get_cntvct;
+	} else {
+		if (arch_timer_counter_has_wa())
+			rd = arch_counter_get_cntpct_stable;
+		else
+			rd = arch_counter_get_cntpct;
+	}
+
+	return rd;
+}
+
 static struct clocksource clocksource_counter = {
 	.name	= "arch_sys_counter",
 	.id	= CSID_ARM_ARCH_COUNTER,
@@ -571,8 +598,10 @@ void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa
 			per_cpu(timer_unstable_counter_workaround, i) = wa;
 	}
 
-	if (wa->read_cntvct_el0 || wa->read_cntpct_el0)
-		atomic_set(&timer_unstable_counter_workaround_in_use, 1);
+	if (wa->read_cntvct_el0 || wa->read_cntpct_el0) {
+		__arch_timer_read_counter = arch_counter_get_read_fn();
+		atomic_set_release(&timer_unstable_counter_workaround_in_use, 1);
+	}
 
 	/*
 	 * Don't use the vdso fastpath if errata require using the
@@ -641,7 +670,7 @@ static bool arch_timer_counter_has_wa(void)
 #else
 #define arch_timer_check_ool_workaround(t,a)		do { } while(0)
 #define arch_timer_this_cpu_has_cntvct_wa()		({false;})
-#define arch_timer_counter_has_wa()			({false;})
+static bool arch_timer_counter_has_wa(void)		{ return false; }
 #endif /* CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND */
 
 static __always_inline irqreturn_t timer_handler(const int access,
@@ -1079,25 +1108,10 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_TIMER_TYPE_CP15) {
-		u64 (*rd)(void);
-
-		if ((IS_ENABLED(CONFIG_ARM64) && !is_hyp_mode_available()) ||
-		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
-			if (arch_timer_counter_has_wa())
-				rd = arch_counter_get_cntvct_stable;
-			else
-				rd = arch_counter_get_cntvct;
-		} else {
-			if (arch_timer_counter_has_wa())
-				rd = arch_counter_get_cntpct_stable;
-			else
-				rd = arch_counter_get_cntpct;
-		}
-
-		arch_timer_read_counter = rd;
+		__arch_timer_read_counter = arch_counter_get_read_fn();
 		clocksource_counter.vdso_clock_mode = vdso_default;
 	} else {
-		arch_timer_read_counter = arch_counter_get_cntvct_mem;
+		__arch_timer_read_counter = arch_counter_get_cntvct_mem;
 	}
 
 	width = arch_counter_get_width();
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 057c8964aefb..ec331b65ba23 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -85,7 +85,7 @@ struct arch_timer_mem {
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
-extern u64 (*arch_timer_read_counter)(void);
+extern u64 arch_timer_read_counter(void);
 extern struct arch_timer_kvm_info *arch_timer_get_kvm_info(void);
 extern bool arch_timer_evtstrm_available(void);
 
-- 
2.34.1

