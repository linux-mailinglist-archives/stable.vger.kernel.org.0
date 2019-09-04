Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C39A90D0
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389797AbfIDSLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389206AbfIDSLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 872812087E;
        Wed,  4 Sep 2019 18:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620713;
        bh=BpPuqPHxIOMgt89UJ/TXoIb3kBwQeVR8aQkQ6MGWwbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zj9LpLe72WoLGGM/ki3T/dQwOlucyfj0QZnwH312OJjkAFB1PNdT7LBRQ0LsiEIQu
         XKtUw5Is5NutdtvVDwAc+ZOQueCFg9pR8jHSvrQt1c4tZsP7P+1Iwz0h+DgqQzJuXW
         UE3A/RWPThRCBOUh5Ufm3L5bxKwtwShL/BEz7+OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 5.2 068/143] KVM: x86: hyper-v: dont crash on KVM_GET_SUPPORTED_HV_CPUID when kvm_intel.nested is disabled
Date:   Wed,  4 Sep 2019 19:53:31 +0200
Message-Id: <20190904175316.724705875@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit ea1529873ab18c204688cf31746df851c098cbea upstream.

If kvm_intel is loaded with nested=0 parameter an attempt to perform
KVM_GET_SUPPORTED_HV_CPUID results in OOPS as nested_get_evmcs_version hook
in kvm_x86_ops is NULL (we assign it in nested_vmx_hardware_setup() and
this only happens in case nested is enabled).

Check that kvm_x86_ops->nested_get_evmcs_version is not NULL before
calling it. With this, we can remove the stub from svm as it is no
longer needed.

Cc: <stable@vger.kernel.org>
Fixes: e2e871ab2f02 ("x86/kvm/hyper-v: Introduce nested_get_evmcs_version() helper")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/hyperv.c  |    5 ++++-
 arch/x86/kvm/svm.c     |    8 +-------
 arch/x86/kvm/vmx/vmx.c |    1 +
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1783,7 +1783,7 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *
 int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				struct kvm_cpuid_entry2 __user *entries)
 {
-	uint16_t evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
+	uint16_t evmcs_ver = 0;
 	struct kvm_cpuid_entry2 cpuid_entries[] = {
 		{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
 		{ .function = HYPERV_CPUID_INTERFACE },
@@ -1795,6 +1795,9 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct k
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
 
+	if (kvm_x86_ops->nested_get_evmcs_version)
+		evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
+
 	/* Skip NESTED_FEATURES if eVMCS is not supported */
 	if (!evmcs_ver)
 		--nent;
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7107,12 +7107,6 @@ failed:
 	return ret;
 }
 
-static uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
-{
-	/* Not supported */
-	return 0;
-}
-
 static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 				   uint16_t *vmcs_version)
 {
@@ -7283,7 +7277,7 @@ static struct kvm_x86_ops svm_x86_ops __
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
 	.nested_enable_evmcs = nested_enable_evmcs,
-	.nested_get_evmcs_version = nested_get_evmcs_version,
+	.nested_get_evmcs_version = NULL,
 
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 };
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7733,6 +7733,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.set_nested_state = NULL,
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
+	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 };
 


