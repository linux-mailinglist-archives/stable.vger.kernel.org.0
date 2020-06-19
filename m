Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43451200E71
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391583AbgFSPHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391626AbgFSPHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:07:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329D421941;
        Fri, 19 Jun 2020 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579263;
        bh=Z5EKxfv+Va+d0E6RTU9IoyZ/sjv+aNvaJmc9GxB6eh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc1zO/nXIcrnNgGK+ckghb9VFgHheYobebKMkUjNmjkXfKTzYONjegSV+u6BsZkgm
         xdtijzstbVrBkFllPe6U5mLc243tl1WqiehgH1FetJaEc5HSqOYI5tzVho+ckKgvmZ
         pgfIN0EnxCfc6eBNVySd+Ba0diA2WxumpmvODp7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juxin Gao <gaojuxin@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/261] MIPS: Make sparse_init() using top-down allocation
Date:   Fri, 19 Jun 2020 16:31:21 +0200
Message-Id: <20200619141653.251209964@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5eec13b8d222..7b06e6ee6817 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -653,7 +653,17 @@ static void __init arch_mem_init(char **cmdline_p)
 				 crashk_res.end - crashk_res.start + 1);
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



