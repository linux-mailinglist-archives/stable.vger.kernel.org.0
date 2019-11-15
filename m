Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7155FD606
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfKOGVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbfKOGVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:44 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D3A2053B;
        Fri, 15 Nov 2019 06:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798903;
        bh=ckjz2sH+WQCTRB2ZN/hdfAWhy/glRwsrLRvWIaMcn+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4vsBGFUGZ/EcLdkvRVdsSanz1CpHAYiTsKmhJ9BJJAeVgj6KVeMRRk7VmTd9Vrxj
         2EecfbaaJRQ6b4kXz4M0S1m/3Stl2WydSWmXYKv+ruFcLCa+o3knRSFNSmgUipzHiR
         N5bfx0x44U5ZxIUUE9k8J2mm7Jd8/J/P/MYS2v20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 06/20] KVM: Introduce kvm_get_arch_capabilities()
Date:   Fri, 15 Nov 2019 14:20:35 +0800
Message-Id: <20191115062010.043596165@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

Extracted from commit 5b76a3cff011 "KVM: VMX: Tell the nested
hypervisor to skip L1D flush on vmentry".  We will need this to let a
nested hypervisor know that we have applied the mitigation for TAA.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx.c              |    3 +--
 arch/x86/kvm/x86.c              |   10 ++++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1226,6 +1226,7 @@ void kvm_vcpu_reload_apic_access_page(st
 void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 					   unsigned long address);
 
+u64 kvm_get_arch_capabilities(void);
 void kvm_define_shared_msr(unsigned index, u32 msr);
 int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5079,8 +5079,7 @@ static int vmx_vcpu_setup(struct vcpu_vm
 		++vmx->nmsrs;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, vmx->arch_capabilities);
+	vmx->arch_capabilities = kvm_get_arch_capabilities();
 
 	vm_exit_controls_init(vmx, vmcs_config.vmexit_ctrl);
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -995,6 +995,16 @@ static u32 emulated_msrs[] = {
 
 static unsigned num_emulated_msrs;
 
+u64 kvm_get_arch_capabilities(void)
+{
+	u64 data;
+
+	rdmsrl_safe(MSR_IA32_ARCH_CAPABILITIES, &data);
+
+	return data;
+}
+EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
+
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	if (efer & EFER_FFXSR) {


