Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2FF353F1D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbhDEJKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239236AbhDEJJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C0561398;
        Mon,  5 Apr 2021 09:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613774;
        bh=aDOT4DkhX4cM/LM+ZYyGObU2dDtzu0yIuWO3HQ25LNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqD3QfEBpGdncZRMajbP44tODszPiumHMftxvOtxmYvJzio1imvbth4nNw5ZD0Ni7
         AbhM8tgAJZYB9ri19Uy0WCZBh9TCI196AoxDWEr0t0uFKevq9cCv9Hz0DOWnZ+9EcN
         ewcUhu7csGsiuF3cGzi438UD6LWadztd5bRlQ0VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/126] kvm: x86/mmu: Add existing trace points to TDP MMU
Date:   Mon,  5 Apr 2021 10:54:09 +0200
Message-Id: <20210405085033.945369436@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

[ Upstream commit 33dd3574f5fef57c2c6caccf98925d63aa2a8d09 ]

The TDP MMU was initially implemented without some of the usual
tracepoints found in mmu.c. Correct this discrepancy by adding the
missing trace points to the TDP MMU.

Tested: ran the demand paging selftest on an Intel Skylake machine with
	all the trace points used by the TDP MMU enabled and observed
	them firing with expected values.

This patch can be viewed in Gerrit at:
https://linux-review.googlesource.com/c/virt/kvm/kvm/+/3812

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201027175944.1183301-1-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0d17457f1c84..61be95c6db20 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,6 +7,8 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <trace/events/kvm.h>
+
 #ifdef CONFIG_X86_64
 static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
@@ -149,6 +151,8 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->gfn = gfn;
 	sp->tdp_mmu_page = true;
 
+	trace_kvm_mmu_get_page(sp, true);
+
 	return sp;
 }
 
@@ -319,6 +323,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		pt = spte_to_child_pt(old_spte, level);
 		sp = sptep_to_sp(pt);
 
+		trace_kvm_mmu_prepare_zap_page(sp);
+
 		list_del(&sp->link);
 
 		if (sp->lpage_disallowed)
@@ -530,11 +536,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	if (unlikely(is_noslot_pfn(pfn))) {
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 		trace_mark_mmio_spte(iter->sptep, iter->gfn, new_spte);
-	} else
+	} else {
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 pfn, iter->old_spte, prefault, true,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
+		trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
+	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -740,6 +748,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
 		young = 1;
+
+		trace_kvm_age_page(iter.gfn, iter.level, slot, young);
 	}
 
 	return young;
-- 
2.30.1



