Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C3439322F
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhE0PQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237098AbhE0PPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15DF2613C3;
        Thu, 27 May 2021 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128429;
        bh=Vy6Ay5huBFbu3BsnKhjEQJUVr1drvFyUZJiC8Kzri3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9qqhFIIdLWCSF6HauAXfEpwMLQeO672UJMvC+ooE+UBskdCRJDBB1z7Q2XN90Xus
         0piNlJh2JleQ69hZ7OMk15fAKkt1i/0Yzox74n2Jcb7NWKIaUT1beujFw7ZHNjQRnC
         6MJSDi7yUUWFpqxe1LSoAZMp9I+BW6e/3xsR5Tyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.12 6/7] KVM: x86: Defer vtime accounting til after IRQ handling
Date:   Thu, 27 May 2021 17:13:07 +0200
Message-Id: <20210527151139.442692176@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
References: <20210527151139.241267495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 160457140187c5fb127b844e5a85f87f00a01b14 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    6 +++---
 arch/x86/kvm/vmx/vmx.c |    6 +++---
 arch/x86/kvm/x86.c     |    9 +++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3815,15 +3815,15 @@ static noinstr void svm_vcpu_enter_exit(
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
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6701,15 +6701,15 @@ static noinstr void vmx_vcpu_enter_exit(
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
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9236,6 +9236,15 @@ static int vcpu_enter_guest(struct kvm_v
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


