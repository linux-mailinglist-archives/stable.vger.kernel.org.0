Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE3535BE28
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbhDLI5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238946AbhDLIzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA7661221;
        Mon, 12 Apr 2021 08:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217635;
        bh=HHC+Vx70WmK07pO/01s/3jWLmBZ1GrZvg5t6wOYVdTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxiRl6SjNeE2YutwOlndLhlsKnqcUhZLasVwC4oHzbhwVM0z0Vpt45qoK3yAZlbKe
         /SPqvY+KmopzoB4nEWhoCyXdo0DORDEQ3vfTolw3YXKxu2TJh/wERejyk14mCpXgnG
         sqELdg517IolzAUs+4HsJhdkvzSVRpzR2sY3NCv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/188] KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
Date:   Mon, 12 Apr 2021 10:40:02 +0200
Message-Id: <20210412084016.576312582@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 048f49809c526348775425420fb5b8e84fd9a133 ]

Honor the "flush needed" return from kvm_tdp_mmu_zap_gfn_range(), which
does the flush itself if and only if it yields (which it will never do in
this particular scenario), and otherwise expects the caller to do the
flush.  If pages are zapped from the TDP MMU but not the legacy MMU, then
no flush will occur.

Fixes: 29cf0f5007a2 ("kvm: x86/mmu: NX largepage recovery for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210325200119.1359384-3-seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dacbd13d32c6..354f9926a183 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5972,6 +5972,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	struct kvm_mmu_page *sp;
 	unsigned int ratio;
 	LIST_HEAD(invalid_list);
+	bool flush = false;
+	gfn_t gfn_end;
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
@@ -5993,19 +5995,20 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (sp->tdp_mmu_page)
-			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
-				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
-		else {
+			gfn_end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, gfn_end);
+		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
 
 		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 			cond_resched_lock(&kvm->mmu_lock);
+			flush = false;
 		}
 	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
-- 
2.30.2



