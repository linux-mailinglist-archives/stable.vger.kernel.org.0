Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5B9206151
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390464AbgFWUje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391643AbgFWUj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:39:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 242232085B;
        Tue, 23 Jun 2020 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944768;
        bh=q7AB9mS4mtH1q8Pg4IL60EGe/7NmFsbw+nZpN7cOZ1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ys682eGBtbo5+WujP/e7gU6mH+QdgmsETvDsYKbh1Xn2CE0Dnt89gaznOWamHHdyu
         XVXtVDITGbutCDapulTyVzmsIsl+U27W6/2Gbuz3zP9ZkARXK/tKLVaeP7br4stmbO
         PlaNQoessPVwWHNxsDV8bE/JLYO3Hs4cnWuO2kVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/206] KVM: PPC: Book3S HV: Ignore kmemleak false positives
Date:   Tue, 23 Jun 2020 21:57:25 +0200
Message-Id: <20200623195322.702803406@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 0aca8a5575544bd21b3363058afb8f1e81505150 ]

kvmppc_pmd_alloc() and kvmppc_pte_alloc() allocate some memory but then
pud_populate() and pmd_populate() will use __pa() to reference the newly
allocated memory.

Since kmemleak is unable to track the physical memory resulting in false
positives, silence those by using kmemleak_ignore().

unreferenced object 0xc000201c382a1000 (size 4096):
 comm "qemu-kvm", pid 124828, jiffies 4295733767 (age 341.250s)
 hex dump (first 32 bytes):
   c0 00 20 09 f4 60 03 87 c0 00 20 10 72 a0 03 87  .. ..`.... .r...
   c0 00 20 0e 13 a0 03 87 c0 00 20 1b dc c0 03 87  .. ....... .....
 backtrace:
   [<000000004cc2790f>] kvmppc_create_pte+0x838/0xd20 [kvm_hv]
   kvmppc_pmd_alloc at arch/powerpc/kvm/book3s_64_mmu_radix.c:366
   (inlined by) kvmppc_create_pte at arch/powerpc/kvm/book3s_64_mmu_radix.c:590
   [<00000000d123c49a>] kvmppc_book3s_instantiate_page+0x2e0/0x8c0 [kvm_hv]
   [<00000000bb549087>] kvmppc_book3s_radix_page_fault+0x1b4/0x2b0 [kvm_hv]
   [<0000000086dddc0e>] kvmppc_book3s_hv_page_fault+0x214/0x12a0 [kvm_hv]
   [<000000005ae9ccc2>] kvmppc_vcpu_run_hv+0xc5c/0x15f0 [kvm_hv]
   [<00000000d22162ff>] kvmppc_vcpu_run+0x34/0x48 [kvm]
   [<00000000d6953bc4>] kvm_arch_vcpu_ioctl_run+0x314/0x420 [kvm]
   [<000000002543dd54>] kvm_vcpu_ioctl+0x33c/0x950 [kvm]
   [<0000000048155cd6>] ksys_ioctl+0xd8/0x130
   [<0000000041ffeaa7>] sys_ioctl+0x28/0x40
   [<000000004afc4310>] system_call_exception+0x114/0x1e0
   [<00000000fb70a873>] system_call_common+0xf0/0x278
unreferenced object 0xc0002001f0c03900 (size 256):
 comm "qemu-kvm", pid 124830, jiffies 4295735235 (age 326.570s)
 hex dump (first 32 bytes):
   c0 00 20 10 fa a0 03 87 c0 00 20 10 fa a1 03 87  .. ....... .....
   c0 00 20 10 fa a2 03 87 c0 00 20 10 fa a3 03 87  .. ....... .....
 backtrace:
   [<0000000023f675b8>] kvmppc_create_pte+0x854/0xd20 [kvm_hv]
   kvmppc_pte_alloc at arch/powerpc/kvm/book3s_64_mmu_radix.c:356
   (inlined by) kvmppc_create_pte at arch/powerpc/kvm/book3s_64_mmu_radix.c:593
   [<00000000d123c49a>] kvmppc_book3s_instantiate_page+0x2e0/0x8c0 [kvm_hv]
   [<00000000bb549087>] kvmppc_book3s_radix_page_fault+0x1b4/0x2b0 [kvm_hv]
   [<0000000086dddc0e>] kvmppc_book3s_hv_page_fault+0x214/0x12a0 [kvm_hv]
   [<000000005ae9ccc2>] kvmppc_vcpu_run_hv+0xc5c/0x15f0 [kvm_hv]
   [<00000000d22162ff>] kvmppc_vcpu_run+0x34/0x48 [kvm]
   [<00000000d6953bc4>] kvm_arch_vcpu_ioctl_run+0x314/0x420 [kvm]
   [<000000002543dd54>] kvm_vcpu_ioctl+0x33c/0x950 [kvm]
   [<0000000048155cd6>] ksys_ioctl+0xd8/0x130
   [<0000000041ffeaa7>] sys_ioctl+0x28/0x40
   [<000000004afc4310>] system_call_exception+0x114/0x1e0
   [<00000000fb70a873>] system_call_common+0xf0/0x278

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 998f8d089ac7e..df0f08cb821b5 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -171,7 +171,13 @@ static struct kmem_cache *kvm_pmd_cache;
 
 static pte_t *kvmppc_pte_alloc(void)
 {
-	return kmem_cache_alloc(kvm_pte_cache, GFP_KERNEL);
+	pte_t *pte;
+
+	pte = kmem_cache_alloc(kvm_pte_cache, GFP_KERNEL);
+	/* pmd_populate() will only reference _pa(pte). */
+	kmemleak_ignore(pte);
+
+	return pte;
 }
 
 static void kvmppc_pte_free(pte_t *ptep)
@@ -187,7 +193,13 @@ static inline int pmd_is_leaf(pmd_t pmd)
 
 static pmd_t *kvmppc_pmd_alloc(void)
 {
-	return kmem_cache_alloc(kvm_pmd_cache, GFP_KERNEL);
+	pmd_t *pmd;
+
+	pmd = kmem_cache_alloc(kvm_pmd_cache, GFP_KERNEL);
+	/* pud_populate() will only reference _pa(pmd). */
+	kmemleak_ignore(pmd);
+
+	return pmd;
 }
 
 static void kvmppc_pmd_free(pmd_t *pmdp)
-- 
2.25.1



