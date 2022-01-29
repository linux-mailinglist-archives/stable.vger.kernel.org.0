Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E4C4A2FC1
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbiA2N10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243032AbiA2N1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:27:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D57C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 05:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F3B7B827B7
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C641C340E5;
        Sat, 29 Jan 2022 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643462842;
        bh=3n7ELjqWe377qXK00vuvkR2pfFShds05Ke/llOaRQ8s=;
        h=Subject:To:Cc:From:Date:From;
        b=aNzxR/Z3aL2+vJuR2bc1r+35lKVAgeHNlxgolmPCdgLmd9fRBAWDXsiYMuwxvJ6sH
         KCbzRGiQIhpS6aYdWmF/d/Bw+i6UUQj+22WkC+oNf2G/sS3YX94U9M9FpI1nVke8Mo
         vj6+u2X3p0sHV34zYOt6RZQTzsWj7IK2nKtbIaJQ=
Subject: FAILED: patch "[PATCH] KVM: x86: Keep MSR_IA32_XSS unchanged for INIT" failed to apply to 5.4-stable tree
To:     xiaoyao.li@intel.com, pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 14:27:11 +0100
Message-ID: <1643462831144232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be4f3b3f82271c3193ce200a996dc70682c8e622 Mon Sep 17 00:00:00 2001
From: Xiaoyao Li <xiaoyao.li@intel.com>
Date: Wed, 26 Jan 2022 17:22:24 +0000
Subject: [PATCH] KVM: x86: Keep MSR_IA32_XSS unchanged for INIT

It has been corrected from SDM version 075 that MSR_IA32_XSS is reset to
zero on Power up and Reset but keeps unchanged on INIT.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220126172226.2298529-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a50baf4c5bff..b6d60c296eda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11266,6 +11266,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vcpu->arch.msr_misc_features_enables = 0;
 
 		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
+		vcpu->arch.ia32_xss = 0;
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
@@ -11282,8 +11283,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
 	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
 
-	vcpu->arch.ia32_xss = 0;
-
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);

