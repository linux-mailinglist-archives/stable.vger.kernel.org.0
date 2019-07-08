Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2762362
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390852AbfGHPe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390729AbfGHPex (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:34:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6729E2173E;
        Mon,  8 Jul 2019 15:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600092;
        bh=ZqQAp2f71kUMzWjXrmUXyEvoOcVtQiz/zU3rz+gLjXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd0gRF56gSHJBOb19XGU98/Z7WN7dL4BAGkpKYPv/oxuEn+OBTxxbAHSkHWvzLmxz
         Jo9tL+w+zkKmnykKuMK1Lvpiirmn5L6iyBaFtkY/wLCTZQHK6ptzMG+JxH5k3XXAgG
         Gi3m1ECbCZQqKpNM8HBNIItr+o2l7VvCdowUAGks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 49/96] arm64: tlbflush: Ensure start/end of address range are aligned to stride
Date:   Mon,  8 Jul 2019 17:13:21 +0200
Message-Id: <20190708150529.164511039@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



