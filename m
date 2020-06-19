Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2C9200C7C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgFSOq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388830AbgFSOqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:46:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2E220A8B;
        Fri, 19 Jun 2020 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577981;
        bh=cl+Qa9of2+ImP93BrZEA1KX/57I+CEY5bH/50wtml6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suyE28OSANH0dKyfeaUxjIKd+cMZR6s8yEdZTCyaJo69/RTSE11hKnEAAKG24Vgrw
         dTro8aihn7grS/NI/zLoV3cT2rIoKmjRaVlwzNoB/VoDJELAd0eKYp8v/ojsTxD8oA
         tFoZ2gNUsOgOjyrPb9C1wwWmeUErexeYIewk4aAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/190] KVM: x86/mmu: Consolidate "is MMIO SPTE" code
Date:   Fri, 19 Jun 2020 16:31:22 +0200
Message-Id: <20200619141635.432266855@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 26c44a63a291893e0a00f01e96b6e1d0310a79a9 ]

Replace the open-coded "is MMIO SPTE" checks in the MMU warnings
related to software-based access/dirty tracking to make the code
slightly more self-documenting.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2e558c814883..d8878266553c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -280,6 +280,11 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
+static bool is_mmio_spte(u64 spte)
+{
+	return (spte & shadow_mmio_mask) == shadow_mmio_value;
+}
+
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 {
 	return sp->role.ad_disabled;
@@ -287,7 +292,7 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 
 static inline bool spte_ad_enabled(u64 spte)
 {
-	MMU_WARN_ON((spte & shadow_mmio_mask) == shadow_mmio_value);
+	MMU_WARN_ON(is_mmio_spte(spte));
 	return !(spte & shadow_acc_track_value);
 }
 
@@ -298,13 +303,13 @@ static bool is_nx_huge_page_enabled(void)
 
 static inline u64 spte_shadow_accessed_mask(u64 spte)
 {
-	MMU_WARN_ON((spte & shadow_mmio_mask) == shadow_mmio_value);
+	MMU_WARN_ON(is_mmio_spte(spte));
 	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
 }
 
 static inline u64 spte_shadow_dirty_mask(u64 spte)
 {
-	MMU_WARN_ON((spte & shadow_mmio_mask) == shadow_mmio_value);
+	MMU_WARN_ON(is_mmio_spte(spte));
 	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
 }
 
@@ -374,11 +379,6 @@ static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
 	mmu_spte_set(sptep, mask);
 }
 
-static bool is_mmio_spte(u64 spte)
-{
-	return (spte & shadow_mmio_mask) == shadow_mmio_value;
-}
-
 static gfn_t get_mmio_spte_gfn(u64 spte)
 {
 	u64 gpa = spte & shadow_nonpresent_or_rsvd_lower_gfn_mask;
-- 
2.25.1



