Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FE699DDB
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403779AbfHVRXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391703AbfHVRXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:01 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4954233FC;
        Thu, 22 Aug 2019 17:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494579;
        bh=FsUGeY9eo7GuzAGPtRzW+Q3Jf1iFUrTPuybXbGlQpu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjt79HECjR5fZVfoN9TiuRsEqJrqsOiddDNvxWfAEBh7rgDl+B1QXNVef5ThqTtD1
         BNcAwq9fod9uPdn8dHIZ0DSjrq8W3wJq6Vv5G/sysP4RTCeP6lVJvyMM3YH4Fiqkik
         65nyeu+1m2q7K+cFuDlteSX3LKkOivqvxp+3+5GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hpe.com>,
        Waiman Long <waiman.long@hpe.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 71/78] x86/vdso: Remove direct HPET access through the vDSO
Date:   Thu, 22 Aug 2019 10:19:15 -0700
Message-Id: <20190822171834.084939719@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 1ed95e52d902035e39a715ff3a314a893a96e5b7 upstream.

Allowing user code to map the HPET is problematic.  HPET
implementations are notoriously buggy, and there are probably many
machines on which even MMIO reads from bogus HPET addresses are
problematic.

We have a report that the Dell Precision M2800 with:

  ACPI: HPET 0x00000000C8FE6238 000038 (v01 DELL   CBX3  01072009 AMI. 00000005)

is either so slow when accessing the HPET or actually hangs in some
regard, causing soft lockups to be reported if users do unexpected
things to the HPET.

The vclock HPET code has also always been a questionable speedup.
Accessing an HPET is exceedingly slow (on the order of several
microseconds), so the added overhead in requiring a syscall to read
the HPET is a small fraction of the total code of accessing it.

To avoid future problems, let's just delete the code entirely.

In the long run, this could actually be a speedup.  Waiman Long as a
patch to optimize the case where multiple CPUs contend for the HPET,
but that won't help unless all the accesses are mediated by the
kernel.

Reported-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <Waiman.Long@hpe.com>
Cc: Waiman Long <waiman.long@hpe.com>
Link: http://lkml.kernel.org/r/d2f90bba98db9905041cff294646d290d378f67a.1460074438.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/vdso/vclock_gettime.c  |   15 ---------------
 arch/x86/entry/vdso/vdso-layout.lds.S |    5 ++---
 arch/x86/include/asm/clocksource.h    |    3 +--
 arch/x86/kernel/hpet.c                |    1 -
 arch/x86/kvm/trace.h                  |    3 +--
 5 files changed, 4 insertions(+), 23 deletions(-)

--- a/arch/x86/entry/vdso/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vclock_gettime.c
@@ -13,7 +13,6 @@
 
 #include <uapi/linux/time.h>
 #include <asm/vgtod.h>
-#include <asm/hpet.h>
 #include <asm/vvar.h>
 #include <asm/unistd.h>
 #include <asm/msr.h>
@@ -26,16 +25,6 @@ extern int __vdso_clock_gettime(clockid_
 extern int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
 extern time_t __vdso_time(time_t *t);
 
-#ifdef CONFIG_HPET_TIMER
-extern u8 hpet_page
-	__attribute__((visibility("hidden")));
-
-static notrace cycle_t vread_hpet(void)
-{
-	return *(const volatile u32 *)(&hpet_page + HPET_COUNTER);
-}
-#endif
-
 #ifdef CONFIG_PARAVIRT_CLOCK
 extern u8 pvclock_page
 	__attribute__((visibility("hidden")));
@@ -209,10 +198,6 @@ notrace static inline u64 vgetsns(int *m
 
 	if (gtod->vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
-#ifdef CONFIG_HPET_TIMER
-	else if (gtod->vclock_mode == VCLOCK_HPET)
-		cycles = vread_hpet();
-#endif
 #ifdef CONFIG_PARAVIRT_CLOCK
 	else if (gtod->vclock_mode == VCLOCK_PVCLOCK)
 		cycles = vread_pvclock(mode);
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -25,7 +25,7 @@ SECTIONS
 	 * segment.
 	 */
 
-	vvar_start = . - 3 * PAGE_SIZE;
+	vvar_start = . - 2 * PAGE_SIZE;
 	vvar_page = vvar_start;
 
 	/* Place all vvars at the offsets in asm/vvar.h. */
@@ -35,8 +35,7 @@ SECTIONS
 #undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
-	hpet_page = vvar_start + PAGE_SIZE;
-	pvclock_page = vvar_start + 2 * PAGE_SIZE;
+	pvclock_page = vvar_start + PAGE_SIZE;
 
 	. = SIZEOF_HEADERS;
 
--- a/arch/x86/include/asm/clocksource.h
+++ b/arch/x86/include/asm/clocksource.h
@@ -5,8 +5,7 @@
 
 #define VCLOCK_NONE 0  /* No vDSO clock available.	*/
 #define VCLOCK_TSC  1  /* vDSO should use vread_tsc.	*/
-#define VCLOCK_HPET 2  /* vDSO should use vread_hpet.	*/
-#define VCLOCK_PVCLOCK 3 /* vDSO should use vread_pvclock. */
+#define VCLOCK_PVCLOCK 2 /* vDSO should use vread_pvclock. */
 
 struct arch_clocksource_data {
 	int vclock_mode;
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -774,7 +774,6 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
-	.archdata	= { .vclock_mode = VCLOCK_HPET },
 };
 
 static int hpet_clocksource_register(void)
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -809,8 +809,7 @@ TRACE_EVENT(kvm_write_tsc_offset,
 
 #define host_clocks					\
 	{VCLOCK_NONE, "none"},				\
-	{VCLOCK_TSC,  "tsc"},				\
-	{VCLOCK_HPET, "hpet"}				\
+	{VCLOCK_TSC,  "tsc"}				\
 
 TRACE_EVENT(kvm_update_master_clock,
 	TP_PROTO(bool use_master_clock, unsigned int host_clock, bool offset_matched),


