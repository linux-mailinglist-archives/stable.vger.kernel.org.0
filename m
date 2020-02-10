Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6188B157516
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgBJMi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbgBJMiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:25 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6A172080C;
        Mon, 10 Feb 2020 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338304;
        bh=GdQsl52W+pf1MM4uLWeCG97tOYAlxd97t1cJcFhk9LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g47R5V0PnCLZ4po/2mAAKikoz5urTckoHj/SbWliHF009kRxreiBxQBo7Lxb/p9gB
         cliIaVo4ec0s3cTKv6kbCdwVHwNYkzL3Pmr8kid4I1Vuxh8F00EyCEtqRuBHdP+QWd
         pa3Zw6CeZUiH6LAsfQDIuxUw4/oG8//8EFaQYfBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 218/309] x86/KVM: Clean up hosts steal time structure
Date:   Mon, 10 Feb 2020 04:32:54 -0800
Message-Id: <20200210122427.498936332@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    3 +--
 arch/x86/kvm/x86.c              |   11 +++--------
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -667,10 +667,9 @@ struct kvm_vcpu_arch {
 	bool pvclock_set_guest_stopped_request;
 
 	struct {
+		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_hva_cache stime;
-		struct kvm_steal_time steal;
 		struct gfn_to_pfn_cache cache;
 	} st;
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2616,7 +2616,7 @@ static void record_steal_time(struct kvm
 	if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
 		kvm_vcpu_flush_tlb(vcpu, false);
 
-	vcpu->arch.st.steal.preempted = 0;
+	vcpu->arch.st.preempted = 0;
 
 	if (st->version & 1)
 		st->version += 1;  /* first time write, random junk */
@@ -2786,11 +2786,6 @@ int kvm_set_msr_common(struct kvm_vcpu *
 		if (data & KVM_STEAL_RESERVED_MASK)
 			return 1;
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
-						data & KVM_STEAL_VALID_BITS,
-						sizeof(struct kvm_steal_time)))
-			return 1;
-
 		vcpu->arch.st.msr_val = data;
 
 		if (!(data & KVM_MSR_ENABLED))
@@ -3504,7 +3499,7 @@ static void kvm_steal_time_set_preempted
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
-	if (vcpu->arch.st.steal.preempted)
+	if (vcpu->arch.st.preempted)
 		return;
 
 	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
@@ -3514,7 +3509,7 @@ static void kvm_steal_time_set_preempted
 	st = map.hva +
 		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
 
-	st->preempted = vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
+	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
 }


