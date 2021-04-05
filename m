Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB87835402B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240587AbhDEJQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240657AbhDEJQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49A0261393;
        Mon,  5 Apr 2021 09:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614159;
        bh=LHJhRKtGuhAP0AC7zVLtWa1yo3jUXb3KMXbK0V6mqDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/OneMvQraOlSP9ze0TQR0duD08Qz9YcH2iq0psT9XmoPMHNXKsrp4LsgU6dKFCe7
         D818RGp8PTKZsOi76i+phEQ11R6JWB7MBn+Xqs2nbUL4UjvuaSn60iTG5Xat2L6XLt
         pJDBfrDXHYCLsvGogG/U1DfN/lOCcRWx7B0ltHlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 069/152] ACPI: processor: Fix CPU0 wakeup in acpi_idle_play_dead()
Date:   Mon,  5 Apr 2021 10:53:38 +0200
Message-Id: <20210405085036.517059465@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 8cdddd182bd7befae6af49c5fd612893f55d6ccb upstream.

Commit 496121c02127 ("ACPI: processor: idle: Allow probing on platforms
with one ACPI C-state") broke CPU0 hotplug on certain systems, e.g.
I'm observing the following on AWS Nitro (e.g r5b.xlarge but other
instance types are affected as well):

 # echo 0 > /sys/devices/system/cpu/cpu0/online
 # echo 1 > /sys/devices/system/cpu/cpu0/online
 <10 seconds delay>
 -bash: echo: write error: Input/output error

In fact, the above mentioned commit only revealed the problem and did
not introduce it. On x86, to wakeup CPU an NMI is being used and
hlt_play_dead()/mwait_play_dead() loops are prepared to handle it:

	/*
	 * If NMI wants to wake up CPU0, start CPU0.
	 */
	if (wakeup_cpu0())
		start_cpu0();

cpuidle_play_dead() -> acpi_idle_play_dead() (which is now being called on
systems where it wasn't called before the above mentioned commit) serves
the same purpose but it doesn't have a path for CPU0. What happens now on
wakeup is:
 - NMI is sent to CPU0
 - wakeup_cpu0_nmi() works as expected
 - we get back to while (1) loop in acpi_idle_play_dead()
 - safe_halt() puts CPU0 to sleep again.

The straightforward/minimal fix is add the special handling for CPU0 on x86
and that's what the patch is doing.

Fixes: 496121c02127 ("ACPI: processor: idle: Allow probing on platforms with one ACPI C-state")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/smp.h    |    1 +
 arch/x86/kernel/smpboot.c     |    2 +-
 drivers/acpi/processor_idle.c |    7 +++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -132,6 +132,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 int wbinvd_on_all_cpus(void);
+bool wakeup_cpu0(void);
 
 void native_smp_send_reschedule(int cpu);
 void native_send_call_func_ipi(const struct cpumask *mask);
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1659,7 +1659,7 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-static bool wakeup_cpu0(void)
+bool wakeup_cpu0(void)
 {
 	if (smp_processor_id() == 0 && enable_start_cpu0)
 		return true;
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -29,6 +29,7 @@
  */
 #ifdef CONFIG_X86
 #include <asm/apic.h>
+#include <asm/cpu.h>
 #endif
 
 #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
@@ -541,6 +542,12 @@ static int acpi_idle_play_dead(struct cp
 			wait_for_freeze();
 		} else
 			return -ENODEV;
+
+#if defined(CONFIG_X86) && defined(CONFIG_HOTPLUG_CPU)
+		/* If NMI wants to wake up CPU0, start CPU0. */
+		if (wakeup_cpu0())
+			start_cpu0();
+#endif
 	}
 
 	/* Never reached */


