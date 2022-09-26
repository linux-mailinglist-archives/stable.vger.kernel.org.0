Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C605EA45D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiIZLpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238673AbiIZLoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8354372FF4;
        Mon, 26 Sep 2022 03:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B5D6091B;
        Mon, 26 Sep 2022 10:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DAEC433D6;
        Mon, 26 Sep 2022 10:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189198;
        bh=ug9Ge9ICIjyQ5FTTGPTaKvIClq9/OIhcNwJxA9pxu+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zECb0Hu1ItCpbcpso7LWpSB56Rz5OV5cpYqcDuBTg6+QfEuvwfmr6cOs6SNBQ0qnY
         W7y0HKQdsnddMWmamtna9+/DWoeUGwy3aO9wjqJ7vm7jb1tl9VEkO1TPaIDBA9lzjs
         dXse07AU4eHrimd1UftNRH60gvQRysQcnNfolBj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 064/207] KVM: x86: Reinstate kvm_vcpu_arch.guest_supported_xcr0
Date:   Mon, 26 Sep 2022 12:10:53 +0200
Message-Id: <20220926100809.463971916@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit ee519b3a2ae3027c341bce829ee8c51f4f494f5b upstream.

Reinstate the per-vCPU guest_supported_xcr0 by partially reverting
commit 988896bb6182; the implicit assessment that guest_supported_xcr0 is
always the same as guest_fpu.fpstate->user_xfeatures was incorrect.

kvm_vcpu_after_set_cpuid() isn't the only place that sets user_xfeatures,
as user_xfeatures is set to fpu_user_cfg.default_features when guest_fpu
is allocated via fpu_alloc_guest_fpstate() => __fpstate_reset().
guest_supported_xcr0 on the other hand is zero-allocated.  If userspace
never invokes KVM_SET_CPUID2, supported XCR0 will be '0', whereas the
allowed user XFEATURES will be non-zero.

Practically speaking, the edge case likely doesn't matter as no sane
userspace will live migrate a VM without ever doing KVM_SET_CPUID2. The
primary motivation is to prepare for KVM intentionally and explicitly
setting bits in user_xfeatures that are not set in guest_supported_xcr0.

Because KVM_{G,S}ET_XSAVE can be used to svae/restore FP+SSE state even
if the host doesn't support XSAVE, KVM needs to set the FP+SSE bits in
user_xfeatures even if they're not allowed in XCR0, e.g. because XCR0
isn't exposed to the guest.  At that point, the simplest fix is to track
the two things separately (allowed save/restore vs. allowed XCR0).

Fixes: 988896bb6182 ("x86/kvm/fpu: Remove kvm_vcpu_arch.guest_supported_xcr0")
Cc: stable@vger.kernel.org
Cc: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220824033057.3576315-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/cpuid.c            |    5 ++---
 arch/x86/kvm/x86.c              |    9 ++-------
 3 files changed, 5 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -713,6 +713,7 @@ struct kvm_vcpu_arch {
 	struct fpu_guest guest_fpu;
 
 	u64 xcr0;
+	u64 guest_supported_xcr0;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -283,7 +283,6 @@ static void kvm_vcpu_after_set_cpuid(str
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
-	u64 guest_supported_xcr0;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best && apic) {
@@ -295,10 +294,10 @@ static void kvm_vcpu_after_set_cpuid(str
 		kvm_apic_set_version(vcpu);
 	}
 
-	guest_supported_xcr0 =
+	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0;
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
 
 	kvm_update_pv_runtime(vcpu);
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1025,15 +1025,10 @@ void kvm_load_host_xsave_state(struct kv
 }
 EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
 
-static inline u64 kvm_guest_supported_xcr0(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.guest_fpu.fpstate->user_xfeatures;
-}
-
 #ifdef CONFIG_X86_64
 static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
 {
-	return kvm_guest_supported_xcr0(vcpu) & XFEATURE_MASK_USER_DYNAMIC;
+	return vcpu->arch.guest_supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC;
 }
 #endif
 
@@ -1056,7 +1051,7 @@ static int __kvm_set_xcr(struct kvm_vcpu
 	 * saving.  However, xcr0 bit 0 is always set, even if the
 	 * emulated CPU does not support XSAVE (see kvm_vcpu_reset()).
 	 */
-	valid_bits = kvm_guest_supported_xcr0(vcpu) | XFEATURE_MASK_FP;
+	valid_bits = vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FP;
 	if (xcr0 & ~valid_bits)
 		return 1;
 


