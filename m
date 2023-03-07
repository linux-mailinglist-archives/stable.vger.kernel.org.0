Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957476AEC8E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCGR4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCGRzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166879E50E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF6EEB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015BCC433EF;
        Tue,  7 Mar 2023 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211445;
        bh=KbWwU7WsFn9JZCO/sFsNwElFLm2CjAVZtKOSLsDCvu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQStfm2hqgBFYraoHkIOz1xzSAwBc6qhZOx3ljnGJh1v2+aB6BdXWZtIVcnsoQU/O
         BAJ3U4UhHt+qNmFjQTQPTl5XYzd8qSseeFIigSAozYItSaAghC3jskv9ADaLRxjTTG
         gJZBC6omaU8+naeiZru3GkLR7QsDe7eB6c9KanXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.2 0823/1001] KVM: Register /dev/kvm as the _very_ last thing during initialization
Date:   Tue,  7 Mar 2023 17:59:55 +0100
Message-Id: <20230307170057.462400895@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 2b01281273738bf2d6551da48d65db2df3f28998 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5995,12 +5995,6 @@ int kvm_init(void *opaque, unsigned vcpu
 
 	kvm_chardev_ops.owner = module;
 
-	r = misc_register(&kvm_dev);
-	if (r) {
-		pr_err("kvm: misc device register failed\n");
-		goto out_unreg;
-	}
-
 	register_syscore_ops(&kvm_syscore_ops);
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
@@ -6009,11 +6003,24 @@ int kvm_init(void *opaque, unsigned vcpu
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
@@ -6039,8 +6046,14 @@ void kvm_exit(void)
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


