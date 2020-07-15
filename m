Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5350220D7A
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbgGOM4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbgGOM4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 08:56:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7888E2071B;
        Wed, 15 Jul 2020 12:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594817782;
        bh=HHgq5Aw7MvTkZoOq7NH6RBQ+tuEiK2FaORHhLBGmu6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HglqKzNswxNon/LwMBmh8ZYxETFJtJEFEm2zpGj0IAco7CtNIh4Lw2EesSUcXmElx
         /bydonwrpL5kdkk5f3wKMjgqH80yHWwic5/RBuylqMA5y+isrEoirGit2X2IbVrA2a
         9BkbRvvdYnZsHmW7cdsbdw2rLoJvlbcvcvL4WPEY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jvgxR-00Bzgo-1v; Wed, 15 Jul 2020 13:56:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     arnd@arndb.de, sashal@kernel.org, naresh.kamboju@linaro.org,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: [Stable-5.4][PATCH 1/3] arm64: Introduce a way to disable the 32bit vdso
Date:   Wed, 15 Jul 2020 13:56:12 +0100
Message-Id: <20200715125614.3240269-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200715125614.3240269-1-maz@kernel.org>
References: <20200715125614.3240269-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, stable@vger.kernel.org, arnd@arndb.de, sashal@kernel.org, naresh.kamboju@linaro.org, mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, daniel.lezcano@linaro.org, vincenzo.frascino@arm.com, linux@arm.linux.org.uk, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 97884ca8c2925d14c32188e865069f21378b4b4f upstream.

[this is a redesign rather than a backport]

We have a class of errata (grouped under the ARM64_WORKAROUND_1418040
banner) that force the trapping of counter access from 32bit EL0.

We would normally disable the whole vdso for such defect, except that
it would disable it for 64bit userspace as well, which is a shame.

Instead, add a new vdso_clock_mode, which signals that the vdso
isn't usable for compat tasks.  This gets checked in the
__arch_get_hw_counter() helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-2-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/clocksource.h                | 11 ++++++++++-
 arch/arm/kernel/vdso.c                            |  2 +-
 arch/arm64/include/asm/clocksource.h              |  5 ++++-
 arch/arm64/include/asm/vdso/clocksource.h         | 14 ++++++++++++++
 arch/arm64/include/asm/vdso/compat_gettimeofday.h |  5 +++--
 arch/arm64/include/asm/vdso/gettimeofday.h        |  6 ++++--
 arch/arm64/include/asm/vdso/vsyscall.h            |  4 +---
 drivers/clocksource/arm_arch_timer.c              |  8 ++++----
 8 files changed, 41 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/include/asm/vdso/clocksource.h

diff --git a/arch/arm/include/asm/clocksource.h b/arch/arm/include/asm/clocksource.h
index 0b350a7e26f3..afb7a59828fe 100644
--- a/arch/arm/include/asm/clocksource.h
+++ b/arch/arm/include/asm/clocksource.h
@@ -1,8 +1,17 @@
 #ifndef _ASM_CLOCKSOURCE_H
 #define _ASM_CLOCKSOURCE_H
 
+enum vdso_arch_clockmode {
+	/* vdso clocksource not usable */
+	VDSO_CLOCKMODE_NONE,
+	/* vdso clocksource usable */
+	VDSO_CLOCKMODE_ARCHTIMER,
+	VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT = VDSO_CLOCKMODE_ARCHTIMER,
+};
+
 struct arch_clocksource_data {
-	bool vdso_direct;	/* Usable for direct VDSO access? */
+	/* Usable for direct VDSO access? */
+	enum vdso_arch_clockmode clock_mode;
 };
 
 #endif
diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
index f00e45fa62c4..6c69a5548ba2 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -281,7 +281,7 @@ static bool tk_is_cntvct(const struct timekeeper *tk)
 	if (!IS_ENABLED(CONFIG_ARM_ARCH_TIMER))
 		return false;
 
-	if (!tk->tkr_mono.clock->archdata.vdso_direct)
+	if (tk->tkr_mono.clock->archdata.clock_mode != VDSO_CLOCKMODE_ARCHTIMER)
 		return false;
 
 	return true;
diff --git a/arch/arm64/include/asm/clocksource.h b/arch/arm64/include/asm/clocksource.h
index 0ece64a26c8c..0c7910447235 100644
--- a/arch/arm64/include/asm/clocksource.h
+++ b/arch/arm64/include/asm/clocksource.h
@@ -2,8 +2,11 @@
 #ifndef _ASM_CLOCKSOURCE_H
 #define _ASM_CLOCKSOURCE_H
 
+#include <asm/vdso/clocksource.h>
+
 struct arch_clocksource_data {
-	bool vdso_direct;	/* Usable for direct VDSO access? */
+	/* Usable for direct VDSO access? */
+	enum vdso_arch_clockmode clock_mode;
 };
 
 #endif
