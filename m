Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABAD1713C9
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgB0JKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:10:46 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:33429 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728655AbgB0JKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:10:46 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id E175E776;
        Thu, 27 Feb 2020 04:10:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:10:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WKhnyJ
        NSdxS1PR0Lq4O8j6OG9h3S2STY1jkX+QNEUL4=; b=oSJsxLHDNNySUEd0Mdosl4
        cwL5iuTCgFPVVH/vz20BPb7NuqxPBuUzk245xkc7VZcRHd0Ec3OdvE3bns4wG8S1
        9qapThog5LeiWJNgTL/EsRT9JNG+ptj+smqBdJNvw2Xq/y+qbWuyZtEmTQ9hUJ5z
        sCf7D3N7IG9f9WViYfK2T+XdlVrZabC7b2TLJZmggMbSMonk0IVQ/ECJl0wskiNd
        XAIgLpE38oMiPsX3oVaR5iLM9z3gjXgmpkeGT3ueat8u7ceCZWDwpAzXBh03K3FX
        tV6JXbF2K8S0aKXAPuY99aCpe8dw9ha2V75Ymiuql/U7xyiPeArSIndwL58QovCA
        ==
X-ME-Sender: <xms:lIdXXkU89nCkjseDl9-5HEsjymiLLMG27ynJBkiB2kSYTQVXMWoZhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lIdXXjStRpc0mNV_cfNKhW86sT46dGpCtmrj2Gt54NN6q9Gzgpg3lg>
    <xmx:lIdXXhFBJlqrxMMfiUKkdMDryzEEkjCXr0VMR2V6JILK5b5iCgR4VA>
    <xmx:lIdXXqecYDTGenNhq_9CPeKjEcfFaHszjUqf-AW6h242fn_i3nbciA>
    <xmx:lIdXXrl2WCCjiQhOkBvqtgZsqX2nqbNIfWabRN9HM6vuXLdFiOWeNg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 107B43280064;
        Thu, 27 Feb 2020 04:10:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested" failed to apply to 4.9-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:10:16 +0100
Message-ID: <158279461624172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a4443267800af240072280c44521caab61924e55 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 20 Feb 2020 18:22:04 +0100
Subject: [PATCH] KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested
 pinbased_ctls only when apicv is globally disabled

When apicv is disabled on a vCPU (e.g. by enabling KVM_CAP_HYPERV_SYNIC*),
nothing happens to VMX MSRs on the already existing vCPUs, however, all new
ones are created with PIN_BASED_POSTED_INTR filtered out. This is very
confusing and results in the following picture inside the guest:

$ rdmsr -ax 0x48d
ff00000016
7f00000016
7f00000016
7f00000016

This is observed with QEMU and 4-vCPU guest: QEMU creates vCPU0, does
KVM_CAP_HYPERV_SYNIC2 and then creates the remaining three.

L1 hypervisor may only check CPU0's controls to find out what features
are available and it will be very confused later. Switch to setting
PIN_BASED_POSTED_INTR control based on global 'enable_apicv' setting.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 283bdb7071af..f486e2606247 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -12,6 +12,7 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
+extern bool __read_mostly enable_apicv;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a5757b0b80f9..2b3ba7d27be4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5949,8 +5949,7 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void)
  * bit in the high half is on if the corresponding bit in the control field
  * may be on. See also vmx_control_verify().
  */
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
-				bool apicv)
+void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 {
 	/*
 	 * Note that as a general rule, the high half of the MSRs (bits in
@@ -5977,7 +5976,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 		PIN_BASED_EXT_INTR_MASK |
 		PIN_BASED_NMI_EXITING |
 		PIN_BASED_VIRTUAL_NMIS |
-		(apicv ? PIN_BASED_POSTED_INTR : 0);
+		(enable_apicv ? PIN_BASED_POSTED_INTR : 0);
 	msrs->pinbased_ctls_high |=
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
 		PIN_BASED_VMX_PREEMPTION_TIMER;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index fc874d4ead0f..1c5fbff45d69 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -17,8 +17,7 @@ enum nvmx_vmentry_status {
 };
 
 void vmx_leave_nested(struct kvm_vcpu *vcpu);
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
-				bool apicv);
+void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
 void nested_vmx_hardware_unsetup(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63ccc435a602..404dafedd778 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -95,7 +95,7 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
-static bool __read_mostly enable_apicv = 1;
+bool __read_mostly enable_apicv = 1;
 module_param(enable_apicv, bool, S_IRUGO);
 
 /*
@@ -6769,8 +6769,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
-					   vmx_capability.ept,
-					   kvm_vcpu_apicv_active(vcpu));
+					   vmx_capability.ept);
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
@@ -6851,8 +6850,7 @@ static int __init vmx_check_processor_compat(void)
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
 		return -EIO;
 	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept,
-					   enable_apicv);
+		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
 		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
 				smp_processor_id());
@@ -7714,7 +7712,7 @@ static __init int hardware_setup(void)
 
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
-					   vmx_capability.ept, enable_apicv);
+					   vmx_capability.ept);
 
 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
 		if (r)

