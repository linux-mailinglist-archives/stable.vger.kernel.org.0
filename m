Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE18A8EFD
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388498AbfIDSBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733156AbfIDSBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:01:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F44A21883;
        Wed,  4 Sep 2019 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620071;
        bh=SukYggwGcFDiVrMyR9vCcwGi1x6yMdhUrF/1+UKg93I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHjHWPk7yWMuWU2aQeJTTsnIRzDK+lP4D/iq6RaqZ2tPxZ6kUWAkR7G5XpdS4bd2A
         Qj9DuCs4BNNegNGYKWzotcXB71jvmH16bYOQvrLLt6BsdLw84JtlcUeZPU5Z6+u95T
         vdbdGMeIsJkM9jkbayS/0qyAfM7cwEKAo1dUPzTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 4.9 61/83] KVM: x86: Dont update RIP or do single-step on faulting emulation
Date:   Wed,  4 Sep 2019 19:53:53 +0200
Message-Id: <20190904175308.960212726@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 75ee23b30dc712d80d2421a9a547e7ab6e379b44 upstream.

Don't advance RIP or inject a single-step #DB if emulation signals a
fault.  This logic applies to all state updates that are conditional on
clean retirement of the emulation instruction, e.g. updating RFLAGS was
previously handled by commit 38827dbd3fb85 ("KVM: x86: Do not update
EFLAGS on faulting emulation").

Not advancing RIP is likely a nop, i.e. ctxt->eip isn't updated with
ctxt->_eip until emulation "retires" anyways.  Skipping #DB injection
fixes a bug reported by Andy Lutomirski where a #UD on SYSCALL due to
invalid state with EFLAGS.TF=1 would loop indefinitely due to emulation
overwriting the #UD with #DB and thus restarting the bad SYSCALL over
and over.

Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: stable@vger.kernel.org
Reported-by: Andy Lutomirski <luto@kernel.org>
Fixes: 663f4c61b803 ("KVM: x86: handle singlestep during emulation")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5823,12 +5823,13 @@ restart:
 		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
-		kvm_rip_write(vcpu, ctxt->eip);
-		if (r == EMULATE_DONE && ctxt->tf)
-			kvm_vcpu_do_singlestep(vcpu, &r);
 		if (!ctxt->have_exception ||
-		    exception_type(ctxt->exception.vector) == EXCPT_TRAP)
+		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
+			kvm_rip_write(vcpu, ctxt->eip);
+			if (r == EMULATE_DONE && ctxt->tf)
+				kvm_vcpu_do_singlestep(vcpu, &r);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
+		}
 
 		/*
 		 * For STI, interrupts are shadowed; so KVM_REQ_EVENT will


