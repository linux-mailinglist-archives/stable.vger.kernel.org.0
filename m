Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A891549A2A4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365884AbiAXXvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356656AbiAXW4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C89AC00366B;
        Mon, 24 Jan 2022 11:41:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC990B8125C;
        Mon, 24 Jan 2022 19:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0229AC340E5;
        Mon, 24 Jan 2022 19:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053262;
        bh=6fZMCQloQ2t3ladZ5ITB1GxhYi5y6jBkCeqwFsjnSLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSaiSNeN18djYK1Kfi9YOhXxhiUxNpmIX4tMVBqqzBBy/EFqc/cdBs7d+On1ZJ27d
         +yjp/2QEs3Nvfas+xIPTe9O+8BRrBJNi2lqHedSoMPlQwhy16H+BQE44GM+hy3Xlud
         4Za+bCPpKx/QHj7zlTsRynzbgOxURJ90hPJvEUHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 001/563] KVM: VMX: switch blocked_vcpu_on_cpu_lock to raw spinlock
Date:   Mon, 24 Jan 2022 19:36:06 +0100
Message-Id: <20220124184024.464020334@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 5f02ef741a785678930f3ff0a8b6b2b0ef1bb402 upstream.

blocked_vcpu_on_cpu_lock is taken from hard interrupt context
(pi_wakeup_handler), therefore it cannot sleep.

Switch it to a raw spinlock.

Fixes:

[41297.066254] BUG: scheduling while atomic: CPU 0/KVM/635218/0x00010001
[41297.066323] Preemption disabled at:
[41297.066324] [<ffffffff902ee47f>] irq_enter_rcu+0xf/0x60
[41297.066339] Call Trace:
[41297.066342]  <IRQ>
[41297.066346]  dump_stack_lvl+0x34/0x44
[41297.066353]  ? irq_enter_rcu+0xf/0x60
[41297.066356]  __schedule_bug.cold+0x7d/0x8b
[41297.066361]  __schedule+0x439/0x5b0
[41297.066365]  ? task_blocks_on_rt_mutex.constprop.0.isra.0+0x1b0/0x440
[41297.066369]  schedule_rtlock+0x1e/0x40
[41297.066371]  rtlock_slowlock_locked+0xf1/0x260
[41297.066374]  rt_spin_lock+0x3b/0x60
[41297.066378]  pi_wakeup_handler+0x31/0x90 [kvm_intel]
[41297.066388]  sysvec_kvm_posted_intr_wakeup_ipi+0x9d/0xd0
[41297.066392]  </IRQ>
[41297.066392]  asm_sysvec_kvm_posted_intr_wakeup_ipi+0x12/0x20
...

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/posted_intr.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -15,7 +15,7 @@
  * can find which vCPU should be waken up.
  */
 static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
-static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
+static DEFINE_PER_CPU(raw_spinlock_t, blocked_vcpu_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
@@ -121,9 +121,9 @@ static void __pi_post_block(struct kvm_v
 			   new.control) != old.control);
 
 	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+		raw_spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 		list_del(&vcpu->blocked_vcpu_list);
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+		raw_spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 		vcpu->pre_pcpu = -1;
 	}
 }
@@ -154,11 +154,11 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
 		vcpu->pre_pcpu = vcpu->cpu;
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+		raw_spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 		list_add_tail(&vcpu->blocked_vcpu_list,
 			      &per_cpu(blocked_vcpu_on_cpu,
 				       vcpu->pre_pcpu));
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+		raw_spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 	}
 
 	do {
@@ -215,7 +215,7 @@ void pi_wakeup_handler(void)
 	struct kvm_vcpu *vcpu;
 	int cpu = smp_processor_id();
 
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	raw_spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 	list_for_each_entry(vcpu, &per_cpu(blocked_vcpu_on_cpu, cpu),
 			blocked_vcpu_list) {
 		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
@@ -223,13 +223,13 @@ void pi_wakeup_handler(void)
 		if (pi_test_on(pi_desc) == 1)
 			kvm_vcpu_kick(vcpu);
 	}
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	raw_spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 }
 
 void __init pi_init_cpu(int cpu)
 {
 	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
-	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	raw_spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 }
 
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)


