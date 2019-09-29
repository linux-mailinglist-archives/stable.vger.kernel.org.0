Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A416EC17B8
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfI2RfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbfI2RfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:35:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49AA421906;
        Sun, 29 Sep 2019 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778504;
        bh=1gGCjJia8yEAWiHCMurLorhELpMT7PCKhoCa6fsupq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2/h8/9D2aZJfVXl6sAannU0ORmuFbsgbyRtxBGrxOYUP0TmFsSfXIJupWYSDAo6Q
         6mf5IYwEpzAnqOhjzy39HiUs81MzBw6fI7Oy8wx49aNyVFCGqyJvsYbEvjkZ/hFbm5
         XAphVJ7pmv8vTCwp8nGejZbQD6M8dCTUbSE7ITdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Rapoport <mike.rapoport@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 22/33] ARM: 8903/1: ensure that usable memory in bank 0 starts from a PMD-aligned address
Date:   Sun, 29 Sep 2019 13:34:10 -0400
Message-Id: <20190929173424.9361-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173424.9361-1-sashal@kernel.org>
References: <20190929173424.9361-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <mike.rapoport@gmail.com>

[ Upstream commit 00d2ec1e6bd82c0538e6dd3e4a4040de93ba4fef ]

The calculation of memblock_limit in adjust_lowmem_bounds() assumes that
bank 0 starts from a PMD-aligned address. However, the beginning of the
first bank may be NOMAP memory and the start of usable memory
will be not aligned to PMD boundary. In such case the memblock_limit will
be set to the end of the NOMAP region, which will prevent any memblock
allocations.

Mark the region between the end of the NOMAP area and the next PMD-aligned
address as NOMAP as well, so that the usable memory will start at
PMD-aligned address.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/mmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e46a6a446cdd2..70e560cf8ca03 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1175,6 +1175,22 @@ void __init adjust_lowmem_bounds(void)
 	 */
 	vmalloc_limit = (u64)(uintptr_t)vmalloc_min - PAGE_OFFSET + PHYS_OFFSET;
 
+	/*
+	 * The first usable region must be PMD aligned. Mark its start
+	 * as MEMBLOCK_NOMAP if it isn't
+	 */
+	for_each_memblock(memory, reg) {
+		if (!memblock_is_nomap(reg)) {
+			if (!IS_ALIGNED(reg->base, PMD_SIZE)) {
+				phys_addr_t len;
+
+				len = round_up(reg->base, PMD_SIZE) - reg->base;
+				memblock_mark_nomap(reg->base, len);
+			}
+			break;
+		}
+	}
+
 	for_each_memblock(memory, reg) {
 		phys_addr_t block_start = reg->base;
 		phys_addr_t block_end = reg->base + reg->size;
-- 
2.20.1

