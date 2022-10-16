Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F626000D5
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJPPqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJPPqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0932C657
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27A6760C05
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B35C433C1;
        Sun, 16 Oct 2022 15:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935201;
        bh=7TaIbUci5xMAgUl15KmojZxHb6pWz0h3Gr/fF5oM3Zw=;
        h=Subject:To:Cc:From:Date:From;
        b=mO2nRN6jFJcGDfPYZJfVBCkQIX/2DNZ8aOQhErhI8PgrllOoS6yrNauoQJerIN66w
         P1nwCjQo3BSCHofIeHqXK3OtpNNF4RrC67HwKQVBKVwxRaAKb8JesLC+ShEyt1Stm2
         q59lVGQ2vrgs1AHfRlX3MU8gUDzw+jemZimbYU/U=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:47:27 +0200
Message-ID: <1665935247137223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

def9d705c05e ("KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02")
389ab25216c9 ("KVM: nVMX: Pull KVM L0's desired controls directly from vmcs01")
d041b5ea9335 ("KVM: nVMX: Enable nested TSC scaling")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From def9d705c05eab3fdedeb10ad67907513b12038e Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Aug 2022 15:37:21 +0200
Subject: [PATCH] KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings
 to vmcs02

Don't propagate vmcs12's VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL to vmcs02.
KVM doesn't disallow L1 from using VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
even when KVM itself doesn't use the control, e.g. due to the various
CPU errata that where the MSR can be corrupted on VM-Exit.

Preserve KVM's (vmcs01) setting to hopefully avoid having to toggle the
bit in vmcs02 at a later point.  E.g. if KVM is loading PERF_GLOBAL_CTRL
when running L1, then odds are good KVM will also load the MSR when
running L2.

Fixes: 8bf00a529967 ("KVM: VMX: add support for switching of PERF_GLOBAL_CTRL")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20220830133737.1539624-18-vkuznets@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1743319015b7..400e015afa64 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2359,9 +2359,14 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	 * are emulated by vmx_set_efer() in prepare_vmcs02(), but speculate
 	 * on the related bits (if supported by the CPU) in the hope that
 	 * we can avoid VMWrites during vmx_set_efer().
+	 *
+	 * Similarly, take vmcs01's PERF_GLOBAL_CTRL in the hope that if KVM is
+	 * loading PERF_GLOBAL_CTRL via the VMCS for L1, then KVM will want to
+	 * do the same for L2.
 	 */
 	exec_control = __vm_entry_controls_get(vmcs01);
-	exec_control |= vmcs12->vm_entry_controls;
+	exec_control |= (vmcs12->vm_entry_controls &
+			 ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
 	exec_control &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_LOAD_IA32_EFER);
 	if (cpu_has_load_ia32_efer()) {
 		if (guest_efer & EFER_LMA)

