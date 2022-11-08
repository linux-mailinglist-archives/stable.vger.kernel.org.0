Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3256214D5
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiKHOFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbiKHOFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB8769DF6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C446611B7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F4EC433C1;
        Tue,  8 Nov 2022 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916330;
        bh=MmJKBwKRu/sOTpdsrFP40oo3p0TYGlzgmB3Aps1xZHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuuKOJfdfSYS99oLylaOmYlbQ7ZzS+7mrCPrq4sMK1gAUBUYZx0Y7QspepIvPUd2F
         F0aXzFAbeon5HCN2spaLyZCvhE6w1eNIVATUOKuwwHD9pqvD32GTpMDdNB+vGG+KDb
         LeiOAXLmXjatimS7QYSQlzVJem/vna+NMsODH478=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Bandan Das <bsd@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 131/144] KVM: VMX: fully disable SGX if SECONDARY_EXEC_ENCLS_EXITING unavailable
Date:   Tue,  8 Nov 2022 14:40:08 +0100
Message-Id: <20221108133350.811570403@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
@@ -7902,6 +7902,11 @@ static __init int hardware_setup(void)
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


