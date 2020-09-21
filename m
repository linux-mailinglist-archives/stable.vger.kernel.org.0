Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13B9272DDE
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgIUQoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729655AbgIUQoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8D9B238E6;
        Mon, 21 Sep 2020 16:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706639;
        bh=OfGD2NmQi/dzHK4CFANYl88bZ5RChIHLeDbSAu2jVUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5igfEFtIX8BAGYf6aN0auiyA6POdwXpCJQZ9rpivAHEUfbttV1ZqBlggVPk87ESJ
         QydkPxNzFI6ZikGZrZcPbGVtUjx7dOs0QL1V9m3RRIYOtRAoMMEEL/TX+u7Z/pqG8c
         ukNU3GRqMGj6jzicqiHnnCGfHWbs6HbI16SlqhOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiwei Li <lihaiwei@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 034/118] KVM: Check the allocation of pv cpu mask
Date:   Mon, 21 Sep 2020 18:27:26 +0200
Message-Id: <20200921162037.894223054@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

[ Upstream commit 0f990222108d214a0924d920e6095b58107d7b59 ]

check the allocation of per-cpu __pv_cpu_mask. Initialize ops only when
successful.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
Message-Id: <d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvm.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index df63786e7bfa4..d6219f3181d63 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -638,7 +638,6 @@ static void __init kvm_guest_init(void)
 	}
 
 	if (pv_tlb_flush_supported()) {
-		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
 		pr_info("KVM setup pv remote TLB flush\n");
 	}
@@ -750,6 +749,14 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);
 
+static void kvm_free_pv_cpu_mask(void)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
+}
+
 static __init int kvm_alloc_cpumask(void)
 {
 	int cpu;
@@ -768,11 +775,20 @@ static __init int kvm_alloc_cpumask(void)
 
 	if (alloc)
 		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(
+				per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu))) {
+				goto zalloc_cpumask_fail;
+			}
 		}
 
+	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
+	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 	return 0;
+
+zalloc_cpumask_fail:
+	kvm_free_pv_cpu_mask();
+	return -ENOMEM;
 }
 arch_initcall(kvm_alloc_cpumask);
 
-- 
2.25.1



