Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FA8409652
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhIMOvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346907AbhIMOrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9A3063232;
        Mon, 13 Sep 2021 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541542;
        bh=5HmtmxxPqkM5P2ZZ7KFz5rLwcy+22pd/Nuk+6xoBBS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mkbTk4O+R4JvivmpgXyJgYpRjqNJfewPYVihfln6rueu9/Mq5UiJ8QFHigOGcEjo
         pn3YAvxPqTI+wWisnjJcW4YTN32J3ZyZvZ2E/lAZkNPop9/MMmQIoBfqiydgB5Kzft
         QAUbQoLRfpN2bc4YuYSuBhA7DI5bum0Czz0qH4ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.14 311/334] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Date:   Mon, 13 Sep 2021 15:16:05 +0200
Message-Id: <20210913131123.938038934@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit a3e03bc1368c1bc16e19b001fc96dc7430573cc8 upstream.

While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true, it may
not always be, and we must not rely on this. Reason is that KVM decides
the vcpu_idx, userspace decides the vcpu_id, thus the two might not
match.

Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
that code like
for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
                vcpu = kvm_get_vcpu(kvm, vcpu_id);
		do_stuff(vcpu);
}
is not legit. Reason is that kvm_get_vcpu expects an vcpu_idx, not an
vcpu_id.  The trouble is, we do actually use kvm->arch.idle_mask like
this. To fix this problem we have two options. Either use
kvm_get_vcpu_by_id(vcpu_id), which would loop to find the right vcpu_id,
or switch to indexing via vcpu_idx. The latter is preferable for obvious
reasons.

Let us make switch from indexing kvm->arch.idle_mask by vcpu_id to
indexing it by vcpu_idx.  To keep gisa_int.kicked_mask indexed by the
same index as idle_mask lets make the same change for it as well.

Fixes: 1ee0bc559dc3 ("KVM: s390: get rid of local_int array")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christian Bornträger <borntraeger@de.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 3.15+
Link: https://lore.kernel.org/r/20210827125429.1912577-1-pasic@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/kvm_host.h |    1 +
 arch/s390/kvm/interrupt.c        |   12 ++++++------
 arch/s390/kvm/kvm-s390.c         |    2 +-
 arch/s390/kvm/kvm-s390.h         |    2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -957,6 +957,7 @@ struct kvm_arch{
 	atomic64_t cmma_dirty_pages;
 	/* subset of available cpu features enabled by user space */
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
+	/* indexed by vcpu_idx */
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -419,13 +419,13 @@ static unsigned long deliverable_irqs(st
 static void __set_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_WAIT);
-	set_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
@@ -3050,18 +3050,18 @@ int kvm_s390_get_irq_state(struct kvm_vc
 
 static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
 {
-	int vcpu_id, online_vcpus = atomic_read(&kvm->online_vcpus);
+	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
 	struct kvm_vcpu *vcpu;
 
-	for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
-		vcpu = kvm_get_vcpu(kvm, vcpu_id);
+	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
+		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
 		if (psw_ioint_disabled(vcpu))
 			continue;
 		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
 		if (deliverable_mask) {
 			/* lately kicked but not yet running */
-			if (test_and_set_bit(vcpu_id, gi->kicked_mask))
+			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
 				return;
 			kvm_s390_vcpu_wakeup(vcpu);
 			return;
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4044,7 +4044,7 @@ static int vcpu_pre_run(struct kvm_vcpu
 		kvm_s390_patch_guest_per_regs(vcpu);
 	}
 
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.gisa_int.kicked_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.gisa_int.kicked_mask);
 
 	vcpu->arch.sie_block->icptcode = 0;
 	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -79,7 +79,7 @@ static inline int is_vcpu_stopped(struct
 
 static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 {
-	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static inline int kvm_is_ucontrol(struct kvm *kvm)


