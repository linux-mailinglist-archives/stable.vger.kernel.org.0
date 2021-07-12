Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FE13C4D26
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbhGLHMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244183AbhGLHK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D072E613D1;
        Mon, 12 Jul 2021 07:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073621;
        bh=/mz2edVgLsGQIrqDJ6rNBI/nqSJZgXx2eNzJGbWh4kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAZ4VNJi/qR+Kc8Fmt8p0z6soEyLtWIW4LB4UhxWQB+zydaylMNMv9e1E09MoFhmn
         WPPk25ZnOzpNpkcAKrz/dGaACfceBj+1E4I8mNVH/IAi63vEq8fE7mS6vp/stOF+bd
         AQuc19dD+vwS/53FepRcRT7fFXH1csJ9Z6H8YFlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 301/700] KVM: x86/mmu: Drop redundant trace_kvm_mmu_set_spte() in the TDP MMU
Date:   Mon, 12 Jul 2021 08:06:24 +0200
Message-Id: <20210712061008.399846592@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 3849e0924ef14a245aa292ecaa9accdc4792012c ]

Remove TDP MMU's call to trace_kvm_mmu_set_spte() that is done for both
shadow-present SPTEs and MMIO SPTEs.  It's fully redundant for the
former, and unnecessary for the latter.  This aligns TDP MMU tracing
behavior with that of the legacy MMU.

Fixes: 33dd3574f5fe ("kvm: x86/mmu: Add existing trace points to TDP MMU")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210225204749.1512652-9-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0aca7dcbcbf9..7cfb55788df5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -777,12 +777,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
 		ret = RET_PF_EMULATE;
-	} else
+	} else {
 		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
 				       rcu_dereference(iter->sptep));
+	}
 
-	trace_kvm_mmu_set_spte(iter->level, iter->gfn,
-			       rcu_dereference(iter->sptep));
 	if (!prefault)
 		vcpu->stat.pf_fixed++;
 
-- 
2.30.2



