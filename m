Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F400C37CB44
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbhELQfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241626AbhELQ1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD27F61DF7;
        Wed, 12 May 2021 15:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834870;
        bh=xAU5NaZrKs84wEQ0MftKqBtsgv0dD5UnYI5EjBqH2Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08ZAhJMWvSau5pCTvyGsnGwcGXWCDJ1X5H0OA+NUiZAuI6HH+BiiARYYKVn1GAwRY
         Wni2H03xqp9jL2vSwugM3dcgRqE/0OdvhrTQtWNtt0klHDnzPVp5A9VKo/DwQXVBgD
         A5vGlvCrpnE6rCFNEIGjfbOJcx5fanqG2OjISAHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 109/677] KVM: x86: Properly handle APF vs disabled LAPIC situation
Date:   Wed, 12 May 2021 16:42:35 +0200
Message-Id: <20210512144840.841629030@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 2f15d027c05fac406decdb5eceb9ec0902b68f53 upstream.

Async PF 'page ready' event may happen when LAPIC is (temporary) disabled.
In particular, Sebastien reports that when Linux kernel is directly booted
by Cloud Hypervisor, LAPIC is 'software disabled' when APF mechanism is
initialized. On initialization KVM tries to inject 'wakeup all' event and
puts the corresponding token to the slot. It is, however, failing to inject
an interrupt (kvm_apic_set_irq() -> __apic_accept_irq() -> !apic_enabled())
so the guest never gets notified and the whole APF mechanism gets stuck.
The same issue is likely to happen if the guest temporary disables LAPIC
and a previously unavailable page becomes available.

Do two things to resolve the issue:
- Avoid dequeuing 'page ready' events from APF queue when LAPIC is
  disabled.
- Trigger an attempt to deliver pending 'page ready' events when LAPIC
  becomes enabled (SPIV or MSR_IA32_APICBASE).

Reported-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210422092948.568327-1-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    6 ++++++
 arch/x86/kvm/x86.c   |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -296,6 +296,10 @@ static inline void apic_set_spiv(struct
 
 		atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	}
+
+	/* Check if there are APF page ready requests pending */
+	if (enabled)
+		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
@@ -2261,6 +2265,8 @@ void kvm_lapic_set_base(struct kvm_vcpu
 		if (value & MSR_IA32_APICBASE_ENABLE) {
 			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 			static_branch_slow_dec_deferred(&apic_hw_disabled);
+			/* Check if there are APF page ready requests pending */
+			kvm_make_request(KVM_REQ_APF_READY, vcpu);
 		} else {
 			static_branch_inc(&apic_hw_disabled.key);
 			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11293,7 +11293,7 @@ bool kvm_arch_can_dequeue_async_page_pre
 	if (!kvm_pv_async_pf_enabled(vcpu))
 		return true;
 	else
-		return apf_pageready_slot_free(vcpu);
+		return kvm_lapic_enabled(vcpu) && apf_pageready_slot_free(vcpu);
 }
 
 void kvm_arch_start_assignment(struct kvm *kvm)


