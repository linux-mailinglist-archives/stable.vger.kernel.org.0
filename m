Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDB6268E22
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgINOpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgINNF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3DA22229;
        Mon, 14 Sep 2020 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088672;
        bh=OfGD2NmQi/dzHK4CFANYl88bZ5RChIHLeDbSAu2jVUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+cdhByRc4JBkNo8bbH6usXShn5HFhWI7pi+fEhOuxgEPT4an2VJhd6GRoPREE4EG
         6nHtzclBakmuFr7Xgeweg99b1Ko89f1ZbjBI/jt21d7umMsrALwY+vqBJRTMiBBSXg
         jxa9F4c3s5DBAllhEhi8NbUlcwYqLMSPOGUUaRis=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiwei Li <lihaiwei@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 28/29] KVM: Check the allocation of pv cpu mask
Date:   Mon, 14 Sep 2020 09:03:57 -0400
Message-Id: <20200914130358.1804194-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

