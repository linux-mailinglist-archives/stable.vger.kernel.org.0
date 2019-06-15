Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1861246EEA
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 10:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfFOIHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 04:07:37 -0400
Received: from terminus.zytor.com ([198.137.202.136]:60541 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFOIHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 04:07:36 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x5F87EqD2124801
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 15 Jun 2019 01:07:14 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5F87EqD2124801
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019051801; t=1560586034;
        bh=t4szRZJ/Jp2WKsreyuqr5PeHRJ/BtR1btsV1LVCWcIA=;
        h=Date:From:Cc:Reply-To:To:Subject:From;
        b=LS3jxdLzhc1ZRj/hS/ve0Ei0qrmNnKeOWrjOf426Pc0cFX6zgcX7CljDk26Bg0Xoq
         dKs6OvwJVZEu9USZbN9u8qDY/aMKJLGrgj1nMCK69yfuePi+9JqpUMXozs/6cukR7E
         M+6LX71x/BQQAiaajHlPyep9zXBy7Bgvd/ZdnBkItbv0pavtjZmBj1o5Xyx9Rq84Tq
         CN1IdX3S66uyuZGm6zMdApC/xg1Pxcp58iG6VcEeNDa06wCfSsaIW5XR3jaurb1vAc
         wrn+L9SSFUUienZ2+bS6ikfsvsR9uVNm+nPLyK+gyi+ewV5h4WsKYRLFti2d5sBS80
         g0MEIRFBep+Ug==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x5F87Cmw2124795;
        Sat, 15 Jun 2019 01:07:12 -0700
Date:   Sat, 15 Jun 2019 01:07:12 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-78f4e932f7760d965fb1569025d1576ab77557c5@git.kernel.org>
Cc:     stable@vger.kernel.org, promarbler14@gmail.com, hpa@zytor.com,
        mingo@kernel.org, bp@suse.de, tglx@linutronix.de,
        peterz@infradead.org
Reply-To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
          promarbler14@gmail.com, hpa@zytor.com, mingo@kernel.org,
          bp@suse.de, tglx@linutronix.de, peterz@infradead.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/microcode, cpuhotplug: Add a microcode loader
 CPU hotplug callback
Git-Commit-ID: 78f4e932f7760d965fb1569025d1576ab77557c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-0.7 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        T_DATE_IN_FUTURE_96_Q autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  78f4e932f7760d965fb1569025d1576ab77557c5
Gitweb:     https://git.kernel.org/tip/78f4e932f7760d965fb1569025d1576ab77557c5
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Thu, 13 Jun 2019 15:49:02 +0200
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Sat, 15 Jun 2019 10:00:29 +0200

x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback

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
---
 arch/x86/kernel/cpu/microcode/core.c | 2 +-
 include/linux/cpuhotplug.h           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 70a04436380e..a813987b5552 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -872,7 +872,7 @@ int __init microcode_init(void)
 		goto out_ucode_group;
 
 	register_syscore_ops(&mc_syscore_ops);
-	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/microcode:online",
+	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:online",
 				  mc_cpu_online, mc_cpu_down_prep);
 
 	pr_info("Microcode Update Driver: v%s.", DRIVER_VERSION);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 6a381594608c..5c6062206760 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -101,6 +101,7 @@ enum cpuhp_state {
 	CPUHP_AP_IRQ_BCM2836_STARTING,
 	CPUHP_AP_IRQ_MIPS_GIC_STARTING,
 	CPUHP_AP_ARM_MVEBU_COHERENCY,
+	CPUHP_AP_MICROCODE_LOADER,
 	CPUHP_AP_PERF_X86_AMD_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
 	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
