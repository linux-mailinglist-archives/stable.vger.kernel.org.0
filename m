Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26083428EEF
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhJKNxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237300AbhJKNwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 583D360F4B;
        Mon, 11 Oct 2021 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960211;
        bh=AuBVr87Shi6Tg3Fqh1mlcjMeh2zQRTw2nAlNt32fzdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lW+em4Vt/L4sbZRdPUFRusps2TXAJORS/Nm1K/AcvWtlKeSoPAhQWEf1EKLKiKpIu
         ttgWfYm9nZ1KHsG4Lep38lRArO48kxC5IjYmPEo5L50uKjiP6VEwjThLEKdM7tf2kc
         nxsnQJC/XMcSu8llKcRZdvJckw2uyHJduUrntWJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 51/52] x86/hpet: Use another crystalball to evaluate HPET usability
Date:   Mon, 11 Oct 2021 15:46:20 +0200
Message-Id: <20211011134505.483011431@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 6e3cd95234dc1eda488f4f487c281bac8fef4d9b upstream.

On recent Intel systems the HPET stops working when the system reaches PC10
idle state.

The approach of adding PCI ids to the early quirks to disable HPET on
these systems is a whack a mole game which makes no sense.

Check for PC10 instead and force disable HPET if supported. The check is
overbroad as it does not take ACPI, intel_idle enablement and command
line parameters into account. That's fine as long as there is at least
PMTIMER available to calibrate the TSC frequency. The decision can be
overruled by adding "hpet=force" on the kernel command line.

Remove the related early PCI quirks for affected Ice Cake and Coffin Lake
systems as they are not longer required. That should also cover all
other systems, i.e. Tiger Rag and newer generations, which are most
likely affected by this as well.

Fixes: Yet another hardware trainwreck
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: stable@vger.kernel.org
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/early-quirks.c |    6 ---
 arch/x86/kernel/hpet.c         |   81 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -710,12 +710,6 @@ static struct chipset early_qrk[] __init
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
@@ -9,6 +9,7 @@
 
 #include <asm/hpet.h>
 #include <asm/time.h>
+#include <asm/mwait.h>
 
 #undef  pr_fmt
 #define pr_fmt(fmt) "hpet: " fmt
@@ -806,6 +807,83 @@ static bool __init hpet_counting(void)
 	return false;
 }
 
+static bool __init mwait_pc10_supported(void)
+{
+	unsigned int eax, ebx, ecx, mwait_substates;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return false;
+
+	if (!cpu_feature_enabled(X86_FEATURE_MWAIT))
+		return false;
+
+	if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+		return false;
+
+	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &mwait_substates);
+
+	return (ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) &&
+	       (ecx & CPUID5_ECX_INTERRUPT_BREAK) &&
+	       (mwait_substates & (0xF << 28));
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
+ * fact that it is impossible to reliably query TSC and CPU frequency via
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
+	unsigned long long pcfg;
+
+	/* Check whether PC10 substates are supported */
+	if (!mwait_pc10_supported())
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
@@ -819,6 +897,9 @@ int __init hpet_enable(void)
 	if (!is_hpet_capable())
 		return 0;
 
+	if (hpet_is_pc10_damaged())
+		return 0;
+
 	hpet_set_mapping();
 	if (!hpet_virt_address)
 		return 0;


