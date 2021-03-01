Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1503290ED
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhCAURq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242386AbhCAUHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07C0D653A3;
        Mon,  1 Mar 2021 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621548;
        bh=OseaO4BLtckJeJoMZmEqsVv254nmbW++6CQWWbFjepg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NduxOHJa+Ag/gbJQnqMsktu29G1UCxaTspi6UjjTDSNXbU5ZyZHwda0EO8v1BiDIk
         pSKHhPUm4XG1C7Epx0RDsbQHuTVK0p1/kE1IQNTwgQzO9JiFomUHivybmKCc2VyOnK
         Fz6NVNv0oFCBjqb8ZrlGh8w02TX1skssKAdxF/G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 556/775] KVM: x86/mmu: Expand collapsible SPTE zap for TDP MMU to ZONE_DEVICE and HugeTLB pages
Date:   Mon,  1 Mar 2021 17:12:04 +0100
Message-Id: <20210301161228.955758720@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c060c72ffeb448fbb5864faa1f672ebfe14dd25f ]

Zap SPTEs that are backed by ZONE_DEVICE pages when zappings SPTEs to
rebuild them as huge pages in the TDP MMU.  ZONE_DEVICE huge pages are
managed differently than "regular" pages and are not compound pages.
Likewise, PageTransCompoundMap() will not detect HugeTLB, so switch
to PageCompound().

This matches the similar check in kvm_mmu_zap_collapsible_spte.

Cc: Ben Gardon <bgardon@google.com>
Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210213005015.1651772-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b56d604809b8a..17976998bffbc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1067,7 +1067,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		pfn = spte_to_pfn(iter.old_spte);
 		if (kvm_is_reserved_pfn(pfn) ||
-		    !PageTransCompoundMap(pfn_to_page(pfn)))
+		    (!PageCompound(pfn_to_page(pfn)) &&
+		     !kvm_is_zone_device_pfn(pfn)))
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-- 
2.27.0



