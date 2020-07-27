Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861CE22FDA3
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 01:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgG0X26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 19:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgG0XYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 19:24:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D30C420A8B;
        Mon, 27 Jul 2020 23:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892259;
        bh=khXc0PSnnR6Npc3HWD8WDMk3xlt4pTF7I/aNk6Z3DTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6uXejaXggZwECBMGK8JLzzRf3bGkRzqMETJCtryktaAenOpiLaw+Cly1e1AegqGI
         SF1WuVTD13DjWICBMcOzGFH5Fm+hCpEkfmE0vyaFceviM/5GlSp6igp5WQT5HVUBqT
         xkC6iewMiBKN9YuQubjzDkME9I4dtOTm68VuN+uU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 25/25] riscv: Parse all memory blocks to remove unusable memory
Date:   Mon, 27 Jul 2020 19:23:45 -0400
Message-Id: <20200727232345.717432-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232345.717432-1-sashal@kernel.org>
References: <20200727232345.717432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

[ Upstream commit fa5a198359053c8e21dcc2b39c0e13871059bc9f ]

Currently, maximum physical memory allowed is equal to -PAGE_OFFSET.
That's why we remove any memory blocks spanning beyond that size. However,
it is done only for memblock containing linux kernel which will not work
if there are multiple memblocks.

Process all memory blocks to figure out how much memory needs to be removed
and remove at the end instead of updating the memblock list in place.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 753f2cdbeab8f..5e3dccf74ca92 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -125,26 +125,29 @@ void __init setup_bootmem(void)
 {
 	struct memblock_region *reg;
 	phys_addr_t mem_size = 0;
+	phys_addr_t total_mem = 0;
+	phys_addr_t mem_start, end = 0;
 	phys_addr_t vmlinux_end = __pa_symbol(&_end);
 	phys_addr_t vmlinux_start = __pa_symbol(&_start);
 
 	/* Find the memory region containing the kernel */
 	for_each_memblock(memory, reg) {
-		phys_addr_t end = reg->base + reg->size;
-
-		if (reg->base <= vmlinux_start && vmlinux_end <= end) {
-			mem_size = min(reg->size, (phys_addr_t)-PAGE_OFFSET);
-
-			/*
-			 * Remove memblock from the end of usable area to the
-			 * end of region
-			 */
-			if (reg->base + mem_size < end)
-				memblock_remove(reg->base + mem_size,
-						end - reg->base - mem_size);
-		}
+		end = reg->base + reg->size;
+		if (!total_mem)
+			mem_start = reg->base;
+		if (reg->base <= vmlinux_start && vmlinux_end <= end)
+			BUG_ON(reg->size == 0);
+		total_mem = total_mem + reg->size;
 	}
-	BUG_ON(mem_size == 0);
+
+	/*
+	 * Remove memblock from the end of usable area to the
+	 * end of region
+	 */
+	mem_size = min(total_mem, (phys_addr_t)-PAGE_OFFSET);
+	if (mem_start + mem_size < end)
+		memblock_remove(mem_start + mem_size,
+				end - mem_start - mem_size);
 
 	/* Reserve from the start of the kernel to the end of the kernel */
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
-- 
2.25.1

