Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A39423C45
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbhJFLOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238225AbhJFLOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 07:14:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D67A461151;
        Wed,  6 Oct 2021 11:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633518781;
        bh=Sp+Y7RJuSk8xCBLGtsWJEjs3MWqFXgXB4aPr4V2Z/c8=;
        h=From:To:Cc:Subject:Date:From;
        b=JQjffBj9qYdgKi8P2NTvxDj2KMaTbUwk77hwHFqRDq/oq5FBsHpkd6RfdmSjxCyvt
         smIAPRvl18FwWJLDeRf/eYJqHe6FZd3j+RqYB8r1rbuMj2zXuvqWAG32XundZkuiuL
         ddwDPSnL2KE1psjvS5iSrqREHJHfaYT+TxeyABwZPNpVJ7OMinNIbwSVVpUQ6y9w4K
         aLlBN/5Ch/I1iOPctSrUt4ATkbwvqE6lKP3i1knZ3W7cNp0TN+EXXw0fsYRH6oWxBs
         3QJ57M5imxQiLGBveJ3FADcu/vukmgb65DoBbPLzSGptUjQFZuPeNuerUzK5yL60cS
         Q6J7evOJHXqug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 4.19 1/2] KVM: x86: Handle SRCU initialization failure during page track init
Date:   Wed,  6 Oct 2021 07:12:58 -0400
Message-Id: <20211006111259.264427-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

[ Upstream commit eb7511bf9182292ef1df1082d23039e856d1ddfb ]

Check the return of init_srcu_struct(), which can fail due to OOM, when
initializing the page track mechanism.  Lack of checking leads to a NULL
pointer deref found by a modified syzkaller.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Message-Id: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
[Move the call towards the beginning of kvm_arch_init_vm. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/page_track.c             | 4 ++--
 arch/x86/kvm/x86.c                    | 7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 172f9749dbb2..5986bd4aacd6 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
 			    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_page_track_init(struct kvm *kvm);
+int kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
diff --git a/arch/x86/kvm/page_track.c b/arch/x86/kvm/page_track.c
index 3052a59a3065..1f6b0d9b0c85 100644
--- a/arch/x86/kvm/page_track.c
+++ b/arch/x86/kvm/page_track.c
@@ -169,13 +169,13 @@ void kvm_page_track_cleanup(struct kvm *kvm)
 	cleanup_srcu_struct(&head->track_srcu);
 }
 
-void kvm_page_track_init(struct kvm *kvm)
+int kvm_page_track_init(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
 
 	head = &kvm->arch.track_notifier_head;
-	init_srcu_struct(&head->track_srcu);
 	INIT_HLIST_HEAD(&head->track_notifier_list);
+	return init_srcu_struct(&head->track_srcu);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 417abc9ba1ad..70cb18f89029 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9039,9 +9039,15 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
+	int ret;
+
 	if (type)
 		return -EINVAL;
 
+	ret = kvm_page_track_init(kvm);
+	if (ret)
+		return ret;
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
@@ -9068,7 +9074,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
 	kvm_hv_init_vm(kvm);
-	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
 
 	if (kvm_x86_ops->vm_init)
-- 
2.33.0

