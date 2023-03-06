Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA57C6AC76F
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 17:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjCFQPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 11:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjCFQOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 11:14:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E04C24136
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 08:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614026102C
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 16:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF17C4339B;
        Mon,  6 Mar 2023 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678118944;
        bh=mk0tbXTfbOZstufGaG7akB6scF2nuPbA6hrCQsIJfgo=;
        h=Subject:To:Cc:From:Date:From;
        b=PYRB+s76JgJuK+bcbK8P/7t/mHlPywq7LH7l/WYs6BVbuzo8JVUqL0kl5hJ1GupiS
         rIJUFOY7jJCNzrTCXkWyQogBNyhk1qnOd4pApMP+8rn0tsRkmNpUaIBnQNqslWvRv6
         cws4FviupaVPEfldrDSjUrwq6bYfi9YCsWgOkByQ=
Subject: FAILED: patch "[PATCH] KVM: Register /dev/kvm as the _very_ last thing during" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 17:08:53 +0100
Message-ID: <16781189338715@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 2b01281273738bf2d6551da48d65db2df3f28998
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781189338715@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

2b0128127373 ("KVM: Register /dev/kvm as the _very_ last thing during initialization")
baff59ccdc65 ("KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()")
ae0946cd3601 ("KVM: Optimize kvm_make_vcpus_request_mask() a bit")
0bbc2ca8515f ("KVM: KVM: Use cpumask_available() to check for NULL cpumask when kicking vCPUs")
85b640450ddc ("KVM: Clean up benign vcpu->cpu data races when kicking vCPUs")
e649b3f0188f ("KVM: x86: Fix APIC page invalidation race")
54163a346d4a ("KVM: Introduce kvm_make_all_cpus_request_except()")
db5a95ec166f ("KVM: x86: remove set but not used variable 'called'")
7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
dfcd66604c1c ("mm/mmu_notifier: convert user range->blockable to helper function")
a3e0d41c2b1f ("mm/hmm: improve driver API to work and wait over a range")
73231612dc7c ("mm/hmm: improve and rename hmm_vma_fault() to hmm_range_fault()")
25f23a0c7127 ("mm/hmm: improve and rename hmm_vma_get_pfns() to hmm_range_snapshot()")
9f454612f602 ("mm/hmm: do not erase snapshot when a range is invalidated")
704f3f2cf63c ("mm/hmm: use reference counting for HMM struct")
484d9a844d0d ("drm/i915/userptr: Avoid struct_mutex recursion for mmu_invalidate_range_start")
ac46d4f3c432 ("mm/mmu_notifier: use structure for invalidate_range_start/end calls v2")
5d6527a784f7 ("mm/mmu_notifier: use structure for invalidate_range_start/end callback")
ec131b2d7fa6 ("mm/hmm: invalidate device page table at start of invalidation")
44532d4c591c ("mm/hmm: use a structure for update callback parameters")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2b01281273738bf2d6551da48d65db2df3f28998 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:08:45 +0000
Subject: [PATCH] KVM: Register /dev/kvm as the _very_ last thing during
 initialization

Register /dev/kvm, i.e. expose KVM to userspace, only after all other
setup has completed.  Once /dev/kvm is exposed, userspace can start
invoking KVM ioctls, creating VMs, etc...  If userspace creates a VM
before KVM is done with its configuration, bad things may happen, e.g.
KVM will fail to properly migrate vCPU state if a VM is created before
KVM has registered preemption notifiers.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221130230934.1014142-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13e88297f999..28a1a02f5228 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5988,12 +5988,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	kvm_chardev_ops.owner = module;
 
-	r = misc_register(&kvm_dev);
-	if (r) {
-		pr_err("kvm: misc device register failed\n");
-		goto out_unreg;
-	}
-
 	register_syscore_ops(&kvm_syscore_ops);
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
@@ -6002,11 +5996,24 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();
-	WARN_ON(r);
+	if (WARN_ON_ONCE(r))
+		goto err_vfio;
+
+	/*
+	 * Registration _must_ be the very last thing done, as this exposes
+	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
+	 */
+	r = misc_register(&kvm_dev);
+	if (r) {
+		pr_err("kvm: misc device register failed\n");
+		goto err_register;
+	}
 
 	return 0;
 
-out_unreg:
+err_register:
+	kvm_vfio_ops_exit();
+err_vfio:
 	kvm_async_pf_deinit();
 out_free_4:
 	for_each_possible_cpu(cpu)
@@ -6032,8 +6039,14 @@ void kvm_exit(void)
 {
 	int cpu;
 
-	debugfs_remove_recursive(kvm_debugfs_dir);
+	/*
+	 * Note, unregistering /dev/kvm doesn't strictly need to come first,
+	 * fops_get(), a.k.a. try_module_get(), prevents acquiring references
+	 * to KVM while the module is being stopped.
+	 */
 	misc_deregister(&kvm_dev);
+
+	debugfs_remove_recursive(kvm_debugfs_dir);
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);

