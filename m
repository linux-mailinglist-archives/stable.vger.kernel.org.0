Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C45220F431
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 14:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387467AbgF3MMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 08:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387465AbgF3MMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 08:12:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC55DC061755
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 05:12:07 -0700 (PDT)
Date:   Tue, 30 Jun 2020 12:12:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1593519121;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQofTU652nzi7btAijaCF/NR0FRitK1IWHgv5m5mego=;
        b=VesSUYvpG+xeiFU+CjPj2iqz+cvPvN7MLRhZriIa9gXmuuqbkufLcFaApkIKns4IwO1MDF
        Ry+u/qDyQR21WCid7ilj4paRTHUkp8REeNlpKYwy6g/bPwtL6LHKU38qnZxOhQhp1EipCl
        zSlGh0TUtmn4EAXe1f11aaLNTmy/d9bhL9flO8DRK4MMsjp3lMlrGxgyLKRkNfaZ2u+R6D
        JhiesgXgF6xLrPVoMMTcskLPpJ+OoH7E+tToVqlfShi7Q5W/eWauw9v7kAg2Uxwj7zd7Ui
        /c56DvagosBVNb+AVmPeWDgG7BeILPrvavLXC1tlMM9tQiZbDT3vpAL1HdHSKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1593519121;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQofTU652nzi7btAijaCF/NR0FRitK1IWHgv5m5mego=;
        b=Uj5+au7XvfZKfsjTst8iYX5redM5PeOmIL4CsqeNPXW0UNQCN4BlPHT8bGO8azFpcKx4ni
        LZ91jf4vEZplUHCg==
From:   "tip-bot2 for Sean Christopherson" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/split_lock: Don't write MSR_TEST_CTRL on CPUs
 that aren't whitelisted
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200605192605.7439-1-sean.j.christopherson@intel.com>
References: <20200605192605.7439-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Message-ID: <159351912091.4006.8957636138691015363.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     009bce1df0bb5eb970b9eb98d963861f7fe353c7
Gitweb:        https://git.kernel.org/tip/009bce1df0bb5eb970b9eb98d963861f7fe353c7
Author:        Sean Christopherson <sean.j.christopherson@intel.com>
AuthorDate:    Fri, 05 Jun 2020 12:26:05 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 30 Jun 2020 14:09:31 +02:00

x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that aren't whitelisted

Choo! Choo!  All aboard the Split Lock Express, with direct service to
Wreckage!

Skip split_lock_verify_msr() if the CPU isn't whitelisted as a possible
SLD-enabled CPU model to avoid writing MSR_TEST_CTRL.  MSR_TEST_CTRL
exists, and is writable, on many generations of CPUs.  Writing the MSR,
even with '0', can result in bizarre, undocumented behavior.

This fixes a crash on Haswell when resuming from suspend with a live KVM
guest.  Because APs use the standard SMP boot flow for resume, they will
go through split_lock_init() and the subsequent RDMSR/WRMSR sequence,
which runs even when sld_state==sld_off to ensure SLD is disabled.  On
Haswell (at least, my Haswell), writing MSR_TEST_CTRL with '0' will
succeed and _may_ take the SMT _sibling_ out of VMX root mode.

When KVM has an active guest, KVM performs VMXON as part of CPU onlining
(see kvm_starting_cpu()).  Because SMP boot is serialized, the resulting
flow is effectively:

  on_each_ap_cpu() {
     WRMSR(MSR_TEST_CTRL, 0)
     VMXON
  }

As a result, the WRMSR can disable VMX on a different CPU that has
already done VMXON.  This ultimately results in a #UD on VMPTRLD when
KVM regains control and attempt run its vCPUs.

The above voodoo was confirmed by reworking KVM's VMXON flow to write
MSR_TEST_CTRL prior to VMXON, and to serialize the sequence as above.
Further verification of the insanity was done by redoing VMXON on all
APs after the initial WRMSR->VMXON sequence.  The additional VMXON,
which should VM-Fail, occasionally succeeded, and also eliminated the
unexpected #UD on VMPTRLD.

The damage done by writing MSR_TEST_CTRL doesn't appear to be limited
to VMX, e.g. after suspend with an active KVM guest, subsequent reboots
almost always hang (even when fudging VMXON), a #UD on a random Jcc was
observed, suspend/resume stability is qualitatively poor, and so on and
so forth.

  kernel BUG at arch/x86/kvm/x86.c:386!
  CPU: 1 PID: 2592 Comm: CPU 6/KVM Tainted: G      D
  Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
  RIP: 0010:kvm_spurious_fault+0xf/0x20
  Call Trace:
   vmx_vcpu_load_vmcs+0x1fb/0x2b0
   vmx_vcpu_load+0x3e/0x160
   kvm_arch_vcpu_load+0x48/0x260
   finish_task_switch+0x140/0x260
   __schedule+0x460/0x720
   _cond_resched+0x2d/0x40
   kvm_arch_vcpu_ioctl_run+0x82e/0x1ca0
   kvm_vcpu_ioctl+0x363/0x5c0
   ksys_ioctl+0x88/0xa0
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x4c/0x170
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: dbaba47085b0c ("x86/split_lock: Rework the initialization flow of split lock detection")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200605192605.7439-1-sean.j.christopherson@intel.com

---
 arch/x86/kernel/cpu/intel.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index c25a67a..0ab48f1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -50,6 +50,13 @@ static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
 static u64 msr_test_ctrl_cache __ro_after_init;
 
 /*
+ * With a name like MSR_TEST_CTL it should go without saying, but don't touch
+ * MSR_TEST_CTL unless the CPU is one of the whitelisted models.  Writing it
+ * on CPUs that do not support SLD can cause fireworks, even when writing '0'.
+ */
+static bool cpu_model_supports_sld __ro_after_init;
+
+/*
  * Processors which have self-snooping capability can handle conflicting
  * memory type across CPUs by snooping its own cache. However, there exists
  * CPU models in which having conflicting memory types still leads to
@@ -1071,7 +1078,8 @@ static void sld_update_msr(bool on)
 
 static void split_lock_init(void)
 {
-	split_lock_verify_msr(sld_state != sld_off);
+	if (cpu_model_supports_sld)
+		split_lock_verify_msr(sld_state != sld_off);
 }
 
 static void split_lock_warn(unsigned long ip)
@@ -1177,5 +1185,6 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 		return;
 	}
 
+	cpu_model_supports_sld = true;
 	split_lock_setup();
 }
