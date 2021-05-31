Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A509396966
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 23:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhEaVsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 17:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhEaVsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 17:48:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F502C061574;
        Mon, 31 May 2021 14:46:34 -0700 (PDT)
Date:   Mon, 31 May 2021 21:46:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622497592;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k1QRMxPMdJs7dIhHtXk9K5Cv3sI4eP0JKbYnGkBMtLM=;
        b=eE0yIBd/FCoOapr9kjulSKaUTF3r9gzqiKV0cUeXxfnPz16tmWOfFAYjSM/Pf6AW/G/sE3
        kVKbf7+p4oFtQXF+GKape0JJN3UBOIYUJTTbk1eri1J5sq4BydY3MQc0HVyTZMCqQ3WjpT
        lusNNV3OE6H2DEg76SPqE4wiaJW8bRHPwQ7MizE6xNI+EY+pkMFwirhtuhwh4Bxo9Z65pN
        1/5D25NqXqyPHsZdA/1r4doa1kU/2hjt+1meWep+DweHDuKvJDBseSXQj+IX0NP+z4tUlW
        GM0doCpqykkEUm7vXe7IeSs5qS3zeg7ISYDkVzOGpXkyKtHuls8Nx5kbtHO2Ag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622497592;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k1QRMxPMdJs7dIhHtXk9K5Cv3sI4eP0JKbYnGkBMtLM=;
        b=FsOenaTV7y2u5XHdNZn4rMu4Xn/jz+n7+HHZZQKWbxMdmi167vNDCWIr+eU+7VAxyeCV5O
        Fs7aVhk4ZXXX4+Cw==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/thermal: Fix LVT thermal setup for SMI delivery mode
Cc:     James Feeney <james@nurealm.net>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <YKIqDdFNaXYd39wz@zn.tnic>
References: <YKIqDdFNaXYd39wz@zn.tnic>
MIME-Version: 1.0
Message-ID: <162249759127.29796.4985967836065516404.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9a90ed065a155d13db0d0ffeaad5cc54e51c90c6
Gitweb:        https://git.kernel.org/tip/9a90ed065a155d13db0d0ffeaad5cc54e51c90c6
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Thu, 27 May 2021 11:02:26 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 31 May 2021 22:32:26 +02:00

x86/thermal: Fix LVT thermal setup for SMI delivery mode

There are machines out there with added value crap^WBIOS which provide an
SMI handler for the local APIC thermal sensor interrupt. Out of reset,
the BSP on those machines has something like 0x200 in that APIC register
(timestamps left in because this whole issue is timing sensitive):

  [    0.033858] read lvtthmr: 0x330, val: 0x200

which means:

 - bit 16 - the interrupt mask bit is clear and thus that interrupt is enabled
 - bits [10:8] have 010b which means SMI delivery mode.

Now, later during boot, when the kernel programs the local APIC, it
soft-disables it temporarily through the spurious vector register:

  setup_local_APIC:

  	...

	/*
	 * If this comes from kexec/kcrash the APIC might be enabled in
	 * SPIV. Soft disable it before doing further initialization.
	 */
	value = apic_read(APIC_SPIV);
	value &= ~APIC_SPIV_APIC_ENABLED;
	apic_write(APIC_SPIV, value);

which means (from the SDM):

"10.4.7.2 Local APIC State After It Has Been Software Disabled

...

* The mask bits for all the LVT entries are set. Attempts to reset these
bits will be ignored."

And this happens too:

  [    0.124111] APIC: Switch to symmetric I/O mode setup
  [    0.124117] lvtthmr 0x200 before write 0xf to APIC 0xf0
  [    0.124118] lvtthmr 0x10200 after write 0xf to APIC 0xf0

This results in CPU 0 soft lockups depending on the placement in time
when the APIC soft-disable happens. Those soft lockups are not 100%
reproducible and the reason for that can only be speculated as no one
tells you what SMM does. Likely, it confuses the SMM code that the APIC
is disabled and the thermal interrupt doesn't doesn't fire at all,
leading to CPU 0 stuck in SMM forever...

Now, before

  4f432e8bb15b ("x86/mce: Get rid of mcheck_intel_therm_init()")

due to how the APIC_LVTTHMR was read before APIC initialization in
mcheck_intel_therm_init(), it would read the value with the mask bit 16
clear and then intel_init_thermal() would replicate it onto the APs and
all would be peachy - the thermal interrupt would remain enabled.

But that commit moved that reading to a later moment in
intel_init_thermal(), resulting in reading APIC_LVTTHMR on the BSP too
late and with its interrupt mask bit set.

Thus, revert back to the old behavior of reading the thermal LVT
register before the APIC gets initialized.

Fixes: 4f432e8bb15b ("x86/mce: Get rid of mcheck_intel_therm_init()")
Reported-by: James Feeney <james@nurealm.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lkml.kernel.org/r/YKIqDdFNaXYd39wz@zn.tnic
---
 arch/x86/include/asm/thermal.h      |  4 +++-
 arch/x86/kernel/setup.c             |  9 +++++++++
 drivers/thermal/intel/therm_throt.c | 15 +++++++++++----
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/thermal.h b/arch/x86/include/asm/thermal.h
index ddbdefd..91a7b66 100644
--- a/arch/x86/include/asm/thermal.h
+++ b/arch/x86/include/asm/thermal.h
@@ -3,11 +3,13 @@
 #define _ASM_X86_THERMAL_H
 
 #ifdef CONFIG_X86_THERMAL_VECTOR
+void therm_lvt_init(void);
 void intel_init_thermal(struct cpuinfo_x86 *c);
 bool x86_thermal_enabled(void);
 void intel_thermal_interrupt(void);
 #else
-static inline void intel_init_thermal(struct cpuinfo_x86 *c) { }
+static inline void therm_lvt_init(void)				{ }
+static inline void intel_init_thermal(struct cpuinfo_x86 *c)	{ }
 #endif
 
 #endif /* _ASM_X86_THERMAL_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 72920af..ff653d6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -44,6 +44,7 @@
 #include <asm/pci-direct.h>
 #include <asm/prom.h>
 #include <asm/proto.h>
+#include <asm/thermal.h>
 #include <asm/unwind.h>
 #include <asm/vsyscall.h>
 #include <linux/vmalloc.h>
@@ -1226,6 +1227,14 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.timers.wallclock_init();
 
+	/*
+	 * This needs to run before setup_local_APIC() which soft-disables the
+	 * local APIC temporarily and that masks the thermal LVT interrupt,
+	 * leading to softlockups on machines which have configured SMI
+	 * interrupt delivery.
+	 */
+	therm_lvt_init();
+
 	mcheck_init();
 
 	register_refined_jiffies(CLOCK_TICK_RATE);
diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index f8e8825..99abdc0 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -621,6 +621,17 @@ bool x86_thermal_enabled(void)
 	return atomic_read(&therm_throt_en);
 }
 
+void __init therm_lvt_init(void)
+{
+	/*
+	 * This function is only called on boot CPU. Save the init thermal
+	 * LVT value on BSP and use that value to restore APs' thermal LVT
+	 * entry BIOS programmed later
+	 */
+	if (intel_thermal_supported(&boot_cpu_data))
+		lvtthmr_init = apic_read(APIC_LVTTHMR);
+}
+
 void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
@@ -630,10 +641,6 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	if (!intel_thermal_supported(c))
 		return;
 
-	/* On the BSP? */
-	if (c == &boot_cpu_data)
-		lvtthmr_init = apic_read(APIC_LVTTHMR);
-
 	/*
 	 * First check if its enabled already, in which case there might
 	 * be some SMM goo which handles it, so we can't even put a handler
