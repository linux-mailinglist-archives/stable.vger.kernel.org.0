Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6971650F569
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345486AbiDZIsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346540AbiDZIpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775DAE98;
        Tue, 26 Apr 2022 01:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C38DB81A2F;
        Tue, 26 Apr 2022 08:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CF3C385A4;
        Tue, 26 Apr 2022 08:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962098;
        bh=FV8BG+7T+xITBrrDvInA32UvQ3xfvYvM7lbb9r9AwBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcBosTKjFG0zh5A7FDWcJ6MJxJ5hcHYTfJu1h1iXUVGQXmGoLffNxd+Aa4P7IC3P/
         PeC6n6BEnJmaB4adEtnzvXfBxWwgaWIHCZvrZM94hoYTb6GVgw9reueiGK6RxHiMeG
         8yA3AXuWApq/7EAjWLllHUMAdFcD+9VxLT4Okpng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 70/86] KVM: PPC: Fix TCE handling for VFIO
Date:   Tue, 26 Apr 2022 10:21:38 +0200
Message-Id: <20220426081743.229621780@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 26a62b750a4e6364b0393562f66759b1494c3a01 ]

The LoPAPR spec defines a guest visible IOMMU with a variable page size.
Currently QEMU advertises 4K, 64K, 2M, 16MB pages, a Linux VM picks
the biggest (16MB). In the case of a passed though PCI device, there is
a hardware IOMMU which does not support all pages sizes from the above -
P8 cannot do 2MB and P9 cannot do 16MB. So for each emulated
16M IOMMU page we may create several smaller mappings ("TCEs") in
the hardware IOMMU.

The code wrongly uses the emulated TCE index instead of hardware TCE
index in error handling. The problem is easier to see on POWER8 with
multi-level TCE tables (when only the first level is preallocated)
as hash mode uses real mode TCE hypercalls handlers.
The kernel starts using indirect tables when VMs get bigger than 128GB
(depends on the max page order).
The very first real mode hcall is going to fail with H_TOO_HARD as
in the real mode we cannot allocate memory for TCEs (we can in the virtual
mode) but on the way out the code attempts to clear hardware TCEs using
emulated TCE indexes which corrupts random kernel memory because
it_offset==1<<59 is subtracted from those indexes and the resulting index
is out of the TCE table bounds.

This fixes kvmppc_clear_tce() to use the correct TCE indexes.

While at it, this fixes TCE cache invalidation which uses emulated TCE
indexes instead of the hardware ones. This went unnoticed as 64bit DMA
is used these days and VMs map all RAM in one go and only then do DMA
and this is when the TCE cache gets populated.

Potentially this could slow down mapping, however normally 16MB
emulated pages are backed by 64K hardware pages so it is one write to
the "TCE Kill" per 256 updates which is not that bad considering the size
of the cache (1024 TCEs or so).

Fixes: ca1fc489cfa0 ("KVM: PPC: Book3S: Allow backing bigger guest IOMMU pages with smaller physical pages")

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Tested-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Frederic Barrat <fbarrat@linux.ibm.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220420050840.328223-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c    | 45 +++++++++++++++--------------
 arch/powerpc/kvm/book3s_64_vio_hv.c | 44 ++++++++++++++--------------
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 8da93fdfa59e..c640053ab03f 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -421,13 +421,19 @@ static void kvmppc_tce_put(struct kvmppc_spapr_tce_table *stt,
 	tbl[idx % TCES_PER_PAGE] = tce;
 }
 
-static void kvmppc_clear_tce(struct mm_struct *mm, struct iommu_table *tbl,
-		unsigned long entry)
+static void kvmppc_clear_tce(struct mm_struct *mm, struct kvmppc_spapr_tce_table *stt,
+		struct iommu_table *tbl, unsigned long entry)
 {
-	unsigned long hpa = 0;
-	enum dma_data_direction dir = DMA_NONE;
+	unsigned long i;
+	unsigned long subpages = 1ULL << (stt->page_shift - tbl->it_page_shift);
+	unsigned long io_entry = entry << (stt->page_shift - tbl->it_page_shift);
+
+	for (i = 0; i < subpages; ++i) {
+		unsigned long hpa = 0;
+		enum dma_data_direction dir = DMA_NONE;
 
-	iommu_tce_xchg_no_kill(mm, tbl, entry, &hpa, &dir);
+		iommu_tce_xchg_no_kill(mm, tbl, io_entry + i, &hpa, &dir);
+	}
 }
 
 static long kvmppc_tce_iommu_mapped_dec(struct kvm *kvm,
@@ -486,6 +492,8 @@ static long kvmppc_tce_iommu_unmap(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -545,6 +553,8 @@ static long kvmppc_tce_iommu_map(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -591,10 +601,9 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_tce_iommu_map(vcpu->kvm, stt, stit->tbl,
 					entry, ua, dir);
 
-		iommu_tce_kill(stit->tbl, entry, 1);
 
 		if (ret != H_SUCCESS) {
-			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
+			kvmppc_clear_tce(vcpu->kvm->mm, stt, stit->tbl, entry);
 			goto unlock_exit;
 		}
 	}
@@ -670,13 +679,13 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		 */
 		if (get_user(tce, tces + i)) {
 			ret = H_TOO_HARD;
-			goto invalidate_exit;
+			goto unlock_exit;
 		}
 		tce = be64_to_cpu(tce);
 
 		if (kvmppc_tce_to_ua(vcpu->kvm, tce, &ua)) {
 			ret = H_PARAMETER;
-			goto invalidate_exit;
+			goto unlock_exit;
 		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
@@ -685,19 +694,15 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 					iommu_tce_direction(tce));
 
 			if (ret != H_SUCCESS) {
-				kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl,
-						entry);
-				goto invalidate_exit;
+				kvmppc_clear_tce(vcpu->kvm->mm, stt, stit->tbl,
+						 entry + i);
+				goto unlock_exit;
 			}
 		}
 
 		kvmppc_tce_put(stt, entry + i, tce);
 	}
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill(stit->tbl, entry, npages);
-
 unlock_exit:
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
@@ -736,20 +741,16 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				goto invalidate_exit;
+				return ret;
 
 			WARN_ON_ONCE(1);
