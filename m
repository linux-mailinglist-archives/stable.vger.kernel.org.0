Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C54226A40
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbgGTQc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731808AbgGTP4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E49120734;
        Mon, 20 Jul 2020 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260602;
        bh=wNlxRvebGgShxuJVu8yvMXJi/nodLWBRPPFAXdnm1cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW5Dv/TD/q/TTR9RWLCzOdg0RPITJ67p2E0IPrT8XzdBW+bfLvIVAc4Xr3EPFoGXR
         VZxrk4USyXzG5BxWyjFR9XiJf15nkmrL27x5T5N+sQvX6SgP8K4J6/w+cqjbdfPDcL
         CYAguANOx9zq5074YRWCzoKXcxgEcu1rbaguPT2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 027/215] arm64: Introduce a way to disable the 32bit vdso
Date:   Mon, 20 Jul 2020 17:35:09 +0200
Message-Id: <20200720152821.472994875@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 97884ca8c2925d14c32188e865069f21378b4b4f upstream.

[this is a redesign rather than a backport]

We have a class of errata (grouped under the ARM64_WORKAROUND_1418040
banner) that force the trapping of counter access from 32bit EL0.

We would normally disable the whole vdso for such defect, except that
it would disable it for 64bit userspace as well, which is a shame.

Instead, add a new vdso_clock_mode, which signals that the vdso
isn't usable for compat tasks.  This gets checked in the new
vdso_clocksource_ok() helper, now provided for the 32bit vdso.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-2-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/clocksource.h                |   11 ++++++++++-
 arch/arm/kernel/vdso.c                            |    2 +-
 arch/arm64/include/asm/clocksource.h              |    5 ++++-
 arch/arm64/include/asm/vdso/clocksource.h         |   14 ++++++++++++++
 arch/arm64/include/asm/vdso/compat_gettimeofday.h |    5 +++--
 arch/arm64/include/asm/vdso/gettimeofday.h        |    6 ++++--
 arch/arm64/include/asm/vdso/vsyscall.h            |    4 +---
 drivers/clocksource/arm_arch_timer.c              |    8 ++++----
 8 files changed, 41 insertions(+), 14 deletions(-)

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
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -281,7 +281,7 @@ static bool tk_is_cntvct(const struct ti
 	if (!IS_ENABLED(CONFIG_ARM_ARCH_TIMER))
 		return false;
 
-	if (!tk->tkr_mono.clock->archdata.vdso_direct)
+	if (tk->tkr_mono.clock->archdata.clock_mode != VDSO_CLOCKMODE_ARCHTIMER)
 		return false;
 
 	return true;
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
--- a/arch/arm64/include/asm/vdso/compat_gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
@@ -10,6 +10,7 @@
 #include <asm/unistd.h>
 #include <uapi/linux/time.h>
 
+#include <asm/vdso/clocksource.h>
 #include <asm/vdso/compat_barrier.h>
 
 #define __VDSO_USE_SYSCALL		ULLONG_MAX
@@ -117,10 +118,10 @@ static __always_inline u64 __arch_get_hw
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
--- a/arch/arm64/include/asm/vdso/gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/gettimeofday.h
@@ -10,6 +10,8 @@
 #include <asm/unistd.h>
 #include <uapi/linux/time.h>
 
+#include <asm/vdso/clocksource.h>
+
 #define __VDSO_USE_SYSCALL		ULLONG_MAX
 
 #define VDSO_HAS_CLOCK_GETRES		1
@@ -71,10 +73,10 @@ static __always_inline u64 __arch_get_hw
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
--- a/arch/arm64/include/asm/vdso/vsyscall.h
+++ b/arch/arm64/include/asm/vdso/vsyscall.h
@@ -24,9 +24,7 @@ struct vdso_data *__arm64_get_k_vdso_dat
 static __always_inline
 int __arm64_get_clock_mode(struct timekeeper *tk)
 {
-	u32 use_syscall = !tk->tkr_mono.clock->archdata.vdso_direct;
-
-	return use_syscall;
+	return tk->tkr_mono.clock->archdata.clock_mode;
 }
 #define __arch_get_clock_mode __arm64_get_clock_mode
 
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -69,7 +69,7 @@ static enum arch_timer_ppi_nr arch_timer
 static bool arch_timer_c3stop;
 static bool arch_timer_mem_use_virtual;
 static bool arch_counter_suspend_stop;
-static bool vdso_default = true;
+static enum vdso_arch_clockmode vdso_default = VDSO_CLOCKMODE_ARCHTIMER;
 
 static cpumask_t evtstrm_available = CPU_MASK_NONE;
 static bool evtstrm_enable = IS_ENABLED(CONFIG_ARM_ARCH_TIMER_EVTSTREAM);
@@ -560,8 +560,8 @@ void arch_timer_enable_workaround(const
 	 * change both the default value and the vdso itself.
 	 */
 	if (wa->read_cntvct_el0) {
-		clocksource_counter.archdata.vdso_direct = false;
-		vdso_default = false;
+		clocksource_counter.archdata.clock_mode = VDSO_CLOCKMODE_NONE;
+		vdso_default = VDSO_CLOCKMODE_NONE;
 	}
 }
 
@@ -979,7 +979,7 @@ static void __init arch_counter_register
 		}
 
 		arch_timer_read_counter = rd;
-		clocksource_counter.archdata.vdso_direct = vdso_default;
+		clocksource_counter.archdata.clock_mode = vdso_default;
 	} else {
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
 	}


