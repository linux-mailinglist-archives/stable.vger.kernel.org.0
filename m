Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27193409322
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344167AbhIMOSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345162AbhIMOQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9B161439;
        Mon, 13 Sep 2021 13:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540661;
        bh=HYTbBeMUiqGBjrz1+FdIckWRVW1XjyEFBxKp4Hthdss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbKh4p7+YsFiFZXjwG+gfWO4YTY/t+ea/prAdw0Hw7/8R2As7byN+zeaGEO8iSnyT
         25Apda7bLkEEefHOiCsqbqt18diKWAWHDZ1WZUVbKDcEw1JZejVfYaS2AOt9yk3ZMX
         Qrr8IZQzAMxiBH/xz9I75e4K7hDR0F+KJViPos0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 284/300] KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in TDP MMU lpage stats
Date:   Mon, 13 Sep 2021 15:15:45 +0200
Message-Id: <20210913131118.935518502@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 088acd23526647844aec1c39db4ad02552c86c7b upstream.

Factor in whether or not the old/new SPTEs are shadow-present when
adjusting the large page stats in the TDP MMU.  A modified MMIO SPTE can
toggle the page size bit, as bit 7 is used to store the MMIO generation,
i.e. is_large_pte() can get a false positive when called on a MMIO SPTE.
Ditto for nuking SPTEs with REMOVED_SPTE, which sets bit 7 in its magic
value.

Opportunistically move the logic below the check to verify at least one
of the old/new SPTEs is shadow present.

Use is/was_leaf even though is/was_present would suffice.  The code
generation is roughly equivalent since all flags need to be computed
prior to the code in question, and using the *_leaf flags will minimize
the diff in a future enhancement to account all pages, i.e. will change
the check to "is_leaf != was_leaf".

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>

Fixes: 1699f65c8b65 ("kvm/x86: Fix 'lpages' kvm stat for TDM MMU")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Message-Id: <20210803044607.599629-3-mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -410,6 +410,7 @@ static void __handle_changed_spte(struct
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool was_large, is_large;
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -443,13 +444,6 @@ static void __handle_changed_spte(struct
 
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
-	if (is_large_pte(old_spte) != is_large_pte(new_spte)) {
-		if (is_large_pte(old_spte))
-			atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
-		else
-			atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
-	}
-
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
@@ -475,6 +469,18 @@ static void __handle_changed_spte(struct
 		return;
 	}
 
+	/*
+	 * Update large page stats if a large page is being zapped, created, or
+	 * is replacing an existing shadow page.
+	 */
+	was_large = was_leaf && is_large_pte(old_spte);
+	is_large = is_leaf && is_large_pte(new_spte);
+	if (was_large != is_large) {
+		if (was_large)
+			atomic64_sub(1, (atomic64_t *)&kvm->stat.lpages);
+		else
+			atomic64_add(1, (atomic64_t *)&kvm->stat.lpages);
+	}
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))


