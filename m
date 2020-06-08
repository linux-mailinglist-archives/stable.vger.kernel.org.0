Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2B61F3064
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgFHXIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbgFHXIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6A8A2089D;
        Mon,  8 Jun 2020 23:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657718;
        bh=0DE62OxpKPeTWcX/ynCTAsqhjaPry1kDxHTLBwogLd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7XKNKCZ7Oc2FXmlbg1rhnV7Agk45EMGsFGGDJO519jx5eKu/wz0B+LEOFnBo/FxA
         tMmN23c9NJRnEujLBFuN9ktCWvjCiuqKttj4iVdZi9vjnYY+TMnrBG6qIOTF08n1KV
         BptiVVBv9DY05RGX6+76ACm032BMb2jP3fI/yUZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Juxin Gao <gaojuxin@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 112/274] MIPS: Make sparse_init() using top-down allocation
Date:   Mon,  8 Jun 2020 19:03:25 -0400
Message-Id: <20200608230607.3361041-112-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 269b3a9ac538c4ae87f84be640b9fa89914a2489 ]

In the current code, if CONFIG_SWIOTLB is set, when failed to get IO TLB
memory from the low pages by plat_swiotlb_setup(), it may lead to the boot
process failed with kernel panic.

(1) On the Loongson and SiByte platform
arch/mips/loongson64/dma.c
arch/mips/sibyte/common/dma.c
void __init plat_swiotlb_setup(void)
{
	swiotlb_init(1);
}

kernel/dma/swiotlb.c
void  __init
swiotlb_init(int verbose)
{
...
	vstart = memblock_alloc_low(PAGE_ALIGN(bytes), PAGE_SIZE);
	if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose))
		return;
...
	pr_warn("Cannot allocate buffer");
	no_iotlb_memory = true;
}

phys_addr_t swiotlb_tbl_map_single()
{
...
	if (no_iotlb_memory)
		panic("Can not allocate SWIOTLB buffer earlier ...");
...
}

(2) On the Cavium OCTEON platform
arch/mips/cavium-octeon/dma-octeon.c
void __init plat_swiotlb_setup(void)
{
...
	octeon_swiotlb = memblock_alloc_low(swiotlbsize, PAGE_SIZE);
	if (!octeon_swiotlb)
		panic("%s: Failed to allocate %zu bytes align=%lx\n",
		      __func__, swiotlbsize, PAGE_SIZE);
...
}

Because IO_TLB_DEFAULT_SIZE is 64M, if the rest size of low memory is less
than 64M when call plat_swiotlb_setup(), we can easily reproduce the panic
case.

In order to reduce the possibility of kernel panic when failed to get IO
TLB memory under CONFIG_SWIOTLB, it is better to allocate low memory as
small as possible before plat_swiotlb_setup(), so make sparse_init() using
top-down allocation.

Reported-by: Juxin Gao <gaojuxin@loongson.cn>
Co-developed-by: Juxin Gao <gaojuxin@loongson.cn>
Signed-off-by: Juxin Gao <gaojuxin@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/setup.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 10bef8f78e7c..573509e0f2d4 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -702,7 +702,17 @@ static void __init arch_mem_init(char **cmdline_p)
 		memblock_reserve(crashk_res.start, resource_size(&crashk_res));
 #endif
 	device_tree_init();
+
+	/*
+	 * In order to reduce the possibility of kernel panic when failed to
+	 * get IO TLB memory under CONFIG_SWIOTLB, it is better to allocate
+	 * low memory as small as possible before plat_swiotlb_setup(), so
+	 * make sparse_init() using top-down allocation.
+	 */
+	memblock_set_bottom_up(false);
 	sparse_init();
+	memblock_set_bottom_up(true);
+
 	plat_swiotlb_setup();
 
 	dma_contiguous_reserve(PFN_PHYS(max_low_pfn));
-- 
2.25.1

