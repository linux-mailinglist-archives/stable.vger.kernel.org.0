Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3BB2171DE
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgGGP01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728869AbgGGP0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA5B220663;
        Tue,  7 Jul 2020 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135584;
        bh=hcARAQi8ypLXq9FRLf2KdIrI8ycMTzItFzTbgDX+B2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nf+RQvIBKdAk2XzVs4iAjiYuRnSEH3uj3Bv5+dI+hDIJyj34WdENIBJINJRM00d+x
         KqlXjBRUpAFEEn0SAvfOtLppVNp9NywdtbRfdO3zvo7CEVMR8OWb0TDHNRjR9pHE0B
         MUrMXZRTaCkT8p3y/h397bfcE1jn2vtonWjhwfsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.7 099/112] x86/split_lock: Dont write MSR_TEST_CTRL on CPUs that arent whitelisted
Date:   Tue,  7 Jul 2020 17:17:44 +0200
Message-Id: <20200707145805.686653891@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 009bce1df0bb5eb970b9eb98d963861f7fe353c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -49,6 +49,13 @@ static enum split_lock_detect_state sld_
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
@@ -1064,7 +1071,8 @@ static void sld_update_msr(bool on)
 
 static void split_lock_init(void)
 {
-	split_lock_verify_msr(sld_state != sld_off);
+	if (cpu_model_supports_sld)
+		split_lock_verify_msr(sld_state != sld_off);
 }
 
 static void split_lock_warn(unsigned long ip)
@@ -1167,5 +1175,6 @@ void __init cpu_set_core_cap_bits(struct
 		return;
 	}
 
+	cpu_model_supports_sld = true;
 	split_lock_setup();
 }


