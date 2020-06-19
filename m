Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A924E200D6A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390249AbgFSO5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390242AbgFSO5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:57:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D88218AC;
        Fri, 19 Jun 2020 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578651;
        bh=g7s+4E0FWjGLf3fU+sdwvbuqe4aR7mVLH5Y7cpF0E24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik3qZQ7VsvqK8MEWdQUDlYRWDBrVabl6PprqrTU11KK2EVlYVqtKaFbNR4rr5VVLS
         0JQEh5gMPZTt3KQMarBaeDxJqOxsJpiwEWHqlUefsZg28ia/l80+jTMP/kU3Fuqf5d
         Y0EUtQxkfsz8lURGtsZ4yOZ0B8d/lG/0F0aVkF7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/267] arm64: insn: Fix two bugs in encoding 32-bit logical immediates
Date:   Fri, 19 Jun 2020 16:31:29 +0200
Message-Id: <20200619141653.850412984@linuxfoundation.org>
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

From: Luke Nelson <lukenels@cs.washington.edu>

[ Upstream commit 579d1b3faa3735e781ff74aac0afd598515dbc63 ]

This patch fixes two issues present in the current function for encoding
arm64 logical immediates when using the 32-bit variants of instructions.

First, the code does not correctly reject an all-ones 32-bit immediate,
and returns an undefined instruction encoding.

Second, the code incorrectly rejects some 32-bit immediates that are
actually encodable as logical immediates. The root cause is that the code
uses a default mask of 64-bit all-ones, even for 32-bit immediates.
This causes an issue later on when the default mask is used to fill the
top bits of the immediate with ones, shown here:

  /*
   * Pattern: 0..01..10..01..1
   *
   * Fill the unused top bits with ones, and check if
   * the result is a valid immediate (all ones with a
   * contiguous ranges of zeroes).
   */
  imm |= ~mask;
  if (!range_of_ones(~imm))
          return AARCH64_BREAK_FAULT;

To see the problem, consider an immediate of the form 0..01..10..01..1,
where the upper 32 bits are zero, such as 0x80000001. The code checks
if ~(imm | ~mask) contains a range of ones: the incorrect mask yields
1..10..01..10..0, which fails the check; the correct mask yields
0..01..10..0, which succeeds.

The fix for both issues is to generate a correct mask based on the
instruction immediate size, and use the mask to check for all-ones,
all-zeroes, and values wider than the mask.

Currently, arch/arm64/kvm/va_layout.c is the only user of this function,
which uses 64-bit immediates and therefore won't trigger these bugs.

We tested the new code against llvm-mc with all 1,302 encodable 32-bit
logical immediates and all 5,334 encodable 64-bit logical immediates.

Fixes: ef3935eeebff ("arm64: insn: Add encoder for bitwise operations using literals")
Suggested-by: Will Deacon <will@kernel.org>
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200508181547.24783-2-luke.r.nels@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/insn.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 3e6229e30109..cd37edbdedcb 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -1490,16 +1490,10 @@ static u32 aarch64_encode_immediate(u64 imm,
 				    u32 insn)
 {
 	unsigned int immr, imms, n, ones, ror, esz, tmp;
-	u64 mask = ~0UL;
-
-	/* Can't encode full zeroes or full ones */
-	if (!imm || !~imm)
-		return AARCH64_BREAK_FAULT;
+	u64 mask;
 
 	switch (variant) {
 	case AARCH64_INSN_VARIANT_32BIT:
-		if (upper_32_bits(imm))
-			return AARCH64_BREAK_FAULT;
 		esz = 32;
 		break;
 	case AARCH64_INSN_VARIANT_64BIT:
@@ -1511,6 +1505,12 @@ static u32 aarch64_encode_immediate(u64 imm,
 		return AARCH64_BREAK_FAULT;
 	}
 
+	mask = GENMASK(esz - 1, 0);
+
+	/* Can't encode full zeroes, full ones, or value wider than the mask */
+	if (!imm || imm == mask || imm & ~mask)
+		return AARCH64_BREAK_FAULT;
+
 	/*
 	 * Inverse of Replicate(). Try to spot a repeating pattern
 	 * with a pow2 stride.
-- 
2.25.1



