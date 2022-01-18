Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA84F492A25
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346385AbiARQHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:07:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40314 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346380AbiARQHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:07:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2651CE1A2C;
        Tue, 18 Jan 2022 16:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA3C340E0;
        Tue, 18 Jan 2022 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522036;
        bh=EI+oyhCyXzwd/u6PX2bA+0veUSeSN5jqvJw+x/ms5gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFn781NKkAE5F4ubf8MEvV3fgNTt5OqqqkYNjKzg4sFJKPY+wmqEP8X+yOywR9b5e
         YCx/pXrle08BxSCI3uc5qPKhfHAEnMdKp6JpnAuOb1t7/ZF4gzuKTYjjvyD3kBwTqU
         QOqwkq0yqUiVbGAvYizZ//ysc6J75oO96e6lqBcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 5.4 06/15] KVM: s390: Clarify SIGP orders versus STOP/RESTART
Date:   Tue, 18 Jan 2022 17:05:45 +0100
Message-Id: <20220118160450.270454516@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

commit 812de04661c4daa7ac385c0dfd62594540538034 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/interrupt.c |    7 +++++++
 arch/s390/kvm/kvm-s390.c  |    9 +++++++--
 arch/s390/kvm/kvm-s390.h  |    1 +
 arch/s390/kvm/sigp.c      |   28 ++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1982,6 +1982,13 @@ int kvm_s390_is_stop_irq_pending(struct
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
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4205,10 +4205,15 @@ void kvm_s390_vcpu_stop(struct kvm_vcpu
 	spin_lock(&vcpu->kvm->arch.start_stop_lock);
 	online_vcpus = atomic_read(&vcpu->kvm->online_vcpus);
 
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
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -373,6 +373,7 @@ void kvm_s390_destroy_adapters(struct kv
 int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu);
 extern struct kvm_device_ops kvm_flic_ops;
 int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu);
+int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu);
 void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu);
 int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu,
 			   void __user *buf, int len);
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -288,6 +288,34 @@ static int handle_sigp_dst(struct kvm_vc
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


