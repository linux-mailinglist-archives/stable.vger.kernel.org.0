Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15B4A44C2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359598AbiAaLc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379412AbiAaLaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764EAC0617B0;
        Mon, 31 Jan 2022 03:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 166FD611DB;
        Mon, 31 Jan 2022 11:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB95C340EF;
        Mon, 31 Jan 2022 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628020;
        bh=gPfYO25pBQ890bf6IYPhQq4gJPP7maXQ4xUx5LxBVQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1AH2Kvy6bZr6WV7KobalnxRzyBNi4/XRXYupAI3ask6QJW6gG8ryUdTG5ys6Gh7m
         HktvbCNU3qOHce9SzgwZ9fQx2wqWLDnYDFUJ0LC51BT00o7Z+xTqeW1Wts7bMkMNd2
         XaTzkRHwMW/j1W/sv2qaUHQt3GIckbfxzw1SGpAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 056/200] KVM: x86: Keep MSR_IA32_XSS unchanged for INIT
Date:   Mon, 31 Jan 2022 11:55:19 +0100
Message-Id: <20220131105235.468652901@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit be4f3b3f82271c3193ce200a996dc70682c8e622 upstream.

It has been corrected from SDM version 075 that MSR_IA32_XSS is reset to
zero on Power up and Reset but keeps unchanged on INIT.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220126172226.2298529-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11065,6 +11065,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 		vcpu->arch.msr_misc_features_enables = 0;
 
 		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
+		vcpu->arch.ia32_xss = 0;
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
@@ -11081,8 +11082,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
 	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
 
-	vcpu->arch.ia32_xss = 0;
-
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);


