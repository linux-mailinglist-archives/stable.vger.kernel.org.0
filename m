Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8BE354037
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbhDEJQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240716AbhDEJQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ABC661399;
        Mon,  5 Apr 2021 09:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614183;
        bh=oUC+zcb9FOiFCXZRwrNlt3iLVBoaHrbF4wk3Q7La2jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDQZ8RgoTfMcZQ0iQB+Pht9omxZIIs4sMJaktAXpoP4e0fw77EHyiLXoV7I8KxR61
         idDFngopqBrlXV3NH5G+jm3cLD4A1/I8TVNKqnIfQVWlS5tFMA9knVPeR0Qz7YfMM4
         P61gneKpIDyXkBFXev/G0J5IFcAo3PJYO9NYN4tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 115/152] KVM: x86/mmu: Dont redundantly clear TDP MMU pt memory
Date:   Mon,  5 Apr 2021 10:54:24 +0200
Message-Id: <20210405085037.971371017@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

[ Upstream commit 734e45b329d626d2c14e2bcf8be3d069a33c3316 ]

The KVM MMU caches already guarantee that shadow page table memory will
be zeroed, so there is no reason to re-zero the page in the TDP MMU page
fault handler.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-5-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6bd86bb4c089..4a2b8844f00f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -708,7 +708,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
 			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
 			child_pt = sp->spt;
-			clear_page(child_pt);
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-- 
2.30.1



