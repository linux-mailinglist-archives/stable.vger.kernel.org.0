Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4103A038B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhFHTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236281AbhFHTQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DC5A6195C;
        Tue,  8 Jun 2021 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178263;
        bh=gE52k/E7YkBeezIjTARd346XAL1t1SFknehX2+IJJTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTyzaB4U7DxP1AojoTUItYGtyCDmteHHn9g9lalf+wxPQ8r2D9LqMPeZhaOseaguj
         RgmT/DqY5OYbdHDDPn81/0H5iwZVB/w4UJzw2yv84YNKw39xEN3comRvmSXIipjISK
         /a5kQ5VwtF4bF9PL0IH3TkJtsYvMsTXLpwpcxGGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Feeney <james@nurealm.net>,
        Borislav Petkov <bp@suse.de>, Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [PATCH 5.12 138/161] x86/thermal: Fix LVT thermal setup for SMI delivery mode
Date:   Tue,  8 Jun 2021 20:27:48 +0200
Message-Id: <20210608175950.109625741@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 9a90ed065a155d13db0d0ffeaad5cc54e51c90c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/thermal.h      |    4 +++-
 arch/x86/kernel/setup.c             |    9 +++++++++
 drivers/thermal/intel/therm_throt.c |   15 +++++++++++----
 3 files changed, 23 insertions(+), 5 deletions(-)

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
@@ -1220,6 +1221,14 @@ void __init setup_arch(char **cmdline_p)
 
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
@@ -630,10 +641,6 @@ void intel_init_thermal(struct cpuinfo_x
 	if (!intel_thermal_supported(c))
 		return;
 
-	/* On the BSP? */
-	if (c == &boot_cpu_data)
-		lvtthmr_init = apic_read(APIC_LVTTHMR);
-
 	/*
 	 * First check if its enabled already, in which case there might
 	 * be some SMM goo which handles it, so we can't even put a handler


