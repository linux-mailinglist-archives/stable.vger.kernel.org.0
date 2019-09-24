Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BEDBCD29
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390591AbfIXQns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387852AbfIXQnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:43:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2461E20872;
        Tue, 24 Sep 2019 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343426;
        bh=8uA5QBwAqm2CzepT+jpEdoZcNv5X0Qm3rEJA+z5W8co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiiN0YqN4vkVKXMDVPyKSTZw5H2UHbww/jCuRXCo75KouEXYzWoDTfioDBj9D2mV/
         gIvuaBEKlcYhoUk1KPaxxnfP9Venm7RpYM2NOd3lCtk6KSKWBuu8QsiJjwQ8gwud5J
         WWjg0BM6MKAC+5yJCrIUCW7ak3vv9eY4OP74zq40=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.3 46/87] powerpc/64s/radix: Remove redundant pfn_pte bitop, add VM_BUG_ON
Date:   Tue, 24 Sep 2019 12:41:02 -0400
Message-Id: <20190924164144.25591-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 6bb25170d7a44ef0ed9677814600f0785e7421d1 ]

pfn_pte is never given a pte above the addressable physical memory
limit, so the masking is redundant. In case of a software bug, it
is not obviously better to silently truncate the pfn than to corrupt
the pte (either one will result in memory corruption or crashes),
so there is no reason to add this to the fast path.

Add VM_BUG_ON to catch cases where the pfn is invalid. These would
catch the create_section_mapping bug fixed by a previous commit.

  [16885.256466] ------------[ cut here ]------------
  [16885.256492] kernel BUG at arch/powerpc/include/asm/book3s/64/pgtable.h:612!
  cpu 0x0: Vector: 700 (Program Check) at [c0000000ee0a36d0]
      pc: c000000000080738: __map_kernel_page+0x248/0x6f0
      lr: c000000000080ac0: __map_kernel_page+0x5d0/0x6f0
      sp: c0000000ee0a3960
     msr: 9000000000029033
    current = 0xc0000000ec63b400
    paca    = 0xc0000000017f0000   irqmask: 0x03   irq_happened: 0x01
      pid   = 85, comm = sh
  kernel BUG at arch/powerpc/include/asm/book3s/64/pgtable.h:612!
  Linux version 5.3.0-rc1-00001-g0fe93e5f3394
  enter ? for help
  [c0000000ee0a3a00] c000000000d37378 create_physical_mapping+0x260/0x360
  [c0000000ee0a3b10] c000000000d370bc create_section_mapping+0x1c/0x3c
  [c0000000ee0a3b30] c000000000071f54 arch_add_memory+0x74/0x130

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190724084638.24982-5-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 8308f32e97823..8e47fb85dfa6b 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -608,8 +608,10 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
  */
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot)
 {
-	return __pte((((pte_basic_t)(pfn) << PAGE_SHIFT) & PTE_RPN_MASK) |
-		     pgprot_val(pgprot));
+	VM_BUG_ON(pfn >> (64 - PAGE_SHIFT));
+	VM_BUG_ON((pfn << PAGE_SHIFT) & ~PTE_RPN_MASK);
+
+	return __pte(((pte_basic_t)pfn << PAGE_SHIFT) | pgprot_val(pgprot));
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
-- 
2.20.1

