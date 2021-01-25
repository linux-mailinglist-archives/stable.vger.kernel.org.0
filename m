Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34D4304AB9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbhAZE6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730863AbhAYSuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ECDA22B3F;
        Mon, 25 Jan 2021 18:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600586;
        bh=IrDWy5ojDmRIZePrgpvvPS9G4CZwVRqYK/yx2XOA914=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tor+xjHCbmEq5uqH/b8QhOUNj1q6P6Q3KThAy13rP7GKG5AWwQ374iwzq0u8tiGIw
         kVza9G85myzYeab0gKEo1R9ShhkKoDWghZzPwtX2unprKQ42cwfZ2BBTy8j9asTBVt
         oBq3z5wYDJbhNlua4GQ1Zr/jrqfScAaMnwwXIDKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/199] RISC-V: Set current memblock limit
Date:   Mon, 25 Jan 2021 19:38:15 +0100
Message-Id: <20210125183219.349363043@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -155,9 +155,10 @@ disable:
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



