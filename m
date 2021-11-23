Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D635B45A81D
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbhKWQjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:39:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235635AbhKWQjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:39:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DFED60F6F;
        Tue, 23 Nov 2021 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685395;
        bh=MHm7YiGN0kEulyLv2J4zpUT4iWdPOPy33Yxe1Sb/iBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8o4yPdMu2A0CyyLk4CooV4j1Hswc8qxHLBdvVE4FIO5ugia+EhMUtSxlKVa/3ZQ7
         IYb5BXCHw3baxBvqMpR5yliH7sFMrHnbHRXNDRPOmGHPzuDogGEcmgzy08ixROih71
         5ktOHS7RJq4DMo2FIh9SCdRUW/OVNU0IvRqSzvk+KsBY0qwSqN/GBGIev4di2zL72/
         kkpj3FDvxhOObTayQ0GXiPbvHODyYNaYCbBEnaZpiwRSv+nuv1Tl4VpZhOvLuNtxCY
         X9qg0X7FjlDxNO+060LrJ8HXy9tlTPhG8jUqtMFGDu8Z/xsFIQmoo3MREcnt6E43oS
         psci4I8qn1f0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 2/8] KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
Date:   Tue, 23 Nov 2021 11:36:24 -0500
Message-Id: <20211123163630.289306-2-sashal@kernel.org>
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

[ Upstream commit 552617382c197949ff965a3559da8952bf3c1fa5 ]

X86_CR4_PCIDE doesn't participate in kvm_mmu_role, so the mmu context
doesn't need to be reset.  It is only required to flush all the guest
tlb.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210919024246.89230-2-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0644f429f848c..98a0f3c28caec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1042,9 +1042,10 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
-	if (((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) ||
-	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
+	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
 
-- 
2.33.0

