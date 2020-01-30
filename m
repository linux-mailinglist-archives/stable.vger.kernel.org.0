Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72F114E070
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgA3SCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:02:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51340 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgA3SCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 13:02:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so4815179wmi.1;
        Thu, 30 Jan 2020 10:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DhUW9seRv5U8Ur+TZJeJyck3fzD5Hy4XW/Hd42LBGS8=;
        b=u/7u2yN6SPuA0R5p73qwMh+sEHAKhUZytQ3tjDPxRMeRuwcbM+rGuZ58Qtb9785QWs
         RAIkggzMelXn/x/k+vmfelAsnpiq/tDd3o4movQGyr9HP7x+/nvN3/Z7cKj0U9TqXMp5
         CYomC8xRD930BOGr8jPToaGoyU7xSWnMUR837VkBKShdyWwwcSz8ZwTAWfxj98uYUFZ7
         xdkeylMXjTFGxEIjH2Zl1NVCxWAYZPZJ6ReWM1zm9auOa3BArCVtEtltmDozLRKjkJy3
         ETFQXxFrIoBPa/axKbOhoW/ixgxe4Ln157G9PuMjHGnRGvJ5FEenF6SJVrNMEe6G2vPD
         XHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=DhUW9seRv5U8Ur+TZJeJyck3fzD5Hy4XW/Hd42LBGS8=;
        b=h7zSUCapDqFLaixN1XqBPnX8SPefNnMC+S2VkEziHuK9TzkyGy/BlW7VFWSHd7cIZg
         qvN/nJ64kqqS3T/kPmoCsVLYev1i4h/AUrYgl/s2AKZf5vqskUgyZDbc6J/E5NjISfCA
         Y5XLT8S0Voe1sT/vLdMLphZKmfsljYd//mfOLPTHhLzZvDwsGkNYwO/LkZZWhX4USzm1
         CqqNh7IrPXhBZdTISWOt298YPB0Eupisgo3rDDTa8k2UjnCvywVDNkRVV1dPYUe+XVH9
         X8bpNk/JtlIJ6qcX71AIKtqJPfU2bw0nC/OH2emGPW998e6cCqyHhldpGQ45A5u6p8ky
         HOBg==
X-Gm-Message-State: APjAAAVbtFlrQBMlAByjT1BMmnqMZ7plj/+be+jpG9N+YgkU82Q8VVpq
        pbLNBEKe6YsJPufhh97z8AXD3K+K+jA=
X-Google-Smtp-Source: APXvYqwyANNPQvDEEq66fJpve9tUMGVDh8EU/kUbSQJeaOxQ8eaB/ncL0Gxi9/PxCzb2Rxo5V6/mdQ==
X-Received: by 2002:a05:600c:211:: with SMTP id 17mr6800817wmi.60.1580407324358;
        Thu, 30 Jan 2020 10:02:04 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w19sm6956878wmc.22.2020.01.30.10.02.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:02:03 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
Subject: [FYI PATCH 4/5] x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed
Date:   Thu, 30 Jan 2020 19:01:55 +0100
Message-Id: <1580407316-11391-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
References: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

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
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 51 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0795bc8..f1845df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2581,45 +2581,47 @@ static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 
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
 	trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
-		vcpu->arch.st.steal.preempted & KVM_VCPU_FLUSH_TLB);
-	if (xchg(&vcpu->arch.st.steal.preempted, 0) & KVM_VCPU_FLUSH_TLB)
+		st->preempted & KVM_VCPU_FLUSH_TLB);
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
@@ -3501,18 +3503,25 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
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
1.8.3.1

