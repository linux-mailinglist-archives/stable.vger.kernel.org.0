Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1655EA511
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbiIZL5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbiIZL4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:56:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195C879EE3;
        Mon, 26 Sep 2022 03:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B768AB80942;
        Mon, 26 Sep 2022 10:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2D8C433D7;
        Mon, 26 Sep 2022 10:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189097;
        bh=2uQhA0qYWotVtBUvYwcPC6h3qGMu2lnXzqUK+uwfSxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6Vx4gZZlCMrzzzY2emeo7Yl6XK/gYGDGq3B62eoQPShMB1TihlmzDrHKGiuN6I8z
         dkS2+169X5Ds/hFLCGo3x+GrIptJnIRXoqhvNIKuT1vh1mJnjL7URIG/78FrUuY57K
         HtM79mFSw94FPS0seEvgFb5qNkkLLVVGE+WJf6qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 065/207] KVM: x86: Always enable legacy FP/SSE in allowed user XFEATURES
Date:   Mon, 26 Sep 2022 12:10:54 +0200
Message-Id: <20220926100809.511013321@linuxfoundation.org>
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

From: Dr. David Alan Gilbert <dgilbert@redhat.com>

commit a1020a25e69755a8a1a37735d674b91d6f02939f upstream.

Allow FP and SSE state to be saved and restored via KVM_{G,SET}_XSAVE on
XSAVE-capable hosts even if their bits are not exposed to the guest via
XCR0.

Failing to allow FP+SSE first showed up as a QEMU live migration failure,
where migrating a VM from a pre-XSAVE host, e.g. Nehalem, to an XSAVE
host failed due to KVM rejecting KVM_SET_XSAVE.  However, the bug also
causes problems even when migrating between XSAVE-capable hosts as
KVM_GET_SAVE won't set any bits in user_xfeatures if XSAVE isn't exposed
to the guest, i.e. KVM will fail to actually migrate FP+SSE.

Because KVM_{G,S}ET_XSAVE are designed to allowing migrating between
hosts with and without XSAVE, KVM_GET_XSAVE on a non-XSAVE (by way of
fpu_copy_guest_fpstate_to_uabi()) always sets the FP+SSE bits in the
header so that KVM_SET_XSAVE will work even if the new host supports
XSAVE.

Fixes: ad856280ddea ("x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0")
bz: https://bugzilla.redhat.com/show_bug.cgi?id=2079311
Cc: stable@vger.kernel.org
Cc: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
[sean: add comment, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220824033057.3576315-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -297,7 +297,13 @@ static void kvm_vcpu_after_set_cpuid(str
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
+	/*
+	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
+	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
+	 * supported by the host.
+	 */
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0 |
+						       XFEATURE_MASK_FPSSE;
 
 	kvm_update_pv_runtime(vcpu);
 


