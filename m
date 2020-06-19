Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2692015C2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389007AbgFSO5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390172AbgFSO5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:57:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B134D21852;
        Fri, 19 Jun 2020 14:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578622;
        bh=d9xj5dr0nAfh++8H+d0Yf1p2MrGb9TGXnHRFeMCwHf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c011GiJGSsjcvaEwNN9HKO4SsDVjgvmS8Q3j37sQsB2999JGdeDgLHjZY2zVd7bvJ
         1iwhirOpFnfDJOw3rw8Ugco55eE/pUMDw9NgtNQxG3OTATWv5wwW3OYMKtX4wQczaO
         bQE29FI8X9GBVdBcvozXm+X8FrxuvuMCuJJ0FWAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/267] KVM: x86/mmu: Consolidate "is MMIO SPTE" code
Date:   Fri, 19 Jun 2020 16:30:37 +0200
Message-Id: <20200619141651.381887149@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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
index 440ffe810e5d..ac0a794267d4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -299,6 +299,11 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value)
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
@@ -306,7 +311,7 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 
 static inline bool spte_ad_enabled(u64 spte)
 {
-	MMU_WARN_ON((spte & shadow_mmio_mask) == shadow_mmio_value);
+	MMU_WARN_ON(is_mmio_spte(spte));
 	return !(spte & shadow_acc_track_value);
 }
 
@@ -317,13 +322,13 @@ static bool is_nx_huge_page_enabled(void)
 
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
 
@@ -393,11 +398,6 @@ static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
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



