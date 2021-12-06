Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB658469F32
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391518AbhLFPpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390746AbhLFPmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB156C07E5E7;
        Mon,  6 Dec 2021 07:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87B4FB81135;
        Mon,  6 Dec 2021 15:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AD0C34900;
        Mon,  6 Dec 2021 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804618;
        bh=FHYTGk8iAPAiTDXBO58qYocphM6hJCLik7KJiqrJ/BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vA2DnSdu4dRQS2X+zWAQ1NOUL6EpnwtP/LOAYyaODAYikwfQGWhem8VOH99kl20Ou
         wetpigipW+HhTXKs3nnTSD7oWQY3obzbrcJC1ulDpQaHBI94P3cBdoN4xQNJjD2FwH
         pGwTWvpKATJpQZ27ZP/kvGNVuWjvp9h+adZWW2Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/207] KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k
Date:   Mon,  6 Dec 2021 15:57:13 +0100
Message-Id: <20211206145616.467672594@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

[ Upstream commit 610265ea3da117db435868bd109f1861534a5634 ]

slot_handle_leaf is a misnomer because it only operates on 4K SPTEs
whereas "leaf" is used to describe any valid terminal SPTE (4K or
large page). Rename slot_handle_leaf to slot_handle_level_4k to
avoid confusion.

Making this change makes it more obvious there is a benign discrepency
between the legacy MMU and the TDP MMU when it comes to dirty logging.
The legacy MMU only iterates through 4K SPTEs when zapping for
collapsing and when clearing D-bits. The TDP MMU, on the other hand,
iterates through SPTEs on all levels.

The TDP MMU behavior of zapping SPTEs at all levels is technically
overkill for its current dirty logging implementation, which always
demotes to 4k SPTES, but both the TDP MMU and legacy MMU zap if and only
if the SPTE can be replaced by a larger page, i.e. will not spuriously
zap 2m (or larger) SPTEs. Opportunistically add comments to explain this
discrepency in the code.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20211019162223.3935109-1-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 287fc1086db78..f2e74e8c1651a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5474,8 +5474,8 @@ slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 }
 
 static __always_inline bool
-slot_handle_leaf(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-		 slot_level_handler fn, bool flush_on_yield)
+slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
+		     slot_level_handler fn, bool flush_on_yield)
 {
 	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
 				 PG_LEVEL_4K, flush_on_yield);
@@ -5859,7 +5859,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+		/*
+		 * Zap only 4k SPTEs since the legacy MMU only supports dirty
+		 * logging at a 4k granularity and never creates collapsible
+		 * 2m SPTEs during dirty logging.
+		 */
+		flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
 		if (flush)
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
@@ -5896,8 +5901,11 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
-					 false);
+		/*
+		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
+		 * support dirty logging at a 4k granularity.
+		 */
+		flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.33.0



