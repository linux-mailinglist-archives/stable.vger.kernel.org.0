Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A96156A87
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBINIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:08:49 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36333 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727682AbgBINIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:08:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 73B1B21EAF;
        Sun,  9 Feb 2020 08:08:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:08:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OHz+2b
        ubBArussOz2rYXrcZ6i8rnSdc4dZATuAm6YmQ=; b=bsfkwc7YyVRolQUMAuMv2F
        zAGb1eytGFO7Iu502w8LmZx9prv3jWcKCjGX0z+hhCB45+9Xw+q270rLjPdm5WfG
        21gqcdZytOjvr1dEBozskGcMSjXywtAYPfytB7Ap2K44D4ArcOct/jBgtN+M6RhM
        CQyBuYhHgd+rG+q8IzODRivNzd4oBYnSnP/acD0IJYhy9vPMwOVkGSBB43Jpd1lt
        +vYz9ocvg8umQar9Epa3cwAHe3I6QDmPhYdOZJlDG3n8793Yl91xlBXEwzDKgT2o
        ciG1BybcpMy7aUa0q1fOHXHVx6qXPfdmQs7UxYaArs4GyLqesO8TdJAdlmqrdUOA
        ==
X-ME-Sender: <xms:YARAXheXOxPdE2LJh3iX9B1XRcrn67gv8v0M9937y3GLiG8MwdYz6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudekne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YARAXhdK3ut8-gTEGl35eGV18n29nprNUd7eBzwXVTDxzxniP2Q6rA>
    <xmx:YARAXqOH-w-auQR7SGO3RKx5WAat_CVGkrBwuDRpYMAGDleCjVhnkA>
    <xmx:YARAXnqYeoCXGl7QPbxQySODW2pDgp6EoWdGVmxQPvVPOq-FFsxaEQ>
    <xmx:YARAXnSCzt18DyEuY9MLb2nlseThApct036nUmWNDNWkmxRP7QCh1Q>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id A70C53280064;
        Sun,  9 Feb 2020 08:08:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX" failed to apply to 4.14-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:22:44 +0100
Message-ID: <158125096467128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f958bd2314d117f8c29f4821401bc1925bc2e5ef Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Mon, 9 Dec 2019 12:19:31 -0800
Subject: [PATCH] KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX
 platform

Unlike most state managed by XSAVE, MPX is initialized to zero on INIT.
Because INITs are usually recognized in the context of a VCPU_RUN call,
kvm_vcpu_reset() puts the guest's FPU so that the FPU state is resident
in memory, zeros the MPX state, and reloads FPU state to hardware.  But,
in the unlikely event that an INIT is recognized during
kvm_arch_vcpu_ioctl_get_mpstate() via kvm_apic_accept_events(),
kvm_vcpu_reset() will call kvm_put_guest_fpu() without a preceding
kvm_load_guest_fpu() and corrupt the guest's FPU state (and possibly
userspace's FPU state as well).

Given that MPX is being removed from the kernel[*], fix the bug with the
simple-but-ugly approach of loading the guest's FPU during
KVM_GET_MP_STATE.

[*] See commit f240652b6032b ("x86/mpx: Remove MPX APIs").

Fixes: f775b13eedee2 ("x86,kvm: move qemu/guest FPU switching out to vcpu_run")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3051324f72d3..0af5cb637bea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8714,6 +8714,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
 	vcpu_load(vcpu);
+	if (kvm_mpx_supported())
+		kvm_load_guest_fpu(vcpu);
 
 	kvm_apic_accept_events(vcpu);
 	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
@@ -8722,6 +8724,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 	else
 		mp_state->mp_state = vcpu->arch.mp_state;
 
+	if (kvm_mpx_supported())
+		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);
 	return 0;
 }

