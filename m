Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5690F423C37
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbhJFLOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238242AbhJFLOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 07:14:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2774D610FC;
        Wed,  6 Oct 2021 11:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633518758;
        bh=BsZVcu9Qk8VGiRAyMaJp5xgphNPWrQZjkYU3qkOqBuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCblspVXcCdAHHDgilkS2SS0FqT953+cxGntr2ztdJRZR5hHof9sq373Pk8W+RPBK
         MMd7wEr5stnz93D2FhTk9iXaWAeGuLv/p4UtacW6IQp35bHngr3TVoUpnckL13IWe7
         IW/OGmOBLmWH0qYichFkPq2C2sR5+ksBYlzkBd/DP2sd3LEEgodyqyKd6NO/AZWo6T
         8dra7Fc5UYyiKXzO+eSdbH8PyEy5VICT7NgMyjtoYub26TvO29qCgRT6L/IopFLwE8
         wW9PlSy+iNxqMcJHm1d+XiajsPiAxExK75m2Je4b+dTyK7pqY5EKK6gsggmgC5DVW/
         T9zTmQ/cQCiDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 2/7] KVM: x86: Handle SRCU initialization failure during page track init
Date:   Wed,  6 Oct 2021 07:12:28 -0400
Message-Id: <20211006111234.264020-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006111234.264020-1-sashal@kernel.org>
References: <20211006111234.264020-1-sashal@kernel.org>
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
 arch/x86/kvm/mmu/page_track.c         | 4 ++--
 arch/x86/kvm/x86.c                    | 7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..6a5f3acf2b33 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
 			    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_page_track_init(struct kvm *kvm);
+int kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 8443a675715b..81cf4babbd0b 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -163,13 +163,13 @@ void kvm_page_track_cleanup(struct kvm *kvm)
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
index 75c59ad27e9f..d65da3b5837b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10392,9 +10392,15 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
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
@@ -10421,7 +10427,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
 	kvm_hv_init_vm(kvm);
-	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
 
 	return kvm_x86_ops.vm_init(kvm);
-- 
2.33.0

