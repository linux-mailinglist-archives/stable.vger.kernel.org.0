Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C502B4ABD9A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388808AbiBGLpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385459AbiBGLby (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459F0C03FEF8;
        Mon,  7 Feb 2022 03:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D20AB80EC3;
        Mon,  7 Feb 2022 11:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306ADC004E1;
        Mon,  7 Feb 2022 11:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233420;
        bh=/FgX0PQoDe/ke1Z7gTQfTglAyxymyTnBOSUKW6/1TSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxwqyzhmQRY/qPzR1H/LrXyJQknHAy/weqv6iNIBkY5wL5/sXAsy1+iwjzmUbs0kX
         o8uMvDAlwXe1JS5ChLcUo6XoXCraJDWENTKSRZNVLHzQlb0XHgtTD0GK/azBk7CcM+
         nxwalfUAwXN7Glz+YimLSso9Pjs/MSGW9hOPsov0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/110] kvm/arm64: rework guest entry logic
Date:   Mon,  7 Feb 2022 12:07:05 +0100
Message-Id: <20220207103805.516218203@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8cfe148a7136bc60452a5c6b7ac2d9d15c36909b ]

In kvm_arch_vcpu_ioctl_run() we enter an RCU extended quiescent state
(EQS) by calling guest_enter_irqoff(), and unmasked IRQs prior to
exiting the EQS by calling guest_exit(). As the IRQ entry code will not
wake RCU in this case, we may run the core IRQ code and IRQ handler
without RCU watching, leading to various potential problems.

Additionally, we do not inform lockdep or tracing that interrupts will
be enabled during guest execution, which caan lead to misleading traces
and warnings that interrupts have been enabled for overly-long periods.

This patch fixes these issues by using the new timing and context
entry/exit helpers to ensure that interrupts are handled during guest
vtime but with RCU watching, with a sequence:

	guest_timing_enter_irqoff();

	guest_state_enter_irqoff();
	< run the vcpu >
	guest_state_exit_irqoff();

	< take any pending IRQs >

	guest_timing_exit_irqoff();

Since instrumentation may make use of RCU, we must also ensure that no
instrumented code is run during the EQS. I've split out the critical
section into a new kvm_arm_enter_exit_vcpu() helper which is marked
noinstr.

Fixes: 1b3d546daf85ed2b ("arm/arm64: KVM: Properly account for guest CPU time")
Reported-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Message-Id: <20220201132926.3301912-3-mark.rutland@arm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 51 ++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9b328bb05596a..f9c7e4e61b296 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -755,6 +755,24 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
 			xfer_to_guest_mode_work_pending();
 }
 
+/*
+ * Actually run the vCPU, entering an RCU extended quiescent state (EQS) while
+ * the vCPU is running.
+ *
+ * This must be noinstr as instrumentation may make use of RCU, and this is not
+ * safe during the EQS.
+ */
+static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	guest_state_enter_irqoff();
+	ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
+	guest_state_exit_irqoff();
+
+	return ret;
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
@@ -845,9 +863,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * Enter the guest
 		 */
 		trace_kvm_entry(*vcpu_pc(vcpu));
-		guest_enter_irqoff();
+		guest_timing_enter_irqoff();
 
-		ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
+		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
@@ -882,26 +900,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
 		/*
-		 * We may have taken a host interrupt in HYP mode (ie
-		 * while executing the guest). This interrupt is still
-		 * pending, as we haven't serviced it yet!
+		 * We must ensure that any pending interrupts are taken before
+		 * we exit guest timing so that timer ticks are accounted as
+		 * guest time. Transiently unmask interrupts so that any
+		 * pending interrupts are taken.
 		 *
-		 * We're now back in SVC mode, with interrupts
-		 * disabled.  Enabling the interrupts now will have
-		 * the effect of taking the interrupt again, in SVC
-		 * mode this time.
+		 * Per ARM DDI 0487G.b section D1.13.4, an ISB (or other
+		 * context synchronization event) is necessary to ensure that
+		 * pending interrupts are taken.
 		 */
 		local_irq_enable();
+		isb();
+		local_irq_disable();
+
+		guest_timing_exit_irqoff();
+
+		local_irq_enable();
 
-		/*
-		 * We do local_irq_enable() before calling guest_exit() so
-		 * that if a timer interrupt hits while running the guest we
-		 * account that tick as being spent in the guest.  We enable
-		 * preemption after calling guest_exit() so that if we get
-		 * preempted we make sure ticks after that is not counted as
-		 * guest time.
-		 */
-		guest_exit();
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
 		/* Exit types that need handling before we can be preempted */
-- 
2.34.1



