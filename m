Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D047159B40F
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiHUNo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHUNo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:44:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84D423151
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FF7EB80D0D
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EE6C433D6;
        Sun, 21 Aug 2022 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661089495;
        bh=MnCiWVJ3xLGDQotaEQb5XUGELS2wndBM1rSvz7jwNR4=;
        h=Subject:To:Cc:From:Date:From;
        b=Qjcx1s40AdbyY4OrvmfLECz7aTrxE/x6j5c5hRWgewE8mDV5cLSz6LQhjiG0reapI
         v7Gp8sot9RHgtQxR+fbt79dyTcU2wu48ptiBtKThhDWDX8RoRQoCYk0PCCykjtmGai
         GqiWjpQ+ASzp2/gF0iBHlN3/TrTWH49PVqwqkM0k=
Subject: FAILED: patch "[PATCH] KVM: Unconditionally get a ref to /dev/kvm module when" failed to apply to 5.10-stable tree
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:44:52 +0200
Message-ID: <166108949216452@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 405294f29faee5de8c10cb9d4a90e229c2835279 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 16 Aug 2022 05:39:36 +0000
Subject: [PATCH] KVM: Unconditionally get a ref to /dev/kvm module when
 creating a VM

Unconditionally get a reference to the /dev/kvm module when creating a VM
instead of using try_get_module(), which will fail if the module is in
the process of being forcefully unloaded.  The error handling when
try_get_module() fails doesn't properly unwind all that has been done,
e.g. doesn't call kvm_arch_pre_destroy_vm() and doesn't remove the VM
from the global list.  Not removing VMs from the global list tends to be
fatal, e.g. leads to use-after-free explosions.

The obvious alternative would be to add proper unwinding, but the
justification for using try_get_module(), "rmmod --wait", is completely
bogus as support for "rmmod --wait", i.e. delete_module() without
O_NONBLOCK, was removed by commit 3f2b9c9cdf38 ("module: remove rmmod
--wait option.") nearly a decade ago.

It's still possible for try_get_module() to fail due to the module dying
(more like being killed), as the module will be tagged MODULE_STATE_GOING
by "rmmod --force", i.e. delete_module(..., O_TRUNC), but playing nice
with forced unloading is an exercise in futility and gives a falsea sense
of security.  Using try_get_module() only prevents acquiring _new_
references, it doesn't magically put the references held by other VMs,
and forced unloading doesn't wait, i.e. "rmmod --force" on KVM is all but
guaranteed to cause spectacular fireworks; the window where KVM will fail
try_get_module() is tiny compared to the window where KVM is building and
running the VM with an elevated module refcount.

Addressing KVM's inability to play nice with "rmmod --force" is firmly
out-of-scope.  Forcefully unloading any module taints kernel (for obvious
reasons)  _and_ requires the kernel to be built with
CONFIG_MODULE_FORCE_UNLOAD=y, which is off by default and comes with the
amusing disclaimer that it's "mainly for kernel developers and desperate
users".  In other words, KVM is free to scoff at bug reports due to using
"rmmod --force" while VMs may be running.

Fixes: 5f6de5cbebee ("KVM: Prevent module exit until all VMs are freed")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220816053937.2477106-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee5f48cc100b..15e304e059d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1134,6 +1134,9 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
+	/* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
+	__module_get(kvm_chardev_ops.owner);
+
 	KVM_MMU_LOCK_INIT(kvm);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
@@ -1226,16 +1229,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
-	/*
-	 * When the fd passed to this ioctl() is opened it pins the module,
-	 * but try_module_get() also prevents getting a reference if the module
-	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
-	 */
-	if (!try_module_get(kvm_chardev_ops.owner)) {
-		r = -ENODEV;
-		goto out_err;
-	}
-
 	return kvm;
 
 out_err:
@@ -1259,6 +1252,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
+	module_put(kvm_chardev_ops.owner);
 	return ERR_PTR(r);
 }
 

