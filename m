Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95443420EE8
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbhJDN3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236775AbhJDN12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0849A61B7B;
        Mon,  4 Oct 2021 13:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353123;
        bh=sbVyS3b/pe/VN4ve5UOz0/7q/rDxrzYHx53sOjsguEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tgIgQqylWAKTkDPVNF9ldMtELmgjkozozPh+EBqIYGQXjgiO0T3UUHLhNcI1cYBG
         caJ05PHgWn5dHpEkh0RTUEQlq571NKsTMeDKwHSsjfYiVweBRr2+ayqSPcSoNUEq4B
         5y8NEg0ORxd+xnhMSFpXeD12mjmyQ6FjH+s/nELo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TCS Robot <tcs_robot@tencent.com>,
        Haimin Zhang <tcs_kernel@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 91/93] KVM: x86: Handle SRCU initialization failure during page track init
Date:   Mon,  4 Oct 2021 14:53:29 +0200
Message-Id: <20211004125037.599892813@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

commit eb7511bf9182292ef1df1082d23039e856d1ddfb upstream.

Check the return of init_srcu_struct(), which can fail due to OOM, when
initializing the page track mechanism.  Lack of checking leads to a NULL
pointer deref found by a modified syzkaller.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Message-Id: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
[Move the call towards the beginning of kvm_arch_init_vm. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_page_track.h |    2 +-
 arch/x86/kvm/mmu/page_track.c         |    4 ++--
 arch/x86/kvm/x86.c                    |    7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
 			    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_page_track_init(struct kvm *kvm);
+int kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -163,13 +163,13 @@ void kvm_page_track_cleanup(struct kvm *
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
@@ -10421,7 +10427,6 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
 	kvm_hv_init_vm(kvm);
-	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
 
 	return kvm_x86_ops.vm_init(kvm);


