Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF735EA500
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiIZL47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbiIZLzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:55:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B5079A44;
        Mon, 26 Sep 2022 03:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2A4BB80954;
        Mon, 26 Sep 2022 10:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEF5C433D6;
        Mon, 26 Sep 2022 10:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188673;
        bh=o1ieDuvPKq+cO2ZvqSA7F+mCLGrZYaQlZxA++JjjbX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Umg8DpXjmwSASS57GGL6VHz3niw6pP7Fh6XA/38sF1eP/XvcNoG8qnkg6xRFrcLIw
         f4aZRKq22LMn3CVObrB4hzgGSkm6iYHHz7JXYBGcolK84DY2aime5daU2d0dVayoYb
         upnQelpqnx2tVouPkAo8swLt/L42k25P7Tb9vjp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 052/148] KVM: x86: Inject #UD on emulated XSETBV if XSAVES isnt enabled
Date:   Mon, 26 Sep 2022 12:11:26 +0200
Message-Id: <20220926100757.978247637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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

commit 50b2d49bafa16e6311ab2da82f5aafc5f9ada99b upstream.

Inject #UD when emulating XSETBV if CR4.OSXSAVE is not set.  This also
covers the "XSAVE not supported" check, as setting CR4.OSXSAVE=1 #GPs if
XSAVE is not supported (and userspace gets to keep the pieces if it
forces incoherent vCPU state).

Add a comment to kvm_emulate_xsetbv() to call out that the CPU checks
CR4.OSXSAVE before checking for intercepts.  AMD'S APM implies that #UD
has priority (says that intercepts are checked before #GP exceptions),
while Intel's SDM says nothing about interception priority.  However,
testing on hardware shows that both AMD and Intel CPUs prioritize the #UD
over interception.

Fixes: 02d4160fbd76 ("x86: KVM: add xsetbv to the emulator")
Cc: stable@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220824033057.3576315-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    3 +++
 arch/x86/kvm/x86.c     |    1 +
 2 files changed, 4 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4122,6 +4122,9 @@ static int em_xsetbv(struct x86_emulate_
 {
 	u32 eax, ecx, edx;
 
+	if (!(ctxt->ops->get_cr(ctxt, 4) & X86_CR4_OSXSAVE))
+		return emulate_ud(ctxt);
+
 	eax = reg_read(ctxt, VCPU_REGS_RAX);
 	edx = reg_read(ctxt, VCPU_REGS_RDX);
 	ecx = reg_read(ctxt, VCPU_REGS_RCX);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1021,6 +1021,7 @@ static int __kvm_set_xcr(struct kvm_vcpu
 
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
+	/* Note, #UD due to CR4.OSXSAVE=0 has priority over the intercept. */
 	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
 	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
 		kvm_inject_gp(vcpu, 0);


