Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ABC22F03A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgG0OWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731961AbgG0OWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6517620775;
        Mon, 27 Jul 2020 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859767;
        bh=pw+zoWOo5qE3BJjvI2ogxid0E79/xtE7wob1dj8vH1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ne9o5BwHM4IoEbQakbkZqw7UU0eU6GOnVb8F+zSuRNtm9lgthwxs+7k9CgOkWjGNN
         j29lPAA1Dh9MQzi1GCPxc8GxlQEAr2UEONa5go17aCsdAE9yewz/80rioyA1Q9sgq8
         g3AFnvPrazWHn2q+1O81JUQeS/l0jj1xtw6p1PF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 098/179] RISC-V: Do not rely on initrd_start/end computed during early dt parsing
Date:   Mon, 27 Jul 2020 16:04:33 +0200
Message-Id: <20200727134937.430056754@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

[ Upstream commit 4400231c8acc7e513204c8470c6d796ba47dc169 ]

Currently, initrd_start/end are computed during early_init_dt_scan
but used during arch_setup. We will get the following panic if initrd is used
and CONFIG_DEBUG_VIRTUAL is turned on.

[    0.000000] ------------[ cut here ]------------
[    0.000000] kernel BUG at arch/riscv/mm/physaddr.c:33!
[    0.000000] Kernel BUG [#1]
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.8.0-rc4-00015-ged0b226fed02 #886
[    0.000000] epc: ffffffe0002058d2 ra : ffffffe0000053f0 sp : ffffffe001001f40
[    0.000000]  gp : ffffffe00106e250 tp : ffffffe001009d40 t0 : ffffffe00107ee28
[    0.000000]  t1 : 0000000000000000 t2 : ffffffe000a2e880 s0 : ffffffe001001f50
[    0.000000]  s1 : ffffffe0001383e8 a0 : ffffffe00c087e00 a1 : 0000000080200000
[    0.000000]  a2 : 00000000010bf000 a3 : ffffffe00106f3c8 a4 : ffffffe0010bf000
[    0.000000]  a5 : ffffffe000000000 a6 : 0000000000000006 a7 : 0000000000000001
[    0.000000]  s2 : ffffffe00106f068 s3 : ffffffe00106f070 s4 : 0000000080200000
[    0.000000]  s5 : 0000000082200000 s6 : 0000000000000000 s7 : 0000000000000000
[    0.000000]  s8 : 0000000080011010 s9 : 0000000080012700 s10: 0000000000000000
[    0.000000]  s11: 0000000000000000 t3 : 000000000001fe30 t4 : 000000000001fe30
[    0.000000]  t5 : 0000000000000000 t6 : ffffffe00107c471
[    0.000000] status: 0000000000000100 badaddr: 0000000000000000 cause: 0000000000000003
[    0.000000] random: get_random_bytes called from print_oops_end_marker+0x22/0x46 with crng_init=0

To avoid the error, initrd_start/end can be computed from phys_initrd_start/size
in setup itself. It also improves the initrd placement by aligning the start
and size with the page size.

Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fdc772f57edc3..81493cee0a167 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -94,19 +94,40 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 static void __init setup_initrd(void)
 {
+	phys_addr_t start;
 	unsigned long size;
 
-	if (initrd_start >= initrd_end) {
-		pr_info("initrd not found or empty");
+	/* Ignore the virtul address computed during device tree parsing */
+	initrd_start = initrd_end = 0;
+
+	if (!phys_initrd_size)
+		return;
+	/*
+	 * Round the memory region to page boundaries as per free_initrd_mem()
+	 * This allows us to detect whether the pages overlapping the initrd
+	 * are in use, but more importantly, reserves the entire set of pages
+	 * as we don't want these pages allocated for other purposes.
+	 */
+	start = round_down(phys_initrd_start, PAGE_SIZE);
+	size = phys_initrd_size + (phys_initrd_start - start);
+	size = round_up(size, PAGE_SIZE);
+
+	if (!memblock_is_region_memory(start, size)) {
+		pr_err("INITRD: 0x%08llx+0x%08lx is not a memory region",
+		       (u64)start, size);
 		goto disable;
 	}
-	if (__pa_symbol(initrd_end) > PFN_PHYS(max_low_pfn)) {
-		pr_err("initrd extends beyond end of memory");
+
+	if (memblock_is_region_reserved(start, size)) {
+		pr_err("INITRD: 0x%08llx+0x%08lx overlaps in-use memory region\n",
+		       (u64)start, size);
 		goto disable;
 	}
 
-	size = initrd_end - initrd_start;
-	memblock_reserve(__pa_symbol(initrd_start), size);
+	memblock_reserve(start, size);
+	/* Now convert initrd to virtual addresses */
+	initrd_start = (unsigned long)__va(phys_initrd_start);
+	initrd_end = initrd_start + phys_initrd_size;
 	initrd_below_start_ok = 1;
 
 	pr_info("Initial ramdisk at: 0x%p (%lu bytes)\n",
-- 
2.25.1



