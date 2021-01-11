Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059B62F1418
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732708AbhAKNRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732699AbhAKNRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B046B2255F;
        Mon, 11 Jan 2021 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371029;
        bh=iC9m1BmdeWnt802W7E5xu3hKI66EzCeVlbrciNhPVgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4eKK02y3bluLhKmGLQHrRASOTLgRveLqO7Zf+wOY9hqXMJvUvaQC5O4E3uYfZrRd
         ikgq5Rx+XprfZi0CiAzq4qo3FX2LVB4No0li2kdTdhWqyZ21V2GFLTezxI6I3Mc5S3
         fAWVWLM4rr1diSzky4lbHwRY/W9ZKlZsK/+xBHJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 111/145] KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()
Date:   Mon, 11 Jan 2021 14:02:15 +0100
Message-Id: <20210111130053.862018544@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 2aa078932ff6c66bf10cc5b3144440dbfa7d813d upstream.

Return -1 from the get_walk() helpers if the shadow walk doesn't fill at
least one spte, which can theoretically happen if the walk hits a
not-present PDPTR.  Returning the root level in such a case will cause
get_mmio_spte() to return garbage (uninitialized stack data).  In
practice, such a scenario should be impossible as KVM shouldn't get a
reserved-bit page fault with a not-present PDPTR.

Note, using mmu->root_level in get_walk() is wrong for other reasons,
too, but that's now a moot point.

Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
Cc: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20201218003139.2167891-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/mmu.c     |    7 ++++++-
 arch/x86/kvm/mmu/tdp_mmu.c |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3488,7 +3488,7 @@ static bool mmio_info_in_cache(struct kv
 static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	int leaf = vcpu->arch.mmu->root_level;
+	int leaf = -1;
 	u64 spte;
 
 
@@ -3532,6 +3532,11 @@ static bool get_mmio_spte(struct kvm_vcp
 	else
 		leaf = get_walk(vcpu, addr, sptes);
 
+	if (unlikely(leaf < 0)) {
+		*sptep = 0ull;
+		return reserved;
+	}
+
 	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
 	for (level = root; level >= leaf; level--) {
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1152,8 +1152,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	int leaf = vcpu->arch.mmu->shadow_root_level;
 	gfn_t gfn = addr >> PAGE_SHIFT;
+	int leaf = -1;
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;