-			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
+			kvmppc_clear_tce(vcpu->kvm->mm, stt, stit->tbl, entry + i);
 		}
 	}
 
 	for (i = 0; i < npages; ++i, ioba += (1ULL << stt->page_shift))
 		kvmppc_tce_put(stt, ioba >> stt->page_shift, tce_value);
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill(stit->tbl, ioba >> stt->page_shift, npages);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvmppc_h_stuff_tce);
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index e5ba96c41f3f..57af53a6a2d8 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -247,13 +247,19 @@ static void iommu_tce_kill_rm(struct iommu_table *tbl,
 		tbl->it_ops->tce_kill(tbl, entry, pages, true);
 }
 
-static void kvmppc_rm_clear_tce(struct kvm *kvm, struct iommu_table *tbl,
-		unsigned long entry)
+static void kvmppc_rm_clear_tce(struct kvm *kvm, struct kvmppc_spapr_tce_table *stt,
+		struct iommu_table *tbl, unsigned long entry)
 {
-	unsigned long hpa = 0;
-	enum dma_data_direction dir = DMA_NONE;
+	unsigned long i;
+	unsigned long subpages = 1ULL << (stt->page_shift - tbl->it_page_shift);
+	unsigned long io_entry = entry << (stt->page_shift - tbl->it_page_shift);
+
+	for (i = 0; i < subpages; ++i) {
+		unsigned long hpa = 0;
+		enum dma_data_direction dir = DMA_NONE;
 
-	iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, entry, &hpa, &dir);
+		iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, io_entry + i, &hpa, &dir);
+	}
 }
 
 static long kvmppc_rm_tce_iommu_mapped_dec(struct kvm *kvm,
@@ -316,6 +322,8 @@ static long kvmppc_rm_tce_iommu_unmap(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill_rm(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -379,6 +387,8 @@ static long kvmppc_rm_tce_iommu_map(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill_rm(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -424,10 +434,8 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_rm_tce_iommu_map(vcpu->kvm, stt,
 					stit->tbl, entry, ua, dir);
 
-		iommu_tce_kill_rm(stit->tbl, entry, 1);
-
 		if (ret != H_SUCCESS) {
-			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
+			kvmppc_rm_clear_tce(vcpu->kvm, stt, stit->tbl, entry);
 			return ret;
 		}
 	}
@@ -569,7 +577,7 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		ua = 0;
 		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce, &ua)) {
 			ret = H_PARAMETER;
-			goto invalidate_exit;
+			goto unlock_exit;
 		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
@@ -578,19 +586,15 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 					iommu_tce_direction(tce));
 
 			if (ret != H_SUCCESS) {
-				kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl,
-						entry);
-				goto invalidate_exit;
+				kvmppc_rm_clear_tce(vcpu->kvm, stt, stit->tbl,
+						entry + i);
+				goto unlock_exit;
 			}
 		}
 
 		kvmppc_rm_tce_put(stt, entry + i, tce);
 	}
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill_rm(stit->tbl, entry, npages);
-
 unlock_exit:
 	if (!prereg)
 		arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
@@ -632,20 +636,16 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				goto invalidate_exit;
+				return ret;
 
 			WARN_ON_ONCE_RM(1);
-			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
+			kvmppc_rm_clear_tce(vcpu->kvm, stt, stit->tbl, entry + i);
 		}
 	}
 
 	for (i = 0; i < npages; ++i, ioba += (1ULL << stt->page_shift))
 		kvmppc_rm_tce_put(stt, ioba >> stt->page_shift, tce_value);
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill_rm(stit->tbl, ioba >> stt->page_shift, npages);
-
 	return ret;
 }
 
-- 
2.35.1



