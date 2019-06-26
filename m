Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0F6560E5
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFZDt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbfFZDnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:22 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0AE5205ED;
        Wed, 26 Jun 2019 03:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520601;
        bh=d1+WP5N9McYnrs0TI4Boiqy40Gwh4H9/yG46Qc8deqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGZxK0IOaJfeGa5/cSdz/f2gI0S2nEtobBSg0reAmrdxbY3h93libLk2Ok8znyK/i
         +LXSbnJHi4UfJPyM2aQ57BFzUX/RPY1wEoSD5eGeFqcThO3pAFj4n6NqY69FCTtAle
         cybtqBbF7Ag/82ONOUdLuvVG4UwKhSy3pq/K2CF8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 45/51] arm64: tlbflush: Ensure start/end of address range are aligned to stride
Date:   Tue, 25 Jun 2019 23:41:01 -0400
Message-Id: <20190626034117.23247-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit 01d57485fcdb9f9101a10a18e32d5f8b023cab86 ]

Since commit 3d65b6bbc01e ("arm64: tlbi: Set MAX_TLBI_OPS to
PTRS_PER_PTE"), we resort to per-ASID invalidation when attempting to
perform more than PTRS_PER_PTE invalidation instructions in a single
call to __flush_tlb_range(). Whilst this is beneficial, the mmu_gather
code does not ensure that the end address of the range is rounded-up
to the stride when freeing intermediate page tables in pXX_free_tlb(),
which defeats our range checking.

Align the bounds passed into __flush_tlb_range().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reported-by: Hanjun Guo <guohanjun@huawei.com>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/tlbflush.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 3a1870228946..dff8f9ea5754 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -195,6 +195,9 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	unsigned long asid = ASID(vma->vm_mm);
 	unsigned long addr;
 
+	start = round_down(start, stride);
+	end = round_up(end, stride);
+
 	if ((end - start) >= (MAX_TLBI_OPS * stride)) {
 		flush_tlb_mm(vma->vm_mm);
 		return;
-- 
2.20.1

