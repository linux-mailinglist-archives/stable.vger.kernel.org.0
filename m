Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D147353F1E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbhDEJKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239261AbhDEJJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A480961394;
        Mon,  5 Apr 2021 09:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613777;
        bh=naVzgU/39qd9FeDVN/IoWsUUSR2Ky4B0p8d3KJGJe38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXDyoBmkErPVfjOzfILfnHLmas1DwmnWFiDvUvwiKH483G1H9H6l7MGfqB1pjnq44
         W7dsU9aCRoG5cfLdJT5JICv6x27eZJnrzKlRRcmYxz42jX2vnrRoAnpl0GJ1FtPJac
         74T1RXKdUNSFSr1lEJGthGxH0bGiTUEl/H76JpP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/126] KVM: x86/mmu: Add lockdep when setting a TDP MMU SPTE
Date:   Mon,  5 Apr 2021 10:54:10 +0200
Message-Id: <20210405085033.984958362@linuxfoundation.org>
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

[ Upstream commit 3a9a4aa5657471a02ffb7f9b7f3b7a468b3f257b ]

Add lockdep to __tdp_mmu_set_spte to ensure that SPTEs are only modified
under the MMU lock.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-4-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 61be95c6db20..ad9f8f187045 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -363,6 +363,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	WRITE_ONCE(*iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-- 
2.30.1



