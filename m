Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE89421712F
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgGGPZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730146AbgGGPYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140FE2078D;
        Tue,  7 Jul 2020 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135492;
        bh=pSEpfkYIfGq7qguaL36WLt7tpg1W6BY1ve9KnmdPolw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1PtSM8FvL8WeM4ZuvdMpMjSOQ19l5YPPG5+5agI+64iwsQGQg7yHJCnus+nxQf2b
         mdUp7dc5lOfKoKpSL35EEslorcDl6gxb1T3/EWolUDTqhjNjg3+4yDB604mZd9H08V
         JlLIUc/ysZ7gjKJ3ZwWq98qeHfSQvecFNMvn7GO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 023/112] powerpc/book3s64/kvm: Fix secondary page table walk warning during migration
Date:   Tue,  7 Jul 2020 17:16:28 +0200
Message-Id: <20200707145802.092528519@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit bf8036a4098d1548cdccf9ed5c523ef4e83e3c68 ]

This patch fixes the below warning reported during migration:

  find_kvm_secondary_pte called with kvm mmu_lock not held
  CPU: 23 PID: 5341 Comm: qemu-system-ppc Tainted: G        W         5.7.0-rc5-kvm-00211-g9ccf10d6d088 #432
  NIP:  c008000000fe848c LR: c008000000fe8488 CTR: 0000000000000000
  REGS: c000001e19f077e0 TRAP: 0700   Tainted: G        W          (5.7.0-rc5-kvm-00211-g9ccf10d6d088)
  MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 42222422  XER: 20040000
  CFAR: c00000000012f5ac IRQMASK: 0
  GPR00: c008000000fe8488 c000001e19f07a70 c008000000ffe200 0000000000000039
  GPR04: 0000000000000001 c000001ffc8b4900 0000000000018840 0000000000000007
  GPR08: 0000000000000003 0000000000000001 0000000000000007 0000000000000001
  GPR12: 0000000000002000 c000001fff6d9400 000000011f884678 00007fff70b70000
  GPR16: 00007fff7137cb90 00007fff7dcb4410 0000000000000001 0000000000000000
  GPR20: 000000000ffe0000 0000000000000000 0000000000000001 0000000000000000
  GPR24: 8000000000000000 0000000000000001 c000001e1f67e600 c000001e1fd82410
  GPR28: 0000000000001000 c000001e2e410000 0000000000000fff 0000000000000ffe
  NIP [c008000000fe848c] kvmppc_hv_get_dirty_log_radix+0x2e4/0x340 [kvm_hv]
  LR [c008000000fe8488] kvmppc_hv_get_dirty_log_radix+0x2e0/0x340 [kvm_hv]
  Call Trace:
  [c000001e19f07a70] [c008000000fe8488] kvmppc_hv_get_dirty_log_radix+0x2e0/0x340 [kvm_hv] (unreliable)
  [c000001e19f07b50] [c008000000fd42e4] kvm_vm_ioctl_get_dirty_log_hv+0x33c/0x3c0 [kvm_hv]
  [c000001e19f07be0] [c008000000eea878] kvm_vm_ioctl_get_dirty_log+0x30/0x50 [kvm]
  [c000001e19f07c00] [c008000000edc818] kvm_vm_ioctl+0x2b0/0xc00 [kvm]
  [c000001e19f07d50] [c00000000046e148] ksys_ioctl+0xf8/0x150
  [c000001e19f07da0] [c00000000046e1c8] sys_ioctl+0x28/0x80
  [c000001e19f07dc0] [c00000000003652c] system_call_exception+0x16c/0x240
  [c000001e19f07e20] [c00000000000d070] system_call_common+0xf0/0x278
  Instruction dump:
  7d3a512a 4200ffd0 7ffefb78 4bfffdc4 60000000 3c820000 e8848468 3c620000
  e86384a8 38840010 4800673d e8410018 <0fe00000> 4bfffdd4 60000000 60000000

Reported-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200528080456.87797-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 10 +++++++
 arch/powerpc/kvm/book3s_64_mmu_radix.c   | 35 ++++++++++++++++++++----
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 2c2635967d6e0..0431db7b82af7 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -635,6 +635,16 @@ extern void kvmhv_remove_nest_rmap_range(struct kvm *kvm,
 				unsigned long gpa, unsigned long hpa,
 				unsigned long nbytes);
 
+static inline pte_t *
+find_kvm_secondary_pte_unlocked(struct kvm *kvm, unsigned long ea,
+				unsigned *hshift)
+{
+	pte_t *pte;
+
+	pte = __find_linux_pte(kvm->arch.pgtable, ea, NULL, hshift);
+	return pte;
+}
+
 static inline pte_t *find_kvm_secondary_pte(struct kvm *kvm, unsigned long ea,
 					    unsigned *hshift)
 {
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index e9b3622405b1d..d4e532a63f08e 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1052,7 +1052,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 {
 	unsigned long gfn = memslot->base_gfn + pagenum;
 	unsigned long gpa = gfn << PAGE_SHIFT;
-	pte_t *ptep;
+	pte_t *ptep, pte;
 	unsigned int shift;
 	int ret = 0;
 	unsigned long old, *rmapp;
@@ -1060,12 +1060,35 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ret;
 
-	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
-	if (ptep && pte_present(*ptep) && pte_dirty(*ptep)) {
-		ret = 1;
-		if (shift)
-			ret = 1 << (shift - PAGE_SHIFT);
+	/*
+	 * For performance reasons we don't hold kvm->mmu_lock while walking the
+	 * partition scoped table.
+	 */
+	ptep = find_kvm_secondary_pte_unlocked(kvm, gpa, &shift);
+	if (!ptep)
+		return 0;
+
+	pte = READ_ONCE(*ptep);
+	if (pte_present(pte) && pte_dirty(pte)) {
 		spin_lock(&kvm->mmu_lock);
+		/*
+		 * Recheck the pte again
+		 */
+		if (pte_val(pte) != pte_val(*ptep)) {
+			/*
+			 * We have KVM_MEM_LOG_DIRTY_PAGES enabled. Hence we can
+			 * only find PAGE_SIZE pte entries here. We can continue
+			 * to use the pte addr returned by above page table
+			 * walk.
+			 */
+			if (!pte_present(*ptep) || !pte_dirty(*ptep)) {
+				spin_unlock(&kvm->mmu_lock);
+				return 0;
+			}
+		}
+
+		ret = 1;
+		VM_BUG_ON(shift);
 		old = kvmppc_radix_update_pte(kvm, ptep, _PAGE_DIRTY, 0,
 					      gpa, shift);
 		kvmppc_radix_tlbie_page(kvm, gpa, shift, kvm->arch.lpid);
-- 
2.25.1



