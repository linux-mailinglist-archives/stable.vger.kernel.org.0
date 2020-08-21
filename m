Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F8724C953
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 02:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHUAnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 20:43:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:13401 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgHUAnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 20:43:50 -0400
IronPort-SDR: l+Krjx3gmGtJiaxkYnhcPXnpXlHBjwSL09kTcKT2EdWcGI3xx/Jb2ZHhMLIdPwj5nl2BACj5kh
 9Y2x3ATlvYHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="135493947"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="135493947"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 17:43:49 -0700
IronPort-SDR: FTiIDdAQKsD8qKcl2BYlQooZIX2YO/UqdWEEXsHMIDutfU7Y41+Gch3BzFZ/SVmQv4FfIoK9PY
 5DZ+ASAiTz3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="321082648"
Received: from otc-nc-03.jf.intel.com ([10.54.39.36])
  by fmsmga004.fm.intel.com with ESMTP; 20 Aug 2020 17:43:49 -0700
From:   Ashok Raj <ashok.raj@intel.com>
To:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc:     Ashok Raj <ashok.raj@intel.com>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Subject: [PATCH v2] x86/hotplug: Silence APIC only after all irq's are migrated
Date:   Thu, 20 Aug 2020 17:42:03 -0700
Message-Id: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When offlining CPUs, fixup_irqs() migrates all interrupts away from the
outgoing CPU to an online CPU. It's always possible the device sent an
interrupt to the previous CPU destination. Pending interrupt bit in IRR in
LAPIC identifies such interrupts. apic_soft_disable() will not capture any
new interrupts in IRR. This causes interrupts from device to be lost during
CPU offline. The issue was found when explicitly setting MSI affinity to a
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

Just flipping the above call sequence seems to hit the IRR checks
and the lost interrupt is fixed for both legacy MSI and when
interrupt remapping is enabled.

Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
Reported-by: Evan Green <evgreen@chromium.org>
Tested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Evan Green <evgreen@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
---
v2:
- Typos and fixes suggested by Randy Dunlap

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
index 27aa04a95702..3016c3b627ce 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1594,13 +1594,20 @@ int native_cpu_disable(void)
 	if (ret)
 		return ret;
 
+	cpu_disable_common();
 	/*
 	 * Disable the local APIC. Otherwise IPI broadcasts will reach
 	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
-	 * messages.
+	 * messages. It's important to do apic_soft_disable() after
+	 * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
+	 * depends on IRR being set. After apic_soft_disable() CPU preserves
+	 * currently set IRR/ISR but new interrupts will not set IRR.
+	 * This causes interrupts sent to outgoing CPU before completion
+	 * of IRQ migration to be lost. Check SDM Vol 3 "10.4.7.2 Local
+	 * APIC State after It Has been Software Disabled" section for more
+	 * details.
 	 */
 	apic_soft_disable();
-	cpu_disable_common();
 
 	return 0;
 }
-- 
2.7.4

