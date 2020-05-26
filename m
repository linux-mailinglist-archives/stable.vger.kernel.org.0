Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F217B1A9D95
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406206AbgDOLqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409232AbgDOLpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 926E020732;
        Wed, 15 Apr 2020 11:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951154;
        bh=dho+nqRB34fBEtZewJ7fhdKrcNy0/PfQqetIxeOIfwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfmHl+1o2lFe+zjwtX6TI7mfFpH8XXLVqYYONSrdNaP5Hh/ZJ93P/PXr47GNUAGc6
         D3EKF7aGPPj4xzzLDr1AdcVJehQJ5/alcshm2MrA5b+qg2fxXrte4ahs1tIa2X06cW
         9gnkfYbkNBB4PrYeKREPPqCrX3G0jy3bAY6/XZBE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 60/84] csky: Fixup cpu speculative execution to IO area
Date:   Wed, 15 Apr 2020 07:44:17 -0400
Message-Id: <20200415114442.14166-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit aefd9461d34a1b0a2acad0750c43216c1c27b9d4 ]

For the memory size ( > 512MB, < 1GB), the MSA setting is:

 - SSEG0: PHY_START        , PHY_START + 512MB
 - SSEG1: PHY_START + 512MB, PHY_START + 1GB

But the real memory is no more than 1GB, there is a gap between the
end size of memory and border of 1GB. CPU could speculatively
execute to that gap and if the gap of the bus couldn't respond to
the CPU request, then the crash will happen.

Now make the setting with:

 - SSEG0: PHY_START        , PHY_START + 512MB (no change)
 - SSEG1: Disabled (We use highmem to use the memory of 512MB~1GB)

We also deprecated zhole_szie[] settings, it's only used by arm
style CPUs. All memory gap should use Reserved setting of dts in
csky system.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/abiv1/inc/abi/entry.h |  5 +--
 arch/csky/abiv2/inc/abi/entry.h |  7 ++--
 arch/csky/kernel/head.S         |  5 +++
 arch/csky/kernel/setup.c        | 63 ++++++++-------------------------
 arch/csky/kernel/smp.c          |  3 ++
 5 files changed, 25 insertions(+), 58 deletions(-)

diff --git a/arch/csky/abiv1/inc/abi/entry.h b/arch/csky/abiv1/inc/abi/entry.h
index f35a9f3315ee6..5056ebb902d18 100644
--- a/arch/csky/abiv1/inc/abi/entry.h
+++ b/arch/csky/abiv1/inc/abi/entry.h
@@ -172,10 +172,7 @@
 	addi	r6, 0xe
 	cpwcr	r6, cpcr30
 
-	lsri	r6, 28
-	addi	r6, 2
-	lsli	r6, 28
-	addi	r6, 0xe
+	movi	r6, 0
 	cpwcr	r6, cpcr31
 .endm
 
diff --git a/arch/csky/abiv2/inc/abi/entry.h b/arch/csky/abiv2/inc/abi/entry.h
index 94a7a58765dff..111973c6c713f 100644
--- a/arch/csky/abiv2/inc/abi/entry.h
+++ b/arch/csky/abiv2/inc/abi/entry.h
@@ -230,11 +230,8 @@
 	addi	r6, 0x1ce
 	mtcr	r6, cr<30, 15> /* Set MSA0 */
 
-	lsri	r6, 28
-	addi	r6, 2
-	lsli	r6, 28
-	addi	r6, 0x1ce
-	mtcr	r6, cr<31, 15> /* Set MSA1 */
+	movi    r6, 0
+	mtcr	r6, cr<31, 15> /* Clr MSA1 */
 
 	/* enable MMU */
 	mfcr    r6, cr18
diff --git a/arch/csky/kernel/head.S b/arch/csky/kernel/head.S
index 61989f9241c02..17ed9d2504807 100644
--- a/arch/csky/kernel/head.S
+++ b/arch/csky/kernel/head.S
@@ -21,6 +21,11 @@ END(_start)
 ENTRY(_start_smp_secondary)
 	SETUP_MMU
 
+	/* copy msa1 from CPU0 */
+	lrw     r6, secondary_msa1
+	ld.w	r6, (r6, 0)
+	mtcr	r6, cr<31, 15>
+
 	/* set stack point */
 	lrw     r6, secondary_stack
 	ld.w	r6, (r6, 0)
diff --git a/arch/csky/kernel/setup.c b/arch/csky/kernel/setup.c
index 23ee604aafdb6..2c1e253abb74c 100644
--- a/arch/csky/kernel/setup.c
+++ b/arch/csky/kernel/setup.c
@@ -24,26 +24,9 @@ struct screen_info screen_info = {
 };
 #endif
 
