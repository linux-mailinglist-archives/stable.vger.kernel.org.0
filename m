Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0F64120D0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbhITR6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355715AbhITR4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:56:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B59116320E;
        Mon, 20 Sep 2021 17:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158058;
        bh=jygjKuYSAr1zC+kR0YLyJRZABPLOTjAS8JXvQEALrwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mC8W+lOfF8bIYSG2w0NLqGZwuoFkOtmEqaxs1ae3o5qfjt7gstfHq/DVfgCytPAWb
         /pD7IbXlaZt5HvOa5FLXh5XnbtzTLb1s64OaD7QHF/3jQklepP/sohhc0tRBdkrGF7
         CcHhnZ+ke05tUyQn+7aDKoVODc6xz3VAIbdGxf1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 4.19 274/293] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Date:   Mon, 20 Sep 2021 18:43:56 +0200
Message-Id: <20210920163942.795516656@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
[borntraeger@de.ibm.com]: change  idle mask, remove kicked_mask 
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/interrupt.c |    4 ++--
 arch/s390/kvm/kvm-s390.h  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -318,13 +318,13 @@ static unsigned long deliverable_irqs(st
 static void __set_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_WAIT);
-	set_bit(vcpu->vcpu_id, vcpu->kvm->arch.float_int.idle_mask);
+	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.float_int.idle_mask);
 }
 
 static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.float_int.idle_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.float_int.idle_mask);
 }
 
 static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -67,7 +67,7 @@ static inline int is_vcpu_stopped(struct
 
 static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 {
-	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.float_int.idle_mask);
+	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.float_int.idle_mask);
 }
 
 static inline int kvm_is_ucontrol(struct kvm *kvm)


