Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70807253C76
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 06:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgH0EMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 00:12:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:34840 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgH0EMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 00:12:18 -0400
IronPort-SDR: iQaVEwsY4dn6HK/gP3thlb2m/BgQ0aO3D7E+YK2939VLnxDt/L/YcTi/pppE9SwGEavQXfIQa0
 K2yo3U6xOrgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="174470452"
X-IronPort-AV: E=Sophos;i="5.76,358,1592895600"; 
   d="scan'208";a="174470452"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 21:12:17 -0700
IronPort-SDR: HZmNVwyuAIxVauNRXIn/7F+dvHBCr75jOHxA6PLHK6X5yXwZ5o0yf/AYaT7B6P5wL35V7gZvkp
 rbPBsdsMmS8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,358,1592895600"; 
   d="scan'208";a="313099176"
Received: from otc-nc-03.jf.intel.com ([10.54.39.36])
  by orsmga002.jf.intel.com with ESMTP; 26 Aug 2020 21:12:17 -0700
From:   Ashok Raj <ashok.raj@intel.com>
To:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc:     Ashok Raj <ashok.raj@intel.com>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] x86/hotplug: Silence APIC only after all irq's are migrated
Date:   Wed, 26 Aug 2020 21:12:10 -0700
Message-Id: <1598501530-45821-1-git-send-email-ashok.raj@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a race when taking a CPU offline. Current code looks like this:

native_cpu_disable()
{
	...
	apic_soft_disable();
	/*
	 * Any existing set bits for pending interrupt to
	 * this CPU are preserved and will be sent via IPI
	 * to another CPU by fixup_irqs().
	 */
	cpu_disable_common();
	{
		....
		/*
		 * Race window happens here. Once local APIC has been
		 * disabled any new interrupts from the device to
		 * the old CPU are lost
		 */
		fixup_irqs(); // Too late to capture anything in IRR.
		...
	}
}

The fix is to disable the APIC *after* cpu_disable_common().

Testing was done with a USB NIC that provided a source of frequent
interrupts. A script migrated interrupts to a specific CPU and
then took that CPU offline.

Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
Reported-by: Evan Green <evgreen@chromium.org>
Tested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Evan Green <evgreen@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
---
v3:
    Fix commit message and comments per Thomas.
    https://lore.kernel.org/lkml/87mu2iw86q.fsf@nanos.tec.linutronix.de/

v2:
- Typos and fixes suggested by Randy Dunlap

To: linux-kernel@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sukumar Ghorai <sukumar.ghorai@intel.com>
Cc: Srikanth Nandamuri <srikanth.nandamuri@intel.com>
Cc: Evan Green <evgreen@chromium.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/smpboot.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 27aa04a95702..f5ef689dd62a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1594,14 +1594,28 @@ int native_cpu_disable(void)
 	if (ret)
 		return ret;
 
-	/*
-	 * Disable the local APIC. Otherwise IPI broadcasts will reach
-	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
-	 * messages.
-	 */
-	apic_soft_disable();
 	cpu_disable_common();
 
+        /*
+         * Disable the local APIC. Otherwise IPI broadcasts will reach
+         * it. It still responds normally to INIT, NMI, SMI, and SIPI
+         * messages.
+         *
+         * Disabling the APIC must happen after cpu_disable_common()
+         * which invokes fixup_irqs().
+         *
+         * Disabling the APIC preserves already set bits in IRR, but
+         * an interrupt arriving after disabling the local APIC does not
+         * set the corresponding IRR bit.
+         *
+         * fixup_irqs() scans IRR for set bits so it can raise a not
+         * yet handled interrupt on the new destination CPU via an IPI
+         * but obviously it can't do so for IRR bits which are not set.
+         * IOW, interrupts arriving after disabling the local APIC will
+         * be lost.
+         */
+	apic_soft_disable();
+
 	return 0;
 }
 
-- 
2.7.4

