Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0604A408DC7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241664AbhIMN3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241817AbhIMNZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4669D61250;
        Mon, 13 Sep 2021 13:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539350;
        bh=xWJqruAQpL/DITz+cAmlG02JbUIUnhYwr2khHa7iXiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZMY8VPh39SShNRabL9aTsi19L3UNsJg5qIeAAnmj6Kf2xAI95VMNoIQ5iq3buS6m
         u9GTRUNYIP7XBKnDP72aXDqFUMXJX/GvVgCarKsZOoOOc5cMGlJtEUmFj1AA/JasAd
         7m5EgGgAA2gAiH63IHYze72SHZ3F5dRBdXbEoXxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 137/144] KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter
Date:   Mon, 13 Sep 2021 15:15:18 +0200
Message-Id: <20210913131052.515585573@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit f7782bb8d818d8f47c26b22079db10599922787a upstream.

Clear nested.pi_pending on nested VM-Enter even if L2 will run without
posted interrupts enabled.  If nested.pi_pending is left set from a
previous L2, vmx_complete_nested_posted_interrupt() will pick up the
stale flag and exit to userspace with an "internal emulation error" due
the new L2 not having a valid nested.pi_desc.

Arguably, vmx_complete_nested_posted_interrupt() should first check for
posted interrupts being enabled, but it's also completely reasonable that
KVM wouldn't screw up a fundamental flag.  Not to mention that the mere
existence of nested.pi_pending is a long-standing bug as KVM shouldn't
move the posted interrupt out of the IRR until it's actually processed,
e.g. KVM effectively drops an interrupt when it performs a nested VM-Exit
with a "pending" posted interrupt.  Fixing the mess is a future problem.

Prior to vmx_complete_nested_posted_interrupt() interpreting a null PI
descriptor as an error, this was a benign bug as the null PI descriptor
effectively served as a check on PI not being enabled.  Even then, the
new flow did not become problematic until KVM started checking the result
of kvm_check_nested_events().

Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
Fixes: 966eefb89657 ("KVM: nVMX: Disable vmcs02 posted interrupts if vmcs12 PID isn't mappable")
Fixes: 47d3530f86c0 ("KVM: x86: Exit to userspace when kvm_check_nested_events fails")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210810144526.2662272-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2057,12 +2057,11 @@ static void prepare_vmcs02_early(struct
 			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
-	if (nested_cpu_has_posted_intr(vmcs12)) {
+	vmx->nested.pi_pending = false;
+	if (nested_cpu_has_posted_intr(vmcs12))
 		vmx->nested.posted_intr_nv = vmcs12->posted_intr_nv;
-		vmx->nested.pi_pending = false;
-	} else {
+	else
 		exec_control &= ~PIN_BASED_POSTED_INTR;
-	}
 	pin_controls_set(vmx, exec_control);
 
 	/*


