Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E9824FC8D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 13:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHXLaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 07:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgHXL37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 07:29:59 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DD752074D;
        Mon, 24 Aug 2020 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598268599;
        bh=RYREpAI28puv40pLrLSlY6MDo5We/pnypNIl1J6niFo=;
        h=From:To:Cc:Subject:Date:From;
        b=BJ9aHSXFWzl9fJVfAab7dQ6+PbFPxcGVDzJrzO/knml4i+uBeuVDWZnDRAN1sEw5g
         238gz4Iu4FQBfxZHkSVVVM2RuIRYf1QudUhqmMdHqeqmCC5KZyrxks3UF9/S1Z9KHM
         FSAkpW9xEcVwb8b/wY+gx53ZKoWxRQCy1Qx6/Dsg=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, james.morse@arm.com, pbonzini@redhat.com,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH stable-4.14.y backport] KVM: arm/arm64: Don't reschedule in unmap_stage2_range()
Date:   Mon, 24 Aug 2020 12:29:54 +0100
Message-Id: <20200824112954.24756-1-will@kernel.org>
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

Cc: <stable@vger.kernel.org> # v4.14 only
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 virt/kvm/arm/mmu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 3814cdad643a..7fe673248e98 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -307,12 +307,6 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 		next = stage2_pgd_addr_end(addr, end);
 		if (!stage2_pgd_none(*pgd))
 			unmap_stage2_puds(kvm, pgd, addr, next);
-		/*
-		 * If the range is too large, release the kvm->mmu_lock
-		 * to prevent starvation and lockup detector warnings.
-		 */
-		if (next != end)
-			cond_resched_lock(&kvm->mmu_lock);
 	} while (pgd++, addr = next, addr != end);
 }
 
-- 
2.28.0.297.g1956fa8f8d-goog

