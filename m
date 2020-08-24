Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF7924FC85
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 13:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgHXL3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 07:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbgHXL3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 07:29:04 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E1B2074D;
        Mon, 24 Aug 2020 11:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598268540;
        bh=NYiwj+2Xby3LHMGCk1joilOc35OND3SJCoRZ5v2O4ho=;
        h=From:To:Cc:Subject:Date:From;
        b=BJTBpmHdnlW+qaqYVqPtom/sjAATJrACtYHEXriX5yxrKSvR3wb7J4olSa9V0uTtP
         Qm99tVniFcVRhnhIomjjiIA8QbCYoyQbmRpz1ShUaodlmH7jjB7WoHMD/7radwmSiX
         o5Cgg2z6rYKA8X6sAP9YmegCOfAMUlwWxmWRLfdI=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, james.morse@arm.com, pbonzini@redhat.com,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH stable-4.4.y backport] KVM: arm/arm64: Don't reschedule in unmap_stage2_range()
Date:   Mon, 24 Aug 2020 12:28:54 +0100
Message-Id: <20200824112854.24651-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commits fdfe7cbd5880 ("KVM: Pass MMU notifier range flags to
kvm_unmap_hva_range()") and b5331379bc62 ("KVM: arm64: Only reschedule
if MMU_NOTIFIER_RANGE_BLOCKABLE is not set") fix a "sleeping from invalid
context" BUG caused by unmap_stage2_range() attempting to reschedule when
called on the OOM path.

Unfortunately, these patches rely on the MMU notifier callback being
passed knowledge about whether or not blocking is permitted, which was
introduced in 4.19. Rather than backport this considerable amount of
infrastructure just for KVM on arm, instead just remove the conditional
reschedule.

Cc: <stable@vger.kernel.org> # v4.4 only
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index e0267532bd4e..edd392fdc14b 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -300,14 +300,6 @@ static void unmap_range(struct kvm *kvm, pgd_t *pgdp,
 		next = kvm_pgd_addr_end(addr, end);
 		if (!pgd_none(*pgd))
 			unmap_puds(kvm, pgd, addr, next);
-		/*
-		 * If we are dealing with a large range in
-		 * stage2 table, release the kvm->mmu_lock
-		 * to prevent starvation and lockup detector
-		 * warnings.
-		 */
-		if (kvm && (next != end))
-			cond_resched_lock(&kvm->mmu_lock);
 	} while (pgd++, addr = next, addr != end);
 }
 
-- 
2.28.0.297.g1956fa8f8d-goog

