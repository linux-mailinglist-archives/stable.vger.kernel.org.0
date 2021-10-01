Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC7F41EC74
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 13:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354110AbhJALrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 07:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353880AbhJALrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 07:47:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C023C061775;
        Fri,  1 Oct 2021 04:45:23 -0700 (PDT)
Date:   Fri, 01 Oct 2021 11:45:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633088721;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=IEIrbFHYsB7VtSDC6yRN5W8FvKTue68QXJpGtCcElrA=;
        b=zjU2Gui3QkgytsOaANlpvbmk3oPyHgM1zWBlYyto3TePuBhLZbX57RYqSrIH5K6F3vCJw0
        8dYY80azORhzbj4bsWQv6ADIDyemIPdgDz/EaVXpC5BjyXX4lm0crNXMUhRKs/8cfaJTfj
        c9shVSbTr6C4Wp4RK3m8C0rYXCuWbDy3/4HrydEnRgb6o0Tm1tfWNG2Ua730Ji9uz2qvlB
        CEdajBb3mu4oV0M8JAhrjryMTZolbE3ZuwwSSwSbLTeiKYIpaxG7BjP1C/7+kxIsJoJGjJ
        Wv+UOZcJIRrTNXmmvDBcspQu09h1+AGzTCqBmQu3j2byMNHXSKgmlfutJpC5Wg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633088721;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=IEIrbFHYsB7VtSDC6yRN5W8FvKTue68QXJpGtCcElrA=;
        b=F2kkN3m3hBEiuq9wJroZjNm0HYnjCwgEvKNVo/yDyAFnjGU0322y1AtJARPPIpfC0MPbUI
        MFUr4cQZ88D4xhDw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/hpet: Use another crystalball to evaluate HPET
 usability
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        "Kai-Heng Feng" <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <163308871989.25758.8858888997266762556.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     6e3cd95234dc1eda488f4f487c281bac8fef4d9b
Gitweb:        https://git.kernel.org/tip/6e3cd95234dc1eda488f4f487c281bac8fef4d9b
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 30 Sep 2021 19:21:39 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 01 Oct 2021 13:38:13 +02:00

x86/hpet: Use another crystalball to evaluate HPET usability

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
---
 arch/x86/kernel/early-quirks.c |  6 +--
 arch/x86/kernel/hpet.c         | 81 +++++++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 38837da..391a4e2 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -714,12 +714,6 @@ static struct chipset early_qrk[] __initdata = {
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
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 42fc41d..882213d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -10,6 +10,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
+#include <asm/mwait.h>
 
 #undef  pr_fmt
 #define pr_fmt(fmt) "hpet: " fmt
@@ -916,6 +917,83 @@ static bool __init hpet_counting(void)
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
@@ -929,6 +1007,9 @@ int __init hpet_enable(void)
 	if (!is_hpet_capable())
 		return 0;
 
+	if (hpet_is_pc10_damaged())
+		return 0;
+
 	hpet_set_mapping();
 	if (!hpet_virt_address)
 		return 0;
