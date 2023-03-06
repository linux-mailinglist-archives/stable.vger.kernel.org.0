Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029F46AC7B0
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 17:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCFQWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 11:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCFQVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 11:21:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B053126F2
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 08:19:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE83DB80F2B
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 16:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475D6C433D2;
        Mon,  6 Mar 2023 16:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678118967;
        bh=UDFMEh8Uvg8WQd+HnpqcMtXGbn+5aAzzzAPnoRMWAVc=;
        h=Subject:To:Cc:From:Date:From;
        b=g5hw9nTp8MdOww8zw57VdqBatn6wbxVN9soqySqYoLJ9S6Kn7L+aiDIV0Ulr2ci3j
         oXUQG1W4+vY5mIv9JIERrAsO3pmRszGJ8Uyb4N1RywSekZv/kP5ao6z9nOYZVn/r51
         zKZHCDhYaF+GLo3NkvmWmsrH9DJSA+zq8K+6+daA=
Subject: FAILED: patch "[PATCH] KVM: VMX: Do _all_ initialization before exposing /dev/kvm to" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 17:09:14 +0100
Message-ID: <167811895425359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x e32b120071ea114efc0b4ddd439547750b85f618
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167811895425359@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace")
4f8396b96a9f ("KVM: x86: Move guts of kvm_arch_init() to standalone helper")
da66de44b01e ("KVM: VMX: Don't bother disabling eVMCS static key on module exit")
2916b70fc342 ("KVM: VMX: Reset eVMCS controls in VP assist page during hardware disabling")
94bda2f4cd86 ("KVM: x86: Reject loading KVM if host.PAT[0] != WB")
fdc298da8661 ("KVM: x86: Move kvm_ops_static_call_update() to x86.c")
5e17b2ee45b9 ("kvm: x86: Require const tsc for RT")
925088781eed ("KVM: x86: Fix pointer mistmatch warning when patching RET0 static calls")
5be2226f417d ("KVM: x86: allow defining return-0 static calls")
abb6d479e226 ("KVM: x86: make several APIC virtualization callbacks optional")
dd2319c61888 ("KVM: x86: warn on incorrectly NULL members of kvm_x86_ops")
e4fc23bad813 ("KVM: x86: remove KVM_X86_OP_NULL and mark optional kvm_x86_ops")
8a2897853c53 ("KVM: x86: return 1 unconditionally for availability of KVM_CAP_VAPIC")
db6e7adf8de9 ("KVM: SVM: Rename AVIC helpers to use "avic" prefix instead of "svm"")
4e71cad31c62 ("Merge remote-tracking branch 'kvm/master' into HEAD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e32b120071ea114efc0b4ddd439547750b85f618 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:08:58 +0000
Subject: [PATCH] KVM: VMX: Do _all_ initialization before exposing /dev/kvm to
 userspace

Call kvm_init() only after _all_ setup is complete, as kvm_init() exposes
/dev/kvm to userspace and thus allows userspace to create VMs (and call
other ioctls).  E.g. KVM will encounter a NULL pointer when attempting to
add a vCPU to the per-CPU loaded_vmcss_on_cpu list if userspace is able to
create a VM before vmx_init() configures said list.

 BUG: kernel NULL pointer dereference, address: 0000000000000008
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 0 P4D 0
 Oops: 0002 [#1] SMP
 CPU: 6 PID: 1143 Comm: stable Not tainted 6.0.0-rc7+ #988
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 RIP: 0010:vmx_vcpu_load_vmcs+0x68/0x230 [kvm_intel]
  <TASK>
  vmx_vcpu_load+0x16/0x60 [kvm_intel]
  kvm_arch_vcpu_load+0x32/0x1f0 [kvm]
  vcpu_load+0x2f/0x40 [kvm]
  kvm_arch_vcpu_create+0x231/0x310 [kvm]
  kvm_vm_ioctl+0x79f/0xe10 [kvm]
  ? handle_mm_fault+0xb1/0x220
  __x64_sys_ioctl+0x80/0xb0
  do_syscall_64+0x2b/0x50
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x7f5a6b05743b
  </TASK>
 Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel(+) kvm irqbypass

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221130230934.1014142-15-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1e2eab6bda16..e0e3f2c1f681 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8564,19 +8564,23 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
+static void __vmx_exit(void)
 {
+	allow_smaller_maxphyaddr = false;
+
 #ifdef CONFIG_KEXEC_CORE
 	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
 #endif
+	vmx_cleanup_l1d_flush();
+}
 
+static void vmx_exit(void)
+{
 	kvm_exit();
 	kvm_x86_vendor_exit();
 
-	vmx_cleanup_l1d_flush();
-
-	allow_smaller_maxphyaddr = false;
+	__vmx_exit();
 }
 module_exit(vmx_exit);
 
@@ -8594,11 +8598,6 @@ static int __init vmx_init(void)
 	if (r)
 		return r;
 
-	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
-		     __alignof__(struct vcpu_vmx), THIS_MODULE);
-	if (r)
-		goto err_kvm_init;
-
 	/*
 	 * Must be called after common x86 init so enable_ept is properly set
 	 * up. Hand the parameter mitigation value in which was stored in
@@ -8632,11 +8631,20 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
+		     __alignof__(struct vcpu_vmx), THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
 	return 0;
 
-err_l1d_flush:
-	vmx_exit();
 err_kvm_init:
+	__vmx_exit();
+err_l1d_flush:
 	kvm_x86_vendor_exit();
 	return r;
 }

