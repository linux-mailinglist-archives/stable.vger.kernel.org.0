Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3DA6BB15A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjCOM0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbjCOM0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8DD24CA4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 257EE61D43
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371AFC433EF;
        Wed, 15 Mar 2023 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883103;
        bh=biaYvCVw5rGH8TYG36sinosiiqszprVrBjTgqBgErBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YanvIR0ZYJR+hvJnrLtoVggkiA0r23brHZ/C9CJWIvQmXTio+J6WBKAseIPn7IPrp
         1p2RlNAoM2l4A7T54/jBxgxPvV7VtRAO3w1nEbwJke8kPGIyPlHp+MHCjmmueRZluD
         i3mK8LnDyrjA9tFR4wC25N496GKNMpLloIl0PVXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/145] KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
Date:   Wed, 15 Mar 2023 13:11:23 +0100
Message-Id: <20230315115739.564593447@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit baff59ccdc657d290be51b95b38ebe5de40036b4 ]

Allocating cpumask dynamically in zalloc_cpumask_var() is not ideal.
Allocation is somewhat slow and can (in theory and when CPUMASK_OFFSTACK)
fail. kvm_make_all_cpus_request_except() already disables preemption so
we can use pre-allocated per-cpu cpumasks instead.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210903075141.403071-8-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last thing during initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d08dbf0be2fce..c60e88b0b24ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -157,6 +157,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+
 __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 						   unsigned long start, unsigned long end)
 {
@@ -320,14 +322,15 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
 	struct kvm_vcpu *vcpu;
-	cpumask_var_t cpus;
+	struct cpumask *cpus;
 	bool called;
 	int i, me;
 
-	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
-
 	me = get_cpu();
 
+	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
+	cpumask_clear(cpus);
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu == except)
 			continue;
@@ -337,7 +340,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
 	put_cpu();
 
-	free_cpumask_var(cpus);
 	return called;
 }
 
@@ -5637,9 +5639,17 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_3;
 	}
 
+	for_each_possible_cpu(cpu) {
+		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
+					    GFP_KERNEL, cpu_to_node(cpu))) {
+			r = -ENOMEM;
+			goto out_free_4;
+		}
+	}
+
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free;
+		goto out_free_5;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
@@ -5665,7 +5675,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 out_unreg:
 	kvm_async_pf_deinit();
-out_free:
+out_free_5:
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
+out_free_4:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5685,8 +5698,12 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	int cpu;
+
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
-- 
2.39.2



