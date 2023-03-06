Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D56AC9E1
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjCFRY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCFRY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:24:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128A41BDF
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92E1BB80EDE
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 16:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE33C433D2;
        Mon,  6 Mar 2023 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678118949;
        bh=MIL3UY2O8PsntkQqMxAhxl2kkqBZp5bIvwdGRMX0V7o=;
        h=Subject:To:Cc:From:Date:From;
        b=LwbP0c5es1bR7gdj765CvIRBHBaA764InM5lkUK6HsqBT20LVK+rBYI5XsHO+b8T3
         jN3qRhUHqCM64tLYx96gMt7PyMtU970CbMofiWQHUbzHyuMs0s2prTC+tGX9ZkQj5+
         ct72DYwqMee4bvQEyVdO2h3s9rCOGBCoPzHnELr8=
Subject: FAILED: patch "[PATCH] KVM: VMX: Do _all_ initialization before exposing /dev/kvm to" failed to apply to 6.2-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 17:09:06 +0100
Message-ID: <167811894610616@kroah.com>
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


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x e32b120071ea114efc0b4ddd439547750b85f618
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167811894610616@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace")

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