diff --git a/arch/arm64/include/asm/vdso/clocksource.h b/arch/arm64/include/asm/vdso/clocksource.h
new file mode 100644
index 000000000000..8019f616e1f7
--- /dev/null
+++ b/arch/arm64/include/asm/vdso/clocksource.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_VDSOCLOCKSOURCE_H
+#define __ASM_VDSOCLOCKSOURCE_H
+
+enum vdso_arch_clockmode {
+	/* vdso clocksource not usable */
+	VDSO_CLOCKMODE_NONE,
+	/* vdso clocksource for both 32 and 64bit tasks */
+	VDSO_CLOCKMODE_ARCHTIMER,
+	/* vdso clocksource for 64bit tasks only */
+	VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT,
+};
+
+#endif
diff --git a/arch/arm64/include/asm/vdso/compat_gettimeofday.h b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
index c50ee1b7d5cd..413d42e197c7 100644
--- a/arch/arm64/include/asm/vdso/compat_gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
@@ -10,6 +10,7 @@
 #include <asm/unistd.h>
 #include <uapi/linux/time.h>
 
+#include <asm/vdso/clocksource.h>
 #include <asm/vdso/compat_barrier.h>
 
 #define __VDSO_USE_SYSCALL		ULLONG_MAX
@@ -117,10 +118,10 @@ static __always_inline u64 __arch_get_hw_counter(s32 clock_mode)
 	u64 res;
 
 	/*
-	 * clock_mode == 0 implies that vDSO are enabled otherwise
+	 * clock_mode == ARCHTIMER implies that vDSO are enabled otherwise
 	 * fallback on syscall.
 	 */
-	if (clock_mode)
+	if (clock_mode != VDSO_CLOCKMODE_ARCHTIMER)
 		return __VDSO_USE_SYSCALL;
 
 	/*
diff --git a/arch/arm64/include/asm/vdso/gettimeofday.h b/arch/arm64/include/asm/vdso/gettimeofday.h
index b08f476b72b4..ff83b8b574fc 100644
--- a/arch/arm64/include/asm/vdso/gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/gettimeofday.h
@@ -10,6 +10,8 @@
 #include <asm/unistd.h>
 #include <uapi/linux/time.h>
 
+#include <asm/vdso/clocksource.h>
+
 #define __VDSO_USE_SYSCALL		ULLONG_MAX
 
 #define VDSO_HAS_CLOCK_GETRES		1
@@ -71,10 +73,10 @@ static __always_inline u64 __arch_get_hw_counter(s32 clock_mode)
 	u64 res;
 
 	/*
-	 * clock_mode == 0 implies that vDSO are enabled otherwise
+	 * clock_mode != NONE implies that vDSO are enabled otherwise
 	 * fallback on syscall.
 	 */
-	if (clock_mode)
+	if (clock_mode == VDSO_CLOCKMODE_NONE)
 		return __VDSO_USE_SYSCALL;
 
 	/*
diff --git a/arch/arm64/include/asm/vdso/vsyscall.h b/arch/arm64/include/asm/vdso/vsyscall.h
index 0c20a7c1bee5..e50f26741946 100644
--- a/arch/arm64/include/asm/vdso/vsyscall.h
+++ b/arch/arm64/include/asm/vdso/vsyscall.h
@@ -24,9 +24,7 @@ struct vdso_data *__arm64_get_k_vdso_data(void)
 static __always_inline
 int __arm64_get_clock_mode(struct timekeeper *tk)
 {
-	u32 use_syscall = !tk->tkr_mono.clock->archdata.vdso_direct;
-
-	return use_syscall;
+	return tk->tkr_mono.clock->archdata.clock_mode;
 }
 #define __arch_get_clock_mode __arm64_get_clock_mode
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 9a5464c625b4..909fe093249e 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -69,7 +69,7 @@ static enum arch_timer_ppi_nr arch_timer_uses_ppi = ARCH_TIMER_VIRT_PPI;
 static bool arch_timer_c3stop;
 static bool arch_timer_mem_use_virtual;
 static bool arch_counter_suspend_stop;
-static bool vdso_default = true;
+static enum vdso_arch_clockmode vdso_default = VDSO_CLOCKMODE_ARCHTIMER;
 
 static cpumask_t evtstrm_available = CPU_MASK_NONE;
 static bool evtstrm_enable = IS_ENABLED(CONFIG_ARM_ARCH_TIMER_EVTSTREAM);
@@ -560,8 +560,8 @@ void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa
 	 * change both the default value and the vdso itself.
 	 */
 	if (wa->read_cntvct_el0) {
-		clocksource_counter.archdata.vdso_direct = false;
-		vdso_default = false;
+		clocksource_counter.archdata.clock_mode = VDSO_CLOCKMODE_NONE;
+		vdso_default = VDSO_CLOCKMODE_NONE;
 	}
 }
 
@@ -979,7 +979,7 @@ static void __init arch_counter_register(unsigned type)
 		}
 
 		arch_timer_read_counter = rd;
-		clocksource_counter.archdata.vdso_direct = vdso_default;
+		clocksource_counter.archdata.clock_mode = vdso_default;
 	} else {
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
 	}
-- 
2.27.0

