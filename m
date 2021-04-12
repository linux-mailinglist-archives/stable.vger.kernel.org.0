Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6A735BFE0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239308AbhDLJHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240303AbhDLJFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEC5B61370;
        Mon, 12 Apr 2021 09:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218170;
        bh=1fM28oRO8QRfQPNZUX7E+hEMFp2XnKuNE1xPiBs5KEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWul2jgD/xxhP4IThtKaG5bPI/4Qh6j/JbsHngwuHA8wMm4ykhmZhyG+UxR4FasOb
         fqVpvjrwzn4Pwdq1NP6CyZjF4MAkMLzIQ/u546Xzvo1rdGTTsqhRBf+Z51t+MAQ18I
         FqVGX+TU6+egNb/x2Kilx22IuWxZlRBwojBUMLPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 098/210] KVM: x86/mmu: Dont allow TDP MMU to yield when recovering NX pages
Date:   Mon, 12 Apr 2021 10:40:03 +0200
Message-Id: <20210412084019.281569015@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 33a3164161fc86b9cc238f7f2aa2ccb1d5559b1c ]

Prevent the TDP MMU from yielding when zapping a gfn range during NX
page recovery.  If a flush is pending from a previous invocation of the
zapping helper, either in the TDP MMU or the legacy MMU, but the TDP MMU
has not accumulated a flush for the current invocation, then yielding
will release mmu_lock with stale TLB entries.

That being said, this isn't technically a bug fix in the current code, as
the TDP MMU will never yield in this case.  tdp_mmu_iter_cond_resched()
will yield if and only if it has made forward progress, as defined by the
current gfn vs. the last yielded (or starting) gfn.  Because zapping a
single shadow page is guaranteed to (a) find that page and (b) step
sideways at the level of the shadow page, the TDP iter will break its loop
before getting a chance to yield.

But that is all very, very subtle, and will break at the slightest sneeze,
e.g. zapping while holding mmu_lock for read would break as the TDP MMU
wouldn't be guaranteed to see the present shadow page, and thus could step
sideways at a lower level.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210325200119.1359384-4-seanjc@google.com>
[Add lockdep assertion. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c     |  6 ++----
 arch/x86/kvm/mmu/tdp_mmu.c |  5 +++--
 arch/x86/kvm/mmu/tdp_mmu.h | 18 +++++++++++++++++-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 64ac8ae4f7a1..387dca3f81cd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5986,7 +5986,6 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	unsigned int ratio;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
-	gfn_t gfn_end;
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
@@ -6007,9 +6006,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
-		if (sp->tdp_mmu_page)
-			gfn_end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
-			flush = kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, gfn_end);
+		if (sp->tdp_mmu_page) {
+			flush = kvm_tdp_mmu_zap_sp(kvm, sp);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0bb62b89476a..a16559f31d94 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -503,13 +503,14 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
+				 bool can_yield)
 {
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root)
-		flush = zap_gfn_range(kvm, root, start, end, true, flush);
+		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
 
 	return flush;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index cbbdbadd1526..a7a3f6db263d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -12,7 +12,23 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
-bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
+				 bool can_yield);
+static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start,
+					     gfn_t end)
+{
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, start, end, true);
+}
+static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
+
+	/*
+	 * Don't allow yielding, as the caller may have pending pages to zap
+	 * on the shadow MMU.
+	 */
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, end, false);
+}
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-- 
2.30.2



