Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBC63C5296
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244525AbhGLHrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346057AbhGLHpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:45:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADC1A613EF;
        Mon, 12 Jul 2021 07:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075708;
        bh=JugIt2GtSf8jOibmRPPPRdzqxEO3gyA5Ebhb4OZ56JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbyXUnKNQIIEeCxkq0bzf7uYwu1Gn48fAQ+c2/o90VE+SXVs2q9WgyN8Bp2n7k9AC
         D0wavevJ93+kzn2c6UhLYNxD3U28Z63GPjM99FJCs+oRIfN50lkwZfH+7l3dIANZiU
         h4JRhkd0x71K2UTPDu8JqpOaIC6cNgwzhpeWhw9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 328/800] KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
Date:   Mon, 12 Jul 2021 08:05:51 +0200
Message-Id: <20210712061001.224957616@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit 57a3e96d6d17ae5ac9861ef34af024a627f1c3bb ]

Currently tdp_mmu_map_handle_target_level() returns 0, which is
RET_PF_RETRY, when page fault is actually fixed.  This makes
kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
RET_PF_FIXED.  Fix by initializing ret to RET_PF_FIXED.

Note that kvm_mmu_page_fault() resumes guest on both RET_PF_RETRY and
RET_PF_FIXED, which means in practice returning the two won't make
difference, so this fix alone won't be necessary for stable tree.

Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Message-Id: <f9e8956223a586cd28c090879a8ff40f5eb6d609.1623717884.git.kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 237317b1eddd..35b0ece7beff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -912,7 +912,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					  kvm_pfn_t pfn, bool prefault)
 {
 	u64 new_spte;
-	int ret = 0;
+	int ret = RET_PF_FIXED;
 	int make_spte_ret = 0;
 
 	if (unlikely(is_noslot_pfn(pfn)))
-- 
2.30.2



