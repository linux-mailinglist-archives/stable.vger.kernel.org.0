Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34A29C5C5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507791AbgJ0OMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756286AbgJ0OMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:12:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D1B2072D;
        Tue, 27 Oct 2020 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807942;
        bh=4pX0BR1UIDlD908n4yjDJ5oQB1DiZsAQZb7GrHxAgoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CL7xOCZRtrscHOsxcrdZm8GX9yh9FtofHf6hbXZJ/IPCfDdrqnAn2ygWm5S4v6cgA
         Avi7LLr2eYotP0QC0QG0mJunEuhV167MA08gARaARzSJFXLxghfod+m4zc/0PLA09x
         stzbAd6cZ+CKADqYiskx/rY/4ZVoS+ulv57WDIuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/191] powerpc/tau: Disable TAU between measurements
Date:   Tue, 27 Oct 2020 14:49:12 +0100
Message-Id: <20201027134914.362253049@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit e63d6fb5637e92725cf143559672a34b706bca4f ]

Enabling CONFIG_TAU_INT causes random crashes:

Unrecoverable exception 1700 at c0009414 (msr=1000)
Oops: Unrecoverable exception, sig: 6 [#1]
BE PAGE_SIZE=4K MMU=Hash SMP NR_CPUS=2 PowerMac
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.7.0-pmac-00043-gd5f545e1a8593 #5
NIP:  c0009414 LR: c0009414 CTR: c00116fc
REGS: c0799eb8 TRAP: 1700   Not tainted  (5.7.0-pmac-00043-gd5f545e1a8593)
MSR:  00001000 <ME>  CR: 22000228  XER: 00000100

GPR00: 00000000 c0799f70 c076e300 00800000 0291c0ac 00e00000 c076e300 00049032
GPR08: 00000001 c00116fc 00000000 dfbd3200 ffffffff 007f80a8 00000000 00000000
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 c075ce04
GPR24: c075ce04 dfff8880 c07b0000 c075ce04 00080000 00000001 c079ef98 c079ef5c
NIP [c0009414] arch_cpu_idle+0x24/0x6c
LR [c0009414] arch_cpu_idle+0x24/0x6c
Call Trace:
[c0799f70] [00000001] 0x1 (unreliable)
[c0799f80] [c0060990] do_idle+0xd8/0x17c
[c0799fa0] [c0060ba4] cpu_startup_entry+0x20/0x28
[c0799fb0] [c072d220] start_kernel+0x434/0x44c
[c0799ff0] [00003860] 0x3860
Instruction dump:
XXXXXXXX XXXXXXXX XXXXXXXX 3d20c07b XXXXXXXX XXXXXXXX XXXXXXXX 7c0802a6
XXXXXXXX XXXXXXXX XXXXXXXX 4e800421 XXXXXXXX XXXXXXXX XXXXXXXX 7d2000a6
---[ end trace 3a0c9b5cb216db6b ]---

Resolve this problem by disabling each THRMn comparator when handling
the associated THRMn interrupt and by disabling the TAU entirely when
updating THRMn thresholds.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5a0ba3dc5612c7aac596727331284a3676c08472.1599260540.git.fthain@telegraphics.com.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/tau_6xx.c  | 65 +++++++++++++---------------------
 arch/powerpc/platforms/Kconfig |  9 ++---
 2 files changed, 26 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/kernel/tau_6xx.c b/arch/powerpc/kernel/tau_6xx.c
index 9e8b709a2aae4..2615cd66dad84 100644
--- a/arch/powerpc/kernel/tau_6xx.c
+++ b/arch/powerpc/kernel/tau_6xx.c
@@ -38,8 +38,6 @@ static struct tau_temp
 
 struct timer_list tau_timer;
 
-#undef DEBUG
-
 /* TODO: put these in a /proc interface, with some sanity checks, and maybe
  * dynamic adjustment to minimize # of interrupts */
 /* configurable values for step size and how much to expand the window when
@@ -72,42 +70,33 @@ void set_thresholds(unsigned long cpu)
 
 void TAUupdate(int cpu)
 {
-	unsigned thrm;
-
-#ifdef DEBUG
-	printk("TAUupdate ");
-#endif
+	u32 thrm;
+	u32 bits = THRM1_TIV | THRM1_TIN | THRM1_V;
 
 	/* if both thresholds are crossed, the step_sizes cancel out
 	 * and the window winds up getting expanded twice. */
-	if((thrm = mfspr(SPRN_THRM1)) & THRM1_TIV){ /* is valid? */
-		if(thrm & THRM1_TIN){ /* crossed low threshold */
-			if (tau[cpu].low >= step_size){
-				tau[cpu].low -= step_size;
-				tau[cpu].high -= (step_size - window_expand);
-			}
-			tau[cpu].grew = 1;
-#ifdef DEBUG
-			printk("low threshold crossed ");
-#endif
+	thrm = mfspr(SPRN_THRM1);
+	if ((thrm & bits) == bits) {
+		mtspr(SPRN_THRM1, 0);
+
+		if (tau[cpu].low >= step_size) {
+			tau[cpu].low -= step_size;
+			tau[cpu].high -= (step_size - window_expand);
 		}
+		tau[cpu].grew = 1;
+		pr_debug("%s: low threshold crossed\n", __func__);
 	}
-	if((thrm = mfspr(SPRN_THRM2)) & THRM1_TIV){ /* is valid? */
-		if(thrm & THRM1_TIN){ /* crossed high threshold */
-			if (tau[cpu].high <= 127-step_size){
-				tau[cpu].low += (step_size - window_expand);
-				tau[cpu].high += step_size;
-			}
-			tau[cpu].grew = 1;
-#ifdef DEBUG
-			printk("high threshold crossed ");
-#endif
+	thrm = mfspr(SPRN_THRM2);
+	if ((thrm & bits) == bits) {
+		mtspr(SPRN_THRM2, 0);
+
+		if (tau[cpu].high <= 127 - step_size) {
+			tau[cpu].low += (step_size - window_expand);
+			tau[cpu].high += step_size;
 		}
+		tau[cpu].grew = 1;
+		pr_debug("%s: high threshold crossed\n", __func__);
 	}
-
-#ifdef DEBUG
-	printk("grew = %d\n", tau[cpu].grew);
-#endif
 }
 
 #ifdef CONFIG_TAU_INT
@@ -132,18 +121,18 @@ void TAUException(struct pt_regs * regs)
 static void tau_timeout(void * info)
 {
 	int cpu;
-	unsigned long flags;
 	int size;
 	int shrink;
 
-	/* disabling interrupts *should* be okay */
-	local_irq_save(flags);
 	cpu = smp_processor_id();
 
 #ifndef CONFIG_TAU_INT
 	TAUupdate(cpu);
 #endif
 
+	/* Stop thermal sensor comparisons and interrupts */
+	mtspr(SPRN_THRM3, 0);
+
 	size = tau[cpu].high - tau[cpu].low;
 	if (size > min_window && ! tau[cpu].grew) {
 		/* do an exponential shrink of half the amount currently over size */
@@ -165,18 +154,12 @@ static void tau_timeout(void * info)
 
 	set_thresholds(cpu);
 
-	/*
-	 * Do the enable every time, since otherwise a bunch of (relatively)
-	 * complex sleep code needs to be added. One mtspr every time
-	 * tau_timeout is called is probably not a big deal.
-	 *
+	/* Restart thermal sensor comparisons and interrupts.
 	 * The "PowerPC 740 and PowerPC 750 Microprocessor Datasheet"
 	 * recommends that "the maximum value be set in THRM3 under all
 	 * conditions."
 	 */
 	mtspr(SPRN_THRM3, THRM3_SITV(0x1fff) | THRM3_E);
-
-	local_irq_restore(flags);
 }
 
 static void tau_timeout_smp(unsigned long unused)
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index d5e34ce5fd5d9..e06ccba351330 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -243,7 +243,7 @@ config TAU
 	  temp is actually what /proc/cpuinfo says it is.
 
 config TAU_INT
-	bool "Interrupt driven TAU driver (DANGEROUS)"
+	bool "Interrupt driven TAU driver (EXPERIMENTAL)"
 	depends on TAU
 	---help---
 	  The TAU supports an interrupt driven mode which causes an interrupt
@@ -251,12 +251,7 @@ config TAU_INT
 	  to get notified the temp has exceeded a range. With this option off,
 	  a timer is used to re-check the temperature periodically.
 
-	  However, on some cpus it appears that the TAU interrupt hardware
-	  is buggy and can cause a situation which would lead unexplained hard
-	  lockups.
-
-	  Unless you are extending the TAU driver, or enjoy kernel/hardware
-	  debugging, leave this option off.
+	  If in doubt, say N here.
 
 config TAU_AVERAGE
 	bool "Average high and low temp"
-- 
2.25.1



