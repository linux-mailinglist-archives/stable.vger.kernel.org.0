Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EEC3CE4C0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344332AbhGSPqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348286AbhGSPlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE3FF613D2;
        Mon, 19 Jul 2021 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711706;
        bh=YjDbZylTrxVoViU6jlMBklcY7OYNE36O/b0sSEiE9e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNHyUT3iL5/Nw4z9ruoHJM9okMNB5CMNmdsb/iiGkWk0bxpqv+DbDKyAtaVoz3l1d
         tj3IZKQn4+0qr6ljckVlVHLzs+8bc7lAAGaHAWQgADg3PuE3Elp8xRJ2jxRwW0chst
         QY0JeCjfSmxCBmHKfg43oz1U0qVUVVlfVo6+fm7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ohad Sharabi <osharabi@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 102/292] habanalabs: fix mask to obtain page offset
Date:   Mon, 19 Jul 2021 16:52:44 +0200
Message-Id: <20210719144945.854600196@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



