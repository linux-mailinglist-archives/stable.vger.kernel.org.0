Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227286215CF
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbiKHOPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiKHOPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E8F686BE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A05836157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D244C433C1;
        Tue,  8 Nov 2022 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916935;
        bh=XNxj8AD1dG4L1RW2GQ/TJ3uVfJHczJvqruxEQVwPY6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKumSm7bVLzCciBU0VXfhwFpXFOjRsbyHsGM+pITCwdim89A3ml/szbI9nUEwHEIh
         0Ot3JIMwr55O8wQrWVs0DxuT+bG1JsM55itLs/duP/+63nyi7osBRUvtoEiuJtw5r+
         LgQ++fl6nlsYunEbxxFG5xC4giWwz3aUfXxNuJ3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Bandan Das <bsd@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 178/197] KVM: VMX: fully disable SGX if SECONDARY_EXEC_ENCLS_EXITING unavailable
Date:   Tue,  8 Nov 2022 14:40:16 +0100
Message-Id: <20221108133403.012233398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Emanuele Giuseppe Esposito <eesposit@redhat.com>

commit 1c1a41497ab879ac9608f3047f230af833eeef3d upstream.

Clear enable_sgx if ENCLS-exiting is not supported, i.e. if SGX cannot be
virtualized.  When KVM is loaded, adjust_vmx_controls checks that the
bit is available before enabling the feature; however, other parts of the
code check enable_sgx and not clearing the variable caused two different
bugs, mostly affecting nested virtualization scenarios.

First, because enable_sgx remained true, SECONDARY_EXEC_ENCLS_EXITING
would be marked available in the capability MSR that are accessed by a
nested hypervisor.  KVM would then propagate the control from vmcs12
to vmcs02 even if it isn't supported by the processor, thus causing an
unexpected VM-Fail (exit code 0x7) in L1.

Second, vmx_set_cpu_caps() would not clear the SGX bits when hardware
support is unavailable.  This is a much less problematic bug as it only
happens if SGX is soft-disabled (available in the processor but hidden
in CPUID) or if SGX is supported for bare metal but not in the VMCS
(will never happen when running on bare metal, but can theoertically
happen when running in a VM).

Last but not least, this ensures that module params in sysfs reflect
KVM's actual configuration.

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2127128
Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-Id: <20221025123749.2201649-1-eesposit@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8281,6 +8281,11 @@ static __init int hardware_setup(void)
 	if (!cpu_has_virtual_nmis())
 		enable_vnmi = 0;
 
+#ifdef CONFIG_X86_SGX_KVM
+	if (!cpu_has_vmx_encls_vmexit())
+		enable_sgx = false;
+#endif
+
 	/*
 	 * set_apic_access_page_addr() is used to reload apic access
 	 * page upon invalidation.  No need to do anything if not


