Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6310A1BC87F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgD1SdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbgD1SdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD1221835;
        Tue, 28 Apr 2020 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098792;
        bh=s48c0xA9AWOzYkT8z8qRtALlO98KGhNl0F4y/Xz6oqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HocLgYQS5bGdUopXnrmfiNZ0Ab8qIgET6or/iuVp34VoyBzxoLdhi39E3n2gf6Z6L
         k/OkaDplaLIEWh6pOH5dF9qagCQIOVjxmaxyn/x1M8/RHvTnQzRVYsBjJEEG7AI+nt
         BvwicFOD+p+w3TUa3OZCsGHlphR6lWoVF2/0ZO30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/131] x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed
Date:   Tue, 28 Apr 2020 20:24:23 +0200
Message-Id: <20200428182231.389944621@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit b043138246a41064527cf019a3d51d9f015e9796 upstream.

There is a potential race in record_steal_time() between setting
host-local vcpu->arch.st.steal.preempted to zero (i.e. clearing
KVM_VCPU_PREEMPTED) and propagating this value to the guest with
kvm_write_guest_cached(). Between those two events the guest may
still see KVM_VCPU_PREEMPTED in its copy of kvm_steal_time, set
KVM_VCPU_FLUSH_TLB and assume that hypervisor will do the right
thing. Which it won't.

Instad of copying, we should map kvm_steal_time and that will
guarantee atomicity of accesses to @preempted.

This is part of CVE-2019-3016.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.19: No tracepoint in record_steal_time().]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 49 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6916f46909ab0..d77822e03ff6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2397,43 +2397,45 @@ static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
+	struct kvm_host_map map;
+	struct kvm_steal_time *st;
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
-	if (unlikely(kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
-		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time))))
+	/* -EAGAIN is returned in atomic context so we can just return. */
+	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
+			&map, &vcpu->arch.st.cache, false))
 		return;
 
+	st = map.hva +
+		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
-	if (xchg(&vcpu->arch.st.steal.preempted, 0) & KVM_VCPU_FLUSH_TLB)
+	if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
 		kvm_vcpu_flush_tlb(vcpu, false);
 
-	if (vcpu->arch.st.steal.version & 1)
-		vcpu->arch.st.steal.version += 1;  /* first time write, random junk */
+	vcpu->arch.st.steal.preempted = 0;
 
-	vcpu->arch.st.steal.version += 1;
+	if (st->version & 1)
+		st->version += 1;  /* first time write, random junk */
 
-	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
-		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
+	st->version += 1;
 
 	smp_wmb();
 
-	vcpu->arch.st.steal.steal += current->sched_info.run_delay -
+	st->steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
 
-	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
-		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
-
 	smp_wmb();
 
-	vcpu->arch.st.steal.version += 1;
+	st->version += 1;
 
-	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
-		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
+	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -3272,18 +3274,25 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
+	struct kvm_host_map map;
+	struct kvm_steal_time *st;
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
 	if (vcpu->arch.st.steal.preempted)
 		return;
 
-	vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
+	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
+			&vcpu->arch.st.cache, true))
+		return;
+
+	st = map.hva +
+		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+
+	st->preempted = vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
 
-	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
-			&vcpu->arch.st.steal.preempted,
-			offsetof(struct kvm_steal_time, preempted),
-			sizeof(vcpu->arch.st.steal.preempted));
+	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-- 
2.20.1



