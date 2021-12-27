Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141347FFCF
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhL0PlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239426AbhL0Pjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352E6C0617A1;
        Mon, 27 Dec 2021 07:38:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 874BCCE10D1;
        Mon, 27 Dec 2021 15:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6E7C36AEA;
        Mon, 27 Dec 2021 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619508;
        bh=Qasf8TKl2rBl/oEYpNwVEpGXxNihOZ1L3Z5UABv86Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBO/QQeepeoQw81red6FyIJAACMKSHPkG3J6S7cW6y8IfFFRx051rZZGP+yswe06k
         71iAn9XPUZbOutzkphMA2E9ul5GiumS/uhy1wOxoMCz9h4PU81oJ3UBIv5bOdwijrl
         tC57t8U9JeaX5PS5MXQXWbfKjtt44jhCrdx6yJng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Longpeng (Mike)" <longpeng2@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 49/76] KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
Date:   Mon, 27 Dec 2021 16:31:04 +0100
Message-Id: <20211227151326.399097017@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit fdba608f15e2427419997b0898750a49a735afcb upstream.

Drop a check that guards triggering a posted interrupt on the currently
running vCPU, and more importantly guards waking the target vCPU if
triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
If a vIRQ is delivered from asynchronous context, the target vCPU can be
the currently running vCPU and can also be blocking, in which case
skipping kvm_vcpu_wake_up() is effectively dropping what is supposed to
be a wake event for the vCPU.

The "do nothing" logic when "vcpu == running_vcpu" mostly works only
because the majority of calls to ->deliver_posted_interrupt(), especially
when using posted interrupts, come from synchronous KVM context.  But if
a device is exposed to the guest using vfio-pci passthrough, the VFIO IRQ
and vCPU are bound to the same pCPU, and the IRQ is _not_ configured to
use posted interrupts, wake events from the device will be delivered to
KVM from IRQ context, e.g.

  vfio_msihandler()
  |
  |-> eventfd_signal()
      |
      |-> ...
          |
          |->  irqfd_wakeup()
               |
               |->kvm_arch_set_irq_inatomic()
                  |
                  |-> kvm_irq_delivery_to_apic_fast()
                      |
                      |-> kvm_apic_set_irq()

This also aligns the non-nested and nested usage of triggering posted
interrupts, and will allow for additional cleanups.

Fixes: 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt delivery for timer fastpath")
Cc: stable@vger.kernel.org
Reported-by: Longpeng (Mike) <longpeng2@huawei.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20211208015236.1616697-18-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4007,8 +4007,7 @@ static int vmx_deliver_posted_interrupt(
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
 
-	if (vcpu != kvm_get_running_vcpu() &&
-	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_kick(vcpu);
 
 	return 0;


