Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88281BCB0D
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgD1SeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbgD1SeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C52D20B80;
        Tue, 28 Apr 2020 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098846;
        bh=9k2uZ6RQiqnzLgXK2TCNkD6hSDYgS+p6jb9lpz1K5iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYrMZcvkjul1pVo6fVCIARno4lDHHbv2LHK2X2cyQty7uumsEoi8JNGDaN4vvZddI
         bzjfHqr4htNi+VwkgPsm6h4dxaxxbI3XdpExJMcdmn6AmDE1/r3kVAucC6IcK+F2Dr
         fEjK3UPXbHk1GIwzk8wpEgoRVkdexEPx9wDHYYvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/131] x86/KVM: Clean up hosts steal time structure
Date:   Tue, 28 Apr 2020 20:24:24 +0200
Message-Id: <20200428182231.504632549@linuxfoundation.org>
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

commit a6bd811f1209fe1c64c9f6fd578101d6436c6b6e upstream.

Now that we are mapping kvm_steal_time from the guest directly we
don't need keep a copy of it in kvm_vcpu_arch.st. The same is true
for the stime field.

This is part of CVE-2019-3016.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/x86.c              | 11 +++--------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ca9c7110b99dd..33136395db8fc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -622,10 +622,9 @@ struct kvm_vcpu_arch {
 	bool pvclock_set_guest_stopped_request;
 
 	struct {
+		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_hva_cache stime;
-		struct kvm_steal_time steal;
 		struct gfn_to_pfn_cache cache;
 	} st;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d77822e03ff6b..6bfc9eaf8dee0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2418,7 +2418,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
 		kvm_vcpu_flush_tlb(vcpu, false);
 
-	vcpu->arch.st.steal.preempted = 0;
+	vcpu->arch.st.preempted = 0;
 
 	if (st->version & 1)
 		st->version += 1;  /* first time write, random junk */
@@ -2577,11 +2577,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & KVM_STEAL_RESERVED_MASK)
 			return 1;
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
-						data & KVM_STEAL_VALID_BITS,
-						sizeof(struct kvm_steal_time)))
-			return 1;
-
 		vcpu->arch.st.msr_val = data;
 
 		if (!(data & KVM_MSR_ENABLED))
@@ -3280,7 +3275,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
-	if (vcpu->arch.st.steal.preempted)
+	if (vcpu->arch.st.preempted)
 		return;
 
 	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
@@ -3290,7 +3285,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	st = map.hva +
 		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
 
-	st->preempted = vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
+	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
 }
-- 
2.20.1



