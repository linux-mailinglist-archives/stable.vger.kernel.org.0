Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFC133BC6E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhCOOZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234060AbhCOOYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A9C65007;
        Mon, 15 Mar 2021 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818276;
        bh=dLggE5UcIHdTZxiVTcRYvG1zoFKMcwZg9ZMurFrMvKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7boBvc1HcNKFWA5d2X6wA2d7xZr6jbf8DvyUW4a7IoO6M2YC/FuWpZletEqqV20Z
         m2/OSnTOUi1b3KB5sVocxG9wPBBO3kNd1yWzGQ8zeEdcc0PiAqnh9gtKEelHJgVPWn
         cM75Yy+z7Uvw0Do6BJISWPBVVpWFjVhY0/vqRa+s=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 292/306] KVM: x86: Ensure deadline timer has truly expired before posting its IRQ
Date:   Mon, 15 Mar 2021 15:24:17 +0100
Message-Id: <20210315135517.556638562@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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


