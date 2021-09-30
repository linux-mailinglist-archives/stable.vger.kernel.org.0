Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC6F41D881
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 13:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350300AbhI3LRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 07:17:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49558 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350266AbhI3LQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 07:16:59 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633000516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IW6qkEuHfTD5sbnBnGmXnQJASYuezgjZNTNLURQvLuk=;
        b=Fm1MBozMWrPkKezNjdr+5m2EdKZF7ouuv6tFP7QGcUBDhEP24VM5KGd6eno5Dvly3B/a/0
        Zfdc9RdSWAesTXXKisswmy0b5eYuU/Vh4OUfkwNjOCthBe83sQ+jvzQjyxoW/Z/DjKlykX
        DIHZ3683WKxprt2NTs1qm4tjCUAM4SHikqRIVyvUrZd9Z8iTdN0DA+1VEI2PKDYGnPj9Ga
        hwl5SgM4YLh5fx14mp6ZYzJCFZ6lYJP8BO6KyKDLh+d9U5Gec7wjDfRInM5L0S3FcvovHX
        BJfqUceCqX4ra2rcVssf90XZsEBwSZZaxCR5aMarTLpgq0kMp1I12z5GdeUIyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633000516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IW6qkEuHfTD5sbnBnGmXnQJASYuezgjZNTNLURQvLuk=;
        b=lH5/tDakESk80A1gJsB2a5+PcFwjllxXxYkHYbErSo9Xdl9gDEpyr8Gc3KblcBifIN/6pb
        9UtPDVgGyXyus7DA==
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        kai.heng.feng@canonical.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, rudolph@fb.com, xapienz@fb.com,
        bmilton@fb.com, paulmck@kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Harry Pan <harry.pan@intel.com>
Subject: [PATCH RFT] x86/hpet: Use another crystalball to evaluate HPET
 usability
In-Reply-To: <87mtnu77mr.ffs@tglx>
References: <20210929160550.GA773748@bhelgaas> <87mtnu77mr.ffs@tglx>
Date:   Thu, 30 Sep 2021 13:15:15 +0200
Message-ID: <87k0iy71rw.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On recent Intel systems the HPET stops working when the system reaches PC10
idle state.

The approach of adding PCI ids to the early quirks to disable HPET on
these systems is a whack a mole game which makes no sense.

Check for PC10 instead and force disable HPET if supported. The check is
overbroad as it does not take ACPI, intel_idle enablement and command
line parameters into account. That's fine as long as there is at least
PMTIMER available to calibrate the TSC frequency. The decision can be
overruled by adding "hpet=force" on the kernel command line.

Remove the related early PCI quirks for affected Ice and Coffin Lake
systems as they are not longer required.

Fixes: Yet another hardware trainwreck
Reported-by: Jakub Kicinski <kuba@kernel.org>
Not-yet-signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
Notes: Completely untested. Use at your own peril.
---
 arch/x86/kernel/early-quirks.c |    6 --
 arch/x86/kernel/hpet.c         |   88 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -714,12 +714,6 @@ static struct chipset early_qrk[] __init
 	 */
 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
-	{ PCI_VENDOR_ID_INTEL, 0x3e20,
-		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
-	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
-		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
-	{ PCI_VENDOR_ID_INTEL, 0x8a12,
-		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
 	{}
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -10,6 +10,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
+#include <asm/mwait.h>
 
 #undef  pr_fmt
 #define pr_fmt(fmt) "hpet: " fmt
@@ -916,6 +917,90 @@ static bool __init hpet_counting(void)
 	return false;
 }
 
+static bool __init get_mwait_substates(unsigned int *mwait_substates)
+{
+	unsigned int eax, ebx, ecx;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return false;
+
+	if (!boot_cpu_has(X86_FEATURE_MWAIT))
+		return false;
+
+	if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+		return false;
+
+	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, mwait_substates);
+
+	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
+	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK) ||
+	    !*mwait_substates)
+		return false;
+
+	return true;
+}
+
+/*
+ * Check whether the system supports PC10. If so force disable HPET as that
+ * stops counting in PC10. This check is overbroad as it does not take any
+ * of the following into account:
+ *
+ *	- ACPI tables
+ *	- Enablement of intel_idle
+ *	- Command line arguments which limit intel_idle C-state support
+ *
+ * That's perfectly fine. HPET is a piece of hardware designed by committee
+ * and the only reasons why it is still in use on modern systems is the
+ * fact that it is impossible to reliably query the TSC frequency via
+ * CPUID or firmware.
+ *
+ * If HPET is functional it is useful for calibrating TSC, but this can be
+ * done via PMTIMER as well which seems to be the last remaining timer on
+ * X86/INTEL platforms that has not been completely wreckaged by feature
+ * creep.
+ *
+ * In theory HPET support should be removed altogether, but there are older
+ * systems out there which depend on it because TSC and APIC timer are
+ * dysfunctional in deeper C-states.
+ *
+ * It's only 20 years now that hardware people have been asked to provide
+ * reliable and discoverable facilities which can be used for timekeeping
+ * and per CPU timer interrupts.
+ *
+ * The probability that this problem is going to be solved in the
+ * forseeable future is close to zero, so the kernel has to be cluttered
+ * with heuristics to keep up with the ever growing amount of hardware and
+ * firmware trainwrecks. Hopefully some day hardware people will understand
+ * that the approach of "This can be fixed in software" is not sustainable.
+ * Hope dies last...
+ */
+static bool __init hpet_is_pc10_damaged(void)
+{
+	unsigned int mwait_substates;
+	unsigned long long pcfg;
+
+	if (!get_mwait_substates(&mwait_substates))
+		return false;
+
+	/* Check whether PC10 substates are supported */
+	if (!(mwait_substates & (0xF << 28)))
+		return false;
+
+	/* Check whether PC10 is enabled in PKG C-state limit */
+	rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
+	if ((pcfg & 0xF) < 8)
+		return false;
+
+	if (hpet_force_user) {
+		pr_warn("HPET force enabled via command line, but dysfunctional in PC10.\n");
+		return false;
+	}
+
+	pr_info("HPET dysfunctional in PC10. Force disabled.\n");
+	boot_hpet_disable = true;
+	return true;
+}
+
 /**
  * hpet_enable - Try to setup the HPET timer. Returns 1 on success.
  */
@@ -929,6 +1014,9 @@ int __init hpet_enable(void)
 	if (!is_hpet_capable())
 		return 0;
 
+	if (hpet_is_pc10_damaged())
+		return 0;
+
 	hpet_set_mapping();
 	if (!hpet_virt_address)
 		return 0;
