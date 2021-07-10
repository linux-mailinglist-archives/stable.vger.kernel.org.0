Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EDC3C2E68
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhGJC1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhGJC0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46D6613FE;
        Sat, 10 Jul 2021 02:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883826;
        bh=YjDbZylTrxVoViU6jlMBklcY7OYNE36O/b0sSEiE9e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvI+2p7pCPQyuZELXSf+81wlEo30FrNiFupzs8ssdzf0sMXpntPflN8mGjXcnMuXc
         blKhx+k9jdTgqV5Qj+YrFJbVoe1e9Qd4BHjO+o0s8jrAGd60MgLiDODxIudCtwgTZo
         R4m6oLxBVLO8JUEmlKo7v3zkV3GDW/FY3vn7qrQ5GaEWvqQS5/C3Pv0KbZZ47Mini+
         IHZS/VRD7SvDHkpRy2llFCeJ18siIqnRjuiQF43njmrhII0+EkEudtKUB/QSP8BMJl
         CEHo9cmRIKhAZfm5hrOEGwdfht+IkkCKdWI7+o8W+zudCdrYySKKAyBKIfzwQUhge0
         UrvzzL9GykGlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ohad Sharabi <osharabi@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 074/104] habanalabs: fix mask to obtain page offset
Date:   Fri,  9 Jul 2021 22:21:26 -0400
Message-Id: <20210710022156.3168825-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ohad Sharabi <osharabi@habana.ai>

[ Upstream commit 0f37510ca34848718db1003479bb4671e8f3c112 ]

When converting virtual address to physical we need to add correct
offset to the physical page.

For this we need to use mask that include ALL bits of page offset.

Signed-off-by: Ohad Sharabi <osharabi@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/mmu/mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/common/mmu/mmu.c b/drivers/misc/habanalabs/common/mmu/mmu.c
index 93c9e5f587e1..86dfa7c41ee7 100644
--- a/drivers/misc/habanalabs/common/mmu/mmu.c
+++ b/drivers/misc/habanalabs/common/mmu/mmu.c
@@ -501,12 +501,20 @@ static void hl_mmu_pa_page_with_offset(struct hl_ctx *ctx, u64 virt_addr,
 
 	if ((hops->range_type == HL_VA_RANGE_TYPE_DRAM) &&
 			!is_power_of_2(prop->dram_page_size)) {
-		u32 bit;
+		unsigned long dram_page_size = prop->dram_page_size;
 		u64 page_offset_mask;
 		u64 phys_addr_mask;
+		u32 bit;
 
-		bit = __ffs64((u64)prop->dram_page_size);
-		page_offset_mask = ((1ull << bit) - 1);
+		/*
+		 * find last set bit in page_size to cover all bits of page
+		 * offset. note that 1 has to be added to bit index.
+		 * note that the internal ulong variable is used to avoid
+		 * alignment issue.
+		 */
+		bit = find_last_bit(&dram_page_size,
+					sizeof(dram_page_size) * BITS_PER_BYTE) + 1;
+		page_offset_mask = (BIT_ULL(bit) - 1);
 		phys_addr_mask = ~page_offset_mask;
 		*phys_addr = (tmp_phys_addr & phys_addr_mask) |
 				(virt_addr & page_offset_mask);
-- 
2.30.2

