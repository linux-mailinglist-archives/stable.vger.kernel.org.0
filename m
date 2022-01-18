Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932684920C3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 08:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245546AbiARH7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 02:59:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60342 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbiARH7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 02:59:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E08A9613F1
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F35C00446;
        Tue, 18 Jan 2022 07:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642492744;
        bh=0HVhNX3h+U1zJCJ02BfU+sylguJJkWQkhhrUVqN6i2k=;
        h=Subject:To:Cc:From:Date:From;
        b=RCsw/4yHOcs2OH7o+2/EfEjzjPuFKR80G+8o0dIDIcmiNML7g+0nXaIBDGVpyxyG1
         DlE5gQnBFBFGRDqv0avoPNvn9+t+40DziOgNuc8uaCXC5r3Q/MZDbVxlcagpfTuIOh
         9iro4fw9ttkVgDV9qXJah2Aea4B948+CzRl2jTfM=
Subject: FAILED: patch "[PATCH] KVM: s390: Clarify SIGP orders versus STOP/RESTART" failed to apply to 4.4-stable tree
To:     farman@linux.ibm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 08:59:01 +0100
Message-ID: <164249274124147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 812de04661c4daa7ac385c0dfd62594540538034 Mon Sep 17 00:00:00 2001
From: Eric Farman <farman@linux.ibm.com>
Date: Mon, 13 Dec 2021 22:05:50 +0100
Subject: [PATCH] KVM: s390: Clarify SIGP orders versus STOP/RESTART

With KVM_CAP_S390_USER_SIGP, there are only five Signal Processor
orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL, EXTERNAL CALL,
SENSE, and SENSE RUNNING STATUS) which are intended for frequent use
and thus are processed in-kernel. The remainder are sent to userspace
with the KVM_CAP_S390_USER_SIGP capability. Of those, three orders
(RESTART, STOP, and STOP AND STORE STATUS) have the potential to
inject work back into the kernel, and thus are asynchronous.

Let's look for those pending IRQs when processing one of the in-kernel
SIGP orders, and return BUSY (CC2) if one is in process. This is in
agreement with the Principles of Operation, which states that only one
order can be "active" on a CPU at a time.

Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20211213210550.856213-2-farman@linux.ibm.com
[borntraeger@linux.ibm.com: add stable tag]
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c3bd993fdd0c..0576d5c99138 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2115,6 +2115,13 @@ int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu)
 	return test_bit(IRQ_PEND_SIGP_STOP, &li->pending_irqs);
 }
 
+int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+
+	return test_bit(IRQ_PEND_RESTART, &li->pending_irqs);
+}
+
 void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 14a18ba5ff2c..ef299aad4009 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4645,10 +4645,15 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	/* SIGP STOP and SIGP STOP AND STORE STATUS has been fully processed */
+	/*
+	 * Set the VCPU to STOPPED and THEN clear the interrupt flag,
+	 * now that the SIGP STOP and SIGP STOP AND STORE STATUS orders
+	 * have been fully processed. This will ensure that the VCPU
+	 * is kept BUSY if another VCPU is inquiring with SIGP SENSE.
+	 */
+	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
 	kvm_s390_clear_stop_irq(vcpu);
 
-	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
 	__disable_ibs_on_vcpu(vcpu);
 
 	for (i = 0; i < online_vcpus; i++) {
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c07a050d757d..1876ab0c293f 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -427,6 +427,7 @@ void kvm_s390_destroy_adapters(struct kvm *kvm);
 int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu);
 extern struct kvm_device_ops kvm_flic_ops;
 int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu);
+int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu);
 void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu);
 int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu,
 			   void __user *buf, int len);
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index cf4de80bd541..8aaee2892ec3 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -276,6 +276,34 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
 	if (!dst_vcpu)
 		return SIGP_CC_NOT_OPERATIONAL;
 
+	/*
+	 * SIGP RESTART, SIGP STOP, and SIGP STOP AND STORE STATUS orders
+	 * are processed asynchronously. Until the affected VCPU finishes
+	 * its work and calls back into KVM to clear the (RESTART or STOP)
+	 * interrupt, we need to return any new non-reset orders "busy".
+	 *
+	 * This is important because a single VCPU could issue:
+	 *  1) SIGP STOP $DESTINATION
+	 *  2) SIGP SENSE $DESTINATION
+	 *
+	 * If the SIGP SENSE would not be rejected as "busy", it could
+	 * return an incorrect answer as to whether the VCPU is STOPPED
+	 * or OPERATING.
+	 */
+	if (order_code != SIGP_INITIAL_CPU_RESET &&
+	    order_code != SIGP_CPU_RESET) {
+		/*
+		 * Lockless check. Both SIGP STOP and SIGP (RE)START
+		 * properly synchronize everything while processing
+		 * their orders, while the guest cannot observe a
+		 * difference when issuing other orders from two
+		 * different VCPUs.
+		 */
+		if (kvm_s390_is_stop_irq_pending(dst_vcpu) ||
+		    kvm_s390_is_restart_irq_pending(dst_vcpu))
+			return SIGP_CC_BUSY;
+	}
+
 	switch (order_code) {
 	case SIGP_SENSE:
 		vcpu->stat.instruction_sigp_sense++;

