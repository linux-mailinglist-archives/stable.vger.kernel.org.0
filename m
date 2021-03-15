Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7069933BAAA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhCOOKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234632AbhCOOEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C0D764DAD;
        Mon, 15 Mar 2021 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817074;
        bh=dLggE5UcIHdTZxiVTcRYvG1zoFKMcwZg9ZMurFrMvKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zR61yK5Z0zYeWtMQCZ/K0GDdCq58+s3AYSjBKiL/tUQ4HFYObIotCZYg10eWvWn5U
         nxIPrDcVWwxFQoFHSS4RLMtI8IW3jqfb9kOaVfUbeKb9jyjdu4Op613fKukMbPJoPX
         M0M8ufdCl/W7siHYNmNYur/n2SRVB6xdkRvhCKIw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 276/290] KVM: x86: Ensure deadline timer has truly expired before posting its IRQ
Date:   Mon, 15 Mar 2021 14:56:09 +0100
Message-Id: <20210315135551.359947615@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Sean Christopherson <seanjc@google.com>

commit beda430177f56656e7980dcce93456ffaa35676b upstream.

When posting a deadline timer interrupt, open code the checks guarding
__kvm_wait_lapic_expire() in order to skip the lapic_timer_int_injected()
check in kvm_wait_lapic_expire().  The injection check will always fail
since the interrupt has not yet be injected.  Moving the call after
injection would also be wrong as that wouldn't actually delay delivery
of the IRQ if it is indeed sent via posted interrupt.

Fixes: 010fd37fddf6 ("KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305021808.3769732-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1641,7 +1641,16 @@ static void apic_timer_expired(struct kv
 	}
 
 	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
-		kvm_wait_lapic_expire(vcpu);
+		/*
+		 * Ensure the guest's timer has truly expired before posting an
+		 * interrupt.  Open code the relevant checks to avoid querying
+		 * lapic_timer_int_injected(), which will be false since the
+		 * interrupt isn't yet injected.  Waiting until after injecting
+		 * is not an option since that won't help a posted interrupt.
+		 */
+		if (vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
+		    vcpu->arch.apic->lapic_timer.timer_advance_ns)
+			__kvm_wait_lapic_expire(vcpu);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}


