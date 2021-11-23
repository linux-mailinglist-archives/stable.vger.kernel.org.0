Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C345A821
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhKWQjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236142AbhKWQjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:39:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D201460F90;
        Tue, 23 Nov 2021 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685397;
        bh=8Q7n2+A7eXwhNLS3rVRVU8pSBDLJsuv9+yxPvog26JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHZd7RHNMuluRb0CIOPd8hn0ulmc5lHiowfKrZdfOrO4svFxgC/flkGhBCumOiNq0
         bCaoGTJnOel18KnecfG7guWi0f2kRcjQabQ9OzClcFdNrMp4U+hw/IkHNGH0lwH2wn
         rqH0g5mKSkv2BVKJxfzFOQCLGjBXPdy3/ssb4aEgixDU4TxkEabNsrMshatJ2gHvwL
         /2p4StbMNJDvN96k5MM6nJILj6MKRRbow4BKSWSOPPePVc2orPtVsvuppNSDcaF7yt
         Kxx/nLxsZfN9fTh3Ti78WfIKZ6bJ5sMVSWkiK9oUYEGJMJve/kwNYnYegvbEPZP1vo
         EKdchTv1kyORQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 3/8] KVM: X86: Don't check unsync if the original spte is writible
Date:   Tue, 23 Nov 2021 11:36:25 -0500
Message-Id: <20211123163630.289306-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163630.289306-1-sashal@kernel.org>
References: <20211123163630.289306-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit 8b8f9d753b84c243bf0b1004b515c53b7ec7e138 ]

If the original spte is writable, the target gfn should not be the
gfn of synchronized shadowpage and can continue to be writable.

When !can_unsync, speculative must be false.  So when the check of
"!can_unsync" is removed, we need to move the label of "out" up.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210918005636.3675-11-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/spte.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3e97cdb13eb7e..86a21eb85d25f 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -150,7 +150,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writable_pte(old_spte))
+		if (is_writable_pte(old_spte))
 			goto out;
 
 		/*
@@ -171,10 +171,10 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 	if (pte_access & ACC_WRITE_MASK)
 		spte |= spte_shadow_dirty_mask(spte);
 
+out:
 	if (speculative)
 		spte = mark_spte_for_access_track(spte);
 
-out:
 	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
-- 
2.33.0

