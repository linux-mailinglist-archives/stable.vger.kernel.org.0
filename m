Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A44408A25
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbhIML20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239683AbhIML2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:28:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 512C460ED8;
        Mon, 13 Sep 2021 11:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532427;
        bh=+7b1btpt/k1mb1V/DT6i+bNKyTsqwDlO60xH10zGkHY=;
        h=Subject:To:Cc:From:Date:From;
        b=g0/ePbbxJRuGYIaaKGwkEUy1kD/P6C0xwH5fM7nu9D8DNi3HhX81068O3xUYU54wz
         1hfrxdkcmCHurf8NZSEkgOZDgZDfysxytWoY/CugCPJEpurAdD0qaTiqoumSds+RAz
         sXobwPFjfLX70uro222hQae5+FYjR5rscqqzYi3k=
Subject: FAILED: patch "[PATCH] KVM: s390: index kvm->arch.idle_mask by vcpu_idx" failed to apply to 4.9-stable tree
To:     pasic@linux.ibm.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:26:57 +0200
Message-ID: <1631532417179198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3e03bc1368c1bc16e19b001fc96dc7430573cc8 Mon Sep 17 00:00:00 2001
From: Halil Pasic <pasic@linux.ibm.com>
Date: Fri, 27 Aug 2021 14:54:29 +0200
Subject: [PATCH] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 118d5450c523..611f18ecde91 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -963,6 +963,7 @@ struct kvm_arch{
 	atomic64_t cmma_dirty_pages;
 	/* subset of available cpu features enabled by user space */
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
+	/* indexed by vcpu_idx */
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index d548d60caed2..16256e17a544 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -419,13 +419,13 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
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
@@ -3050,18 +3050,18 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu, __u8 __user *buf, int len)
 
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
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5b45c83ced21..e144c8046ceb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4026,7 +4026,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 		kvm_s390_patch_guest_per_regs(vcpu);
 	}
 
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.gisa_int.kicked_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.gisa_int.kicked_mask);
 
 	vcpu->arch.sie_block->icptcode = 0;
 	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 9fad25109b0d..ecd741ee3276 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -79,7 +79,7 @@ static inline int is_vcpu_stopped(struct kvm_vcpu *vcpu)
 
 static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 {
-	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static inline int kvm_is_ucontrol(struct kvm *kvm)

