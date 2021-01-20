Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA30A2FC8FE
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbhATC3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbhATB2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC6D2311C;
        Wed, 20 Jan 2021 01:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106021;
        bh=SyhzL3wKjvVs6HHrpK4LfBtmC+2xOrb/9aBifmqgYOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gySbF9SxHMTVguUIhx8cjOqh6hfzutykQSuSb+shHhWy378vLPOjCR1BdStHKE33+
         84N0mIIn3qE7zQUlNltwQpn/KY3VCdFF7e7EpMHVVXIEBOWUzkRl/g3JYxQTXMuKKh
         ehx4d0VgPh+EzEh2tISRaWAuG0KqDed6dR5QchGvk1GnleJgAUtKuq5AUXGeKzFnwi
         JGyfYBXqSzJxFGP56SWsK0Fyul8wt618iUoERPZV7IB7H3bSDL6JZxh5WWO5aPQA4O
         xfZk35stJp7nIQLazfbJ5S4tgnH2TmMtkzHmD+ehuK0TlRTOUf/W5uaItsv5iQCMT9
         XdxuxobOAq4FQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 44/45] RISC-V: Set current memblock limit
Date:   Tue, 19 Jan 2021 20:26:01 -0500
Message-Id: <20210120012602.769683-44-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

[ Upstream commit abb8e86b269604e906a6a4af7a09f04b72dbb862 ]

Currently, linux kernel can not use last 4k bytes of addressable space
because IS_ERR_VALUE macro treats those as an error. This will be an issue
for RV32 as any memblock allocator potentially allocate chunk of memory
from the end of DRAM (2GB) leading bad address error even though the
address was technically valid.

Fix this issue by limiting the memblock if available memory spans the
entire address space.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e4133c20744ce..608082fb9a6c6 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -155,9 +155,10 @@ static void __init setup_initrd(void)
 void __init setup_bootmem(void)
 {
 	phys_addr_t mem_start = 0;
-	phys_addr_t start, end = 0;
+	phys_addr_t start, dram_end, end = 0;
 	phys_addr_t vmlinux_end = __pa_symbol(&_end);
 	phys_addr_t vmlinux_start = __pa_symbol(&_start);
+	phys_addr_t max_mapped_addr = __pa(~(ulong)0);
 	u64 i;
 
 	/* Find the memory region containing the kernel */
@@ -179,7 +180,18 @@ void __init setup_bootmem(void)
 	/* Reserve from the start of the kernel to the end of the kernel */
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
-	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	dram_end = memblock_end_of_DRAM();
+
+	/*
+	 * memblock allocator is not aware of the fact that last 4K bytes of
+	 * the addressable memory can not be mapped because of IS_ERR_VALUE
+	 * macro. Make sure that last 4k bytes are not usable by memblock
+	 * if end of dram is equal to maximum addressable memory.
+	 */
+	if (max_mapped_addr == (dram_end - 1))
+		memblock_set_current_limit(max_mapped_addr - 4096);
+
+	max_pfn = PFN_DOWN(dram_end);
 	max_low_pfn = max_pfn;
 	set_max_mapnr(max_low_pfn);
 
-- 
2.27.0

