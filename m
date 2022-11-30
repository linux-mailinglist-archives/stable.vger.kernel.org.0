Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF07163E00F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiK3SxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiK3SxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C76E0A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C327B61D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FF8C433D7;
        Wed, 30 Nov 2022 18:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834378;
        bh=lZ8IV3RGQVMuKf/P2TSW30SoHqygVejhggepNHHuK8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q09j3Rt6Gqoibpz4DT0y3tKNg2efc9SEDjX205HCXJ8CRSQxg0zW5ZsNej7yI4vLn
         zQj+Wia9uuQGxRuQvcIQjeJY/Xdj2rDETh14AFE7900bBkExxyTpwGmahhTjLOGdDX
         9jEUj++GpogMxCLlRz9OHzK4S3EGDPQfc0Qf8M6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>, stable@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 204/289] KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
Date:   Wed, 30 Nov 2022 19:23:09 +0100
Message-Id: <20221130180548.744269853@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit c2b8cdfaf3a6721afe0c8c060a631b1c67a7f1ee upstream.

There are almost no hypercalls which are valid from CPL > 0, and definitely
none which are handled by the kernel.

Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
Reported-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: stable@kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1216,6 +1216,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *v
 	bool longmode;
 	u64 input, params[6], r = -ENOSYS;
 	bool handled = false;
+	u8 cpl;
 
 	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
 
@@ -1243,9 +1244,17 @@ int kvm_xen_hypercall(struct kvm_vcpu *v
 		params[5] = (u64)kvm_r9_read(vcpu);
 	}
 #endif
+	cpl = static_call(kvm_x86_get_cpl)(vcpu);
 	trace_kvm_xen_hypercall(input, params[0], params[1], params[2],
 				params[3], params[4], params[5]);
 
+	/*
+	 * Only allow hypercall acceleration for CPL0. The rare hypercalls that
+	 * are permitted in guest userspace can be handled by the VMM.
+	 */
+	if (unlikely(cpl > 0))
+		goto handle_in_userspace;
+
 	switch (input) {
 	case __HYPERVISOR_xen_version:
 		if (params[0] == XENVER_version && vcpu->kvm->arch.xen.xen_version) {
@@ -1280,10 +1289,11 @@ int kvm_xen_hypercall(struct kvm_vcpu *v
 	if (handled)
 		return kvm_xen_hypercall_set_result(vcpu, r);
 
+handle_in_userspace:
 	vcpu->run->exit_reason = KVM_EXIT_XEN;
 	vcpu->run->xen.type = KVM_EXIT_XEN_HCALL;
 	vcpu->run->xen.u.hcall.longmode = longmode;
-	vcpu->run->xen.u.hcall.cpl = static_call(kvm_x86_get_cpl)(vcpu);
+	vcpu->run->xen.u.hcall.cpl = cpl;
 	vcpu->run->xen.u.hcall.input = input;
 	vcpu->run->xen.u.hcall.params[0] = params[0];
 	vcpu->run->xen.u.hcall.params[1] = params[1];


