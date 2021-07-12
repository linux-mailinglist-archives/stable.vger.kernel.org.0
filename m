Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E053C4916
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbhGLGly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236218AbhGLGkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81ACD610E5;
        Mon, 12 Jul 2021 06:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071872;
        bh=PXb2Jt7LH3zPrEkslchl23TlNBsAyoMWyQyb3AGHGac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUzT8wN4fu+2TMDoVIqNUoGVxT0aQpR84evwUjv/SQWOOXM5cuTYUAGxQZnyPhVCM
         zVnA98iRGS18L3V6Lf56Ko0geewhkBt3yGZ+M34dDa7/n19MfPZ0mgZI2puM1sxUyp
         GaNFi7NZ+b9dli38/3ok3xrKRvsPuFV/Y861FFr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/593] KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
Date:   Mon, 12 Jul 2021 08:06:57 +0200
Message-Id: <20210712060911.380243236@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 61c00f8631f1..f2ddf663e72e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -527,7 +527,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					  kvm_pfn_t pfn, bool prefault)
 {
 	u64 new_spte;
-	int ret = 0;
+	int ret = RET_PF_FIXED;
 	int make_spte_ret = 0;
 
 	if (unlikely(is_noslot_pfn(pfn))) {
-- 
2.30.2



