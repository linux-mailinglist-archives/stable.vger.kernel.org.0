Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E751C16E6
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfI2Rdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730185AbfI2Rdu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:33:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DA22196E;
        Sun, 29 Sep 2019 17:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778429;
        bh=mEX6m77D5xfNKL3qk0Z81bvRU50ZjzXX9ZeCSI33gmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFAT/Oe6JRuYfY9ADkfdr/sQQ4hN/SX7AziXteBd3tQAlO8X6UmVz78HYlTpK49LR
         DYjMEKu3OfyF59cbWfHIKU6FPGKPfItehZdiK3R2sxwsg7+5LK96x0vo1D9HJ97p+y
         gviMbVwbXdD2p35ed+NvUTWswG57cey6I28Y+SNo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Rapoport <mike.rapoport@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 31/42] ARM: 8903/1: ensure that usable memory in bank 0 starts from a PMD-aligned address
Date:   Sun, 29 Sep 2019 13:32:30 -0400
Message-Id: <20190929173244.8918-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173244.8918-1-sashal@kernel.org>
References: <20190929173244.8918-1-sashal@kernel.org>
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
index 1aa2586fa597b..13233c7917fe7 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1177,6 +1177,22 @@ void __init adjust_lowmem_bounds(void)
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

