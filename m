Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D158B417380
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344450AbhIXM5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345076AbhIXMzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 839B861268;
        Fri, 24 Sep 2021 12:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487855;
        bh=3Dsulu7ppbW/0IoQ+ds6k1avbRsBrYijcpyFPSf7VbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jP90OCkze+hyEKQSEal91sovAVoxublSjPy8MVFTaIq1Bd6NfllFbs2iyNr/8RB0G
         Vob/KXh7w9Of0SpOSH/HruxEF/mq8YlxwD+ehB61HSqGzjqR0x+ON5V+rSufafcY0X
         A4+YiGqWceM6k7twU2Uwowo3UQZzwHIs7g8PpNzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.4 06/50] KVM: remember position in kvm->vcpus array
Date:   Fri, 24 Sep 2021 14:43:55 +0200
Message-Id: <20210924124332.450747933@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radim Krčmář <rkrcmar@redhat.com>

commit 8750e72a79dda2f665ce17b62049f4d62130d991 upstream.

Fetching an index for any vcpu in kvm->vcpus array by traversing
the entire array everytime is costly.
This patch remembers the position of each vcpu in kvm->vcpus array
by storing it in vcpus_idx under kvm_vcpu structure.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[borntraeger@de.ibm.com]: backport to 4.19 (also fits for 5.4)
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |   11 +++--------
 virt/kvm/kvm_main.c      |    5 +++--
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -266,7 +266,8 @@ struct kvm_vcpu {
 	struct preempt_notifier preempt_notifier;
 #endif
 	int cpu;
-	int vcpu_id;
+	int vcpu_id; /* id given by userspace at creation */
+	int vcpu_idx; /* index in kvm->vcpus array */
 	int srcu_idx;
 	int mode;
 	u64 requests;
@@ -571,13 +572,7 @@ static inline struct kvm_vcpu *kvm_get_v
 
 static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *tmp;
-	int idx;
-
-	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
-		if (tmp == vcpu)
-			return idx;
-	BUG();
+	return vcpu->vcpu_idx;
 }
 
 #define kvm_for_each_memslot(memslot, slots)	\
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2864,7 +2864,8 @@ static int kvm_vm_ioctl_create_vcpu(stru
 		goto unlock_vcpu_destroy;
 	}
 
-	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
+	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
+	BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
 
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
@@ -2874,7 +2875,7 @@ static int kvm_vm_ioctl_create_vcpu(stru
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
+	kvm->vcpus[vcpu->vcpu_idx] = vcpu;
 
 	/*
 	 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus


