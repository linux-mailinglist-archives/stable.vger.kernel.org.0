Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9C12F141C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbhAKNUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732677AbhAKNRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42A5622AAF;
        Mon, 11 Jan 2021 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371033;
        bh=WFkY3quhZczA/dc/ncx8SFqTyTHRGlXtmolo2hHjofc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJR6YiKXS8A3PNMmbHsB7HpV9yIYrvd0x5pGHP9oAYJlWQaAEZqsvHF6zE6Y2CQGV
         nBNR5cSyQ0VKuO37NdVvMRiSPieKOrW83TRRHvz4DM68ixD3J8GkIl/xkCNQ25PvK3
         h3n3WrsdqXxcAxroxpYlkvTAbs36tAUHUujxn/6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Herbert <rherbert@sympatico.ca>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 112/145] KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE
Date:   Mon, 11 Jan 2021 14:02:16 +0100
Message-Id: <20210111130053.909763007@linuxfoundation.org>
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

commit 39b4d43e6003cee51cd119596d3c33d0449eb44c upstream.

Get the so called "root" level from the low level shadow page table
walkers instead of manually attempting to calculate it higher up the
stack, e.g. in get_mmio_spte().  When KVM is using PAE shadow paging,
the starting level of the walk, from the callers perspective, is not
the CR3 root but rather the PDPTR "root".  Checking for reserved bits
from the CR3 root causes get_mmio_spte() to consume uninitialized stack
data due to indexing into sptes[] for a level that was not filled by
get_walk().  This can result in false positives and/or negatives
depending on what garbage happens to be on the stack.

Opportunistically nuke a few extra newlines.

Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
Reported-by: Richard Herbert <rherbert@sympatico.ca>
Cc: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20201218003139.2167891-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/mmu.c     |   15 ++++++---------
 arch/x86/kvm/mmu/tdp_mmu.c |    5 ++++-
 arch/x86/kvm/mmu/tdp_mmu.h |    4 +++-
 3 files changed, 13 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3485,16 +3485,16 @@ static bool mmio_info_in_cache(struct kv
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
  */
-static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	int leaf = -1;
 	u64 spte;
 
-
 	walk_shadow_page_lockless_begin(vcpu);
 
-	for (shadow_walk_init(&iterator, vcpu, addr);
+	for (shadow_walk_init(&iterator, vcpu, addr),
+	     *root_level = iterator.level;
 	     shadow_walk_okay(&iterator);
 	     __shadow_walk_next(&iterator, spte)) {
 		leaf = iterator.level;
@@ -3504,7 +3504,6 @@ static int get_walk(struct kvm_vcpu *vcp
 
 		if (!is_shadow_present_pte(spte))
 			break;
-
 	}
 
 	walk_shadow_page_lockless_end(vcpu);
@@ -3517,9 +3516,7 @@ static bool get_mmio_spte(struct kvm_vcp
 {
 	u64 sptes[PT64_ROOT_MAX_LEVEL];
 	struct rsvd_bits_validate *rsvd_check;
-	int root = vcpu->arch.mmu->shadow_root_level;
-	int leaf;
-	int level;
+	int root, leaf, level;
 	bool reserved = false;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
@@ -3528,9 +3525,9 @@ static bool get_mmio_spte(struct kvm_vcp
 	}
 
 	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
-		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes);
+		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
-		leaf = get_walk(vcpu, addr, sptes);
+		leaf = get_walk(vcpu, addr, sptes, &root);
 
 	if (unlikely(leaf < 0)) {
 		*sptep = 0ull;
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1148,13 +1148,16 @@ bool kvm_tdp_mmu_write_protect_gfn(struc
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
+	*root_level = vcpu->arch.mmu->shadow_root_level;
+
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf - 1] = iter.old_spte;
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -44,5 +44,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(s
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
 
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes);
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level);
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */


