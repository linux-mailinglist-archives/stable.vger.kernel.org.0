Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA14749351
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbfFQV3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbfFQV3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:29:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9096F2070B;
        Mon, 17 Jun 2019 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806990;
        bh=uFoyq3kvcDsAZmt6jvzusQXoikeYE3A01lol6c2UdoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbBrJcGBJzBalNyAkFBb9hQA8uZ/pd8M2GWcrO3V62HBaA/rW2CDGHFC6VWE9KKLG
         6w8CcPlexEGfOFjknF7XLLp8dk3JgKfyn1sryrIEPW+F6x6rFCrsbpLw9j9kypn5Jz
         N8vOlM+4EJJcJ4HcQw7UZgjqKfeVzU2SYPI4FObU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adric Blake <promarbler14@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: [PATCH 4.14 51/53] x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback
Date:   Mon, 17 Jun 2019 23:10:34 +0200
Message-Id: <20190617210752.600204681@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 78f4e932f7760d965fb1569025d1576ab77557c5 upstream.

Adric Blake reported the following warning during suspend-resume:

  Enabling non-boot CPUs ...
  x86: Booting SMP configuration:
  smpboot: Booting Node 0 Processor 1 APIC 0x2
  unchecked MSR access error: WRMSR to 0x10f (tried to write 0x0000000000000000) \
   at rIP: 0xffffffff8d267924 (native_write_msr+0x4/0x20)
  Call Trace:
   intel_set_tfa
   intel_pmu_cpu_starting
   ? x86_pmu_dead_cpu
   x86_pmu_starting_cpu
   cpuhp_invoke_callback
   ? _raw_spin_lock_irqsave
   notify_cpu_starting
   start_secondary
   secondary_startup_64
  microcode: sig=0x806ea, pf=0x80, revision=0x96
  microcode: updated to revision 0xb4, date = 2019-04-01
  CPU1 is up

The MSR in question is MSR_TFA_RTM_FORCE_ABORT and that MSR is emulated
by microcode. The log above shows that the microcode loader callback
happens after the PMU restoration, leading to the conjecture that
because the microcode hasn't been updated yet, that MSR is not present
yet, leading to the #GP.

Add a microcode loader-specific hotplug vector which comes before
the PERF vectors and thus executes earlier and makes sure the MSR is
present.

Fixes: 400816f60c54 ("perf/x86/intel: Implement support for TSX Force Abort")
Reported-by: Adric Blake <promarbler14@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: x86@kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203637
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/microcode/core.c |    2 +-
 include/linux/cpuhotplug.h           |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -873,7 +873,7 @@ int __init microcode_init(void)
 		goto out_ucode_group;
 
 	register_syscore_ops(&mc_syscore_ops);
-	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/microcode:online",
+	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:online",
 				  mc_cpu_online, mc_cpu_down_prep);
 
 	pr_info("Microcode Update Driver: v%s.", DRIVER_VERSION);
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -100,6 +100,7 @@ enum cpuhp_state {
 	CPUHP_AP_IRQ_ARMADA_XP_STARTING,
 	CPUHP_AP_IRQ_BCM2836_STARTING,
 	CPUHP_AP_ARM_MVEBU_COHERENCY,
+	CPUHP_AP_MICROCODE_LOADER,
 	CPUHP_AP_PERF_X86_AMD_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
 	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,


