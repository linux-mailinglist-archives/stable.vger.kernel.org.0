Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007793CE1F8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346308AbhGSP2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347042AbhGSP0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08326601FD;
        Mon, 19 Jul 2021 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710811;
        bh=B9PwzVkDt+YbbI0grdaZ9+ed3WdmaMZd2+FoHBNeCZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEHhzAk6acjowPJaHpcpkLe4ZtjshYBQC29EK+8oKCMOfIarfi3HZDHB9bWW+ww/I
         1JFbynmvLtaDEDp8n4uvGyrKCZ9lP0irYpuFfH+blMjX2phQ3KSIfSUs38fkDGwVza
         OEbjcb15UPabQtEFKbfDGh/2EQtMh6I1vOF05uFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ohad Sharabi <osharabi@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 117/351] habanalabs: fix mask to obtain page offset
Date:   Mon, 19 Jul 2021 16:51:03 +0200
Message-Id: <20210719144948.353558703@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index b37189956b14..792d25b79ea6 100644
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



