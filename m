Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419EB201631
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394798AbgFSQ1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389989AbgFSOzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:55:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F0E62158C;
        Fri, 19 Jun 2020 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578539;
        bh=We1j8t3ry/5aeI/mTNzvMj2rnXXr23+3mHuJif/Bsew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U27KDNV+7peOZ98HU11ZDyrouwFEjGxvnDdZCGD3iTWheCxmBw3mVeOIXs4Hm5TUu
         3VKQhQMcqVe1nO/CxmVBECEROy5ys7ugKrtN6+zPdp3s2+PCBDGZe9PG+yfEi2FExY
         7Qo7OTH8sA0srfq4xn0u3oylnXtfBDlXapuLzIwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/267] KVM: x86: only do L1TF workaround on affected processors
Date:   Fri, 19 Jun 2020 16:30:38 +0200
Message-Id: <20200619141651.428799275@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit d43e2675e96fc6ae1a633b6a69d296394448cc32 ]

KVM stores the gfn in MMIO SPTEs as a caching optimization.  These are split
in two parts, as in "[high 11111 low]", to thwart any attempt to use these bits
in an L1TF attack.  This works as long as there are 5 free bits between
MAXPHYADDR and bit 50 (inclusive), leaving bit 51 free so that the MMIO
access triggers a reserved-bit-set page fault.

The bit positions however were computed wrongly for AMD processors that have
encryption support.  In this case, x86_phys_bits is reduced (for example
from 48 to 43, to account for the C bit at position 47 and four bits used
internally to store the SEV ASID and other stuff) while x86_cache_bits in
would remain set to 48, and _all_ bits between the reduced MAXPHYADDR
and bit 51 are set.  Then low_phys_bits would also cover some of the
bits that are set in the shadow_mmio_value, terribly confusing the gfn
caching mechanism.

To fix this, avoid splitting gfns as long as the processor does not have
the L1TF bug (which includes all AMD processors).  When there is no
splitting, low_phys_bits can be set to the reduced MAXPHYADDR removing
the overlap.  This fixes "npt=0" operation on EPYC processors.

Thanks to Maxim Levitsky for bisecting this bug.

Cc: stable@vger.kernel.org
Fixes: 52918ed5fcf0 ("KVM: SVM: Override default MMIO mask if memory encryption is enabled")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ac0a794267d4..18632f15b29f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -294,6 +294,8 @@ kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value)
 {
 	BUG_ON((mmio_mask & mmio_value) != mmio_value);
+	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
+	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 	shadow_mmio_value = mmio_value | SPTE_SPECIAL_MASK;
 	shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
 }
@@ -486,16 +488,15 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	 * the most significant bits of legal physical address space.
 	 */
 	shadow_nonpresent_or_rsvd_mask = 0;
-	low_phys_bits = boot_cpu_data.x86_cache_bits;
-	if (boot_cpu_data.x86_cache_bits <
-	    52 - shadow_nonpresent_or_rsvd_mask_len) {
+	low_phys_bits = boot_cpu_data.x86_phys_bits;
+	if (boot_cpu_has_bug(X86_BUG_L1TF) &&
+	    !WARN_ON_ONCE(boot_cpu_data.x86_cache_bits >=
+			  52 - shadow_nonpresent_or_rsvd_mask_len)) {
+		low_phys_bits = boot_cpu_data.x86_cache_bits
+			- shadow_nonpresent_or_rsvd_mask_len;
 		shadow_nonpresent_or_rsvd_mask =
-			rsvd_bits(boot_cpu_data.x86_cache_bits -
-				  shadow_nonpresent_or_rsvd_mask_len,
-				  boot_cpu_data.x86_cache_bits - 1);
-		low_phys_bits -= shadow_nonpresent_or_rsvd_mask_len;
-	} else
-		WARN_ON_ONCE(boot_cpu_has_bug(X86_BUG_L1TF));
+			rsvd_bits(low_phys_bits, boot_cpu_data.x86_cache_bits - 1);
+	}
 
 	shadow_nonpresent_or_rsvd_lower_gfn_mask =
 		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
-- 
2.25.1



