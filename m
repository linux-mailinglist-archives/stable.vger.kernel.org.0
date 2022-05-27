Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9554535CD7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350466AbiE0JBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350970AbiE0JA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BC012B007;
        Fri, 27 May 2022 01:57:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53974CE238F;
        Fri, 27 May 2022 08:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EB5C385B8;
        Fri, 27 May 2022 08:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641853;
        bh=CBA5U7Thwi67+WFwmA0DDhJhf9pBTilOgX3JRI1M0aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xb/pjN92fKqDaKwD8zPsY3A9EiW8O2m/ALzUV0E9gpwDqJkkLRJemdBOFV/fv2a0i
         Tk5iazYxO7tINiREFYPnM7kpFGQLYTZIqHcPx2DU2QiAw5qVfnfGqFVOB3pt11h4EN
         fz5QjA7AZT2ArgaHt1eofk+fFyjuvX24gCh3kFYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH 5.10 003/163] KVM: x86: Properly handle APF vs disabled LAPIC situation
Date:   Fri, 27 May 2022 10:48:03 +0200
Message-Id: <20220527084828.658414949@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[Guoqing: backport to 5.10-stable ]
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    6 ++++++
 arch/x86/kvm/x86.c   |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -297,6 +297,10 @@ static inline void apic_set_spiv(struct
 
 		atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	}
+
+	/* Check if there are APF page ready requests pending */
+	if (enabled)
+		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
@@ -2260,6 +2264,8 @@ void kvm_lapic_set_base(struct kvm_vcpu
 		if (value & MSR_IA32_APICBASE_ENABLE) {
 			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 			static_key_slow_dec_deferred(&apic_hw_disabled);
+			/* Check if there are APF page ready requests pending */
+			kvm_make_request(KVM_REQ_APF_READY, vcpu);
 		} else {
 			static_key_slow_inc(&apic_hw_disabled.key);
 			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11146,7 +11146,7 @@ bool kvm_arch_can_dequeue_async_page_pre
 	if (!kvm_pv_async_pf_enabled(vcpu))
 		return true;
 	else
-		return apf_pageready_slot_free(vcpu);
+		return kvm_lapic_enabled(vcpu) && apf_pageready_slot_free(vcpu);
 }
 
 void kvm_arch_start_assignment(struct kvm *kvm)


