Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E2E591252
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 16:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbiHLOfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 10:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiHLOfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 10:35:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A06FCB
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 07:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44AC6B82378
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FB2C433C1;
        Fri, 12 Aug 2022 14:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660314912;
        bh=m9CJsWhf42/HHeirjZgWHltNR6+AKVZIqnQ5Q0+waP8=;
        h=Subject:To:Cc:From:Date:From;
        b=sIDhE7xucBKliUDMwV0gp2YG2oC3fq4VNEr2AvW7bFessaLoFMUmkOT5yrfqBqIhp
         VL6OyNtTNBdRFe6WW9OGrlCWpDWV5D/J3YFN8R5mLUZjkYyhAlnoOuKrfKWIy5MoJC
         hhd+qAriqIsp/f5V7Hp2XUZgsGLMM11zjnvQQuN0=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Account for KVM reserved CR4 bits in consistency" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Aug 2022 16:35:09 +0200
Message-ID: <166031490970186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca58f3aa53d165afe4ab74c755bc2f6d168617ac Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 7 Jun 2022 21:35:51 +0000
Subject: [PATCH] KVM: nVMX: Account for KVM reserved CR4 bits in consistency
 checks

Check that the guest (L2) and host (L1) CR4 values that would be loaded
by nested VM-Enter and VM-Exit respectively are valid with respect to
KVM's (L0 host) allowed CR4 bits.  Failure to check KVM reserved bits
would allow L1 to load an illegal CR4 (or trigger hardware VM-Fail or
failed VM-Entry) by massaging guest CPUID to allow features that are not
supported by KVM.  Amusingly, KVM itself is an accomplice in its doom, as
KVM adjusts L1's MSR_IA32_VMX_CR4_FIXED1 to allow L1 to enable bits for
L2 based on L1's CPUID model.

Note, although nested_{guest,host}_cr4_valid() are _currently_ used if
and only if the vCPU is post-VMXON (nested.vmxon == true), that may not
be true in the future, e.g. emulating VMXON has a bug where it doesn't
check the allowed/required CR0/CR4 bits.

Cc: stable@vger.kernel.org
Fixes: 3899152ccbf4 ("KVM: nVMX: fix checks on CR{0,4} during virtual VMX operation")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220607213604.3346000-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c92cea0b8ccc..129ae4e01f7c 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -281,7 +281,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	u64 fixed0 = to_vmx(vcpu)->nested.msrs.cr4_fixed0;
 	u64 fixed1 = to_vmx(vcpu)->nested.msrs.cr4_fixed1;
 
-	return fixed_bits_valid(val, fixed0, fixed1);
+	return fixed_bits_valid(val, fixed0, fixed1) &&
+	       __kvm_is_valid_cr4(vcpu, val);
 }
 
 /* No difference in the restrictions on guest and host CR4 in VMX operation. */

