Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D36244F95
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 23:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHNViz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 17:38:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:24480 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgHNViz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Aug 2020 17:38:55 -0400
IronPort-SDR: 3QlMHMzX3e3ZrdBau7hrK2KAZm6L+RlKSVg63axxZlrGBB7/v4DrjY5NXMRJcxyD3GEI6umuRE
 DD5Fhv/HilZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="216014790"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="216014790"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 14:38:52 -0700
IronPort-SDR: m1BxrBUKmO585g+Pmj3RtcKmI9FmAd+SQNenfVmglsMbkS+66xuNfqYODuRTqIFyJuzOmAqO+9
 wO/Vv3/AaO1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="470717445"
Received: from araj-mobl1.jf.intel.com ([10.254.120.157])
  by orsmga005.jf.intel.com with ESMTP; 14 Aug 2020 14:38:50 -0700
From:   Ashok Raj <ashok.raj@intel.com>
To:     linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc:     Ashok Raj <ashok.raj@intel.com>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Subject: [PATCH] x86/hotplug: Silence APIC only after all irq's are migrated
Date:   Fri, 14 Aug 2020 14:38:42 -0700
Message-Id: <20200814213842.31151-1-ashok.raj@intel.com>
X-Mailer: git-send-email 2.13.6
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When offlining CPU's, fixup_irqs() migrates all interrupts away from the
outgoing CPU to an online CPU. Its always possible the device sent an
interrupt to the previous CPU destination. Pending interrupt bit in IRR in
lapic identifies such interrupts. apic_soft_disable() will not capture any
new interrupts in IRR. This causes interrupts from device to be lost during
cpu offline. The issue was found when explicitly setting MSI affinity to a
CPU and immediately offlining it. It was simple to recreate with a USB
ethernet device and doing I/O to it while the CPU is offlined. Lost
interrupts happen even when Interrupt Remapping is enabled.

Current code does apic_soft_disable() before migrating interrupts.

native_cpu_disable()
{
	...
	apic_soft_disable();
	cpu_disable_common();
	  --> fixup_irqs(); // Too late to capture anything in IRR.
}

Just fliping the above call sequence seems to hit the IRR checks
and the lost interrupt is fixed for both legacy MSI and when
interrupt remapping is enabled.


Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
Signed-off-by: Ashok Raj <ashok.raj@intel.com>

To: linux-kernel@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sukumar Ghorai <sukumar.ghorai@intel.com>
Cc: Srikanth Nandamuri <srikanth.nandamuri@intel.com>
Cc: Evan Green <evgreen@chromium.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/smpboot.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ffbd9a3d78d8..278cc9f92f2f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1603,13 +1603,20 @@ int native_cpu_disable(void)
 	if (ret)
 		return ret;
 
+	cpu_disable_common();
 	/*
 	 * Disable the local APIC. Otherwise IPI broadcasts will reach
 	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
-	 * messages.
+	 * messages. Its important to do apic_soft_disable() after
+	 * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
+	 * depends on IRR being set. After apic_soft_disable() CPU preserves
+	 * currently set IRR/ISR but new interrupts will not set IRR.
+	 * This causes interrupts sent to outgoing cpu before completion
+	 * of irq migration to be lost. Check SDM Vol 3 "10.4.7.2 Local
+	 * APIC State after It Has been Software Disabled" section for more
+	 * details.
 	 */
 	apic_soft_disable();
-	cpu_disable_common();
 
 	return 0;
 }
-- 
2.13.6

