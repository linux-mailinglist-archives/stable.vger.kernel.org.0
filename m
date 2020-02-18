Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598391621FF
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 09:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgBRIFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 03:05:18 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42769 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbgBRIFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 03:05:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4A7AE67A;
        Tue, 18 Feb 2020 03:05:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 18 Feb 2020 03:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fuvMN5
        AvXr7MFbSS9FCxsSeUq1sD+OyW4KJ8/mnw5y8=; b=aMLA0mjSEbaFanBiqD7BVj
        7gBuyIK+sUgNpQbD1Yn/juhMM2EDHWFQjq+bRos24lZhv0qIyPz99qTvHjFNtIfF
        vvOrP/HaZyqhHcdYCwf2il774ZRQN7VKm6tq+K/WQbcViUBDNj780Wz1z+I9zIXl
        r8lWbnlAozI71snVKFnupHK3dr9lAzdbHkAeMYth8XYyMgIBIVOLWTq3946SexJV
        eosinhQVEB9iyn2HuPG18O4wVpuBnPCwqWFmhh4wtTyryN1zl5Fl2zk+ODhxTbkx
        2+b/uR8dwEkifcloSelcYNycg8K7timenpcIbZi0Ija7r+V1tScR7ilv+UnG+pRg
        ==
X-ME-Sender: <xms:vJpLXuhuf5z2Pp_GeuLaKBkbuh2bztEOhW3I_s_oZGJpk5wNYMaraQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeejgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpegvgigtvghpthhiohhnrdhnrhenucfkphepkeefrdekiedrke
    elrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vJpLXjSe6y4LcD01aTSPhpmeVinNTu4gDY1hw4zYJOREwn0SbR_Vqg>
    <xmx:vJpLXhEBEFyR_O-HsN9-YjveB5plucxlO0senvD8UIv71UGWt_i-_A>
    <xmx:vJpLXrnDcFzn7uW_ExK-vQzloyv6ZqjnHpg4J60DQQoF_a6UWkkMiA>
    <xmx:vJpLXmHxiQbErJt2XKvhSzZ9X_0p0aopY7ZeDWc5nRDKeKyXrB_zQg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4085F3280062;
        Tue, 18 Feb 2020 03:05:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Handle pending #DB when injecting INIT VM-exit" failed to apply to 5.4-stable tree
To:     oupton@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Feb 2020 09:05:14 +0100
Message-ID: <1582013114182227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 684c0422da71da0cd81319c90b8099b563b13da4 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oupton@google.com>
Date: Fri, 7 Feb 2020 02:36:05 -0800
Subject: [PATCH] KVM: nVMX: Handle pending #DB when injecting INIT VM-exit

SDM 27.3.4 states that the 'pending debug exceptions' VMCS field will
be populated if a VM-exit caused by an INIT signal takes priority over a
debug-trap. Emulate this behavior when synthesizing an INIT signal
VM-exit into L1.

Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 657c2eda357c..1586aaae3a6f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3575,6 +3575,33 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 	nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI, intr_info, exit_qual);
 }
 
+/*
+ * Returns true if a debug trap is pending delivery.
+ *
+ * In KVM, debug traps bear an exception payload. As such, the class of a #DB
+ * exception may be inferred from the presence of an exception payload.
+ */
+static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.exception.pending &&
+			vcpu->arch.exception.nr == DB_VECTOR &&
+			vcpu->arch.exception.payload;
+}
+
+/*
+ * Certain VM-exits set the 'pending debug exceptions' field to indicate a
+ * recognized #DB (data or single-step) that has yet to be delivered. Since KVM
+ * represents these debug traps with a payload that is said to be compatible
+ * with the 'pending debug exceptions' field, write the payload to the VMCS
+ * field if a VM-exit is delivered before the debug trap.
+ */
+static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
+{
+	if (vmx_pending_dbg_trap(vcpu))
+		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+			    vcpu->arch.exception.payload);
+}
+
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3587,6 +3614,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
 			return -EBUSY;
+		nested_vmx_update_pending_dbg(vcpu);
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
 		return 0;

