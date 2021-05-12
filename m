Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C9137C556
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhELPjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234577AbhELPdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:33:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B3BB611F0;
        Wed, 12 May 2021 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832620;
        bh=p2s4egqZMpRAULSV02V+fhZ0C233G0Pagr+/U4AKZfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ow+QOuZUq2pOV8HLNT5UX4A5lr3apGtV+dnKX/iKQYXfK0mlR1MVk9eTAdxhNcz/p
         7qk0YyaK4Ln618CgekKSE0RwD2q7tMY1Fvx6LXYV/Rsne86OTphb+vW2zWT0VCrPF/
         5rqXsxbrnth8Rw9UXYat+LYMI77KpvUY+EbNF6vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/530] KVM: x86/mmu: Retry page faults that hit an invalid memslot
Date:   Wed, 12 May 2021 16:47:44 +0200
Message-Id: <20210512144831.418086363@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit e0c378684b6545ad2d4403bb701d0ac4932b4e95 ]

Retry page faults (re-enter the guest) that hit an invalid memslot
instead of treating the memslot as not existing, i.e. handling the
page fault as an MMIO access.  When deleting a memslot, SPTEs aren't
zapped and the TLBs aren't flushed until after the memslot has been
marked invalid.

Handling the invalid slot as MMIO means there's a small window where a
page fault could replace a valid SPTE with an MMIO SPTE.  The legacy
MMU handles such a scenario cleanly, but the TDP MMU assumes such
behavior is impossible (see the BUG() in __handle_changed_spte()).
There's really no good reason why the legacy MMU should allow such a
scenario, and closing this hole allows for additional cleanups.

Fixes: 2f2fad0897cb ("kvm: x86/mmu: Add functions to handle changed TDP SPTEs")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210225204749.1512652-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d37068b7cd5..2f2576fd343e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3663,6 +3663,14 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
 
+	/*
+	 * Retry the page fault if the gfn hit a memslot that is being deleted
+	 * or moved.  This ensures any existing SPTEs for the old memslot will
+	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
+	 */
+	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
+		return true;
+
 	/* Don't expose private memslots to L2. */
 	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
 		*pfn = KVM_PFN_NOSLOT;
-- 
2.30.2



