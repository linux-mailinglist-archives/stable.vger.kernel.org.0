Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1466532369
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 08:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiEXGmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 02:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiEXGmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 02:42:17 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D7C31938
        for <stable@vger.kernel.org>; Mon, 23 May 2022 23:42:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653374534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z9BomDPslMVbI/PFNphqSP681/9WI8wlrwx4OxrAfKk=;
        b=mig72ZT1X3lczrBoKOCK+kxr7uEXsbDXRvf5cccqsxD+3o8SX1YZwR00WVNzRuDWoLAPk2
        /YRNdaPHqsVWy4XHoQ2EtrmETOL9ThNRuLSYr/7OZxUYnEgCkpvZ9Hk2t4M9AggNek/l9C
        XAFSFbCWVkhN/CKXsl/KdRlAc6WbtrA=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com,
        sebastien.boeuf@intel.com, kai.liu@suse.com
Subject: [PATCH 5.10] KVM: x86: Properly handle APF vs disabled LAPIC situation
Date:   Tue, 24 May 2022 14:42:04 +0800
Message-Id: <20220524064204.18598-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Backport of commit 2f15d027c05fac406decdb5eceb9ec0902b68f53 upstream.

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
---
Hi,

We encountered below task hang issue with 5.10.113 stable kernel.

[  246.845061] INFO: task rpmbuild:2303 blocked for more than 122 seconds.
[  246.846269]       Not tainted 5.10.113-1.1.se2-default #1
[  246.847103] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  246.848248] task:rpmbuild        state:D stack:    0 pid: 2303 ppid:  2302 flags:0x00000000
[  246.848252] Call Trace:
[  246.848266]  __schedule+0x3f6/0x7c0
[  246.848289]  ? __handle_mm_fault+0x3dd/0x6d0
[  246.848291]  schedule+0x46/0xb0
[  246.848295]  kvm_async_pf_task_wait_schedule+0x4b/0x90
[  246.848297]  ? handle_mm_fault+0xbc/0x280
[  246.848300]  __kvm_handle_async_pf+0x4f/0xb0
[  246.848303]  exc_page_fault+0x204/0x540
[  246.848305]  ? asm_exc_page_fault+0x8/0x30
[  246.848307]  asm_exc_page_fault+0x1e/0x30
[  246.848310] RIP: 0033:0x7f122fbdfc90

And after investigating, this patch resolve the issue. 5.12 stable kernel
has already merged it by commit 36825931c607.

Thanks,
Guoqing    

 arch/x86/kvm/lapic.c | 6 ++++++
 arch/x86/kvm/x86.c   | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a3ef793fce5f..6ed6b090be94 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -297,6 +297,10 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 
 		atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	}
+
+	/* Check if there are APF page ready requests pending */
+	if (enabled)
+		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
@@ -2260,6 +2264,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		if (value & MSR_IA32_APICBASE_ENABLE) {
 			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 			static_key_slow_dec_deferred(&apic_hw_disabled);
+			/* Check if there are APF page ready requests pending */
+			kvm_make_request(KVM_REQ_APF_READY, vcpu);
 		} else {
 			static_key_slow_inc(&apic_hw_disabled.key);
 			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4588f73bf59a..ae18062c26a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11146,7 +11146,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 	if (!kvm_pv_async_pf_enabled(vcpu))
 		return true;
 	else
-		return apf_pageready_slot_free(vcpu);
+		return kvm_lapic_enabled(vcpu) && apf_pageready_slot_free(vcpu);
 }
 
 void kvm_arch_start_assignment(struct kvm *kvm)
-- 
2.34.1

