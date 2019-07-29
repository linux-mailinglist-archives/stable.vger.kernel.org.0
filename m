Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CBD79724
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390943AbfG2Txx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390935AbfG2Txw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:53:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6112217D7;
        Mon, 29 Jul 2019 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430031;
        bh=7oNkVGkCARzG3ouaad00+6R83JA69aiApiOofGoMXcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7r0wJDMUyOUeM+YAxSH2u8P883Csv/BuK6MbXytvsYzC+kotmfR20vip8g268I+l
         sLR7r7qsrWb4097ZqO+NChPbPaibHtis7IxnFFu2XjouQV3i+W7GZdlulCQdttUC7J
         ypQ+uZnfveknkaUw9wX/IeHPavxSX+lvLXvXObRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Lambertz <mail@thomaslambertz.de>,
        anthony <antdev66@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 5.2 174/215] KVM: X86: Fix fpu state crash in kvm guest
Date:   Mon, 29 Jul 2019 21:22:50 +0200
Message-Id: <20190729190810.125640760@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit e751732486eb3f159089a64d1901992b1357e7cc upstream.

The idea before commit 240c35a37 (which has just been reverted)
was that we have the following FPU states:

               userspace (QEMU)             guest
---------------------------------------------------------------------------
               processor                    vcpu->arch.guest_fpu
>>> KVM_RUN: kvm_load_guest_fpu
               vcpu->arch.user_fpu          processor
>>> preempt out
               vcpu->arch.user_fpu          current->thread.fpu
>>> preempt in
               vcpu->arch.user_fpu          processor
>>> back to userspace
>>> kvm_put_guest_fpu
               processor                    vcpu->arch.guest_fpu
---------------------------------------------------------------------------

With the new lazy model we want to get the state back to the processor
when schedule in from current->thread.fpu.

Reported-by: Thomas Lambertz <mail@thomaslambertz.de>
Reported-by: anthony <antdev66@gmail.com>
Tested-by: anthony <antdev66@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Thomas Lambertz <mail@thomaslambertz.de>
Cc: anthony <antdev66@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 5f409e20b (x86/fpu: Defer FPU state load until return to userspace)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
[Add a comment in front of the warning. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3264,6 +3264,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 
+	fpregs_assert_state_consistent();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
@@ -7955,9 +7959,8 @@ static int vcpu_enter_guest(struct kvm_v
 		wait_lapic_expire(vcpu);
 	guest_enter_irqoff();
 
-	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_return();
+	/* The preempt notifier should have taken care of the FPU already.  */
+	WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
 
 	if (unlikely(vcpu->arch.switch_db_regs)) {
 		set_debugreg(0, 7);


