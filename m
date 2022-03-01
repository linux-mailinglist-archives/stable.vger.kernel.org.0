Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADFC4C9594
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbiCAUPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiCAUPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:15:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38E375612;
        Tue,  1 Mar 2022 12:14:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 345EC61711;
        Tue,  1 Mar 2022 20:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BCDC340F1;
        Tue,  1 Mar 2022 20:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165664;
        bh=81+sJ4k+0IFTBlriLvK8LVa2UlmEq7RDSTqWnpHwSjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOjwKy76Kg2JjXZd3ylExFklTbIly5hei8w3Wl7c5Ky1FN8YwWjoONkhH4Eaonylg
         7fWYyX1VdfgwcYVdJlnxAYdIs3BPUa7z9li7VwCiCPg5MZOQjwhPDNPJtZMa6ebv7s
         RrOzz0+Ulfs/NiWt6VuTDFfV2hpBTSJw11S5CNzl/2oiQtdMew6eInxbAQh8fcNWe2
         /GjO0STnIB61bjmzrUSkWe6+0FqLl1dqz3+KlgaB7wR4u0g0g92YiMIKA1dcjkueih
         6ppexm8UDhsRCvv/qlVUESz7xxWikPJi+L05Si78PO0QU/CXxV9G+rIK9iM8TEa07N
         qx1pmiPYn1fNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonardo Bras <leobras@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, chang.seok.bae@intel.com, luto@kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0
Date:   Tue,  1 Mar 2022 15:13:12 -0500
Message-Id: <20220301201344.18191-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonardo Bras <leobras@redhat.com>

[ Upstream commit ad856280ddea3401e1f5060ef20e6de9f6122c76 ]

During host/guest switch (like in kvm_arch_vcpu_ioctl_run()), the kernel
swaps the fpu between host/guest contexts, by using fpu_swap_kvm_fpstate().

When xsave feature is available, the fpu swap is done by:
- xsave(s) instruction, with guest's fpstate->xfeatures as mask, is used
  to store the current state of the fpu registers to a buffer.
- xrstor(s) instruction, with (fpu_kernel_cfg.max_features &
  XFEATURE_MASK_FPSTATE) as mask, is used to put the buffer into fpu regs.

For xsave(s) the mask is used to limit what parts of the fpu regs will
be copied to the buffer. Likewise on xrstor(s), the mask is used to
limit what parts of the fpu regs will be changed.

The mask for xsave(s), the guest's fpstate->xfeatures, is defined on
kvm_arch_vcpu_create(), which (in summary) sets it to all features
supported by the cpu which are enabled on kernel config.

This means that xsave(s) will save to guest buffer all the fpu regs
contents the cpu has enabled when the guest is paused, even if they
are not used.

This would not be an issue, if xrstor(s) would also do that.

xrstor(s)'s mask for host/guest swap is basically every valid feature
contained in kernel config, except XFEATURE_MASK_PKRU.
Accordingto kernel src, it is instead switched in switch_to() and
flush_thread().

Then, the following happens with a host supporting PKRU starts a
guest that does not support it:
1 - Host has XFEATURE_MASK_PKRU set. 1st switch to guest,
2 - xsave(s) fpu regs to host fpustate (buffer has XFEATURE_MASK_PKRU)
3 - xrstor(s) guest fpustate to fpu regs (fpu regs have XFEATURE_MASK_PKRU)
4 - guest runs, then switch back to host,
5 - xsave(s) fpu regs to guest fpstate (buffer now have XFEATURE_MASK_PKRU)
6 - xrstor(s) host fpstate to fpu regs.
7 - kvm_vcpu_ioctl_x86_get_xsave() copy guest fpstate to userspace (with
    XFEATURE_MASK_PKRU, which should not be supported by guest vcpu)

On 5, even though the guest does not support PKRU, it does have the flag
set on guest fpstate, which is transferred to userspace via vcpu ioctl
KVM_GET_XSAVE.

This becomes a problem when the user decides on migrating the above guest
to another machine that does not support PKRU: the new host restores
guest's fpu regs to as they were before (xrstor(s)), but since the new
host don't support PKRU, a general-protection exception ocurs in xrstor(s)
and that crashes the guest.

This can be solved by making the guest's fpstate->user_xfeatures hold
a copy of guest_supported_xcr0. This way, on 7 the only flags copied to
userspace will be the ones compatible to guest requirements, and thus
there will be no issue during migration.

As a bonus, it will also fail if userspace tries to set fpu features
(with the KVM_SET_XSAVE ioctl) that are not compatible to the guest
configuration.  Such features will never be returned by KVM_GET_XSAVE
or KVM_GET_XSAVE2.

Also, since kvm_vcpu_after_set_cpuid() now sets fpstate->user_xfeatures,
there is not need to set it in kvm_check_cpuid(). So, change
fpstate_realloc() so it does not touch fpstate->user_xfeatures if a
non-NULL guest_fpu is passed, which is the case when kvm_check_cpuid()
calls it.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Message-Id: <20220217053028.96432-2-leobras@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 5 ++++-
 arch/x86/kvm/cpuid.c         | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d28829403ed08..6ac01f9828530 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1563,7 +1563,10 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
 		fpregs_restore_userregs();
 
 	newfps->xfeatures = curfps->xfeatures | xfeatures;
-	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
+
+	if (!guest_fpu)
+		newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
+
 	newfps->xfd = curfps->xfd & ~xfeatures;
 
 	curfps = fpu_install_fpstate(fpu, newfps);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index bf18679757c70..875dce4aa2d28 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -276,6 +276,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
+
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-- 
2.34.1

