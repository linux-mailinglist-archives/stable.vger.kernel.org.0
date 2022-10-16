Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E436000D8
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJPPq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJPPqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:46:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D43033863
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0410B80CC3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1637FC433D6;
        Sun, 16 Oct 2022 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935210;
        bh=2YglQj1T6Z7hq1Yg1icx3k9YWvzPJPiRpYqjygxdJro=;
        h=Subject:To:Cc:From:Date:From;
        b=eEryMhHCjwvpkQMxOBiB5qMsuoBNU6/8zyo5kCyQ6ZY/SXPX/N7tI1EfzHZOmC3iP
         y5c8MxICGaCWh8eBIdK+DcpcpDNfz2f/LfZYET+RdOBE5VgRS9ecySHEz7OJHz//32
         Bj3wd/j3OD+X3y2q8iTnU0MiMLmwc9a9SzWWmM6Q=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:47:30 +0200
Message-ID: <1665935250113216@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

def9d705c05e ("KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02")
389ab25216c9 ("KVM: nVMX: Pull KVM L0's desired controls directly from vmcs01")
d041b5ea9335 ("KVM: nVMX: Enable nested TSC scaling")
5e3d394fdd9e ("KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING")
4e2a0bc56ad1 ("KVM: VMX: Rename NMI_PENDING to NMI_WINDOW")
9dadc2f918df ("KVM: VMX: Rename INTERRUPT_PENDING to INTERRUPT_WINDOW")
4289d2728664 ("KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers")
f399e60c45f6 ("KVM: x86: optimize more exit handlers in vmx.c")
b7ad61084842 ("tools headers kvm: Sync kvm headers with the kernel sources")
4a53d99dd0c2 ("KVM: VMX: Introduce exit reason for receiving INIT signal on guest-mode")
5497b95567c1 ("KVM: nVMX: add tracepoint for failed nested VM-Enter")
1edce0a9eb23 ("KVM: x86: Add kvm_emulate_{rd,wr}msr() to consolidate VXM/SVM code")
f20935d85a23 ("KVM: x86: Refactor up kvm_{g,s}et_msr() to simplify callers")
32d1d15c52c1 ("Merge tag 'kvmarm-5.4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

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

