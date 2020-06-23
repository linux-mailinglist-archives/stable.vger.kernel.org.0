Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21E0206530
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgFWUMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388994AbgFWUMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD1A2073E;
        Tue, 23 Jun 2020 20:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943159;
        bh=hZHMC3YSxuf3DBQMdBM6bV8U9JITKt2qZ1akjHsMHbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x268khwerBKSIv3B6DuLJy/MdqGm8GiH2slulk2X3hzUpm6LwMOI/Tmci0ls80zkY
         I8DEPB22ID568ehJwdFUgoqiETZmo9968XC46LrqZmHI3+fxLQclCAmeUlLJ9H7Z9d
         q4ZEtLILCCF6El9i9kyzFpkZgMQc5GcimW57CclA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 283/477] KVM: PPC: Book3S: Fix some RCU-list locks
Date:   Tue, 23 Jun 2020 21:54:40 +0200
Message-Id: <20200623195420.949348844@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit ab8b65be183180c3eef405d449163964ecc4b571 ]

It is unsafe to traverse kvm->arch.spapr_tce_tables and
stt->iommu_tables without the RCU read lock held. Also, add
cond_resched_rcu() in places with the RCU read lock held that could take
a while to finish.

 arch/powerpc/kvm/book3s_64_vio.c:76 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 no locks held by qemu-kvm/4265.

 stack backtrace:
 CPU: 96 PID: 4265 Comm: qemu-kvm Not tainted 5.7.0-rc4-next-20200508+ #2
 Call Trace:
 [c000201a8690f720] [c000000000715948] dump_stack+0xfc/0x174 (unreliable)
 [c000201a8690f770] [c0000000001d9470] lockdep_rcu_suspicious+0x140/0x164
 [c000201a8690f7f0] [c008000010b9fb48] kvm_spapr_tce_release_iommu_group+0x1f0/0x220 [kvm]
 [c000201a8690f870] [c008000010b8462c] kvm_spapr_tce_release_vfio_group+0x54/0xb0 [kvm]
 [c000201a8690f8a0] [c008000010b84710] kvm_vfio_destroy+0x88/0x140 [kvm]
 [c000201a8690f8f0] [c008000010b7d488] kvm_put_kvm+0x370/0x600 [kvm]
 [c000201a8690f990] [c008000010b7e3c0] kvm_vm_release+0x38/0x60 [kvm]
 [c000201a8690f9c0] [c0000000005223f4] __fput+0x124/0x330
 [c000201a8690fa20] [c000000000151cd8] task_work_run+0xb8/0x130
 [c000201a8690fa70] [c0000000001197e8] do_exit+0x4e8/0xfa0
 [c000201a8690fb70] [c00000000011a374] do_group_exit+0x64/0xd0
 [c000201a8690fbb0] [c000000000132c90] get_signal+0x1f0/0x1200
 [c000201a8690fcc0] [c000000000020690] do_notify_resume+0x130/0x3c0
 [c000201a8690fda0] [c000000000038d64] syscall_exit_prepare+0x1a4/0x280
 [c000201a8690fe20] [c00000000000c8f8] system_call_common+0xf8/0x278

 ====
 arch/powerpc/kvm/book3s_64_vio.c:368 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 2 locks held by qemu-kvm/4264:
  #0: c000201ae2d000d8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0xdc/0x950 [kvm]
  #1: c000200c9ed0c468 (&kvm->srcu){....}-{0:0}, at: kvmppc_h_put_tce+0x88/0x340 [kvm]

 ====
 arch/powerpc/kvm/book3s_64_vio.c:108 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by qemu-kvm/4257:
  #0: c000200b1b363a40 (&kv->lock){+.+.}-{3:3}, at: kvm_vfio_set_attr+0x598/0x6c0 [kvm]

 ====
 arch/powerpc/kvm/book3s_64_vio.c:146 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by qemu-kvm/4257:
  #0: c000200b1b363a40 (&kv->lock){+.+.}-{3:3}, at: kvm_vfio_set_attr+0x598/0x6c0 [kvm]

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 50555ad1db932..1a529df0ab442 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -73,6 +73,7 @@ extern void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 	struct kvmppc_spapr_tce_iommu_table *stit, *tmp;
 	struct iommu_table_group *table_group = NULL;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stt, &kvm->arch.spapr_tce_tables, list) {
 
 		table_group = iommu_group_get_iommudata(grp);
@@ -87,7 +88,9 @@ extern void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 				kref_put(&stit->kref, kvm_spapr_tce_liobn_put);
 			}
 		}
+		cond_resched_rcu();
 	}
+	rcu_read_unlock();
 }
 
 extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
@@ -105,12 +108,14 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	if (!f.file)
 		return -EBADF;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stt, &kvm->arch.spapr_tce_tables, list) {
 		if (stt == f.file->private_data) {
 			found = true;
 			break;
 		}
 	}
+	rcu_read_unlock();
 
 	fdput(f);
 
@@ -143,6 +148,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	if (!tbl)
 		return -EINVAL;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stit, &stt->iommu_tables, next) {
 		if (tbl != stit->tbl)
 			continue;
@@ -150,14 +156,17 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 		if (!kref_get_unless_zero(&stit->kref)) {
 			/* stit is being destroyed */
 			iommu_tce_table_put(tbl);
+			rcu_read_unlock();
 			return -ENOTTY;
 		}
 		/*
 		 * The table is already known to this KVM, we just increased
 		 * its KVM reference counter and can return.
 		 */
+		rcu_read_unlock();
 		return 0;
 	}
+	rcu_read_unlock();
 
 	stit = kzalloc(sizeof(*stit), GFP_KERNEL);
 	if (!stit) {
@@ -365,18 +374,19 @@ static long kvmppc_tce_validate(struct kvmppc_spapr_tce_table *stt,
 	if (kvmppc_tce_to_ua(stt->kvm, tce, &ua))
 		return H_TOO_HARD;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stit, &stt->iommu_tables, next) {
 		unsigned long hpa = 0;
 		struct mm_iommu_table_group_mem_t *mem;
 		long shift = stit->tbl->it_page_shift;
 
 		mem = mm_iommu_lookup(stt->kvm->mm, ua, 1ULL << shift);
-		if (!mem)
-			return H_TOO_HARD;
-
-		if (mm_iommu_ua_to_hpa(mem, ua, shift, &hpa))
+		if (!mem || mm_iommu_ua_to_hpa(mem, ua, shift, &hpa)) {
+			rcu_read_unlock();
 			return H_TOO_HARD;
+		}
 	}
+	rcu_read_unlock();
 
 	return H_SUCCESS;
 }
-- 
2.25.1



