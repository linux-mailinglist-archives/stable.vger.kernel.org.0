Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A0C24FC87
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 13:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHXL3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 07:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgHXL3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 07:29:47 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E29832074D;
        Mon, 24 Aug 2020 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598268587;
        bh=sr8h31oVBhwwGNGUqRzUcOWMUXXTUZq5SuhMZEvleDY=;
        h=From:To:Cc:Subject:Date:From;
        b=Vhe9H5ItJFq4txVxAATthQYWtFxl7wVew7GJzCSo7txaXfYOCspXg37tLlUkBVJqP
         bquOLg04GMRUw1fQ/8kTuB3FJlYilZqTn4c/JKqnpiXK3XaYQy3dYoFancfnvwvE2i
         70dEDtAj7ffQGABRucc0m2J9Zd6IdqRlQn9LxbTg=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, james.morse@arm.com, pbonzini@redhat.com,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH stable-4.9.y backport] KVM: arm/arm64: Don't reschedule in unmap_stage2_range()
Date:   Mon, 24 Aug 2020 12:29:40 +0100
Message-Id: <20200824112940.24706-1-will@kernel.org>
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

Cc: <stable@vger.kernel.org> # v4.9 only
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm/kvm/mmu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index bb0d5e21d60b..b5ce1e81f945 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -298,12 +298,6 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
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