-phys_addr_t __init_memblock memblock_end_of_REG0(void)
-{
-	return (memblock.memory.regions[0].base +
-		memblock.memory.regions[0].size);
-}
-
-phys_addr_t __init_memblock memblock_start_of_REG1(void)
-{
-	return memblock.memory.regions[1].base;
-}
-
-size_t __init_memblock memblock_size_of_REG1(void)
-{
-	return memblock.memory.regions[1].size;
-}
-
 static void __init csky_memblock_init(void)
 {
 	unsigned long zone_size[MAX_NR_ZONES];
-	unsigned long zhole_size[MAX_NR_ZONES];
 	signed long size;
 
 	memblock_reserve(__pa(_stext), _end - _stext);
@@ -57,54 +40,36 @@ static void __init csky_memblock_init(void)
 	memblock_dump_all();
 
 	memset(zone_size, 0, sizeof(zone_size));
-	memset(zhole_size, 0, sizeof(zhole_size));
 
 	min_low_pfn = PFN_UP(memblock_start_of_DRAM());
-	max_pfn	    = PFN_DOWN(memblock_end_of_DRAM());
-
-	max_low_pfn = PFN_UP(memblock_end_of_REG0());
-	if (max_low_pfn == 0)
-		max_low_pfn = max_pfn;
+	max_low_pfn = max_pfn = PFN_DOWN(memblock_end_of_DRAM());
 
 	size = max_pfn - min_low_pfn;
 
-	if (memblock.memory.cnt > 1) {
-		zone_size[ZONE_NORMAL]  =
-			PFN_DOWN(memblock_start_of_REG1()) - min_low_pfn;
-		zhole_size[ZONE_NORMAL] =
-			PFN_DOWN(memblock_start_of_REG1()) - max_low_pfn;
+	if (size <= PFN_DOWN(SSEG_SIZE - PHYS_OFFSET_OFFSET))
+		zone_size[ZONE_NORMAL] = size;
+	else if (size < PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET_OFFSET)) {
+		zone_size[ZONE_NORMAL] =
+				PFN_DOWN(SSEG_SIZE - PHYS_OFFSET_OFFSET);
+		max_low_pfn = min_low_pfn + zone_size[ZONE_NORMAL];
 	} else {
-		if (size <= PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET_OFFSET))
-			zone_size[ZONE_NORMAL] = max_pfn - min_low_pfn;
-		else {
-			zone_size[ZONE_NORMAL] =
+		zone_size[ZONE_NORMAL] =
 				PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET_OFFSET);
-			max_low_pfn = min_low_pfn + zone_size[ZONE_NORMAL];
-		}
+		max_low_pfn = min_low_pfn + zone_size[ZONE_NORMAL];
+		write_mmu_msa1(read_mmu_msa0() + SSEG_SIZE);
 	}
 
 #ifdef CONFIG_HIGHMEM
-	size = 0;
-	if (memblock.memory.cnt > 1) {
-		size = PFN_DOWN(memblock_size_of_REG1());
-		highstart_pfn = PFN_DOWN(memblock_start_of_REG1());
-	} else {
-		size = max_pfn - min_low_pfn -
-			PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET_OFFSET);
-		highstart_pfn =  min_low_pfn +
-			PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET_OFFSET);
-	}
-
-	if (size > 0)
-		zone_size[ZONE_HIGHMEM] = size;
+	zone_size[ZONE_HIGHMEM] = max_pfn - max_low_pfn;
 
-	highend_pfn = max_pfn;
+	highstart_pfn = max_low_pfn;
+	highend_pfn   = max_pfn;
 #endif
 	memblock_set_current_limit(PFN_PHYS(max_low_pfn));
 
 	dma_contiguous_reserve(0);
 
-	free_area_init_node(0, zone_size, min_low_pfn, zhole_size);
+	free_area_init_node(0, zone_size, min_low_pfn, NULL);
 }
 
 void __init setup_arch(char **cmdline_p)
diff --git a/arch/csky/kernel/smp.c b/arch/csky/kernel/smp.c
index 0bb0954d55709..de61feb4b6df2 100644
--- a/arch/csky/kernel/smp.c
+++ b/arch/csky/kernel/smp.c
@@ -156,6 +156,8 @@ volatile unsigned int secondary_hint;
 volatile unsigned int secondary_ccr;
 volatile unsigned int secondary_stack;
 
+unsigned long secondary_msa1;
+
 int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	unsigned long mask = 1 << cpu;
@@ -164,6 +166,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 		(unsigned int) task_stack_page(tidle) + THREAD_SIZE - 8;
 	secondary_hint = mfcr("cr31");
 	secondary_ccr  = mfcr("cr18");
+	secondary_msa1 = read_mmu_msa1();
 
 	/*
 	 * Because other CPUs are in reset status, we must flush data
-- 
2.20.1

