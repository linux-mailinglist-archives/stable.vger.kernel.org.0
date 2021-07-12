Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F513C4DA1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbhGLHNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245405AbhGLHMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB1D61006;
        Mon, 12 Jul 2021 07:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073774;
        bh=zs2iCVfLhabpPBv7Qs0DHn84/XSM8RTgq6Y6Z4Nmh48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3vMTa3Lh524CAKObH34UOTB5FjbT+YB1BUSuzRPXms6D1hzpiBGjnib1U1TeYD9h
         192jIS9xP67XZaYCzHuhQFR+xZ44H/hZYndmvZ0WX7qcaLb62SYaYFBktSSjjRvNKn
         leVCORN/BY7kXwDw3xtGcibx+C0jCroIbbS6kxOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 302/700] KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
Date:   Mon, 12 Jul 2021 08:06:25 +0200
Message-Id: <20210712061008.512163414@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit 857f84743e4b78500afae010d866675642e18e90 ]

Currently pf_fixed is not increased when prefault is true.  This is not
correct, since prefault here really means "async page fault completed".
In that case, the original page fault from the guest was morphed into as
async page fault and pf_fixed was not increased.  So when prefault
indicates async page fault is completed, pf_fixed should be increased.

Additionally, currently pf_fixed is also increased even when page fault
is spurious, while legacy MMU increases pf_fixed when page fault returns
RET_PF_EMULATE or RET_PF_FIXED.

To fix above two issues, change to increase pf_fixed when return value
is not RET_PF_SPURIOUS (RET_PF_RETRY has already been ruled out by
reaching here).

More information:
https://lore.kernel.org/kvm/cover.1620200410.git.kai.huang@intel.com/T/#mbb5f8083e58a2cd262231512b9211cbe70fc3bd5

Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Message-Id: <2ea8b7f5d4f03c99b32bc56fc982e1e4e3d3fc6b.1623717884.git.kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7cfb55788df5..5c83b912becc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -782,7 +782,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 				       rcu_dereference(iter->sptep));
 	}
 
-	if (!prefault)
+	/*
+	 * Increase pf_fixed in both RET_PF_EMULATE and RET_PF_FIXED to be
+	 * consistent with legacy MMU behavior.
+	 */
+	if (ret != RET_PF_SPURIOUS)
 		vcpu->stat.pf_fixed++;
 
 	return ret;
-- 
2.30.2



