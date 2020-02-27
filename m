Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DC21713CB
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgB0JKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:10:50 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54201 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728624AbgB0JKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:10:50 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D1B9E767;
        Thu, 27 Feb 2020 04:10:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dUEwdV
        /G17Xu3TxckUuJ37bt82qJc8yY/D4iVbVq/Gg=; b=LF3MMkPIM9w47+ahDELgqp
        ydlur1A88Wb8nIyvjyte8nO3RpvKbUWFGlwJg3Yc3vxUIyv5g7/lBw1L2c8QSa5o
        DJ+0Kw7ASbgebKul1tsp7rydljEOFCcd39zaA1AJxopwHBehLOtMTgqhaQrH5DbU
        Xs95qY2YlnjitdADokSH9QM33Pc1Fi4A10lZ+tLXd6p6CroDqg1G+a1M2AKidWCF
        vWQHvrswDEeo0SDEJhi2e6smm1fZbaF73luRjMlCeNzc/ISuqRcZgobT0hq0wUBh
        UoZaGKhJoVFBOsF6uESVkEvCSccChVZorkM9QY4GoXHflnz4m4wfkq9KsQfv1ZFA
        ==
X-ME-Sender: <xms:mIdXXqXABicUtFWEXK_ThDmvHrM3s3w9YHmhfY7QuZHFksbo31O7TA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mIdXXudOu3fPnikOtFSiewSlU4Jylv0tvDZy1qVnsvD9IxEwDGyo2Q>
    <xmx:mIdXXtyBSwbNiXmxvVyfdKDPDZt0KQZaWm7Szugt-lYv9w7qador_Q>
    <xmx:mIdXXpF68xeAxDsSkQ3Pmf8s2XSktVtrymMUTE5ZVZhA9IWJV9nSQQ>
    <xmx:mIdXXnb63lLT3fvBmfvMzyU0uaw84XaCRxoo_yOsVPVDY6FHE0figg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF61E328005D;
        Thu, 27 Feb 2020 04:10:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested" failed to apply to 4.4-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:10:17 +0100
Message-ID: <158279461791163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

