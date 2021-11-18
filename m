Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E88455E22
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhKROhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:37:52 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39208 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhKROhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:37:50 -0500
Date:   Thu, 18 Nov 2021 14:34:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637246089;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+KBAXfINBDngw79WyyWxTVVH1FuLVzM+Khkw83Sjj8=;
        b=jimiHe8+6FBuyifBQ/s6qJHCLIc4B515BoZW3xfhwDkYT/yG02904vD4gFh/dO+Rz1Dq+T
        BI6znXRhePqNVMOLI1d4GfHU5NMFMIAv+xEsz2JSiebK7wwj9swJ6tlt5FlJHgJbpVCnJX
        oG/F+xfdDI4//LXzn+rpGTY2Rl6N3TbQ0YuBMpbCwLP8r3Sb5/CvEhSTqQD/uLJXHVrVLX
        2tvnQ2zzksiG6HyXzmSXkjK6/eW5O6z2PEEsoDtf66fQtnnPD6duWCxJ6n+J48RxzxOn9C
        Rqn0xIhnMVfGndajKNP1cHlzTqTLp9OfSGfWJ6JyxVD8vxDqak2tOW8Hs2orUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637246089;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+KBAXfINBDngw79WyyWxTVVH1FuLVzM+Khkw83Sjj8=;
        b=DPeqdSyOMMZvuDs6txTNtT5VkZXfK/FAYmY8DUSAaDEf0ygNp+wbN/U31XdsRDlzCJX0JY
        Bd30DLm4gJQxQHDQ==
From:   "tip-bot2 for Sean Christopherson" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] KVM: x86: Register perf callbacks after calling
 vendor's hardware_setup()
Cc:     Sean Christopherson <seanjc@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211111020738.2512932-3-seanjc@google.com>
References: <20211111020738.2512932-3-seanjc@google.com>
MIME-Version: 1.0
Message-ID: <163724608811.11128.10260908640428524095.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     5c7df80e2ce4c954c80eb4ecf5fa002a5ff5d2d6
Gitweb:        https://git.kernel.org/tip/5c7df80e2ce4c954c80eb4ecf5fa002a5ff5d2d6
Author:        Sean Christopherson <seanjc@google.com>
AuthorDate:    Thu, 11 Nov 2021 02:07:23 
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 17 Nov 2021 14:49:06 +01:00

KVM: x86: Register perf callbacks after calling vendor's hardware_setup()

Wait to register perf callbacks until after doing vendor hardaware setup.
VMX's hardware_setup() configures Intel Processor Trace (PT) mode, and a
future fix to register the Intel PT guest interrupt hook if and only if
Intel PT is exposed to the guest will consume the configured PT mode.

Delaying registration to hardware setup is effectively a nop as KVM's perf
hooks all pivot on the per-CPU current_vcpu, which is non-NULL only when
KVM is handling an IRQ/NMI in a VM-Exit path.  I.e. current_vcpu will be
NULL throughout both kvm_arch_init() and kvm_arch_hardware_setup().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211111020738.2512932-3-seanjc@google.com
---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc7eb5f..50f0cd1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8626,8 +8626,6 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
@@ -8659,7 +8657,6 @@ void kvm_arch_exit(void)
 		clear_hv_tscchange_cb();
 #endif
 	kvm_lapic_exit();
-	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
@@ -11225,6 +11222,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
@@ -11252,6 +11251,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
