Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC74375379
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 14:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhEFMPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 08:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbhEFMPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 08:15:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEEEC061574;
        Thu,  6 May 2021 05:14:07 -0700 (PDT)
Date:   Thu, 06 May 2021 12:14:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620303245;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5cnn4Fmmyn5WvE4AFKiO+TAVCk9EaZgQjTJEq3MOtSY=;
        b=sIv0zeoqLgyiO9BrLDO3dXP3dknF9Z2m37As+abuS9FrUaYKzfKSgEuH7gB4YuaDaHsKCI
        t0Zg00pfgb12CW5OoYuzVgLBalQ7WJjrAu4e1RCL1+TsyFkLlUuZH9rHTd4CKxskcaX6Dk
        ZosOGG+Yu6xR5+j8o9QiY1LHDxxsrVNymyX4ORHLA9FIVoEexlXVi4oBgM7PtGbOxTdVQk
        jKPUkwWUAGDWHKMcq2J9U74toN6gF/R6NAh1C3hHdJYHm35m2YKPZHc2UsgC4nitLVMJ+x
        RpWgI/yyRfYkSQ8C+05jFtRr0Jj5wBv4RixyLJUchkNHQVBJ0sLsZpq2Y5csCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620303245;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5cnn4Fmmyn5WvE4AFKiO+TAVCk9EaZgQjTJEq3MOtSY=;
        b=fp0jkOIOygAPKfy+OJlYcv/J8jIDzNAcrvKgrEM+ePoz5USZIzydyjRZkCz1PprKt4Ekdi
        IHvKl017xGgFzhDA==
From:   "tip-bot2 for Wanpeng Li" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] KVM: x86: Defer vtime accounting 'til after IRQ handling
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210505002735.1684165-4-seanjc@google.com>
References: <20210505002735.1684165-4-seanjc@google.com>
MIME-Version: 1.0
Message-ID: <162030324464.29796.14687279478344934242.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     160457140187c5fb127b844e5a85f87f00a01b14
Gitweb:        https://git.kernel.org/tip/160457140187c5fb127b844e5a85f87f00a01b14
Author:        Wanpeng Li <wanpengli@tencent.com>
AuthorDate:    Tue, 04 May 2021 17:27:30 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 05 May 2021 22:54:11 +02:00

KVM: x86: Defer vtime accounting 'til after IRQ handling

Defer the call to account guest time until after servicing any IRQ(s)
that happened in the guest or immediately after VM-Exit.  Tick-based
accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
handler runs, and IRQs are blocked throughout the main sequence of
vcpu_enter_guest(), including the call into vendor code to actually
enter and exit the guest.

This fixes a bug where reported guest time remains '0', even when
running an infinite loop in the guest:

  https://bugzilla.kernel.org/show_bug.cgi?id=209831

Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210505002735.1684165-4-seanjc@google.com
---
 arch/x86/kvm/svm/svm.c |  6 +++---
 arch/x86/kvm/vmx/vmx.c |  6 +++---
 arch/x86/kvm/x86.c     |  9 +++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9790c73..c400def 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3753,15 +3753,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit() restores host context and reinstates
+	 * RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b21d751..e108fb4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6703,15 +6703,15 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit() restores host context and reinstates
+	 * RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cebdaa1..6eda283 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9315,6 +9315,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
+	/*
+	 * Wait until after servicing IRQs to account guest time so that any
+	 * ticks that occurred while running the guest are properly accounted
+	 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
+	 * of accounting via context tracking, but the loss of accuracy is
+	 * acceptable for all known use cases.
+	 */
+	vtime_account_guest_exit();
+
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {
